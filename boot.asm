;; Rust Kernel Loader

MAGIC_NUMBER equ 0x1BADB002                         ; define the magic number constant
FLAGS        equ 0x0                                ; multiboot flags
CHECKSUM     equ -MAGIC_NUMBER                      ; calculate the checksum
                                                    ; (magic number + checksum + flags should equal 0)
KERNEL_STACK_SIZE equ 8192                          ; size of stack in bytes
      
section .text                                       ; Multiboot Specification
        align 4                   
        dd MAGIC_NUMBER                              
        dd FLAGS                    
        dd CHECKSUM                   
      
global start                    
extern kmain	                                      ; fn kmain() from kernel.rs
      
start:                    
  cli 			                                        ; block interrupts
  mov esp, kernel_stack + KERNEL_STACK_SIZE	        ; set stack pointer
  call kmain            
  hlt		 	                                          ; halt the CPU
        
section .bss                    
align 4                                             ; align at 4 bytes
kernel_stack:                                       ; label points to beginning of memory
    resb KERNEL_STACK_SIZE                          ; reserve stack for the kernel