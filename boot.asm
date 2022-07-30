bits 32

section .text
        ; Multiboot Specification
        align 4
        dd 0x1BADB002            ; Magic Number
        dd 0x00                  ; Flags
        dd - (0x1BADB002 + 0x00) ; Checksum. m+f+c should be zero

global start
extern kmain	        ;kmain from kernel.rs

start:
  cli 			        ;block interrupts
  mov esp, stack_space	;set stack pointer
  call kmain
  hlt		 	        ;halt the CPU

section .bss
resb 8192		        ;8KB for stack
stack_space: