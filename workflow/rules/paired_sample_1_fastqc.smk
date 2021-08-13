rule fastqc:
    input:
        fq1 = "../data/{paired_sample}/{fraction}/*_1.fastq.gz",
        fq2 = "../data/{paired_sample}/{fraction}/*_2.fastq.gz"
    output:
        fq1_html = "../results/qc/fastqc/virus_fastqc/{virus_sample}_1_fastqc.html",
        fq1_zip = "../results/qc/fastqc/virus_fastqc/{virus_sample}_1_fastqc.zip",
        fq2_html = "../results/qc/fastqc/virus_fastqc/{virus_sample}_2_fastqc.html",
        fq2_zip = "../results/qc/fastqc/virus_fastqc/{virus_sample}_2_fastqc.zip"
    params:
        qc_dir = "../results/qc/fastqc/"
    log:
        LOGS + "/logs/{virus_sample}.log"
    threads:
        CONFIG["FASTQC"]["threads"]
    conda:
        "../envs/fastqc.yaml"
    shell:
        "fastqc -o {params.qc_dir} "
        "-t {threads} "
        "{input.fq1} {input.fq2} 2>{log}"

rule virus_multiqc:
    input:
        expand([
            "../results/qc/fastqc/virus_fastqc/{virus_sample}_{mate}_fastqc.html",
            "../results/qc/fastqc/virus_fastqc/{virus_sample}_{mate}_fastqc.zip"],
            virus_sample=virus_samples, mate=[1,2])
    output:
        virus_multiqc_html="../results/qc/fastqc/virus_fastqc/virus_multiqc_report.html"
    params:
        qc_dir = "../results/qc/fastqc/virus_fastqc"
    log:
        "../logs/virus_multiqc/virus_multiqc.log"
    conda:
        "../envs/fastqc.yaml"
    shell:
        "multiqc -o {params.qc_dir} "
        "--filename virus_multiqc_report "
        "{params.qc_dir} 2>{log}"

rule microbe_fastqc:
    input:
        microbe_fq1 = "../data/fecal_microbe/{microbe_sample}/{microbe_sample}_1.fastq.gz",
        microbe_fq2 = "../data/fecal_microbe/{microbe_sample}/{microbe_sample}_2.fastq.gz"
    output:
        fq1_html = "../results/qc/fastqc/microbe_fastqc/{microbe_sample}_1_fastqc.html",
        fq1_zip = "../results/qc/fastqc/microbe_fastqc/{microbe_sample}_1_fastqc.zip",
        fq2_html = "../results/qc/fastqc/microbe_fastqc/{microbe_sample}_2_fastqc.html",
        fq2_zip = "../results/qc/fastqc/microbe_fastqc/{microbe_sample}_2_fastqc.zip"
    params:
        qc_dir = "../results/qc/fastqc/microbe_fastqc/"
    log:
        "../logs/microbe_fastqc/{microbe_sample}.log"
    threads:
        2
    conda:
        "../envs/fastqc.yaml"
    shell:
        "fastqc -o {params.qc_dir} "
        "-t {threads} "
        "{input.microbe_fq1} {input.microbe_fq2} 2>{log}"

rule microbe_multiqc:
    input:
        expand([
            "../results/qc/fastqc/microbe_fastqc/{microbe_sample}_{mate}_fastqc.html",
            "../results/qc/fastqc/microbe_fastqc/{microbe_sample}_{mate}_fastqc.zip"],
            microbe_sample=microbe_samples, mate=[1,2])
    output:
        microbe_multiqc_html="../results/qc/fastqc/microbe_fastqc/microbe_multiqc_report.html"
    params:
        qc_dir = "../results/qc/fastqc/microbe_fastqc"
    log:
        "../logs/microbe_multiqc/microbe_multiqc.log"
    conda:
        "../envs/fastqc.yaml"
    shell:
        "multiqc -o {params.qc_dir} "
        "--filename microbe_multiqc_report "
        "{params.qc_dir} 2>{log}"
