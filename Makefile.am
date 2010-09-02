## Nexgenta Build Tools
## http://developer.nexgenta.com/buildtools/
##
## Copyright (c) 2003, 2004, 2005, 2006, 2007, 2008, 2009 Mo McRoberts.
##
## Redistribution and use in source and binary forms, with or without
## modification, are permitted provided that the following conditions
## are met:
## 1. Redistributions of source code must retain the above copyright
##    notice, this list of conditions and the following disclaimer.
## 2. Redistributions in binary form must reproduce the above copyright
##    notice, this list of conditions and the following disclaimer in the
##    documentation and/or other materials provided with the distribution.
## 3. The names of the author(s) of this software may not be used to endorse
##    or promote products derived from this software without specific prior
##    written permission.
##
## THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, 
## INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
## AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL
## AUTHORS OF THIS SOFTWARE BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
## SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
## TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
## PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
## LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
## NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS 
## SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

SUBDIRS = ext

EXTRA_DIST = autogen decl.h.in LICENSE PROJECT-README \
	buildtools.m4 bundles.m4 config.m4 gnustep.m4 packages.m4 php5.m4 \
	configure.ac

if BUILDTOOLS_NOINST
noinst_SCRIPTS = autogen
else
bin_SCRIPTS = .tmp/autogen
endif

autogen_tools_DATA = decl.h.in LICENSE \
	packages.m4 php5.m4 bundles.m4 gnustep.m4 config.m4

.tmp/autogen: autogen.inst
	test -d .tmp || mkdir .tmp
	cp autogen.inst .tmp/autogen
