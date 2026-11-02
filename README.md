# Operating Systems - Worksheet 1

**Name:** Ben Hicks  
**Student ID:** 25000896  
**Module:** UFCFWK-15-2 Operating Systems

## Overview

For this worksheet, I used NASM to write 32-bit x86 assembly programs and called them through a C driver. The tasks cover input, calculations, loops, conditions and arrays. I also made a Makefile to build all the programs together.

## Repo Structure

- `src/` contains my assembly programs, the C driver and the supplied I/O files.
- `screenshots/` contains screenshots of the programs running.
- `Makefile` contains the commands needed to build the programs.
- `README.md` explains each task and how to run it.

## Task 1 - Adding Two Integers

### What the program does

This program adds 15 and 6, stores the answer and prints 21.

### How it works

- `integer1` and `integer2` hold 15 and 6 in the `.data` section.
- `result resd 1` reserves four bytes in `.bss` to store the answer.
- `mov eax, [integer1]` copies the first number into EAX.
- `add eax, [integer2]` adds the second number, leaving 21 in EAX.
- `mov [result], eax` saves the answer in memory.
- `print_int` prints the number in EAX, and `print_nl` adds a new line.
- `driver.c` calls `asm_main`. The line `global asm_main` makes this function available to the C driver when the files are linked. The function returns 0 to indicate success.

### How to build and run

Run these commands in the `src` folder:

```bash
nasm -f elf32 task1.asm -o task1.o
nasm -f elf32 -d ELF_TYPE asm_io.asm -o asm_io.o
gcc -m32 -c driver.c -o driver.o
gcc -m32 -no-pie driver.o task1.o asm_io.o -o task1
./task1
```

### Result

The expected output is 21.

![Task 1 output](screenshots/task1.png)

## Task 1_2 - Adding User Input

### What the program does

This version asks the user for two numbers instead of using fixed values. It adds them together and prints the calculation.

### How it works

- `mov eax, prompt` puts the address of the prompt into EAX. `print_string` prints it until it reaches the zero byte at the end.
- `read_int` reads a number from the user and puts it into EAX.
- The inputs are saved in `integer1` and `integer2`. Each has four bytes reserved in `.bss`.
- The first number is loaded into EAX, then `add` adds the second number. The answer is saved in `result`.
- `print_string` prints the text, while `print_int` prints the numbers and answer.

### How to build and run

Run these commands in `src`. This reuses `driver.o` and `asm_io.o` from Task 1.

```bash
nasm -f elf32 task1_2.asm -o task1_2.o
gcc -m32 -no-pie driver.o task1_2.o asm_io.o -o task1_2
./task1_2
```

### Result

Entering 5 and 7 should give:

```text
The sum of 5 and 7 is: 12
```

![Task 1_2 output](screenshots/task1_2.png)

## Task 2.1 - Personalised Welcome Message

### What the program does

The user enters their name and a number from 51 to 99. The program prints a welcome message that many times. If the number is outside the range, it prints an error.

### How it works

- `print_string` displays the prompts.
- `read_char` reads the name one character at a time into AL, which is the lowest byte of EAX.
- The characters are stored in `name_buffer`. ESI tracks the position for the next character.
- The buffer has 64 bytes. It stores up to 63 characters and leaves space for a zero byte at the end.
- `read_int` reads the number, which is saved in `count`.
- The comparisons reject numbers of 50 or below and 100 or above.
- The loop prints `"Welcome, "` followed by the name. `dec` subtracts one from the count each time, and the loop stops when it reaches zero.

### Code example

```nasm
cmp eax, 50
jle .invalid_count

cmp eax, 100
jge .invalid_count
```

These checks only allow numbers from 51 to 99. `jle` means jump if less than or equal, and `jge` means jump if greater than or equal.

### How to build and run

Run these commands in `src`:

```bash
nasm -f elf32 -d ELF_TYPE asm_io.asm -o asm_io.o
gcc -m32 -c driver.c -o driver.o
nasm -f elf32 task2_welcome.asm -o task2_welcome.o
gcc -m32 -no-pie driver.o task2_welcome.o asm_io.o -o task2_welcome
./task2_welcome
```

### Results

The first screenshot shows the welcome message working with a valid number.

![Welcome Input Working](screenshots/welcome51.png)

The second shows the error message for an invalid number.

![Welcome Input Error](screenshots/task2error.png)

## Task 2.2 - Initialising and Summing an Array

### What the program does

I made an array that stores the numbers 1 to 100. Another loop adds the stored numbers together and prints the total.

### How it works

- `numbers resd ARRAY_SIZE` reserves space for 100 four-byte integers in `.bss`.
- The first loop fills the array. EAX holds the number being stored, while ESI holds the array index.
- `[numbers + esi*4]` accesses an element. The index is multiplied by four because each integer takes up four bytes.
- The second loop starts EAX at zero and adds each array element to it.
- `inc esi` moves to the next index. The loop continues while ESI is below 100.
- The answer is saved in `result` and printed with `print_int`.

### Code example

```nasm
add eax, [numbers + esi*4]
inc esi

cmp esi, ARRAY_SIZE
jl .sum_array
```

This adds one element to the total and moves to the next. The array indexes run from 0 to 99.

### How to build and run

Run these commands in `src`:

```bash
nasm -f elf32 -d ELF_TYPE asm_io.asm -o asm_io.o
gcc -m32 -c driver.c -o driver.o
nasm -f elf32 task2_array.asm -o task2_array.o
gcc -m32 -no-pie driver.o task2_array.o asm_io.o -o task2_array
./task2_array
```

### Result

The expected total was 5050, which matched my output.

```text
The sum of 1 to 100 is: 5050
```

![Array sum program running](screenshots/task2_array.png)

## Task 2.3 - Summing a Selected Range

### What the program does

This extends the array program by letting the user choose a start and end value. It adds the numbers in that range, including both endpoints. Invalid ranges give an error.

### How it works

- A loop fills the array with the numbers 1 to 100.
- The user enters two numbers, which are saved in `range_start` and `range_end`.
- The program checks that both numbers are between 1 and 100. It also checks that the end is not below the start.
- Array indexes start at zero, so the program subtracts one from the starting value to find its index.
- A loop adds the selected array elements to EAX.
- The total is saved in `result` and printed. If a check fails, the program prints the error message instead.

### Code examples

```nasm
mov esi, [range_start]
dec esi
```

This finds the starting index. For example, the number 10 is stored at index 9.

```nasm
.sum_range:
    add eax, [numbers + esi*4]
    inc esi

    cmp esi, [range_end]
    jl .sum_range
```

The loop adds each number in the range, including the ending value.

### How to build and run

Run these commands in `src`:

```bash
nasm -f elf32 -d ELF_TYPE asm_io.asm -o asm_io.o
gcc -m32 -c driver.c -o driver.o
nasm -f elf32 task2_range.asm -o task2_range.o
gcc -m32 -no-pie driver.o task2_range.o asm_io.o -o task2_range
./task2_range
```

### Screenshot

![Range sum with valid input](screenshots/task2_range.png)

## Task 3 - Building with Make

### What the Makefile does

The Makefile builds all five programs using `make`. I can also use `make clean` to remove the generated object files and executables.

### How it works

- `NASM` and `CC` specify the assembler and compiler. `PROGRAMS` lists the programs to build.
- `all` is the first target, so running `make` builds everything by default.
- Each rule has a target, prerequisites and a recipe. These are the output, the files it needs and the commands used to build it.
- `%` matches different program names, so I do not need a separate assembly rule for every program.
- `$<` means the first prerequisite, `$@` means the target and `$^` means all prerequisites.
- Make checks file modification times to decide what needs rebuilding.
- `make clean` removes the build files and keeps the source code.
- `.PHONY` tells Make that `all` and `clean` are actions rather than actual files.

### Code example

```makefile
src/%.o: src/%.asm src/asm_io.inc
	$(NASM) -f elf32 -I src/ $< -o $@
```

This turns an assembly source file into a 32-bit object file. `-I src/` tells NASM where to find `asm_io.inc`. The include file is also a prerequisite, so changing it causes the affected object files to be rebuilt.

### How to build and run

Run these commands from the main repo folder:

```bash
make clean
make
./src/task2_array
```

The array program should print:

```text
The sum of 1 to 100 is: 5050
```

Running `make` again without changing any files should report that nothing needs doing.

```bash
make
```

### Screenshot

![Make building all programs](screenshots/make_build.png)