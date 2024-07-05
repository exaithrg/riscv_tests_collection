/* Linker script for bare-metal RISC-V environment */
/* Author: H GENG */
/* Thanks https://riscvasm.lucasteske.dev/ */

/* Define the required amount of heap and stack */
__heap_size   = 0x200;  /* Heap size: 512 bytes */
__stack_size  = 0x800;  /* Stack size: 2048 bytes */
/* Heap + Stack : 2560 bytes */

/* Memory sections */
MEMORY
{
    /* ROM: Start at 0x80000000, 1024 bytes, Read and Execute only */
    ROM (rx) : ORIGIN = 0x80000000, LENGTH = 0x400   
    /* RAM: Start at 0x00000000, 4096 bytes, Read, Write, and Execute */
    RAM (rwx) : ORIGIN = 0x00000000, LENGTH = 0x1000 
}

/* Sections definition */
SECTIONS
{
    /* .text section: Code and read-only data */
    .text :
    {
        *(.boot)           /* Boot code */
        *(.text)           /* Main code */
        *(.text*)          /* Other text sections */
        *(.rodata*)        /* Read-only data */
    } > ROM                /* Place .text section in ROM */

    /* .data section: Initialized data, uninitialized data, and common symbols */
    .data :
    {
        *(.sbss)           /* Small uninitialized data */
        *(.data)           /* Initialized data */
        *(.bss)            /* Uninitialized data */
        *(.rela*)          /* Relocation data */
        *(COMMON)          /* Common symbols */
    } > RAM                /* Place .data section in RAM */

    /* .heap section: Define heap area */
    .heap :
    {
        . = ALIGN(4);      /* Align to 4 bytes */
        PROVIDE ( end = . ); /* Provide 'end' symbol for heap start */
        _sheap = .;        /* Define _sheap as the start of heap */
        . = . + __heap_size; /* Allocate heap size */
        . = ALIGN(4);      /* Align to 4 bytes */
        _eheap = .;        /* Define _eheap as the end of heap */
    } > RAM                /* Place .heap section in RAM */

    /* .stack section: Define stack area */
    .stack :
    {
        . = ALIGN(4);      /* Align to 4 bytes */
        _estack = .;       /* Define _estack as the end of stack */
        . = . + __stack_size; /* Allocate stack size */
        . = ALIGN(4);      /* Align to 4 bytes */
        _sstack = .;       /* Define _sstack as the start of stack */
    } > RAM                /* Place .stack section in RAM */
}
