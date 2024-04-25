rule quast:
    input:
        scaffolds_header_fixed = "results/{sample}/scaffolds/{sample}.scaffolds.fasta",
    output:
        quast_output = "results/{sample}/quast/report.txt"
    conda:
        "../envs/quast.yaml"
    log:
        "logs/{sample}/quast/{sample}.quast.log"
    threads:
        config["QUAST"]["threads"]
    params:
        script = "/home/lingyi/miniconda3/envs/quast/bin/quast",
        out_dir = "results/{sample}/quast/"
    shell:
        "python3 {params.script} "
        "-o {out_dir} "
        "-t {threads} "
        "{input} "
        "&>{log}"
