#!/bin/bash
set -e

bundle install
yarn install --frozen-lockfile
bundle exec rails assets:precompile
echo "Running DB Migrate..."
bundle exec rails db:migrate