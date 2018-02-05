#!/bin/sh
set -ex
hhvm --version

wget https://getcomposer.org/composer.phar
hhvm -d hhvm.php7.all=1 ./composer.phar install --ignore-platform-reqs

hh_client

hhvm -d hhvm.php7.all=0 bin/hhast-lint
hhvm -d hhvm.php7.all=1 bin/hhast-lint
