#include "Terminal.hpp"
#include "String.hpp"

static inline uint8_t vga_entry_color(enum Terminal::vga_color fg, enum Terminal::vga_color bg) {
  return fg | bg << 4;
}

static inline uint16_t vga_entry(unsigned char uc, uint8_t color) {
  return (uint16_t)uc | (uint16_t)color << 8;
}


static const size_t VGA_WIDTH = 80;
static const size_t VGA_HEIGHT = 25;

Terminal::Terminal() {
  terminal_row = 0;
  terminal_column = 0;
  terminal_color = vga_entry_color(vga_color::VGA_COLOR_RED, vga_color::VGA_COLOR_BLACK);
  terminal_buffer = (uint16_t *)0xB8000;
  for (size_t y = 0; y < VGA_HEIGHT; y++) {
    for (size_t x = 0; x < VGA_WIDTH; x++) {
      const size_t index = y * VGA_WIDTH + x;
      terminal_buffer[index] = vga_entry(' ', terminal_color);
    }
  }
}

void Terminal::terminal_setcolor(uint8_t color) { terminal_color = color; }

void Terminal::terminal_putentryat(char c, uint8_t color, size_t x, size_t y) {
  const size_t index = y * VGA_WIDTH + x;
  terminal_buffer[index] = vga_entry(c, color);
}

void Terminal::terminal_putchar(char c) {
  if (c == '\n') {
    terminal_column = 0;
    terminal_row += 1;
    return;
  }
  terminal_putentryat(c, terminal_color, terminal_column, terminal_row);
  if (++terminal_column == VGA_WIDTH) {
    terminal_column = 0;
    if (++terminal_row == VGA_HEIGHT) {
      terminal_row--;
      scrollUp();
    }
  }
}

void Terminal::terminal_write(const char *data, size_t size) {
  for (size_t i = 0; i < size; i++)
    terminal_putchar(data[i]);
}
void Terminal::terminal_writestring(const char *data) {
  terminal_write(data,String::strlen(data));
}
void Terminal::scrollUp() {
  // Move all rows up by one row and clear the last row
  for (size_t y = 1; y < VGA_HEIGHT; y++) {
    for (size_t x = 0; x < VGA_WIDTH; x++) {
      const size_t dest_index = (y - 1) * VGA_WIDTH + x;
      const size_t src_index = y * VGA_WIDTH + x;
      terminal_buffer[dest_index] = terminal_buffer[src_index];
    }
  }

  // Clear the last row
  size_t last_row_index = (VGA_HEIGHT - 1) * VGA_WIDTH;
  for (size_t x = 0; x < VGA_WIDTH; x++) {
    terminal_buffer[last_row_index + x] = vga_entry(' ', terminal_color);
  }
}
