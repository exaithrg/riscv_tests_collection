// See LICENSE for license details.
// Hello World Test

#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include "hbird_sdk_soc.h"
#include "mye203func.h"

// #define FLASHXIP_MODE
// #define FLASH_MODE
#define ILM_MODE

// UL means unsigned long
#define AXI_O5				(0x40000000UL)      /*!< (ILM       ) Base Address */
// offset range: 0-33,554,428(8388607*4)
#define AXI_SDRAM(offset)	_REG32(AXI_O5, offset)

int main(void)
{
	// int a = 0;
	int i,j,k;
	int imax;
	int kcut;
	int flag,allflag;
	int idat, jdat, kdat, imaxdat;
	int swinputs = 0;
	int gpioout;
	// int hexnum = 0x4447;
	// int decnum = 6666;
	// int testnum = 6827;
	// int MAX_SDRAM_ADDR = 8388608; //FAILED with many errors
	// int MAX_SDRAM_ADDR = 2097152; //PASS
	// int MAX_SDRAM_ADDR = 4194304; //FAILED with many errors
	// int MAX_SDRAM_ADDR = 4194303; //FAILED with many errors
	// int MAX_SDRAM_ADDR = 2097153;	//FAILED with 1 error: NOT addr%65519: AXI_SDRAM[0]: dec=2176, addr=0
	int MAX_SDRAM_ADDR = 8388608;
	int I_STEP = 4;
	allflag = 0;
	GPIOA->IOFCFG = 0x000f0000;
	GPIOA->INTEN = 0x00000000;
	GPIOA->PADDIR = 0x00f00000;

	// UART TEST
	e203_uart_init(UART0);
	e203_uart_init(UART2);

	e203_printf(UART0, "\r\n======================================================\r\n");
	e203_printf(UART0, "UART0 says:  --------CPU START--------\r\n");
	e203_printf(UART2, "\r\n======================================================\r\n");
	e203_printf(UART2, "UART2 says:  --------CPU START--------\r\n");

# ifdef FLASHXIP_MODE
	e203_printf(UART0, "UART0 says:  --------FLASHXIP MODE--------\r\n");
	e203_printf(UART2, "UART2 says:  --------FLASHXIP MODE--------\r\n");
# endif
# ifdef FLASH_MODE
	e203_printf(UART0, "UART0 says:  --------FLASH MODE--------\r\n");
	e203_printf(UART2, "UART2 says:  --------FLASH MODE--------\r\n");
# endif
# ifdef ILM_MODE
	e203_printf(UART0, "UART0 says:  --------ILM MODE--------\r\n");
	e203_printf(UART2, "UART2 says:  --------ILM MODE--------\r\n");
# endif

    for (int i = 0; i < 2; i ++) {
        e203_printf(UART0, "UART0 says: Hello World! %d times\r\n", i+1);
        e203_printf(UART2, "UART2 says: Hello World! %d times\r\n", i+1);
        // delay_1ms(100);
    }

	e203_printf(UART2, "======================================================\r\n");
	e203_printf(UART0, "======================================================\r\n");
	e203_printf(UART0, "UART0 says:  --------SDRAM TEST START--------\r\n");

	// SDRAM INITIAL TEST
	i = 0;
	j = 4;
	idat = 0xab4447;
	jdat = 0xabcdef97;
	printf("Write SDRAM: AXI_SDRAM[%x]=0x%x \r\n", i, idat);
	printf("Write SDRAM: AXI_SDRAM[%x]=0x%x \r\n", j, jdat);
	AXI_SDRAM(i)= idat;
	AXI_SDRAM(j)= jdat;
    printf("Read SDRAM Data...\r\n");
	printf("AXI_SDRAM[%x]: hex=%x dec=%d \r\n", i, AXI_SDRAM(i), AXI_SDRAM(i));
	printf("AXI_SDRAM[%x]: hex=%x dec=%d \r\n", j, AXI_SDRAM(j), AXI_SDRAM(j));

	i = 2096640;
	j = 4193792;
	k = 33553920; 		//1fffe00
	kcut = 8388096;		//07ffe00
	imax = (MAX_SDRAM_ADDR-1)*4;
	idat = 100;
	jdat = 200;
	kdat = 300;
	imaxdat = 777;
	printf("Write SDRAM: AXI_SDRAM[%x]=%d \r\n", i, idat);
	printf("Write SDRAM: AXI_SDRAM[%x]=%d \r\n", j, jdat);
	printf("Write SDRAM: AXI_SDRAM[%x]=%d \r\n", k, kdat);
	printf("Write SDRAM: AXI_SDRAM[%x]=%d \r\n", imax, imaxdat);
	AXI_SDRAM(i)= idat;
	AXI_SDRAM(j)= jdat;
	AXI_SDRAM(k)= kdat;
	AXI_SDRAM(imax)= imaxdat;
    printf("Read SDRAM Data...\r\n");
	printf("AXI_SDRAM[%x]: hex=%x dec=%d \r\n", i, AXI_SDRAM(i), AXI_SDRAM(i));
	printf("AXI_SDRAM[%x]: hex=%x dec=%d \r\n", j, AXI_SDRAM(j), AXI_SDRAM(j));
	printf("AXI_SDRAM[%x]: hex=%x dec=%d \r\n", k, AXI_SDRAM(k), AXI_SDRAM(k));
	printf("AXI_SDRAM[%x]: hex=%x dec=%d \r\n", kcut, AXI_SDRAM(kcut), AXI_SDRAM(kcut));
	printf("AXI_SDRAM[%x]: hex=%x dec=%d \r\n", imax, AXI_SDRAM(imax), AXI_SDRAM(imax));

	e203_printf(UART0, "UART0 says:  --------Note: i=i+%d--------\r\n",I_STEP);
	e203_printf(UART0, "======================================================\r\n");

	// GPIO TEST
	// led: gpioA[20]-[23]
	// switch: gpioA[0]-[3]
	while(1){
		swinputs = gpio_read(GPIOA,0x0000000f);
		// e203_printf(UART2, "swinputs = %d\r\n", swinputs);
		gpioout = swinputs << 20;
		// e203_printf(UART0, "swinputs = %d\r\n", swinputs);
		GPIOA->PADOUT = gpioout;
	    // delay_1ms(500);
		if( (swinputs >> 3) & 0x1 == 1) {
			// enable all led and quit
			GPIOA->PADOUT = 0x00f00000;
			break;
		}
	}

    return 0;
}