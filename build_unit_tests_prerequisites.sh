#!/bin/bash

set -x

BASEDIR="$( cd "$(dirname "$0")" ; pwd -P )"
docker build -t puppet-gb_backend-unit-tests-prerequisites:latest -f ${BASEDIR}/UnitTestsPrereqDockerfile .
