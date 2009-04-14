dnl Jazzio Labs Autotools support - GNUstep support
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
dnl Check for a gnustep-config script, unless the user explicitly tells us
dnl they don't want GNUstep support (or alternatively, if the OS is one of
dnl darwin, rhapsody, openstep or nextstep and an explicit --with-gnustep
dnl is not given).
AC_DEFUN([_JL_GNUSTEP_INIT],[
AC_REQUIRE([AC_CANONICAL_HOST])
AC_ARG_WITH([gnustep],[AS_HELP_STRING([--with-gnustep],[Check for GNUstep (default=auto)])],[check_gnustep=$withval],[check_gnustep=auto])
gnustep_enable=no
gnustep_host=''
if test x"$check_gnustep" = x"no" ; then
	true
	gnustep_explicit=yes
elif test x"$check_gnustep" = x"yes" ; then
	true
	gnustep_explicit=yes
else
	gnustep_explicit=no
	case "$host_os" in
		darwin*|rhapsody*|openstep*|nextstep*)
			check_gnustep=no
			;;
		*)
			check_gnustep=yes
			;;
	esac
fi
if test x"$check_gnustep" = x"yes" ; then
	AC_PATH_PROG([GNUSTEP_CONFIG],[gnustep-config])
	if test x"$GNUSTEP_CONFIG" = x"" ; then
		true
	else
		gnustep_enable=yes
		gnustep_host=`$GNUSTEP_CONFIG --variable=GNUSTEP_HOST`
	fi
fi
AC_MSG_CHECKING([for GNUstep])
if test x"$gnustep_enable" = x"yes" ; then
	AC_MSG_RESULT([yes, host type is $gnustep_host])
else
	AC_MSG_RESULT([no])
fi
])
dnl JL_GNUSTEP_VAR(name)
dnl Set the shell variable NAME to the value of
dnl `gnustep-config --variable=name` if GNUstep is present, and an empty
dnl string if not.
AC_DEFUN([JL_GNUSTEP_VAR],[
AC_REQUIRE([_JL_GNUSTEP_INIT])
if test x"$gnustep_enable" = x"yes" ; then
	]$1[="`$GNUSTEP_CONFIG --variable=]$1[`"
else
	]$1[=''
fi
])
dnl JL_CHECK_GNUSTEP([action-if-found],[action-if-not-found])
AC_DEFUN([JL_CHECK_GNUSTEP],[
AC_REQUIRE([_JL_GNUSTEP_INIT])
if test x"$gnustep_enable" = x"yes" ; then
	$1
	true
else
	$2
	true
fi
])
