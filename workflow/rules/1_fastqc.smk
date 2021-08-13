rule virus_fastqc:
    input:
        virus_fq1 = "../data/fecal_virus/{virus_sample}/{virus_sample}_1.fastq.gz",
        virus_fq2 = "../data/fecal_virus/{virus_sample}/{virus_sample}_2.fastq.gz"
    output:
        fq1_html = "../results/fastqc/{virus_sample}_1_fastqc.html",
        fq1_zip = "../results/fastqc/{virus_sample}_1_fastqc.zip",
        fq2_html = "../results/fastqc/{virus_sample}_2_fastqc.html",
        fq2_zip = "../results/fastqc/{virus_sample}_2_fastqc.zip"
    log:
        "../logs/fastqc/{virus_sample}.log"
    threads:
        config["FASTQC"]["threads"]
    conda:
        "../envs/fastqc.yaml"
    params:
        qc_dir = config["FASTQC"]["qc_dir"]
    shell:
        "fastqc -o {params.qc_dir} "
        "-t {threads} "
        "{input.virus_fq1} {input.virus_fq2} 2>{log}"

rule microbe_fastqc:
    input:
        microbe_fq1 = "../data/fecal_microbe/{microbe_sample}/{microbe_sample}_1.fastq.gz",
        microbe_fq2 = "../data/fecal_microbe/{microbe_sample}/{microbe_sample}_2.fastq.gz"
    output:
        fq1_html = "../results/fastqc/{microbe_sample}_1_fastqc.html",
        fq1_zip = "../results/fastqc/{microbe_sample}_1_fastqc.zip",
        fq2_html = "../results/fastqc/{microbe_sample}_2_fastqc.html",
        fq2_zip = "../results/fastqc/{microbe_sample}_2_fastqc.zip"
    log:
        "../logs/fastqc/{microbe_sample}.log"
    threads:
        config["FASTQC"]["threads"]
    params:
        qc_dir = config["FASTQC"]["qc_dir"]
    conda:
        "../envs/fastqc.yaml"
    shell:
        "fastqc -o {params.qc_dir} "
        "-t {threads} "
        "{input.microbe_fq1} {input.microbe_fq2} 2>{log}"

rule multiqc:
    input:
        expand([
            "../results/fastqc/{virus_sample}_{mate}_fastqc.html",
            "../results/fastqc/{virus_sample}_{mate}_fastqc.zip",
            "../results/fastqc/{microbe_sample}_{mate}_fastqc.html",
            "../results/fastqc/{microbe_sample}_{mate}_fastqc.zip"],
            virus_sample=virus_samples, microbe_sample=microbe_samples, mate=[1,2])
    output:
        multiqc_html="../results/fastqc/multiqc_report.html"
    log:
        "../logs/multiqc/multiqc.log"
    conda:
        "../envs/fastqc.yaml"
    params:
        qc_dir = config["FASTQC"]["qc_dir"]
    shell:
        "multiqc -o {params.qc_dir} "
        "{params.qc_dir} 2>{log}"
