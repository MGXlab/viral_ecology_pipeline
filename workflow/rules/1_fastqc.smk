rule fastqc_before:
    input:
        fqs = get_sample_fastqs
    output:
        fq1_zip = "results/{fraction}/{sample}/fastqc/before/{sample}_1_fastqc.html",
        fq2_zip = "results/{fraction}/{sample}/fastqc/before/{sample}_2_fastqc.html"
    params:
        fraction = get_sample_fraction
    log:
        "logs/{fraction}/{sample}/{sample}.fastqc_before.log"
    threads: 2
    conda:
        "../envs/fastqc.yaml"
    shell:
        "fastqc -o results/{params.fraction}/{wildcards.sample}/fastqc/before "
        "-t {threads} "
        "{input.fqs[0]} {input.fqs[1]} "
        "&>{log}"


rule multiqc_before:
    input:
        get_fastqc_before_results
    output:
        multiqc_html = "results/{fraction}/multiqc/multiqc_before.html"
    log:
        "logs/{fraction}/multiqc/multiqc.log"
    conda:
        "../envs/fastqc.yaml"
    shell:
        "multiqc -o results/{wildcards.fraction}/multiqc/ "
        "--quiet "
        "-n multiqc_before.html "
        "results/{wildcards.fraction}/{sample}/fastqc/before "
        "2>{log}"



rule fastqc_after:
    input:
        clean_1 = "results/{fraction}/{sample}/trim/{sample}_1.clean_paired.fastq.gz",
        clean_2 = "results/{fraction}/{sample}/trim/{sample}_2.clean_paired.fastq.gz"
    output:
        fq1_zip = "results/{fraction}/{sample}/fastqc/after/{sample}_1.clean_paired_fastqc.zip",
        fq2_zip = "results/{fraction}/{sample}/fastqc/after/{sample}_2.clean_paired_fastqc.zip"
    params:
        fraction = get_sample_fraction
    log:
        "logs/{fraction}/{sample}/{sample}.fastqc_after.log"
    threads: 2
    conda:
        "../envs/fastqc.yaml"
    shell:
        "fastqc -o results/{params.fraction}/{wildcards.sample}/fastqc/after "
        "-t {threads} "
        "{input.clean_1} {input.clean_2} "
        "&>{log}"


rule multiqc_after:
    input:
        get_fastqc_after_results
    output:
        multiqc_after_html = "results/{fraction}/multiqc/multiqc_after.html"
    log:
        "logs/{fraction}/multiqc/multiqc_after.log"
    conda:
        "../envs/fastqc.yaml"
    shell:
        "multiqc -o results/{wildcards.fraction}/multiqc/ "
        "--quiet "
        "-n multiqc_after.html "
        "results/{wildcards.fraction}/{sample}/fastqc/after "
        "2>{log}"
