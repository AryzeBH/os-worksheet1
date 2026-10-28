%include "asm_io.inc"

segment .data
    name_prompt  db "Enter your name: ", 0
    count_prompt db "Enter a number from 51 to 99: ", 0
    welcome      db "Welcome, ", 0
    error_msg    db "Error: the number must be from 51 to 99.", 0

segment .bss
    name_buffer resb 64
    count       resd 1

segment .text
    global asm_main

asm_main:
    enter 0, 0
    pusha

    ; gets name
    mov eax, name_prompt
    call print_string


    mov esi, 0

.read_name:
    call read_char          ; Read one character into AL

    cmp al, 10              ; Enter produces a newline character
    je .name_done

    cmp esi, 63             ; Leave space for the terminating zero
    jae .read_name          ; Discard extra characters until Enter

    mov [name_buffer + esi], al
    inc esi
    jmp .read_name

.name_done:
    mov byte [name_buffer + esi], 0

    ; gets repeat
    mov eax, count_prompt
    call print_string
    call read_int
    mov [count], eax

    ; Accept only values greater than 50 and less than 100
    cmp eax, 50
    jle .invalid_count

    cmp eax, 100
    jge .invalid_count

.print_welcome:
    mov eax, welcome
    call print_string

    mov eax, name_buffer
    call print_string
    call print_nl

    dec dword [count]       
    cmp dword [count], 0
    jg .print_welcome

    jmp .finish

.invalid_count:
    mov eax, error_msg
    call print_string
    call print_nl

.finish:
    popa
    mov eax, 0
    leave
    ret