section		.text
global		fFFT
global		iFFT

iFFT:
		mov		dword		[rel b + 8],	0
		mov		dword		[rel b + 12],	080000000h
		mov		dword		[rel d + 12],	0bf3504f3h
		mov		dword		[rel d + 20],	0bf800000h
		mov		dword		[rel d + 28],	0bf3504f3h
		mov		rax,		2
.again:
		mov		r8,		8
		push		rdx
		lea		rdx,		[rel copy_matrix]
.copy_loop:
		mov		r9,		[rcx + 0 * 64]
		mov		[rdx + 0 * 8],	r9
		mov		r9,		[rcx + 1 * 64]
		mov		[rdx + 7 * 8],	r9
		mov		r9,		[rcx + 2 * 64]
		mov		[rdx + 6 * 8],	r9
		mov		r9,		[rcx + 3 * 64]
		mov		[rdx + 5 * 8],	r9
		mov		r9,		[rcx + 4 * 64]
		mov		[rdx + 4 * 8],	r9
		mov		r9,		[rcx + 5 * 64]
		mov		[rdx + 3 * 8],	r9
		mov		r9,		[rcx + 6 * 64]
		mov		[rdx + 2 * 8],	r9
		mov		r9,		[rcx + 7 * 64]
		mov		[rdx + 1 * 8],	r9
		add		rdx,		64
		add		rcx,		8
		dec		r8
		jnz		.copy_loop
		pop		rdx
		lea		rcx,		[rel copy_matrix]
		mov		r8,		8
.read_lines:
		vmovdqu		ymm0,		[rcx]
		vmovdqu		ymm1,		[rcx + 32]
		add		rcx,		64
		call		fft
		vmovdqu		[rdx],		ymm2
		vmovdqu		[rdx + 32],	ymm3
		add		rdx,		64
		dec		r8
		jnz		.read_lines
		sub		rdx,		512
		mov		rcx,		rdx
		dec		rax
		jnz		.again
		ret

fFFT:
		mov		dword		[rel b + 8],	080000000h
		mov		dword		[rel b + 12],	0
		mov		dword		[rel d + 12],	03f3504f3h
		mov		dword		[rel d + 20],	03f800000h
		mov		dword		[rel d + 28],	03f3504f3h
		mov		rax,		2
.again:
		mov		r8,		8
.read_lines:
		vmovdqu		ymm0,		[rcx]
		vmovdqu		ymm1,		[rcx + 32]
		add		rcx,		64
		call		fft
		vmovdqu		[rdx],		ymm2
		vmovdqu		[rdx + 32],	ymm3
		add		rdx,		64
		dec		r8
		jnz		.read_lines
		sub		rdx,		512
		mov		r8,		8
		lea		rcx,		[rel copy_matrix]
.copy_loop:
		mov		r9,		[rdx + 0 * 8]
		mov		[rcx + 0 * 64],	r9
		mov		r9,		[rdx + 7 * 8]
		mov		[rcx + 1 * 64],	r9
		mov		r9,		[rdx + 6 * 8]
		mov		[rcx + 2 * 64],	r9
		mov		r9,		[rdx + 5 * 8]
		mov		[rcx + 3 * 64],	r9
		mov		r9,		[rdx + 4 * 8]
		mov		[rcx + 4 * 64],	r9
		mov		r9,		[rdx + 3 * 8]
		mov		[rcx + 5 * 64],	r9
		mov		r9,		[rdx + 2 * 8]
		mov		[rcx + 6 * 64],	r9
		mov		r9,		[rdx + 1 * 8]
		mov		[rcx + 7 * 64],	r9
		add		rcx,		8
		add		rdx,		64
		dec		r8
		jnz		.copy_loop
		sub		rdx,		512
		lea		rcx,		[rel copy_matrix]
		dec		rax
		jnz		.again
		mov		r8,		64
.copy_to_out:
		mov		r9,		[rcx]
		mov		[rdx],		r9
		add		rcx,		8
		add		rdx,		8
		dec		r8
		jnz		.copy_to_out
		ret

fft:
		vshufps		ymm2,		ymm1,		ymm0,		01000100b
		vshufps		ymm3,		ymm0,		ymm1,		01000100b
		call		helper
		vmovdqu		ymm5,		ymm2
		vshufps		ymm2,		ymm1,		ymm0,		11101110b
		vshufps		ymm3,		ymm0,		ymm1,		11101110b
		call		helper
		vmovdqu		ymm0,		ymm5
		vmovdqu		ymm1,		ymm2
		vmovdqu		ymm2,		[rel d]
		vmulps		ymm3,		ymm1,		ymm2
		vshufps		ymm2,		ymm2,		ymm2,		10110001b
		vmulps		ymm4,		ymm1,		ymm2
		vshufps		ymm2,		ymm3,		ymm4,		10001000b
		vshufps		ymm5,		ymm3,		ymm4,		11011101b
		vxorps		ymm5,		ymm5,		[rel const_f]
		vaddps		ymm2,		ymm5
		vshufps		ymm1,		ymm2,		ymm2,		11011000b
		vaddps		ymm2,		ymm0,		ymm1
		vsubps		ymm3,		ymm0,		ymm1
		ret

helper:
		vxorps		ymm3,		ymm3,		[rel const_a]
		vaddps		ymm2,		ymm3 
		vextracti128	xmm3,		ymm2,		1
		vinsertf128	ymm2,		ymm2,		xmm2,		1
		shufps		xmm3,		xmm3,		10110100b
		pxor		xmm3,		[rel b]
		vinsertf128	ymm3,		ymm3,		xmm3,		1
		vxorps		ymm3,		ymm3,		[rel const_c]
		vaddps		ymm2,		ymm3
		ret

section		.rdata
align		20h
const_a:
		dq		0
		dq		9223372039002259456
		dq		0
		dq		9223372039002259456
const_c:
		dq		0
		dq		0
		dq		9223372039002259456
		dq		9223372039002259456
const_f:
		dq		9223372039002259456
		dq		0
		dq		9223372039002259456
		dq		0
section		.data
copy_matrix:
		times		64		dq		0
b:
		dd		0
		dd		0
		dd		2147483648
		dd		0
d:
		dd		03f800000h
		dd		0
		dd		03f3504f3h
		dd		03f3504f3h
		dd		0
		dd		03f800000h
		dd		0bf3504f3h
		dd		03f3504f3h