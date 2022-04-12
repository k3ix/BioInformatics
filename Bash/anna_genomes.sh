#!/bin/bash
dir=$1

cd $dir
#mkdir anna_genomes
#for p in $(ls */ -d)
#do
	#cd $dir/anna_genomes
	#mkdir $p
#done
for p1 in $(ls */ -d | grep -v "analysis" | grep -v "anna_genomes")
do
	cd $dir/$p1
	path_name=$(pwd | rev | cut -d "/" -f1 | rev)
	echo $path_name
	cp *.fasta $dir/anna_genomes/$path_name
	cp log* $dir/anna_genomes/$path_name
done
