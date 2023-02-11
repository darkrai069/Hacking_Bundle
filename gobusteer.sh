#!/bin/bash

if [[ $1 = "-h" || $1 = "--help" ]]
then
	echo "[+] Syntax : ./gobusteer.sh [Host_Name] [dir_name] [threads]"
	echo "[+] example : ./gobusteer.sh 10.10.10.44/posts m 100 "
	echo "[+] example : ./gobusteer.sh 10.10.10.44/posts b 100 "
	exit
fi

medium="/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt"
big="/home/anonymous/Documents/hacking_TOOL-KIT/wordlists/big.txt"

if [[ $2 == "m" ]]
then
	word=$medium
elif [[ $2 = "b" ]]
then
	word=$big
fi


echo "[+] Starting Gobuster Directory Enumeration!!!!"
echo " "
echo "Host : $1"
echo "Dir : $word"
echo " "

if [ $# -eq 3 ]
then
	gobuster dir -u http://$1 -w $word -t $3 | tee dir_enum.txt
elif [ $# -ne 3 ]
then
	echo "[-] Incorrect Syntax; Use -h or --help to get the correct syntax"
	exit
fi

echo " [+] Completed!!! "
