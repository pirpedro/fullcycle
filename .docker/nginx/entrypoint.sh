#!/bin/sh

dockerize -template /var/www/.docker/nginx/nginx.conf:/etc/nginx/conf.d/nginx.conf 
nginx -g "daemon off;"