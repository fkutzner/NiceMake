#include <testlib/testmodule/Foo.h>

#include <iostream>
#include <cstdlib>

#if defined(HAVE_MAGIC_NUMBER) && !defined(MAGIC_NUMBER)
  #error "MAGIC_NUMBER is not defined, but should be since this target links against a library containing its definition in its public compiler flags"
#endif

int main(int argc, char **argv) {
  std::cout << getMagicNumber() << "\n";
  return EXIT_SUCCESS;
}
