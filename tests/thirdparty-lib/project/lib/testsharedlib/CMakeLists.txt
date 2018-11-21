nm_add_lib_compile_options(PUBLIC -DNM_SHARED_LIB)
nm_add_lib_compile_options(PRIVATE -DBUILDING_NM_SHARED_LIB)

if (NOT CMAKE_VERSION VERSION_LESS "3.12")
  add_subdirectory(objsharedlib)
  set(objlib_files $<TARGET_OBJECTS:testsharedlib.objsharedlib>)
else()
  set(objlib_files objsharedlib/ObjShared.cpp)
endif()


nm_add_library(testsharedlib SHARED Shared.cpp ${objlib_files})
