#include "pageFrameAllocator.hpp"
#include <stdint.h>

static uint8_t frameMap[NUM_FRAMES];
static pageframe_t preframes[20]; // Array to hold preallocated frames
extern uint32_t endkernel;
static pageframe_t startframe;

void initFrameAllocator() {
  for (uint32_t i = 0; i < NUM_FRAMES; i++) {
    frameMap[i] = FREE;
  }
  startframe = (endkernel / PAGE_SIZE) + 1;
}

pageframe_t kallocFrameInt() {
  for (uint32_t i = 0; i < NUM_FRAMES; i++) {
    if (frameMap[i] == FREE) {
      frameMap[i] = USED;
      return startframe + (i * PAGE_SIZE);
    }
  }
  return ERROR;
}

pageframe_t kallocFrame() {
  static uint8_t allocate = 1;
  static uint8_t pframe = 0;
  pageframe_t ret;
  if (pframe == 20) {
    allocate = 1;
  }
  if (allocate == 1) {
    for (int i{}; i < 20; i++) {
      preframes[i] = kallocFrameInt();
    }
    pframe = 0;
    allocate = 0;
  }
  ret = preframes[pframe];
  pframe++;
  return ret;
}

void kfree(pageframe_t a) {
  a = a - startframe;
  if (a == 0) {
    frameMap[0] = FREE;
  } else {
    uint32_t index = a / PAGE_SIZE;
    frameMap[index] = FREE;
  }
}
