nm_add_tool(run Run.cpp)
target_link_libraries(run PRIVATE testsharedlib teststaticlib)
