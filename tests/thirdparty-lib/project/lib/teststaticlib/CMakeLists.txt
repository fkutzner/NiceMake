add_subdirectory(objlib)

nm_add_library(teststaticlib STATIC Static.cpp $<TARGET_OBJECTS:teststaticlib.objlib>)
