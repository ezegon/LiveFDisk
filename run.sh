#!/bin/bash

echo "Welcome to monOS install"

nasm -f bin -o monos.bin monos.asm

dd status=noxfer conv=notrunc if=monos.bin of=myimage.img

qemu-system-i386 myimage.img -hdb fat:./hdd
