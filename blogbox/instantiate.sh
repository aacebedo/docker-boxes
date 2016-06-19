#!/usr/bin/env sh

export BASE_IMAGE="alpine:latest"
export DOCKERIZE_ARCH="amd64"
export DOMAIN="example.com"
export GHOST_DATADIR="/tmp/ghost"
export BLOGBOX_NETWORK="traefik_network"

dockerize -force -template ./ghost/Dockerfile.tmpl:./ghost/Dockerfile