#!/bin/bash

set -e

TEST_PROJECT_DIR=$1
CHECK_RESULTS_LIB=$2
CMAKE_GENERATOR=$3

echo "Running in $(pwd) with test project dir ${TEST_PROJECT_DIR}"


if [ -e add-gtest ]
then
  rm -r add-gtest
fi

mkdir add-gtest && cd add-gtest
cmake -G "${CMAKE_GENERATOR}" -DCMAKE_BUILD_TYPE=Debug ${TEST_PROJECT_DIR}
cmake --build . --config Debug

if [[ "${CMAKE_GENERATOR}" == Visual* ]]
then
  bin/Debug/testbin.exe
else
  bin/testbin
fi
