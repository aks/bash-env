# Alan's .aliases.sh file
#
# Miscellaneous aliases

alias a=alias
alias una=unalias

# Job control made a little easier
a j='jobs -l'
a 1='%1'
a 2='%2'
a 3='%3'
a 4='%4'

# directory commands
a .=pwd
a ..='(up)'
a home=cd
a up='up=(`dirs`);cd ${up[1]}:h;echo $cwd;unset up'

if [[ -n "$XDISPLAY" &&  "$TERM" != 'hpterm' ]];  then
  po() { popdir $*  ; xtermname "`pwd`" ; }
  pu() { pushdir $* ; xtermname "`pwd`" ; }
else
  a po='popdir'
  a pu='pushdir'
fi
a d='dirs -v'

a bye=logout

a beep="echo -n ''"

a cp="cp -i"
a cpr="cp -r"

# die bypasses any cleanup in .bash_logout
a die='touch ~/.die.quietly; logout'
[[ -f ~/.die.quietly ]] && { rm -f ~/.die.quietly ; }

# {e}grep invocations
a e='egrep'
a g='grep -i'
a gr='grep'

# Emacs helpers
a ecomp='emacs -batch -f batch-byte-compile'
a ecompdir='emacs -batch -f batch-byte-recompile-directory'
a errno='$PAGER /usr/include/sys/errno.h'

# history command
a h='history'

a mail='Mail'

a mv='mv -i'

a newalias='vi ~/.aliases.sh'

a null='cat /dev/null >'

pe() { printenv $1 | cat -v ; }

a prt='lpr -i -p'

# RCS helpers
a rlogl='rlog -R -L RCS/*'

# rm helpers
a rmi='rm -i'
a rmr='rm -r'

# vi invocations
# htvi -- hard tabs vi
# stvi -- soft tabs vi
# vit -- vi on tag X
a htvi="vi +':set ts=8 sw=4|1'"
a stvi="vi +':set ts=4 sw=4|1'"
a vit='vi -t'
a vi='vim'

# sysline commands
if [[ -n "$DO_SYSLINE" ]];  then		# currently disabled
   a sysline='newsysline'
   a syslineoff='touch -f ~/.syslinelock'
   a syslineon='rm -f ~/.syslinelock'
fi

# make whereis show the path
a whereis='whereis -P'

# Terminal management
a usebs="stty intr ^c erase ^h kill ^u susp ^z"
a usedel="stty intr ^c erase '^?' kill ^u susp ^z"

# Process management
niceme() { ps -axw | grep N | grep $USER | awk '{print $2}' | xargs renice 0 ; }
a psa='ps -aux'
a psall='ps -auxww'
a psg='psall | egrep -i'
a psf='psall | fgrep'
a psu='ps -auxww | grep ''^$USER '''
a psx='ps -auxww | grep -v ''^$USER '''

# Umask management
a private='umask 77'
a public='umask 22'
a groupw='umask 2'
a x+='chmod +x'
a x-='chmod -x'
a w+='chmod u+w'
a aw+='chmod +w'
a w-='chmod -w'

# Term and Xterm label aliases

xtermicon()  { echo -n "]1;$*" ; }
xtermlabel() { echo -n "]2;$*" ; }
xtermname()  { xtermlabel "$@" ; xtermicon "$@" ; }

if [[ -d /usr/X11/lib/config/ ]]; then
  a irules='less /usr/lib/X11/config/Imake.rules'
  a itmpl='less /usr/lib/X11/config/Imake.tmpl'
fi

if [[ -x /usr/X11/bin/xhost && -n "$DISPLAY" ]]; then
  +xhosts() { awk '{print $1}' ~/.xhosts | xargs xhost ; }
fi

# Directory management
# Two kinds: go DIR & back, and "pu","po", & "dirs"
# a back='lastdir="$cwd"; cd "$backdir"; backdir="$lastdir"; pwd'
back() {
  lastdir=`pwd` 
  cd "$backdir"
  backdir="$lastdir"
} 

# a go='backdir="$cwd"; cd'
go() {
  if [[ -n "$1" ]]; then
    backdir=`pwd`
    cd "$1"
  fi
  pwd
}


# Quick'n'dirty list management
# ml args	- make a list=with "args"
# al args	- add to a list=with "args"
# pl		- print current list

ml() { list=( "$@" ) ; }
al() { list=( "${list[@]}" "$@" ) ; }
pl() { echo "${list[@]}" ; }

# Operating System specific aliases
case "`sh -c 'uname -s 2>/dev/null'`" in
AIX*)
	# Virtual screen manager aliases
	smactive() { qsm | egrep active ; }
	smset() { ctl_sm /dev/hft/$1 ; }
	;;
IRIX*)
	# Make SGI Irix numbers come out in units of k (1024) bytes
	a df="/bin/df -k"
	a du="/bin/du -k"
	# There are already some unique 6.5 features
	case "`sh -c 'uname -r 2>/dev/null'`" in
	6.5*)
	    unalias df
	    setenv HUMAN_BLOCKS
	    ;;
	esac
	;;
OSF*)
	;;
"SunOS 4"*)
	;;
"SunOS 5"*)
	a df='df -k'
	;;
Darwin*)
	;;
Linux*)
	;;
esac

# mh aliases
if [[ -r ~/.mh_profile ]]; then
  a n='next'
  a p='prev'
  a s="show -show mhl -form CleanFmt.mhl"
  a dn='rmm;next'
  a dp='rmm;prev'
  a mvm='refile'

  # This is a "move=folder" command.  It is safer than just renaming the directory.
  # If there is an existing directory (folder), then the source folder's contents
  # are moved into the destination folder, and then the source folder (which should
  # now be empty) is removed.

  mvf() { mvm -src $1 $2 all && rmf $1 ; }

  # This is a special=form of reply, with my own replcomp file.

  a ans='repl -filter Include.repl'

  a f='folder'
  a fs='folders'

  rmmsubj() { rmm `pick subj "$*"` ; }

  inbox() { scan +inbox last:30 ; }
  scanl() { scan $1 last:10 ; }
  fromme() { scan `pick $1 -from $USER -seq $USER -list` ; }

fi

#
# Pretty printing
#
  a ens='enscript'
  a ens8='ens -fCourier8'
  a ensw='ens -rG'
  a ensw8='ensw -fCourier8'
  a ens2w='ens -2rG'
#
# Rq & Req aliases
#
if [[ -d /usr/local/req ]]; then
  a rqt='rq :15'
  a rqun='rq -un'
  a rqut='rqun :15'
  a rqown='rq -owner'
  a rqhigh='rq -prio high'
  a rqme='rqown $USER'
  a rqmine='rqme'
  #
  rqs()     { req -show $1 | $PAGER ; }
  rqgive()  { req -give "$@" ; }
  rqtake()  { req -take "$@" ; }
  rqsubj()  { req -subject $1 "${@:2:$#}" ; }
  rqcomm()  { req -comment "$*" ; }
  rqprio()  { req -prio "$@" ; }
  rqprhi()  { rqprio $1 high ; }
  rqprlo()  { rqprio $1 low ; }
  rqsolv()  { req -resolve ; }
  rqstall() { req -stall ; }
  rqkill()  { req -kill ; }
  rqnew()   { req -create ; }
fi
#
# nslookup aliases
#
  a ns='nslookup'
  a nsany='ns -querytype=any'
  a nshinfo='ns -querytype=hinfo'
  a nsns='ns -querytype=ns'
  a nsptr='ns -querytype=ptr'
#
# Some handy working aliases
#
  a pmlib='cd ~/src/mail/procmail/procmail-lib; pwd; ls'
  a sllib='cd ~/src/mail/procmail/smartlist-lib; pwd; ls'

# PGP keys
  a pwds='pgpedit -s'

# Now, source two other sets of alises files, depending on the DOMAIN and WORKGROUP
# The alias files should have this naming pattern: .aliases.NAME.sh
# where NAME can be a domain name, workgroup name, or user name.

for sfx in "$DOMAIN" "$WORKGROUP" "$USER" ; do
  if [[ -n "$sfx" && -r ~/.aliases."$sfx".sh ]]; then
    source ~/.aliases."$sfx".sh
  fi
done

# alias to extract a line=from a flie
  # line NUM FILE
  # lines START LEN FILE
  line()  { tail +$1 "${@:2:$#}" ; }
  lines() { tail +$1 "${@:3:$#}" | head -$2 ; }

# ssh aliases
  ssh-unset() { eval `ssh-agent -s -k` ; }
  ssh-setup() { ssh-unset ; eval `ssh-agent -s`; ssh-add; ssh-add -l ; }

# resetpath
  a resetpath='export PATH=/opt/local/bin:/usr/local/bin:/bin:/sbin:/usr/bin:/usr/sbin:/sw/bin:/sw/sbin:/usr/local/etc:.:~/bin:~/lib'

# filesystem listings
# These cover all the myriad "ls" options

# mk_func NAME 'DEFINITION'
mk_func() { 
  name="${1:?'Missing function name'}"
  shift
  { alias $name 2>/dev/null 1>&2 ; } && unalias $name
  unset -f $name
  eval "$name() { $@ ; }"
}

# undefine this if ls doesn't support color
case `uname -s` in
Linux) LSCOLOR='--color=auto' ;;
*) LSCOLOR=
esac

mk_func ls   '/bin/ls -Fh $LSCOLOR "$@"'
mk_func ll   'ls -l  "$@"'
mk_func lf   'ls -F  "$@"'
mk_func lsl  'ls -l  "$@"'
mk_func lsa  'ls -a  "$@"'
mk_func lsad 'ls -ad "$@"'
mk_func lsd  'ls -d  "$@"'
mk_func lsf  'ls -f  "$@"'
mk_func lsg  'ls -lg "$@"'
mk_func lsr  'ls -R  "$@"'
mk_func lss  'ls -s  "$@"'
mk_func lst  'ls -lt "$@"'
mk_func lsu  'ls -lu "$@"'

mk_func m    'less "$@"'
mk_func more 'less "$@"'

# quit less on 2nd consecutive EOF, and quit if display is less than one screen
# -ef doesn't work on short files
# export LESS='-eF'

unset -f mk_func

lstop() { lst --color=always $* | head -${LSTLIMIT:-20} ; }

# t [directory] [ limit ] -- show <limit> "top" modified files
unset -f t
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

# use Meteor
alias mt=meteor
hash -p /usr/local/bin/meteor mt

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

# vim: set ai sw=2
# end of .aliases.sh
