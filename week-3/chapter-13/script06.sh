#!/bin/bash

for file in /mnt/c/Users/38762/Desktop2/Desktop/bilal-djedovic-devops-mentorship/*
do 
    if [ -d "$file" ]
    then 
        echo "$file is a directory"
    elif [ -f "$file" ]
    then
    echo "$file is a file"
    fi
done