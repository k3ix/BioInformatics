#!/bin/bash
dir=$1
ref_dir=$2
ref=$3
proc=$4
cd $dir
#mkdir results
#python2 /home/yahor/anaconda3/bin/fasta_generate_regions.py $ref.fai 100000 > $ref_dir/GRCh37_by_hand_regions_freeb.regions
#for dr in $(ls */ -d | grep -v "Stats" | grep -v "results" | grep -v "kam" | grep -v "osp1" | grep -v "osp3" | grep -v "osp13" | grep -v "osp18" | grep -v "osp20" | grep -v "osp22" | grep -v "osp250" | grep -v "osp1003" | grep -v "osp1006" | grep -v "osp1010" | grep -v "osp1011" | grep -v "osp1013" | grep -v "osp1017" | grep -v "osp1057" | grep -v "osp1063" | grep -v "osp1117" | grep -v "osp1149" | grep -v "osp1155" | grep -v "osp1159" | grep -v "osp4" | grep -v "osp40" | grep -v "osp41" | grep -v "osp44" | grep -v "osp45" | grep -v "osp55" | grep -v "osp60" | grep -v "osp421" | grep -v "osp430" | grep -v "osp447" | grep -v "osp510" | grep -v "osp531" | grep -v "osp546" | grep -v "osp554" | grep -v "osp566" | grep -v "osp595" | grep -v "osp617" | grep -v "osp618" | grep -v "osp752" | grep -v "osp754" | grep -v "osp769" | grep -v "osp770" | grep -v "osp772" | grep -v "osp776" | grep -v "osp778" | grep -v "osp783" | grep -v "osp784" | grep -v "osp786" | grep -v "osp839" | grep -v "osp849" | grep -v "osp857" | grep -v "osp863" | grep -v "osp865" | grep -v "osp873" | grep -v "osp874" | grep -v "osp887" | grep -v "osp890" | grep -v "osp892" | grep -v "osp894" | grep -v "Undetermined" | grep -v "osp9" | grep -v "osp905" | grep -v "osp913" | grep -v "osp915" | grep -v "osp917" | grep -v "osp921" | grep -v "osp925" | grep -v "osp926" | grep -v "osp927" | grep -v "osp928" | grep -v "osp932" | grep -v "osp933" | grep -v "osp940" | grep -v "osp944" | grep -v "osp948" | grep -v "osp949" | grep -v "osp952" | grep -v "osp953" | grep -v "osp956" | grep -v "osp957" | grep -v "osp962" | grep -v "osp965")
for dr in osp30 osp36 osp38 osp350 osp355 osp367 osp378
do
	cd $dir/$dr
	for fq in $(ls | grep "R1")
	do
		echo $fq
		name_align=$(basename $fq | cut -d "_" -f1,2,3)
		bowtie2 --local -p $proc -x $ref_dir/GRCh37_by_hand -1 $fq -2 "${name_align}_R2_001.fastq.gz" | samtools view -@ $proc -bS | samtools sort -@ $proc -o "${name_align}_sorted.bam"
	done
	name_sample=$(pwd | rev | cut -d "/" -f1 | rev | cut -d "_" -f1)
	samtools merge -@ $proc "${name_sample}.bam" *.bam && samtools sort -@ $proc "${name_sample}.bam" -o "${name_sample}.s.bam"
	samtools index -@ $proc "${name_sample}.s.bam"
	#freebayes-parallel $ref_dir/GRCh37_by_hand_regions_freeb.regions $proc -f $ref "${name_sample}.s.bam" > "${name_sample}.vcf"
	#bcftools filter -e 'QUAL<=20' "${name_sample}.vcf" | bcftools filter -i 'FORMAT/DP>=8 & FORMAT/AO>=4' -o "${name_sample}_filtered.vcf"
	#cp "${name_sample}_filtered.vcf" $dir/results
	cp "${name_sample}.s.bam" /home/yahor/osteo_analysis/bams
done

#/home/yahor/Osteopanel2/Fastq
#/home/yahor/Data/Ref

