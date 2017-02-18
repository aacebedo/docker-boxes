#!/usr/bin/env sh

export ARCH="amd64"
export GHOST_VERSION="1.0.0-alpha.12"
export GHOST_HOSTNAME="http://blog.example.com"
export GHOST_DATADIR="/mnt/data/ghost"

export BLOGBOX_NETWORK="traefik_network"

rocker build -var ARCH=${ARCH} \
             -var GHOST_VERSION=${GHOST_VERSION} \
             -var IS_LATEST=true \
             -f ./ghost/Rockerfile ./ghost
