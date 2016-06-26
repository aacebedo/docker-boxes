#!/usr/bin/env sh

export BASE_IMAGE="alpine:latest"
export DOCKERIZE_ARCH="amd64"

export COUCHPOTATO_VERSION="3.0.1"
export SICKRAGE_VERSION="2016.05.20-1"
export NZBGET_VERSION="16.4"

export NZBSDIR="/tmp/medias"
export MOVIESDIR="/tmp/medias"
export TORRENTSDIR="/tmp/medias"
export TVSHOWSDIR="/tmp/medias"
export DOMAIN="example.com"
export SEEDBOX_NETWORK="traefik_network"

dockerize -force -template ./nzbget/Dockerfile.tmpl:./nzbget/Dockerfile
dockerize -force -template ./sickrage/Dockerfile.tmpl:./sickrage/Dockerfile
dockerize -force -template ./transmission/Dockerfile.tmpl:./transmission/Dockerfile
dockerize -force -template ./couchpotato/Dockerfile.tmpl:./couchpotato/Dockerfile
