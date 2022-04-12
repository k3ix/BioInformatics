#!/bin/bash
dir=$(cd $(dirname $0) && pwd)
ref=$1
proc=$2
#bowtie2-build $ref ref_index
samtools faidx $ref
python2 /home/yahor/anaconda3/bin/fasta_generate_regions.py $ref.fai 100000 > GRCh37_regions_freeb.regions
mkdir $dir/results
for i in $(ls */ -d)
do
	cd $dir/$i
	name=$(ls | grep -v "R1" | cut -d "_" -f1,2,3)
	gunzip *.gz
	bowtie2 --local -p $proc -x $dir/ref_index -1 *R1_001.fastq -2 *R2_001.fastq | samtools view -@ $proc -bS | samtools sort -@ $proc -o ${name}_sorted.bam
	samtools index -@ $proc ${name}_sorted.bam
	freebayes-parallel $dir/GRCh37_regions_freeb.regions $proc -f $ref ${name}_sorted.bam > $name.vcf
	bcftools filter -e 'QUAL<=20' $name".vcf" | bcftools filter -i 'FORMAT/DP>=8 & FORMAT/AO>=4' -o $name"_filtered.vcf"
	cp $name"_filtered.vcf" $dir/results
done


#/home/yahor/2020-09%20Osteopanel%20190/OsteoPanel-199767570/FASTQ_Generation_2020-09-29_15_04_20Z-321042722/GRCh37_latest_genomic.fa



