#!/bin/bash

echo '[+] Assembling with Nasm ... '
nasm -f elf64 $1.nasm -o $1.o 

echo '[+] Linking ...'
ld -o $1 $1.o 

echo '[+] Done!'
