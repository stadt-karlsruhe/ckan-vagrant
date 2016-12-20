# Vagrant configuration for CKAN development

This repository contains a simple [Vagrant][vagrant] configuration to set up a
virtual machine for [CKAN][ckan] development.

[vagrant]: https://www.vagrantup.com/
[ckan]: https://github.com/ckan/ckan


## Installation

First make sure that you have installed [Vagrant][vagrant] and
[Virtualbox][virtualbox]:

    sudo apt-get install vagrant virtualbox

The setup is configured to share a CKAN git repository between the host and the
VM. The CKAN repository is assumed to be in an adjacent `ckan` directory. Hence
you need to clone both this repository and that of CKAN:

    git clone https://github.com/stadt-karlsruhe/ckan-vagrant.git
    git clone https://github.com/ckan/ckan.git


## Usage

First bring up the VM:

    cd ckan-vagrant
    vagrant up

The first time you run `vagrant up` it will install the CKAN development
environment in the VM.

Once the VM has finished booting log into it using SSH:

    vagrant ssh

From the SSH shell you can then, for example, run CKAN's development server:

    . /usr/lib/ckan/default/bin/activate
    paster serve -v --reload /etc/ckan/default/bin/activate

From the host machine, the server is reachable via http://172.16.16.18:5000.

