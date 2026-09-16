#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
# For a free instance, migrations must run during the build
bundle exec rails db:migrate
