#pragma once

#include <stddef.h>
class Memory {
public:
  static void *memset(void *ptr, int c, size_t size);
};
