#!/bin/bash

if [ ! -x "$(command -v docker-compose)" ]; then
    echo "WARN: docker-compose doesn't exist, use alias for 'docker compose'"
    alias docker-compose='docker compose'
fi 

echo "\n----------------- INIT PULL SERVICE IMAGES  ---------------------"
docker-compose pull
echo "----------------- FINISH PULL SERVICE IMAGES  ---------------------\n"

echo "\n----------------- INIT LAUNCH database IMAGES ---------------------"
docker-compose up -d database
echo "----------------- FINISH LAUNCH database IMAGES ---------------------\n"

echo "\n----------------- INIT BUILD ubicor-api IMAGES ---------------------"
docker-compose build --no-cache ubicor-api
echo "----------------- FINISH BUILD ubicor-api IMAGES ---------------------\n"

echo "\n----------------- INIT LAUNCH ubicor-api IMAGES ---------------------"
docker-compose up -d ubicor-api
echo "----------------- FINISH LAUNCH ubicor-api IMAGES ---------------------\n"

echo "\n----------------- INIT BUILD ubicor-frontend IMAGE ---------------------"
docker-compose build --no-cache ubicor-frontend
echo "----------------- FINISH BUILD ubicor-frontend IMAGE ---------------------\n"

echo "\n----------------- INIT LAUNCH ubicor-frontend IMAGES ---------------------"
docker-compose up -d ubicor-frontend
echo "----------------- FINISH LAUNCH ubicor-frontend IMAGES ---------------------\n"
