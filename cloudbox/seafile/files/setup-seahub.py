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

ROOTLOGGER = logging.getLogger("seahubsetup")

class SeahubSetup:
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
            prog="Seahub setup",
            description='Seahub setup')
   
    parser.add_argument(
            '--install-dir',
            required=True,
            help='Install directory',
            type=str)
    parser.add_argument(
            '--admin-email',
            required=True,
            help="Administator email",
            type=str)
    parser.add_argument(
            '--admin-password',
            required=True,
            help="Administator password",
            type=str)
    return parser.parse_args(raw_args)

  @staticmethod
  def run(install_dir,admin_email, admin_password):
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
  def main(raw_args):
    res = 0
    SeahubSetup.init_loggers()
    args = SeahubSetup.parse_args(raw_args)
    try:
      SeahubSetup.run(args.install_dir, args.admin_email, args.admin_password)
    except Exception as e:
      traceback.print_exc()
      res = -1
    return res

if __name__ == "__main__":
    sys.exit(SeahubSetup.main(sys.argv[1:]))
