#!/bin/bash
if [ -z "$1" ]
then
echo "Reference's path didn't find. Please enter path to the reference!"
exit
fi
ref=$1
proc=$2
dir=$(cd $(dirname $0) && pwd)
cd $dir/analysis
bowtie2-build $ref ref_index # индексирование референса
for r1 in $dir/data/*R1.fastq
do
	if [ -z "$r1" ]
	then
	echo "No fastq files."
	exit
	fi
	r2="${r1/R1/R2}"
	sam="${r1/.R1.fastq}"
	samf="${sam/data/analysis}"
	bowtie2 --local -p $proc -x ref_index -1 $r1 -2 $r2 -S $samf.sam # выравнивание ридов на референс
done
cd $dir/analysis
for dsam in *.sam
do
	bam="${dsam/.sam}"
	samtools view -@ $proc -bS $dsam > $dir/analysis/$bam.bam   # конвертация sam формата в bam
	rm -f $dsam  # удаление sam-файлов (т.к. могут много весить)
done
for bam2 in *.bam
do
	fbam="${bam2/.bam}"
	samtools sort -@ $proc $bam2 -o ${fbam}_sorted.bam # сортировка bam-файлов 
done
for sbam in *sorted.bam
do
	samtools index -@ $proc $sbam  # индексирование bam-файлов 
done
cd $dir
samtools faidx $ref    # индексирование референса для bcftools
cd $dir/analysis
for dbam in $dir/analysis/*sorted.bam
do
	vcf="${dbam/_sorted.bam}"
	bcftools mpileup --threads $proc $dbam -f $ref | bcftools call --threads $proc -mv -Ov -f GQ -o $vcf.vcf    # генерация vcf-файлов
done
for vcf in $dir/analysis/*.vcf
do
	ovcf="${vcf/.vcf}"
	ovcf2="${ovcf/analysis/results}"
	bcftools view --threads $proc -i 'DP>=10 && GQ>=15' $vcf > ${ovcf2}_filtered.vcf  # фильтрование vcf-файлов
done
cd $dir/results
bcftools mpileup --threads $proc $dir/analysis/1_sorted.bam $dir/analysis/2_sorted.bam $dir/analysis/3_sorted.bam $dir/analysis/4_sorted.bam $dir/analysis/5_sorted.bam -f $ref | bcftools call -mv -Ov -f GQ -o merged.vcf  # генерация общего vcf-файла


	
