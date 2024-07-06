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

    /* Call main function */
    call main

    /* Exit program */
    /* li a7, 10   Exit syscall */
    /* ecall       Perform syscall */

    /* Endless loop (trap into a dead loop) */
loop:
    jal loop

    /* End of program */
    .size _start, .-_start
