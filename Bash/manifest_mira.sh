#!/bin/bash
cd /home/yegor/Genomics/Soft/mira_4.0.2_linux-gnu_x86_64_static/bin/
mkdir manifests
cd /home/yegor/Diuraphis_noxia2/more_then
for i in *.fna
do
	cd /home/yegor/Genomics/Soft/mira_4.0.2_linux-gnu_x86_64_static/bin/manifests
	refName="/home/yegor/Diuraphis_noxia2/references/1_$i"
	readName="/home/yegor/Diuraphis_noxia2/reads/2_$i"
	echo $refName
	echo $readName
	exec 3<> manifest_$i.conf
        	echo "project = Afa_cyp_$i" >&3
        	echo "job=genome,mapping,accurate" >&3
        	echo "parameters = --noqualities, -NW:cmrnl=warn, " >&3
        	echo "" >&3
        	echo "readgroup" >&3
        	echo "is_reference" >&3
        	echo "data = $refName" >&3
        	echo "strain = Afa_cyp" >&3
        	echo "" >&3
        	echo "readgroup = reads" >&3
        	echo "data = $readName" >&3
        	echo "technology = iontor" >&3
        	echo "strain = Afa_cyp" >&3
        exec 3>&-    
	cd /home/yegor/Genomics/Soft/mira_4.0.2_linux-gnu_x86_64_static/bin
	mira /home/yegor/Genomics/Soft/mira_4.0.2_linux-gnu_x86_64_static/bin/manifests/manifest_$i.conf
done
