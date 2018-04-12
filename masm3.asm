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
strMenuPrompt22		byte	"* <19> String_concat                              currently:",0
strMenuPrompt23		byte	"* <20> String_replace                             currently:",0
strMenuPrompt24		byte	"* <21> String_toLowerCase                         currently:",0
strMenuPrompt25		byte	"* <22> String_toUpperCase                         currently:",0
strMenuPrompt26		byte	"* <23> Quit                                                *",13,10,0
strMenuPrompt27		byte	"************************************************************",13,10,0

strCrlf				byte	13,10,0
strTrue				byte	"TRUE",0
strFalse			byte	"FALSE",0
strNull				byte	"NULL",0
strCurrently		byte	" currently:"

string1				byte	"NULL", 100 dup (0)
string2				byte	"NULL", 100 dup (0)

	.code

Menu proc
	invoke putstring, addr strMenuPrompt1
	invoke putstring, addr strMenuPrompt2
	invoke putstring, addr strMenuPrompt3
	invoke putstring, addr strMenuPrompt4
	invoke putstring, addr strCrlf
	invoke putstring, addr strMenuPrompt5
	invoke putstring, addr strCrlf
	invoke putstring, addr strMenuPrompt6
	invoke putstring, addr strCrlf
	invoke putstring, addr strMenuPrompt7
	invoke putstring, addr strCrlf
	invoke putstring, addr strMenuPrompt8
	invoke putstring, addr strCrlf
	invoke putstring, addr strMenuPrompt9
	invoke putstring, addr strCrlf
	invoke putstring, addr strMenuPrompt10
	invoke putstring, addr strCrlf
	invoke putstring, addr strMenuPrompt11
	invoke putstring, addr strCrlf
	invoke putstring, addr strMenuPrompt12
	invoke putstring, addr strCrlf
	invoke putstring, addr strMenuPrompt13
	invoke putstring, addr strCrlf
	invoke putstring, addr strMenuPrompt14
	invoke putstring, addr strCrlf
	invoke putstring, addr strMenuPrompt15
	invoke putstring, addr strCrlf
	invoke putstring, addr strMenuPrompt16
	invoke putstring, addr strCrlf
	invoke putstring, addr strMenuPrompt17
	invoke putstring, addr strCrlf
	invoke putstring, addr strMenuPrompt18
	invoke putstring, addr strCrlf
	invoke putstring, addr strMenuPrompt19
	invoke putstring, addr strCrlf
	invoke putstring, addr strMenuPrompt20
	invoke putstring, addr strCrlf
	invoke putstring, addr strMenuPrompt21
	invoke putstring, addr strCrlf
	invoke putstring, addr strMenuPrompt22
	invoke putstring, addr strCrlf
	invoke putstring, addr strMenuPrompt23
	invoke putstring, addr strCrlf
	invoke putstring, addr strMenuPrompt24
	invoke putstring, addr strCrlf
	invoke putstring, addr strMenuPrompt25
	invoke putstring, addr strCrlf
	invoke putstring, addr strMenuPrompt26
	invoke putstring, addr strMenuPrompt27
	ret
Menu endp


_main:
	call Menu

	invoke ExitProcess, 0
end _main