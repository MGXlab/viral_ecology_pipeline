samples_df = samplesheet_to_df(config['samplesheet'])
SAMPLES = samples_df['sample_id'].values.tolist()

rule checkv:
    input:
        "results/{sample}/scaffolds/{sample}_scaffolds.fasta",
    output:
        "results/checkv/{sample}/quality_summary.tsv",
    conda:
        "../envs/checkv.yaml"
    log:
        "logs/{sample}/checkv/{sample}.log"
    threads:
        config["CHECKV"]["threads"]
    shell:
        "export CHECKVDB=data/checkv-db-v1.5 "
        "checkv end_to_end {input} results/checkv/{wildcards.sample}/ -t {threads} "
        "2> {log}"
