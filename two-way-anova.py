# -*- coding: utf-8 -*-
"""
Created on Sun Jun 16 21:33:06 2019

@author: AungPyae
"""

# !pip install researchpy
# !conda install -c researchpy researchpy

import pandas
import researchpy as rp
import seaborn as sns

import statsmodels.api as sm
from statsmodels.formula.api import ols
import statsmodels.stats.multicomp

df = pandas.read_csv("https://raw.githubusercontent.com/Opensourcefordatascience/Data-sets/master/crop_yield.csv")
df.boxplot(column=['Yield'], grid=True)

rp.summary_cont(df['Yield'])
rp.summary_cont(df.groupby(['Fert']))['Yield']
rp.summary_cont(df.groupby(['Water']))['Yield']
rp.summary_cont(df.groupby(['Fert', 'Water']))['Yield']


# 2 way ANOVA
# Fits the model with the interaction term
# This will also automatically include the main effects for each factor
model = ols('Yield ~ C(Fert)*C(Water)', df).fit()

# Seeing if the overall model is significant
print(f"Overall model F({model.df_model: .0f},{model.df_resid: .0f}) = {model.fvalue: .3f}, p = {model.f_pvalue: .4f}")
model.summary()

# Creates the ANOVA table
res = sm.stats.anova_lm(model, typ= 2)
res

# Fits the model (check again)
model2 = ols('Yield ~ C(Fert)+ C(Water)', df).fit()

print(f"Overall model F({model2.df_model: .0f},{model2.df_resid: .0f}) = {model2.fvalue: .3f}, p = {model2.f_pvalue: .4f}")
model2.summary()

# Creates the ANOVA table
res2 = sm.stats.anova_lm(model2, typ= 2)
res2


# Calculating effect size
def anova_table(aov):
    aov['mean_sq'] = aov[:]['sum_sq']/aov[:]['df']
    
    aov['eta_sq'] = aov[:-1]['sum_sq']/sum(aov['sum_sq'])
    
    aov['omega_sq'] = (aov[:-1]['sum_sq']-(aov[:-1]['df']*aov['mean_sq'][-1]))/(sum(aov['sum_sq'])+aov['mean_sq'][-1])
    
    cols = ['sum_sq', 'mean_sq', 'df', 'F', 'PR(>F)', 'eta_sq', 'omega_sq']
    aov = aov[cols]
    return aov

anova_table(res2)



# Post-hoc Testing
mc = statsmodels.stats.multicomp.MultiComparison(df['Yield'], df['Fert'])
mc_results = mc.tukeyhsd()
print(mc_results)

mc = statsmodels.stats.multicomp.MultiComparison(df['Yield'], df['Water'])
mc_results = mc.tukeyhsd()
print(mc_results)

# https://pythonfordatascience.org/anova-2-way-n-way/