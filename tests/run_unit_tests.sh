#!/bin/bash

set -x

BASEDIR="$( cd "$(dirname "$0")" ; pwd -P )"
docker run -v ${BASEDIR}/..:/project puppet-gb_backend-prerequisites:latest bash -c "cd /project && bundle && bundle exec rake test"
