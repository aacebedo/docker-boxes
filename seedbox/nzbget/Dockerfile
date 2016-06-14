FROM alpine:latest
MAINTAINER Alexandre ACEBEDO

ENV NZBGET_USER        nzbget

ARG NZBGET_UID
ENV NZBGET_UID         ${NZBGET_UID:-1000}

ENV NZBGET_GROUP       nzbget

ARG NZBGET_GID
ENV NZBGET_GID         ${NZBGET_GID:-1000}

ARG NZBGET_PORT
ENV NZBGET_PORT        ${NZBGET_PORT:-8080}

ARG NZBGET_SECUREPORT
ENV NZBGET_SECUREPORT  ${NZBGET_PORT:-4443}
 
ARG NZBGET_VERSION
ENV NZBGET_VERSION     ${NZBGET_VERSION:-16.4}

ENV DOCKERIZE_VERSION  0.2.0
ENV DOCKERIZE_ARCH     amd64

ENV NZBGET_INSTALLDIR  /opt/nzbget

ARG NZBGET_DATADIR
ENV NZBGET_DATADIR     ${NZBGET_DATADIR:-/var/lib/nzbget}
 
ENV TERM xterm

RUN apk update
RUN apk add wget ca-certificates zsh vim
RUN wget https://github.com/nzbget/nzbget/releases/download/v${NZBGET_VERSION}/nzbget-${NZBGET_VERSION}-bin-linux.run -O /tmp/nzbget.bin
RUN chmod a+x /tmp/nzbget.bin
RUN /tmp/nzbget.bin --destdir ${NZBGET_INSTALLDIR} 

RUN wget https://github.com/jwilder/dockerize/releases/download/v${DOCKERIZE_VERSION}/dockerize-linux-${DOCKERIZE_ARCH}-v${DOCKERIZE_VERSION}.tar.gz -O /tmp/dockerize.tar.gz
RUN tar -C /usr/local/bin -xzvf /tmp/dockerize.tar.gz
RUN rm /tmp/dockerize.tar.gz

RUN addgroup -g ${NZBGET_GID} -S ${NZBGET_GROUP}
RUN adduser -G ${NZBGET_GROUP} -u ${NZBGET_UID} -S -H ${NZBGET_USER} 

COPY ./files/nzbget.conf.tmpl ${NZBGET_INSTALLDIR}/nzbget.conf.tmpl

RUN mkdir -p ${NZBGET_DATADIR}
RUN chown -R ${NZBGET_USER}:${NZBGET_GROUP} ${NZBGET_DATADIR}
RUN chown -R ${NZBGET_USER}:${NZBGET_GROUP} ${NZBGET_INSTALLDIR}

VOLUME [${NZBGET_DATADIR}]
EXPOSE ${NZBGET_PORT} ${NZBGET_SECUREPORT}
USER ${NZBGET_USER}
WORKDIR ${NZBGET_INSTALLDIR} 

ENTRYPOINT ["dockerize", "-template", "./nzbget.conf.tmpl:./nzbget.conf", "./nzbget", "-c", "./nzbget.conf", "-s"]
