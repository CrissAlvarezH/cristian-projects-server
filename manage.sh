#!/bin/bash

action=$1

if [ $action = "start" ]; then

    [ ! -f acme.json ] && touch acme.json && chmod 600 acme.json && echo "\ncreate acme.json for tls certificates"
    [ ! -f traefik.log ] && touch traefik.log && echo "\ncreate traefik.log for error logs"

    echo "\nlaunch database"
    docker compose up -d database
    sleep 4  # wait for database is ready to accept connections

    echo "\nlaunch other services"
    docker compose up -d 

    echo "\nfinish start"

elif [ $action = "update" ]; then

    echo "\npull images"
    docker compose pull

    echo "\nrelaunch services"
    docker compose up --force-recreate -d 
    docker images prune

    echo "\nfinish update"

elif [ $action = "generate-env" ]; then

    echo "\ncreate .env-services from template"
    [ -d .env-services ] && rm -r .env-services && echo "delete .env-services"

    cp -r .env-services.example .env-services

    echo "\ngenerate secrets"
    dbuser=pguser-$(tr -dc A-Za-z0-9 </dev/urandom  | head -c 10 ; echo '')
    dbpass=$(tr -dc A-Za-z0-9 </dev/urandom  | head -c 30 ; echo '')
    secret=$(tr -dc A-Za-z0-9 </dev/urandom  | head -c 50 ; echo '')

    ubicor_root_user=ubicor-root-$(tr -dc A-Za-z0-9 </dev/urandom  | head -c 10 ; echo '')@email.com
    ubicor_root_pass=$(tr -dc A-Za-z0-9 </dev/urandom  | head -c 30 ; echo '')

    sed -i "s~__POSTGRES_USER__~$dbuser~g" .env-services/.backups.env
    sed -i "s~__POSTGRES_PASSWORD__~$dbpass~g" .env-services/.backups.env

    sed -i "s~__POSTGRES_USER__~$dbuser~g" .env-services/.database.env
    sed -i "s~__POSTGRES_PASSWORD__~$dbpass~g" .env-services/.database.env

    sed -i "s~__SECRET_KEY__~$secret~g" .env-services/.ubicor-api.env
    sed -i "s~__POSTGRES_USER__~$dbuser~g" .env-services/.ubicor-api.env
    sed -i "s~__POSTGRES_PASSWORD__~$dbpass~g" .env-services/.ubicor-api.env
    sed -i "s~__SUPER_USER_EMAIL__~$ubicor_root_user~g" .env-services/.ubicor-api.env
    sed -i "s~__SUPER_USER_PASSWORD__~$ubicor_root_pass~g" .env-services/.ubicor-api.env

    sed -i "s~__NEXTAUTH_SECRET__~$secret~g" .env-services/.ubicor-frontend.env

    echo "\nfinish reset env"

fi
