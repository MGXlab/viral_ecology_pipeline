rule pharokka:
    input:
        "results/{sample}/jaeger/{sample}.jaeger_viral_contigs.fasta",
    output:
        "results/{sample}/pharokka/pharokka.gbk",
    conda:
        "../envs/pharokka.yaml"
    log:
        "logs/{sample}/pharokka/{sample}.pharokka.log"
    threads:
        config["PHAROKKA"]["threads"]
    params:
        outdir = "results/{sample}/pharokka/",
        pharokka_db = config["PHAROKKA"]["pharokka_db"]
    shell:
        "pharokka.py -i {input} -o {params.outdir} -d {params.pharokka_db} -t {threads} "
        "&> {log}"
