#!/usr/bin/env bash
# Build script for Render: install gems, build assets, update the database
set -o errexit

bundle install
bin/rails assets:precompile
bin/rails assets:clean
bin/rails db:migrate
bin/rails db:seed
