/* start.s - Startup code for RISC-V */
/* Author: H GENG */

/* Symbol definitions from the linker script */
.extern _estack /* End of stack */
.extern _sstack /* Start of stack */
.extern _start /* Entry point */
.extern main   /* Main function */

/* Start of program execution */
.section .text
.globl _start
_start:
    /* Initialize stack pointer */
    la sp, _estack

    /* Initialize t0,t1,t2 */
    li t0,0
    li t1,0
    li t2,0

    /* Call main function */
    call main

    /* Exit program */
    /* Set t0 as the return value of main */
    addi t0,a0,0

    /* li a7, 10   Exit syscall */
    /* ecall       Perform syscall */

    /* Endless loop (trap into a dead loop) */
loop:
    /* Cal loop counts */
    addi t1,t1,-1
    /* Cal loop counts / 2 */
    addd t2,t1,zero
    jal loop

    /* End of program */
    .size _start, .-_start
