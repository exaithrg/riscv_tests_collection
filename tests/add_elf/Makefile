# Makefile for RISC-V project
# make
# make sed / make postprocess
# make clean

# Compiler and tools
# GCC = riscv64-unknown-linux-gnu-gcc
# LD = riscv64-unknown-linux-gnu-ld
# OBJDUMP = riscv64-unknown-linux-gnu-objdump
# OBJCOPY = riscv64-unknown-linux-gnu-objcopy
GCC = riscv64-unknown-elf-gcc
LD = riscv64-unknown-elf-ld
OBJDUMP = riscv64-unknown-elf-objdump
OBJCOPY = riscv64-unknown-elf-objcopy
SED = sed
CHMOD = chmod

# Compiler and linker flags
ARCH_FLAGS = -march=rv32i -mabi=ilp32
CFLAGS = $(ARCH_FLAGS) -nostdlib -c
LDFLAGS = -m elf32lriscv -T basic.ld -nostdlib

# Source files
# start.s must be the first one
SRCS = start.s main.c 
OBJS = start.o main.o 

# Output files
ELF = main.elf
DIS = main.dis
TEXT_HEX = main_text.hex
DATA_HEX = main_data.hex

# Default target
all: $(DIS) $(TEXT_HEX) $(DATA_HEX)

# Compile source files
main.o: main.c
	$(GCC) $(CFLAGS) -o $@ $<

start.o: start.s
	$(GCC) $(CFLAGS) -o $@ $<

# Link object files
$(ELF): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $^

# Generate disassembly
$(DIS): $(ELF)
	$(OBJDUMP) -D $< > $@

# Generate hex files
$(TEXT_HEX): $(ELF)
	$(OBJCOPY) -O verilog --only-section ".text" $< $@
#	$(CHMOD) -x $@

$(DATA_HEX): $(ELF)
	$(OBJCOPY) -O verilog --only-section ".data" $< $@
#	$(CHMOD) -x $@

# Post-process hex files
postprocess: $(TEXT_HEX) $(DATA_HEX)
	$(SED) -i 's/@800/@000/g' $(TEXT_HEX) $(DATA_HEX)
	@echo "Address @80000000 replaced with @00000000"

# Alias for postprocess
sed: postprocess

# Clean up
clean:
	rm -f $(OBJS) $(ELF) $(DIS) $(TEXT_HEX) $(DATA_HEX)

.PHONY: all clean postprocess sed

# Ensure postprocess is run after all
all: postprocess
