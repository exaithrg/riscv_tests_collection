#!/bin/bash

# Input instruction
instruction="$1"
echo "Input instruction: $instruction"

# Temporary file to store assembly code
tmp_asm_file="tmp.asm"

# Create temporary assembly file
echo ".text" > "$tmp_asm_file"
echo ".global _start" >> "$tmp_asm_file"
echo "_start:" >> "$tmp_asm_file"
echo "  $instruction" >> "$tmp_asm_file"
echo "  nop" >> "$tmp_asm_file"

# Assemble the temporary file
riscv64-unknown-elf-as -march=rv32i "$tmp_asm_file" -o tmp.o

# Disassemble to extract the instruction
disassembly=$(riscv64-unknown-elf-objdump -d tmp.o)

# Extract the hex instruction using awk
hex_instruction=$(echo "$disassembly" | awk '/<_start>/ {getline; print $2}')

# Output only the required lines
echo "Extracted hex instruction: $hex_instruction"

# Clean up
rm -f "$tmp_asm_file" tmp.o
