AC_DEFUN([BUILDTOOLS_INIT],[
AM_CONDITIONAL([BUILDTOOLS_NOINST],[test x"${autogen_toolsdir}" = x""])
AC_SUBST([autogen_toolsdir])
])

