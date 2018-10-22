#!/bin/bash

set -e

TEST_PROJECT_DIR=$1
CHECK_RESULTS_LIB=$2
CMAKE_GENERATOR=$3

echo "Running in $(pwd) with test project dir ${TEST_PROJECT_DIR}"


if [ -e thirdparty-lib ]
then
  rm -r thirdparty-lib
fi

mkdir thirdparty-lib && cd thirdparty-lib
cmake -G "${CMAKE_GENERATOR}" -DCMAKE_BUILD_TYPE=Debug ${TEST_PROJECT_DIR}
cmake --build . --config Debug

echo "Checking results..."
source ${CHECK_RESULTS_LIB}

platform=$(print_build_platform_name)
if [ $? -ne 0 ]
then
  exit 1
fi

EXPECTED_ARTIFACTS_FILE=${TEST_PROJECT_DIR}/../testconfigs/ExpectedArtifacts.${platform}
check_build_dir_artifacts ${EXPECTED_ARTIFACTS_FILE}
