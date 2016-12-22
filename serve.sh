#!/bin/bash

# Exit on error
set -e

vagrant up
vagrant ssh -c '/usr/lib/ckan/default/bin/paster serve -v --reload \
    /etc/ckan/default/development.ini'

