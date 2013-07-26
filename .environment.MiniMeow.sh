# ~/.environment.anywhere.sh
#
# Envars for host MiniMeow (MacOS MacMini)
#
# $Header: /Users/aks/RCS/.environment.MiniMeow.sh,v 1.6 2013/07/04 22:29:36 aks Exp $
#

export WORKGROUP=Stebbens

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

# These are to set the PATH envar

newpath=(	\
		~/.rbenv/bin		\
		/usr/local/bin		\
		/usr/bin		\
		/bin			\
		$path 			\
		. 			\
		~/bin		        \
		/usr/sbin		\
		/sbin/			\
		/usr/local/etc		\
	    )

add_paths PATH nvpu newpath

mandirs=(	\
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

# Set the cdpath to make it easy to get to various directories on 
# this system
cdpath=(	. 					\
		..					\
		~					\
		~/Dev/					\
		~/Dev/meteor/				\
		~/Dev/BL/				\
		~/Projects/ 				\
	     )
add_paths CDPATH nvU cdpath

# add rbenv to the PATH
# use the brew version of rbenv
export RBENV_ROOT=/usr/local/var/rbenv
eval "$(rbenv init -)"

# Setup PerlBrew
source ~/perl5/perlbrew/etc/bashrc

# Set up special aliases

unset autologout
