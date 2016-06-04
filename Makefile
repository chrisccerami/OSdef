LD = ~/opt/bin/x86_64-pc-elf-ld
GRUB_MKRESCUE= ~/opt/bin/grub-mkrescue

default: run

build: os.iso

run: build/os.iso
	qemu-system-x86_64 -cdrom build/os.iso

build/multiboot_header.o: multiboot_header.asm
	mkdir -p build
	nasm -f elf64 multiboot_header.asm -o build/multiboot_header.o

build/boot.o: boot.asm
	mkdir -p build
	nasm -f elf64 boot.asm -o build/boot.o

build/kernel.bin: build/multiboot_header.o build/boot.o linker.ld
	${LD} -n -o build/kernel.bin -T linker.ld build/multiboot_header.o build/boot.o

build/os.iso: build/kernel.bin grub.cfg
	mkdir -p build/isofiles/boot/grub
	cp grub.cfg build/isofiles/boot/grub
	cp build/kernel.bin build/isofiles/boot/
	${GRUB_MKRESCUE} -o build/os.iso build/isofiles

.PHONY: clean
clean:
	rm -rf build
