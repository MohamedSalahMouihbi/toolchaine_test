CC = arm-none-eabi-gcc
MACH = cortex-m4
CFLAGS = -c -mcpu=$(MACH) -mthumb -mfloat-abi=soft -std=gnu11 -Wall -o0
LDFLAGS = -mcpu=$(MACH) -mthumb -mfloat-abi=soft --specs=nano.specs -T stm32_linkerScript.ld -Wl,-Map=final.map #-nostdlib 
# -Wl,-Map=final.map			: to get a memory map readable report of elf file
# -nostdlib						: no use of standard library
# STDLIB: --specs=nano.specs	: use of nano standard library
# -mfloat-abi=hard 				: floatingpoint process type

all:main.o led.o stm32_startupFile.o syscalls.o final.elf

main.o:main.c
	$(CC) $(CFLAGS) main.c -o main.o

led.o:led.c
	$(CC) $(CFLAGS) led.c -o led.o

stm32_startupFile.o:stm32_startupFile.c
	$(CC) $(CFLAGS) stm32_startupFile.c -o stm32_startupFile.o

syscalls.o:syscalls.c  #STDLIB:	-o $@ $^ == led.c -o led.o
	$(CC) $(CFLAGS) -o $@ $^ 

final.elf: main.o led.o stm32_startupFile.o syscalls.o
	$(CC) $(LDFLAGS) main.o led.o stm32_startupFile.o syscalls.o -o final.elf

clean:
	rm -rf *.o *.elf

load: 
	openocd -f board/stm32f4discovery.cfg