#!/usr/bin/env sh

export BASE_IMAGE="alpine:latest"
export DOCKERIZE_ARCH="amd64"
export DOMAIN="domain.com"
export SEAFILE_SERVERHOST="toto.toto.fr"
export SEAFILE_ADMIN_EMAIL="toto@toto.fr"
export SEAFILE_ADMIN_PASSWORD="toto"

export SEAFILE_DATADIR="/tmp/seafile"
export CLOUDBOX_NETWORK="cloudbox_network"

#dockerize -template ./seafile/Dockerfile.tmpl:./seafile/Dockerfile
