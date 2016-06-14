FROM alpine:latest
MAINTAINER Alexandre ACEBEDO

ENV DELUGE_USER       deluge

ARG DELUGE_UID
ENV DELUGE_UID        ${DELUGE_UID:-1000}

ENV DELUGE_GROUP      deluge

ARG DELUGE_GID
ENV DELUGE_GID        ${DELUGE_GID:-1000}

ARG DELUGE_PORT
ENV DELUGE_PORT       ${DELUGE_PORT:-8080}
 
ARG DELUGE_VERSION
ENV DELUGE_VERSION    ${DELUGE_VERSION:-1.3.12}

ENV BOOST_VERSION     1_61_0
ENV BOOST_VERSION_PT  1.61.0
ENV THREADS           8

RUN apk update
RUN apk add git unzip python unrar wget libtorrent-dev tar zsh openssl \
    py-openssl py-enum34 py-cryptography vim py-setuptools py-chardet \
    py-twisted py-six py-cffi py-pip py-mako autoconf libtool \
    automake gcc g++ make openssl-dev linux-headers python-dev bzip2-dev ca-certificates
#RUN pip install pyxdg service_identity python-libtorrent

#RUN wget -O /tmp/boost.tar.gz https://sourceforge.net/projects/boost/files/boost/${BOOST_VERSION_PT}/boost_${BOOST_VERSION}.tar.gz/download
#RUN mkdir -p /tmp/boost
#RUN tar --strip-components=1 -C /tmp/boost -xvzf /tmp/boost.tar.gz
#WORKDIR /tmp/boost
#RUN ./bootstrap.sh
#RUN ./bjam cxxflags="-std=c++11" -j${THREADS} install
#RUN rm -rf /tmp/boost /tmp/boost.tar.gz

#RUN wget -O /tmp/libtorrent.tar.gz https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_1/libtorrent-rasterbar-1.1.0.tar.gz
#RUN mkdir -p /tmp/libtorrent
#RUN tar --strip-components=1 -C /tmp/libtorrent -xvzf /tmp/libtorrent.tar.gz
#WORKDIR /tmp/libtorrent
#RUN ./configure --enable-python-binding
#RUN make install -j${THREADS}
#WORKDIR /tmp/libtorrent/bindings/python
#RUN python ./setup.py install
#RUN rm -rf /tmp/libtorrent /tmp/libtorrent.tar.gz

RUN wget -O /tmp/deluge.tar.gz https://github.com/deluge-torrent/deluge/archive/deluge-${DELUGE_VERSION}.tar.gz
RUN mkdir -p /tmp/deluge
RUN tar --strip-components=1 -C /tmp/deluge -xvzf  /tmp/deluge.tar.gz
WORKDIR /tmp/deluge
RUN python setup.py build
RUN python setup.py install
RUN rm -rf /tmp/deluge

RUN addgroup -g ${DELUGE_GID} -S ${DELUGE_GROUP}
RUN adduser -G ${DELUGE_GROUP} -u ${DELUGE_UID} -S -H ${DELUGE_USER} 

EXPOSE ${DELUGE_PORT}

RUN mkdir -p /opt/deluge
RUN mkdir -p /home/deluge
RUN chown ${DELUGE_USER}:${DELUGE_GROUP} /home/deluge

#USER ${DELUGE_USER} 

#ENTRYPOINT ["zsh","-c","deluged && deluge-web  -p ${DELUGE_PORT}"]



