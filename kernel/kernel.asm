[BITS 32]

global _start
global kernel_main

_start:
    call kernel_main
    jmp $

times 512 - ($ - $$) db 0
