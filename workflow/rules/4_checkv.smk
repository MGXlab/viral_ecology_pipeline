samples_df = samplesheet_to_df(config['samplesheet'])
SAMPLES = samples_df['SampleName'].values.tolist()

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
    params:
        outdir= "results/checkv/{sample}/",
    shell:
        "export CHECKVDB=data/checkv-db-v1.5 \n"
        "checkv end_to_end {input} {params.outdir} -t {threads} "
        "2> {log}"
