#pragma once
#include <stdint.h>

#define PAGE_SIZE 4096 // 4 kb
#define FREE 0x00
#define USED 0x01
#define ERROR ((pageframe_t)-1)
typedef uint32_t pageframe_t;

// Estimate numframes based on the maximum addressable memory in a 32-bit x86
// system
#define MAX_ADDRESSABLE_MEMORY_BYTES                                           \
  0xFFFFFFFF // 4 GiB (maximum 32-bit addressable memory)
#define NUM_FRAMES (MAX_ADDRESSABLE_MEMORY_BYTES / PAGE_SIZE)
extern "C" {
void initFrameAllocator();
pageframe_t kallocFrameInt();
pageframe_t kallocFrame();
void kfree(pageframe_t a);
}
