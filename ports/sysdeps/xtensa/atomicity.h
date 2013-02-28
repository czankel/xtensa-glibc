/* Low-level functions for atomic operations.
   Copyright (C) 2005-2013 Free Software Foundation, Inc.
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

#ifndef _ATOMICITY_H
#define _ATOMICITY_H	1

/* User processes need kernel help for atomic operations. */

#include <sysdep.h>
#include <inttypes.h>

static inline int
__attribute__ ((unused))
exchange_and_add (volatile uint32_t *mem, int val)
{
  return INTERNAL_SYSCALL(xtensa, , 4, SYS_XTENSA_ATOMIC_EXG_ADD, mem, val, 0);
}

static inline int
__attribute__ ((unused))
atomic_add (volatile uint32_t *mem, int val)
{
  return INTERNAL_SYSCALL(xtensa, , 4, SYS_XTENSA_ATOMIC_ADD, mem, val, 0);
}

static inline int
__attribute__ ((unused))
compare_and_swap (volatile long int *mem, long int oldval, long int newval)
{
  return INTERNAL_SYSCALL(xtensa, ,4,SYS_XTENSA_ATOMIC_CMP_SWP,mem,oldval,newval);
}

#endif /* atomicity.h */
