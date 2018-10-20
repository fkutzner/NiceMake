# Test that third-party libraries are linked and their exported definitions
# are added to the target library 

if(UNIX)
  add_test(
    NAME thirdparty-lib
    COMMAND bash ${CMAKE_CURRENT_SOURCE_DIR}/RunTest-Unix.bash
                 ${CMAKE_CURRENT_SOURCE_DIR}/project
                 ${CMAKE_CURRENT_SOURCE_DIR}/../CheckResults.bash
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  )
endif()
