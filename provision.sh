#!/bin/bash

# Exit on error
set -e

# Install required packages
sudo apt-get update
sudo apt-get install --yes python-dev postgresql libpq-dev \
                           python-virtualenv git-core solr-tomcat \
                           redis-server

# Create virtualenv
sudo mkdir -p /usr/lib/ckan/default
sudo chown -R `whoami` /usr/lib/ckan/default
virtualenv /usr/lib/ckan/default
. /usr/lib/ckan/default/bin/activate

# Install CKAN from Git repository in shared folder
cd /ckan
python setup.py develop
pip install -r requirements.txt
pip install -r dev-requirements.txt

# Link CKAN configuration
sudo mkdir -p /etc/ckan/default
sudo chown -R `whoami` /etc/ckan
cd /etc/ckan/default
ln -sf /vagrant/development.ini
ln -sf /ckan/who.ini

# Configure Solr
sudo cp /ckan/ckan/config/solr/schema.xml /etc/solr/conf/schema.xml
sudo service tomcat6 restart

# Set up PostgreSQL
sudo -u postgres psql -c "CREATE USER ckan_default
                        WITH PASSWORD 'ckan_default';"
sudo -u postgres psql -c "CREATE USER datastore_default
                        WITH PASSWORD 'datastore_default';"
sudo -u postgres createdb -O ckan_default ckan_default -E utf-8
sudo -u postgres createdb -O ckan_default datastore_default -E utf-8
sudo -u postgres createdb -O ckan_default ckan_test -E utf-8
sudo -u postgres createdb -O ckan_default datastore_test -E utf-8
paster --plugin=ckan datastore set-permissions \
       -c /etc/ckan/default/development.ini \
    | sudo -u postgres psql --set ON_ERROR_STOP=1
paster --plugin=ckan datastore set-permissions \
       -c /vagrant/test-core.ini \
    | sudo -u postgres psql --set ON_ERROR_STOP=1
paster --plugin=ckan db init -c /etc/ckan/default/development.ini

# Fix problems with outdated setuptools
# https://github.com/pyca/cryptography/issues/2838
pip install --upgrade pip setuptools

