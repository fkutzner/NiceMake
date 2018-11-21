#!/bin/bash

set -e

TEST_PROJECT_DIR=$1
CHECK_RESULTS_LIB=$2
CMAKE_GENERATOR=$3

echo "Running in $(pwd) with test project dir ${TEST_PROJECT_DIR} and mode ${MODE}"


if [ -e compilerflags ]
then
  rm -r compilerflags
fi

mkdir compilerflags && cd compilerflags
cmake -G "${CMAKE_GENERATOR}" -DCMAKE_BUILD_TYPE=Debug ${TEST_PROJECT_DIR}
cmake --build . --config Debug
