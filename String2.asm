;**********************************************************************
; Program:	String2.asm                               
; Name:		Neal Hitzfield                     
; Class:	CS3B                               
; Date:		4/13/18                            
; Purpose:  Define String operations for MASM3        
;***********************************************************************

.486
.model flat, c
.stack 100h

ExitProcess PROTO Near32 stdcall, dVal:dword
memoryallocBailey  proto Near32 stdcall, dNumBytes:dword

	.data

	.code
;main proc
	;invoke ExitProcess, 0
;main endp

lastIndexOf1 proc         
; receives: string1 (byte ptr), char (byte ptr)
	push ebp
	mov ebp, esp
	
	mov esi, [ebp + 8]		; store string1 address in esi
	mov edi, [ebp + 12]		; store char address in edi
	mov dl, byte ptr [edi]		; store the char in dl
	mov ebx, 0			; clear the index count
	.while byte ptr [esi] != 0
		cmp byte ptr [esi], dl	; check for the char
		jz save
		jmp skip
	save:
		mov eax, ebx		; save the current index position
	skip:
		inc esi			; go to next index
		inc ebx			; increment index counter
	.endw
	
	pop ebp
	ret				; index is in eax
lastIndexOf1 endp

lastIndexOf2 proc
	; receives: string1 (byte ptr), char (byte ptr), fromIndex (dword)
	push ebp
	mov ebp, esp
	
	mov esi, [ebp + 8]		; store string1 address in esi
	add esi, [ebp + 16]		; go to starting point in string
	mov edi, [ebp + 12]		; store char address in edi
	mov dl, byte ptr [edi]		; move the char to dl
	mov ebx, 0			; clear the index count
	.while byte ptr [esi] != 0
		cmp byte ptr [esi], dl	; check for the char
		jz save
		jmp skip
	save:
		mov eax, ebx		; save the current index position
	skip:
		inc esi			; go to next index
		inc ebx			; increment index counter
	.endw
	
	pop ebp
	ret				; index is in eax
lastIndexOf2 endp

COMMENT @ ; lastIndexOf3 & String_concat don't work.
lastIndexOf3 proc
	; receives: string1 (byte ptr), strOther (byte ptr)
	push ebp
	mov ebp, esp
	
	mov esi, [ebp + 8]		; store string1 address in esi
	mov edi, [ebp + 12]		; store other string's address in edi

	mov ebx, 0			; clear the index count
	.while byte ptr [esi] != 0
		cmp byte ptr [esi], byte ptr [edi]	; check for equality
		jz save
		jmp skip
	save:
		mov eax, ebx		; save the current index position
	skip:
		inc esi			; go to next index in string1
		inc ebx			; increment index counter
	.endw
	
	pop ebp
	ret	
lastIndexOf3 endp

;String_concat(string1:String,str:String):String  
;Concatenates the specified string “str” at the end of the string.
String_concat proc, string1: ptr byte, str2: ptr byte
	xor eax, eax			; clear eax
	push string1
	call String_length		; get string length of string1
	add esp, 8			; clean up stack
	mov ecx, eax			; save length
	
	push str2
	call String_length		; get string length of str2
	add esp, 8			; clean up stack
	add eax, ecx			; add the two string lengths
	inc eax				; +1 for terminating null
	
	invoke memoryallocBailey, eax	; allocate the calculated space on heap for new string
	
	mov esi, string1
	.while byte ptr [esi] != 0
		mov dl, byte ptr [esi]	; get string1 char from memory
		mov byte ptr [eax], dl	; move it into memory of new string
		inc esi			; go to next char for string1
		inc eax			; go to next char for new string
	.endw
	
	mov esi, str2
	.while byte ptr [esi] != 0
		mov dl, byte ptr [esi]	; get str2 char from memory
		mov byte ptr [eax], dl	; move it into memory of new string
		inc esi			; go to next char for str2
		inc eax			; go to next char for new string
	.endw
	mov byte ptr [eax], 0		; append null to concatenated string
	
	ret				; eax contains memory address of new string
String_concat endp
@

;String_replace(string1:String,oldChar:char,newChar:char):String  
;Returns new updated string after changing all the occurrences of oldChar with the newChar.
String_replace proc, string1: ptr byte, oldChar: ptr byte, newChar: ptr byte
	xor eax, eax
	mov eax, string1
	mov ebx, oldChar
	mov ecx, newChar
	
	.while byte ptr [eax] != 0		; until the string reaches null
		mov dl, byte ptr [eax]		; move one byte from old string into dl
		mov dh, byte ptr [ebx]		; move old char into dh from memory
		.if dl == dh			; compare the character with oldChar
			mov dl, byte ptr [ecx]	; move new char into dl from memory
			mov byte ptr [eax], dl	; replace oldChar with newChar
		.endif
		inc eax				; go to next character
	.endw					; eax holds new string
	
	ret
String_replace endp

;String_toLowerCase(string1:String):String  
;It converts the string to lower case string
String_toLowerCase proc, string1: ptr byte
	mov esi, string1			; get string to convert from the stack
	.while byte ptr [esi] != 0		; while not at the end of string
		mov al, byte ptr [esi]		; get a char from memory
		.if al < 'A'			; if the char is less than ascii a 
			jmp skip		; skip it
		.endif					
		.if al > 'Z'			; if the char is greater than ascii z
			jmp skip		; skip it
		.endif
		
		xor byte ptr [esi], 00100000b	; convert the char to lowercase

		skip:
		inc esi				; go to next char
	.endw
	mov eax, esi
	
	ret					; converted string address is in eax
String_toLowerCase endp

;String_toUpperCase(string1:String):String   
;It converts the string to upper case string
String_toUpperCase proc, string1: ptr byte
	mov esi, string1	; get string to convert from the stack
	.while byte ptr [esi] != 0		; while not at the end of string
		mov al, byte ptr [esi]		; get a char from memory
		.if al < 'a'			; if the char is less than ascii a 
			jmp skip		; skip it
		.endif					
		.if al > 'z'			; if the char is greater than ascii z
			jmp skip		; skip it
		.endif
		
		and byte ptr [esi], 11011111b	; convert the char to uppercase

		skip:
		inc esi				; go to next char
	.endw
	mov eax, esi				; move the string's address to eax
	
	;Tried to allocated new string and copy into it, doesn't work though.
	;push string1
	;call String_length	; get length of string to convert
	;add esp, 8
	;inc eax				; add one for a null
	;invoke memoryallocBailey, eax	; allocate heap memory for new string
	;mov esi, string1
	;.while byte ptr [esi] != 0	; until converted string is null
	;	mov bl, byte ptr [esi]	; move char into bl
	;	mov byte ptr [eax], bl	; put that char into new memory location
	;	inc esi					; go to the next character in string to copy
	;	inc eax					; go to next byte in memory
	;.endw
	;mov byte ptr [eax], 0		; add a null at the end
	
	ret							; converted string address is in eax
String_toUpperCase endp

;end main
end
