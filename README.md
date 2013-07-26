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

Let's describe some uses.

I have computers at both work and home. There are some production
systems on which I have accounts, some QA hosts, some development
systems, including my work laptop.  My home systems include a
couple of Mac OS X systems, an Unbuntu system, and a Mac OS X
laptop.

I would like to have as uniform an environment as possible, but
each system, or each group of systems will have some unique
environments.

The following is a hierarchical set of environments, centrally
managed, distributed across all the hosts.  Even though some of
the environment files are not needed on some hosts, it is easier
to manage if all the files are distributed to all the hosts on
which I have access.

First, I'll setup two "workgroup" environemnts, one for work, and
one for home.  My "home" workgroup is called "Home". My work
workgroup is a hypothetical company called "Acme.com", and we'll
call the workgroup "acme".

The group of work production systems live in the subdomain of
"prod.acme.com", the QA systems in "qa.acme.com", and the dev
systems in "dev.acme.com".

My user id on the work systems is "astebbens", while my user id on
the home systems is "aks".

My work personal laptop is called "somewhere", and my home desktop
system is called "anywhere".

Here are the files that can be created to property configure
environments appropriate to each combination of user, workgroup,
and system.

<table>
 <tr> 
  <th>Filename</th>
  <th>Purpose</th> </tr>
 <tr> 
  <td>.environment.acme.sh</td>
  <td>Define variables for Acme.com</td>
 </tr>
 <tr>
  <td>.envriomment.home.sh</td>
  <td>Define variables for home systems</td>
 </tr>
 <tr>
  <td>.envriomment.prod.acme.com.sh</td>
  <td>Define variables for work production systems</td>
 </tr>
 <tr>
  <td>.envriomment.qa.acme.com.sh</td>
  <td>Define variables for work QA systems</td>
 </tr>
 <tr>
  <td>.envriomment.dev.acme.com.sh</td>
  <td>Define variables for work dev systems</td>
 </tr>
 <tr>
  <td>.envriomment.darwin.sh</td>
  <td>Define variables for Mac OS X systems</td>
 </tr>
 <tr>
  <td>.envriomment.Ubuntu.sh</td>
  <td>Define variables for Ubuntu systems</td>
 </tr>
 <tr>
  <td>.environment.somewhere.sh</td>
  <td>Define variables for work laptop</td>
 <tr>
 <tr>
  <td>.environment.anywhere.sh</td>
  <td>Define variables for home laptop</td>
 <tr>
  <td>.envriomment.astebbens.sh</td>
  <td>Define variables for user astebbens</td>
 </tr>
 <tr>
  <td>.envriomment.aks.sh</td>
  <td>Define variables for user aks</td>
 </tr>
</table>

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

vim: :set ai sw=2 textwidth=66

