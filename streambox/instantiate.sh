#!/usr/bin/env bash

export ARCH="amd64"
export PLEX_VERSION="1.4.1.3362-77c6a4f80"
export PLEX_HOSTNAME="plex.example.com"
export PLEX_MEDIADIR="/tmp/plex/media"
export PLEX_DATADIR="/tmp/plex/data"

export STREAMBOX_NETWORK="traefik_network"

rocker build -var ARCH=amd64 \
           -var PLEX_VERSION=${PLEX_VERSION} \
           -var IS_LATEST=true \
           -f ./plex/Rockerfile ./plex
