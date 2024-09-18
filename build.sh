#!/bin/bash

nasm boot.asm -o boot

qemu-system-i386 boot
