#!/usr/bin/env bash

export BASE_IMAGE="alpine:latest"
export DOCKERIZE_ARCH="amd64"
export TRAEFIK_ARCH="amd64"
export TRAEFIK_DOMAIN="acebedo.fr"
export TRAEFIK_SUBDOMAINS='"seafile.acebedo.fr"'
export TRAEFIK_ADMIN_EMAIL="alexandre@acebedo.fr"
export TRAEFIK_DATADIR="/tmp/traefik"
export TRAEFIK_PORT="80"
export TRAEFIK_SECUREPORT="443"
export TRAEFIK_CONTROLPORT="82"
export UTILITIES_NETWORK="traefik_network"

dockerize -force -template ./traefik/Dockerfile.tmpl:./traefik/Dockerfile
