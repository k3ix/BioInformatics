#!/bin/bash
dir=$1
cd $dir
mkdir $dir/analysis/fastqc
for p1 in $(ls */ -d | grep -v "analysis" | grep -v "anna_genomes")
do
	cd $dir/$p1
	path_name=$(pwd | rev | cut -d "/" -f1 | rev)
	echo $path_name
	mv *fastqc* $dir/analysis/fastqc
done
