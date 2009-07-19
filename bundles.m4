dnl @(#) $Id$
dnl Jazzio Labs Autotools support - bundles
dnl Copyright (c) 2003, 2004, 2005, 2006, 2007, 2008, 2009 Mo McRoberts.
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
dnl Override _AC_INIT_PARSE_ENABLE to deal with 
m4_pushdef([_AC_INIT_PARSE_ENABLE],m4_defn([_AC_INIT_PARSE_ENABLE])[
m4_if([$1],[with],[
  -domain=*|--domain=*)
	bundledomain=$ac_optarg
	;;
  -librarydir=*|--librarydir=*)
	librarydir=$ac_optarg
	;;
  -appsdir=*|--appsdir=*)
	appsdir=$ac_optarg
	;;
  -frameworkdir=*|--frameworkdir=*)
	frameworkdir=$ac_optarg
	;;
  -appsupportdir=*|--appsupportdir=*)
	appsupportdir=$ac_optarg
	;;
])dnl
])dnl
dnl _JL_BUNDLE_HELP
AC_DEFUN([_JL_BUNDLE_HELP],[
m4_divert_push([HELP_BEGIN])dnl
m4_changequote(==,==)dnl

Bundle installation paths (for --enable-bundles):
  --domain=NAME          Install bundles into domain NAME (system, network, 
                         local, or user)
  --librarydir=DIR       bundled Libary path [DOMAINDIR/Library or
                         $GNUSTEP_xxx_LIBRARY]
  --frameworkdir=DIR     bundled Frameworks path [LIBRARYDIR/Frameworks]
  --appsdir=DIR          bundled Applications path [DOMAINDIR/Applications or 
                         $GNUSTEP_xxx_APPS]
  --appsupportdir=DIR    application support path [LIBRARYDIR/Application 
                         Support]
m4_changequote([,])dnl
m4_divert_pop([HELP_BEGIN])dnl
])dnl
dnl JL_ENABLE_BUNDLES
dnl - Force building of bundles (i.e., if this is a package targeted at
dnl   GNUstep). This macro is for packages where bundles MUST be built, and
dnl   should be called before JL_CHECK_BUNDLES.
AC_DEFUN([JL_ENABLE_BUNDLES],[
AC_BEFORE([$0],[JL_CHECK_BUNDLES])dnl
jl_enable_bundles_auto="yes"
])dnl
AC_DEFUN([JL_DELTA_BUNDLES],[
AC_REQUIRE([JL_ENABLE_BUNDLES])
jl_bundles_delta="yes"
if test x"$1" = x"" ; then
	true
else
	bundledomain="$1"
fi
])
dnl JL_CHECK_BUNDLES
dnl - If building bundles has been explicitly enabled, or implicitly because
dnl   of the host OS (i.e., Darwin), set jl_build_bundles to "yes" and
dnl   determine librarydir, frameworkdir, appsdir, appsupportdir
AC_DEFUN([JL_CHECK_BUNDLES],[
AC_REQUIRE([_JL_BUNDLE_HELP])
AC_REQUIRE([AC_CANONICAL_HOST])
AC_REQUIRE([_JL_GNUSTEP_INIT])
AC_ARG_ENABLE(bundles, [AS_HELP_STRING([--enable-bundles],[Install libraries and applications as bundles (default=no)])],[jl_enable_bundles=$enableval],[jl_enable_bundles=auto])
AC_MSG_CHECKING([whether to install frameworks and applications as bundles])
if test x"${jl_enable_bundles_auto}" = x"" ; then
	case "$host_os" in
		darwin*|rhapsody*|nextstep*|openstep*)
			jl_enable_bundles_auto='yes'
			;;
		*)
			if test x"$gnustep_enable" = x"yes" && test x"$gnustep_explicit" = x"yes" ; then
				jl_enable_bundles_auto='yes'
			else
				jl_enable_bundles_auto='no'
			fi
			;;
	esac
fi
case "$jl_enable_bundles" in
	yes|no)
		;;
	*)
		jl_enable_bundles="${jl_enable_bundles_auto}"
		;;
esac
AC_MSG_RESULT([${jl_enable_bundles}])
if test x"$jl_bundles_delta" = x"yes" ; then
	_JL_BUNDLE_DELTAPATHS
else
case "$host_os" in
	nextstep*|openstep*)
		deflibrarydir='/LocalLibrary'
		defappsdir='/LocalApps'
		;;
	darwin*|rhapsody*)
		_JL_BUNDLE_MACPATHS
		;;
	*)
		if test x"$jl_bundles_delta" = x"auto" ; then
			_JL_BUNDLE_DELTAPATHS
		elif test x"$gnustep_enable" = x"yes" ; then
			_JL_BUNDLE_GSPATHS
		else
			_JL_BUNDLE_DEFPATHS
			deflibrarydir='${exec_prefix}/lib/GNUstep'
			defappsdir='${librarydir}/Applications'
		fi
		;;
esac
fi
test x"$librarydir" = x"" && librarydir="$deflibrarydir"
test x"$appsdir" = x"" && appsdir="$defappsdir"
test x"$frameworkdir" = x"" && frameworkdir='${librarydir}/Frameworks'
test x"$appsupportdir" = x"" && appsupportdir='${librarydir}/Application Support'
AC_SUBST([librarydir])
AC_SUBST([appsdir])
AC_SUBST([frameworkdir])
AC_SUBST([appsupportdir])
])dnl
dnl
dnl JL_BUNDLE_PATHS(varpfx, path, basename, [inplace])
dnl - Define bundle /path/, and set /varpfx/bindir, /varpfx/libdir,
dnl   /varpfx/includedir, /varpfx/sharedstatedir to either the system-wide
dnl   path, or the bundled path, depending on whether jl_build_bundles is
dnl   "yes".
AC_DEFUN([JL_BUNDLE_PATHS],[
AC_REQUIRE([JL_CHECK_BUNDLES])dnl
if test x"${jl_enable_bundles}" = x"yes" ; then
	if test x"$4" = x"" ; then
		[$1]bundledir='[$2]'
	elif test x"${jl_build_inplace}" = x"yes" ; then
		[$1]bundledir="${jl_inplace_root}"'/[$4]'
	else
		[$1]bundledir='[$2]'
	fi
	[$1]bindir="${[$1]bundledir}/Contents/${host}"
	[$1]sbindir="${[$1]bundledir}/Contents/${host}"
	[$1]libexecdir="${[$1]bundledir}/Contents/${host}"
	[$1]libdir="${[$1]bundledir}/Contents/${host}"
	[$1]includedir="${[$1]bundledir}/Contents/Headers"
	[$1]sharedstatedir="${[$1]bundledir}/Contents/Resources"
	[$1]fixup="\${BUNDLEFIXUP} '${[$1]bundledir}' '${host}'"
else
	[$1]bundledir='${exec_prefix}'
	[$1]bindir='${bindir}'
	[$1]sbindir='${sbindir}'
	[$1]libexecdir='${libexecdir}'
	[$1]libdir='${libdir}'
	[$1]includedir='${includedir}/[$3]'
	[$1]sharedstatedir='${sharedstatedir}'
	[$1]fixup='true'
fi
AC_SUBST([$1]fixup)
AC_SUBST([$1]bundledir)
AC_SUBST([$1]bindir)
AC_SUBST([$1]libdir)
AC_SUBST([$1]includedir)
AC_SUBST([$1]sharedstatedir)
])dnl
dnl ---- Macros for defining different types of bundle
dnl JL_BUNDLE_FRAMEWORK(varpfx, name, [parent bundle path],[inplace-path])
dnl - Delegate to JL_BUNDLE_PATHS for ${frameworkdir}/name.framework
AC_DEFUN([JL_BUNDLE_FRAMEWORK],[
m4_if([$3],[],[
JL_BUNDLE_PATHS([$1],[${frameworkdir}/]$2[.framework],[$2],[$4])
],[
JL_BUNDLE_PATHS([$1],$3[/Contents/Frameworks/]$2[.framework],[$2],[$4])
])dnl
])dnl
dnl
dnl JL_BUNDLE_APP(varpfx, name, [parent bundle path],[inplace-path])
dnl - Delegate to JL_BUNDLE_PATHS for ${appsdir}/name.app
AC_DEFUN([JL_BUNDLE_APP],[
m4_if([$3],[],[
JL_BUNDLE_PATHS([$1],[${appsdir}/]$2[.app],[$2],[$4])
],[
JL_BUNDLE_PATHS([$1],$3[/Contents/Resources/]$2[.app],[$2],[$4])
])dnl
])dnl
dnl JL_BUNDLE_PLUGIN(varpfx, name, appname, [parent bundle path])
dnl - Delegate to JL_BUNDLE_PATHS for ${appsupportdir}/appname/name.plugin
AC_DEFUN([JL_BUNDLE_PLUGIN],[
m4_if([$4],[],[
JL_BUNDLE_PATHS([$1],[${appsupportdir}/]$3[/PlugIns/]$2[.bundle],[$2])
],[
JL_BUNDLE_PATHS([$1],$3[/Contents/PlugIns/]$2[.bundle],[$2])
])dnl
])dnl
dnl JL_BUNDLE_PERSONALITY(varpfx, name, [parent bundle path], [inplace-path])
dnl - Delegate to JL_BUNDLE_PATHS for ${librarydir}/Personalities/name.personality
AC_DEFUN([JL_BUNDLE_PERSONALITY],[
m4_if([$3],[],[
JL_BUNDLE_PATHS([$1],[${librarydir}/Personalities/]$2[.personality],[$2],[$4])
],[
JL_BUNDLE_PATHS([$1],$3[/Contents/Resources/]$2[.personality],[$2],[$4])
])dnl
])dnl
AC_DEFUN([_JL_BUNDLE_DOMAIN],[
test x"$bundledomain" = x"" && bundledomain=local
case "$bundledomain" in
	system|network|local|user)
		;;
	*)
		AC_MSG_ERROR([bundle domain $bundledomain is not supported. must be one of system, network, local or user])
		;;
esac
])

AC_DEFUN([_JL_BUNDLE_GSPATHS],[
AC_REQUIRE([_JL_BUNDLE_DOMAIN])
JL_GNUSTEP_VAR([GNUSTEP_SYSTEM_APPS])
JL_GNUSTEP_VAR([GNUSTEP_NETWORK_APPS])
JL_GNUSTEP_VAR([GNUSTEP_LOCAL_APPS])
JL_GNUSTEP_VAR([GNUSTEP_USER_APPS])
JL_GNUSTEP_VAR([GNUSTEP_SYSTEM_LIBRARY])
JL_GNUSTEP_VAR([GNUSTEP_NETWORK_LIBRARY])
JL_GNUSTEP_VAR([GNUSTEP_LOCAL_LIBRARY])
JL_GNUSTEP_VAR([GNUSTEP_USER_LIBRARY])
case "$bundledomain" in
	system)
		deflibrarydir="$GNUSTEP_SYSTEM_LIBRARY"
		defappsdir="$GNUSTEP_SYSTEM_APPS"
		;;
	network)
		deflibrarydir="$GNUSTEP_NETWORK_LIBRARY"
		defappsdir="$GNUSTEP_NETWORK_APPS"
		;;
	local)
		deflibrarydir="$GNUSTEP_LOCAL_LIBRARY"
		defappsdir="$GNUSTEP_LOCAL_APPS"
		;;
	user)
		deflibrarydir="$GNUSTEP_USER_LIBRARY"
		defappsdir="$GNUSTEP_USER_APPS"
		;;
esac
])
AC_DEFUN([_JL_BUNDLE_MACPATHS],[
AC_REQUIRE([_JL_BUNDLE_DOMAIN])
case "$bundledomain" in
	system)
		defappsdir="/Applications"
		deflibrarydir="/System/Library"
		;;
	network)
		defappsdir="/Network/Applications"
		deflibrarydir="/Network/Library"
		;;
	local)
		defappsdir="/Applications"
		deflibrarydir="/Library"
		;;
	user)
		defappsdir="$HOME/Applications"
		deflibrarydir="$HOME/Library"
		;;
esac
])
AC_DEFUN([_JL_BUNDLE_DEFPATHS],[
_JL_BUNDLE_MACPATHS
])
AC_DEFUN([_JL_BUNDLE_DELTAPATHS],[
AC_REQUIRE([_JL_BUNDLE_DOMAIN])
case "$bundledomain" in
	system)
		defappsdir="$DELTA_ROOT/System/Applications"
		deflibrarydir="$DELTA_ROOT/System/Library"
		;;
	network)
		defappsdir="$DELTA_ROOT/Network/Applications"
		deflibrarydir="$DELTA_ROOT/Network/Library"
		;;
	local)
		defappsdir="$DELTA_ROOT/Local/Applications"
		deflibrarydir="$DELTA_ROOT/Local/Library"
		;;
	user)
		defappsdir="$HOME/Applications"
		deflibrarydir="$HOME/Library"
		;;
esac
])
dnl JL_CHECK_INPLACE([pwd-tail])
AC_DEFUN([JL_CHECK_INPLACE],[
AC_MSG_CHECKING([if $PACKAGE_NAME is being built in-place])
case "`pwd`" in
	*/$1|*/$1/)
		jl_build_inplace=yes
		;;
	*)
		jl_build_inplace=no
		;;
esac
if test x"$2" = x"" ; then
	jl_inplace_root="`pwd`"
else
	jl_inplace_root="`cd $2 && pwd`"
fi
AC_MSG_RESULT([$jl_build_inplace])
])
