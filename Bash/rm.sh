#!/bin/bash
dir=$(cd $(dirname $0) && pwd)
for i in $(ls */ -d)
do
	cd $dir/$i
	rm `ls | grep  ".vcf"`
done


#/home/yahor/2020-09%20Osteopanel%20190/OsteoPanel-199767570/FASTQ_Generation_2020-09-29_15_04_20Z-321042722/GRCh37_latest_genomic.fa



