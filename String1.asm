;*****************************************************************************
;Name:		David Cruz
;Program:	String1.asm
;Class:		CS3B
;Lab:		MASM2
;Date:		March 29, 2018 at 11:59 PM
;Purpose:
;	Define String operations for MASM3
;*****************************************************************************

.486
.model flat, c
.stack 100h

memoryallocBailey	PROTO NEAR32 stdcall, dSize:dword

	.data


	.code
String_length proc, string1: ptr byte
	mov eax, 0
	mov esi, string1

	.while byte ptr [esi] != 0 ; for each character in ESI that is not NULL
		inc esi				   ; move to the next character
		inc eax				   ; increment the count of characters
	.endw
	ret
String_length endp

String_equals proc, string1: ptr byte, string2: ptr byte
	push string1		
	call String_length	; get the length of string1 and store it in EDI
	add esp, 4
	mov edi, eax
	push string2
	call String_length	; get the length of string2 and store it in EAX
	add esp, 4

	.if edi != eax		; if the two strings have different length, we can return early
		mov eax, 0
		ret
	.endif

	mov esi, string1
	mov edi, string2

	.while byte ptr [esi] != 0		; loop through each character of string 1
		mov bl, byte ptr [edi]		; get the character from string 2 from memory
		.if byte ptr [esi] != bl	; compare the same character in both strings
			mov eax, 0				; if they aren't equal, return FALSE
			ret
		.endif
		inc esi						; increment ESI and EDI after each loop
		inc edi
	.endw

	mov eax, 1						; if the loop finishes, all characters are equal
	ret
String_equals endp

String_equalsIgnoreCase proc, string1: ptr byte, string2: ptr byte
	; push string1
	; call String_toLowerCase		; convert string1 to lowercase
	; add esp, 4
	; mov esi, eax
	; push string2
	; call String_toLowerCase		; convert string2 to lowercase
	; add esp, 4
	; mov edi, eax

	; push esi
	; push edi
	; call String_equals			; compare the two lowercase strings
	; ret
String_equalsIgnoreCase endp

String_copy proc, string1: ptr byte
	push string1
	call String_length			; get the length of the string (num bytes to allocate)
	inc eax						; add 1 for the NULL

	invoke memoryallocBailey, eax

	mov esi, string1
	.while byte ptr [esi] != 0	; for each character in the source string
		mov bl, byte ptr [esi]	; get the character into a register
		mov byte ptr [eax], bl	; move the character into the new memory location
		inc esi					; go to the next character
	.endw

	; memory address is already in EAX, ready to return
	ret
String_copy endp

String_substring_1 proc, string1: ptr byte, beginIndex: dword, endIndex: dword
	mov edx, endIndex		; memory to allocate is (endIndex - beginIndex) + 1 + 1
	sub edx, beginIndex		; first +1 is to include both ends, second +1 is for NULL
	add edx, 2

	invoke memoryallocBailey, edx

String_substring_1 endp

String_substring_2 proc

String_substring_2 endp

String_charAt proc

String_charAt endp

String_startsWith_1 proc

String_startsWith_1 endp

String_startsWith_2 proc

String_startsWith_2 endp

String_endsWith proc

String_endsWith endp

end