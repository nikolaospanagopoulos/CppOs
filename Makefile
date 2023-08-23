FILES = ./build/boot.o ./build/kernel.o ./build/pageFrameAllocator.o ./build/kernel.asm.o ./build/idt.asm.o ./build/idt.o ./build/memory.o ./build/string.o ./build/terminal.o ./build/io.asm.o 
FLAGS= -g -ffreestanding -falign-jumps -falign-functions -falign-labels -falign-loops -fstrength-reduce -fomit-frame-pointer -finline-functions -Wno-unused-function -fno-builtin -Werror -Wno-unused-label  -Wno-unused-parameter -nostdlib -nostartfiles -nodefaultlibs -Wall -O0 -Iinc
all: ./bin/kernel.bin
	mkdir -p isodir/boot/grub
	cp ./bin/kernel.bin isodir/boot/myos.bin
	cp grub.cfg isodir/boot/grub/grub.cfg
	grub-mkrescue -o myos.iso isodir
./bin/kernel.bin: $(FILES)
	i686-elf-ld -g -relocatable $(FILES) -o ./build/kernelfull.o
	i686-elf-gcc $(FLAGS) -T linker.ld -o ./bin/kernel.bin -ffreestanding -O0 -nostdlib ./build/kernelfull.o

./build/boot.o:
	nasm -f elf -g boot.asm -o ./build/boot.o
./build/kernel.asm.o:
	nasm -f elf -g kernel.asm -o ./build/kernel.asm.o
./build/idt.asm.o:
	nasm -f elf -g idt.asm -o ./build/idt.asm.o
./build/io.asm.o:
	nasm -f elf -g io.asm -o ./build/io.asm.o
./build/kernel.o:
	i686-elf-g++ -c $(FLAGS) kernel.cpp -o ./build/kernel.o -ffreestanding -O2 -Wall -Wextra -fno-exceptions -fno-rtti  
./build/terminal.o:
	i686-elf-g++ -c $(FLAGS) Terminal.cpp -o ./build/terminal.o -ffreestanding -O2 -Wall -Wextra -fno-exceptions -fno-rtti 
./build/string.o:
	i686-elf-g++ -c $(FLAGS) string.cpp -o ./build/string.o -ffreestanding -O2 -Wall -Wextra -fno-exceptions -fno-rtti  
./build/memory.o:
	i686-elf-g++ -c $(FLAGS) Memory.cpp -o ./build/memory.o -ffreestanding -O2 -Wall -Wextra -fno-exceptions -fno-rtti  
./build/idt.o:
	i686-elf-g++ -c $(FLAGS) idt.cpp -o ./build/idt.o -ffreestanding -O2 -Wall -Wextra -fno-exceptions -fno-rtti  
./build/pageFrameAllocator.o:
	i686-elf-g++ -c $(FLAGS) pageFrameAllocator.cpp -o ./build/pageFrameAllocator.o -ffreestanding -O2 -Wall -Wextra -fno-exceptions -fno-rtti  
clean:
	rm -rf ./bin/*
	rm -rf ./build/*
	rm -rf ./isodir/*

