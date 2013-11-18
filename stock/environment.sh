# .environment.sh
#
# source up a heirarchical environment
#
# source ~/.environment.sh
#
# First, some common, platform and host-independent 
# environment setups are done, then platform-specific
# and then host-specific environment files, if any, 
# are sourced.
#
# .environment.sh
#   .environment.x11.sh	      # special case
#   .environment.$OSTYPE.sh
#   .environment.$OSTYPE-$OSREV.sh
#   .environment.$MACHTYPE.sh
#   .environment.$HOST.sh
#   .environment.$USER.sh
#   .environment.$WORKGROUP.sh
#   .environment.$DOMAIN.sh	# for each name in $DOMAINS
#   .environment.term.sh      # special case
#
# By performing the more general files first, followed by the more specific
# files, exact control, with reasonable defaults can be achieved without
# duplicating setup code.  By having the user file last, the user can override
# anything to suit taste.
#
# Only the files that exist are sourced.
#
# This script provides the following functions to make writing the
# sub-enviroinment scripts easier:
#
# run_file FILE [RECORDFILE]
#
#   source FILE if and only if it exists, if RECORDFILE is given, and if FILE
#   is sourced without errors, then append FILE to the contents of RECORDFILE.
#     
# run_env  NAME
#
#   If ~/.environment.NAME.sh exists, source it, and if it is sourced without
#   errors, append its name to ~/.runenv
#
# run_env_once NAME
#
#   If ~/.environment.NAME.sh exists and has not already been sourced during
#   this session, source it, and record the fact in ~/.runenv.
#
# add_path PATHVAR DIR
#
#   Add DIR to the directory list in PATHVAR if it's not already there.
#
# add_path_first PATHVAR DIR
#
#   Add DIR to the front of the directory list in PATHVAR; if it's not already there.
#
# Alan Stebbens <aks@stebbens.org>
#
# Source other .environment.*.sh files in the proper order
#
# DOMAINNAME comes after HOST, and  WORKGROUP comes after USER, so that each of
# the latter can choose the former, respectively.
#

# if RCHOME is not defined, used the directory in which this script
# resides.

if [[ -z "$RCHOME" ]]; then
  export RCHOME=`cd $(dirname $0) ; pwd`
fi

run_file() {
  if [[ -f "$1" ]]; then
    source "$1"
    if [[ -n "$2" ]] ; then
      echo "$1" >> "$2"
    fi
  fi
}

run_env() {
  run_file $RCHOME/.environment."$1".sh $RCHOME/.runenv
}

run_env_once() {
  if ! grep -q "\.$1\." $RCHOME/.runenv ; then
    run_env "$1"
  fi
}

# $RCHOME/runenv will show which modules get sourced
cat /dev/null >$RCHOME/.runenv

# Setup environment variables
run_env_once envars

# The scripts sourced below can use "add_path" to add a new directory to a path
# variable
#
# add_path PATHVAR DIR
#
# Add DIR to PATHVAR but only if it's not already in the PATH, and only if DIR
# actually exists.
#
# Examples:
#
#   add_path MAN /usr/local/man 
#   add_path PATH /usr/local/bin

add_path() {
  if [[ -d "$2" ]]; then
    local val
    eval "val=\"\$$1\""
    if ! { echo "$val" | egrep -q "(^|:)$2(:|\$)" ; } ; then
      eval "export $1=\"$val:$2\""
    fi
  fi
}

# add_path_first PATHVAR DIR
#
# Put the DIR in the front of PATHVAR (but only if DIR actually exists)

add_path_first() {
  if [[ -d "$2" ]]; then
    eval "export $1=\"${2}:\$$1\""
  fi
}

# function to add lots of new items to paths

# add_paths PATHVAR opts PATHLIST
#
# This uses a program at $SETPATH to efficiently build the PATH-like envar, or,
# uses the "add_path" bash function above.
#
# PATHLIST is the name of an array containing a list of directories.

add_paths() {
  eval "local list=(\"\${$3[@]}\")"
  if [[ -n "$SETPATH" ]]; then
    eval `$SETPATH -s$2 $1 "${list[@]}"`
  else
    for dir in "${list[@]}" ; do
      add_path $1 "$dir"
    done
  fi
  unset $3
}

# this bit finds the "setpath" script

unset SETPATH
for dir in /usr/local/bin ~/bin ; do
  if [[ -x $dir/setpath ]] ; then
    export SETPATH=$dir/setpath
    break
  fi
done


# If this is an X11 display, and there is an init shell for it, source it
if [[ -n "$DISPLAY" ]] ; then
  run_env_once x11
fi

for var in OSTYPE CPUTYPE MACHTYPE HOST USER WORKGROUP DOMAINS ; do
  eval "vals=( \$$var )"
  for val in "${vals[@]}" ; do
    run_env_once "$val"
  done
done

run_env_once term

# end of .environment.sh

# vim: sw=2 ai
