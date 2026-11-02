%include "asm_io.inc"

%define ARRAY_SIZE 100

segment .data
    start_prompt db "Enter the start of the range (1-100): ", 0
    end_prompt   db "Enter the end of the range (1-100): ", 0
    message      db "The sum of the range is: ", 0
    error_msg    db "Invalid range. Use 1-100 with start <= end.", 0

segment .bss
    numbers     resd ARRAY_SIZE
    range_start resd 1
    range_end   resd 1
    result      resd 1

segment .text
    global asm_main

asm_main:
    enter 0, 0
    pusha

    ; POpulates with values from 1 to 100
    mov esi, 0
    mov eax, 1

.fill_array:
    mov [numbers + esi*4], eax
    inc eax
    inc esi

    cmp esi, ARRAY_SIZE
    jl .fill_array

    ; THe starting value
    mov eax, start_prompt
    call print_string
    call read_int
    mov [range_start], eax

    ; COnfirms the start is between the range, 1-100
    cmp eax, 1
    jl .invalid_range
    cmp eax, ARRAY_SIZE
    jg .invalid_range

    ; Read the ending value
    mov eax, end_prompt
    call print_string
    call read_int
    mov [range_end], eax

    ; Check that the end is between 1 and 100
    cmp eax, 1
    jl .invalid_range
    cmp eax, ARRAY_SIZE
    jg .invalid_range

    ; THe end cannot be below the start
    cmp eax, [range_start]
    jl .invalid_range

    ; Convert the starting value to a zero-based index
    mov esi, [range_start]
    dec esi

    mov eax, 0              ; Running total

.sum_range:
    add eax, [numbers + esi*4]
    inc esi


    cmp esi, [range_end]
    jl .sum_range

    mov [result], eax

    ; Print the total
    mov eax, message
    call print_string

    mov eax, [result]
    call print_int
    call print_nl

    jmp .finish

.invalid_range:
    mov eax, error_msg
    call print_string
    call print_nl

.finish:
    popa
    mov eax, 0
    leave
    ret