FILES = ./build/boot.o ./build/kernel.o 

./bin/os.bin: $(FILES)
	i686-elf-g++ -T linker.ld -o ./bin/os.bin -ffreestanding -O2 -nostdlib ./build/boot.o ./build/kernel.o
	mkdir -p isodir/boot/grub
	cp ./bin/os.bin isodir/boot/myos.bin
	cp grub.cfg isodir/boot/grub/grub.cfg
	grub-mkrescue -o myos.iso isodir
./build/boot.o:
	nasm -felf32 boot.asm -o ./build/boot.o
./build/kernel.o:
	i686-elf-g++ -c kernel.cpp -o ./build/kernel.o -ffreestanding -O2 -Wall -Wextra -fno-exceptions -fno-rtti  
clean:
	rm -rf ./bin/*
	rm -rf ./build/*
