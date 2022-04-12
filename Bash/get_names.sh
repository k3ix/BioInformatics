#!/bin/bash
for i in $(ls */ -d)
do
	cd $i
	name=$(ls | grep -v "R1" | cut -d "_" -f1,2,3)
	echo $name
	cd ../
done


