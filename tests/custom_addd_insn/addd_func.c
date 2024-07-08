
int addd_func(int a1, int a2) {
    int result;
    asm volatile (
        // .insn r opcode, funct3, funct7, rd, rs1, rs2
        ".insn r 0x0b, 0x5, 0x55, %0, %1, %2"
             : "=r"(result)
             : "r"(a1), "r"(a2)
    );
    return result;
}
