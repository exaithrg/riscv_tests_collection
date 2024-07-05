// R-type
.macro custom0 funct7, rs2, rs1, funct3, rd
    .word (\funct7 << 25) + (\rs2 << 20) + (\rs1 << 15) + (\funct3 << 12) + (\rd << 7) + 0b0001011
.endm
