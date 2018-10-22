# Test that nm_add_tool actually creates the desired tool

add_test(
  NAME build-tool
  COMMAND bash ${CMAKE_CURRENT_SOURCE_DIR}/RunTest-Unix.bash
               ${CMAKE_CURRENT_SOURCE_DIR}/project
               ${CMAKE_CURRENT_SOURCE_DIR}/../CheckResults.bash
               ${CMAKE_GENERATOR}
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)
