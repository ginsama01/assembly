; Compile with nasm32 and ld linker

SYS_EXIT    equ 1
SYS_READ    equ 3
SYS_WRITE   equ 4
SYS_OPEN    equ 5
SYS_CLOSE   equ 6
SYS_STAT    equ 0x6a
STDIN       equ 0
STDOUT      equ 1

; Some constants from glibc elf.h
%define EM_NONE                 0        ; No machine 
%define EM_M32                 1        ; AT&T WE 32100 
%define EM_SPARC         2        ; SUN SPARC 
%define EM_386                 3        ; Intel 80386 
%define EM_68K                 4        ; Motorola m68k family 
%define EM_88K                 5        ; Motorola m88k family 
%define EM_IAMCU         6        ; Intel MCU 
%define EM_860                 7        ; Intel 80860 
%define EM_MIPS                 8        ; MIPS R3000 big-endian 
%define EM_S370                 9        ; IBM System/370 
%define EM_MIPS_RS3_LE        10        ; MIPS R3000 little-endian 
                                ; reserved 11-14 
%define EM_PARISC        15        ; HPPA 
                                ; reserved 16 
%define EM_VPP500        17        ; Fujitsu VPP500 
%define EM_SPARC32PLUS        18        ; Sun's "v8plus" 
%define EM_960                19        ; Intel 80960 
%define EM_PPC                20        ; PowerPC 
%define EM_PPC64        21        ; PowerPC 64-bit 
%define EM_S390                22        ; IBM S390 
%define EM_SPU                23        ; IBM SPU/SPC 
                                ; reserved 24-35 
%define EM_V800                36        ; NEC V800 series 
%define EM_FR20                37        ; Fujitsu FR20 
%define EM_RH32                38        ; TRW RH-32 
%define EM_RCE                39        ; Motorola RCE 
%define EM_ARM                40        ; ARM 
%define EM_FAKE_ALPHA        41        ; Digital Alpha 
%define EM_SH                42        ; Hitachi SH 
%define EM_SPARCV9        43        ; SPARC v9 64-bit 
%define EM_TRICORE        44        ; Siemens Tricore 
%define EM_ARC                45        ; Argonaut RISC Core 
%define EM_H8_300        46        ; Hitachi H8/300 
%define EM_H8_300H        47        ; Hitachi H8/300H 
%define EM_H8S                48        ; Hitachi H8S 
%define EM_H8_500        49        ; Hitachi H8/500 
%define EM_IA_64        50        ; Intel Merced 
%define EM_MIPS_X        51        ; Stanford MIPS-X 
%define EM_COLDFIRE        52        ; Motorola Coldfire 
%define EM_68HC12        53        ; Motorola M68HC12 
%define EM_MMA                54        ; Fujitsu MMA Multimedia Accelerator 
%define EM_PCP                55        ; Siemens PCP 
%define EM_NCPU                56        ; Sony nCPU embeeded RISC 
%define EM_NDR1                57        ; Denso NDR1 microprocessor 
%define EM_STARCORE        58        ; Motorola Start*Core processor 
%define EM_ME16                59        ; Toyota ME16 processor 
%define EM_ST100        60        ; STMicroelectronic ST100 processor 
%define EM_TINYJ        61        ; Advanced Logic Corp. Tinyj emb.fam 
%define EM_X86_64        62        ; AMD x86-64 architecture 
%define EM_PDSP                63        ; Sony DSP Processor 
%define EM_PDP10        64        ; Digital PDP-10 
%define EM_PDP11        65        ; Digital PDP-11 
%define EM_FX66                66        ; Siemens FX66 microcontroller 
%define EM_ST9PLUS        67        ; STMicroelectronics ST9+ 8/16 mc 
%define EM_ST7                68        ; STmicroelectronics ST7 8 bit mc 
%define EM_68HC16        69        ; Motorola MC68HC16 microcontroller 
%define EM_68HC11        70        ; Motorola MC68HC11 microcontroller 
%define EM_68HC08        71        ; Motorola MC68HC08 microcontroller 
%define EM_68HC05        72        ; Motorola MC68HC05 microcontroller 
%define EM_SVX                73        ; Silicon Graphics SVx 
%define EM_ST19                74        ; STMicroelectronics ST19 8 bit mc 
%define EM_VAX                75        ; Digital VAX 
%define EM_CRIS                76        ; Axis Communications 32-bit emb.proc 
%define EM_JAVELIN        77        ; Infineon Technologies 32-bit emb.proc 
%define EM_FIREPATH        78        ; Element 14 64-bit DSP Processor 
%define EM_ZSP                79        ; LSI Logic 16-bit DSP Processor 
%define EM_MMIX                80        ; Donald Knuth's educational 64-bit proc 
%define EM_HUANY        81        ; Harvard University machine-independent object files 
%define EM_PRISM        82        ; SiTera Prism 
%define EM_AVR                83        ; Atmel AVR 8-bit microcontroller 
%define EM_FR30                84        ; Fujitsu FR30 
%define EM_D10V                85        ; Mitsubishi D10V 
%define EM_D30V                86        ; Mitsubishi D30V 
%define EM_V850                87        ; NEC v850 
%define EM_M32R                88        ; Mitsubishi M32R 
%define EM_MN10300        89        ; Matsushita MN10300 
%define EM_MN10200        90        ; Matsushita MN10200 
%define EM_PJ                91        ; picoJava 
%define EM_OPENRISC        92        ; OpenRISC 32-bit embedded processor 
%define EM_ARC_COMPACT        93        ; ARC International ARCompact 
%define EM_XTENSA        94        ; Tensilica Xtensa Architecture 
%define EM_VIDEOCORE        95        ; Alphamosaic VideoCore 
%define EM_TMM_GPP        96        ; Thompson Multimedia General Purpose Proc 
%define EM_NS32K        97        ; National Semi. 32000 
%define EM_TPC                98        ; Tenor Network TPC 
%define EM_SNP1K        99        ; Trebia SNP 1000 
%define EM_ST200        100        ; STMicroelectronics ST200 
%define EM_IP2K                101        ; Ubicom IP2xxx 
%define EM_MAX                102        ; MAX processor 
%define EM_CR                103        ; National Semi. CompactRISC 
%define EM_F2MC16        104        ; Fujitsu F2MC16 
%define EM_MSP430        105        ; Texas Instruments msp430 
%define EM_BLACKFIN        106        ; Analog Devices Blackfin DSP 
%define EM_SE_C33        107        ; Seiko Epson S1C33 family 
%define EM_SEP                108        ; Sharp embedded microprocessor 
%define EM_ARCA                109        ; Arca RISC 
%define EM_UNICORE        110        ; PKU-Unity & MPRC Peking Uni. mc series 
%define EM_EXCESS        111        ; eXcess configurable cpu 
%define EM_DXP                112        ; Icera Semi. Deep Execution Processor 
%define EM_ALTERA_NIOS2 113        ; Altera Nios II 
%define EM_CRX                114        ; National Semi. CompactRISC CRX 
%define EM_XGATE        115        ; Motorola XGATE 
%define EM_C166                116        ; Infineon C16x/XC16x 
%define EM_M16C                117        ; Renesas M16C 
%define EM_DSPIC30F        118        ; Microchip Technology dsPIC30F 
%define EM_CE                119        ; Freescale Communication Engine RISC 
%define EM_M32C                120        ; Renesas M32C 
                                ; reserved 121-130 
%define EM_TSK3000        131        ; Altium TSK3000 
%define EM_RS08                132        ; Freescale RS08 
%define EM_SHARC        133        ; Analog Devices SHARC family 
%define EM_ECOG2        134        ; Cyan Technology eCOG2 
%define EM_SCORE7        135        ; Sunplus S+core7 RISC 
%define EM_DSP24        136        ; New Japan Radio (NJR) 24-bit DSP 
%define EM_VIDEOCORE3        137        ; Broadcom VideoCore III 
%define EM_LATTICEMICO32 138        ; RISC for Lattice FPGA 
%define EM_SE_C17        139        ; Seiko Epson C17 
%define EM_TI_C6000        140        ; Texas Instruments TMS320C6000 DSP 
%define EM_TI_C2000        141        ; Texas Instruments TMS320C2000 DSP 
%define EM_TI_C5500        142        ; Texas Instruments TMS320C55x DSP 
%define EM_TI_ARP32        143        ; Texas Instruments App. Specific RISC 
%define EM_TI_PRU        144        ; Texas Instruments Prog. Realtime Unit 
                                ; reserved 145-159 
%define EM_MMDSP_PLUS        160        ; STMicroelectronics 64bit VLIW DSP 
%define EM_CYPRESS_M8C        161        ; Cypress M8C 
%define EM_R32C                162        ; Renesas R32C 
%define EM_TRIMEDIA        163        ; NXP Semi. TriMedia 
%define EM_QDSP6        164        ; QUALCOMM DSP6 
%define EM_8051                165        ; Intel 8051 and variants 
%define EM_STXP7X        166        ; STMicroelectronics STxP7x 
%define EM_NDS32        167        ; Andes Tech. compact code emb. RISC 
%define EM_ECOG1X        168        ; Cyan Technology eCOG1X 
%define EM_MAXQ30        169        ; Dallas Semi. MAXQ30 mc 
%define EM_XIMO16        170        ; New Japan Radio (NJR) 16-bit DSP 
%define EM_MANIK        171        ; M2000 Reconfigurable RISC 
%define EM_CRAYNV2        172        ; Cray NV2 vector architecture 
%define EM_RX                173        ; Renesas RX 
%define EM_METAG        174        ; Imagination Tech. META 
%define EM_MCST_ELBRUS        175        ; MCST Elbrus 
%define EM_ECOG16        176        ; Cyan Technology eCOG16 
%define EM_CR16                177        ; National Semi. CompactRISC CR16 
%define EM_ETPU                178        ; Freescale Extended Time Processing Unit 
%define EM_SLE9X        179        ; Infineon Tech. SLE9X 
%define EM_L10M                180        ; Intel L10M 
%define EM_K10M                181        ; Intel K10M 
                                ; reserved 182 
%define EM_AARCH64        183        ; ARM AARCH64 
                                ; reserved 184 
%define EM_AVR32        185        ; Amtel 32-bit microprocessor 
%define EM_STM8                186        ; STMicroelectronics STM8 
%define EM_TILE64        187        ; Tileta TILE64 
%define EM_TILEPRO        188        ; Tilera TILEPro 
%define EM_MICROBLAZE        189        ; Xilinx MicroBlaze 
%define EM_CUDA                190        ; NVIDIA CUDA 
%define EM_TILEGX        191        ; Tilera TILE-Gx 
%define EM_CLOUDSHIELD        192        ; CloudShield 
%define EM_COREA_1ST        193        ; KIPO-KAIST Core-A 1st gen. 
%define EM_COREA_2ND        194        ; KIPO-KAIST Core-A 2nd gen. 
%define EM_ARC_COMPACT2        195        ; Synopsys ARCompact V2 
%define EM_OPEN8        196        ; Open8 RISC 
%define EM_RL78                197        ; Renesas RL78 
%define EM_VIDEOCORE5        198        ; Broadcom VideoCore V 
%define EM_78KOR        199        ; Renesas 78KOR 
%define EM_56800EX        200        ; Freescale 56800EX DSC 
%define EM_BA1                201        ; Beyond BA1 
%define EM_BA2                202        ; Beyond BA2 
%define EM_XCORE        203        ; XMOS xCORE 
%define EM_MCHP_PIC        204        ; Microchip 8-bit PIC(r) 
                                ; reserved 205-209 
%define EM_KM32                210        ; KM211 KM32 
%define EM_KMX32        211        ; KM211 KMX32 
%define EM_EMX16        212        ; KM211 KMX16 
%define EM_EMX8                213        ; KM211 KMX8 
%define EM_KVARC        214        ; KM211 KVARC 
%define EM_CDP                215        ; Paneve CDP 
%define EM_COGE                216        ; Cognitive Smart Memory Processor 
%define EM_COOL                217        ; Bluechip CoolEngine 
%define EM_NORC                218        ; Nanoradio Optimized RISC 
%define EM_CSR_KALIMBA        219        ; CSR Kalimba 
%define EM_Z80                220        ; Zilog Z80 
%define EM_VISIUM        221        ; Controls and Data Services VISIUMcore 
%define EM_FT32                222        ; FTDI Chip FT32 
%define EM_MOXIE        223        ; Moxie processor 
%define EM_AMDGPU        224        ; AMD GPU 
                                ; reserved 225-242 
%define EM_RISCV        243        ; RISC-V 
%define EM_BPF                247        ; Linux BPF -- in-kernel virtual machine 
%define EM_CSKY                252     ; C-SKY 
%define EM_NUM                253
; Old spellings/synonyms.  
%define EM_ARC_A5        EM_ARC_COMPACT

; If it is necessary to assign new unofficial EM_* values, please
;   pick large random numbers (0x8523, 0xa7f2, etc.) to minimize the
;   chances of collision with official or non-GNU unofficial values.  

%define EM_ALPHA        0x9026
; Legal values for e_version (version).  
section .data
    space               db  " ", 0x0
    newline             db  0xA, 0x0
    byteifmsg           db  " (bytes into file)", 0xA, 0x0
    bytemsg             db  " (bytes)", 0xA, 0x0

    ElfHeaderMsg        db  "ELF Header:", 0xA, 0x0
    ElfMagicMsg         db  "   Magic:  ", 0x0
    
    ElfClassMsg         db  "   Class:                                  ", 0x0
    ElfClass32Msg       db  "ELF32", 0xA, 0x0
    ElfClass64Msg       db  "ELF64", 0xA, 0x0
    ElfClassNone        db  "Invalid class", 0xA, 0x0

    ElfDataMsg          db  "   Data:                                   ", 0x0
    ElfDataLSBMsg       db  "2's complement, little endian", 0xA, 0x0
    ElfDataMSBMsg       db  "2's complement, big endian", 0xA, 0x0
    ElfDataNone         db  "Invalid data encoding", 0xA, 0x0

    ElfVersionMsg       db  "   Version:                                ", 0x0
    ElfVersionCurrentMsg   db  "1 (current)", 0xA, 0x0
    ElfVersionNoneMsg   db  "0 (invalid)", 0xA, 0x0

    ElfOSABIMsg         db  "   OS/ABI:                                 ", 0x0
    ElfOSABINoneMsg     db  "Invalid OS/ABI", 0xA, 0x0

    ElfABIMsg           db  "   ABI Version:                            ", 0x0

    ElfTypeMsg          db  "   Type:                                   ", 0x0
    ElfTypeNoneMsg      db  "Invalid type", 0xA, 0x0

    ElfMachineMsg       db  "   Machine:                                ", 0x0
    ElfMachineNoneMsg   db  "Invalid machine", 0xA, 0x0

    ElfVersion2Msg      db  "   Version:                                ", 0x0
    ElfVersion2CurrentMsg   db  "0x1", 0xA, 0x0
    ElfVersion2NoneMsg  db  "0x0", 0xA, 0x0

    ElfEntryMsg         db  "   Entry point address:                    ", 0x0
    
    ElfPHTMsg           db  "   Start of program headers:               ", 0x0
    
    ElfSHTMsg           db  "   Start of section headers:               ", 0x0

    ElfFlagsMsg         db  "   Flags:                                  ", 0x0

    ElfSizeHeaderMsg    db  "   Size of this header:                    ", 0x0

    ElfSizePHeaderMsg   db  "   Size of program headers:                ", 0x0

    ElfNumPHeaderMsg    db  "   Number of program headers:              ", 0x0

    ElfSizeSHeaderMsg   db  "   Size of section headers:                ", 0x0

    ElfNumSHeaderMsg    db  "   Number of section headers:              ", 0x0

    ElfSHeaderIndex     db  "   Section header string table index:      ", 0x0

    SecHeaderMsg        db  "Section Headers:", 0xA, 0x0

    ElfOSABIStr:
        dd 0
        db "UNIX - System V", 0Ah, 0
        dd 1
        db "UNIX - HP-UX", 0Ah, 0
        dd 2
        db "UNIX - NetBSD", 0Ah, 0
        dd 3
        db "UNIX - GNU", 0Ah, 0
        dd 6
        db "UNIX - Solaris", 0Ah, 0
        dd 7
        db "UNIX - AIX", 0Ah, 0
        dd 8
        db "UNIX - IRIX", 0Ah, 0
        dd 9
        db "UNIX - FreeBSD", 0Ah, 0
        dd 10
        db "UNIX - TRU64", 0Ah, 0
        dd 11
        db "Novell - Modesto", 0Ah, 0
        dd 12
        db "UNIX - OpenBSD", 0Ah, 0
        dd 13
        db "VMS - OpenVMS", 0Ah, 0
        dd 14
        db "HP - Non-Stop Kernel", 0Ah, 0
        dd 15
        db "AROS", 0Ah, 0
        dd 16
        db "FenixOS", 0Ah, 0
        dd 17
        db "Nuxi CloudABI", 0Ah, 0
        dd 18
        db "Stratus Technologies OpenVOS", 0Ah, 0
        dd -1

    ElfTypeStr:
        dd 0
        db 'ET_NONE (No file type)        ', 0Ah, 0
        dd 1
        db 'ET_REL (Relocatable file)     ', 0Ah, 0
        dd 2
        db 'ET_EXEC (Executable file)     ', 0Ah, 0
        dd 3
        db 'ET_DYN (Shared object file)   ', 0Ah, 0
        dd 4
        db 'ET_CORE (Core file)           ', 0Ah, 0
        dd 0xfe00
        db 'ET_LOOS (Operating system specific)', 0Ah, 0
        dd 0xfeff
        db 'ET_HIOS (Operating system specific)', 0Ah, 0
        dd 0xff00
        db 'ET_LOPROC (Processor specific)', 0Ah, 0
        dd 0xffff
        db 'ET_HIPROC (Processor specific)', 0Ah, 0
        dd -1

    ElfMachineStr:
        dd EM_NONE		
        db "None", 0xA, 0
        dd EM_M32		
        db "WE32100", 0xA, 0
        dd EM_SPARC		
        db "Sparc", 0xA, 0
        dd EM_386		
        db "Intel 80386", 0xA, 0
        dd EM_68K		
        db "MC68000", 0xA, 0
        dd EM_88K		
        db "MC88000", 0xA, 0
        dd EM_IAMCU		
        db "Intel MCU", 0xA, 0
        dd EM_860		
        db "Intel 80860", 0xA, 0
        dd EM_MIPS		
        db "MIPS R3000", 0xA, 0
        dd EM_S370		
        db "IBM System/370", 0xA, 0
        ; 10 
        dd EM_MIPS_RS3_LE	
        db "MIPS R4000 big-endian", 0xA, 0
        dd EM_PARISC		
        db "HPPA", 0xA, 0
        dd EM_SPARC32PLUS	
        db "Sparc v8+" , 0xA, 0
        dd EM_960		
        db "Intel 80960", 0xA, 0
        dd EM_PPC		
        db "PowerPC", 0xA, 0
        ; 20 
        dd EM_PPC64		
        db "PowerPC64", 0xA, 0
        dd EM_S390		
        db "IBM S/390", 0xA, 0
        dd EM_SPU		
        db "SPU", 0xA, 0
        ; 30 
        dd EM_V800		
        db "Renesas V850 (using RH850 ABI)", 0xA, 0
        dd EM_FR20		
        db "Fujitsu FR20", 0xA, 0
        dd EM_RH32		
        db "TRW RH32", 0xA, 0
        ; 40 
        dd EM_ARM		
        db "ARM", 0xA, 0
        dd EM_SH			
        db "Renesas / SuperH SH", 0xA, 0
        dd EM_SPARCV9		
        db "Sparc v9", 0xA, 0
        dd EM_TRICORE		
        db "Siemens Tricore", 0xA, 0
        dd EM_ARC		
        db "ARC", 0xA, 0
        dd EM_H8_300		
        db "Renesas H8/300", 0xA, 0
        dd EM_H8_300H		
        db "Renesas H8/300H", 0xA, 0
        dd EM_H8S		
        db "Renesas H8S", 0xA, 0
        dd EM_H8_500		
        db "Renesas H8/500", 0xA, 0
        ; 50 
        dd EM_IA_64		
        db "Intel IA-64", 0xA, 0
        dd EM_MIPS_X		
        db "Stanford MIPS-X", 0xA, 0
        dd EM_COLDFIRE		
        db "Motorola Coldfire", 0xA, 0
        dd EM_68HC12		
        db "Motorola MC68HC12 Microcontroller", 0xA, 0
        dd EM_MMA		
        db "Fujitsu Multimedia Accelerator", 0xA, 0
        dd EM_PCP		
        db "Siemens PCP", 0xA, 0
        dd EM_NCPU		
        db "Sony nCPU embedded RISC processor", 0xA, 0
        dd EM_NDR1		
        db "Denso NDR1 microprocesspr", 0xA, 0
        dd EM_STARCORE		
        db "Motorola Star*Core processor", 0xA, 0
        dd EM_ME16		
        db "Toyota ME16 processor", 0xA, 0
        ; 60 
        dd EM_ST100		
        db "STMicroelectronics ST100 processor", 0xA, 0
        dd EM_TINYJ		
        db "Advanced Logic Corp. TinyJ embedded processor", 0xA, 0
        dd EM_X86_64		
        db "Advanced Micro Devices X86-64", 0xA, 0
        dd EM_PDSP		
        db "Sony DSP processor", 0xA, 0
        dd EM_PDP10		
        db "Digital Equipment Corp. PDP-10", 0xA, 0
        dd EM_PDP11		
        db "Digital Equipment Corp. PDP-11", 0xA, 0
        dd EM_FX66		
        db "Siemens FX66 microcontroller", 0xA, 0
        dd EM_ST9PLUS		
        db "STMicroelectronics ST9+ 8/16 bit microcontroller", 0xA, 0
        dd EM_ST7		
        db "STMicroelectronics ST7 8-bit microcontroller", 0xA, 0
        dd EM_68HC16		
        db "Motorola MC68HC16 Microcontroller", 0xA, 0
        ; 70 
        dd EM_68HC11		
        db "Motorola MC68HC11 Microcontroller", 0xA, 0
        dd EM_68HC08		
        db "Motorola MC68HC08 Microcontroller", 0xA, 0
        dd EM_68HC05		
        db "Motorola MC68HC05 Microcontroller", 0xA, 0
        dd EM_SVX		
        db "Silicon Graphics SVx", 0xA, 0
        dd EM_ST19		
        db "STMicroelectronics ST19 8-bit microcontroller", 0xA, 0
        dd EM_VAX		
        db "Digital VAX", 0xA, 0
        dd EM_CRIS		
        db "Axis Communications 32-bit embedded processor", 0xA, 0
        dd EM_JAVELIN		
        db "Infineon Technologies 32-bit embedded cpu", 0xA, 0
        dd EM_FIREPATH		
        db "Element 14 64-bit DSP processor", 0xA, 0
        dd EM_ZSP		
        db "LSI Logic's 16-bit DSP processor", 0xA, 0
        ; 80 
        dd EM_MMIX		
        db "Donald Knuth's educational 64-bit processor", 0xA, 0
        dd EM_HUANY		
        db "Harvard Universitys's machine-independent object format", 0xA, 0
        dd EM_PRISM		
        db "Vitesse Prism", 0xA, 0
        dd EM_AVR		
        db "Atmel AVR 8-bit microcontroller", 0xA, 0
        dd EM_FR30		
        db "Fujitsu FR30", 0xA, 0
        dd EM_D10V		
        db "d10v", 0xA, 0
        dd EM_D30V		
        db "d30v", 0xA, 0
        dd EM_V850		
        db "Renesas V850", 0xA, 0
        dd EM_M32R		
        db "Renesas M32R (formerly Mitsubishi M32r)", 0xA, 0
        dd EM_MN10300		
        db "mn10300", 0xA, 0
        ; 90 
        dd EM_MN10200		
        db "mn10200", 0xA, 0
        dd EM_PJ			
        db "picoJava", 0xA, 0
        dd EM_ARC_COMPACT	
        db "ARCompact", 0xA, 0
        dd EM_XTENSA		
        db "Tensilica Xtensa Processor", 0xA, 0
        dd EM_VIDEOCORE		
        db "Alphamosaic VideoCore processor", 0xA, 0
        dd EM_TMM_GPP		
        db "Thompson Multimedia General Purpose Processor", 0xA, 0
        dd EM_NS32K		
        db "National Semiconductor 32000 series", 0xA, 0
        dd EM_TPC		
        db "Tenor Network TPC processor", 0xA, 0
        dd EM_SNP1K	        
        db "Trebia SNP 1000 processor", 0xA, 0
        ; 100 
        dd EM_ST200		
        db "STMicroelectronics ST200 microcontroller", 0xA, 0
        dd EM_IP2K		
        db "Ubicom IP2xxx 8-bit microcontrollers", 0xA, 0
        dd EM_MAX		
        db "MAX Processor", 0xA, 0
        dd EM_CR			
        db "National Semiconductor CompactRISC", 0xA, 0
        dd EM_F2MC16		
        db "Fujitsu F2MC16", 0xA, 0
        dd EM_MSP430		
        db "Texas Instruments msp430 microcontroller", 0xA, 0
        dd EM_BLACKFIN		
        db "Analog Devices Blackfin", 0xA, 0
        dd EM_SE_C33		
        db "S1C33 Family of Seiko Epson processors", 0xA, 0
        dd EM_SEP		
        db "Sharp embedded microprocessor", 0xA, 0
        dd EM_ARCA		
        db "Arca RISC microprocessor", 0xA, 0
        ; 110 
        dd EM_UNICORE		
        db "Unicore", 0xA, 0
        dd EM_EXCESS		
        db "eXcess 16/32/64-bit configurable embedded CPU", 0xA, 0
        dd EM_DXP		
        db "Icera Semiconductor Inc. Deep Execution Processor", 0xA, 0
        dd EM_ALTERA_NIOS2	
        db "Altera Nios II", 0xA, 0
        dd EM_CRX		
        db "National Semiconductor CRX microprocessor", 0xA, 0
        dd EM_XGATE		
        db "Motorola XGATE embedded processor", 0xA, 0
        dd EM_M16C		
        db "Renesas M16C series microprocessors", 0xA, 0
        dd EM_DSPIC30F		
        db "Microchip Technology dsPIC30F Digital Signal Controller", 0xA, 0
        dd EM_CE			
        db "Freescale Communication Engine RISC core", 0xA, 0
        ; 120 
        dd EM_M32C	        
        db "Renesas M32c", 0xA, 0
        ; 130 
        dd EM_TSK3000		
        db "Altium TSK3000 core", 0xA, 0
        dd EM_RS08		
        db "Freescale RS08 embedded processor", 0xA, 0
        dd EM_ECOG2		
        db "Cyan Technology eCOG2 microprocessor", 0xA, 0
        dd EM_DSP24		
        db "New Japan Radio (NJR) 24-bit DSP Processor", 0xA, 0
        dd EM_VIDEOCORE3		
        db "Broadcom VideoCore III processor", 0xA, 0
        dd EM_LATTICEMICO32	
        db "Lattice Mico32", 0xA, 0
        dd EM_SE_C17		
        db "Seiko Epson C17 family", 0xA, 0
        ; 140 
        dd EM_TI_C6000		
        db "Texas Instruments TMS320C6000 DSP family", 0xA, 0
        dd EM_TI_C2000		
        db "Texas Instruments TMS320C2000 DSP family", 0xA, 0
        dd EM_TI_C5500		
        db "Texas Instruments TMS320C55x DSP family", 0xA, 0
        dd EM_TI_PRU		
        db "TI PRU I/O processor", 0xA, 0
        ; 160 
        dd EM_MMDSP_PLUS		
        db "STMicroelectronics 64bit VLIW Data Signal Processor", 0xA, 0
        dd EM_CYPRESS_M8C	
        db "Cypress M8C microprocessor", 0xA, 0
        dd EM_R32C		
        db "Renesas R32C series microprocessors", 0xA, 0
        dd EM_TRIMEDIA		
        db "NXP Semiconductors TriMedia architecture family", 0xA, 0
        dd EM_QDSP6		
        db "QUALCOMM DSP6 Processor", 0xA, 0
        dd EM_8051		
        db "Intel 8051 and variants", 0xA, 0
        dd EM_STXP7X		
        db "STMicroelectronics STxP7x family", 0xA, 0
        dd EM_NDS32		
        db "Andes Technology compact code size embedded RISC processor family", 0xA, 0
        dd EM_ECOG1X		
        db "Cyan Technology eCOG1X family", 0xA, 0
        dd EM_MAXQ30		
        db "Dallas Semiconductor MAXQ30 Core microcontrollers", 0xA, 0
        ; 170 
        dd EM_XIMO16		
        db "New Japan Radio (NJR) 16-bit DSP Processor", 0xA, 0
        dd EM_MANIK		
        db "M2000 Reconfigurable RISC Microprocessor", 0xA, 0
        dd EM_CRAYNV2		
        db "Cray Inc. NV2 vector architecture", 0xA, 0
        dd EM_RX			
        db "Renesas RX", 0xA, 0
        dd EM_METAG		
        db "Imagination Technologies Meta processor architecture", 0xA, 0
        dd EM_MCST_ELBRUS	
        db "MCST Elbrus general purpose hardware architecture", 0xA, 0
        dd EM_ECOG16		
        db "Cyan Technology eCOG16 family", 0xA, 0
        dd EM_CR16
        db "Xilinx MicroBlaze", 0xA, 0
        dd EM_MICROBLAZE
        db "Xilinx MicroBlaze", 0xA, 0
        dd EM_ETPU		
        db "Freescale Extended Time Processing Unit", 0xA, 0
        dd EM_SLE9X		
        db "Infineon Technologies SLE9X core", 0xA, 0
        ; 180 
        dd EM_AARCH64		
        db "AArch64", 0xA, 0
        dd EM_AVR32		
        db "Atmel Corporation 32-bit microprocessor", 0xA, 0
        dd EM_STM8		
        db "STMicroeletronics STM8 8-bit microcontroller", 0xA, 0
        dd EM_TILE64		
        db "Tilera TILE64 multicore architecture family", 0xA, 0
        dd EM_TILEPRO		
        db "Tilera TILEPro multicore architecture family", 0xA, 0
        ; 190 
        dd EM_CUDA		
        db "NVIDIA CUDA architecture", 0xA, 0
        dd EM_TILEGX		
        db "Tilera TILE-Gx multicore architecture family", 0xA, 0
        dd EM_CLOUDSHIELD	
        db "CloudShield architecture family", 0xA, 0
        dd EM_COREA_1ST		
        db "KIPO-KAIST Core-A 1st generation processor family", 0xA, 0
        dd EM_COREA_2ND		
        db "KIPO-KAIST Core-A 2nd generation processor family", 0xA, 0
        dd EM_ARC_COMPACT2	
        db "ARCv2", 0xA, 0
        dd EM_OPEN8		
        db "Open8 8-bit RISC soft processor core", 0xA, 0
        dd EM_RL78		
        db "Renesas RL78", 0xA, 0
        dd EM_VIDEOCORE5		
        db "Broadcom VideoCore V processor", 0xA, 0
        ; 200 
        dd EM_56800EX		
        db "Freescale 56800EX Digital Signal Controller (DSC)", 0xA, 0
        dd EM_BA1		
        db "Beyond BA1 CPU architecture", 0xA, 0
        dd EM_BA2		
        db "Beyond BA2 CPU architecture", 0xA, 0
        dd EM_XCORE		
        db "XMOS xCORE processor family", 0xA, 0
        dd EM_MCHP_PIC		
        db "Microchip 8-bit PIC(r) family", 0xA, 0
        ; 210 
        dd EM_KM32		
        db "KM211 KM32 32-bit processor", 0xA, 0
        dd EM_KMX32		
        db "KM211 KMX32 32-bit processor", 0xA, 0
        dd EM_KVARC		
        db "KM211 KVARC processor", 0xA, 0
        dd EM_CDP		
        db "Paneve CDP architecture family", 0xA, 0
        dd EM_COGE		
        db "Cognitive Smart Memory Processor", 0xA, 0
        dd EM_COOL		
        db "Bluechip Systems CoolEngine", 0xA, 0
        dd EM_NORC		
        db "Nanoradio Optimized RISC", 0xA, 0
        dd EM_CSR_KALIMBA	
        db "CSR Kalimba architecture family", 0xA, 0
        ; 220 
        dd EM_Z80		
        db "Zilog Z80", 0xA, 0
        dd EM_VISIUM		
        db "CDS VISIUMcore processor", 0xA, 0
        dd EM_FT32               
        db "FTDI Chip FT32", 0xA, 0
        dd EM_MOXIE              
        db "Moxie", 0xA, 0
        dd EM_AMDGPU 	 	
        db "AMD GPU", 0xA, 0
        ; 230 (all reserved) 
        ; 240 
        dd EM_RISCV 	 	
        db "RISC-V", 0xA, 0
        dd EM_BPF		
        db "Linux BPF", 0xA, 0
        ; 250 
        dd EM_CSKY		
        db "C-SKY", 0xA, 0

        ; Large numbers...  
        dd EM_ALPHA		
        db "Alpha", 0xA, 0
        dd -1

section .bss
    filename        resb 32
    f_input         resb 32
    stat            resb 92
    file            resb 1000000
    hex             resb 8
    numstr          resb 12

struc STAT
    .st_dev         resb 8
    .st_ino         resb 8
    .st_mode        resb 4
    .st_nlink       resb 8
    .st_uid         resb 4
    .st_gid         resb 4
    .st_rdev        resb 8
    .st_size        resb 8
    .st_blksize     resb 8
    .st_blocks      resb 8
    .st_atime       resb 8
    .st_mtime       resb 8
    .st_ctime       resb 8
endstruc
    
struc e_ident
	.EI_MAG		    resb 4	; ELF "magic number" (0x7f, 'ELF')
	.EI_CLASS	    resb 1	; file's class, or capacity
	.EI_DATA	    resb 1	; data encoding of the cpu-specific data
	.EI_VERSION	    resb 1	; ELF header version number (set to EV_CURRENT)
    .EI_OSABI       resb 1
    .EI_ABIVERSION  resb 1
	.EI_PAD		    resb 7	; marks the beginning of the unused bytes
endstruc

struc ELF32_Ehdr
    .e_ident        resb 16
    .e_type         resw 1
    .e_machine      resw 1
    .e_version      resd 1
    .e_entry        resd 1
    .e_phoff        resd 1
    .e_shoff        resd 1
    .e_flags        resd 1
    .e_ehsize       resw 1
    .e_phentsize    resw 1
    .e_phnum        resw 1
    .e_shentsize    resw 1
    .e_shnum        resw 1
    .e_shstrndx     resw 1
endstruc


section .text
    global _start

_start:
    pop ecx ; Return address
    pop ecx ; argc
    pop ecx ; argv 
    mov ecx, [ecx]

    ; open file
    mov [filename], ecx
    mov eax, SYS_OPEN
    mov ebx, filename
    mov ecx, 2
    xor edx, edx
    int 0x80

    mov [f_input], eax

    ; use sys_stat to get file_size
    mov eax, SYS_STAT
    mov ebx, filename
    mov ecx, stat
    int 0x80

    ; read file 
    mov eax, SYS_READ
    mov ebx, [f_input]
    mov ecx, file
    mov edx, [stat + STAT.st_size]
    int 0x80

    ; mov eax, SYS_WRITE
    ; mov ebx, STDOUT
    ; mov ecx, file
    ; mov edx, [stat + STAT.st_size]
    ; int 0x80

    ; check elf file
    mov eax, [file]
    cmp eax, 0x464c457f
    jne exit

    ;-------------------------------------------------------------------------
    ; print elf header
    mov ecx, ElfHeaderMsg
    call printStr

    ; print magic
    mov ecx, ElfMagicMsg
    call printStr

    xor ecx, ecx

magicloop:
    xor eax, eax
    mov al, [file + ecx]
    push ecx
    call printHexByte
    mov ecx, space
    call printStr
    pop ecx
    inc ecx
    cmp ecx, 16
    je magicloop_print
    jmp magicloop

    magicloop_print:
        mov ecx, newline
        call printStr

elf_class:
    ; print class
    mov ecx, ElfClassMsg
    call printStr

    cmp byte [file + e_ident.EI_CLASS], 1
    je elf_class_32
    cmp byte [file + e_ident.EI_CLASS], 2
    je elf_class_64
    mov ecx, ElfClassNone
    jmp elf_class_print

    elf_class_32:
        mov ecx, ElfClass32Msg
        jmp elf_class_print

    elf_class_64:
        mov ecx, ElfClass64Msg

    elf_class_print:
        call printStr

elf_data:
    ; print data
    mov ecx, ElfDataMsg
    call printStr

    cmp byte [file + e_ident.EI_DATA], 1
    je elf_data_lsb
    cmp byte [file + e_ident.EI_DATA], 2
    je elf_data_msb
    mov ecx, ElfDataNone
    jmp elf_data_print

    elf_data_lsb:
        mov ecx, ElfDataLSBMsg
        jmp elf_data_print
    
    elf_data_msb:
        mov ecx, ElfDataMSBMsg

    elf_data_print:
        call printStr

elf_version:
    ; print version
    mov ecx, ElfVersionMsg
    call printStr

    cmp byte [file + e_ident.EI_VERSION], 1
    je elf_version_current
    mov ecx, ElfVersionNoneMsg
    jmp elf_version_print

    elf_version_current:
        mov ecx, ElfVersionCurrentMsg
        jmp elf_version_print

    elf_version_print:
        call printStr

elf_osabi:
    ; print osabi
    mov ecx, ElfOSABIMsg
    call printStr

    xor edi, edi
    xor eax, eax
    movzx edi, byte [file + e_ident.EI_OSABI]
    mov ecx, ElfOSABIStr
    call findInArray

    cmp eax, -1
    je elf_osabi_none
    jmp elf_osabi_print

    elf_osabi_none:
        mov ecx, ElfOSABINoneMsg

    elf_osabi_print:
        call printStr

elf_abi:
    ; print abi version
    mov ecx, ElfABIMsg
    call printStr

    movzx eax, byte [file + e_ident.EI_ABIVERSION]
    call printNumber

    mov ecx, newline
    call printStr

elf_type:
    ; print type
    mov ecx, ElfTypeMsg
    call printStr

    xor edi, edi
    xor eax, eax
    movzx edi, word [file + ELF32_Ehdr.e_type]
    mov ecx, ElfTypeStr
    call findInArray

    cmp eax, -1
    je elf_type_none
    jmp elf_type_print

    elf_type_none:
        mov ecx, ElfTypeNoneMsg

    elf_type_print:
        call printStr

elf_machine:
    ; print machine
    mov ecx, ElfMachineMsg
    call printStr

    xor edi, edi
    xor eax, eax
    movzx edi, word [file + ELF32_Ehdr.e_machine]
    mov ecx, ElfMachineStr
    call findInArray

    cmp eax, -1
    je elf_machine_none
    jmp elf_machine_print

    elf_machine_none:
        mov ecx, ElfMachineNoneMsg

    elf_machine_print:
        call printStr

elf_version2:
    ; print version2
    mov ecx, ElfVersion2Msg
    call printStr

    cmp byte [file + e_ident.EI_VERSION], 1
    je elf_version2_current
    mov ecx, ElfVersion2NoneMsg
    jmp elf_version2_print

    elf_version2_current:
        mov ecx, ElfVersion2CurrentMsg
        jmp elf_version2_print

    elf_version2_print:
        call printStr

elf_entry:
    ; print entry
    mov ecx, ElfEntryMsg
    call printStr
    
    mov eax, dword [file + ELF32_Ehdr.e_entry]
    call printHexNumber

    mov ecx, newline
    call printStr

elf_pht:
    ; print start of program headers
    mov ecx, ElfPHTMsg
    call printStr

    mov eax, dword [file + ELF32_Ehdr.e_phoff]
    call printNumber

    mov ecx, byteifmsg
    call printStr

elf_sht:
    ; print start of section headers
    mov ecx, ElfSHTMsg
    call printStr

    mov eax, dword [file + ELF32_Ehdr.e_shoff]
    call printNumber

    mov ecx, byteifmsg
    call printStr

elf_flags:
    ; print flags
    mov ecx, ElfFlagsMsg
    call printStr

    mov eax, dword [file + ELF32_Ehdr.e_flags]
    call printHexNumber

    mov ecx, newline
    call printStr

elf_sizeheader:
    ; print size of this header
    mov ecx, ElfSizeHeaderMsg
    call printStr

    xor eax, eax
    movzx eax, word [file + ELF32_Ehdr.e_ehsize]
    call printNumber

    mov ecx, bytemsg
    call printStr

elf_sizepheader:
    ; print size of program headers
    mov ecx, ElfSizePHeaderMsg
    call printStr

    xor eax, eax
    movzx eax, word [file + ELF32_Ehdr.e_phentsize]
    call printNumber

    mov ecx, bytemsg
    call printStr

elf_numpheader:
    ; print number of program headers
    mov ecx, ElfNumPHeaderMsg
    call printStr

    xor eax, eax
    movzx eax, word [file + ELF32_Ehdr.e_phnum]
    call printNumber

    mov ecx, newline
    call printStr

elf_sizesheader:
    ; print size of section headers
    mov ecx, ElfSizeSHeaderMsg
    call printStr

    xor eax, eax
    movzx eax, word [file + ELF32_Ehdr.e_shentsize]
    call printNumber

    mov ecx, bytemsg
    call printStr

elf_numsheader:
    ; print number of section headers
    mov ecx, ElfNumSHeaderMsg
    call printStr

    xor eax, eax
    movzx eax, word [file + ELF32_Ehdr.e_shnum]
    call printNumber

    mov ecx, newline
    call printStr

elf_sectionheaderindex:
    ; print section header string table index
    mov ecx, ElfSHeaderIndex
    call printStr

    xor eax, eax
    movzx eax, word [file + ELF32_Ehdr.e_shstrndx]
    call printNumber

    mov ecx, newline
    call printStr

    ;-------------------------------------------------------------------------
    ; print section header
    mov ecx, newline
    call printStr

    mov ecx, SecHeaderMsg
    call printStr

exit:
    mov eax, SYS_EXIT
    xor ebx, ebx
    int 0x80


strlen:
    xor eax, eax
    mov edi, ecx
    strlen_loop:
        cmp byte [edi], 0
        je strlen_done
        inc edi
        inc eax
        jmp strlen_loop

    strlen_done:
        ret

printStr:
    call strlen
    mov edx, eax
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    int 0x80
    ret

findInArray:
    cmp dword [ecx], -1
    je find_unknown

    cmp edi, [ecx]
    je find_done

    inc ecx
    jmp findInArray

    find_unknown:
        mov eax, -1
        ret

    find_done:
        add ecx, 4
        ret



decimalToByteHex:
    xor edi, edi
    mov [hex], edi
    mov [hex + 4], edi
    mov dl, 16
    div dl
    mov ebx, hex
    add al, 48
    cmp al, 58
    jae addToHexAl

    contAfterAl:
        mov [ebx], al
        inc ebx
        add ah, 0x30
        cmp ah, 58
        jae addToHexAh

    contAfterAh:
        mov [ebx], ah
        ret

    addToHexAl:
        add al, 39
        jmp contAfterAl
    
    addToHexAh:
        add ah, 39
        jmp contAfterAh

decimalToHex:
    xor edi, edi
    mov [hex], edi
    mov [hex + 4], edi
    mov edi, hex
    mov [edi], byte 0x30
    inc edi
    mov [edi], byte 0x78
    inc edi
    xor ecx, ecx

    dth_loop:
        mov ebx, 16
        xor edx, edx
        div ebx
        push edx
        inc ecx
        cmp eax, 0
        je dth_done
        jmp dth_loop

    dth_done:
        pop edx
        add edx, 0x30
        cmp edx, 58
        jae addToHex
        jmp addToHex_done
        
        addToHex:
            add edx, 39
            
        addToHex_done:
            mov [edi], edx
            inc edi
            loop dth_done
    
    ret

printHexByte:
    call decimalToByteHex
    mov ecx, hex
    call printStr
    ret

printHexNumber:
    call decimalToHex
    mov ecx, hex
    call printStr

decimalToString:
    xor edi, edi
    mov [numstr], edi
    mov [numstr + 4], edi
    mov [numstr + 8], edi
    mov edi, numstr
    xor ecx, ecx
    
    dts_loop:
        mov ebx, 10
        xor edx, edx
        div ebx
        push edx
        inc ecx
        cmp eax, 0
        je dts_done
        jmp dts_loop

    dts_done:
        pop edx
        add edx, 0x30
        mov [edi], edx
        inc edi
        loop dts_done

    ret

    

printNumber:
    call decimalToString
    mov ecx, numstr
    call printStr
    ret
