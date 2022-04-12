#!/bin/bash
path=$(pwd)
proc=$1
bwa index glycine_max_chr_new.fasta
samtools faidx glycine_max_chr_new.fasta
/usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java -jar /storage/analysis/progs/gatk-4.1.1.0/gatk-package-4.1.1.0-local.jar CreateSequenceDictionary -R glycine_max_chr_new.fasta
mkdir results_chl_newRef
for dr in $(ls */ -d | grep -v "tmp" | grep -v "results")
do
	cd $path/$dr
	sm=$(pwd | rev | cut -d "/" -f1 | rev)
	fqnm=$(ls | grep "R1" | cut -d "_" -f1,2)
	echo $sm $fqnm
	bwa mem -t $proc $path/glycine_max_chr_new.fasta $fqnm"_L001_R1_001.fastq.gz" $fqnm"_L001_R2_001.fastq.gz" | samtools view -@ $proc -bS | samtools sort -@ $proc -o $sm"_chl_newRef_withot_RG.bam"
	/usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java -jar /storage/analysis/progs/gatk-4.1.1.0/gatk-package-4.1.1.0-local.jar AddOrReplaceReadGroups  -I $sm"_chl_newRef_withot_RG.bam" -O $sm"_chl_newRef.bam" -SORT_ORDER coordinate  --RGPL ILLUMINA --RGSM $sm --RGPU exome_seq --RGLB glycine_chl --TMP_DIR $path/tmp
	samtools index $sm"_chl_newRef.bam"
	/usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java -jar /storage/analysis/progs/gatk-4.1.1.0/gatk-package-4.1.1.0-local.jar HaplotypeCaller --native-pair-hmm-threads $proc -R $path/glycine_max_chr_new.fasta -I $sm"_chl_newRef.bam" -O $sm"_chl_newRef.vcf" --tmp-dir /storage/analysis/TTN/tmp
	bcftools filter -e 'QUAL<=20' $sm"_chl_newRef.vcf" | bcftools filter -i 'FORMAT/DP>=8' -o $sm"_chl_newRef_filtered.vcf"
	mv $sm"_chl_newRef_filtered.vcf" $path/results_chl_newRef	
done
