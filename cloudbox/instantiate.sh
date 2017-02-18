#!/usr/bin/env sh

export ARCH="amd64"

export SEAFILE_VERSION="5.1.3"
export SEAFILE_HOSTNAME="seafile.example.com"
export SEAFILE_SERVERNAME="seafile"
export SEAFILE_ADMIN_EMAIL="admin@example.com"
export SEAFILE_ADMIN_PASSWORD="password"
export SEAFILE_PROTOCOL="https"
export SEAFILE_URL="https://bintray.com/artifact/download/seafile-org/seafile/seafile-server_${SEAFILE_VERSION}_x86-64.tar.gz"
export SEAFILE_DATADIR="/tmp/seafile/data"
export SEAFILE_CONFDIR="/tmp/seafile/conf"
export SEAFILE_SMTP_TLS="True"
export SEAFILE_SMTP_SERVER="smtp.example.com"
export SEAFILE_SMTP_EMAIL="admin@example"
export SEAFILE_SMTP_PASSWORD="password"

export ROUNDCUBE_VERSION="1.3-beta"
export ROUNDCUBE_SMTP_SERVER="ssl://smtp.example.com"
export ROUNDCUBE_IMAP_SERVER="ssl://imap.example.com"
export ROUNDCUBE_DES_KEY="aaaaaaaaaaaaaaaaaaaaaaaa"

export CLOUDBOX_NETWORK="traefik_network"

rocker build -var ARCH=amd64 \
             -var SEAFILE_VERSION=${SEAFILE_VERSION} \
             -var IS_LATEST=true \
             -f ./seafile/Rockerfile ./seafile
rocker build -var ARCH=amd64 \
             -var ROUNDCUBE_VERSION=${ROUNDCUBE_VERSION} \
             -var IS_LATEST=true \
             -f ./roundcube/Rockerfile ./roundcube
