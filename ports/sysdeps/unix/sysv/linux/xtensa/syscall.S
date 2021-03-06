/* Copyright (C) 2005 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#include <sysdep.h>

/* The register layout upon entering the function is:

   arguments	syscall number	arg0, arg1, arg2, arg3, arg4, arg5
   ---------	--------------	----------------------------------
   function	a2		a3,   a4,   a5,   a6,   a7,   (sp)
   syscall	a2		a6,   a3,   a4,   a5,   a8,   a9

*/

ENTRY (syscall)
	entry	a1, 16		/* PSEUDO_RET does a call8 */
	l32i	a9, a1, 16	/* load extra argument from stack */
	mov	a8, a7
	mov	a7, a3		/* preserve a3 in a7 */
	mov	a3, a4
	mov	a4, a5
	mov	a5, a6
	mov	a6, a7
	syscall
	movi    a4, -2048
	movi    a5, 1
	addx2   a4, a4, a5
	bgeu    a2, a4, SYSCALL_ERROR_LABEL
L(pseudo_end):
	retw
PSEUDO_END (syscall)

