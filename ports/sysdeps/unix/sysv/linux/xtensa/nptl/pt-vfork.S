/* Copyright (C) 2005, 2010 Free Software Foundation, Inc.
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
   License along with the GNU C Library.  If not, see
   <http://www.gnu.org/licenses/>.  */

#include <tls.h>

/*
  Save the PID value, save 0x80000000 if PID was 0.
  Registers a2, a3, and a6 are available 
 */
// FIXME: preserve origin threadptr across syscall, keep it in some reg
#define SAVE_PID							\
	rur	a3, THREADPTR;						\
	l32i	a2, a3, PID;						\
	neg	a2, a2;							\
	s32i	a2, a3, PID;						\

/*
  Restore the PID value, restore to 0 if saved value was 0x80000000
  Return value from the syscall is in a2. 
 */
#define RESTORE_PID(ar)							\
	beqz	a2, 1f;							\
	rur	a3, THREADPTR;						\
	l32i	a6, a3, PID;						\
	movi	ar, 0x80000000;						\
	sub	ar, a6, ar;						\
	s32i	ar, a3, PID;						\
1:

#include <sysdeps/unix/sysv/linux/xtensa/vfork.S>
