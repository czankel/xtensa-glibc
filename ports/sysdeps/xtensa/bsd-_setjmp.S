/* BSD `_setjmp' entry point to `sigsetjmp (..., 0)'.
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

/* This just does a tail-call to `__sigsetjmp (ARG, 0)'.
   We cannot do it in C because it must be a tail-call, so frame-unwinding
   in setjmp doesn't clobber the state restored by longjmp.  */

#include <sysdep.h>

ENTRY (_setjmp)
	entry	a1, 16

	mov	a6, a2
	mov	a7, a3
	movi	a8, 0

#ifdef	PIC
	movi	a4, C_SYMBOL_NAME (__sigsetjmp@PLT)
#else
	movi	a4, C_SYMBOL_NAME (__sigsetjmp)
#endif
	callx4	a4
	mov	a2, a6
	retw
END (_setjmp)
libc_hidden_def (_setjmp)
