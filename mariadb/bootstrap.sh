#!/usr/bin/env bash

set -x

sudo yum install -y mariadb mariadb-server

sudo systemctl enable mariadb
sudo systemctl start mariadb

# todo
# https://mariadb.com/kb/en/mariadb/configuring-mariadb-for-remote-client-access/
