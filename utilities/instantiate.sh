#!/usr/bin/env bash

export BASE_IMAGE="alpine:latest"
export ARCH="amd64"

export TRAEFIK_VERSION="1.1.0"
export TRAEFIK_DOMAIN="example.com"
export TRAEFIK_SUBDOMAINS='"subdomain.example.com"'
export TRAEFIK_ADMIN_EMAIL="admin@example.com"
export TRAEFIK_DATADIR="/mnt/data/traefik"
export TRAEFIK_PORT="80"
export TRAEFIK_SECUREPORT="443"
export TRAEFIK_CONTROLPORT="82"
export TRAEFIK_ADMIN_AUTH="admin:test"

export CFDNSUPDATER_DOMAIN="example.com"
export CFDNSUPDATER_EMAIL="admin@example.com"
export CFDNSUPDATER_APIKEY="none"
export CFDNSUPDATER_PERIOD="60"
export CFDNSUPDATER_RECORDTYPES=""
export CFDNSUPDATER_RECORDNAMES=""
export CFDNSUPDATER_VERSION="0.9.2"

export DNSDOCK_VERSION="1.12.1"
export DNSDOCK_DOMAIN="example.com"
export DNSDOCK_PORT="53"
export DNSDOCK_CONTROLPORT="83"

export UTILITIES_NETWORK="traefik_network"

rocker build -var ARCH=amd64 -var TRAEFIK_VERSION=${TRAEFIK_VERSION} -var IS_LATEST=true -f ./traefik/Rockerfile ./traefik
