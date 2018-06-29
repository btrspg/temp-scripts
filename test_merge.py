#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Time    : 2018/6/12 上午11:25
# @Author  : Chen Yuelong
# @Mail    : yuelong_chen@yahoo.com
# @File    : test_merge.py
# @Software: PyCharm

from __future__ import absolute_import, unicode_literals

__author__ = 'Chen Yuelong'
import os, sys
import pandas as pd
import glob
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt


def main():
    files =glob.glob('/*/*/*/*/*/*/*/ALIGNMENT/*csv')
    data_list = []
    for file in files:
        # print(file)
        tmp = pd.read_csv(file,usecols=[0,1])
        data_list.append(tmp)
    print(len(data_list))
    merge_data = data_list.pop(0)

    for data in data_list:
        merge_data = pd.merge(merge_data,data,)

    # print(merge_data.columns)
    # plt.subplot(211)
    # fig,axes = plt.subplots(ncols=2)
    merge_data.to_csv('all.csv')
    data=pd.DataFrame([[merge_data.iloc[i][0],
                        merge_data.iloc[i][1:].mean(),
                        merge_data.iloc[i][1:].mean()+2*merge_data.iloc[i][1:].std(),
                        merge_data.iloc[i][1:].mean()-2*merge_data.iloc[i][1:].std(),
                        merge_data.iloc[i][1:].min()] for i in range(1,merge_data.shape[0])],
                      columns=['amplicon','mean','mean+2std','mean-2std','min'])

    data.sort_values('mean',inplace=True,ascending=True)
    data.to_csv('meanstd.csv')
    data.plot(x='amplicon')



    # plt.subplot(2)
    #
    plt.savefig('test.stat.png', dpi=300)
    # plt.subplot(212)
    subdata =data[data['mean'] < 3000]
    subdata.plot(x='amplicon',title=subdata.shape[0])

    plt.plot(y=500)
    plt.savefig('test2.png',dpi=300)


    # merge_data=merge_data.transpose()
    # print(merge_data.columns)
    # merge_data.plot(kind='box')
    # plt.savefig('test1.stat.png', dpi=300)
    #
    # print(merge_data.shape)



if __name__ == '__main__':
    main()
