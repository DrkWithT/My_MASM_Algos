; Test.asm
; By: Derek Tan
; Date: 11/15/2022

INCLUDE Irvine32.inc

.data
    ; none
.code
; Procedure printHexW
; ==================
; Desc: Prints the unsigned hex digit representation of a WORD type. Uses WriteChar from Irvine32.inc!
; Uses: EBX for a WORD value (argument) int "num"!, EAX for hex digit, ECX for looping, EDX for bitmask.
; Returns: void
printHexW PROC
    ; preserve general registers EAX, ECX, EDX...
    push eax
    push ecx
    push edx

    ; setup initial values
    mov eax, 0    ; int digit = 0;
    mov ecx, 0
    mov cl, 12    ; int shifts = 12;

    mov edx, 15
    shl edx, cl    ; int bmask = (0x000F << (char)shifts);

    ; loop through half bytes for hex digits (4 bits each)
StartL1:
    ; check if needed shifts are 0 (done with half bytes)
    cmp ecx, 0    ; while(shifts >= 0):
    je EndL1

    ; get half byte
    mov eax, ebx
    and eax, edx
    shr eax, cl    ; digit = (num & bmask) >> shifts

    ; convert half byte value to correct ASCII...
CondNumeric:
    cmp al, 9
    ja CondLetter
    
    add al, 48    ; if (digit <= 9) digit += 48; // for numeric ASCII digit char

    jmp EndCond
CondLetter:
    add al, 55    ; else digit += 55; // for alphabetic ASCII char

EndCond:
    call WriteChar    ; print hex digit

    mov eax, 0    ; digit = 0
    sub cl, 4    ; shifts -= 4
    shr edx, 4    ; bmask >>= 4
    jmp StartL1
EndL1:

; manually print last digit since the loop will stop when shifts == 0
    mov eax, ebx
    and eax, edx

CondNumeric2:
    cmp al, 9
    ja CondLetter2
    
    add al, 48    ; if (digit <= 9) digit += 48; // for LAST numeric ASCII digit char

    jmp EndCond2
CondLetter2:
    add al, 55    ; else digit += 55; // for LAST alphabetic ASCII char

EndCond2:
    call WriteChar

    ; restore registers before return
    pop edx
    pop ecx
    pop eax
    ret

printHexW ENDP

; Procedure main
; Tests my procedures.
main PROC
    ; Do the function call of printHex(190)
    mov ebx, 190    ; 0000 0000 0000 0000
    call printHexW
    exit

main ENDP
END main