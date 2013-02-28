/* Machine-dependent pthreads configuration and inline functions.
   Xtensa Processor version

   Copyright (C) 2001-2013 Free Software Foundation, Inc.
   This file is part of the GNU C Library.
   Based on the MIPS and PowerPC versions

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Library General Public License as
   published by the Free Software Foundation; either version 2 of the
   License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU Library General Public
   License along with the GNU C Library; see the file COPYING.LIB.  If
   not, write to the Free Software Foundation, Inc.,
   59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.  */

#ifndef _PT_MACHINE_H
#define _PT_MACHINE_H   1

#include <sysdep.h>

#ifndef PT_EI
# define PT_EI extern inline
#endif

/* Memory barrier.  */
#define MEMORY_BARRIER() __asm__ ("" : : : "memory")


/* Spinlock implementation; required.  */

PT_EI long int
testandset (int *spinlock)
{
  int unused;
  return INTERNAL_SYSCALL(xtensa, ,4, SYS_XTENSA_ATOMIC_SET, spinlock, 1, unused);
}


#if 0  /* XTFIXME:  remove if unneeded */

/* Get some notion of the current stack.  Need not be exactly the top
   of the stack, just something somewhere in the current frame.  */
#define CURRENT_STACK_FRAME  stack_pointer
register char * stack_pointer __asm__ ("sp");

#endif

#endif /* _PT_MACHINE_H */
