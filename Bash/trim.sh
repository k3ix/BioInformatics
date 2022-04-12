#!/bin/bash
path=$(cd $(dirname $0) && pwd)
#for dir in $(ls */ -d)
#do
	#cd $path/$dir
	#fastqc *fastq
#done
#cd $path
#for dir1 in $(ls */ -d)
#do
	#cd $path/$dir1
	#sample_name=$(pwd | rev | cut -d "/" -f1 | rev | cut -d "_" -f1,2)
	#echo $sample_name
	#trimmomatic PE ${sample_name}_L001_R1_001.fastq ${sample_name}_L001_R2_001.fastq \
	#${sample_name}_1.fastq.gz ${sample_name}_1_unpaired.fastq.gz \
	#${sample_name}_2.fastq.gz  ${sample_name}_2_unpaired.fastq.gz \
	#SLIDINGWINDOW:4:20 MINLEN:25
#done
#cd $path

	
