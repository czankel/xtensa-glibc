/* xmknod call using old-style Unix mknod system call.
   Copyright (C) 1991-2013 Free Software Foundation, Inc.
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
   License along with the GNU C Library; if not, see
   <http://www.gnu.org/licenses/>.  */

#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/sysmacros.h>

#include <sysdep.h>
#include <sys/syscall.h>
#include <bp-checks.h>

/* Create a device file named PATH, with permission and special bits MODE
   and device number DEV (which can be constructed from major and minor
   device numbers with the `makedev' macro above).  */
int
__xmknod (int vers, const char *path, mode_t mode, dev_t *dev)
{
  unsigned long long int k_dev;

  if (vers != _MKNOD_VER)
    {
      __set_errno (EINVAL);
      return -1;
    }

  /* We must convert the value to dev_t type used by the kernel.  */
  k_dev =  (*dev) & ((1ULL << 32) - 1);
  if (k_dev != *dev)
    {
      __set_errno (EINVAL);
      return -1;
    }

  return INLINE_SYSCALL (mknod, 3, CHECK_STRING (path), mode,
			 (unsigned int) k_dev);
}

weak_alias (__xmknod, _xmknod)
libc_hidden_def (__xmknod)
