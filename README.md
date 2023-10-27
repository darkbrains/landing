# Blackdocs

[![GitHub Repo](https://img.shields.io/badge/GitHub-Repo-blue)](https://github.com/Blackdocs-Cloud/blackdocs-cloud)
[![GitHub](https://img.shields.io/badge/GitHub-Releases-green)](https://github.com/Blackdocs-Cloud/blackdocs-cloud/releases)
![GitHub Workflow Status](https://github.com/Blackdocs-Cloud/blackdocs-cloud/actions/workflows/test.yaml/badge.svg?branch=main)

## Project Description

This project is a **Node.js** web application containerized using Docker. It provides a basic web server that serves dynamic content using the **EJS** templating engine. The application includes logging capabilities and handles routes for rendering webpages in multiple languages.

### Dockerfile

The Dockerfile (`Dockerfile`) contains instructions for building the Docker image for this **Node.js** application. It defines the following steps:

1. Base Image: It starts with the latest **Node.js** image as the base image.

2. Working Directory: It sets up a working directory within the container at `/app`.

3. Application Files: It copies the contents of the `/bin/app` directory into the container's working directory. This includes your **Node.js** application code.

4. Dependency Installation: It runs `yarn install` to install the project's dependencies.

5. Default Command: It specifies the default command to start the **Node.js** application, which is `yarn main`.

6. Port Exposure: It exposes port 8887 for external access.

## Installation

Comming soon.

### main.js Files

- `main.js`: This is the main server script (`main.js`) responsible for handling HTTP requests and defining route handlers. It uses the Express.js framework to set up the server, handle routing, and serve dynamic content using EJS templates. Key features include:
  
  - Middleware: It sets up middleware for logging requests using the Winston library.
  
  - Error Handling: It includes error handling middleware to log and handle errors gracefully.
  
  - Routing: It defines various routes for rendering webpages in different languages and redirects for specific URLs.
  
  - Logging: It configures the Winston logger to log request information.

### Views (EJS Templates)

The `/bin/app/views/` directory contains EJS templates for rendering webpages. These templates are used to generate dynamic **HTML** content based on the requested URL.

### Public Assets

The `/bin/app/public/static/` directory contains static assets such as **CSS** and **JavaScript**files that are used to style and enhance the webpages.

## License

This project is licensed under the *Apache 2.0* License. See the [LICENSE](LICENSE) file for more details.
