#!/bin/bash


# Start darkbrains-landing Docker container
docker network create actions --driver bridge

docker run --network actions --name darkbrains-landing-tests -p 8887:8887 \
  darkbrains/landing:local &

sleep 15


# Test /api/healthz endpoint
HTTP_STATUS_HEALTHZ=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8887/api/healthz -H "Content-Type: application/json")
if [ "$HTTP_STATUS_HEALTHZ" -eq 200 ]; then
  echo "/api/healthz $HTTP_STATUS_HEALTHZ OK" >> status_report.txt
else
  echo "/api/healthz $HTTP_STATUS_HEALTHZ Failed" >> status_report.txt
fi

sleep 5


# Test / endpoint
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8887/ -H "Content-Type: application/json")
if [ "$HTTP_STATUS" -eq 200 ]; then
  echo "/ $HTTP_STATUS OK" >> status_report.txt
else
  echo "/ $HTTP_STATUS Failed" >> status_report.txt
fi

sleep 5


# Test /empty
HTTP_STATUS_EMPTY=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8887/empty -H "Content-Type: application/json")
if [ "$HTTP_STATUS_EMPTY" -eq 404 ]; then
  echo "/empty $HTTP_STATUS_EMPTY OK" >> status_report.txt
else
  echo "/empty $HTTP_STATUS_EMPTY Failed" >> status_report.txt
fi

sleep 5


# Stop and remove the Docker containers
docker stop darkbrains-landing-tests
docker rm darkbrains-landing-tests


# Status Report
if grep -iwq "Failed" status_report.txt; then
  echo "Tests Failed"
  grep -iw "Failed" status_report.txt
  exit 1
else
  echo "Tests Passed"
  grep -iw "OK" status_report.txt
fi
