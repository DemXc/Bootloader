#!/bin/bash

# Set cross-compiler variables
export CROSS_COMPILE=i686-elf-

# Paths to source files
BOOT_SRC="boot.asm"
KERNEL_SRC_C="kernel/kernel.c"
KERNEL_SRC_ASM="kernel/kernel.asm"
PAGING_SRC="kernel/paging.c"  # Путь к файлу paging.c в директории kernel/
MALLOC_SRC="kernel/malloc.c"

# Driver
DRIVER_CODE_C="driver/driver.c"

# Output file names
BOOT_BIN="bootloader.bin"
KERNEL_BIN="kernel.bin"
OS_IMAGE="os-image.bin"

# Function to build the bootloader
build_bootloader() {
    echo "Building bootloader..."
    nasm -f bin $BOOT_SRC -o $BOOT_BIN
    echo "Bootloader built: $BOOT_BIN"
}

# Function to compile the kernel (C)
build_kernel_c() {
    echo "Building kernel (C)..."
    ${CROSS_COMPILE}gcc -m32 -ffreestanding -c $KERNEL_SRC_C -o kernel.o
    ${CROSS_COMPILE}gcc -m32 -ffreestanding -c $PAGING_SRC -o paging.o  # Компиляция paging.c
    echo "Kernel (C) and Paging built: kernel.o, paging.o"
}

# Function to compile the kernel (ASM)
build_kernel_asm() {
    echo "Building kernel (ASM)..."
    nasm -f elf32 -o kernel_asm.o $KERNEL_SRC_ASM
    echo "Kernel (ASM) built: kernel_asm.o"
}

# Function to link the kernel
link_kernel() {
    echo "Linking kernel..."
    ${CROSS_COMPILE}ld -m elf_i386 -o $KERNEL_BIN -Ttext 0x1000 kernel_asm.o kernel.o paging.o --oformat binary  # Линковка paging.o
    echo "Kernel linked: $KERNEL_BIN"
}

# Function to create the final image
create_image() {
    echo "Creating final image..."
    cat $BOOT_BIN $KERNEL_BIN > $OS_IMAGE
    echo "Image created: $OS_IMAGE"
}

# Function to run in QEMU
run_qemu() {
    echo "Running in QEMU..."
    qemu-system-i386 -drive format=raw,file=$OS_IMAGE
}

# Main build process
build_bootloader
build_kernel_c
build_kernel_asm
link_kernel
create_image
run_qemu
