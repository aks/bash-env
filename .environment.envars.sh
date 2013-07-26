# .environment.envars.sh
#
# Setup the environment variables
#
# Alan K. Stebbens <aks@stebbens.org>
#
# The following environment variables are set, possibly based
# on the given sources.
#
# | Envar        | Source               | Meaning                      |
# |--------------+----------------------+------------------------------|
# | USER         | LOGNAME              | User currently logged in     |
# | LOGNAME      | whoami               |                              |
# |--------------+----------------------+------------------------------|
# | OSTYPE       | uname -s             | Operating System type name   |
# | OSREV        | uname -r             | OS revision                  |
# | MACHTYPE     | uname -m             | Machine type                 |
# |--------------+----------------------+------------------------------|
# | HOST         | uname -n or hostname | Host name                    |
# | HOSTALASES   | ~/.hostaliases       | Host aliases list            |
# |--------------+----------------------+------------------------------|
# | ORGANIZATION | ~/.organization      |                              |
# |--------------+----------------------+------------------------------|
# | WORKGROUP    | ~/.workgroup or      | Company or organization name |
# |              | $ORGANIZATION        |                              |
# |--------------+----------------------+------------------------------|
# | DOMAIN       | ~/.domain or end of  |                              |
# |              | uname -n             | The local domain name        |
# |--------------+----------------------+------------------------------|
#
#

# Set the USER or LOGNAME
if [[ -z "$USER" ]] ; then
  if [[ -z "$LOGNAME" ]]; then
    export LOGNAME=`whoami`
  fi
  export USER $LOGNAME
elif [[ -z "$LOGNAME" ]]; then
  export LOGNAME="$USER"
fi

if [[ -z "$HOME" ]]; then
  export HOME=`echo ~$USER`
fi

if [[ -z "$RCHOME" ]]; then
  mydir() {
    echo "$(dirname \"${BASH_SOURCE[0]}\")"
  }
  for dir in . "`mydir`" $HOME ; do
    if [[ -f "$dir/.environment.envars.sh" ]]; then
      export RCHOME="$dir"
      break
    fi
  done
fi
  

if [[ -z "$OSTYPE" ]]; then
  export OSTYPE="`uname -s`"
fi
if [[ -z "$OSREV" ]]; then
  export OSREV="`uname -r`"
fi
if [[ -z "$MACHTYPE" ]]; then
  export MACHTYPE="`uname -m`"
fi

if [[ -z "$HOST" ]]; then
  export HOST=`(uname -n || hostname) 2>/dev/null`
fi

# get plain hostname
if [[ "$HOST" == *.* ]]; then
  export HOST=`echo "$HOST" | sed -e 's/\..*//'`
fi

if [[ -z "$HOSTALIASES" ]]; then
  if [[ -f $RCHOME/.hostaliases ]] ; then
    export HOSTALIASES=$RCHOME/.hostaliases
  fi
fi

if [[ -z "$ORGANIZATION" ]]; then
  if [[ -f $RCHOME/.organization ]] ; then
    export ORGANIZATION=$(< $RCHOME/.organization )
  fi
fi

# set a couple of defaults
if [[ -z "$WORKGROUP" ]]; then
  if [[ -f $RCHOME/.workgroup ]]; then
    export WORKGROUP=$(< $RCHOME/.workgroup )
  else
    export WORKGROUP=none
  fi
fi

if [[ -z "$DOMAINNAME" ]]; then
  if [[ -f "$RCHOME/.domain" ]]; then
    export DOMAINNAME=$(< $RCHOME/.domain )
  elif [[ $(uname -n) =~ \. ]]; then
    export DOMAINNAME=$( uname -n | sed -e 's/^[^.]+\.//' )
  else
    export DOMAINNAME=none
  fi
fi

export DOMAINS=()

# vim: sw=2 ai
