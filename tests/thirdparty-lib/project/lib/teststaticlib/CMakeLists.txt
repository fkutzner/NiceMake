if (NOT CMAKE_VERSION VERSION_LESS "3.12")
  add_subdirectory(objlib)
  set(objlib_files $<TARGET_OBJECTS:teststaticlib.objlib>)
else()
  set(objlib_files objlib/Obj.cpp)
endif()

nm_add_library(teststaticlib STATIC Static.cpp ${objlib_files})
