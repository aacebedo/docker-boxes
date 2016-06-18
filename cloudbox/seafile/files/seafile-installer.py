#!/usr/bin/env python3
import pexpect
import sys
import argparse
import logging
from logging import StreamHandler
import traceback
import os

import fileinput
import re
import tarfile
import fnmatch

ROOTLOGGER = logging.getLogger("seafileinstaller")

class SeafileInstaller:
  @staticmethod
  def init_loggers():
     """
     Initialize loggers of the program
     """
     formatter = logging.Formatter('%(message)s')
     hdlr = StreamHandler(sys.stdout)

     hdlr.setLevel(1)
     hdlr.setFormatter(formatter)
     ROOTLOGGER.addHandler(hdlr)

  @staticmethod
  def parse_args(raw_args):
    """
    Function to parse the command line arguments
    """
    # Create main parser
    parser = argparse.ArgumentParser(
            prog="Seafile installer",
            description='Seafile installer')
    root_subparsers = parser.add_subparsers(dest="function")
    install_parser = root_subparsers.add_parser('install', help='Install seafile')

    install_parser.add_argument(
            '--install-dir',
            required=True,
            help='Install directory',
            type=str)
    install_parser.add_argument(
            '--server-name',
            required=True,
            help='Server name',
            type=str)
    install_parser.add_argument(
            '--domain',
            required=True,
            help="Server's domain",
         type=str)
    install_parser.add_argument(
            '--data-dir',
            required=True,
            help="Directory where data will be stored",
            type=str)
 
    install_parser.add_argument(
            'archive',
            help="Seafile archive path",
            type=str) 
    install_parser.add_argument(
            '--server-port',
            required=True,
            type=int)

    configure_parser = root_subparsers.add_parser('configure', help='Configure seafile')
    configure_parser.add_argument(
            '--install-dir',
            required=True,
            help='Install directory',
            type=str)
    configure_parser.add_argument(
            '--admin-email',
            required=True,
            help="Administator email",
            type=str)
    configure_parser.add_argument(
            '--admin-password',
            required=True,
            help="Administator password",
            type=str)
    return parser.parse_args(raw_args)

  @staticmethod
  def install(install_dir, archive_path, domain, server_name, port, data_dir):
    os.makedirs(install_dir,exist_ok=True)
    tar = tarfile.open(archive_path)
    tar.extractall(path=install_dir)
    tar.close()
    uid = os.getuid()
    gid = os.getgid()
    for root, dirnames, filenames in os.walk(install_dir):
      for f in filenames:
        os.chown( os.path.join(root, f),uid,gid)
      for d in dirnames:
        os.chown( os.path.join(root, d),uid,gid)
    setup_file_path = None
    for root, dirnames, filenames in os.walk(install_dir):
      for filename in fnmatch.filter(filenames, 'setup-seafile.sh'):
        setup_file_path = os.path.join(root, filename)
    if setup_file_path != None:
      child = pexpect.spawnu(setup_file_path, timeout=380)
      child.logfile = sys.stdout
      child.expect_exact("Press [ENTER] to continue")
      child.sendline()
      child.expect_exact("[server name]:")
      child.sendline(server_name)
      child.expect_exact("[This server's ip or domain]:")
      child.sendline("{}.{}".format(server_name,domain))
      child.expect_exact("[default: /opt/seafile/seafile-data ]")
      child.sendline(data_dir)
      child.expect_exact("[default: 8082 ]")
      child.sendline(str(port))
      child.expect_exact("If you are OK with the configuration, press [ENTER] to continue.")
      child.sendline()
      child.expect_exact("Now let's setup seahub configuration. Press [ENTER] to continue")
      child.sendline()
      child.wait()
      setup_dir = os.path.dirname(setup_file_path)
    else:
      raise Exception("Unable to find installer") 

#  @staticmethod
#  def generate_nginx_config(nginx_dir, host, install_dir):
#    template = Template("""
#server {
#      listen     80 default;
#      server_name _;
#      return 301 https://$host$request_uri;
#}
#
#server {
#    listen 443;
#    server_name @seafile_host;
#
#    proxy_set_header X-Forwarded-For $remote_addr;
#
#    location / {
#        fastcgi_pass    127.0.0.1:8000;
#        fastcgi_param   SCRIPT_FILENAME     $document_root$fastcgi_script_name;
#        fastcgi_param   PATH_INFO           $fastcgi_script_name;
#
#        fastcgi_param    SERVER_PROTOCOL        $server_protocol#;
#        fastcgi_param   QUERY_STRING        $query_string;
#        fastcgi_param   REQUEST_METHOD      $request_method;
#        fastcgi_param   CONTENT_TYPE        $content_type;
#        fastcgi_param   CONTENT_LENGTH      $content_length;
#        fastcgi_param    SERVER_ADDR         $server_addr;
#        fastcgi_param    SERVER_PORT         $server_port;
#        fastcgi_param    SERVER_NAME         $server_name;
#        fastcgi_param   REMOTE_ADDR         $remote_addr;
#
#        access_log      /var/log/nginx/seahub.access.log;
#        error_log       /var/log/nginx/seahub.error.log;
#        fastcgi_read_timeout 36000;
#    }
#
#    location /seafhttp {
#        rewrite ^/seafhttp(.*)$ $1 break;
#        proxy_pass http://127.0.0.1:8082;
#        client_max_body_size 0;
#        proxy_connect_timeout  36000s;
#        proxy_read_timeout  36000s;
#        proxy_send_timeout  36000s;
#        send_timeout  36000s;
#    }
#
#    location /media {
#        root @seafile_install_dir/seafile-server-latest/seahub;
#    }
#}
#""")
#    output_file_path = os.path.join(nginx_dir,"etc","nginx","sites-enabled","seafile") 
#    os.makedirs(os.path.dirname(output_file_path),exist_ok=True)
# 
#    output_file = open(output_file_path,'w')
#    output_file.write(template.render({"seafile_host":host, "seafile_install_dir":install_dir}))
#    output_file.close()
#
#    found = False
#    output_file_path = os.path.join(nginx_dir,"etc","nginx","nginx.conf")
#   
#    with fileinput.FileInput(output_file_path, inplace=True, backup='.bak') as file:
#      for line in file:
#        if (re.match("daemon .*;",line) != None):
#          found = True
#          print(re.sub("daemon .*;", "daemon off;", line),end='')
#        else:
#          print(line,end='')
#    if found == False:
#      output_file = open(output_file_path,"a")
#      output_file.write("daemon off;")
#      output_file.close()

#  @staticmethod
#  def generate_seahub_settings(install_dir, host):
#    found = False
#    output_file_path = os.path.join(install_dir,"conf","seahub_settings.py")
#    new_root = "FILE_SERVER_ROOT = 'http://{}/seafhttp'".format(host)
#    with fileinput.FileInput(output_file_path, inplace=True, backup='.bak') as file:
#      for line in file:
#        if (re.match("FILE_SERVER_ROOT = '.*'",line) != None):
#          found = True
#          print(re.sub("FILE_SERVER_ROOT = '.*'", new_root, line),end='')
#        else:
#          print(line,end='')
#    if found == False:
#      output_file = open(output_file_path,"a")
#      output_file.write(new_root)
#      output_file.close()

#  @staticmethod
#  def generate_ccnet(install_dir, host):
#    found = False
#    output_file_path = os.path.join(install_dir,"conf","ccnet.conf"),
#    new_service = "SERVICE_URL = http://{}".format(host)
#    with fileinput.FileInput(output_file_path, inplace=True, backup='.bak') as file:
#      for line in file:
#        if (re.match("SERVICE_URL = .*",line) != None):
#          found = True
#          print(re.sub("SERVICE_URL = .*", new_service, line),end='')
#        else:
#          print(line,end='')
#    if found == False:
#      output_file = open(output_file_path,"a")
#      output_file.write(new_service)
#      output_file.close()

  @staticmethod
  def configure_seahub(install_dir,admin_email, admin_password):
      child = pexpect.spawnu("{}".format(os.path.join(install_dir,"seafile-server-latest","seafile.sh")),["start"],timeout=180)
      child.expect(pexpect.EOF)
      child = pexpect.spawnu("{}".format(os.path.join(install_dir,"seafile-server-latest","seahub.sh")),["start-fastcgi"],timeout=180)
      child.logfile = sys.stdout
      child.expect_exact("[ admin email ]")
      child.sendline(admin_email)
      child.expect_exact("[ admin password ]")
      child.sendline(admin_password)
      child.expect_exact("[ admin password again ]")
      child.sendline(admin_password)
      child = pexpect.spawnu("{}".format(os.path.join(install_dir,"seafile-server-latest","seahub.sh")),["stop"],timeout=180)
      child.expect(pexpect.EOF) 
      child = pexpect.spawnu("{}".format(os.path.join(install_dir,"seafile-server-latest","seafile.sh")),["stop"],timeout=180)
      child.expect(pexpect.EOF)

  @staticmethod
  def execute_action(action, args):
    if action == "install":
      SeafileInstaller.install(args.install_dir, args.archive, args.domain, args.server_name, args.server_port, args.data_dir)
    elif action == "configure":
      SeafileInstaller.configure_seahub(args.install_dir, args.admin_email, args.admin_password)
 
  @staticmethod
  def main(raw_args):
    res = 0
    SeafileInstaller.init_loggers()
    args = SeafileInstaller.parse_args(raw_args)
    if args.function != None:
      try:
        SeafileInstaller.execute_action(args.function, args)      
      except Exception as e:
        traceback.print_exc()
        res = -1
    return res

if __name__ == "__main__":
    sys.exit(SeafileInstaller.main(sys.argv[1:]))
