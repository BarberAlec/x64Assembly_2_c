option casemap:none             ; case sensitive
includelib legacy_stdio_definitions.lib
extrn printf:near
.data
 public g 
 g		QWORD	4

fxp2	db	'a = %I64d b = %I64d c = %I64d d = %I64d e = %I64d sum = %I64d', 10
.code

;
; t2.asm
; Alec Barber
; Trintiy College Dublin
;

public		_min

_min:		sub		rsp,	8			;allocate local variable memory

			mov		[rsp],	rcx			;v = a

			cmp		rdx,	[rsp]		;if (b < v)
			jge		skip0
			mov		[rsp],	rdx			;v = b

skip0:		cmp		r8,		[rsp]		;if (c < v)
			jge		skip1
			mov		[rsp],	r8			;v = c


skip1:		mov		rax,	[rsp]		;return v
			add		rsp,	8
			ret		0


public		_p

_p:			sub		rsp,	32
			mov		[rsp+48], rdx
			mov		[rsp+56], r8
			mov		[rsp+64], r9
			mov		rdx,	rcx
			mov		rcx,	g
			mov		r8,		[rsp+48]
			call	_min

			mov		rcx,	rax
			mov		rdx,	[rsp+56]
			mov		r8,		[rsp+64]
			call	_min

			add		rsp,	32
			ret


public		_gcd

_gcd:		cmp		rdx,	0		;if (b == 0)
			jne		skip2
			mov		rax,	rcx		;return a
			ret
									;else
skip2:
			mov		r10,	rdx		;hold rdx (b) as rdx is used in converting rax to oword
			mov		rax,	rcx
			cqo						;convert b to oword
			idiv	r10				;a%b
			mov		rcx,	r10
			call	_gcd
			add		rsp,	32
			ret

public		_q

_q:			mov		r10,	[rsp+40]
			add		r10,	rcx
			add		r10,	rdx
			add		r10,	r8
			add		r10,	r9

			mov		r11,	r9
			mov		r9,		r8
			mov		r8,		rdx
			mov		rdx,	rcx
			lea		rcx,	fxp2

			push	r10
			mov		r10,	[rsp+40]
			push	r10
			push	r11
			sub		rsp,	32
			call	printf
			add		rsp,	48

			pop		rax
			ret		0


end