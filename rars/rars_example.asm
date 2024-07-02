########################################################################
#----Calculate the Sum of Positive and Negative Numbers In An Array----#
########################################################################
# Simulator: RARS 1.6
########################################################################
# Src1: https://stackoverflow.com/questions/64734986/how-to-print-the-total-in-risc-v-assembly-language
# Src2: https://www.bilibili.com/video/BV1nY411d7Zv/
########################################################################

    .data
array:          .word 22,-35,48,10,-15,-30,25,20,-1,-26,-18,1,2,3,4,5,6,7,-9,1,-4,-3,-2,1,6,0   # array input
positiveSum:    .word 0
negativeSum:    .word 0

# outcome messages
position:       .word 0 # index posisiont of array
# length:         .word 9

# .ascii "\nPositive Integers Total: \0"
# EQUAL TO: .asciz "\nPositive Integers Total: "
# EQUAL TO: .string "\nPositive Integers Total: "
posTotalMsg:       .asciz "\nPositive Integers Total: "
.balign 4   # Align data section to 4 bytes. Optional.
negTotalMsg:       .ascii "\nNegative Integers Total: "

    .text
main:
    la t0,array          # load array to register t0 
    lw t1,position
    lw s1,positiveSum    # load the positive sum to s1, and negative sum to s2
    lw s2,negativeSum

loop:
    # calculate the index position in terms of memory
    # each integer needs 4 bytes
    # so shift left the value in t1 and store it in t3
    slli t3,t1,2
    add t3,t3,t0    # add the base address and the above result
    lw t4,0(t3)     # load the word from above address into t4
    beqz t4,exit    # exit loop when reaching 0
    j checkSign     # if value is not 0 jump to check integer sign

checkSign:
    bltz t4,addNegative     # check if array value is negative, if yes goto addnegative
    # j addPositive           # if not goto addpositive
               
addPositive:
    add s1,s1,t4    # add all positive integers to s1 register
    j increment     # increment
               
addNegative:
    add s2,s2,t4    # add the negative integers to the s2 register
    # j increment     # increment
           
increment:
    addi t1,t1,1    # increment the current index in t1 by 1
    j loop
          
exit:               # end of program
    la t1,positiveSum
    sw s1,(t1)
    sw s2,negativeSum,t1

    la a0,posTotalMsg   # ECALL. PRINT MESSAGE.
    li a7,4             # print the positive sum 
    ecall               # check RARS "help" to see how ecall works

    lw a0,positiveSum   # ECALL. PRINT NUMBER.
    li a7,1
    ecall
        
    la a0,negTotalMsg   # ECALL. PRINT MESSAGE.
    li a7,4             # print the negative sum 
    ecall

    lw a0,negativeSum   # ECALL. PRINT NUMBER.
    li a7,1
    ecall

    # ori a7, zero, 10    # program exit system call
    li a7,10
    ecall               # ECALL: EXIT PROGRAM
