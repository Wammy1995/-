import numpy as np
import scipy.stats as stats
import pandas as pd
import sys


##将输出240组试次内的各组数据等级差*10000及标准差
num_samples = (30,50,100,500)
rs = (0.9,0.7,0.5,0.3)
ms = (50,80,200,500,100)
sds = (225,100,25)
count = 239
for sd in sds:
    for c in rs:
        cov = [[sd, c*sd], [c*sd, sd]]
        for num_sample in num_samples:
            for a in ms:
                m = (a, a)
                pccss = []
                diffs = []
                diffsW = []
                sd2 = []
                # if a == 80:
                #     sys.exit()
                for i in range(10000):
                    linalg = np.linalg
                    X, Y = np.random.multivariate_normal(m, cov, num_sample, tol=0.01).T
                    pccs, pval = stats.pearsonr(X, Y)
                    # 调取某一试次的X、Y数列
                    # if i == 4:
                    #     dataframe0 = pd.DataFrame({'X': X, 'Y': Y})
                    #     dataframe0.to_csv('single_dataset', index=False, sep=',')
                    #     sys.exit()
                    if pccs < c-0.01 or pccs > c+0.01:
                        continue
                    else:
                        spp, pval = stats.spearmanr(X, Y)
                        sd2.append(np.std(X))
                        pccss.append(pccs)
                        diffs.append(pccs-spp)
                        if len(diffs) == 1000:
                            break
                name = str(num_sample)+'_'+str(c)+'_'+str(a)+'_'+str(sd)+'.csv'
                for i in range(len(diffs)):
                    diffsW.append(np.trunc(diffs[i]*10000))
                dataframe = pd.DataFrame({'diff': diffs, 'diffW': diffsW, 'std': sd2})
                dataframe.to_csv(name, index=False, sep=',')
                # sys.exit()
                print(count)
                count = count-1

