#include "stm32f446xx.h"   /* pulls in RCC, GPIOA structs + core_cm4.h */

static void delay(volatile uint32_t count)
{
    while (count--) { __asm__("nop"); }
}

int main(void)
{
    /* enable GPIOA clock — same bit as before, now via named macro + struct member */
    RCC->AHB1ENR |= RCC_AHB1ENR_GPIOAEN;

    /* PA5 as output */
    GPIOA->MODER &= ~(3U << (5 * 2));
    GPIOA->MODER |=  (1U << (5 * 2));

    while (1) {
        GPIOA->ODR ^= (1U << 5);
        delay(500000);
    }
}
