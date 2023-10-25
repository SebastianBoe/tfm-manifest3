#include "uart_stdout.h"
#include "stdio.h"
#include <stdbool.h>

const unsigned char hello_world[] = "Hello world\r\n";
int main(void)
{
        stdio_init();

        /* Not enough stack space in NS app to call printf.
         * Increase NS_STACK_SIZE in region_defs.h.
         */
        stdio_output_string(hello_world, sizeof(hello_world) - 1);

        while(true);

        return 0;
}