global init_pm
extern kernel_main
[BITS 32]
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

    call kernel_main
    jmp $
