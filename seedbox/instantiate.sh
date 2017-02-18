#!/usr/bin/env sh

export ARCH="amd64"

export COUCHPOTATO_VERSION="3.0.1"
export SICKRAGE_VERSION="2017.02.15-1"
export NZBGET_VERSION="16.4"

export NZBSDIR="/tmp/medias"
export MOVIESDIR="/tmp/medias"
export TORRENTSDIR="/tmp/medias"
export TVSHOWSDIR="/tmp/medias"
export DOMAIN="example.com"
export SEEDBOX_NETWORK="traefik_network"

rocker build -var ARCH=amd64 \
           -var COUCHPOTATO_VERSION=${COUCHPOTATO_VERSION} \
           -var IS_LATEST=true \
           -f ./couchpotato/Rockerfile ./couchpotato
rocker build -var ARCH=amd64 \
           -var NZBGET_VERSION=${NZBGET_VERSION} \
           -var IS_LATEST=true \
           -f ./nzbget/Rockerfile ./nzbget
rocker build -var ARCH=amd64 \
           -var SICKRAGE_VERSION=${SICKRAGE_VERSION} \
            -var IS_LATEST=true \
            -f ./sickrage/Rockerfile ./sickrage
rocker build -var ARCH=amd64 \
             -f ./transmission/Rockerfile ./transmission
