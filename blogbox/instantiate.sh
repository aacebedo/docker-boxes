#!/usr/bin/env sh

export ARCH="amd64"
export GHOST_VERSION="1.0.0-alpha.13"
export GHOST_HOSTNAME="http://blog.example.com"
export GHOST_DATADIR="/mnt/data/ghost"

export WORDPRESS_VERSION="4.7.2"
export WORDPRESS_HOSTNAME="blog.example.com"
export WORDPRESS_DATADIR="/mnt/data/wordpress"

export BLOGBOX_NETWORK="traefik_network"

rocker build -var ARCH=${ARCH} \
             -var GHOST_VERSION=${GHOST_VERSION} \
             -var IS_LATEST=true \
             -f ./ghost/Rockerfile ./ghost
             
rocker build -var ARCH=${ARCH} \
             -var WORDPRESS_VERSION=${WORDPRESS_VERSION} \
             -var IS_LATEST=true \
             -f ./wordpress/Rockerfile ./wordpress
