# Makefile for RISC-V project
# make
# make sed / make postprocess
# make clean

# Compiler and tools
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
SRCS = $(wildcard *.c *.s)
OBJS = $(SRCS:.c=.o)
OBJS := $(OBJS:.s=.o)

# Output file base name
TARGET = rvtest

# Output files
ELF = $(TARGET).elf
DIS = $(TARGET).dis
TEXT_HEX = $(TARGET)_text.hex
DATA_HEX = $(TARGET)_data.hex

# Default target
all: $(DIS) $(TEXT_HEX) $(DATA_HEX)

# Compile source files
%.o: %.c
	$(GCC) $(CFLAGS) -o $@ $<

%.o: %.s
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

$(DATA_HEX): $(ELF)
	$(OBJCOPY) -O verilog --only-section ".data" $< $@

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

# Ensure dependencies
$(TEXT_HEX): $(ELF)
$(DATA_HEX): $(ELF)
$(DIS): $(ELF)
