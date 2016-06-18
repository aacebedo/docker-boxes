#!/usr/bin/env sh

export BASE_IMAGE="alpine:latest"
export DOCKERIZE_ARCH="amd64"
export DOMAIN="domain.com"
export NZBSDIR=""
export MOVIESDIR=""
export TORRENTSDIR=""
export TVSHOWSDIR=""
export SICKRAGE_USERNAME="admin"
export SICKRAGE_PASSWORD="password"
export NZBGET_USERNAME="admin"
export NZBGET_PASSWORD="password"
export TRANSMISSION_USERNAME="admin"
export TRANSMISSION_PASSWORD="password"
export SEEDBOX_NETWORK="seedbox_network"

dockerize -force -template ./nzbget/Dockerfile.tmpl:./nzbget/Dockerfile
dockerize -force -template ./sickrage/Dockerfile.tmpl:./sickrage/Dockerfile
dockerize -force -template ./transmission/Dockerfile.tmpl:./transmission/Dockerfile
dockerize -force -template ./couchpotato/Dockerfile.tmpl:./couchpotato/Dockerfile