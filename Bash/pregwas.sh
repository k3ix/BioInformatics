#!/bin/bash
dir=$(pwd)
proc=$1
mkdir $dir/pregwas
for p in Full_exome TSOne TSOne_Exp
do
	cd $dir/$p
	i=$(pwd | rev | cut -d "/" -f1 | rev)
	vcftools --vcf ${i}"_unfiltered.vcf" --remove-indels --recode --recode-INFO-all --stdout | bcftools filter -e 'QUAL<=20' | bcftools filter -i 'FORMAT/DP>=8' -o $i".vcf"
	bcftools annotate --threads $proc -x ID -I +'%CHROM:%POS:%REF:%ALT' -Ob $i".vcf" -o $i.rs.bcf $i.id.bcf
	mv ${i}.rs.bcf $dir/pregwas
done
cd $dir/pregwas
for f in $(ls | grep "bcf" | grep -v "csi")
do
	echo $f
	basename $f >> merge.list
	bcftools index $f --threads $proc
done
bcftools merge --threads $proc --force-samples -l merge.list -Oz -o  merged.vcf.gz
bcftools index merged.vcf.gz
bcftools index /storage/analysis/GWAS/rr/vcf/1000G_gwas/ALL.2of4intersection.20100804.genotypes.vcf.gz
bcftools isec --threads $proc -p dir merged.vcf.gz /storage/analysis/GWAS/rr/vcf/1000G_gwas/ALL.2of4intersection.20100804.genotypes.vcf.gz -Oz 

#/usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java -jar /storage/analysis/progs/gatk-4.1.1.0/gatk-package-4.1.1.0-local.jar HaplotypeCaller --native-pair-hmm-threads 8 -R /storage/analysis/Databases/Ref/GRCh37_only_chr.fna -L TruSeq_Exome_TargetedRegions_v1.2_withoutMT.bed -I Full_exome_bam.list -O Full_exome_unfiltered.vcf --tmp-dir /storage/analysis/exome_trios/tmp 


#/storage/analysis/GWAS/rr/vcf/1000G_gwas/ALL.2of4intersection.20100804.genotypes.vcf.gz

