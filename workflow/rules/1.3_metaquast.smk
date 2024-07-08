rule metaquast:
    input:
        scaffolds_header_fixed = "results/{sample}/penguin/{sample}.scaffolds.fasta",
    output:
        quast_output = "results/{sample}/penguin_metaquast/report.txt"
    conda:
        "../envs/quast.yaml"
    log:
        "logs/{sample}/penguin_metaquast/{sample}.metaquast.log"
    threads:
        config["QUAST"]["threads"]
    params:
        script = "/home/lingyi/miniconda3/envs/quast/bin/metaquast",
        out_dir = "results/{sample}/penguin_metaquast/"
    shell:
        "python3 {params.script} "
        "-o {params.out_dir} "
        "-t {threads} "
        "{input} "
        "&>{log}"
