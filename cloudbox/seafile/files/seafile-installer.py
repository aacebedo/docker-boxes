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
            '--hostname',
            required=True,
            help="Server's hostname",
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
  def install(install_dir, archive_path, hostname, server_name, port, data_dir):
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
      child.sendline(hostname)
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
      SeafileInstaller.install(args.install_dir, args.archive, args.hostname, args.server_name, args.server_port, args.data_dir)
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
