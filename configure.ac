dnl Nexgenta Build Tools
dnl http://developer.nexgenta.com/buildtools/

AC_INIT([buildtools],[master],[autogen])
AM_INIT_AUTOMAKE([foreign])
AM_MAINTAINER_MODE

autogen_toolsdir='${datadir}/buildtools'
AC_SUBST([autogen_toolsdir])

AC_CONFIG_FILES([
Makefile
ext/Makefile
])

AC_CONFIG_FILES([autogen.inst:autogen],[chmod +x autogen.inst])

AC_OUTPUT
