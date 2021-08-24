#!/usr/bin/env python

import pandas as pd

def samplesheet_to_df(samplesheet):
    samples_df = pd.read_csv(samplesheet, sep='\t')
    return samples_df


def get_sample_fastqs(wildcards):
    R1 = samples_df.loc[samples_df.sample_id == wildcards.sample, 'R1'].values[0]
    R2 = samples_df.loc[samples_df.sample_id == wildcards.sample, 'R2'].values[0]
    return [R1, R2]


def get_sample_fraction(wildcards):
    fraction = samples_df.loc[samples_df.sample_id == wildcards.sample, 'fraction'].values[0]
    return fraction

def get_fastqc_before_results(wildcards):
    fraction_samples = samples_df.loc[samples_df.fraction == wildcards.fraction, 'sample_id'].values.tolist()
    fraction_fastqc = []
    for sample_id in fraction_samples:
        for mate in [1,2]:
            sample_fastqc = f"results/{wildcards.fraction}/fastqc/before/{sample_id}_{mate}_fastqc.html"
            fraction_fastqc.append(sample_fastqc)
    return fraction_fastqc

def get_fastqc_after_results(wildcards):
    fraction_samples = samples_df.loc[samples_df.fraction == wildcards.fraction, 'sample_id'].values.tolist()
    fraction_fastqc = []
    for sample_id in fraction_samples:
        for mate in [1,2]:
            sample_fastqc = f"results/{wildcards.fraction}/fastqc/after/{sample_id}_{mate}.clean_paired_fastqc.zip"
            fraction_fastqc.append(sample_fastqc)
    return fraction_fastqc
