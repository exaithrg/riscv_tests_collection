// Custom Hummingbird E203 functions
#include <stdarg.h>
#include "hbird_sdk_soc.h"
#include "mye203func.h"

void e203_uart_init(UART_TypeDef *uart){
	uart_init(uart,115200);
	// uart_config_stopbit(uart,UART_STOP_BIT_1);
	uart_config_stopbit(uart,UART_STOP_BIT_2);
	uart_disable_paritybit(uart);
	uart_enable_rx_th_int(uart);
	uart_set_rx_th(uart,0);
	// uart_enable_tx_empt_int(uart);
}

int32_t e203_printf(UART_TypeDef *uart, const char * str,...){
    va_list arg;
    va_start(arg,str);
    int lengh = 0;
    int num_lengh = 0;
    while(str[lengh]!='\0'){
        if(str[lengh] == '%'){
            int num = va_arg(arg,int);
            num_lengh += e203_printf_num(uart, num);
            lengh ++;
        }else{
            // putchar(str[lengh]);
            uart_write(uart,str[lengh]);
        }
        lengh++;
    }
    va_end(arg);
    return lengh + num_lengh;
}

int32_t e203_printf_num(UART_TypeDef *uart, int n){
    int tail = n % 10;
    n /= 10;
    if(tail < 0){
        n *= -1;
        tail *= -1; 
        uart_write(uart,'-');
        // putchar('-');
    }
    int lengh = 0;
    int temp = 0;
    while(n){
        temp = temp * 10 + n % 10;
        n /= 10;
        lengh ++;
    }
    for(int i = 0;i < lengh;i ++){
        // putchar('0' + temp % 10);
        uart_write(uart,'0' + temp % 10);
        temp /= 10;
    }
    // putchar('0'+tail);
    uart_write(uart,'0' + tail);
    return lengh;
}
