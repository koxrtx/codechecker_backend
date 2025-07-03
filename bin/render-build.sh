#!/bin/bash
set -e

bundle install
yarn install --frozen-lockfile
bundle exec rails assets:precompile