#!/bin/bash
#set -x
# HEADER
###################################################################################################
# Author        : Robert McKenzie <rmckenzi@rpmdp.com>
# Script Name   : picam-timelapse.sh
# Description   : This script is designed to automate making time lapse photos using the
#		: Raspberry Pi with the Raspberry Pi Camera attached.
#
# Revision      : $Revision: 1.3 $
# Version       : $Header: /home/rmckenzi/Dropbox/sourcecode/RCS/picam-timelapse.sh,v 1.3 2013/08/29 22:42:10 rmckenzi Exp $
#
###################################################################################################

# Set this to the root path of where you will store images, a new folder $SUBJECT will be created here
# ie: /media/bigUSBhdd/timelapse/
CAPPATH=/tmp/

# Add / Remove any options you want here, however don't add -h or -v to sizes, thats done later in the script,
# the output and capture timings will also be added later (-o, -t and -tl)
CAMOPS=" -sh 100 -awb auto -ex auto -q 100 -vf "

# These don't need to be edited

VARCOUNT=3	# Minimum number of cmdline args to work
SUBJECT=$1
RUNTIME=$2
CAPTIME=$3
CAPSIZE=$4

# This variable used to calculate timings for raspistill
TIMEBASE=1000

function capture
{
	echo "Capturing... "

	cd $CAPPATH

	if [ -d "$SUBJECT" ]; then
		echo &> /dev/null
	else
		mkdir $SUBJECT
	fi

	cd $SUBJECT

	raspistill $CAMOPS $IMAGESIZE -o $SUBJECT-%09d.jpg -t $CRUNTIME -tl $CCAPTIME

}

function setsize
{

	echo "Setting image size..."
	echo
	if [ "$CAPSIZE" = "" ]; then
		CAPSIZE=1
	fi
	case "$CAPSIZE" in
		"1" )
			IMAGESIZE=" -h 2592 -w 1944 "
			ISPACE="2400"
		;;
		"2" )
			IMAGESIZE=" -h 1944 -w 2592 "
			ISPACE="2800"
		;;
		"3" )
			IMAGESIZE=" -h 1600 -w 1200 "
			ISPACE="1200"
		;;
		"4" )
			IMAGESIZE=" -h 1200 -w 1600 "
			ISPACE="1300"
		;;
		"5" )
			IMAGESIZE=" -h 1024 -w 768 "
			ISPACE="580"
		;;
		"6" )
			IMAGESIZE=" -h 768 -w 1024 "
			ISPACE="540"
		;;
		"7" )
			IMAGESIZE=" -h 800 -w 600 "
			ISPACE="350"
		;;
		"8" )
			IMAGESIZE=" -h 600 -w 800 "
			ISPACE="360"
		;;
		* )
			CAPSIZE=1
			setsize
		;;
	esac
	echo ""

}

function textout
{

	echo
	echo "Working dir: $CAPPATH/$SUJECT "
	echo
	echo "SUBJECT: $SUBJECT"
	echo "RUNTIME: $RUNTIME (seconds)"
	echo "CRUNTIME: $CRUNTIME (ms)"
	echo "CAPTIME: $CAPTIME (seconds)"
	echo "CCAPTIME: $CCAPTIME (ms)"
	echo
	echo "Image size: $IMAGESIZE"
	echo 
	echo "Number of photos to be: $CAPNUM"
	echo "Estimate disk space of capture run: $DSPACE meg"
	echo

}

function help
{

	echo "You need to provide at least $VARCOUNT command line variables for this script."
	echo
	echo "ARG1 = Subject - The subject of the time lapse (no spaces allowed), ie: flytrap"
	echo "ARG2 = Runtime - In seconds, how long to capture for? ie: 100 (seconds)"
	echo "ARG3 = Captime - In seconds (or parts of) when to capture, ie: 0.2 (200ms)"
	echo
	echo "Optional, if not specified Full Landscape will be used"
	echo
	echo "ARG4 = CapSize - Size of the image you want to capture, pick from these"
	echo
	echo "	1 - Full	- Landscape	(2592 H x 1944 W)"
	echo "	2 - Full	- Portrait	(1944 H x 2592 W)"
	echo "	3 - Large	- Landscape	(1600 H x 1200 W)"
	echo "	4 - Large	- Portrait	(1200 H x 1600 W)"
	echo "	5 - Medium	- Landscape	(1024 H x 768 W)"
	echo "	6 - Medium	- Portrait	(768 H x 1024 W)"
	echo "	7 - Small	- Landscape	(800 H x 600 W)"
	echo "	8 - Small	- Portrait	(600 H x 800 W)"
	echo
	echo "If you want to only capture 1 image use 1 and 1 for ARG 2 and 3, ie:"
	echo "  $0 mysubject 1 1"
	echo
	exit 1

}


if [ "$CAPTIME" = "" ]; then
	help
fi

setsize

CRUNTIME=$((RUNTIME * TIMEBASE))
CCAPTIME=`echo "$CAPTIME * $TIMEBASE" | bc`
CAPNUM=`echo "$CRUNTIME / $CCAPTIME" | bc`
DSPACE=`echo "($CAPNUM * $ISPACE) / 1024" | bc`

textout
capture


# FOOTER
###################################################################################################
#
# RCS Log
#
# $Log: picam-timelapse.sh,v $
# Revision 1.3  2013/08/29 22:42:10  rmckenzi
# Updated CAPPATH for public release
#
# Revision 1.2  2013/08/29 22:37:01  rmckenzi
# Fixed the help messages.
#
# Revision 1.1  2013/08/29 22:03:09  rmckenzi
# Initial revision
#
# Revision 1.2  2013/08/29 21:28:28  rmckenzi
# Fixed VARCOUNT to the correct number.
#
# Revision 1.1  2013/08/29 21:25:19  rmckenzi
# Initial revision
#
#
###################################################################################################

