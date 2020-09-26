#!/bin/bash
a=$(head -1 ae.ref | awk'{print $2}')
for i in $a;
do
 my_array="${my_array[@]}" $i
done 
