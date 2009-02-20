dnl @(#) $Id$
dnl Jazzio Labs Autotools support - source pacakges
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
dnl JL_WITH_PACKAGE(varpfx, name, shortname, header, lib, func, srcincdir=include, srclibdir,srcdir=shortname)
AC_DEFUN([JL_WITH_PACKAGE],[
jl_req_included="auto"
jl_req_sources="no"
jl_req_prefix="$prefix"
jl_req_found="no"
jl_req_incsrc="$9"
test x"$jl_req_incsrc" = x"" && jl_req_incsrc="$3"
AC_ARG_WITH(included-$3, [AS_HELP_STRING([--without-included-$3],[Do not build against included ]$2[, if available])],[jl_req_included="$withval"])
AC_ARG_WITH($3-sources, [AS_HELP_STRING([--with-$3-sources=DIR],[Build against uninstalled ]$2[ sources in DIR])],[jl_req_sources="$withval"])
AC_ARG_WITH($3, [AS_HELP_STRING([--with-$3=PREFIX],[Use installed ]$2[ in PREFIX])],[jl_req_sources="$withval"])
AC_LANG_PUSH([C])
if test x"$jl_req_sources" = x"no" ; then
	true
elif test x"$jl_req_sources" = x"yes" ; then
	AC_MSG_ERROR([you must specify a pathname for ]$2[ sources (e.g., --with-]$3[-sources=PATH])
else
	AC_MSG_CHECKING([for uninstalled ]$2[ sources in $jl_req_sources])
	jl_req_srcincdir="$7"
	jl_req_srclibdir="$8"
	test x"$jl_req_srcincdir" = x"" && jl_req_srcincdir="include"
	test x"$jl_req_srclibdir" = x"" && jl_req_srclibdir="."
	if test -r "${jl_req_sources}/${jl_req_srcincdir}/$4" ; then
		AC_MSG_RESULT([found])
		jl_req_found="sources"
		jl_req_sources="`cd \"${jl_req_sources}\" && pwd`"
		jl_req_cppflags="-I${jl_req_sources}/${jl_req_srcincdir}"
		jl_req_ldflags="-L${jl_req_sources}/${jl_req_srclibdir}"
		jl_req_libs="-l$5"
	else
		AC_MSG_ERROR([could not find uninstalled ]$2[ sources in $jl_req_sources])
	fi
fi
if test x"${jl_req_found}" = x"no" ; then
	if test x"${jl_req_included}" = x"no" ; then
		true
	else
		AC_MSG_CHECKING([for included ]$2[ sources in $jl_req_incsrc])
		if test -d "$jl_req_incsrc" ; then
			jl_req_found="included"
			ac_configure_args="--with-$3-sources=`cd \"$jl_req_incsrc\" && pwd` $ac_configure_args"
			AC_MSG_RESULT([found])
		else
			AC_MSG_RESULT([not found])
		fi
	fi
fi
if test x"${jl_req_found}" = x"no" ; then
	test x"$jl_req_prefix" = x"NONE" && jl_req_prefix="$ac_default_prefix"
	if test x"${jl_req_prefix}" = x"no" ; then
		true
	else
		if test x"${jl_req_prefix}" = x"yes" ; then
			true
		else
			AC_MSG_CHECKING([for ]$2[ in $jl_req_prefix])
			jl_req_savelibs="$LIBS"
			jl_req_saveldflags="$LDFLAGS"
			jl_req_savecpp="$CPPFLAGS"

			CPPFLAGS="${CPPFLAGS} -I${jl_req_prefix}/include"
			LDFLAGS="${LDFLAGS} -L${jl_req_prefix}/lib"
			LIBS="-l$5"
			AC_LINK_IFELSE(AC_LANG_PROGRAM([#include "]$4["],[void *jl__req_test = (void *)]$6[;]),[jl_req_found=yes])
			LIBS="$jl_req_savelibs"
			LDFLAGS="$jl_req_saveldflags"
			CPPFLAGS="$jl_req_savecpp"
			if test x"${jl_req_found}" = x"yes" ; then
					jl_req_cppflags="-I${jl_req_prefix}/include"
					jl_req_ldflags="-L${jl_req_prefix}/lib"
					jl_req_libs="-l$5"
			fi
			AC_MSG_RESULT([$jl_req_found])
		fi
		if test x"${jl_req_found}" = x"no" ; then
			AC_MSG_CHECKING([for $2])
			jl_req_savelibs="$LIBS"
			LIBS="-l$5"
			AC_LINK_IFELSE(AC_LANG_PROGRAM([#include "]$4["],[void *jl__req_test = (void *)]$6[;]),[jl_req_found=yes])
			LIBS="$jl_req_savelibs"
			AC_MSG_RESULT([$jl_req_found])
		fi
	fi
fi
if test x"$jl_req_found" = x"no" ; then
	$1[_FOUND]="no"
else
	$1[_FOUND]="$jl_req_found"
	$1[_CPPFLAGS]="$jl_req_cppflags"
	$1[_LIBS]="$jl_req_libs"
	$1[_LDFLAGS]="$jl_req_ldflags"
fi
AC_SUBST($1[_FOUND])
AC_SUBST($1[_CPPFLAGS])
AC_SUBST($1[_LIBS])
AC_SUBST($1[_LDFLAGS])
AC_LANG_POP([C])
])dnl
dnl
dnl JL_WITH_PACKAGE(varpfx, name, shortname, header, lib, func, srcincdir=include, srclibdir,srcdir=shortname)
AC_DEFUN([JL_REQUIRE_PACKAGE],[
JL_WITH_PACKAGE($1,$2,$3,$4,$5,$6,$7,$8,$9)dnl
if test x"[$]$1[_FOUND]" = x"no" ; then
	AC_MSG_ERROR([cannot locate required ]$2)
fi
])dnl
dnl
dnl JL_WITH_LIBCOM(srcdir=libcom)
AC_DEFUN([JL_WITH_LIBCOM],[
JL_WITH_PACKAGE(LIBCOM, libCOM, libcom, COM/COM.h, COM, com_init,,libCOM,$1)
])dnl
dnl
dnl JL_REQUIRE_LIBCOM(srcdir=libcom)
AC_DEFUN([JL_REQUIRE_LIBCOM],[
JL_REQUIRE_PACKAGE(LIBCOM, libCOM, libcom, COM/COM.h, COM, com_init,,libCOM,$1)
])dnl
dnl JL_REQUIRE_LIBIRI(srcdir=libiri)
AC_DEFUN([JL_REQUIRE_LIBIRI],[
JL_REQUIRE_PACKAGE(LIBIRI, libIRI, libiri, iri.h, iri, iri_parse,,libiri,$1)
])
dnl JL_REQUIRE_LIBIRI(srcdir=libdbo)
AC_DEFUN([JL_REQUIRE_LIBDBO],[
JL_REQUIRE_PACKAGE(LIBDBO, libDBO, libdbo, DBO/DBO.h, DBO, dbo_connect,,libDBO,$1)
])

