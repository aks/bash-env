# .environment.__USER__.sh
# __USER__'s bashrc startup for any system

# ensure these named arguments do not exist as aliases
noalias() { 
  while [[ $# -gt 0 ]]; do
    eval "unalias $1 2>/dev/null" 
    shift
  done
}

# more/less

noalias m more
m()    { less "$@" ; }
more() { less "$@" ; }

# filesystem listings

# Create these as functions and NOT aliases
case `uname -s` in
  Darwin|MacOS) LSFLAGS='-FG' ;;
  Linux)        LSFLAGS='-Fh --color=auto' ;;
esac

noalias ls ll lsa lsd lsad lsg
ls()   { /bin/ls $LSFLAGS "$@" ; }
ll()   { ls -l "$@" ; }
lsa()  { ls -a "$@" ; }
lsd()  { ls -d "$@" ; }
lsad() { ls -ad "$@" ; }
lsg()  { ls -lg "$@" ; }

if [[ -f /usr/bin/dircolors ]]; then
  eval `dircolors`
fi

# t [directory] [ limit ] -- show <limit> "top" modified files

noalias t
t()   { 
  local limit=-20
  case "$1" in
    -[0-9]|-[0-9][0-9])	
      limit="$1" ; shift ;;
  esac
  ls -latch "$@"| head $limit
}

noalias dtree
dtree() { 
  ls -R "$@" | 
  grep ':$'  | 
  sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/ /' -e 's/-/|/'  
}

# Directory stack
noalias pu po di di
pu() { pushd "$@" ; }
po() { popd $@ ; }
di() { dirs -v ; }
d()  { dirs -v ; }

# grep
noalias g gr
g()   { grep -i "$@" ; }
gr()  { grep "$@" ; }

# process listings
noalias psg psj
psg() { ps auxww | grep -i "$@" ; }
psj() { ps auxww | grep -i java ; }

# pretty cal
noalias ncal
ncal() { 
  cal | grep -C6 --color -e " $(date +%e)" -e "^(date +%e)" 
}

# history
noalias h
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

if [[ $SHLVL > 1 ]]; then
  export PS1="\[\e[1;34m\](L=$SHLVL) \u@\H:\W \t (\j) <\!>\n\$\[\e[0;00m\] "
else
  export PS1='\[\e[1;34m\]\u@\H:\W \t (\j) <\!>\n\$\[\e[0;00m\] '
fi

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

# Special shell level tracker
noalias shlvl quit exit
shlvl() { set | grep SHLVL ; }
quit()  { (( SHLVL > 1 )) && builtin exit || echo "Not in a subshell!" ; }
exit()  { quit ; }

# vim: sw=2 ai
