
	.section .text
	.arch armv7-a
	.fpu neon
	.syntax unified

	.thumb

	.global calc2
calc2:
	push {r4, lr}
	bl calc           @ should be a reloc + offset 0
	pop {r4, pc}


	.global calc
calc:
	mul	r0, r0, r0
	vdup.u16	d0, r0
1:
	vmul.u16	d0, d0, d0
	vmov.u16	r0, d0[0]
	bne calc          @ either a reloc with offset 0, or an absolute jump with offset included
	b memset          @ reloc with offset 0
	bl memset         @ reloc with offset 0
	bl calc3          @ no reloc, address of calc3
#	blx memset        @ reloc with offset 0
	beq 1b            @ absolute jump with offset included
#	ldr r0, =table
	movw r3, #:lower16:table + 24
	movt r3, #:upper16:table + 24
	bx lr
#	.word table - (1b + (8 >> 1))
calc3:
	bx lr

	.section .rodata
	.align 2
	.word calc  @ value 0, reloc to calc
	.word calc2
	.word calc3 @ address to the start of calc3

	.end
