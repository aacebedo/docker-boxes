#!/usr/bin/env bash

export BASE_IMAGE="alpine:latest"
export DOCKERIZE_ARCH="amd64"

export TRAEFIK_ARCH="amd64"
export TRAEFIK_VERSION="1.0.0-rc2"
export TRAEFIK_DOMAIN="acebedo.fr"
export TRAEFIK_SUBDOMAINS='"seafile.acebedo.fr"'
export TRAEFIK_ADMIN_EMAIL="alexandre@acebedo.fr"
export TRAEFIK_DATADIR="/tmp/traefik"
export TRAEFIK_PORT="80"
export TRAEFIK_SECUREPORT="443"
export TRAEFIK_CONTROLPORT="82"

export CFDNSUPDATER_DOMAIN="example.com"
export CFDNSUPDATER_EMAIL="admin@example.com"
export CFDNSUPDATER_APIKEY="none"
export CFDNSUPDATER_PERIOD="60"
export CFDNSUPDATER_RECORDTYPES=""
export CFDNSUPDATER_RECORDNAMES=""
export CFDNSUPDATER_ARCH="amd64"
export CFDNSUPDATER_VERSION="0.9.2"

export UTILITIES_NETWORK="traefik_network"

dockerize -force -template ./traefik/Dockerfile.tmpl:./traefik/Dockerfile
dockerize -force -template ./cfdnsupdater/Dockerfile.tmpl:./cfdnsupdater/Dockerfile
