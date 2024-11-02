# main.s
.section .text
.global main
main:
    addi a0,zero,-1
    addi a1,zero,0
    sw a0,0(a1)
    sw zero,-4(a1)
    sw zero,4(a1)
    ecall
    