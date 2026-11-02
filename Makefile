NASM = nasm
CC = gcc

PROGRAMS = task1 task1_2 task2_welcome task2_array task2_range
TARGETS = $(addprefix src/,$(PROGRAMS))

.PHONY: all clean

all: $(TARGETS)

src/driver.o: src/driver.c
	$(CC) -m32 -c $< -o $@

src/asm_io.o: src/asm_io.asm src/asm_io.inc
	$(NASM) -f elf32 -d ELF_TYPE $< -o $@

src/%.o: src/%.asm src/asm_io.inc
	$(NASM) -f elf32 -I src/ $< -o $@

$(TARGETS): src/%: src/%.o src/driver.o src/asm_io.o
	$(CC) -m32 -no-pie $^ -o $@

clean:
	rm -f src/*.o $(TARGETS)