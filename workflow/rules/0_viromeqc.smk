rule viromeQC:
    input:
        fqs = get_sample_fastqs
    output:
        viromeqc_output = "results/{sample}/viromeqc/{sample}_viromeqc.txt"
    log:
        "logs/{sample}/viromeqc/{sample}.log"
    threads:
        config["VIROMEQC"]["threads"]
   params:
        script = "workflow/scripts/viromeQC.py"
    shell:
        "python3 {params.script} "
        "-i {input} "
        "-o {output} "
        "--bowtie2_threads {threads} "
        "--diamond_threads {threads}"
