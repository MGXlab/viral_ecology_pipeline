rule fastp:
    input:
        fqs = get_sample_fastqs
    output:
        paired_1 = "results/{sample}/qc/{sample}_1.clean_paired.fastq.gz",
        paired_2 = "results/{sample}/qc/{sample}_2.clean_paired.fastq.gz",
        unpaired_1 = "results/{sample}/qc/{sample}_1.clean_unpaired.fastq.gz",
        unpaired_2 = "results/{sample}/qc/{sample}_2.clean_unpaired.fastq.gz",
        html = "results/{sample}/qc/{sample}.fastp.html",
        json = "results/{sample}/qc/{sample}.fastp.json"
    log:
        "logs/{sample}/qc/{sample}.fastp.log"
    threads:
        config["FASTP"]["threads"]
    conda:
        "../envs/fastp.yaml"
    shell:
        "fastp -i {input[0]} -I {input[1]} "
        "-o {output.paired_1} -O {output.paired_2} "
        "--unpaired1 {output.unpaired_1} --unpaired2 {output.unpaired_2} "
        "--html {output.html} --json {output.json} "
        "--dedup --detect_adapter_for_pe "
        "&> {log}"
