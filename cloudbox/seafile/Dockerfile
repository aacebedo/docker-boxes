FROM ubuntu:latest
MAINTAINER Alexandre ACEBEDO

ENV SEAFILE_INSTALLDIR     /opt/seafile
ENV SEAFILE_DATADIR        /var/lib/seafile
ENV SEAFILE_SEAHUB_PORT    8000
ENV SEAFILE_SERVER_PORT    8082

ARG SEAFILE_VERSION
ENV SEAFILE_VERSION        ${SEAFILE_VERSION:-5.1.3}

ENV SEAFILE_USER           seafile

ARG SEAFILE_UID 
ENV SEAFILE_UID            ${SEAFILE_UID:-1000}

ENV SEAFILE_GROUP          seafile

ARG SEAFILE_GID
ENV SEAFILE_GID            ${SEAFILE_GID:-1000}

ARG SEAFILE_PORT
ENV SEAFILE_PORT           ${SEAFILE_PORT:-80}

ARG SEAFILE_SERVERNAME
ENV SEAFILE_SERVERNAME     ${SEAFILE_SERVERNAME:-seafile}

ARG SEAFILE_DOMAIN
ENV SEAFILE_DOMAIN         ${SEAFILE_DOMAIN:-example.com}

ARG SEAFILE_ADMIN_USERNAME
ENV SEAFILE_ADMIN_USERNAME ${SEAFILE_ADMIN_USERNAME:-admin}

ARG SEAFILE_ADMIN_EMAIL
ENV SEAFILE_ADMIN_EMAIL    ${SEAFILE_ADMIN_EMAIL:-admin@${SEAFILE_DOMAIN}}

ARG SEAFILE_ADMIN_PASSWORD
ENV SEAFILE_ADMIN_PASSWORD ${SEAFILE_ADMIN_PASSWORD:-password}

ENV DOCKERIZE_VERSION      0.2.0
ENV DOCKERIZE_ARCH         amd64

RUN apt update 
RUN apt install nginx python python-pip python-imaging python3 sqlite gcc python-pillow \
    python-dev libssl-dev libldap2-dev zsh less vim bash libevent-dev zlib1g-dev \
    libglib2.0-dev libffi-dev libjansson4 libsasl2-dev wget python3-pip -y --force-yes
RUN pip install python-ldap
RUN pip3 install --upgrade pip
RUN pip3 install pexpect

RUN addgroup --system --gid ${SEAFILE_GID} ${SEAFILE_GROUP}
RUN adduser --system -gid ${SEAFILE_GID} --uid ${SEAFILE_UID} ${SEAFILE_USER} 

RUN wget https://github.com/aacebedo/dockerize/releases/download/v${DOCKERIZE_VERSION}/dockerize-linux-${DOCKERIZE_ARCH}-v${DOCKERIZE_VERSION}.tar.gz -O /tmp/dockerize.tar.gz
RUN tar -C /usr/local/bin -xzvf /tmp/dockerize.tar.gz
RUN rm -rf /tmp/dockerize.tar.gz

RUN mkdir -p ${SEAFILE_INSTALLDIR}
COPY files/entrypoint.sh ${SEAFILE_INSTALLDIR}/entrypoint.sh
RUN chmod u+x ${SEAFILE_INSTALLDIR}/entrypoint.sh

COPY files/seafile-installer.py ${SEAFILE_INSTALLDIR}/seafile-installer.py
RUN chmod u+x ${SEAFILE_INSTALLDIR}/seafile-installer.py
COPY files/ccnet.conf.tmpl ${SEAFILE_INSTALLDIR}/ccnet.conf.tmpl
COPY files/seahub_settings.py.tmpl ${SEAFILE_INSTALLDIR}/seahub_settings.py.tmpl
COPY files/nginx.conf.tmpl ${SEAFILE_INSTALLDIR}/nginx.conf.tmpl

#RUN chown -R ${SEAFILE_USER}:${SEAFILE_GROUP} ${SEAFILE_INSTALLDIR}

RUN rm -rf /etc/nginx/sites-enabled/*

#ADD https://github.com/haiwen/seafile-rpi/releases/download/v${SEAFILE_VERSION}/seafile-server_stable_${SEAFILE_VERSION}_pi.tar.gz /tmp/seafile.tar.gz
ADD https://bintray.com/artifact/download/seafile-org/seafile/seafile-server_${SEAFILE_VERSION}_x86-64.tar.gz /tmp/seafile.tar.gz
RUN ${SEAFILE_INSTALLDIR}/seafile-installer.py install --install-dir ${SEAFILE_INSTALLDIR} --data-dir ${SEAFILE_DATADIR} --domain ${SEAFILE_DOMAIN} --server-name ${SEAFILE_SERVERNAME} --server-port ${SEAFILE_SERVER_PORT} /tmp/seafile.tar.gz
RUN dockerize -force -template ${SEAFILE_INSTALLDIR}/nginx.conf.tmpl:/etc/nginx/sites-enabled/seafile.conf
RUN export SEAFILE_ID=`grep "ID" ${SEAFILE_INSTALLDIR}/conf/ccnet.conf | cut -d ' ' -f 3` && dockerize -force  -template ${SEAFILE_INSTALLDIR}/ccnet.conf.tmpl:${SEAFILE_INSTALLDIR}/conf/ccnet.conf
RUN ${SEAFILE_INSTALLDIR}/seafile-installer.py configure --install-dir ${SEAFILE_INSTALLDIR} --admin-email ${SEAFILE_ADMIN_EMAIL} --admin-password ${SEAFILE_ADMIN_PASSWORD}
RUN export SEAFILE_SECRETKEY=`grep "SECRET_KEY" ${SEAFILE_INSTALLDIR}/conf/seahub_settings.py | cut -d ' ' -f 3` && dockerize -force -template ${SEAFILE_INSTALLDIR}/seahub_settings.py.tmpl:${SEAFILE_INSTALLDIR}/conf/seahub_settings.py
#RUN rm /tmp/seafile.tar.gz 

#RUN chown -R ${SEAFILE_USER}:${SEAFILE_GROUP} ${SEAFILE_INSTALLDIR}

RUN mkdir -p ${SEAFILE_DATADIR} 
#RUN chown -R ${SEAFILE_USER}:${SEAFILE_GROUP} ${SEAFILE_DATADIR}

EXPOSE ${SEAFILE_PORT}

ENTRYPOINT "zsh"
#ENTRYPOINT ["zsh","-c","${SEAFILE_INSTALLDIR}/entrypoint.sh"]
