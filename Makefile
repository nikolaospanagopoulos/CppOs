FILES = ./build/boot.o ./build/kernel.o ./build/pageFrameAllocator.o ./build/kernel.asm.o ./build/idt.asm.o ./build/idt.o ./build/memory.o ./build/string.o ./build/terminal.o

./bin/os.bin: $(FILES)
	i686-elf-g++ -T linker.ld -o ./bin/os.bin -ffreestanding -O2 -nostdlib $(FILES)
	mkdir -p isodir/boot/grub
	cp ./bin/os.bin isodir/boot/myos.bin
	cp grub.cfg isodir/boot/grub/grub.cfg
	grub-mkrescue -o myos.iso isodir
./build/boot.o:
	nasm -felf32 boot.asm -o ./build/boot.o
./build/kernel.asm.o:
	nasm -felf32 kernel.asm -o ./build/kernel.asm.o
./build/idt.asm.o:
	nasm -felf32 idt.asm -o ./build/idt.asm.o
./build/kernel.o:
	i686-elf-g++ -c kernel.cpp -o ./build/kernel.o -ffreestanding -O2 -Wall -Wextra -fno-exceptions -fno-rtti  
./build/terminal.o:
	i686-elf-g++ -c Terminal.cpp -o ./build/terminal.o -ffreestanding -O2 -Wall -Wextra -fno-exceptions -fno-rtti 
./build/string.o:
	i686-elf-g++ -c string.cpp -o ./build/string.o -ffreestanding -O2 -Wall -Wextra -fno-exceptions -fno-rtti  
./build/memory.o:
	i686-elf-g++ -c Memory.cpp -o ./build/memory.o -ffreestanding -O2 -Wall -Wextra -fno-exceptions -fno-rtti  
./build/idt.o:
	i686-elf-g++ -c idt.cpp -o ./build/idt.o -ffreestanding -O2 -Wall -Wextra -fno-exceptions -fno-rtti  
./build/pageFrameAllocator.o:
	i686-elf-g++ -c pageFrameAllocator.cpp -o ./build/pageFrameAllocator.o -ffreestanding -O2 -Wall -Wextra -fno-exceptions -fno-rtti  
clean:
	rm -rf ./bin/*
	rm -rf ./build/*
	rm -rf ./isodir/*
