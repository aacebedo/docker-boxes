#!/usr/bin/env sh

export BASE_IMAGE="ubuntu:latest"
export DOCKERIZE_ARCH="amd64"
export SEAFILE_DOMAIN="acebedo.fr"
export SEAFILE_SERVERNAME="seafile"
export SEAFILE_ADMIN_EMAIL="alexandre@acebedo.fr"
export SEAFILE_ADMIN_PASSWORD="password"

export SEAFILE_DATADIR="/tmp/seafile"
export CLOUDBOX_NETWORK="traefik_network"

#dockerize -template ./seafile/Dockerfile.tmpl:./seafile/Dockerfile
