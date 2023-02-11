#!/bin/bash

#here we give the 2 files to compare

#Say you wanna compare 2nd_file with 1st_file.
#1st file - default file
#2nd file - file that u wanna compare with the default file.

c=0
x=`pwd`
#echo $x
#echo " "

# Help Command
if [[ $1 = "-h" || $1 = "--help" ]]
then
	echo "[+] Syntax : ./compare-nd-match.sh [Default_file] [File_to_Match]"
	echo "[+] example : ./compare-nd-match.sh default.txt match.txt"
	exit 1
fi

# Check if two files have been provided as arguments
if [ $# -ne 2 ]
then
    echo "[-] Error: Two files must be provided as arguments."
    echo "[+] Usage: compare-nd-match.sh [file1] [file2]"
    echo "[+] Use --help or -h for more information."
    exit 1
fi

# Check if the files exist
if [ ! -f $1 ]
then
    echo "Error: File $1 does not exist."
    exit 1
fi

if [ ! -f $2 ]
then
    echo "Error: File $2 does not exist."
    exit 1
fi

# Copying the files to the current directory
echo "Current Working Directory : $x "

cp $1 $x/default.txt
cp $2 $x/match.txt


# Comparing file-2 with file-1
a=`cat $x/default.txt`
b=`cat $x/match.txt`

echo ""
echo "[+] Matching results......"
for lines in $a
do
	for check in $b
	do
		if [[ $check == $lines ]]
		then
			echo "[+] Match found in $2 : $check"
			c=$c+1
		else
			continue
		fi
				
	done
done

if [[ $c -eq 0 ]]
then
	echo "[-] No Matching Results on $2"
fi

rm $1 $x/default.txt
rm $2 $x/match.txt
