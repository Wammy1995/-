import numpy as np
import scipy.stats as stats
import pandas as pd
import sys


# 本程序将获得240个试次每个试次等级差扩大一万倍后的均值和标准差，以及对应的设定参数
num_samples = (30,50,100,500)
rs = (0.9,0.7,0.5,0.3)
ms = (50,80,200,500,100)
sds = (225,100,25)
count = 239
tm = [];ts = []
nos = [];noc = [];nom = [];nosd = []
for sd in sds:
    for c in rs:
        cov = [[sd, c*sd], [c*sd, sd]]
        for num_sample in num_samples:
            for a in ms:
                m = (a, a)
                # for b in sds:
                diffs = []
                diffsW = []
                for i in range(10000):
                    linalg = np.linalg
                    X, Y = np.random.multivariate_normal(m, cov, num_sample, tol=0.01).T
                    pccs, pval = stats.pearsonr(X, Y)
                    if pccs < c-0.01 or pccs > c+0.01:
                        continue
                    else:
                        spp, pval = stats.spearmanr(X, Y)
                        diffs.append(pccs-spp)
                        if len(diffs) == 1000:
                            break
                for i in range(len(diffs)):
                    diffsW.append(np.trunc(diffs[i]*10000))
                tm.append(np.mean(diffsW))
                ts.append(np.trunc(np.std(diffsW)))
                noc.append(c);nom.append(a);nos.append(num_sample);nosd.append(sd)
                count = count-1
                print(count)
dataframe = pd.DataFrame({'num_sample': nos, 'pearsonR': noc, 'mean_sample': nom, 'sd2_sample': nosd, 'diffW_M': tm, 'diffW_STD': ts})
dataframe.to_csv('全部420数据.csv', index=False, sep=',')
                # sys.exit()
