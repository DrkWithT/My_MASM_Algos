; Test2.asm
; By: Derek Tan
; Date: 11/16/2022
; Brief: Practice code for MUL and DIV instruction use.

INCLUDE Irvine32.inc

.data
	numB DWORD 66    ; b is 0x42: upper stack arg
	numA DWORD 78    ; a is 0x4E: lower stack arg

.code
; Procedure calcGCF
; Uses Euclid's Algorithm (unsigned number version) to find the GCF of numbers a,b.
; Params: DWORD a, DWORD b. Note: a >= b
; Uses: EAX as quotient, ECX is current divisor, EDX is current remainder.
; Returns: GCF(a, b) in EBX.
; ===========================
calcGCF PROC
	; create stack frame as reference point!
	push ebp
	mov ebp, esp

	; preserve regs
	push eax
	push ecx
	push edx

	; load in arguments from stack
	mov eax, DWORD PTR [ebp + 8]   ; curr_quotient = (eax)  // bottom stack arg above return addr.
	mov ecx, DWORD PTR [ebp + 12]   ; curr_divisor = (ecx)  // upper stack arg
	mov edx, 0    ; rem = 0

RepEucAl:    ; Begin Euclid's Algorithm... Repeat the algo in do while style looping.
	; STEP 1: do modular division!
	div ecx    ; curr_quotient /= curr_divisor... rem = (edx) = curr_quotient % curr_divisor

	; STEP 2: conditional loop check: until (rem == 0)
	cmp edx, 0
	je EndEucAl

	; STEP 3: update quotient and divisor!
	mov eax, ecx    ; curr_quotient = curr_divisor
	mov ecx, edx    ; curr_divisor = rem
	mov edx, 0    ; reset sign extension and remainder reg: EDX!

	jmp RepEucAl
EndEucAl:
	; get last current divisor as GCF: return curr_divisor;
	mov ebx, ecx

	; restore regs
	pop edx
	pop ecx
	pop eax

	; destroy stack frame
	mov esp, ebp
	pop ebp
	ret
calcGCF ENDP

; Procedure main
; This procedure tests my self-made GCD procedure above...
main PROC
	; load arguments by stack! a, b where a >= b and a is below b in stack
	push numB
	push numA
	call calcGCF

	; reset stack
	pop eax
	pop eax

	; print resulting GCD: must be 6
	mov eax, ebx    ; <- result from calcGCF(a, b)
	call WriteDec
	exit
main ENDP
END main