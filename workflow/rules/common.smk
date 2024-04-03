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
    R1 = samples_df.loc[samples_df.SampleName == wildcards.sample, 'R1'].values[0]
    R2 = samples_df.loc[samples_df.SampleName == wildcards.sample, 'R2'].values[0]
    return [R1, R2]


def get_sample_gradient(wildcards):
    """Get the gradient of a sample as a string
    """
    gradient = samples_df.loc[samples_df.SampleName == wildcards.sample, 'gradient'].values[0]
    return gradient


# def get_fastqc_before_results(wildcards):
#     """Build a list of filenames for raw fastqc output
#     """
#     fraction_samples = samples_df.loc[samples_df.fraction == wildcards.fraction, 'SampleName'].values.tolist()
#     fraction_fastqc = []
#     for SampleName in fraction_samples:
#         for mate in [1,2]:
#             sample_fastqc = f"results/{wildcards.fraction}/{SampleName}/fastqc/before/{SampleName}_{mate}_fastqc.zip"
#             fraction_fastqc.append(sample_fastqc)
#     return fraction_fastqc


def concatenate_multiqc_dirs(wildcards, input):
    """Get directories from the input files as a string

    Helper function that builds a space separated string
    of unique directories from the input filenames.
    """
    dirs_list = []
    for path in input.files:
        d = Path(path).parents[0]
        dirs_list.append(str(d))
    return ' '.join(set(dirs_list))


# def get_fastqc_after_results(wildcards):
#     """Build a list of filenames for processed fastqc output
#     """
#     fraction_samples = samples_df.loc[samples_df.fraction == wildcards.fraction, 'SampleName'].values.tolist()
#     fraction_fastqc = []
#     for SampleName in fraction_samples:
#         for mate in [1,2]:
#             sample_fastqc = f"results/{wildcards.fraction}/{SampleName}/fastqc/after/{SampleName}_{mate}.clean_paired_fastqc.zip"
#             fraction_fastqc.append(sample_fastqc)
#     return fraction_fastqc

# LENGTH = str(config['SEQTK']['length'])
# def get_scaffolds_by_fraction(wildcards):
#     fraction_samples = samples_df.loc[samples_df.fraction == wildcards.fraction, 'SampleName'].values.tolist()
#     fraction_scaffolds = []
#     for SampleName in fraction_samples:
#         sample_scaffolds = f"results/{wildcards.fraction}/{SampleName}/scaffolds/{SampleName}_scaffolds_gt{LENGTH}.fasta"
#         fraction_scaffolds.append(sample_scaffolds)
#     return fraction_scaffolds
