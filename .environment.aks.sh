# .environment.aks.sh
# Alan's bashrc startup for any system
# $Id: .environment.aks.sh,v 1.8 2010/03/17 22:30:24 aks Exp $

# Define my current working group
unset WORKGROUP

# more/less

m()    { less "$@" ; }
more() { less "$@" ; }

# filesystem listings

ls()   { /bin/ls -FG "$@" ; }
ll()   { ls -l "$@" ; }
lsa()  { ls -a "$@" ; }
lsd()  { ls -d "$@" ; }
lsad() { ls -ad "$@" ; }
lsg()  { ls -lg "$@" ; }

# t [directory] [ limit ] -- show <limit> "top" modified files

t()   { 
  local limit=-20
  case "$1" in
    -[0-9]|-[0-9][0-9])	
      limit="$1" ; shift ;;
  esac
  ls -latch "$@"| head $limit
}

dtree() { 
  ls -R "$@" | 
  grep ':$'  | 
  sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/ /' -e 's/-/|/'  
}

# Directory stack

pu() { pushd "$@" ; }
po() { popd $@ ; }
alias	di='dirs -v'
alias	d='dirs -v'

# grep
#g()   { grep -i "$@" ; }
#gr()  { grep "$@" ; }

alias g='grep -i'
alias gr=grep

# process listings
#psg() { ps auxww | grep -i "$@" ; }
#psj() { ps auxww | grep -i java ; }

alias	psg='ps auxww | grep -i'
alias	psj='ps auxx | grep -i java'

# pretty cal
ncal() { 
  cal | grep -C6 --color -e " $(date +%e)" -e "^(date +%e)" 
}

# history
h() { history ${1:-20} ; }

# use vi for visual editing
export VISUAL=vi

# colors
# 31m - red
# 32m - green
# 33m - yellow
# 34m - blue
# 35m - purple
# 36m - turquoise, teal blue
# 37m - white
# 38m - black
# 39m
  
# set the prompt

export PS1='\[\e[1;34m\]\u@\h:\W \t (\j) <\!>\n\$\[\e[0;00m\] '

# set special CD for "screen"
if [[ "$TERM" = 'screen' ]]; then
  title() { printf "\ek%s\e\\" "${1:-`hostname`:}" ; }
  dirtitle() { 
    if [ -t 1 ]; then
      title "$HOST:`basename $PWD`" ;  
    fi
  }
  cd() { builtin cd "${1:-$HOME}" ; dirtitle ; }
  pu() { pushd "$@" ; dirtitle ; }
  po() { popd "$@" ; dirtitle ; }
else
  title() { : ; }         # dummy 
  dirtitle() { echo "$HOST:`basename $PWD`" ; }
fi

# update-ssh
#
# When reconnecting to existing screen or tmux sessions, the authentication
# linkage needs to be refreshed.  The script ~/bin/update-ssh does this by
# emitting a new export command.

updatessh() { eval `update-ssh` ; }

# Do this to make it hard to kill your login shell accidentally
export IGNOREEOF=1
unset autologout

# vim: sw=2 ai
