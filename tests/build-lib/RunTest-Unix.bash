#!/bin/bash

set -e

MODE=$1
TEST_PROJECT_DIR=$2
CHECK_RESULTS_LIB=$3
CMAKE_GENERATOR=$4

echo "Running in $(pwd) with test project dir ${TEST_PROJECT_DIR} and mode ${MODE}"


if [ -e build-lib-${MODE} ]
then
  rm -r build-lib-${MODE}
fi

mkdir build-lib-${MODE} && cd build-lib-${MODE}
cmake -DLIB_BUILD_MODE=${MODE} -G "${CMAKE_GENERATOR}" ${TEST_PROJECT_DIR}
cmake --build .


echo "Checking results..."
source ${CHECK_RESULTS_LIB}
platform=$(print_build_platform_name)
EXPECTED_ARTIFACTS_FILE=${TEST_PROJECT_DIR}/../testconfigs/${MODE}/ExpectedArtifacts.${platform}
check_build_dir_artifacts ${EXPECTED_ARTIFACTS_FILE}
