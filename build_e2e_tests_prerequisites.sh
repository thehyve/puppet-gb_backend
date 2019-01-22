#!/bin/bash

set -x

BASEDIR="$( cd "$(dirname "$0")" ; pwd -P )"
docker build -t puppet-gb_backend-e2e-tests-prerequisites:latest -f ${BASEDIR}/E2eTestsPrereqDockerfile .
