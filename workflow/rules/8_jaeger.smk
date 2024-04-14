rule jaeger:
    input:
        "results/{sample}/scaffolds/{sample}.scaffolds_gt" + LENGTH + ".fasta",
    output:
        "results/{sample}/jaeger/{sample}.scaffolds_gt" + LENGTH + "_jaeger.tsv",
    conda:
        "../envs/jaeger.yaml"
    log:
        "logs/{sample}/jaeger/{sample}.log"
    params:
        output_dir = "results/{sample}/jaeger"
    threads:
    shell:
        "Jaeger -i {input} -o {params.output_dir} --batch 128 "
        "2> {log}"
