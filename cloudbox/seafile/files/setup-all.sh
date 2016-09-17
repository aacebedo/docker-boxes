#! /usr/bin/env bash

if [ ! -f "/etc/seafile/seahub_settings.py" ]; then
  /opt/seafile/seafile-server-latest/setup-seafile.sh auto -n ${SEAFILE_SERVERNAME} -i ${SEAFILE_HOSTNAME} -p 8082 -d /var/lib/seafile
  /opt/seafile/seafile-server-latest/seafile.sh start
  dockerize -force -template /etc/seafile/nginx.conf.tmpl:/etc/seafile/nginx.conf
  export SEAFILE_ID=`grep "ID" /etc/seafile/ccnet.conf | cut -d ' ' -f 3`
  dockerize -force  -template /etc/seafile/ccnet.conf.tmpl:/opt/seafile/conf/ccnet.conf
  setup-seahub.py --install-dir /opt/seafile --admin-email ${SEAFILE_ADMIN_EMAIL} --admin-password ${SEAFILE_ADMIN_PASSWORD}
  export SEAFILE_SECRETKEY=`grep "SECRET_KEY" /etc/seafile/seahub_settings.py | cut -d ' ' -f 3`
  dockerize -force -template /etc/seafile/seahub_settings.py.tmpl:/etc/seafile/seahub_settings.py
fi
