#!/bin/bash

# Exit on error
set -e

ARGS="ckan ckanext"
if [[ $# -gt 0 ]]; then
    ARGS=$@
fi

vagrant up
vagrant ssh -c ". /usr/lib/ckan/default/bin/activate; \
                cd /ckan; \
                nosetests --ckan --with-pylons=test-core.ini $ARGS"

