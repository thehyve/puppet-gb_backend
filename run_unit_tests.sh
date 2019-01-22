#!/bin/bash

set -x

BASEDIR="$( cd "$(dirname "$0")" ; pwd -P )"
docker run -v ${BASEDIR}:/latest puppet-gb_backend-unit-tests-prerequisites:latest bash -c "cd /latest && bundle exec rake test"
