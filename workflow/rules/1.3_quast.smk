rule quast:
    input:
        scaffolds_header_fixed = "results/{sample}/penguin/{sample}.scaffolds.fasta",
    output:
        quast_output = "results/{sample}/penguin_quast/report.txt"
    conda:
        "../envs/quast.yaml"
    log:
        "logs/{sample}/penguin_quast/{sample}.quast.log"
    threads:
        config["QUAST"]["threads"]
    params:
        script = "/home/lingyi/miniconda3/envs/quast/bin/quast",
        out_dir = "results/{sample}/penguin_quast/"
    shell:
        "python3 {params.script} "
        "-o {params.out_dir} "
        "-t {threads} "
        "{input} "
        "&>{log}"
