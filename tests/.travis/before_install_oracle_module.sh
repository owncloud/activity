#!/bin/bash

# build php module
git clone https://github.com/DeepDiver1975/oracle_instant_client_for_ubuntu_64bit.git instantclient
cd instantclient
sudo bash -c 'printf "\n" | python system_setup.py'

sudo mkdir -p /usr/lib/oracle/11.2/client64/rdbms/
sudo ln -s /usr/include/oracle/11.2/client64/ /usr/lib/oracle/11.2/client64/rdbms/public

sudo apt-get install -qq --force-yes libaio1
if [ "$TRAVIS_PHP_VERSION" == "5.6" ] ; then
  printf "/usr/lib/oracle/11.2/client64\n" | pecl install oci8-2.0.12
else
  printf "/usr/lib/oracle/11.2/client64\n" | pecl install oci8
fi
