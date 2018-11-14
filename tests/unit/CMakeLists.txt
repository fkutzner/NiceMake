# Tests for individual NiceMake helper functions

add_test(
  NAME unit
  COMMAND bash ${CMAKE_CURRENT_SOURCE_DIR}/RunTest-Unix.bash
               ${CMAKE_CURRENT_SOURCE_DIR}/project
               ${CMAKE_GENERATOR}
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)
