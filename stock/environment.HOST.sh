# ~/.environment.__HOST__.sh
#
# Envars for __HOST__
#

export WORKGROUP=__WORKGROUP__

### Debugging statments
### set verbose
### set echo

# Make rsync work better with partial transfers
export SYNC_PARTIAL_DIR=.rsync-tmp

# Set the various info directories; and set them from more specific to more general.

infopath=(	/usr/share/info		\
		/usr/info		\
		/usr/local/info		\
		/usr/local/share/info	\
	     )

add_paths INFOPATH vpU infopath

# These are to set the PATH envar

newpaths=(	\
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

add_paths PATH nvpu newpaths

mandirs=(	\
		/usr/local/share/man	\
		/usr/local/man		\
		/usr/share/man		\
		/usr/man		\
		~/man		        \
	    )
add_paths MANPATH vU mandirs

# So man pages work correctly
if [[ -n `which gnroff` ]]; then
  export NROFF=gnroff
  export TROFF=gnroff
fi

# set PERL library
if [[ -d $HOME/lib/perl ]]; then
  export PERLLIB=$HOME/lib/perl
fi

# Set the cdpath to make it easy to get to various directories on 
# this system
cdpath=(	. 			\
		..			\
		~			\
                ~/src                   \
	     )
add_paths CDPATH nvU cdpath

# add rbenv to the PATH
# if ~/.rbenv/bin is present, use it
if [[ -d ~/.rbenv/bin ]] ; then
  if [[ -d /usr/local/var/rbenv ]]; then
    # use the brew version of rbenv
    export RBENV_ROOT=/usr/local/var/rbenv
  fi
  export PATH=~/.rbenv/bin:$PATH
  eval "$(rbenv init -)"
fi

# Setup PerlBrew if present
if [[ -e ~/perl5/perlbrew/etc/bashrc ]]; then
  source ~/perl5/perlbrew/etc/bashrc
fi

unset autologout

# vim: sw=2 ai
