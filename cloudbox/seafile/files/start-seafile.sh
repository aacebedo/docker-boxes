#! /usr/bin//env bash
/opt/seafile/seafile-server-latest/seafile.sh start 
if [[ $? == 0 ]]; then  
  trap '{ /opt/seafile/seafile-server-latest/seafile.sh stop; exit 0; }' EXIT
  tail -f -n1 /opt/seafile/logs/seafile.log
fi
exit $?
