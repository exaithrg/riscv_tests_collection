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
