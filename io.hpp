#pragma once

extern "C" {
unsigned char insb(unsigned short port);
unsigned char insw(unsigned short port);

void outb(unsigned short port, unsigned char val);
void outw(unsigned short port, unsigned short val);
}
