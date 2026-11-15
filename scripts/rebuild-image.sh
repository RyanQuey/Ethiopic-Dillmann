#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PROJECT_DIR=$SCRIPT_DIR/..

cd $PROJECT_DIR

docker stop exist && docker rm exist && docker rmi ethiopic-dillmann-existdb:latest && docker-compose up -d
docker logs -f exist 
