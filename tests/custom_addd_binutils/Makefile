# Makefile for RISC-V GNU Toolchain Projects
# Author: H GENG
# How to use:
# make
# make clean

# Output files NAME
OFNAME = main
# Linker script
LDSCRIPT = RV32NAvi349.ld

# Compiler and tools
GCC = riscv32-addd-elf-gcc
LD = riscv32-addd-elf-ld
OBJDUMP = riscv32-addd-elf-objdump
OBJCOPY = riscv32-addd-elf-objcopy
SED = sed
CHMOD = chmod

# Compiler and linker flags
# ARCH_FLAGS = -march=rv32i -mabi=ilp32
# CFLAGS = $(ARCH_FLAGS) -nostdlib -c
CFLAGS = -nostdlib -c
LDFLAGS = -m elf32lriscv -nostdlib
# LDFLAGS = -m elf32lriscv -nostdlib -e _start

# Source files
SRCS = $(wildcard *.c *.s)
OBJS = $(SRCS:.c=.o)
OBJS := $(OBJS:.s=.o)

# Output files
ELF = $(OFNAME).elf
DIS = $(OFNAME).dis
TEXT_HEX = $(OFNAME)_text.hex
DATA_HEX = $(OFNAME)_data.hex

# Default target
all: $(DIS) $(TEXT_HEX) $(DATA_HEX)

# Compile source files
%.o: %.c
	$(GCC) $(CFLAGS) -o $@ $<

%.o: %.s
	$(GCC) $(CFLAGS) -o $@ $<

# Link object files
# $(ELF): $(OBJS)
# Make sure link start.o first
$(ELF): start.o $(filter-out start.o, $(OBJS))
	$(LD) $(LDFLAGS) -T $(LDSCRIPT) -o $@ $^

# Generate disassembly
$(DIS): $(ELF)
	$(OBJDUMP) -D $< > $@

# Generate hex files
$(TEXT_HEX): $(ELF)
	$(OBJCOPY) -O verilog --only-section ".text" $< $@

$(DATA_HEX): $(ELF)
	$(OBJCOPY) -O verilog --only-section ".data" $< $@

# Post-process hex files
postprocess: $(TEXT_HEX) $(DATA_HEX)
# in link script: ROM (rx) : ORIGIN = 0x80000000
	$(SED) -i 's/@800/@000/g' $(TEXT_HEX)
	@echo "Address @80000000 replaced with @00000000 in $(TEXT_HEX)"
# in link script: RAM (rwx) : ORIGIN = 0x00000000
#	$(SED) -i 's/@000/@000/g' $(DATA_HEX)
#	@echo "Address @00000000 replaced with @00000000 in $(DATA_HEX)"

# Clean up
clean:
	rm -f $(OBJS) $(ELF) $(DIS) $(TEXT_HEX) $(DATA_HEX)

# Aliases
sed: postprocess
cl: clean

.PHONY: all clean cl postprocess sed

# Ensure postprocess is run after all
all: postprocess

# Ensure dependencies
$(TEXT_HEX): $(ELF)
$(DATA_HEX): $(ELF)
$(DIS): $(ELF)
