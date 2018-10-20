# Test that google test can be downloaded, built and linked

if(UNIX)
  add_test(
    NAME add-gtest
    COMMAND bash ${CMAKE_CURRENT_SOURCE_DIR}/RunTest-Unix.bash
                 ${CMAKE_CURRENT_SOURCE_DIR}/project
                 ${CMAKE_CURRENT_SOURCE_DIR}/../CheckResults.bash
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  )
endif()
