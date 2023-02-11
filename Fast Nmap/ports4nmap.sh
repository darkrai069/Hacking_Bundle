#!/bin/bash

# Check if the file has been provided as arguments
if [ $# -ne 1 ]
then
    echo "Error: A file must be provided as arguments."
    exit 1
fi

# Check if the file exist
if [ ! -f $1 ]
then
    echo "Error: File $1 does not exist."
    exit 1
fi

cat $1 | grep syn-ack | grep tcp | awk -F/ '{ print $1 }' | tr '\n' ',' | sed 's/,$/\n/'
