# Thest that nm_add_library actually creates the desired libraries
# and sets up include paths.

foreach(mode IN ITEMS STATIC SHARED OBJECT OBJECT-STATIC OBJECT-SHARED)
  if(UNIX)
    add_test(
      NAME build-lib-${mode}
      COMMAND bash ${CMAKE_CURRENT_SOURCE_DIR}/RunTest-Unix.bash
                   ${mode}
                   ${CMAKE_CURRENT_SOURCE_DIR}/project
                   ${CMAKE_CURRENT_SOURCE_DIR}/../CheckResults.bash
      WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    )
  endif()
endforeach()
