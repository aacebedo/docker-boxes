#!/usr/bin/env sh

export BASE_IMAGE="alpine:latest"
export DOCKERIZE_ARCH="amd64"
export DOMAIN="domain.com"
export NZBSDIR=""
export MOVIESDIR=""
export TORRENTSDIR=""
export TVSHOWS=""
export SICKRAGE_USERNAME="admin"
export SICKRAGE_PASSWORD="password"
export NZBGET_USERNAME="admin"
export NZBGET_PASSWORD="password"
export TRANSMISSION_USERNAME="admin"
export TRANSMISSION_PASSWORD="password"
export SEEDBOX_NETWORK="seedbox_network"

dockerize -template ./nzbget/Dockerfile.tmpl:./nzbget/Dockerfile
dockerize -template ./sickrage/Dockerfile.tmpl:./sickrage/Dockerfile
dockerize -template ./transmission/Dockerfile.tmpl:./transmission/Dockerfile
dockerize -template ./couchpotato/Dockerfile.tmpl:./couchpotato/Dockerfile