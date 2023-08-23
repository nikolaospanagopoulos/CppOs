[BITS 32]
global init_pm
extern kernel_main
init_pm:
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

	; remap master pic
	mov al, 00010001b
    out 0x20, al ; Tell master PIC

    mov al, 0x20 ; Interrupt 0x20 is where master ISR should start
    out 0x21, al

    mov al, 00000001b
    out 0x21, al

    sti
    call kernel_main
    jmp $
times 512-($ - $$) db 0
