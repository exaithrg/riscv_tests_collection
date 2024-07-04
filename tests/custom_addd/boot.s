/* RISC-V 32 Test Codes */
/* Author: H GENG */
/* Thanks https://riscvasm.lucasteske.dev/ */

.global _boot
.text

_boot:                    /* x0  = 0    0x000 */
    /* Test ADDI */
    addi x1 , x0,  1000  /* x1  = 1000 0x3E8 */
    addi x2 , x1,  2000  /* x2  = 3000 0xBB8 */
    addi x3 , x2,  -1000 /* x3  = 2000 0x7D0 */
    /* Hazard Test */
    add  x4 , x2,  x3    /* x4  = 5000 */
    addi x5 , x4,  1000  /* x5  = 6000 */

    la x6, variable      /* load addr(var) to x6 */
    lw x7, 0(x6)         /* load var(feedcafe) to x7 */
    /* Hazard Test */
    add x8, x6, x7       
    sw x8, 4(zero)
    sw x6, 8(zero)
    sw x7, 0(zero)

.data
variable:
	.word 0xfeedcafe
