#!/bin/bash

#shellcheck disable=SC1091
source /etc/profile.d/rvm.sh
ruby -v
type -p bundler || gem install bundler

cd /tmp || exit 1
tar xzf /share/project.tar.gz
bundle install --path /cache/gems
bundle exec rake
echo "EXIT_STATUS=$?"
