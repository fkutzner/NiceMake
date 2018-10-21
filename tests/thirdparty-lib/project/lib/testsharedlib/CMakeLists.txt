nm_add_lib_compile_options(PUBLIC -DNM_SHARED_LIB)
nm_add_lib_compile_options(PRIVATE -DBUILDING_NM_SHARED_LIB)

add_subdirectory(objsharedlib)

nm_add_library(testsharedlib SHARED Shared.cpp $<TARGET_OBJECTS:testsharedlib.objsharedlib>)
