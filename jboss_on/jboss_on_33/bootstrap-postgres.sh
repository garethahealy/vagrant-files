#!/usr/bin/env bash

set -x

# Install postgres
sudo yum install -y postgresql-server &&
    sudo postgresql-setup initdb &&
    sudo systemctl enable postgresql.service
    sudo systemctl start postgresql.service

# Change password for postgres user
echo "postgres" | sudo passwd "postgres" --stdin

# Create rhq db
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres';"
sudo -u postgres psql -c "CREATE USER rhqadmin PASSWORD 'rhqadmin';"
sudo -u postgres psql -c "CREATE DATABASE rhq OWNER rhqadmin;"

# Change auth to be md5 based
sudo sed -i "s/local   all             all                                     peer/local   all             all                                     md5/" /var/lib/pgsql/data/pg_hba.conf
sudo sed -i "s/host    all             all             127.0.0.1\/32            ident/host    all             all             127.0.0.1\/32            md5/" /var/lib/pgsql/data/pg_hba.conf
sudo sed -i "s/host    all             all             ::1\/128                 ident/host    all             all             ::1\/128                 md5/" /var/lib/pgsql/data/pg_hba.conf
sudo sh -c "echo 'host    all             all             10.20.3.2/24            md5' >> /var/lib/pgsql/data/pg_hba.conf"

# Reload config postgres
sudo systemctl restart postgresql.service

# Check rhqadmin user works
export PGPASSWORD=rhqadmin &&
    psql -U rhqadmin -d rhq
