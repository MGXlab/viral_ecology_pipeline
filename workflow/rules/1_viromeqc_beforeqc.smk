rule viromeqc_beforeqc:
    input:
        beforeqc_reads=["results/{sample}/fastp/{sample}_1.clean_paired.fastq.gz", "results/{sample}/fastp/{sample}_2.clean_paired.fastq.gz"],
    output:
        viromeqc_output = "results/{sample}/viromeqc_beforeqc/{sample}.viromeqc_beforeqc.txt"
    conda:
        "../envs/viromeqc.yaml"
    log:
        "logs/{sample}/viromeqc_beforeqc/{sample}.log"
    threads:
        config["VIROMEQC"]["threads"]
    params:
        script = "/net/phage/linuxhome/mgx/people/lingyi/bin/software/viromeqc/viromeQC.py"
    shell:
        "python3 {params.script} "
        "-i {input} "
        "-o {output} "
        "--bowtie2_threads {threads} "
        "--diamond_threads {threads} "
        "&>{log}"
