#!/usr/bin/env sh

export BASE_IMAGE="alpine:latest"

export ARCH="amd64"
export GHOST_VERSION="0.11.3"
export GHOST_HOSTNAME="http://blog.example.com"
export GHOST_DATADIR="/mnt/data/ghost"

export BLOGBOX_NETWORK="traefik_network"

rocker build -var ARCH=${ARCH} -var GHOST_VERSION=${GHOST_VERSION} -var IS_LATEST=true -f ./ghost/Rockerfile ./ghost
