add_subdirectory(objsharedlib)

nm_add_library(testsharedlib SHARED Shared.cpp $<TARGET_OBJECTS:testsharedlib.objsharedlib>)
