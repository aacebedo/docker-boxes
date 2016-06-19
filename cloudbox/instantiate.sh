#!/usr/bin/env sh

export BASE_IMAGE="ubuntu:latest"
export DOCKERIZE_ARCH="amd64"
export SEAFILE_HOSTNAME="seafile.example.com"
export SEAFILE_SERVERNAME="seafile"
export SEAFILE_ADMIN_EMAIL="root@example.com"
export SEAFILE_ADMIN_PASSWORD="password"
export SEAFILE_URL="https://bintray.com/artifact/download/seafile-org/seafile/seafile-server_5.1.3_x86-64.tar.gz"
export SEAFILE_PORT="80"
export SEAFILE_DATADIR="/tmp/seafile"
export CLOUDBOX_NETWORK="traefik_network"

dockerize -template ./seafile/Dockerfile.tmpl:./seafile/Dockerfile
