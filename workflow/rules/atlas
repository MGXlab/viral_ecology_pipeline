rule atlas:
    input:
        fqs = get_sample_fastqs
    output:
        viromeqc_output = "results/{sample}/viromeqc/{sample}_viromeqc.txt"
    conda:
        "../envs/viromeqc.yaml"
    log:
        "logs/{sample}/viromeqc/{sample}.log"
    threads:
        config["VIROMEQC"]["threads"]
    params:
        script = "workflow/scripts/viromeqc/viromeQC.py"
    shell:
        "atlas init --db-dir databases {input}"

