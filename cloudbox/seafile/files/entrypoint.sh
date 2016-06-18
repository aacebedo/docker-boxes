#!/usr/bin/env bash
${SEAFILE_INSTALLDIR}/seafile-server-latest/seafile.sh start
${SEAFILE_INSTALLDIR}/seafile-server-latest/seahub.sh start-fastcgi ${SEAFILE_SEAHUB_PORT}
nginx
