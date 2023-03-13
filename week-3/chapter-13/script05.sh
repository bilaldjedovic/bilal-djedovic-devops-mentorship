#!/bin/bash
# reading values from a file

file="towns"

for town in $(cat $file)
do 
    echo "Visit beautiful $town"
done
