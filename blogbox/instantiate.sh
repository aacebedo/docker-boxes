#!/usr/bin/env sh

export BASE_IMAGE="alpine:latest"

export DOCKERIZE_ARCH="amd64"

export GHOST_VERSION="0.8.0"
export GHOST_HOSTNAME="blog.example.com"
export GHOST_DATADIR="/tmp/ghost"

export BLOGBOX_NETWORK="traefik_network"

dockerize -force -template ./ghost/Dockerfile.tmpl:./ghost/Dockerfile