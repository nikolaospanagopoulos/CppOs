#include "Memory.hpp"

void *Memory::memset(void *ptr, int c, size_t size) {
  char *charPtr = (char *)ptr;
  for (size_t i = 0; i < size; i++) {
    charPtr[i] = char(c);
  }
  return ptr;
}
