; This is a basic bootloader for displaying text on the screen
bits 16
org 0x7c00

; Initialize the pointer
mov si, 0

; Main loop to display text
display_text:
    mov ah, 0x0e         ; Function to output a character to the screen
    mov al, [text + si]  ; Character to display
    int 0x10             ; BIOS interrupt call
    add si, 1            ; Move to the next character
    cmp byte [text + si], 0 ; Check for end of string
    jne display_text     ; If not end, continue

; Infinite loop
jmp $

; Text to display
text:
    db "Hello, World!", 0

; Fill remaining space with zeros and set bootloader signature
times 510 - ($ - $$) db 0
dw 0xAA55
