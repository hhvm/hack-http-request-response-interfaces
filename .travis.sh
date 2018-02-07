#!/bin/sh
set -ex
hhvm --version

wget https://getcomposer.org/composer.phar
hhvm ./composer.phar install --ignore-platform-reqs

hh_client

hhvm vendor/bin/hhast-lint
