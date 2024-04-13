rule checkv:
    input:
        "results/2_scaffolds/scaffolds_gt1000/{sample}_scaffolds_gt1000.fasta",
    output:
        "results/3_jaeger/{sample}_scaffolds_gt1000_jaeger.tsv",
    conda:
        "jaeger_v1.1.23"
    log:
        "logs/jaeger/{sample}.log"
    threads:
        config["JAEGER"]["threads"]
    shell:
        "/home/groups/VEO/tools/jaeger/v1.1.23/Jaeger/bin/jaeger "-i {input} -o {output} --gpu"
        "2> {log}"
