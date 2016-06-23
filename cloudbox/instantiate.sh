#!/usr/bin/env sh

export BASE_IMAGE="ubuntu:latest"
export DOCKERIZE_ARCH="amd64"
export SEAFILE_HOSTNAME="seafile.example.com"
export SEAFILE_SERVERNAME="seafile"
export SEAFILE_ADMIN_EMAIL="admin@example.com"
export SEAFILE_ADMIN_PASSWORD="password"
export SEAFILE_PROTOCOL="http"
#https://github.com/haiwen/seafile-rpi/releases/download/v${SEAFILE_VERSION}/seafile-server_stable_${SEAFILE_VERSION}_pi.tar.gz
export SEAFILE_URL="https://bintray.com/artifact/download/seafile-org/seafile/seafile-server_5.1.3_x86-64.tar.gz"
export SEAFILE_DATADIR="/tmp/seafile"
export CLOUDBOX_NETWORK="traefik_network"

dockerize -force -template ./seafile/Dockerfile.tmpl:./seafile/Dockerfile
