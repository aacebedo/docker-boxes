FROM alpine:latest
MAINTAINER Alexandre ACEBEDO

ENV TRAEFIK_INSTALLDIR   /opt/traefik

ARG TRAEFIK_VERSION
ENV TRAEFIK_VERSION      ${TRAEFIK_VERSION:-1.0.0-rc2}
ENV TRAEFIK_USER         traefik

ARG TRAEFIK_UID
ENV TRAEFIK_UID          ${TRAEFIK_UID:-1000}

ENV TRAEFIK_GROUP        traefik

ARG TRAEFIK_GID
ENV TRAEFIK_GID          ${TRAEFIK_GID:-1000}

ARG TRAEFIK_PORT
ENV TRAEFIK_PORT         ${TRAEFIK_PORT:-8080}

ARG TRAEFIK_SECUREPORT
ENV TRAEFIK_SECUREPORT   ${TRAEFIK_SECUREPORT:-4443}

ARG TRAEFIK_CONTROLPORT
ENV TRAEFIK_CONTROLPORT  ${TRAEFIK_CONTROLPORT:-8082}

ARG TRAEFIK_ADMIN_EMAIL
ENV TRAEFIK_ADMIN_EMAIL  ${TRAEFIK_ADMIN_EMAIL:-root@domain.com}

ARG TRAEFIK_DOMAIN
ENV TRAEFIK_DOMAIN       ${TRAEFIK_DOMAIN:-domain.com}

ARG TRAEFIK_SUBDOMAINS
ENV TRAEFIK_SUBDOMAINS   ${TRAEFIK_SUBDOMAINS:-[\"subdomain.domain.com\"]}

ENV DOCKERIZE_VERSION    0.2.0
ENV DOCKERIZE_ARCH       amd64

ARG TRAEFIK_DATADIR
ENV TRAEFIK_DATADIR      ${TRAEFIK_DATADIR:-/var/lib/traefik}

ENV TRAEFIK_ARCH         amd64

RUN apk update
RUN apk add git zsh openssl ca-certificates vim

RUN mkdir -p ${TRAEFIK_INSTALLDIR}
RUN wget https://github.com/containous/traefik/releases/download/v${TRAEFIK_VERSION}/traefik_linux-${TRAEFIK_ARCH} -O ${TRAEFIK_INSTALLDIR}/traefik
RUN chmod a+x ${TRAEFIK_INSTALLDIR}/traefik

RUN wget https://github.com/jwilder/dockerize/releases/download/v${DOCKERIZE_VERSION}/dockerize-linux-${DOCKERIZE_ARCH}-v${DOCKERIZE_VERSION}.tar.gz -O /tmp/dockerize.tar.gz
RUN tar -C /usr/local/bin -xzvf /tmp/dockerize.tar.gz
RUN rm /tmp/dockerize.tar.gz

RUN addgroup -g ${TRAEFIK_GID} -S ${TRAEFIK_GROUP}
RUN adduser -G ${TRAEFIK_GROUP} -u ${TRAEFIK_UID} -S -H ${TRAEFIK_USER} 

COPY ./files/traefik.conf.tmpl ${TRAEFIK_INSTALLDIR}/traefik.conf.tmpl
RUN chown -R ${TRAEFIK_USER}:${TRAEFIK_GROUP} ${TRAEFIK_INSTALLDIR}

RUN mkdir -p ${TRAEFIK_DATADIR}
RUN chown -R ${TRAEFIK_USER}:${TRAEFIK_GROUP} ${TRAEFIK_DATADIR}

EXPOSE ${TRAEFIK_PORT} ${TRAEFIK_SECUREPORT} ${TRAEFIK_CONTROLPORT}

USER ${TRAEFIK_USER}

VOLUME ["unix:///var/run/docker.sock"]
WORKDIR ${TRAEFIK_INSTALLDIR}

ENTRYPOINT ["dockerize", "-template", "./traefik.conf.tmpl:./traefik.conf", "./traefik", "-c", "./traefik.conf"]
