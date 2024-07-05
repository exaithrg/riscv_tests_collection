.macro addd rd, rs1, rs2
    custom0 0b1010101, \rs2, \rs1, 0b101, \rd
.endm
