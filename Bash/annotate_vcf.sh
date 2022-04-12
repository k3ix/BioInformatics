#!/bin/bash
for i in $(cat $1)
do
	/storage/analysis/progs/annovar/convert2annovar.pl  -includeinfo -allsample -withfreq -format vcf4 $i > $i".avinpu"
	/storage/analysis/progs/annovar/table_annovar.pl $i /storage/analysis/Databases/humandb_new/ -buildver hg19 -out $i".avinpu" -remove -protocol refGene,esp6500siv2_all,avsnp150,clinvar_20190305,revel,intervar_20180118,1000g2015aug_all,1000g2015aug_afr,1000g2015aug_eas,1000g2015aug_eur,gnomad211_genome -operation g,f,f,f,f,f,f,f,f,f,f -nastring . -vcfinput --thread 40
done
