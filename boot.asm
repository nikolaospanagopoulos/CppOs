;Multiboot Standard
;easy interface between bootloader and kernel
;just put magic values in multiboot header
;the bootloader sees these values, and recognises kernel as multiboot


; Declare constants for the multiboot header.
MBALIGN  equ  1 << 0            ; align loaded modules on page boundaries
MEMINFO  equ  1 << 1            ; provide memory map
MBFLAGS  equ  MBALIGN | MEMINFO ; this is the Multiboot 'flag' field
MAGIC    equ  0x1BADB002        ; 'magic number' lets bootloader find the header
CHECKSUM equ -(MAGIC + MBFLAGS)   ; checksum of above, to prove we are multiboot
 
; Declare a multiboot header that marks the program as a kernel. These are magic
; values that are documented in the multiboot standard. The bootloader will
; search for this signature in the first 8 KiB of the kernel file, aligned at a
; 32-bit boundary. The signature is in its own section so the header can be
; forced to be within the first 8 KiB of the kernel file.
section .multiboot
align 4
	dd MAGIC
	dd MBFLAGS
	dd CHECKSUM
 
; The multiboot standard does not define the value of the stack pointer register
; (esp) and it is up to the kernel to provide a stack. This allocates room for a
; small stack by creating a symbol at the bottom of it, then allocating 16384
; bytes for it, and finally creating a symbol at the top. The stack grows
; downwards on x86. The stack is in its own section so it can be marked nobits,
; which means the kernel file is smaller because it does not contain an
; uninitialized stack. The stack on x86 must be 16-byte aligned according to the
; System V ABI standard and de-facto extensions. The compiler will assume the
; stack is properly aligned and failure to align the stack will result in
; undefined behavior.
VGA_TEXT_MEM_BASE equ 0xb8000
TEXT_ATTR         equ 0x4f
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
section .data
hello db "Hello, Multiboot World!", 0
gdt_start:              ; Define a label at the start of the GDT
    dd 0                ; Null segment descriptor (required)
    dd 0

gdt_code:               ; Code segment descriptor
    dw 0xFFFF           ; Limit low (16 bits of segment limit)
    dw 0                ; Base low (16 bits of base address)
    db 0                ; Base middle
    db 10011010b        ; Access byte (Present, Ring 0, Code, Executable)
    db 11001111b        ; Granularity byte (4KB granularity, 32-bit mode)
    db 0                ; Base high

gdt_data:               ; Data segment descriptor
    dw 0xFFFF           ; Limit low (16 bits of segment limit)
    dw 0                ; Base low (16 bits of base address)
    db 0                ; Base middle
    db 10010010b        ; Access byte (Present, Ring 0, Data, Read/Write)
    db 11001111b        ; Granularity byte (4KB granularity, 32-bit mode)
    db 0                ; Base high

gdt_end:                ; Define a label at the end of the GDT

gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; Size of GDT - 1
    dd gdt_start            ; Address of the GDT
section .bss
align 16
stack_bottom:
resb 16384 ; 16 KiB
stack_top:
 
; The linker script specifies _start as the entry point to the kernel and the
; bootloader will jump to this position once the kernel has been loaded. It
; doesn't make sense to return from this function as the bootloader is gone.
; Declare _start as a function symbol with the given symbol size.
section .text

print_message:
    ; Clear the screen
    mov edi, VGA_TEXT_MEM_BASE
    mov eax, TEXT_ATTR | (' ' << 8)
    mov ecx, 80 * 25
    rep stosd

    ; Print a new message
    mov edi, VGA_TEXT_MEM_BASE + (80 * 10 + 20) * 2 ; Adjust row and column
    mov esi, hello
    mov ecx, 0
    .print_loop:
        mov al, byte [esi + ecx]
        test al, al
        jz .print_done
        mov ah, TEXT_ATTR
        mov [edi], ax
        add edi, 2
        inc ecx
        jmp .print_loop
    .print_done:
    ret


global _start:function (_start.end - _start)
_start:
	; The bootloader has loaded us into 32-bit protected mode on a x86
	; machine. Interrupts are disabled. Paging is disabled. The processor
	; state is as defined in the multiboot standard. The kernel has full
	; control of the CPU. The kernel can only make use of hardware features
	; and any code it provides as part of itself. There's no printf
	; function, unless the kernel provides its own <stdio.h> header and a
	; printf implementation. There are no security restrictions, no
	; safeguards, no debugging mechanisms, only what the kernel provides
	; itself. It has absolute and complete power over the
	; machine.
 
	; To set up a stack, we set the esp register to point to the top of our
	; stack (as it grows downwards on x86 systems). This is necessarily done
	; in assembly as languages such as C cannot function without a stack.
	cli
	mov esp, stack_top
	lgdt [gdt_descriptor]
	mov eax, cr0
    or eax, 0x1
    mov cr0, eax
	  ; Enable protected mode
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
	jmp CODE_SEG:.init_pm
    ; Load segment selectors for code and data segments


.init_pm:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
	mov ebp, 0x90000
    mov esp, ebp
	in al, 0x92
    or al, 2
    out 0x92, al



extern kernel_main
call kernel_main
 
 
	cli
.hang:	hlt
	jmp .hang
.end:
