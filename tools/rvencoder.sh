#!/bin/bash

# Function to assemble and disassemble the instruction
assemble_and_disassemble() {
    local instruction="$1"
    local tmp_asm_file="tmp.asm"

    # Create temporary assembly file
    echo ".text" > "$tmp_asm_file"
    echo ".global _start" >> "$tmp_asm_file"
    echo "_start:" >> "$tmp_asm_file"
    echo "  $instruction" >> "$tmp_asm_file"
    echo "  nop" >> "$tmp_asm_file"

    # Assemble the temporary file
    riscv64-unknown-elf-as -march=rv32i "$tmp_asm_file" -o tmp.o > /dev/null 2>&1

    # Disassemble to extract the instruction
    disassembly=$(riscv64-unknown-elf-objdump -d tmp.o)

    # Extract the hex instruction using awk
    hex_instruction=$(echo "$disassembly" | awk '/<_start>/ {getline; print $2}')

    # Output the result in the desired format
    echo "$hex_instruction <- $instruction"

    # Clean up
    rm -f "$tmp_asm_file" tmp.o
}

# Loop through each input argument
for arg in "$@"
do
    assemble_and_disassemble "$arg"
done
