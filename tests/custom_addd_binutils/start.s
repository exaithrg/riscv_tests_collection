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
    li t0,10
    li t1,10
    li t2,10

    /* Call main function */
    call main

    /* Exit program */
    /* li a7, 10   Exit syscall */
    /* ecall       Perform syscall */

    /* Endless loop (trap into a dead loop) */
loop:
    add t1,t1,t0
    addd t2,t1,t2
    jal loop

    /* End of program */
    .size _start, .-_start
