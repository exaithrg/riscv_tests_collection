# include "add_func.h"
# include "addd_func.h"

int main(){
    int i;
    int gauss;
    int add1,add2;
    gauss = 0;
    // add from 1 to 100
    for(i=0; i<=100; i++){
        gauss+=i;
    }
    // gauss = 5050.
    // -1U is unsigned -1, which is 0xFFFFFFFF
    // FOR ADD_FUNC: x[rd] = x[rs1] + x[rs2]
    //    0000 0000 0000 0000 0001 0011 1011 1010   (x[rs1] = 5050)
    //  + 1111 1111 1111 1111 1111 1111 1111 1111   (x[rs2] = -1)
    //  -----------------------------------------
    //  1 0000 0000 0000 0000 0001 0011 1011 1001
    // add1 will be 0x13B9, which is DEC5049
    add1 = add_func(gauss,-1U); 

    // FOR ADDD_FUNC: x[rd] = ( x[rs1] + x[rs2] ) > 1
    //   0000 0000 0000 0000 0001 0011 1011 1010   (a = 5050)
    // + 1111 1111 1111 1111 1111 1111 1111 1111   (b = -1U)
    // -----------------------------------------
    // 1 0000 0000 0000 0000 0000 0000 0011 1001
    // > 1
    //   1000 0000 0000 0000 0000 0000 0001 1100
    // add2 will be 0x8000001C, which is DEC-2147483684
    add2 = addd_func(gauss,-1U);
    
    return add2;
}
