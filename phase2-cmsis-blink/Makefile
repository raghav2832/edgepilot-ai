TARGET = blink

CC = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy
SIZE = arm-none-eabi-size

MCU = -mcpu=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16

INCLUDES = -IDrivers/CMSIS/Include -IDrivers/CMSIS/Device/ST/STM32F4xx/Include
DEFS = -DSTM32F446xx

CFLAGS = $(MCU) $(INCLUDES) $(DEFS) -Wall -O0 -g -ffreestanding -std=c11
LDFLAGS = $(MCU) -T STM32F446RETX_FLASH.ld -nostdlib -Wl,--gc-sections -Wl,-Map=$(TARGET).map

SRCS = main.c startup_stm32f446xx.s
OBJS = main.o startup_stm32f446xx.o

all: $(TARGET).elf $(TARGET).bin
	$(SIZE) $(TARGET).elf

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.s
	$(CC) $(MCU) -c $< -o $@

$(TARGET).elf: $(OBJS)
	$(CC) $(LDFLAGS) $(OBJS) -o $@

$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -O binary $< $@

flash: $(TARGET).bin
	st-flash --reset write $(TARGET).bin 0x8000000

clean:
	rm -f *.o *.elf *.bin *.map

.PHONY: all flash clean
