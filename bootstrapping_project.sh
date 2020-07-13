#!/usr/bin/env bash

#script to create a new laravel project
docker run --rm -d --name phplaravel -v $(pwd):/usr/src/app pirpedro/laravel:1.0.1 && \
docker exec phplaravel composer create-project --prefer-dist laravel/laravel myapp && \
mv myapp/* . && \
docker stop phplaravel
