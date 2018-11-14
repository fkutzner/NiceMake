
#
# test_nm_detail_check_for_interface_generator(<input> <expected_result>)
#
# Causes a fatal error iff
# `nm_detail_check_for_interface_generator(<input> result)` causes `result` to
# differ from `<expected_result>`.
#
function(test_nm_detail_check_for_interface_generator_expr INPUT_STR EXPECTED_RESULT)
  nm_detail_check_for_interface_generator_expr("${INPUT_STR}" result)
  if(NOT "${result}" STREQUAL "${EXPECTED_RESULT}")
    message(FATAL_ERROR "nm_detail_check_for_interface_generator(\"${INPUT_STR}\" result) produced result=${result}, expected: result=${EXPECTED_RESULT}")
  endif()
endfunction()

test_nm_detail_check_for_interface_generator_expr("" FALSE)
test_nm_detail_check_for_interface_generator_expr("SingleStr" FALSE)
test_nm_detail_check_for_interface_generator_expr("ListStr1;ListStr2" FALSE)
test_nm_detail_check_for_interface_generator_expr("LBUILD_INTERFACE2" FALSE)
test_nm_detail_check_for_interface_generator_expr("LINSTALL_INTERFACE2" FALSE)
test_nm_detail_check_for_interface_generator_expr("L<INSTALL_INTERFACE2" FALSE)
test_nm_detail_check_for_interface_generator_expr("L<BUILD_INTERFACE2" FALSE)
test_nm_detail_check_for_interface_generator_expr("L$<INSTALL_INTERFACE2" FALSE)
test_nm_detail_check_for_interface_generator_expr("L$<BUILD_INTERFACE2" FALSE)
test_nm_detail_check_for_interface_generator_expr("L<INSTALL_INTERFACE2>" FALSE)
test_nm_detail_check_for_interface_generator_expr("L<BUILD_INTERFACE2>" FALSE)
test_nm_detail_check_for_interface_generator_expr("\$<BUILD_INTERFACE:foo;bar>" TRUE)
test_nm_detail_check_for_interface_generator_expr("\$<INSTALL_INTERFACE:foo;bar>" TRUE)
test_nm_detail_check_for_interface_generator_expr("foo;\$<BUILD_INTERFACE:foo;bar>" TRUE)
test_nm_detail_check_for_interface_generator_expr("foo;\$<INSTALL_INTERFACE:foo;bar>" TRUE)
test_nm_detail_check_for_interface_generator_expr("foo;\$<BUILD_INTERFACE:foo;bar>baz" TRUE)
test_nm_detail_check_for_interface_generator_expr("foo;\$<INSTALL_INTERFACE:foo;bar>baz" TRUE)
test_nm_detail_check_for_interface_generator_expr("foo;\$<BUILD_INTERFACE:foo;bar>baz\$<BUILD_INTERFACE:foo;bar>" TRUE)
test_nm_detail_check_for_interface_generator_expr("foo;\$<INSTALL_INTERFACE:foo;bar>baz\$<BUILD_INTERFACE:foo;bar>" TRUE)
