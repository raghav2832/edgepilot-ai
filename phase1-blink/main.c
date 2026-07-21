#include <stdint.h>


#define RCC_BASE        0x40023800UL
#define RCC_AHB1ENR     (*(volatile uint32_t *)(RCC_BASE + 0x30))


#define GPIOA_BASE      0x40020000UL
#define GPIOA_MODER     (*(volatile uint32_t *)(GPIOA_BASE + 0x00))
#define GPIOA_ODR       (*(volatile uint32_t *)(GPIOA_BASE + 0x14))

#define GPIOAEN         (1U << 0)   
#define PIN5            (1U << 5)   

static void delay(volatile uint32_t count)
{
    while (count--) { __asm__("nop"); }
}

int main(void)
{
    
    RCC_AHB1ENR |= GPIOAEN;

    
    GPIOA_MODER &= ~(3U << (5 * 2));
    GPIOA_MODER |=  (1U << (5 * 2));

    
    while (1) {
        GPIOA_ODR ^= PIN5;
        delay(500000);
    }
}
