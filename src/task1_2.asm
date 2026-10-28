%include "asm_io.inc"

segment .data
    prompt db "Enter a number: ", 0
    msg1   db "The sum of ", 0
    msg2   db " and ", 0
    msg3   db " is: ", 0

segment .bss
    integer1 resd 1
    integer2 resd 1
    result   resd 1

segment .text
    global asm_main

asm_main:
    enter 0, 0
    pusha

    ; Ask for and store the first number
    mov eax, prompt
    call print_string
    call read_int
    mov [integer1], eax

    ; Ask for and store the second number
    mov eax, prompt
    call print_string
    call read_int
    mov [integer2], eax

    ; Calculate and store the sum
    mov eax, [integer1]
    add eax, [integer2]
    mov [result], eax

    ; Display the calculation
    mov eax, msg1
    call print_string
    mov eax, [integer1]
    call print_int

    mov eax, msg2
    call print_string
    mov eax, [integer2]
    call print_int

    mov eax, msg3
    call print_string
    mov eax, [result]
    call print_int
    call print_nl

    popa
    mov eax, 0
    leave
    ret