#!/usr/bin/env python

import pandas as pd
from pathlib import Path

def samplesheet_to_df(samplesheet):
    """Convert the tsv samplesheet to a pandas dataframe
    """
    samples_df = pd.read_csv(samplesheet, sep='\t')
    return samples_df


def get_sample_fastqs(wildcards):
    """Get a list of the paired fastqs for a sample
    """
    R1 = samples_df.loc[samples_df.sample_id == wildcards.sample, 'R1'].values[0]
    R2 = samples_df.loc[samples_df.sample_id == wildcards.sample, 'R2'].values[0]
    return [R1, R2]
