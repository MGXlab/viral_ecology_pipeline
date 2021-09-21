samples_df = samplesheet_to_df(config['samplesheet'])

FRACTIONS = samples_df['fraction'].unique().tolist()
VIRAL_SAMPLES = samples_df.loc[samples_df.fraction == 'viral', 'sample_id'].values.tolist()
MICROBIAL_SAMPLES = samples_df.loc[samples_df.fraction == 'microbial', 'sample_id'].values.tolist()
ALL_SAMPLES = VIRAL_SAMPLES + MICROBIAL_SAMPLES
LENGTH = config['SEQTK']['length']

rule create_wtp_input:
    input:
        expand("results/{fraction}/{sample}/scaffolds/{sample}_scaffolds_gt{length}.fasta",
                fraction='viral', sample=VIRAL_SAMPLES, length=LENGTH),
        expand("results/{fraction}/{sample}/scaffolds/{sample}_scaffolds_gt{length}.fasta",
                fraction='microbial', sample=MICROBIAL_SAMPLES, length=LENGTH)
    output:
        expand("results/wtp/input/{sample}_scaffolds_gt{length}.fasta",
                sample=ALL_SAMPLES, length=LENGTH),
    shell:
        """
        mkdir -p results/wtp/input 
        for f in {input};do
            ln -sr $f -d results/wtp/input;
        done
        """

rule wtp:
    input:
        expand("results/wtp/input/{sample}_scaffolds_gt{length}.fasta",
                sample=ALL_SAMPLES, length=LENGTH)
    output:
        expand("results/wtp/output/{sample}_scaffolds_gt{length}/{sample}_scaffolds_gt{length}_quality_summary.tsv",
                sample=ALL_SAMPLES, length=LENGTH),
        "results/wtp/output/runinfo/execution_report.html",
        "results/wtp/output/literature/Citations.bib",
    log:
        ".nextflow.log"
    conda:
        "../envs/wtp.yaml"
    params:
        fasta="'results/wtp/input/*.fasta'",
        pipeline="replikation/What_the_Phage",
        revision="v1.0.2",
        profile=["local", "singularity"],
        workdir=config["WTP"]["workdir"],
        databases=config["WTP"]["databases"],
        cachedir=config["WTP"]["cachedir"],
        output=config["WTP"]["outputdir"],
        cores=config["WTP"]["threads"],
    handover: True
    wrapper:
        "0.74.0/utils/nextflow"
