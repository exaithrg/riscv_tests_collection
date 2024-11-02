ENTRY(_start)
SECTIONS
{
    . = 0x80000000;
    .text : { *(.text) }
    .rodata : { *(.rodata) }
    .data : { *(.data) }
    .bss : { *(.bss COMMON) }
    /DISCARD/ : { *(.eh_frame) }
    
    /* Define stack space, assuming stack size is 128 bytes */
    . = ALIGN(4);
    __stack_top = .;
    . = . + 0x80;  /* 128 bytes */
    __stack_bottom = .;
}
