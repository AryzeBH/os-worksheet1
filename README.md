# Operating Systems - Worksheet 1

**Name:** Ben Hicks
**Student ID:** 25000896
**Module:** UFCFWK-15-2 Operating Systems

## Overview
This worksheet will explore the 32-bit x86 assembly using NASM and calling assembly from C, while also implementing conditionals and loops, and building programs with MAke.

## Repo Structure
- "Src/" Is the assembly programs, C Driver and supplied I/O files.
- "screenshots/" Will be the screenshots of the program running and results
- "Makefile" Will be the build rules.
- "README" Is this! THe explanations, instructions, and testing.

## Task 1 - Adding Two Integers

### What the program does
Adds the stored numbers 15 and 6, saves the result and prints 21.

### How it works
- **Where are the numbers and results are stored:** ```Integer1``` and ```Integer2``` are stored in the ```.data``` section with the values 15 and 6. The .```bss``` section also reserves four bytes for result and resd 1.
- **How the sum is calculated:** ```mov eax, [Integer1]``` copies 15 into the EAX register. ```add eax, [integer2]``` adds 6, leaving 21 in EAX and lastly. ```mov [result], eax``` stores that answer in its memory.
- **How the result is displayed:** ```call print_int``` print the integer currently held within the EAX, which would be 21. ```call print_n1``` would then print a newline
- ***How C calls the assembly:*** ```driver.c``` declares ```asm_main``` and calls it from its function ```main```. This assembly declartion ```global asm_main``` then makes the function available to all the C drivers when the files are linked. The assembly would then return to the sum of 0 to indicate a successful completion.

### How to build and run
Run these commands inside the `src` folder via terminal:

```bash
nasm -f elf32 task1.asm -o task1.o
nasm -f elf32 -d ELF_TYPE asm_io.asm -o asm_io.o
gcc -m32 -c driver.c -o driver.o
gcc -m32 -no-pie driver.o task1.o asm_io.o -o task1
./task1
```

- The expected output would be 21
![Picture evident of the output](screenshots/image-2.png)

## Task 1_2 - Adding User Input

### What the program does
Asks the user for two integers, adds them together and displays the result.

### How it works
- Explain how `print_string` displays the prompts.
- Explain how `read_int` reads a number into EAX.
- Explain how the two numbers are stored in memory.
- Explain how `mov` and `add` calculate the sum.
- Explain how `print_string` and `print_int` display the calculation.

### How to build and run
Run these commands inside the `src` folder.
These reuse `driver.o` and `asm_io.o` from Task 1.

```bash
nasm -f elf32 task1_2.asm -o task1_2.o
gcc -m32 -no-pie driver.o task1_2.o asm_io.o -o task1_2
./task1_2
```

### Result
Entering `5` and `7` should display:

```text
The sum of 5 and 7 is: 12
```
![Picture evidence of task 1_2 output](screenshots/image-1.png)
