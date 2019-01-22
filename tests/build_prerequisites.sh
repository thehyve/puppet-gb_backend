#!/bin/bash

set -x

BASEDIR="$( cd "$(dirname "$0")" ; pwd -P )"
docker build -t puppet-gb_backend-prerequisites:latest ${BASEDIR}/prerequisites
