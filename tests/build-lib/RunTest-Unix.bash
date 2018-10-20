#!/bin/bash

set -e

MODE=$1
TEST_PROJECT_DIR=$2
CHECK_RESULTS_LIB=$3

echo "Running in $(pwd) with test project dir ${TEST_PROJECT_DIR} and mode ${MODE}"


if [ -e build-lib-${MODE} ]
then
  rm -r build-lib-${MODE}
fi

mkdir build-lib-${MODE} && cd build-lib-${MODE}
cmake -DLIB_BUILD_MODE=${MODE} ${TEST_PROJECT_DIR}
cmake --build .

EXPECTED_ARTIFACTS_FILE=${TEST_PROJECT_DIR}/../testconfigs/${MODE}/ExpectedArtifacts.$(uname)
source ${CHECK_RESULTS_LIB}

echo "Checking results..."
check_build_dir_artifacts ${EXPECTED_ARTIFACTS_FILE}
