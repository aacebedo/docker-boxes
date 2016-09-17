#! /usr/bin//env bash

/opt/seafile/seafile-server-latest/seahub.sh start-fastcgi 8000

if [[ $? == 0 ]]; then
  trap '{ /opt/seafile/seafile-server-latest/seahub.sh stop; exit 0; }' EXIT
  tail -f -n1 /opt/seafile/logs/seahub.log
fi
exit $?
