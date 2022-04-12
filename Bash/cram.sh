#!/bin/bash
file="/home/yegor/scripts/ceuuu.txt"
while IFS= read -r line
do
	IFS=' ' read -r -a array <<< "$line"
	echo ${array[0]} >> CEU_crams.txt
done < $file
