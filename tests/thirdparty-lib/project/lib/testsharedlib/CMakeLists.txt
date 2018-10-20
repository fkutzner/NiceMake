nm_add_lib_compiler_flags(PUBLIC -DNM_SHARED_LIB)
nm_add_lib_compiler_flags(PRIVATE -DBUILDING_NM_SHARED_LIB)

add_subdirectory(objsharedlib)

nm_add_library(testsharedlib SHARED Shared.cpp $<TARGET_OBJECTS:testsharedlib.objsharedlib>)
