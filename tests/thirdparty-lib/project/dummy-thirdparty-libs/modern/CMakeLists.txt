add_library(modern-thirdparty-lib STATIC ModernThirdParty.cpp)
target_include_directories(modern-thirdparty-lib PUBLIC ${PROJECT_SOURCE_DIR}/dummy-thirdparty-libs/modern)
target_compile_options(modern-thirdparty-lib PUBLIC -DHAVE_MODERN_TPL)
