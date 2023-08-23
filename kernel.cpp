
extern "C" {
#include "kernel.hpp"
#include "Heap.hpp"
#include "String.hpp"
#include "Terminal.hpp"
#include "idt.hpp"
#include "io.hpp"
#include "pageFrameAllocator.hpp"
}
#if defined(__linux__)
#error                                                                         \
    "You are not using a cross-compiler, you will most certainly run into trouble"
#endif

/* This tutorial will only work for the 32-bit ix86 targets. */
#if !defined(__i386__)
#error "This tutorial needs to be compiled with a ix86-elf compiler"
#endif

Terminal *terminal;

void printDebug(const char *debugMessage) {
  for (size_t i{}; i < String::strlen(debugMessage); i++) {
    outb(0x3F8, debugMessage[i]);
  }
}
void print(const char *message) { terminal->terminal_writestring(message); }
void initializeTerminal() { *terminal = Terminal{}; }
extern "C" {
void kernel_main(void) {

  initializeTerminal();
  initFrameAllocator();
  initIdt();
}
}
