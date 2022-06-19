#!/bin/bash

# Pull service images
echo "\n----------------- INIT PULL SERVICE IMAGES  ---------------------"
docker-compose pull
echo "----------------- FINISH PULL SERVICE IMAGES  ---------------------\n"

# build ubicor-api image and its dependencies
echo "\n----------------- INIT BUILD ubicor-api IMAGES ---------------------"
docker-compose build --no-cache ubicor-api
echo "----------------- FINISH BUILD ubicor-api IMAGES ---------------------\n"

# run previews built images
echo "\n----------------- INIT LAUNCH ubicor-api IMAGES ---------------------"
docker-compose up -d ubicor-api
echo "----------------- FINISH LAUNCH ubicor-api IMAGES ---------------------\n"

# build ubicor-frontend image
echo "\n----------------- INIT BUILD ubicor-frontend IMAGE ---------------------"
docker-compose build --no-cache ubicor-frontend
echo "----------------- FINISH BUILD ubicor-frontend IMAGE ---------------------\n"

# run ubicor-frontend image
echo "\n----------------- INIT LAUNCH ubicor-frontend IMAGES ---------------------"
docker-compose up -d ubicor-frontend
echo "----------------- FINISH LAUNCH ubicor-frontend IMAGES ---------------------\n"
