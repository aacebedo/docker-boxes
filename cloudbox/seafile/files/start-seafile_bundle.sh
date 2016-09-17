#! /usr/bin/env bash
trap '{ supervisorctl stop seafile seahub nginx; exit 0; }' EXIT

sudo -u seafile -E setup-all.sh
supervisorctl start seafile
sleep 3
supervisorctl start seahub nginx

tail -f -n1 /var/log/supervisord.log
