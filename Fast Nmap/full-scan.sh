#!/bin/bash

# Help Command
if [[ $1 == "-h" || $1 == "--help" ]]
then
	echo ""
	echo "[+] Syntax: full-scan [victim_IP] [open_PORTs]"
	echo ""
	exit 1
fi


# Check if the argument has been provided as arguments
if [ $# -ne 2 ]
then
    echo "[-] Provide an IP Address and PORTs in that order, as argument."
    echo "[+] Example full-scan [victim_IP] [open_PORTs]"
    exit 1
fi


# Requirements
pd=`pwd`
ip=$1
ports=$2


# ************************* Executing the Command ************************* #
read -p 'Do you want to skip Host Discovery[y/n] : ' host_d

# Checking if the Directory Exists
if [ ! -d $pd/nmap ]
then
	echo ""
	echo "[+] Directory does not exist, Creating $pd/nmap"
	mkdir $pd/nmap
fi

echo ""
echo "************************* Starting Scan ************************* "
if [ "$host_d" == "y" ]
then
	echo ""
	echo "nmap -Pn -A -T4 -vv -p $ports -oA nmap/full-scan $ip"
	nmap -Pn -A -T4 -vv -p $ports -oA nmap/full-scan $ip
	echo ""

elif [ "$host_d" == "n" ]
then
	echo ""
	echo "nmap -Pn -A -T4 -vv -p $ports -oA nmap/full-scan $ip"
	nmap -A -T4 -vv -p $ports -oA nmap/full-scan $ip
	echo ""

else
	echo ""
	echo "nmap -Pn -A -T4 -vv -p $ports -oA nmap/full-scan $ip"
	nmap -A -T4 -vv -p $ports -oA nmap/full-scan $ip
	echo ""
fi

echo "[+] Scanning Completed!............"

