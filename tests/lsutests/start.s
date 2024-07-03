# start.s
.section .text
.global _start
_start:
    call main
    # 使用 ecall 指令退出
    li a7, 93          # ecall 号，93 代表 exit
    li a0, 0           # exit 状态码
    ecall
