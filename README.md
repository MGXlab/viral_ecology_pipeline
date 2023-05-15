# gradient_viral

## Quickstart

1. Grab the code
```
$ git clone git@github.com:MGXlab/gradient_virome.git 
$ conda create -n gradient_virome --file conda-linux-64.lock
$ conda activate gradient_virome
```

2. Define a tab-separated samplesheet with a header and  column names
  - `sample_id`
  - `pair_id`: mucosal and luminal paired id
  - `gradient`: `mucosal` or `luminal` (can be anything really)
  - `R1`: Path to forward fastq file
  - `R2`: Path to reverse fastq file
  - `R1_MD5`: MD5 numbers of Generated R1 FASTQ files
  - `R2_MD5`: MD5 numbers of Generated R2 FASTQ files

3. Fill in the `config.yaml` based on your needs.

4. Execute from within this dir.

```
# This is a dry run
(gradient_virome)$ snakemake -j 32 --use-conda --conda-frontend mamba -p -n
```
* Remove `-n` to run it

## Input

Short, paired-end sequencing reads of a sample. 

