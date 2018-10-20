#!/bin/bash

set -e

TEST_PROJECT_DIR=$1
CHECK_RESULTS_LIB=$2

echo "Running in $(pwd) with test project dir ${TEST_PROJECT_DIR} and mode ${MODE}"


if [ -e build-tool ]
then
  rm -r build-tool
fi

mkdir build-tool && cd build-tool
cmake ${TEST_PROJECT_DIR}
cmake --build .

host_os=$(uname)
if [[ ${host_os} == CYGWIN* ]]
then
  host_os=Cygwin
elif [[ ${host_os} == MSYS* ]]
then
  host_os=MSys
fi

EXPECTED_ARTIFACTS_FILE=${TEST_PROJECT_DIR}/../testconfigs/ExpectedArtifacts.${host_os}
source ${CHECK_RESULTS_LIB}

echo "Checking results..."
check_build_dir_artifacts ${EXPECTED_ARTIFACTS_FILE}
