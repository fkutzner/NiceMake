#!/bin/bash

set -e

TEST_PROJECT_DIR=$1
CHECK_RESULTS_LIB=$2

echo "Running in $(pwd) with test project dir ${TEST_PROJECT_DIR}"


if [ -e add-gtest ]
then
  rm -r add-gtest
fi

mkdir add-gtest && cd add-gtest
cmake ${TEST_PROJECT_DIR}
cmake --build .
bin/testbin
