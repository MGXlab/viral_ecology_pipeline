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
  - compartment: almond: 0-rhizosphere, 1-bulk soil; sponge: 0-sponge, 1-seawater; gut: 0-lumen, 1-mucosa.

3. Fill in the `config.yaml` based on your needs.

4. Execute from within this dir.

5. Datasets:
   - almond: https://www.researchgate.net/publication/371360764_Almond_rhizosphere_viral_prokaryotic_and_fungal_communities_differed_significantly_among_four_California_orchards_and_in_comparison_to_bulk_soil_communities
   - sponge: https://www-sciencedirect-com.proxy.library.uu.nl/science/article/pii/S1931312819304287#sec4 
   - mammalian gut: https://www.nature.com/articles/s41564-022-01178-w

```
# This is a dry run
(gradient_virome)$ snakemake -j 94 --use-conda --conda-frontend mamba -p -n
```
* Remove `-n` to run it

## Input

Short, paired-end sequencing reads of a sample. 

