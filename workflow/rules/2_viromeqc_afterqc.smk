rule viromeQC:
    input:
        afterqc_reads=["results/{sample}/remove_host_reads/{sample}_1.remove_host_reads.fastq.gz", "results/{sample}/remove_host_reads/{sample}_2.remove_host_reads.fastq.gz"],
    output:
        viromeqc_output = "results/{sample}/viromeqc/{sample}_viromeqc.txt"
    conda:
        "../envs/viromeqc.yaml"
    log:
        "logs/{sample}/viromeqc_afterqc/{sample}.log"
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
