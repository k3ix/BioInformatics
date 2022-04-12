#!/bin/bash
#echo "USAGE_FROM_ROMASHKA: ./run_bowtie2.sh path/to/references/dir path/to/index/dir path/to/stat/dir path/to/reads/dir CPU_number(int)"
reads=$1
ref_folder=$2
ref_name=$3
cpu=$4
cd $reads
#mkdir $reads/analysis/finally_vcfs
#java -jar /home/yahor/Soft/picard/build/libs/picard.jar NormalizeFasta \
      #I=$ref_folder/Saski_haruna.fasta \
      #O=$ref_folder/Saski_haruna_norm.fasta
#Если не обрабатывать Trimmomatic, то нужно менять расширения для bowtie2 c .fq на .fastq!
bowtie2-build $ref_folder/$ref_name $ref_folder/${ref_name}_index
for path in 1a_S5 2a_S6 #$(ls */ -d | grep -v "analysis" | grep -v "10_S18")
do
	cd $reads/$path
	n=$(pwd | rev | cut -d "/" -f1 | rev)
	echo $n
	bowtie2 -p $cpu \
	-x $ref_folder/${ref_name}_index \
	-1 ${n}_1.fastq.gz \
	-2 ${n}_2.fastq.gz \
	-S paired_trit.${n}.sam &> bowtie.log

	echo "take your sam for paired reads" 

#/home/manager/Documents/BI_soft/bowtie2-2.3.3/bowtie2 -p2 \
#-x /media/sf_biolinux_folder/Anya_Hordeum/2020_Hordeum/data_Danya/index.plastid_mt_norm_names \
#-U /media/sf_biolinux_folder/NGS_data_january_2020/trimmed/${n}.R1.unpaired.fastq.gz \
#-U /media/sf_biolinux_folder/NGS_data_january_2020/trimmed/${n}.R1.unpaired.fastq.gz \
#-S unpaired.${n}.sam



	for r in paired_trit #unpaired 
	do 
		samtools view ${r}.${n}.sam -o ${r}.${n}.bam
		samtools sort ${r}.${n}.bam -o ${r}.${n}.s.bam
		samtools index ${r}.${n}.s.bam
		samtools rmdup -S ${r}.${n}.s.bam ${r}.${n}.rmd.bam
		samtools sort ${r}.${n}.rmd.bam -o ${r}.${n}.rmd.s.bam
		samtools index ${r}.${n}.rmd.s.bam

#samtools depth ${r}.${n}.rmd.s.bam | awk '{sum+=$3} END { print "Average cov '${n}.merged' = ",sum/NR}' >> /media/sf_biolinux_folder/Anya_Hordeum/2020_Hordeum/assembly_2020/on_danyas_ref_without_merging/depth.txt

		samtools mpileup -f $ref_folder/$ref_name -g ${r}.${n}.rmd.s.bam | bcftools call -Ov -v -c -o ${r}.${n}.rmd.s.vcf
		#cp ${r}.${n}.rmd.s.vcf $reads/analysis/finally_vcfs
	done
done

#Статистика по ВАМ:

#samtools stats cov_${f}.mp_${mp}.sorted.bam > cov_${f}.mp_${mp}.sorted.bc

#plot-bamstats cov_${f}.mp_${mp}.sorted.bc -p /media/sf_Biolinux_folder_E/Anya_Hordeum/weza_fake_reads/cov_${f}/trash_${f}/cov_${f}.mp_${mp}

#cp cov_${f}.mp_${mp}-acgt-cycles.png -t /media/sf_Biolinux_folder_E/Anya_Hordeum/weza_fake_reads/cov_${f}
#cp cov_${f}.mp_${mp}-coverage.png -t /media/sf_Biolinux_folder_E/Anya_Hordeum/weza_fake_reads/cov_${f}
#cp cov_${f}.mp_${mp}-gc-depth.png -t /media/sf_Biolinux_folder_E/Anya_Hordeum/weza_fake_reads/cov_${f}
#cp cov_${f}.mp_${mp}-quals-hm.png -t /media/sf_Biolinux_folder_E/Anya_Hordeum/weza_fake_reads/cov_${f}
#cp cov_${f}.mp_${mp}-quals2.png -t /media/sf_Biolinux_folder_E/Anya_Hordeum/weza_fake_reads/cov_${f}
#/home/yahor/Fastq/8_S16
#/home/yahor/Fastq/Saski_haruna.fa

