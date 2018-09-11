#!/bin/bash

echo "Welcome to monOS install"

nasm -f bin -o monos.bin monos.asm
nasm -f bin -o loader.bin loader.asm

dd status=noxfer conv=notrunc if=loader.bin of=myimage.img
dd if=monos.bin seek=1 bs=512 of=myimage.img

qemu-system-i386 -s -S -fda myimage.img -hda ./hdd/mbrsda.img -boot order=ac
