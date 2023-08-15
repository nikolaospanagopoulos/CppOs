#pragma once
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

size_t strlen(const char *str);
class Terminal {
private:
  size_t terminal_row;
  size_t terminal_column;
  uint8_t terminal_color;
  uint16_t *terminal_buffer;
  void terminal_setcolor(uint8_t color);
  void terminal_putentryat(char c, uint8_t color, size_t x, size_t y);
  void terminal_putchar(char c);
  void terminal_write(const char *data, size_t size);

public:
  Terminal();
  void terminal_writestring(const char *data);
};
