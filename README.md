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
example, if these files are stored in `~/lib` (aka `$HOME/lib`),
then the `PATH` environment variable should be set:

    export PATH=$PATH:$HOME/lib

Description:
------------

This script is meant to be invoked from `~/.bashrc` or
`~/.bash_login/`

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
systems in "dev.acme.com".  All of the work systems are linux
systems (except my laptop, which is MacOSX).

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
  <td>`.environment.acme.sh`</td>
  <td>Define variables for Acme.com</td>
 </tr>
 <tr>
  <td>`.enviromment.home.sh`</td>
  <td>Define variables for home systems</td>
 </tr>
 <tr>
  <td>`.enviromment.prod.acme.com.sh`</td>
  <td>Define variables for work production systems</td>
 </tr>
 <tr>
  <td>`.enviromment.qa.acme.com.sh`</td>
  <td>Define variables for work QA systems</td>
 </tr>
 <tr>
  <td>`.enviromment.dev.acme.com.sh`</td>
  <td>Define variables for work dev systems</td>
 </tr>
 <tr>
  <td>`.enviromment.darwin.sh`</td>
  <td>Define variables for Mac OS X systems</td>
 </tr>
 <tr>
  <td>`.enviromment.Ubuntu.sh`</td>
  <td>Define variables for Ubuntu systems</td>
 </tr>
 <tr>
  <td>`.environment.somewhere.sh`</td>
  <td>Define variables for work laptop</td>
 <tr>
 <tr>
  <td>`.environment.anywhere.sh`</td>
  <td>Define variables for home laptop</td>
 <tr>
  <td>`.enviromment.astebbens.sh`</td>
  <td>Define variables for user astebbens</td>
 </tr>
 <tr>
  <td>`.enviromment.aks.sh`</td>
  <td>Define variables for user aks</td>
 </tr>
</table>

Here is the sequence of files on a production work system:

    .environment.sh
    .environment.linux.sh
    .environment.astebbens.sh
    .environment.acme.sh
    .environment.prod.acme.com.sh

Here are the files sourced in the work dev environment:

    .environment.sh
    .environment.linux.sh
    .environment.astebbens.sh
    .environment.acme.sh
    .environment.dev.acme.com.sh

Here are the files sourced in on my work laptop:

    .environment.sh
    .environment.darwin.sh
    .environment.somewhere.sh
    .environment.astebbens.sh
    .environment.acme.sh
    .environment.dev.acme.com.sh

Here are the files sourced in on my home desktop:

    .environment.sh
    .environment.darwin.sh
    .environment.anywhere.sh
    .environment.aks.sh
    .environment.home.sh

The `.environment.sh` script does all the work of figuring out which
other files need to be sourced.

Environment Variables
---------------------

The following environment variables are set, possibly based
on the given sources.

<table>
 <tr>
  <th>Envar</th>
  <th>Source</th>
  <th>Meaning</th>
 </tr>
 <tr>
  <td>`USER`<br>`LOGNAME`</td>
  <td>`$LOGNAME`<br>`whoami`</td>
  <td>User currently logged in</td>
 </tr>
 <tr>
  <td>`OSTYPE`</td>
  <td>`uname -s`</td>
  <td>Operating System type name</td>
 </tr>
 <tr>
  <td>`OSREV`</td>
  <td>`uname -r`</td>
  <td>OS revision</td>
 </tr>
 <tr>
  <td>`MACHTYPE`</td>
  <td>`uname -m`</td>
  <td>Machine type</td>
 </tr>
 <tr>
  <td>`HOST`</td>
  <td>`uname -n` <br/>`hostname`</td>
  <td>Host name</td>
 </tr>
 <tr>
  <td>`HOSTALASES`</td>
  <td>`~/.hostaliases`</td>
  <td>Host aliases list</td>
 </tr>
 <tr>
  <td>`ORGANIZATION`</td>
  <td>`~/.organization`</td>
  <td>&nbsp;</td>
 </tr>
 <tr>
  <td>`WORKGROUP`</td>
  <td>`~/.workgroup`<br/>`$ORGANIZATION`</td>
  <td>Company or organization name</td>
 </tr>
 <tr>
  <td>`DOMAIN`</td>
  <td>`~/.domain` or end of `uname -n`</td>
  <td>The local domain name</td>
 </tr>
</table>

`DOMAIN` and `WORKGROUP` both come after `USER` and
`HOST`, so that each of the latter can choose the former, respectively.

Only the files that actually exist are sourced.

After the files are sourced, the file `~/.runenv` can be examined
to see which files were actually sourced.


Functions Provided
------------------

This script provides the following functions to make writing the
sub-enviroinment scripts easier:

    run_file FILE [RECORDFILE]

source FILE if and only if it exists, if `RECORDFILE` is given,
and if `FILE` is sourced without errors, then append FILE to the
contents of `RECORDFILE`.
    
    run_env  NAME

If `~/.environment.NAME.sh` exists, source it, and if it is
sourced without errors, append its name to `~/.runenv`

    run_env_once NAME

If `~/.environment.NAME.sh` exists and has not already been
sourced during this session, source it, and record the fact in
`~/.runenv`.

    add_path PATHVAR PATH

Add `DIR` to the directory list in `PATHVAR` if it's not already
there.

    add_path_first PATHVAR DIR

Add (or move) `DIR` to the front of the PATHVAR.

    add_paths PATHVAR options LIST-OF-DIRS ..

Like `add_path`, all the directories in `LIST-OF-DIRS` are
added to the `PATHVAR`, using the `$SETPATH` script, or the
`add_path` function above.

Author
------

Alan Stebbens <aks@stebbens.org>

vim: :set ai sw=2 textwidth=66

