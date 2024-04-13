rule checkv:
    input:
        "results/{sample}/scaffolds/{sample}.scaffolds_gt" + LENGTH + ".fasta",
    output:
        "results/{sample}/checkv/quality_summary.tsv",
    conda:
        "../envs/checkv.yaml"
    log:
        "logs/{sample}/checkv/{sample}.log"
    threads:
        config["CHECKV"]["threads"]
    params:
        outdir= "results/{sample}/checkv/",
    shell:
        "export CHECKVDB=data/checkv-db-v1.5 \n"
        "checkv end_to_end {input} {params.outdir} -t {threads} "
        "2> {log}"
