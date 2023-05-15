samples_df = samplesheet_to_df(config['samplesheet'])
SAMPLES = samples_df['sample_id'].values.tolist()

rule checkv:
    input:
        expand("results/{sample}/scaffolds/{sample}_scaffolds.fasta", sample = SAMPLES),
    output:
        expand("results/checkv/{sample}/quality_summary.tsv", sample = SAMPLES),
    conda:
        "../envs/checkv.yaml"
    log:
        "logs/{sample}/checkv/{sample}.log"
    threads:
        config["CHECKV"]["threads"]
    shell:
        "checkv end_to_end {input} results/checkv/{sample}/ -t {threads} "
        "2>{log}"
