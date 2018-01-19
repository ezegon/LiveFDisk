#!/bin/bash

echo "Welcome to monOS install"

nasm -f bin -o monos.bin monos.asm

dd status=noxfer conv=notrunc if=monos.bin of=myimage.img

qemu-system-i386 -fda myimage.img -hda ./discus/hdd_qcow2.qcow -boot order=ac
