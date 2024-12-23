// Custom Hummingbird E203 functions

#ifndef _MYE203FUNC_H
#define _MYE203FUNC_H

void e203_uart_init(UART_TypeDef *uart);
int32_t e203_printf(UART_TypeDef *uart, const char * str,...);
int32_t e203_printf_num(UART_TypeDef *uart, int n);

#endif /* _MYE203FUNC_H */
