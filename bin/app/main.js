const express = require('express');
const app = express();
const PORT = 8887;
const METRICS_PORT = 5887;
const HOST = 'localhost';
const winston = require('winston');
const client = require('prom-client');
const metricsApp = express();
const collectDefaultMetrics = client.collectDefaultMetrics;

collectDefaultMetrics({ timeout: 5000 });

app.set('view engine', 'ejs');
app.use(express.static(__dirname + '/public'));


app.use((req, res, next) => {
    if (req.originalUrl.startsWith('/static/')) {
      next();
    } else {
      winston.info({
        message: 'Request received',
        method: req.method,
        url: req.originalUrl,
        ip: req.ip,
      });
      next();
    }
});


const customFormat = winston.format.combine(
    winston.format.timestamp(),
    winston.format.printf(({ timestamp, level, message, method, url, ip }) => {
      return JSON.stringify({ timestamp, level, message, method, url, ip });
  })
);

 
winston.configure({
    level: 'debug',
    format: customFormat,
    transports: [
        new winston.transports.Console(),
    ],
});
  

app.use((err, req, res, next) => {
    winston.error({
        message: 'Error occurred',
        error: err.message,
        stack: err.stack,
    });
    if (res.statusCode === 500) {
        return res.status(500).render('server-error');
    }
    res.status(500).json({ error: 'Internal Server Error' });
});


app.get('/api/healthz', (req, res) => {
    winston.info('Processing request at /api/healthz');
    res.render('healthz');
});


app.get('/', (req, res) => {
  winston.info('Processing request at /');
  res.render('index');
});


metricsApp.get('/metrics', async (req, res) => {
  try {
    res.set('Content-Type', client.register.contentType);
    winston.info('Processing request at /metrics');
    res.end(await client.register.metrics());
  } catch (err) {
    res.status(500).end(err);
  }
});


app.use((req, res) => {
    winston.warn('Request for undefined route', { url: req.originalUrl, ip: req.ip });
    res.status(404).render('not-found');
});


metricsApp.use((req, res) => {
  winston.warn('Request for undefined route', { url: req.originalUrl, ip: req.ip });
  res.status(404).render('not-found');
});


app.listen(PORT, () => {
  winston.info(`Server started: http://${HOST}:${PORT}`);
});

metricsApp.listen(METRICS_PORT, () => {
  winston.info(`Metrics server listening on port http://${HOST}:${METRICS_PORT}`);
});
