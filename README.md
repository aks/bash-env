bash-env
========

Hierarchical, multi-workgroup, multi-system, distributable bash
environment.

Usage:
------

  ~/.bashrc:

    source ~/.environment.sh

If these bash-env files are kept in another directory, the
location needs to be named in the PATH environment variable.  For
example, if these files are stored in "~/lib" (aka "$HOME/lib"),
then the PATH environment variable should be set:

    export PATH=$PATH:$HOME/lib

Description:
------------

This script is meant to be invoked from "~/.bashrc" or
"~/.bash_login/"

First, the common platform and host-independent environment
setups are done, then platform-specific and then host-specific
environment files, if any, are sourced.

The list below represents the general order of the files being
sourced:

    .environment.sh
    .environment.envars.sh
    .environment.x11.sh		  # special case
    .environment.$OSTYPE.sh
    .environment.$OSTYPE-$OSREV.sh
    .environment.$MACHTYPE.sh
    .environment.$HOST.sh
    .environment.$USER.sh
    .environment.$WORKGROUP.sh
    .environment.$DOMAIN.sh	  # for each name in $DOMAINS
    .environment.term.sh	  # special case

By performing the more general files first, followed by the more
specific files, exact control, with reasonable defaults can be
achieved without duplicating setup code.  By having the user file
last, the user can override anything to suit taste.

The following environment variables are set, possibly based
on the given sources.

  Envar          Source                 Meaning
+--------------+----------------------+------------------------------+
| USER         | LOGNAME              | User currently logged in     |
| LOGNAME      | whoami               |                              |
|--------------+----------------------+------------------------------|
| OSTYPE       | uname -s             | Operating System type name   |
| OSREV        | uname -r             | OS revision                  |
| MACHTYPE     | uname -m             | Machine type                 |
|--------------+----------------------+------------------------------|
| HOST         | uname -n or hostname | Host name                    |
| HOSTALASES   | ~/.hostaliases       | Host aliases list            |
|--------------+----------------------+------------------------------|
| ORGANIZATION | ~/.organization      |                              |
|--------------+----------------------+------------------------------|
| WORKGROUP    | ~/.workgroup or      | Company or organization name |
|              | $ORGANIZATION        |                              |
|--------------+----------------------+------------------------------|
| DOMAIN       | ~/.domain or end of  |                              |
|              | uname -n             | The local domain name        |
+--------------+----------------------+------------------------------+

DOMAIN and WORKGROUP both come after USER and HOST, so that each
of the latter can choose the former, respectively.

Only the files that actually exist are sourced.

After the files are sourced, the file "~/.runenv" can be examined
to see which files were actually sourced.


Functions Provided
------------------

This script provides the following functions to make writing the
sub-enviroinment scripts easier:

  run_file FILE [RECORDFILE]

    source FILE if and only if it exists, if RECORDFILE is given,
    and if FILE is sourced without errors, then append FILE to the
    contents of RECORDFILE.
    
  run_env  NAME

    If ~/.environment.NAME.sh exists, source it, and if it is
    sourced without errors, append its name to ~/.runenv

  run_env_once NAME

    If ~/.environment.NAME.sh exists and has not already been
    sourced during this session, source it, and record the fact in
    ~/.runenv.

  add_path VAR PATH

    Add PATH to the directory list in VAR if it's not already
    there.

  add_paths VAR options LIST-OF-PATHS ..

    Like "add_path", all the directories in LIST-OF-PATHS are
    added to the VAR, using the $SETPATH script, or the "add_path"
    function above.

Author
------

Alan Stebbens <aks@stebbens.org>

vim: set ai sw=2 textwidth=66

