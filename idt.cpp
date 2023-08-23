#include "io.hpp"
extern "C" {
#include "Memory.hpp"
#include "idt.hpp"
#include "kernel.hpp"
}
extern "C" void idtLoad(void *ptr);
extern "C" void int21h();
extern "C" void noInterrupt();
IdtDescriptor idtDescriptors[512];
IdtrDesc idtrDescriptor;

IdtDescriptor::IdtDescriptor()
    : offset1(0), selector(0), zero(0), typeAttr(0), offset2(0) {}

IdtDescriptor::IdtDescriptor(uint16_t offset1, uint16_t selector, uint8_t zero,
                             uint8_t typeAttr, uint16_t offset2)
    : offset1(offset1), selector(selector), zero(zero), typeAttr(typeAttr),
      offset2(offset2) {}

void idtZero() { print("devide by zero error"); }
extern "C" {
void noInterruptHandler() { outb(0x20, 0x20); }
void int21Handler() {
  print("keyboard pressed\n");
  outb(0x20, 0x20);
}
}
void (*idtZeroPtr)() = &idtZero;
void IdtDescriptor::setDescriptor(uint16_t off1, uint16_t selec, uint8_t zer,
                                  uint8_t typeAtt, uint16_t off2) {
  offset1 = off1;
  selector = selec;
  zero = zer;
  typeAttr = typeAtt;
  offset2 = off2;
}

void idtSet(int interruptNo, void *address) {
  IdtDescriptor *desc = &idtDescriptors[interruptNo];
  desc->setDescriptor((uint32_t)address & 0x0000ffff, 0x08, 0x00, 0xEE,
                      (uint32_t)address >> 16);
}

void initIdt() {
  Memory::memset(idtDescriptors, 0, sizeof(idtDescriptors));
  idtrDescriptor.limit = sizeof(idtDescriptors) - 1;
  idtrDescriptor.base = (uint32_t)idtDescriptors;
  for (int i{}; i < 512; i++) {
    idtSet(i, (void *)noInterrupt);
  }
  idtSet(0, (void *)idtZero);
  idtSet(0x21, (void *)int21h);
  idtLoad(&idtrDescriptor);
}
