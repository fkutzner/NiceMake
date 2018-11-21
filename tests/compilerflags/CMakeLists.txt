# Test that compiler-flag-setting function

add_test(
  NAME compilerflags
  COMMAND bash ${CMAKE_CURRENT_SOURCE_DIR}/RunTest-Unix.bash
               ${CMAKE_CURRENT_SOURCE_DIR}/project
               ${CMAKE_CURRENT_SOURCE_DIR}/../CheckResults.bash
               ${CMAKE_GENERATOR}
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)
