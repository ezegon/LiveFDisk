#!/bin/bash

echo "Welcome to monOS install"

nasm -f bin -o monos.bin monos.asm

dd status=noxfer conv=notrunc if=monos.bin of=monos.qcow

qemu-system-i386 -s -hda monos.qcow
