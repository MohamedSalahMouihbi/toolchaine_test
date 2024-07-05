#include<stdint.h>

#define SRAM_START  0x20000000U
#define SRAM_SIZE   (128 * 1024U) //128KB
#define SRAM_END    (SRAM_START + SRAM_SIZE)

#define STACK_START SRAM_END

// use this command "arm-none-eabi-nm.exe elf_file" to get all symboles names
extern uint32_t _ebss;
extern uint32_t _edata;
extern uint32_t _etext;
extern uint32_t _sbss;
extern uint32_t _sdata;

int main(void);
void __libc_init_array(void);

void Reset_Handler(void);
void NMI_Handler 					(void) __attribute__ ((weak, alias("Default_Handler"))); //weak: u can create implimant htis function in main

uint32_t vector[]   __attribute__((section(".isr_vector"))) = {     // we use __attribute__((section(".isr_vector"))) 
    STACK_START,                                                    //          to create new section to stor vector table on it
    (uint32_t)&Reset_Handler,                                       //          because perdefault data stored in .data section
    (uint32_t)&NMI_Handler, 
    // continue to add all...

};

void Reset_Handler(void)
{
    // copy .data section to SRAM
    uint32_t size = (uint32_t*)&_edata - (uint32_t*)&_sdata;

    uint8_t *pDst = (uint8_t*)&_sdata; //sram
    uint8_t *pSrc = (uint8_t*)&_etext; //flash
    for(uint32_t i =0; i<size; i++)
    {
        *pDst++ = *pSrc++;
    }

    // init .bss section to zero in SRAM
    size = &_ebss - &_sbss;

    pDst = (uint8_t*)&_sbss; 
    for(uint32_t i =0; i<size; i++)
    {
        *pDst++ = 0;
    }

    // call init function of std library
        /*in our example we will not use any stdlib*/

        /* STDLIB:in second example we will add it*/
    __libc_init_array();

    // call main function
    main();
    
}
void Default_Handler(void)
{

}