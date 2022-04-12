#!/bin/bash
dir=$(cd $(dirname $0) && pwd)
cd $dir/results
for i in $(ls)
do
	realpath $i >> $dir/sample_list.txt
done
