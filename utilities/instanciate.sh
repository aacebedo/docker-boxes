#!/usr/bin/env sh

export BASE_IMAGE="alpine:latest"
export DOCKERIZE_ARCH="amd64"
export TRAEFIK_ARCH="amd64"
export TRAEFIK_DOMAIN="domain.com"
export TRAEFIK_SUBDOMAINS=""
export TRAEFIK_ADMIN_EMAIL="root@domain.com"
export TRAEFIK_DATADIR=""
export UTILITIES_NETWORK="utilities_network"

dockerize -template ./traefik/Dockerfile.tmpl:./traefik/Dockerfile