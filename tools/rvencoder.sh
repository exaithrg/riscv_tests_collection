#!/bin/bash

# Function to convert hex to binary with leading zeros and underscore format
hex_to_binary() {
    local hex="$1"
    hex=$(echo "$hex" | tr '[:lower:]' '[:upper:]')  # Convert hex to uppercase
    local len=$((${#hex} * 4))  # Calculate total bit length
    local binary=""

    # bug shooting
    # printf: warning: 111101110000011110110011: Numerical result out of range
    # local binary=$(echo "obase=2; ibase=16; $hex" | bc)
    # value too great for base (error token is "2#00812E23")
    # local binary=$(printf "%${len}s" "$((2#$hex))")
    
    for (( i=0; i<${#hex}; i++ )); do
        case "${hex:i:1}" in
            0) binary+="0000" ;;
            1) binary+="0001" ;;
            2) binary+="0010" ;;
            3) binary+="0011" ;;
            4) binary+="0100" ;;
            5) binary+="0101" ;;
            6) binary+="0110" ;;
            7) binary+="0111" ;;
            8) binary+="1000" ;;
            9) binary+="1001" ;;
            A) binary+="1010" ;;
            B) binary+="1011" ;;
            C) binary+="1100" ;;
            D) binary+="1101" ;;
            E) binary+="1110" ;;
            F) binary+="1111" ;;
            *) echo "Invalid hex digit '${hex:i:1}'"; exit 1 ;;
        esac
    done
    
    # Add underscores to format the binary string
    binary_formatted=""
    for (( i=0; i<len; i+=4 )); do
        binary_formatted+="${binary:i:4}_"
    done
    
    echo "${binary_formatted%_}"  # Remove trailing underscore
}

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

    # Convert hex instruction to binary format with underscore and leading zeros
    binary_instruction=$(hex_to_binary "$hex_instruction")

    # Output the result in the desired format
    printf "%s ( %s ) <- %s\n" "$binary_instruction" "$hex_instruction" "$instruction"

    # Clean up
    rm -f "$tmp_asm_file" tmp.o
}

# Loop through each input argument
for arg in "$@"
do
    assemble_and_disassemble "$arg"
done
