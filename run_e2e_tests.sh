#!/bin/bash

set -x

BASEDIR="$( cd "$(dirname "$0")" ; pwd -P )"
docker run -v ${BASEDIR}:/etc/puppet/code/modules/gb_backend -v ${BASEDIR}/test_hiera.yaml:/etc/puppet/code/hiera/common.yaml puppet-gb_backend-e2e-tests-prerequisites:latest puppet apply --detailed-exitcodes -e "include gb_backend"
