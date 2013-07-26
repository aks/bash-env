# ~/.environment.anywhere.sh
#
# Envars for host anywhere (MacOS ibook)
#
# $Header: /Users/aks/RCS/.environment.anywhere.sh,v 1.5 2010/03/11 02:06:23 aks Exp $
#

export WORKGROUP=marketocracy

sock=/tmp/501/SSHKeychain.socket 
if [[ -e "$sock" ]]; then
    export SSH_AUTH_SOCK="$sock"
fi
unset sock

### Debugging statments
### set verbose
### set echo

# Make rsync work better with partial transfers
export SYNC_PARTIAL_DIR=.rsync-tmp

# set CVSROOT for my private software cache
if [[ -z "$CVSROOT" && -d "~/src/CVSROOT" ]] ; then
  export CVSROOT=~/src/CVSROOT
fi

export SVNROOT='svn+ssh://svn.marketocracy.com/svn/repo/main/trunk/'

if [[ -z "$HOSTALIASES" && -f ~/.hostaliases ]]; then
  export HOSTALIASES=~/.hostaliases
fi

# Define the COOKIE paths
export COOKIE_PATH=~aks/Documents/aks/mail/Cookies
export COOKIE_PATTERN="cookie.*\\.(txt|dat)"'$'


# Set the various info directories; and set them from more specific to more general.

infopath=(	/usr/share/info		\
		/usr/info		\
		/usr/local/info		\
		/usr/local/share/info	\
	     )

add_paths INFOPATH vpU infopath

newpath=(	\
		/usr/local/ActivePerl-5.12/bin \
		/usr/local/bin		\
		/opt/local/bin		\
		/usr/bin		\
		/sw/bin			\
		/bin			\
		$path 			\
		. 			\
		~/bin		        \
		/usr/sbin		\
		/sbin/			\
		/sw/sbin		\
		/usr/local/mysql/bin	\
		/Library/FrontBase/bin	\
		/usr/local/etc		\
	    )

add_paths PATH nvpu newpath

mandirs=(	\
		/usr/local/ActivePerl-5.12/share/man \
		/usr/local/share/man	\
		/usr/local/man		\
		/usr/share/man		\
		/usr/man		\
		~/man		        \
		/usr/ssl/man		\
	    )
add_paths MANPATH vU mandirs

# So man pages work correctly
export NROFF=gnroff
export TROFF=gnroff

# set PERL library
export PERLLIB=$HOME/lib/perl

export DOMAINS=( "${DOMAINS[@]}" )

export JPATH601=~aks/j601

# Set the cdpath to make it easy to get to various directories on 
# this system
cdpath=(	. 					\
		..					\
		~
		~/Marketocracy/ 			\
		~/Projects/ 				\
		~/Projects/MTACO/repo/ 			\
		~/Projects/MTACO/repo/main/trunk/	\
		~/Projects/MTACO/webrepo/		\
	     )
add_paths CDPATH nvU cdpath

# Set up special aliases

unset autologout
