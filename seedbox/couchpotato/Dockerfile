FROM alpine:latest
MAINTAINER Alexandre ACEBEDO

ENV COUCHPOTATO_INSTALLDIR   /opt/couchpotato

ARG COUCHPOTATO_USERNAME
ENV COUCHPOTATO_USERNAME     ${COUCHPOTATO_USERNAME:-admin}

ARG COUCHPOTATO_PASSWORD
ENV COUCHPOTATO_PASSWORD     ${COUCHPOTATO_PASSWORD:-password}

ARG COUCHPOTATO_VERSION
ENV COUCHPOTATO_VERSION      ${COUCHPOTATO_VERSION:-3.0.1}

ENV COUCHPOTATO_USER         couchpotato

ARG COUCHPOTATO_UID
ENV COUCHPOTATO_UID          ${COUCHPOTATO_UID:-1000}

ENV COUCHPOTATO_GROUP        couchpotato

ARG COUCHPOTATO_GID
ENV COUCHPOTATO_GID          ${COUCHPOTATO_GID:-1000}

ARG COUCHPOTATO_PORT
ENV COUCHPOTATO_PORT         ${COUCHPOTATO_PORT:-8080}

ARG COUCHPOTATO_DATADIR
ENV COUCHPOTATO_DATADIR      ${COUCHPOTATO_DATADIR:-/var/lib/couchpotato}

ENV DOCKERIZE_VERSION        0.2.0
ENV DOCKERIZE_ARCH           amd64

RUN apk update
RUN apk add git unzip python unrar wget tar zsh openssl py-openssl ca-certificates py-cryptography py-enum34 py-cffi py-lxml vim

RUN wget https://github.com/CouchPotato/CouchPotatoServer/archive/build/${COUCHPOTATO_VERSION}.tar.gz -O /tmp/couchpotato.tar.gz
RUN mkdir -p ${COUCHPOTATO_INSTALLDIR}
RUN tar --strip-components=1  -C ${COUCHPOTATO_INSTALLDIR} -xvzf /tmp/couchpotato.tar.gz
RUN rm -rf /tmp/couchpotato.tar.gz

RUN wget https://github.com/jwilder/dockerize/releases/download/v${DOCKERIZE_VERSION}/dockerize-linux-${DOCKERIZE_ARCH}-v${DOCKERIZE_VERSION}.tar.gz -O /tmp/dockerize.tar.gz
RUN tar -C /usr/local/bin -xzvf /tmp/dockerize.tar.gz
RUN rm -rf /tmp/dockerize.tar.gz

RUN addgroup -g ${COUCHPOTATO_GID} -S ${COUCHPOTATO_GROUP}
RUN adduser -G ${COUCHPOTATO_GROUP} -u ${COUCHPOTATO_UID} -S -H ${COUCHPOTATO_USER} 

RUN mkdir -p ${COUCHPOTATO_DATADIR}
RUN chown -R ${COUCHPOTATO_USER}:${COUCHPOTATO_GROUP} ${COUCHPOTATO_DATADIR}

RUN chown -R ${COUCHPOTATO_USER}:${COUCHPOTATO_GROUP} ${COUCHPOTATO_INSTALLDIR} 

COPY ./files/settings.conf.tmpl ${COUCHPOTATO_INSTALLDIR}/settings.conf.tmpl

EXPOSE ${COUCHPOTATO_PORT}

VOLUME [${COUCHPOTATO_DATADIR}]

USER ${COUCHPOTATO_USER}

WORKDIR ${COUCHPOTATO_INSTALLDIR}
ENTRYPOINT ["zsh", "-c", "dockerize -template ./settings.conf.tmpl:./settings.conf ./CouchPotato.py --data_dir=${COUCHPOTATO_DATADIR} --config_file=./settings.conf"]




