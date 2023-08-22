
#include "pageFrameAllocator.hpp"
extern "C" {
#include "String.hpp"
#include "Terminal.hpp"
#include "idt.hpp"
#include "kernel.hpp"
}
#if defined(__linux__)
#error                                                                         \
    "You are not using a cross-compiler, you will most certainly run into trouble"
#endif

/* This tutorial will only work for the 32-bit ix86 targets. */
#if !defined(__i386__)
#error "This tutorial needs to be compiled with a ix86-elf compiler"
#endif

Terminal *terminal = nullptr;

void print(const char *message) { terminal->terminal_writestring(message); }

void initializeTerminal() { *terminal = Terminal{}; }
extern "C" {
void kernel_main(void) {
  /* Initialize terminal interface */
  initializeTerminal();
  print("1. Entering protected mode\n");
  print("2. Terminal initialized\n");

  initFrameAllocator();
  print("3. Frame allocator initialized\n");

  initIdt();
  print("4. Interrupts enabled\n");
}
}
