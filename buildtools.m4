AC_DEFUN([BUILDTOOLS_INIT],[
AM_CONDITIONAL([BUILDTOOLS_NOINST],[test x"${autogen_toolsdir}" = x""])
AC_SUBST([autogen_toolsdir])
])

AC_DEFUN([BUILDTOOLS_DETECT_VERSION],[
    AC_MSG_CHECKING([package version])
	if test x"$PACKAGE_VERSION" = x"trunk" ; then
	    if test -r "$srcdir/.release" ; then
		   PACKAGE_VERSION=`cat "$srcdir/.release"`
		fi
    fi

	if test x"$PACKAGE_VERSION" = x"trunk" ; then
	    if test -d "$srcdir/.git" ; then
		   branch=`( cd "$srcdir" && git symbolic-ref HEAD ) 2>/dev/null`
		   case "$branch" in
		   		refs/heads/master)
						;;
		   		refs/heads/*)
						PACKAGE_VERSION=`echo $branch | sed s'!refs/heads/!!'`
						;;
		   esac
		   if test x"$PACKAGE_VERSION" = x"trunk" ; then
		   	  rev=`(cd "$srcdir" && git rev-parse HEAD | cut -c1-7) 2>/dev/null`
		   	  if test x"$rev" = x"HEAD" || test x"$rev" = x"" ; then
		        true
		   	  else
		      	 PACKAGE_VERSION=$rev
		   	  fi
		   fi
    	fi
	fi
	VERSION=$PACKAGE_VERSION
	PACKAGE_STRING="$PACKAGE_NAME $PACKAGE_VERSION"
    AC_MSG_RESULT([$PACKAGE_VERSION])
	AC_SUBST([VERSION])
])
