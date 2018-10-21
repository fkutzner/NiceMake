#include <testlib/testmodule/Foo.h>

int getMagicNumber() {
  return MAGIC_NUMBER_A + MAGIC_NUMBER_B; // MAGIC_NUMBER_x is defined via compiler flags
}
