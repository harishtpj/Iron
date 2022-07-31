OBJECTS = boot.o kernel.o
RSC = rustc
RSFLAGS =  -O --target i686-unknown-linux-gnu --emit obj -C panic=abort
LDFLAGS = -T link.ld -melf_i386
AS = nasm
ASFLAGS = -f elf32

all: kernel os.iso

kernel: $(OBJECTS)
	@ld $(LDFLAGS) $(OBJECTS) -o iso/boot/kernel
	@echo "--> Compiled Kernel"

os.iso: kernel
	@echo "--> Generating os.iso file"
	@genisoimage -R                              \
				-b boot/grub/stage2_eltorito    \
				-no-emul-boot                   \
				-boot-load-size 4               \
				-A MKS                          \
				-boot-info-table                \
				-o os.iso                       \
				iso
	@echo "--> Completed building OS"

%.o: %.rs
	@$(RSC) $(RSFLAGS) $<
	@echo "--> Compiled $<"

%.o: %.asm
	@$(AS) $(ASFLAGS) $<
	@echo "--> Compiled $<"

clean:
	@rm -rf *.o iso/boot/kernel os.iso