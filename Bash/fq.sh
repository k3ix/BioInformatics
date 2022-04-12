#!/bin/bash
dir=$(cd $(dirname $0) && pwd)
proc=$1
#for fqgz in $(ls | grep -v "sh" | grep -v "txt")
#do
	#mkdir $(basename $fqgz | cut -d "_" -f1,2) 
	#mv $fqgz /home/yahor/Fastq/"$(basename $fqgz | cut -d "_" -f1,2)"
#done
#bowtie2-build chloroplast.fasta chlor_index
#bowtie2-build mito.fasta mito_index
#samtools faidx $dir/chloroplast.fasta
#samtools faidx $dir/mito.fasta
#python2 /home/yahor/anaconda3/bin/fasta_generate_regions.py $dir/chloroplast.fasta.fai 25000 > chlor_freeb.regions
#python2 /home/yahor/anaconda3/bin/fasta_generate_regions.py $dir/mito.fasta.fai 50000 > mito_freeb.regions
for d in #$(ls */ -d)
do
	cd $dir/$d
	name=$(pwd | rev | cut -d "/" -f1 | rev)
	echo $name
	bowtie2 --local -p $proc -x $dir/chlor_index -1 *_1.fastq.gz -2 *_2.fastq.gz | samtools view -@ $proc -bS | samtools sort -@ $proc -o ${name}_chlor.bam
	bowtie2 --local -p $proc -x $dir/mito_index -1 *_1.fastq.gz -2 *_2.fastq.gz | samtools view -@ $proc -bS | samtools sort -@ $proc -o ${name}_mito.bam
done
#cd $dir
#for j in $(ls */ -d)
#do
	#cd $dir/$j
	#name=$(pwd | rev | cut -d "/" -f1 | rev)
	#samtools index -@ $proc ${name}_chlor.bam
	#samtools index -@ $proc ${name}_mito.bam
	#freebayes-parallel $dir/chlor_freeb.regions $proc -f $dir/chloroplast.fasta \
	#${name}_chlor.bam > ${name}_chlor.vcf
	#freebayes-parallel $dir/mito_freeb.regions $proc -f $dir/mito.fasta \
	#${name}_mito.bam > ${name}_mito.vcf
	#freebayes -f $ref ${name}.bam > $name.vcf
	#bcftools filter -e 'QUAL<=20' $name"_chlor.vcf" | bcftools filter -i 'FORMAT/DP>=8 & FORMAT/AO>=4' -o $name"_chlor_filtered.vcf"
	#bcftools filter -e 'QUAL<=20' $name"_mito.vcf" | bcftools filter -i 'FORMAT/DP>=8 & FORMAT/AO>=4' -o $name"_mito_filtered.vcf"	
#done

#/home/yahor/Fastq/chloroplast.fasta
#/home/yahor/Fastq/mito.fasta


