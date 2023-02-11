#!/usr/bin/env bash

# The script searches for the name of the files in the "names.txt" file.
# Then it copies the files in the current directory.

# Steps to do before running the script
#	1. Change to the required directory
#	2. Save the names of the files into a file and save it as "names.txt".
#	3. RUN THE SCRIPT and WAIT !!!!!!!!!

val=$(cat names.txt | wc -l)

names=()
count=1

for i in `seq 0 $((val-1))`
do
        enter_name=$(cat names.txt| head -$count | tail -1)
        #echo $enter_name

        names[$i]=$enter_name

        count=$((count+1))

done
echo ""
echo "[+] List of Files to search : ${names[@]}"
#echo ${names[@]}
sleep 3
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "

c=1
for i in ${names[*]}
do
	echo ""
        echo "[+] Searching file : $i"
	#echo $i
        finding=$(find / -type f -name $i 2>/dev/null)
        sleep 3

	echo " "
	echo "[+] Result of search : $finding"
        #echo $finding

	echo ""
        echo "[+] File no.$c Copiying !!!"
        cp  $finding $PWD 2>/dev/null

        c=$((c+1))

	echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
	sleep 2

done
final=$((c-1))
echo ""
echo "[+] Total $final files copied to : $PWD"
echo "[+} ********** FINISHED **********"