ENTRY(Reset_Handler)

MEMORY
{
    FLASH(rx) : ORIGIN =0x08000000,LENGTH =1024K
    SRAM(rx) : ORIGIN =0x20000000,LENGTH =128K
}

SECTIONS
{
    .text :
    {
        *(.isr_vector)
        *(.text)
        *(.text.*)      /* STDLIB: assemblate all text subsection of stdlib (.text.write....) under only one section*/
        *(.data)
        *(.rodata.*)    /* STDLIB: assemblate all rodata subsection of stdlib under only one section*/
        . = ALIGN(4);   /* alignelment */
        _etext = .;     /* symbole name to te the adress of end text segment */
    }> FLASH

    .data :
    {
        _sdata = .;
        *(.data)
        *(.data.*)    /* STDLIB: assemblate all data subsection of stdlib under only one section*/
        . = ALIGN(4); /* alignelment */
        _edata = .;
    }> SRAM AT> FLASH

    .bss :
    {
        _sbss = .;
        __bss_start__ = _sbss;  /* STDLIB:add when using standart lib*/
        *(.bss)
        *(.bss.*)               /* STDLIB: assemblate all bss subsection of stdlib under only one section*/
        *(COMMON)               /* put common section into bss */
        . = ALIGN(4);           /* alignelment */
        _ebss = .;
        __bss_end__ = _sbss;    /* STDLIB:add when using standart lib*/
        . = ALIGN(4);           /* STDLIB:alignelment */ 
        end = .;                /* STDLIB:when adding syscalls file add this symbolique */
    }> SRAM
}