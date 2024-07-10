# run this rule on a gpu machine
rule jaeger:
    input:
        "combined_results/scaffolds/penguin_gt2480.scaffolds.fasta",
    output:
        "combined_results/jaeger/penguin_gt2480_jaeger_output.txt",
    conda:
        "../envs/jaeger.yaml"
    log:
        "logs/combined_results/jaeger/jaeger.log"
    params:
        output_dir = "combined_results/jaeger"
    shell:
        "Jaeger -i {input} -o {params.output_dir} --batch 128 "
        "2> {log}"
