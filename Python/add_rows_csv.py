#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jul 29 13:25:30 2021

@author: Yahor@k$ix^
"""

import pandas as pd
import os
import sys
df = pd.read_csv(sys.argv[1])
df = df.copy(deep = True)
os.chdir(sys.argv[2])
for curr, dirs, files in os.walk('.'):
    for b in files:
        if '.bam' in b and 'bai' not in b:
            print(b)
            res = os.getcwd() + '/' + str(b)
            print(res)
            new_row = {'путь к файлу' : str(res)}
            print(new_row)
            df = df.append(new_row, ignore_index=True)
            print(df.tail())
df.to_csv('samples_out.csv')