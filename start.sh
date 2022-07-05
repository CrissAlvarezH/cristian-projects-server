#!/bin/bash

environment=$1

[ -z $environment ] && environment="dev"
[ $environment != "dev" -a $environment != "prod" ] && "ERROR: invalid 'environment' value, must be 'dev' or 'prod'" && exit 2

if [ ! -x "$(command -v docker-compose)" ]; then
    echo "WARN: docker-compose doesn't exist, use alias for 'docker compose'"
    alias docker-compose='docker compose'
fi 

if [ $environment = "dev" ]; then

    echo "\n----------------- INIT PULL postgres AND traefik IMAGES  ---------------------"
    docker-compose pull database reverse-proxy
    echo "----------------- FINISH PULL postgres AND traefik IMAGES  ---------------------\n"

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

elif [ $environment = "prod" ]; then

    echo "\n----------------- INIT PULL SERVICE IMAGES  ---------------------"
    docker-compose pull
    echo "----------------- FINISH PULL SERVICE IMAGES  ---------------------\n"

    echo "\n----------------- INIT LAUNCH database IMAGES ---------------------"
    docker-compose -f docker-compose.yaml up -d database
    sleep 10  # wait for database is ready to accept connections
    echo "----------------- FINISH LAUNCH database IMAGES ---------------------\n"

    echo "\n----------------- INIT LAUNCH OTHER IMAGES ---------------------"
    docker-compose -f docker-compose.yaml up -d 
    echo "----------------- FINISH LAUNCH IMAGES ---------------------\n"

fi
