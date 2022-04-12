#!/bin/bash
file=$1
awk 'BEGIN{a=0}{if(a==1){print;a=0}}/^@/{print;a=1}' $file | sed 's/^@/>/'

