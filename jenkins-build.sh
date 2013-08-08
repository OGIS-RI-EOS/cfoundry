#! /bin/sh
# build script for jenkins

git submodule update --init
bundle install --no-color --path vendor
bundle exec rake spec
