#!/bin/bash
# using a variable to hold the list

list="London  Malmo Helsinki Goražde"
list=$list" Sarajevo"

for town in $list
do 
    echo "Have you ever visited $town?"
done