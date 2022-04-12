#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue May  4 10:53:26 2021

@author: yahor
"""

n_type = [30, 0.3, 2, 1, 1, 7] #процентное соотношение типов кл.
N = 40000000 #количество лейкоцитов в 10мл крови
DN = 1000000 #порог входа для DNase-Seq
ATAC = 500 #порог входа для ATAC-Seq
counterDN = 0
counterATAC = 0

for n in n_type:
    if (N * (n / 100) / DN) > 1:
        counterDN += 1
    if (N * (n / 100) / ATAC) > 1:
        counterATAC += 1
print(f'{counterDN} иммунных клеточных типов вы гарантированно сможете изучить при помощи DNase-Seq')
print(f'{counterATAC} иммунных клеточных типов вы гарантированно сможете изучить при помощи ATAC-Seq')