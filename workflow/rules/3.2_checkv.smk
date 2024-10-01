rule checkv:
    input:
        "results/{sample}/jaeger/{sample}.jaeger_virus_gt10000_seqs.fasta",
    output:
        "results/{sample}/checkv/quality_summary.tsv",
    conda:
        "../envs/checkv.yaml"
    log:
        "logs/{sample}/checkv/{sample}.log"
    threads:
        config["CHECKV"]["threads"]
    params:
        outdir = "results/{sample}/checkv/",
        checkv_db = config["CHECKV"]["checkv_db"]
    shell:
        "export CHECKVDB={params.checkv_db} \n"
        "checkv end_to_end {input} {params.outdir} -t {threads} "
        "2> {log}"
