#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Sep  3 14:06:56 2021

@author: yahor
"""

a = []
with open('/storage/analysis/cnv/pregwas/Full_exome.rs.vcf', 'r') as f:
    for line in f:
        if "./." not in line:
            print(line)
            a.append(line)
with open('/storage/analysis/cnv/pregwas/Full_exome.miss.vcf', 'w') as w:
    for i in a:
        w.write(i)