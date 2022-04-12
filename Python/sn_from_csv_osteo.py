# -*- coding: utf-8 -*-
"""
Created on Tue Nov 23 19:52:23 2021

@author: Asus
"""

import pandas as pd
import re
df = pd.read_excel("/home/yahor/osteo.xlsx")
df.drop(df.iloc[:, 3:6], inplace = True, axis = 1)
df.drop(df.iloc[:, 4:], inplace = True, axis = 1)
j = 0
osp = []
con = []
for i in df['Library']:
    if i == 'OsteoSeq2' or i == 'OsteoSeq1':
        if df['Group'][j] == 'osp':
            osp.append(df['Столбец1'][j])
        elif df['Group'][j] == 'con':
            con.append(df['Столбец1'][j])        
    else:
        if df['Group'][j] == 'osp':
            osp.append(df['№ образца'][j])
        elif df['Group'][j] == 'con':
            con.append(df['№ образца'][j])
    j +=1
    
for i in range(len(osp)):
    pattern = r"^osp(0)+"
    if len(str(osp[i])) == 1:
        osp[i] = '00' + str(osp[i]) + '.bam'
    elif len(str(osp[i])) == 2:
        osp[i] = '0' + str(osp[i]) + '.bam'
    elif len(str(osp[i])) == 3:
        osp[i] = str(osp[i]) + '.bam'    
    elif re.match(pattern, osp[i]):
        osp[i] = 'osp' + re.sub(r'osp(0)+', '', osp[i]) + '.bam'
    else:
        osp[i] = str(osp[i]) + '.bam'
    with open('/home/yahor/osp_merge.list', 'a') as ospWrite:
        ospWrite.write(osp[i]+'\n')

print(end='\n\n')

for i in range(len(con)):
    pattern = r"^osp(0)+"
    if len(str(con[i])) == 1:
        con[i] = '00' + str(con[i]) + '.bam'
    elif len(str(con[i])) == 2:
        con[i] = '0' + str(con[i]) + '.bam'
    elif len(str(con[i])) == 3:
        con[i] = str(con[i]) + '.bam'    
    elif re.match(pattern, con[i]):
        con[i] = 'osp' + re.sub(r'osp(0)+', '', con[i]) + '.bam'
    else:
        con[i] = str(con[i]) + '.bam' 
    with open('/home/yahor/con_merge.list', 'a') as conWrite:
        conWrite.write(con[i]+'\n')








