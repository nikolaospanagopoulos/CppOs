#pragma once

#include "kernel.hpp"
#include <stdint.h>
class IdtDescriptor {
public:
  uint16_t offset1;  // offset bits 0-15
  uint16_t selector; // selector in the GDT
  uint8_t zero;      // set to 0
  uint8_t typeAttr;  // Descriptor type and attributes
  uint16_t offset2;  // offset bits 16 - 31
  IdtDescriptor(uint16_t offset1, uint16_t selector, uint8_t zero,
                uint8_t typeAttr, uint16_t offset2);
  IdtDescriptor();
  void setDescriptor(uint16_t offset1, uint16_t selector, uint8_t zero,
                     uint8_t typeAttr, uint16_t offset2);
};

class IdtrDesc {
public:
  uint16_t limit; // size of the descriptor table -1
  uint32_t base;  // base address of the start of the idt

} __attribute__((packed));
void init(Terminal*ter);
