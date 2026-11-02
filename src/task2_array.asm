%include "asm_io.inc"

%define ARRAY_SIZE 100

segment .data
    message db "The sum of 1 to 100 is: ", 0

segment .bss
    numbers resd ARRAY_SIZE    ; GIVES 100FOUR BYTE INTEGERS
    result  resd 1

segment .text
    global asm_main

asm_main:
    enter 0, 0
    pusha

    ; Fill the array with the numbers 1 to 100
    mov esi, 0                ; ARRAY STARTS AT 0
    mov eax, 1                ; STORES FIREST

.fill_array:
    mov [numbers + esi*4], eax
    inc eax                   ; NEXT NUMBER
    inc esi                   ; ARRAY 2

    cmp esi, ARRAY_SIZE
    jl .fill_array

    ; ADDS ALL THE STORED ELEMENTS
    mov esi, 0                ; Start at the first element
    mov eax, 0                ; Running total starts at zero

.sum_array:
    add eax, [numbers + esi*4]
    inc esi

    cmp esi, ARRAY_SIZE
    jl .sum_array

    mov [result], eax

    ; Display the result
    mov eax, message
    call print_string

    mov eax, [result]
    call print_int
    call print_nl

    popa
    mov eax, 0
    leave
    ret