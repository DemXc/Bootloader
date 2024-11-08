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

    ; Очищаем экран
    mov ax, 0x0600
    mov bh, 0x07
    mov cx, 0x0000
    mov dx, 0x184F
    int 0x10

    ; Печать тестового символа для отладки
    mov ah, 0x0E    ; Функция 0x0E для печати символа
    mov al, 'X'     ; Печатаем символ 'X'
    int 0x10        ; Вызываем BIOS для печати

    ; Печать сообщения в реальном режиме
    mov si, text
    call print

    ; Загрузка ядра с диска
    mov dx, KERNEL_LOAD_SEG
    mov dh, 0x00
    mov dl, 0x80
    mov cl, 0x02
    mov ch, 0x00
    mov ah, 0x02
    mov al, 8
    int 0x13

    ; Переход в защищённый режим
    load_protected_mode:
        cli
        lgdt [gdt_descriptor]
        mov eax, cr0
        or al, 1
        mov cr0, eax
        jmp CODE_OFFSET:protected_mode_main

; Печать сообщения
print:
    lodsb           ; Загружаем байт текста в AL
    cmp al, 0       ; Проверяем конец строки (0)
    je done         ; Если конец строки, выходим
    mov ah, 0x0E    ; Функция 0x0E BIOS для вывода символа
    int 0x10        ; Вызываем BIOS
    jmp print       ; Повторяем для следующего символа

done:
    cli
    hlt             ; Останавливаем выполнение

text db 'Welcome to NkOs', 0

; Описание GDT
gdt_start:
    db 0x00, 0x00, 0x00, 0x00      ; Пустой сегмент
    db 0xFF, 0xFF, 0xFF, 0x00      ; Кодовый сегмент
    db 0x00, 0x00, 0x00, 0x00      ; Данные

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

[BITS 32]
protected_mode_main:
    ; Устанавливаем сегментные регистры в защищённом режиме
    mov ax, DATA_OFFSET
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov ss, ax
    mov gs, ax
    mov ebp, 0x9C00
    mov esp, ebp

    ; Бесконечный цикл для демонстрации
    jmp $

times 510 - ($ - $$) db 0
dw 0xAA55
