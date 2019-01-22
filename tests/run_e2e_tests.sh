#!/bin/bash

set -x

BASEDIR="$( cd "$(dirname "$0")" ; pwd -P )"
docker run -v ${BASEDIR}/..:/etc/puppet/code/modules/gb_backend -v ${BASEDIR}/test_hiera.yaml:/etc/puppet/code/hiera/common.yaml puppet-gb_backend-prerequisites:latest puppet apply --debug -e "include gb_backend"
