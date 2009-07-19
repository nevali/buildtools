dnl @(#) $Id$
dnl Jazzio Labs Autotools support - config file support
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
dnl Override _AC_INIT_PARSE_ENABLE to deal with --config=NAME
m4_pushdef([_AC_INIT_PARSE_ENABLE],m4_defn([_AC_INIT_PARSE_ENABLE])[
m4_if([$1],[with],[
  -config=*|--config=*)
	jl_config_name=$ac_optarg
	;;
])dnl
])dnl
dnl _JL_CONFIG_HELP
AC_DEFUN([_JL_CONFIG_HELP],[
m4_divert_push([HELP_BEGIN])dnl
m4_changequote(==,==)dnl

Stored build configurations:
  --config=NAME          Source options from the configuration NAME.

Configurations are sourced from BUILDDIR/config or SRCDIR/config, in that order.
m4_changequote([,])dnl
m4_divert_pop([HELP_BEGIN])dnl
])dnl
dnl JL_CONFIG_INIT
dnl - Check for --config=NAME and if supplied, apply configuration options
dnl   from $builddir/config/NAME or $srcdir/config/NAME, whichever is found
dnl   first.
AC_DEFUN([JL_CONFIG_INIT],[
AC_REQUIRE([_JL_CONFIG_HELP])

## enable THING [ARG=yes]
enable()
{
	_opt="$[1]"
	_val="$[2]"
	test x"$_val" = x"" && _val="yes"
	eval "enable_${_opt}=\"\$_val\""
	AC_MSG_RESULT([  setting option --enable-$_opt=$_val])
}

## disable THING
disable()
{
	_opt="$[1]"
	eval "enable_${_opt}=no"
	AC_MSG_RESULT([  setting option --disable-$_opt])
}

## with THING [ARG=yes]
with()
{
	_opt="$[1]"
	_val="$[2]"
	test x"$_val" = x"" && _val="yes"
	eval "with_${_opt}=\"\$_val\""
	AC_MSG_RESULT([  setting option --with-$_opt=$_val])
}

## without THING
without()
{
	_opt="$[1]"
	eval "with_${_opt}=no"
	AC_MSG_RESULT([  setting option --without-$_opt])
}

if test x"$jl_config_name" = x"" ; then
	true
else
	if test -r "config/$jl_config_name" ; then
		AC_MSG_RESULT([using build configuration config/$jl_config_name])
		jl_config_path="config/$jl_config_name"
	elif test -r "$srcdir/config/$jl_config_name" ; then
		AC_MSG_RESULT([using build configuration $srcdir/config/$jl_config_name])
		jl_config_path="$srcdir/config/$jl_config_name"
	else
		if test x"$srcdir" = x"." ; then
			AC_MSG_ERROR([cannot locate $jl_config_name in ./config])
		else
			AC_MSG_ERROR([cannot locate $jl_config_name in ./config/ or $srcdir/config/])
		fi
	fi
	
	. "$jl_config_path"
	
fi
])
