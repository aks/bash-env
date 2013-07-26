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

<table>
 <tr>
  <th>Envar</th>
  <th>Source</th>
  <th>Meaning</th>
 </tr>
 <tr>
  <td><tt>USER</tt><br><tt>LOGNAME</tt></td>
  <td><tt>$LOGNAME</tt><br><tt>whoami</tt></td>
  <td>User currently logged in</td>
 </tr>
 <tr>
  <td><tt>OSTYPE</tt></td>
  <td><tt>uname -s</tt></td>
  <td>Operating System type name</td>
 </tr>
 <tr>
  <td><tt>OSREV</tt></td>
  <td><tt>uname -r</tt></td>
  <td>OS revision</td>
 </tr>
 <tr>
  <td><tt>MACHTYPE</tt></td>
  <td><tt>uname -m</tt></td>
  <td>Machine type</td>
 </tr>
 <tr>
  <td><tt>HOST</tt></td>
  <td><tt>uname -n</tt> <br/></tt>hostname</tt></td>
  <td>Host name</td>
 </tr>
 <tr>
  <td><tt>HOSTALASES</tt></td>
  <td><tt>~/.hostaliases</tt></td>
  <td>Host aliases list</td>
 </tr>
 <tr>
  <td><tt>ORGANIZATION</tt></td>
  <td><tt>~/.organization</tt></td>
  <td>&nbsp;</td>
 </tr>
 <tr>
  <td><tt>WORKGROUP</tt></td>
  <td><tt>~/.workgroup</tt><br/><tt>$ORGANIZATION</tt></td>
  <td>Company or organization name</td>
 </tr>
 <tr>
  <td><tt>DOMAIN</tt></td>
  <td><tt>~/.domain</tt> or end of <tt>uname -n</tt></td>
  <td>The local domain name</td>
 </tr>
</table>

<tt>DOMAIN</tt> and <tt>WORKGROUP</tt> both come after <tt>USER</tt> and
<tt>HOST</tt>, so that each of the latter can choose the former, respectively.

Only the files that actually exist are sourced.

After the files are sourced, the file <tt>~/.runenv</tt> can be examined
to see which files were actually sourced.


Functions Provided
------------------

This script provides the following functions to make writing the
sub-enviroinment scripts easier:

<tt>run_file FILE [RECORDFILE]</tt>

    source FILE if and only if it exists, if RECORDFILE is given,
    and if FILE is sourced without errors, then append FILE to the
    contents of RECORDFILE.
    
<tt>run_env  NAME</tt>

    If ~/.environment.NAME.sh exists, source it, and if it is
    sourced without errors, append its name to ~/.runenv

<tt>run_env_once NAME</tt>

    If ~/.environment.NAME.sh exists and has not already been
    sourced during this session, source it, and record the fact in
    ~/.runenv.

<tt>add_path VAR PATH</tt>

    Add PATH to the directory list in VAR if it's not already
    there.

<tt>add_paths VAR options LIST-OF-PATHS ..</tt>

    Like "add_path", all the directories in LIST-OF-PATHS are
    added to the VAR, using the $SETPATH script, or the "add_path"
    function above.

Author
------

Alan Stebbens <aks@stebbens.org>

vim: set ai sw=2 textwidth=66

