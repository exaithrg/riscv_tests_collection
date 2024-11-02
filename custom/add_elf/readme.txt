关于链接脚本，la sp, __stack_top
通过运行D://GitHubRepos//riscv_tests_collection//tests//lsutests//main_text.hex，我们认识到在任何情况下都不应该出现向内存的负地址写入数据的情况。因此我们修改了D://GitHubRepos//riscv_tests_collection//tests//add_elf//的链接脚本，希望能够让sp初始化为<__stack_top>，这是一个比较大的值，应该能解决一些问题。
但是我似乎还是不能灵活控制栈空间的最高和最低地址，因为目前脚本是。
    /* Define stack space, assuming stack size is 128 bytes */
    . = ALIGN(4);
    __stack_top = .;
    . = . + 0x80;  /* 128 bytes */
    __stack_bottom = .;
似乎没有最低地址的选项。
而且如果栈爆了应该怎么办呢？

以下是编译流程

# 编译 C 文件
riscv64-unknown-linux-gnu-gcc -march=rv32i -mabi=ilp32 -nostdlib -c -o main.o main.c

# 编译汇编启动代码
riscv64-unknown-linux-gnu-gcc -march=rv32i -mabi=ilp32 -nostdlib -c -o start.o start.s

# 链接，使用自定义链接器脚本
# elf32lriscv = elf32-littleriscv
riscv64-unknown-linux-gnu-ld -m elf32lriscv -T linkadd.ld -nostdlib -o main.elf start.o main.o

riscv64-unknown-linux-gnu-objdump -D main.elf > main.dis
riscv64-unknown-linux-gnu-objcopy -O verilog --only-section ".text" main.elf main_text.hex
riscv64-unknown-linux-gnu-objcopy -O verilog --only-section ".data" main.elf main_data.hex

然后还需要将.text中的所有@80000000改成@00000000
对于E203，改法是：
riscv-nuclei-elf-objcopy -O verilog "${BuildArtifactFileBaseName}.elf" "${BuildArtifactFileBaseName}.verilog";sed -i 's/@800/@000/g' "${BuildArtifactFileBaseName}.verilog"; sed -i 's/@00002FB8/@00002000/g' "${BuildArtifactFileBaseName}.verilog"; riscv-nuclei-elf-objdump -d  "${BuildArtifactFileBaseName}.elf" > "${BuildArtifactFileBaseName}.dasm";
我们的做法是
for file in *_text.hex; do
    sed -i 's/@800/@000/g' "$file"
done
或者直接
sed -i 's/@800/@000/g' main_text.hex
