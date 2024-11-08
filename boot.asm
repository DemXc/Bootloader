[BITS 16]
[ORG 0x7c00]

CODE_OFFSET equ 0x8
DATA_OFFSET equ 0x10

KERNEL_LOAD_SEG equ 0x10000
KERNEL_START_ADDR equ 0x1000

start:
    cli
    mov ax, 0x00
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00

    mov ax, 0x0600
    mov bh, 0x07
    mov cx, 0x0000
    mov dx, 0x184F
    int 0x10

   ; mov ah, 0x0E
   ; mov al, 'X'
   ; int 0x10

    mov si, text
    call print

    mov dx, KERNEL_LOAD_SEG
    mov dh, 0x00
    mov dl, 0x80
    mov cl, 0x02
    mov ch, 0x00
    mov ah, 0x02
    mov al, 8
    int 0x13

    load_protected_mode:
        cli
        lgdt [gdt_descriptor]
        mov eax, cr0
        or al, 1
        mov cr0, eax
        jmp CODE_OFFSET:protected_mode_main

print:
    lodsb
    cmp al, 0
    je done
    mov ah, 0x0E
    int 0x10
    jmp print

done:
    cli
    hlt

text db 'Welcome to NkOs', 0

gdt_start:
    db 0x00, 0x00, 0x00, 0x00
    db 0xFF, 0xFF, 0xFF, 0x00
    db 0x00, 0x00, 0x00, 0x00

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

[BITS 32]
protected_mode_main:
    mov ax, DATA_OFFSET
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov ss, ax
    mov gs, ax
    mov ebp, 0x9C00
    mov esp, ebp

    jmp $

times 510 - ($ - $$) db 0
dw 0xAA55
