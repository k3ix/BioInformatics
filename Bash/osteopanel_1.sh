#!/bin/bash
dir=$(cd $(dirname $0) && pwd)
ref=$1
proc=$2
#bowtie2-build $ref ref_index
samtools faidx $ref
python2 /home/yahor/anaconda3/bin/fasta_generate_regions.py $ref.fai 100000 > GRCh38_regions_freeb.regions
for i in $(ls */ -d)
do 
	mv $i $(echo $i | cut -d "-" -f1)
done
for k in $(ls */ -d)	
do
	cd $dir/$k
	name=$(pwd | rev | cut -d "/" -f1 | rev)
	name_short=$(pwd | rev | cut -d "/" -f1 | rev | cut -d "_" -f1)
	gunzip *.gz
	bowtie2 --local -p $proc -x $dir/ref38 -1 *R1_001.fastq -2 *R2_001.fastq | samtools view -@ $proc -bS | samtools sort -@ $proc -o ${name}_sorted.bam
	mkdir $dir/$name_short
	cp ${name}_sorted.bam $dir/$name_short
done
mkdir $dir/results
echo "works"
cd $dir
for j in $(ls */ -d | grep -v "_" | grep -v "results")
do
	echo $j
	cd $dir/$j
	name=$(pwd | rev | cut -d "/" -f1 | rev)
	samtools merge $name.bam *.bam
	samtools index -@ $proc ${name}.bam
	freebayes-parallel $dir/GRCh38_regions_freeb.regions $proc -f $ref ${name}.bam > $name.vcf
	bcftools filter -e 'QUAL<=20' $name".vcf" | bcftools filter -i 'FORMAT/DP>=8 & FORMAT/AO>=4' -o $name"_filtered.vcf"
	cp $name"_filtered.vcf" $dir/results	
done
	
#/home/yahor/OsteoPanel_input/FASTQ/GRCh38_genomic.fna



