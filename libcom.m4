dnl @(#) $Id$
dnl Jazzio Labs Autotools support - libcom
dnl Copyright (c) 2009 Mo McRoberts.
dnl
dnl Redistribution and use in source and binary forms, with or without
dnl modification, are permitted provided that the following conditions
dnl are met:
dnl 1. Redistributions of source code must retain the above copyright
dnl    notice, this list of conditions and the following disclaimer.
dnl 2. Redistributions in binary form must reproduce the above copyright
dnl    notice, this list of conditions and the following disclaimer in the
dnl    documentation and/or other materials provided with the distribution.
dnl 3. The names of the author(s) of this software may not be used to endorse
dnl    or promote products derived from this software without specific prior
dnl    written permission.
dnl
dnl THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, 
dnl INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY 
dnl AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL
dnl AUTHORS OF THIS SOFTWARE BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
dnl SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
dnl TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
dnl PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
dnl LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
dnl NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS 
dnl SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
dnl
m4_pattern_forbid(^JL_)dnl
m4_pattern_forbid(^_JL_)dnl
AC_DEFUN([JL_REQUIRE_LIBCOM],[
LIBCOM_CPPFLAGS=''
LIBCOM_LIBS=''
libcom_srcdir=''
m4_ifval([$1],,[
libcom_included="$1"
AC_ARG_WITH(included-libcom, [AS_HELP_STRING([--without-included-libcom],[Do not build against included libcom])],[
if test x"$withval" = x"no" ; then
	libcom_included=""
fi
])
if test x"$libcom_included" = x"" ; then
	true
else
	if test -d "$srcdir/$libcom_included" ; then
		libcom_srcdir="`cd \"${libcom_included}\" && pwd`"
	fi
fi
])
AC_ARG_WITH(libcom-sources, [AS_HELP_STRING([--with-libcom-sources=PATH],[Build against a libcom source tree])],[
libcom_srcdir="`cd \"${withval}\" && pwd`"])

if test x"$libcom_srcdir" = x"" ; then
	# Normal tests
	AC_CHECK_HEADER([COM/COM.h],[AC_DEFINE([HAVE_COM_COM_H], 1, [Define to 1 if you have <COM/COM.h>])],[AC_MSG_ERROR([cannot find <COM/COM.h> from libCOM])])
	AC_TRY_LINK([#include "COM/COM.h"],[com_init(NULL);],[LIBCOM_LIBS="-lCOM"],[AC_MSG_ERROR([cannot find -lCOM])])
else
	AC_MSG_RESULT([building against not-yet-installed libcom sources in ${libcom_srcdir}])
	LIBCOM_CPPFLAGS="-I${libcom_srcdir}/include"
	LIBCOM_LIBS="${libcom_srcdir}/libCOM/libCOM.la"
	COMIDL="${libcom_srcdir}/comidl/comidl -nostdinc -I${libcom_srcdir}/include -I${libcom_srcdir}/include/DCE-RPC"
fi
AC_SUBST([LIBCOM_CPPFLAGS])
AC_SUBST([LIBCOM_LIBS])
AC_SUBST([COMIDL])
])dnl
