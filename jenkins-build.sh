#! /bin/sh
# build script for jenkins

git submodule update --init
bundle install --no-color --path vendor --without production
bundle exec rake ci:setup:rspec spec
