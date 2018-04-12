;*****************************************************************************
;Name:		David Cruz
;Program:	MASM3.asm
;Class:		CS3B
;Lab:		MASM2
;Date:		March 29, 2018 at 11:59 PM
;Purpose:
;	Test the String1.asm library
;*****************************************************************************

.486
.model flat, c
.stack 100h
option casemap:none

ExitProcess PROTO Near32 stdcall, dVal:dword
putstring 	PROTO Near32 stdcall, lpStringToPrint:dword

extern String_length: Near32, String_equals: Near32, String_equalsIgnoreCase: Near32,
	   String_copy: Near32, String_substring_1: Near32, String_substring_2: Near32,
	   String_charAt: Near32, String_startsWith_1: Near32, String_startsWith_2: Near32,
	   String_endsWith: Near32

	.data
strTest	byte "asdf",0
strTest2 byte "a",0

	.code
_main:
	push offset strTest
	call String_length
	add esp, 4

	push offset strTest
	push offset strTest2
	call String_equals
	add esp, 8

	push offset strTest
	call String_copy
	invoke putstring, eax

	

	invoke ExitProcess, 0
end _main