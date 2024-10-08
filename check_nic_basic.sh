#!/bin/sh
# check_nic_basic plugin for Nagios
# Written by Udo Seidel
#
# Description:
#
# This plugin will perform 2 basic checks for a given NIC
#
# 
MYNIC=""
MYIP=""


# Nagios return codes
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
STATE_DEPENDENT=4

EXITSTATUS=$STATE_UNKNOWN #default


PROGNAME=`basename $0`

print_usage() {
	echo 
	echo " This plugin will perform 2 basic checks of a given NIC."
	echo 
	echo 
        echo " Usage: $PROGNAME -<h|n>"
        echo
        echo "   -n: NIC"
        echo "   -h: print this help"
	echo 
}

if [ "$#" -lt 1 ]; then
	print_usage
        EXITSTATUS=$STATE_UNKNOWN
        exit $EXITSTATUS
fi

check_nic()
{
ifconfig $1 > /dev/null 2>&1
if [ "$?" -ne 0 ]; then
	echo "CRITICAL - Interface $1 not found"
        EXITSTATUS=$STATE_CRITICAL
        exit $EXITSTATUS
else
	ifconfig $1 | grep UP > /dev/null 2>&1
	if [ "$?" -ne 0 ]; then
		echo "CRITICAL - Interface $1 is not up"
		EXITSTATUS=$STATE_CRITICAL
		exit $EXITSTATUS
	fi
	ifconfig $1 | grep -v inet6 | grep inet > /dev/null 2>&1
	if [ "$?" -ne 0 ]; then
		echo "WARNING - Interface $1 has no valid IP address"
		EXITSTATUS=$STATE_WARNING
		exit $EXITSTATUS
	else
		MYIP=`ifconfig $1 | grep -v inet6 | grep inet | awk '{print $2}'`
		echo "OK - Interface $1 is avaiable and has IP address $MYIP"
		EXITSTATUS=$STATE_OK
		exit $EXITSTATUS
	fi
fi
}

while getopts "hn" OPT
do		
	case "$OPT" in
	h)
		print_usage
		exit $STATE_UNKNOWN
		;;
	n)
		MYNIC=$2
		;;
	*)
		print_usage
		exit $STATE_UNKNOWN
	esac
done

check_nic $MYNIC
exit $EXITSTATUS
