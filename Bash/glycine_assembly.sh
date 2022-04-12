#!/bin/bash
path=$1
cd $path
#for fq in $(ls | grep "R1")
#do
	#sn=$(basename $fq | cut -d "_" -f1)
	#sn_move=$(basename $fq | cut -d "_" -f1,2)
	#echo $sn
	#mkdir $sn
	#mv $fq $sn
	#mv $sn_move"_L001_R2_001.fastq.gz" $sn
#done
for dr in $(ls */ -d)
do 
	cd $path/$dr
	sample_name=$(pwd | rev | cut -d "/" -f1 | rev | cut -d "_" -f1,2)
	r1=$(ls | grep "R1")
	r2=$(ls | grep "R2")
	exec 3<> config_mito.txt
		echo "Project:" >&3
		echo "-----------------------" >&3
		echo "Project name          = ${sample_name}_mito" >&3
		echo "Type                  = mito_plant" >&3
		echo "Genome Range          = 120000-600000" >&3
		echo "K-mer                 = 39" >&3
		echo "Max memory            =" >&3
		echo "Extended log          = 0" >&3
		echo "Save assembled reads  = no" >&3
		echo "Seed Input            = /home/yahor/Organelles_glycine/glycine_cox1_mito.fasta" >&3
		echo "Extend seed directly  = no" >&3
		echo "Reference sequence    = /home/yahor/Organelles_glycine/glycine_mito.fasta" >&3
		echo "Variance detection    = " >&3
		echo "Chloroplast sequence  = /home/yahor/Organelles_glycine/glycine_chloro.fasta" >&3
		echo "" >&3
		echo "" >&3
		echo "" >&3
		echo "Dataset 1:" >&3
		echo "-----------------------" >&3
		echo "Read Length           = 300" >&3
		echo "Insert size           = 301" >&3
		echo "Platform              = illumina" >&3
		echo "Single/Paired         = PE" >&3
		echo "Combined reads        =" >&3
		echo "Forward reads         = "$path"/"$dr""$r1"" >&3
		echo "Reverse reads         = "$path"/"$dr""$r2"" >&3
		echo "" >&3
		echo "" >&3
		echo "Heteroplasmy:" >&3
		echo "-----------------------" >&3
		echo "MAF                   = " >&3
		echo "HP exclude list       = " >&3
		echo "PCR-free              = " >&3
		echo "" >&3
		echo "Optional:" >&3
		echo "-----------------------" >&3
		echo "Insert size auto      = yes" >&3
		echo "Use Quality Scores    = no" >&3
		echo "Output path           = $path/$dr" >&3
	exec 3>&-
	
	
	
	exec 3<> config_chl.txt
		echo "Project:" >&3
		echo "-----------------------" >&3
		echo "Project name          = ${sample_name}_chl" >&3
		echo "Type                  = chloro" >&3
		echo "Genome Range          = 120000-210000" >&3
		echo "K-mer                 = 39" >&3
		echo "Max memory            =" >&3
		echo "Extended log          = 0" >&3
		echo "Save assembled reads  = no" >&3
		echo "Seed Input            = /home/yahor/Organelles_glycine/glycine_ndhB_chl.fasta" >&3
		echo "Extend seed directly  = no" >&3
		echo "Reference sequence    = /home/yahor/Organelles_glycine/glycine_chloro.fasta" >&3
		echo "Variance detection    = " >&3
		echo "Chloroplast sequence  = " >&3
		echo "" >&3
		echo "" >&3
		echo "" >&3
		echo "Dataset 1:" >&3
		echo "-----------------------" >&3
		echo "Read Length           = 300" >&3
		echo "Insert size           = 301" >&3
		echo "Platform              = illumina" >&3
		echo "Single/Paired         = PE" >&3
		echo "Combined reads        =" >&3
		echo "Forward reads         = "$path"/"$dr""$r1"" >&3
		echo "Reverse reads         = "$path"/"$dr""$r2"" >&3
		echo "" >&3
		echo "" >&3
		echo "Heteroplasmy:" >&3
		echo "-----------------------" >&3
		echo "MAF                   = " >&3
		echo "HP exclude list       = " >&3
		echo "PCR-free              = " >&3
		echo "" >&3
		echo "Optional:" >&3
		echo "-----------------------" >&3
		echo "Insert size auto      = yes" >&3
		echo "Use Quality Scores    = no" >&3
		echo "Output path           = $(pwd)" >&3
	exec 3>&-
	perl /home/yahor/Soft/NOVOPlasty-master/NOVOPlasty4.2.1.pl -c config_mito.txt
	perl /home/yahor/Soft/NOVOPlasty-master/NOVOPlasty4.2.1.pl -c config_chl.txt
done


