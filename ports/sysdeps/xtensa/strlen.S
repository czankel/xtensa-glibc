/*
   ANSI C standard library function strlen
   Xtensa Processor version.

   Copyright (C) 2001 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Library General Public License as
   published by the Free Software Foundation; either version 2 of the
   License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU Library General Public
   License along with the GNU C Library; see the file COPYING.LIB.  If not,
   write to the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
   Boston, MA 02111-1307, USA.  */


#define XCHAL_HAVE_LOOPS 1

/*
 * int strlen(const char *s)
 */
.text
.begin literal
.align	4
.Lmask0:
	.byte	0xff, 0x00, 0x00, 0x00
.Lmask1:
	.byte	0x00, 0xff, 0x00, 0x00
.Lmask2:
	.byte	0x00, 0x00, 0xff, 0x00
.Lmask3:
	.byte	0x00, 0x00, 0x00, 0xff
.end literal

.align	4
.global	strlen
.type	strlen,@function
strlen:
	entry	sp, 16		# minimal stack frame
	# a2/ s
	addi	a3, a2, -4	# because we overincrement at the end
	l32r	a4, .Lmask0	# mask for byte 0
	l32r	a5, .Lmask1	# mask for byte 1
	l32r	a6, .Lmask2	# mask for byte 2
	l32r	a7, .Lmask3	# mask for byte 3
	bbsi.l	a2, 0, .L1mod2	# if only  8-bit aligned
	bbsi.l	a2, 1, .L2mod4	# if only 16-bit aligned
	j	.Laligned

/*
 * String is word-aligned.
 */
	.align	4		# (2 mod 4) alignment for loop instruction
.Laligned:
#if XCHAL_HAVE_LOOPS
	_movi.n	a8, 0		# set up for the maximum loop count
	loop	a8, .Lz3	# loop forever (almost anyway)
#endif /* XCHAL_HAVE_LOOPS */
	l32i	a8, a3, 4	# get next word of string
	addi	a3, a3, 4	# advance string pointer
	bnone	a8, a4, .Lz0	# if byte 0 is zero
	bnone	a8, a5, .Lz1	# if byte 1 is zero
	bnone	a8, a6, .Lz2	# if byte 2 is zero
#if XCHAL_HAVE_LOOPS
	bnone	a8, a7, .Lz3	# if byte 3 is zero
#else /* !XCHAL_HAVE_LOOPS */
	bany	a8, a7, .Laligned	# repeat if byte 3 is non-zero
#endif /* !XCHAL_HAVE_LOOPS */

.Lz3:	# byte 3 is zero
	addi	a3, a3, 3	# point to zero byte
.Lz0:	# byte 0 is zero
	sub	a2, a3, a2	# subtract to get length
	retw
.Lz1:	# byte 1 is zero
	addi	a3, a3, 1	# point to zero byte
	sub	a2, a3, a2	# subtract to get length
	retw
.Lz2:	# byte 2 is zero
	addi	a3, a3, 2	# point to zero byte
	sub	a2, a3, a2	# subtract to get length
	retw

.L1mod2:	# address is odd
	l8ui	a8, a3, 4	# get byte 0
	addi	a3, a3, 1	# advance string pointer
	beqz	a8, .Lz3	# if byte 0 is zero
	bbci.l	a3, 1, .Laligned # if string pointer is now word-aligned

.L2mod4:	# address is 2 mod 4
	addi	a3, a3, 2	# advance ptr for aligned access
	l32i	a8, a3, 0	# get word with first two bytes of string
	bnone	a8, a6, .Lz2	# if byte 2 (of word, not string) is zero
	bany	a8, a7, .Laligned # if byte 3 (of word, not string) is nonzero
	# byte 3 is zero
	addi	a3, a3, 3	# point to zero byte
	sub	a2, a3, a2	# subtract to get length
	retw

libc_hidden_builtin_def (strlen)

