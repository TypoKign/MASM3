;*****************************************************************************
;Name:		David Cruz & Neal Hitzfield
;Program:	MASM3.asm
;Class:		CS3B
;Lab:		MASM3
;Date:		April 19, 2018 at 11:59 PM
;Purpose:
;	Use the String1 and String2 libraries
;*****************************************************************************

.486
.model flat, c
.stack 100h
option casemap:none

ExitProcess PROTO Near32 stdcall, dVal:dword
putstring 	PROTO Near32 stdcall, lpStringToPrint:dword
intasc32	proto Near32 stdcall, lpStringToHold:dword, dval:dword
hexToChar PROTO Near32 stdcall,lpDestStr:dword,lpSourceStr:dword,dLen:dword
getstring	PROTO Near32 stdcall, lpStringToGet:dword, dlength:dword
ascint32	PROTO Near32 stdcall, lpStringToConvert:dword  

extern String_equals: Near32, String_equalsIgnoreCase: Near32,
	   String_copy: Near32, String_substring_1: Near32, String_substring_2: Near32,
	   String_charAt: Near32, String_startsWith_1: Near32, String_startsWith_2: Near32,
	   String_endsWith: Near32
	   
extern String_indexOf_1: Near32, String_indexOf_2:Near32, String_indexOf_3:Near32,
       String_lastIndexOf_1: Near32, String_lastIndexOf_2: Near32, String_lastIndexOf_3: Near32,
       String_concat: Near32, String_replace: Near32, String_toLowerCase: Near32,
	   String_toUpperCase: Near32
	
	.data
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; MENU ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
strMenuPrompt1		byte	"************************************************************",13,10,0
strMenuPrompt2		byte	"*                          MASM 3                          *",13,10,0
strMenuPrompt3		byte	"*----------------------------------------------------------*",13,10,0
strMenuPrompt4		byte	"* <1> Set string1                                 currently:",0
strMenuPrompt5		byte	"* <2> Set string2                                 currently:",0
strMenuPrompt6		byte	"* <3> String_length                               currently:",0
strMenuPrompt7		byte	"* <4> String_equals                               currently:",0
strMenuPrompt8		byte	"* <5> String_equalsIgnoreCase                     currently:",0
strMenuPrompt9		byte	"* <6> String_copy                                 &",0
strMenuPrompt10		byte	"* <7> String_substring_1                          &",0
strMenuPrompt11		byte	"* <8> String_substring_2                          &",0
strMenuPrompt12		byte	"* <9> String_charAt                               currently:",0
strMenuPrompt13		byte	"* <10> String_startsWith_1                        currently:",0
strMenuPrompt14		byte	"* <11> String_startsWith_2                        currently:",0
strMenuPrompt15		byte	"* <12> String_endsWith                            currently:",0
strMenuPrompt16		byte	"* <13> String_indexOf_1                           currently:",0
strMenuPrompt17		byte	"* <14> String_indexOf_2                           currently:",0
strMenuPrompt18		byte	"* <15> String_indexOf_3                           currently:",0
strMenuPrompt19		byte	"* <16> String_lastIndexOf_1                       currently:",0
strMenuPrompt20		byte    "* <17> String_lastIndexOf_2                       currently:",0
strMenuPrompt21		byte	"* <18> String_lastIndexOf_3                       currently:",0
strMenuPrompt22		byte	"* <19> String_concat                              &",0
strMenuPrompt23		byte	"* <20> String_replace                             currently:",0
strMenuPrompt24		byte	"* <21> String_toLowerCase                         currently:",0
strMenuPrompt25		byte	"* <22> String_toUpperCase                         currently:",0
strMenuPrompt26		byte	"* <23> Quit                                                *",13,10,0
strMenuPrompt27		byte	"************************************************************",13,10,0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; INPUT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
strChoicePrompt		byte	"Choice (1-23): ",0
strChoice			byte	11 dup (?)
dChoice				dword	0
strInvalid			byte	"Invalid input, returning to menu...",0
strInputPrompt1		byte	"Enter a value for String 1: ", 0
strInputPrompt2		byte	"Enter a value for String 2: ", 0
strSelectPrompt		byte	"Enter <1> for String 1, or <2> for String 2: ",0
strBeginIndex		byte	"Enter begin index: ",0
strEndIndex			byte	"Enter end index: ",0
strPositionPrompt	byte	"Enter the position to retrieve: ",0
strCharPrompt       byte    "Enter the character to search for: ",0
strStringPrompt     byte    "Enter the string to search for: ",0
strCharRep1Prompt   byte    "Enter the character you want to replace: ",0
strCharRep2Prompt   byte    "Enter the character you want to replace it with: ",0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; FORMATTING ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
strCrlf				byte	13,10,0
strTrue				byte	"TRUE",0
strFalse			byte	"FALSE",0
strNull				byte	"NULL",0
strCurrently		byte	" currently:",0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; INPUT STRINGS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
string1				byte	"NULL", 100 dup (0)
string2				byte	"NULL", 100 dup (0)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; MENU FUNCTION VALUES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dLength				dword	0
strLength			byte	11 dup (?)
bEquals				byte	0
bEqualsIgnoreCase	byte	0
dCopyAddress		dword	0
strCopyAddress		byte	9 dup (?)
dSub1Address		dword	0
strSub1Address		byte 	9 dup (?)
dSub2Address		dword	0
strSub2Address		byte	9 dup (?)
strCharAt			byte	"NULL", 0
strStartsWith1		byte	"FALSE",0
strStartsWith2		byte	"FALSE",0
strEndsWith			byte	"FALSE",0
dIndexOf1			dword	-1
strIndexOf1			byte	11 dup (?)
dIndexOf2			dword	-1
strIndexOf2			byte	11 dup (?)
dIndexOf3			dword	-1
strIndexOf3			byte	11 dup (?)
dLastIndexOf1		dword	-1
strLastIndexOf1		byte	11 dup (?)
dLastIndexOf2		dword	-1
strLastIndexOf2		byte	11 dup (?)
dLastIndexOf3		dword	-1
strLastIndexOf3		byte	11 dup (?)
dConcatAddress		dword	0
strConcatAddress	byte	9 dup (?)
dReplaceAddress     dword   0
strReplaceAddr		byte	"NULL",100 dup (0)
dToLowercaseAddr    dword   0
strToLowercaseAddr	byte	"NULL", 100 dup (0)
dToUppercaseAddr    dword   0
strToUppercaseAddr	byte	"NULL", 100 dup (0)

	.code


String_length proc, _string1: ptr byte
	mov eax, 0
	mov esi, _string1

	.while byte ptr [esi] != 0 ; for each character in ESI that is not NULL
		inc esi				   ; move to the next character
		inc eax				   ; increment the count of characters
	.endw
	ret
String_length endp

Menu proc
	invoke putstring, addr strMenuPrompt1
	invoke putstring, addr strMenuPrompt2
	invoke putstring, addr strMenuPrompt3

	invoke putstring, addr strMenuPrompt4 ; string 1
	invoke putstring, addr string1
	invoke putstring, addr strCrlf

	invoke putstring, addr strMenuPrompt5 ; string 2
	invoke putstring, addr string2
	invoke putstring, addr strCrlf

	invoke putstring, addr strMenuPrompt6 ; string length
	invoke intasc32, addr strLength, dLength
	invoke putstring, addr strLength
	invoke putstring, addr strCrlf

	invoke putstring, addr strMenuPrompt7 ; string equals
	.if bEquals == 1
		invoke putstring, addr strTrue
	.else
		invoke putstring, addr strFalse
	.endif
	invoke putstring, addr strCrlf

	invoke putstring, addr strMenuPrompt8 ; string equals ignore case
	.if bEqualsIgnoreCase == 1
		invoke putstring, addr strTrue
	.else
		invoke putstring, addr strFalse
	.endif
	invoke putstring, addr strCrlf

	invoke putstring, addr strMenuPrompt9 ; string copy
	invoke hexToChar, addr strCopyAddress, dCopyAddress, 0
	invoke putstring, addr strCopyAddress
	invoke putstring, addr strCurrently
	.if dCopyAddress == 0
		invoke putstring, addr strNull
	.else
		invoke putstring, dCopyAddress
	.endif
	invoke putstring, addr strCrlf

	invoke putstring, addr strMenuPrompt10 ; string substring 1
	invoke hexToChar, addr strSub1Address, dSub1Address, 0
	invoke putstring, addr strSub1Address
	invoke putstring, addr strCurrently
	.if dSub1Address == 0
		invoke putstring, addr strNull
	.else
		invoke putstring, dSub1Address
	.endif
	invoke putstring, addr strCrlf

	invoke putstring, addr strMenuPrompt11 ; string substring 2
	invoke hexToChar, addr strSub2Address, dSub2Address, 0
	invoke putstring, addr strSub2Address
	invoke putstring, addr strCurrently
	.if dSub2Address == 0
		invoke putstring, addr strNull
	.else
		invoke putstring, dSub2Address
	.endif
	invoke putstring, addr strCrlf

	invoke putstring, addr strMenuPrompt12 ; string charat
	invoke putstring, addr strCharAt
	invoke putstring, addr strCrlf

	invoke putstring, addr strMenuPrompt13 ; string starts with 1
	invoke putstring, addr strStartsWith1
	invoke putstring, addr strCrlf
	
	invoke putstring, addr strMenuPrompt14 ; string starts with 2
	invoke putstring, addr strStartsWith2
	invoke putstring, addr strCrlf

	invoke putstring, addr strMenuPrompt15 ; string ends with
	invoke putstring, addr strEndsWith
	invoke putstring, addr strCrlf

	invoke putstring, addr strMenuPrompt16 ; string index of 1
	invoke intasc32, addr strIndexOf1, dIndexOf1
	invoke putstring, addr strIndexOf1
	invoke putstring, addr strCrlf

	invoke putstring, addr strMenuPrompt17 ; string index of 2
	invoke intasc32, addr strIndexOf2, dIndexOf2
	invoke putstring, addr strIndexOf2
	invoke putstring, addr strCrlf

	invoke putstring, addr strMenuPrompt18 ; string index of 3
	invoke intasc32, addr strIndexOf3, dIndexOf3
	invoke putstring, addr strIndexOf3
	invoke putstring, addr strCrlf

	invoke putstring, addr strMenuPrompt19 ; string last index of 1
	invoke intasc32, addr strLastIndexOf1, dLastIndexOf1
	invoke putstring, addr strLastIndexOf1
	invoke putstring, addr strCrlf

	invoke putstring, addr strMenuPrompt20 ; string last index of 2
	invoke intasc32, addr strLastIndexOf2, dLastIndexOf2
	invoke putstring, addr strLastIndexOf2
	invoke putstring, addr strCrlf

	invoke putstring, addr strMenuPrompt21 ; string last index of 3
	invoke intasc32, addr strLastIndexOf3, dLastIndexOf3
	invoke putstring, addr strLastIndexOf3
	invoke putstring, addr strCrlf

	invoke putstring, addr strMenuPrompt22 ; string concat
	invoke hexToChar, addr strConcatAddress, dConcatAddress, 0
	invoke putstring, addr strConcatAddress
	invoke putstring, addr strCurrently
	.if dConcatAddress == 0
		invoke putstring, addr strNull
	.else
		invoke putstring, dConcatAddress
	.endif
	invoke putstring, addr strCrlf

	invoke putstring, addr strMenuPrompt23 ; string replace
	invoke hexToChar, addr strReplaceAddr, dReplaceAddress, 0
	invoke putstring, addr strReplaceAddr
	invoke putstring, addr strCrlf

	invoke putstring, addr strMenuPrompt24 ; string to lower case
	invoke hexToChar, addr strToLowercaseAddr, dToLowercaseAddr, 0
	invoke putstring, addr strToLowercaseAddr
	invoke putstring, addr strCrlf

	invoke putstring, addr strMenuPrompt25 ; string to uppercase
	invoke hexToChar, addr strToUppercaseAddr, dToUppercaseAddr, 0
	invoke putstring, addr strToUppercaseAddr
	invoke putstring, addr strCrlf
	invoke putstring, addr strMenuPrompt26
	invoke putstring, addr strMenuPrompt27
	invoke putstring, addr strCrlf
	ret
Menu endp

Input proc
	invoke putstring, addr strChoicePrompt
	invoke getstring, addr strChoice, 2
	invoke putstring, addr strCrlf
	invoke ascint32, addr strChoice
	mov dChoice, eax

	.if dChoice == 1
		invoke putstring, addr strInputPrompt1
		invoke getstring, addr string1, 100
		invoke putstring, addr strCrlf
	.elseif dChoice == 2
		invoke putstring, addr strInputPrompt2
		invoke getstring, addr string2, 100
		invoke putstring, addr strCrlf
	.elseif dChoice == 3
		invoke putstring, addr strSelectPrompt
		invoke getstring, addr strChoice, 1
		invoke putstring, addr strCrlf
		invoke ascint32, addr strChoice

		.if eax == 1
			push offset string1
			call String_length
			add esp, 4
			mov dLength, eax
		.elseif eax == 2
			push offset string2
			call String_length
			add esp, 4
			mov dLength, eax
		.else
			invoke putstring, addr strInvalid
			ret
		.endif
	.elseif dChoice == 4
		push offset string2
		push offset string1
		call String_equals
		add esp, 8
		mov bEquals, al
	.elseif dChoice == 5
		push offset string2
		push offset string1
		call String_equalsIgnoreCase
		add esp, 8
		mov bEqualsIgnoreCase, al
	.elseif dChoice == 6
		invoke putstring, addr strSelectPrompt
		invoke getstring, addr strChoice, 1
		invoke putstring, addr strCrlf
		invoke ascint32, addr strChoice

		.if eax == 1
			push offset string1
			call String_copy
			add esp, 4
			mov dCopyAddress, eax
		.elseif eax == 2
			push offset string2
			call String_copy
			add esp, 4
			mov dCopyAddress, eax
		.else
			invoke putstring, addr strInvalid
			ret
		.endif
	.elseif dChoice == 7
		invoke putstring, addr strSelectPrompt
		invoke getstring, addr strChoice, 1
		invoke putstring, addr strCrlf
		invoke ascint32, addr strChoice

		.if eax == 1
			mov edx, offset string1
		.elseif eax == 2
			mov edx, offset string2
		.else
			invoke putstring, addr strInvalid
			ret
		.endif

		invoke putstring, addr strBeginIndex
		invoke getstring, addr strChoice, 11
		invoke putstring, addr strCrlf
		invoke ascint32, addr strChoice
		mov esi, eax

		invoke putstring, addr strEndIndex
		invoke getstring, addr strChoice, 11
		invoke putstring, addr strCrlf
		invoke ascint32, addr strChoice
		mov edi, eax

		push edi
		push esi
		push edx
		call String_substring_1
		add esp, 12
		mov dSub1Address, eax
	.elseif dChoice == 8
		invoke putstring, addr strSelectPrompt
		invoke getstring, addr strChoice, 1
		invoke putstring, addr strCrlf
		invoke ascint32, addr strChoice

		.if eax == 1
			mov edx, offset string1
		.elseif eax == 2
			mov edx, offset string2
		.else
			invoke putstring, addr strInvalid
			ret
		.endif

		invoke putstring, addr strBeginIndex
		invoke getstring, addr strChoice, 11
		invoke putstring, addr strCrlf
		invoke ascint32, addr strChoice
		mov esi, eax

		push esi
		push edx
		call String_substring_2
		add esp, 8
		mov dSub2Address, eax
	.elseif dChoice == 9
		invoke putstring, addr strSelectPrompt
		invoke getstring, addr strChoice, 1
		invoke putstring, addr strCrlf
		invoke ascint32, addr strChoice

		.if eax == 1
			mov edx, offset string1
		.elseif eax == 2
			mov edx, offset string2
		.else
			invoke putstring, addr strInvalid
			ret
		.endif

		invoke putstring, addr strPositionPrompt
		; todo: finish
	.elseif dChoice == 10

	.elseif dChoice == 11

	.elseif dChoice == 12

	.elseif dChoice == 13
		invoke putstring, addr strSelectPrompt
		invoke getstring, addr strChoice, 1
		invoke putstring, addr strCrlf
		invoke ascint32, addr strChoice
		
		.if eax == 1
			mov edx, offset string1
		.elseif eax == 2
			mov edx, offset string2
		.else
			invoke putstring, addr strInvalid
			ret
		.endif
		
		invoke putstring, addr strCharPrompt
		invoke getstring, addr strChoice, 1
		invoke putstring, addr strCrlf
		invoke ascint32, addr strChoice
		mov esi, eax

		push esi
		push edx
		call String_indexOf_1
		add esp, 8
		mov dIndexOf1, eax
	.elseif dChoice == 14
		invoke putstring, addr strSelectPrompt
		invoke getstring, addr strChoice, 1
		invoke putstring, addr strCrlf
		invoke ascint32, addr strChoice
		
		.if eax == 1
			mov edx, offset string1
		.elseif eax == 2
			mov edx, offset string2
		.else
			invoke putstring, addr strInvalid
			ret
		.endif
		
		invoke putstring, addr strCharPrompt
		invoke getstring, addr strChoice, 1
		invoke putstring, addr strCrlf
		invoke ascint32, addr strChoice
		mov esi, eax
		
		invoke putstring, addr strBeginIndex
		invoke getstring, addr strChoice, 11
		invoke putstring, addr strCrlf
		invoke ascint32, addr strChoice
		mov edi, eax

		push edi
		push esi
		push edx
		call String_indexOf_2
		add esp, 12
		mov dIndexOf2, eax
	.elseif dChoice == 15
		invoke putstring, addr strSelectPrompt
		invoke getstring, addr strChoice, 1
		invoke putstring, addr strCrlf
		invoke ascint32, addr strChoice
		
		.if eax == 1
			mov edx, offset string1
		.elseif eax == 2
			mov edx, offset string2
		.else
			invoke putstring, addr strInvalid
			ret
		.endif
		
		invoke putstring, addr strStringPrompt
		invoke getstring, addr strChoice, 11
		invoke putstring, addr strCrlf
		invoke ascint32, addr strChoice
		mov esi, eax

		push esi
		push edx
		call String_indexOf_3
		add esp, 8
		mov dIndexOf3, eax
	.elseif dChoice == 16
		invoke putstring, addr strSelectPrompt
		invoke getstring, addr strChoice, 1
		invoke putstring, addr strCrlf
		invoke ascint32, addr strChoice
		
		.if eax == 1
			mov edx, offset string1
		.elseif eax == 2
			mov edx, offset string2
		.else
			invoke putstring, addr strInvalid
			ret
		.endif
		
		invoke putstring, addr strCharPrompt
		invoke getstring, addr strChoice, 1
		invoke putstring, addr strCrlf
		invoke ascint32, addr strChoice
		mov esi, eax

		push esi
		push edx
		call String_lastIndexOf_1
		add esp, 8
		mov dLastIndexOf1, eax
	.elseif dChoice == 17
		invoke putstring, addr strSelectPrompt
		invoke getstring, addr strChoice, 1
		invoke putstring, addr strCrlf
		invoke ascint32, addr strChoice
		
		.if eax == 1
			mov edx, offset string1
		.elseif eax == 2
			mov edx, offset string2
		.else
			invoke putstring, addr strInvalid
			ret
		.endif
		
		invoke putstring, addr strCharPrompt
		invoke getstring, addr strChoice, 1
		invoke putstring, addr strCrlf
		invoke ascint32, addr strChoice
		mov esi, eax
		
		invoke putstring, addr strBeginIndex
		invoke getstring, addr strChoice, 11
		invoke putstring, addr strCrlf
		invoke ascint32, addr strChoice
		mov edi, eax

		push edi
		push esi
		push edx
		call String_lastIndexOf_2
		add esp, 12
		mov dLastIndexOf2, eax
	.elseif dChoice == 18
		invoke putstring, addr strSelectPrompt
		invoke getstring, addr strChoice, 1
		invoke putstring, addr strCrlf
		invoke ascint32, addr strChoice
		
		.if eax == 1
			mov edx, offset string1
		.elseif eax == 2
			mov edx, offset string2
		.else
			invoke putstring, addr strInvalid
			ret
		.endif
		
		invoke putstring, addr strStringPrompt
		invoke getstring, addr strChoice, 11
		invoke putstring, addr strCrlf
		invoke ascint32, addr strChoice
		mov esi, eax

		push esi
		push edx
		call String_lastIndexOf_3
		add esp, 8
		mov dLastIndexOf3, eax
	.elseif dChoice == 19
		invoke putstring, addr strSelectPrompt
		invoke getstring, addr strChoice, 1
		invoke putstring, addr strCrlf
		invoke ascint32, addr strChoice
		
		.if eax == 1
			mov edx, offset string1
		.elseif eax == 2
			mov edx, offset string2
		.else
			invoke putstring, addr strInvalid
			ret
		.endif
		
		invoke putstring, addr strStringPrompt
		invoke getstring, addr strChoice, 11
		invoke putstring, addr strCrlf
		invoke ascint32, addr strChoice
		mov esi, eax

		push esi
		push edx
		call String_concat
		add esp, 8
		mov dConcatAddress, eax
	.elseif dChoice == 20
		invoke putstring, addr strSelectPrompt
		invoke getstring, addr strChoice, 1
		invoke putstring, addr strCrlf
		invoke ascint32, addr strChoice
		
		.if eax == 1
			mov edx, offset string1
		.elseif eax == 2
			mov edx, offset string2
		.else
			invoke putstring, addr strInvalid
			ret
		.endif
		
		invoke putstring, addr strCharRep1Prompt
		invoke getstring, addr strChoice, 1
		invoke putstring, addr strCrlf
		invoke ascint32, addr strChoice
		mov esi, eax
		
		invoke putstring, addr strCharRep2Prompt
		invoke getstring, addr strChoice, 1
		invoke putstring, addr strCrlf
		invoke ascint32, addr strChoice
		mov edi, eax

		push edi
		push esi
		push edx
		call String_replace
		add esp, 12
		mov dReplaceAddress, eax
	.elseif dChoice == 21
		invoke putstring, addr strSelectPrompt
		invoke getstring, addr strChoice, 1
		invoke putstring, addr strCrlf
		invoke ascint32, addr strChoice
		
		.if eax == 1
			mov edx, offset string1
		.elseif eax == 2
			mov edx, offset string2
		.else
			invoke putstring, addr strInvalid
			ret
		.endif

		push edx
		call String_toLowerCase
		add esp, 12
		mov dToLowercaseAddr, eax
	.elseif dChoice == 22
		invoke putstring, addr strSelectPrompt
		invoke getstring, addr strChoice, 1
		invoke putstring, addr strCrlf
		invoke ascint32, addr strChoice
		
		.if eax == 1
			mov edx, offset string1
		.elseif eax == 2
			mov edx, offset string2
		.else
			invoke putstring, addr strInvalid
			ret
		.endif

		push edx
		call String_toUpperCase
		add esp, 12
		mov dToUppercaseAddr, eax
	.elseif dChoice == 23

	.else

	.endif
	ret
Input endp


_main:
	.while dChoice != 23
		call Menu
		call Input
	.endw

	invoke ExitProcess, 0
end _main