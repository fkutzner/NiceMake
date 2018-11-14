set -e

TEST_PROJECT_DIR=$1
CMAKE_GENERATOR=$2

echo "Running in $(pwd) with test project dir ${TEST_PROJECT_DIR}"


if [ -e thirdparty-lib ]
then
  rm -r thirdparty-lib
fi

mkdir thirdparty-lib && cd thirdparty-lib
cmake -G "${CMAKE_GENERATOR}" -DCMAKE_BUILD_TYPE=Debug ${TEST_PROJECT_DIR}
cmake --build . --config Debug
