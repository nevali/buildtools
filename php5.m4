dnl @(#) $Id$
dnl Jazzio Labs Autotools support - source pacakges
dnl Copyright (c) 2006, 2007, 2008, 2009 Mo McRoberts.
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
AC_DEFUN([JL_REQUIRE_PHP5],[AC_REQUIRE([JL_REQUIRE_PHP5_])])dnl
AC_DEFUN([JL_REQUIRE_PHP5_],[
	AC_ARG_WITH(php-config,[AS_HELP_STRING([--with-php-config=PATH],[specify path to the php-config script (e.g., /usr/local/php5/bin/php-config)])],[phpconfig=$withval],[phpconfig=''])
	phppath="$PATH"
	if test x"$phpconfig" = x"" ; then
		AC_PATH_PROG(phpconfig, php-config-5)
	fi
	if test x"$phpconfig" = x"" ; then
		AC_PATH_PROG(phpconfig, php-config5)
	fi
	if test x"$phpconfig" = x"" ; then
		AC_PATH_PROG(phpconfig, php-config)
	fi
	if test x"$phpconfig" = x"" ; then
		AC_MSG_ERROR([cannot locate your php-config script (see --with-php-config)])
	fi
	phprootdir=`${phpconfig} --prefix`
	phpincludes=`${phpconfig} --includes`
	phpldflags="`${phpconfig} --ldflags` -R${phpdir}/lib"
	phplibs=`${phpconfig} --libs`
	PHP_5=`${phpconfig} --php-binary`
	phppath="${phpdir}/bin:${phppath}"
	if test x"${PHP_5}" = x"" ; then
		AC_PATH_PROG(PHP_5, php-5)
	fi
	if test x"${PHP_5}" = x"" ; then
		AC_PATH_PROG(PHP_5, php5)
	fi
	if test x"${PHP_5}" = x"" ; then
		AC_PATH_PROG(PHP_5, php-5)
	fi
	dnl TODO: Check that ${PHP_5} is actually PHP 5

	AC_PATH_PROG(PHPIZE_5, phpize-5,,$phppath)

	if test x"${PHPIZE_5}" = x"" ; then
		AC_PATH_PROG(PHPIZE_5, phpize5,,$phppath)
	fi
	if test x"${PHPIZE_5}" = x"" ; then
		AC_PATH_PROG(PHPIZE_5, phpize,,$phppath)
	fi
	
	phpdir="${phprootdir}/share/php"
	AC_SUBST(phpdir)
	AC_SUBST(PHP_5)
	AC_SUBST(PHPIZE_5)
])
