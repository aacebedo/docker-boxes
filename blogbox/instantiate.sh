#!/usr/bin/env sh

export BASE_IMAGE="alpine:latest"
export DOCKERIZE_ARCH="amd64"
export DOMAIN="domain.com"
export GHOST_DATADIR=""
export BLOGBOX_NETWORK="blogbox_network"

dockerize -force -template ./ghost/Dockerfile.tmpl:./ghost/Dockerfile