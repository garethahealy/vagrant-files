#!/usr/bin/env bash

set -x

sudo firewall-cmd --zone=public --add-port=5432/tcp --permanent
sudo firewall-cmd --reload

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

# Update postgres config
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /var/lib/pgsql/data/postgresql.conf
sudo sed -i "s/shared_buffers = 32MB/shared_buffers = 80MB/" /var/lib/pgsql/data/postgresql.conf
sudo sed -i "s/#work_mem = 1MB/work_mem = 2048/" /var/lib/pgsql/data/postgresql.conf
sudo sed -i "s/#checkpoint_segments = 3/checkpoint_segments = 10/" /var/lib/pgsql/data/postgresql.conf

# Reload config postgres
sudo systemctl restart postgresql.service

# Check rhqadmin user works
export PGPASSWORD=rhqadmin &&
    psql -U rhqadmin -d rhq -c "SELECT 1"
