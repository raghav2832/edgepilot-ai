#include <stdint.h>

/* RCC (Reset and Clock Control) base + AHB1 peripheral clock enable register */
#define RCC_BASE        0x40023800UL
#define RCC_AHB1ENR     (*(volatile uint32_t *)(RCC_BASE + 0x30))

/* GPIOA base + relevant registers */
#define GPIOA_BASE      0x40020000UL
#define GPIOA_MODER     (*(volatile uint32_t *)(GPIOA_BASE + 0x00))
#define GPIOA_ODR       (*(volatile uint32_t *)(GPIOA_BASE + 0x14))

#define GPIOAEN         (1U << 0)   /* bit 0 of AHB1ENR enables GPIOA clock */
#define PIN5            (1U << 5)   /* PA5 = LD2 on Nucleo-F446RE */

static void delay(volatile uint32_t count)
{
    while (count--) { __asm__("nop"); }
}

int main(void)
{
    /* 1. enable clock to GPIOA */
    RCC_AHB1ENR |= GPIOAEN;

    /* 2. set PA5 to general purpose output (MODER bits [11:10] = 01) */
    GPIOA_MODER &= ~(3U << (5 * 2));
    GPIOA_MODER |=  (1U << (5 * 2));

    /* 3. toggle forever */
    while (1) {
        GPIOA_ODR ^= PIN5;
        delay(500000);
    }
}
