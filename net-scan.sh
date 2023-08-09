#!/bin/bash

#specify color for echo output
Red='\033[0;31m'
BRed='\033[1;31m'
Green='\033[0;32m'
BGreen='\033[1;32m'
Color_Off='\033[0m'

#check for argument
if [[ $# -lt 1 ]];then
        printf "${BRed}[-] Please specify a range of ip's${Color_Off}\n"
        printf "[+] example '192.168.1.0/24'\n"
	printf "[+] example '192.168.1.1-100'\n"
        exit 1 #exit the script
fi

#some constant variables
RPATH='scan_results'

check_rpath(){
#check for scannetwork dir
printf "${Green}[+] check if $RPATH exists ${Color_Off}\n"
if [ ! -d $RPATH ]; then
	printf "${Red}[-] $RPATH directory not present yet.${Color_Off}\n"
	mkdir $RPATH
	printf "${Green}[+] now it is :)${Color_Off}\n"
fi

#check if scannetwork subdir exists to store our results
if [ ! -d $RPATH/$1 ]; then
	printf "[-] $RPATH/$1 directory not present yet.\n"
	printf "[+] making directory right now\n"
	mkdir $RPATH/$1
fi
}

get_allhosts(){
#ping sweep all network for alive hosts
printf "[+] Sweeping Network...\n"
nmap -sn $1 | grep "report" | cut -d" " -f 5 > ips.txt
}

print_allhosts(){
#print live hosts
for host in $(cat ips.txt); do
	printf "${Green}[+] Alive host on IP: ${BGreen}$host${Color_Off}\n"
done
}

scan_allhosts(){
#full port scan on all alive hosts
printf "[+] scanning all hosts alive...\n"
for ip in $(cat ips.txt); do
    printf "[+] scanning for open ports on host $ip\n"
    if [ ! -d $RPATH/$1/$ip ]; then
	    mkdir $RPATH/$1/$ip
    fi
    nmap -p- -Pn $ip > $RPATH/$1/$ip/$ip
done
printf "[+] full port scan has been performed on all alive hosts\n"
printf "[+] time for detailed scan...\n"
for ip in $( ls $RPATH/$1/ | cut -d"." -f1,2,3,4); do
	printf "\n${Red}============================================\n${Color_Off}"
    printf "${Green}[+] scanning for ip $ip:\n${Color_Off}"
	printf "${Red}============================================\n\n${Color_Off}"
	#saving all ports into a file for later use
    for port in $(cat $RPATH/$1/$ip/$ip | grep "/tcp" | cut -d"/" -f1); do
		echo "$port" >> $RPATH/$1/$ip/ports
    done
    printf "\n"
    #here is the later use :)
	nmap -sC -sV -p$(cat $RPATH/$1/$ip/ports | tr "\n" ", ") $ip -oN $RPATH/$1/$ip/$ip.full >/dev/null
	cat $RPATH/$1/$ip/$ip.full
	printf "\n"
done
}

check_rpath
get_allhosts $1
print_allhosts
scan_allhosts

printf "${BGreen}[+] The script has finished!${Color_Off}\n"
printf "${Green}Results can be checked in each Directory in $RPATH/$1/\n"
exit 1
