#!/bin/bash
#iterating through multiple directories

for file in /mnt/c/Users/38762/Desktop2/Desktop/bilal-djedovic-devops-mentorship/* /mnt/c/Users/38762/Desktop2/Desktop/bilal-djedovic-devops-mentorship/nesto
do
    if [ -d "$file" ]
    then 
    echo "$file is a driectory"
    elif [ -f "$file" ]
    then
    echo "$file is a file"
    else
    echo "$file doesn't exist"
    fi
done
