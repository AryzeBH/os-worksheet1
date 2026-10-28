%include "asm_io.inc"

segment .data
    integer1 dd 15          ; First 32-bit integer
    integer2 dd 6           ; Second 32-bit integer

segment .bss
    result resd 1           ; Reserve space for the result

segment .text
    global asm_main

asm_main:
    enter 0, 0
    pusha                   ; Save general-purpose registers

    mov eax, [integer1]     ; Load 15 into EAX
    add eax, [integer2]     ; Add 6: EAX now holds 21
    mov [result], eax       ; Store 21 in memory

    call print_int         ; Print the integer in EAX
    call print_nl          ; Print a newline

    popa                    ; Restore saved registers
    mov eax, 0              ; Return success to C
    leave
    ret