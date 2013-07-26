# ~/.environment.x11.sh
# 
# Setup various XTERM envars if DISPLAY is set.
#
# $Header: /home/aks/RCS/.environment.x11.sh,v 1.1 2013/02/01 05:50:49 aks Exp $
#

# When using Xterm or XLterm, use the following XTERMinal
export XTERM=xterm

# set an envar XDISPLAY iff DISPLAY is set, and one of the terminal
# emulators is the TERM var.

unset XDISPLAY

if [[ -n "$DISPLAY" ]]; then
  #export XWMGR=tvtwm
  #export X_VIEWER=xv

  case "$TERM" in
      [xk]term|\
       aixterm|\
	exterm|\
	hpterm|\
       winterm|\
	  xwsh|\
     iris-ansi)
      export XDISPLAY=$TERM
      ;;
  esac

  case "$DISPLAY" in
             :[0-9]|\
 	     :[0-9].[0-9]|\
         unix:[0-9]|\
         unix:[0-9].[0-9]|\
        local:[0-9].[0-9]|\
    localhost:[0-9].[0-9])
	export DISPLAY=`echo $DISPLAY | sed -e "s/^.*:/${HOST}:/"`
	;;
  esac

fi

