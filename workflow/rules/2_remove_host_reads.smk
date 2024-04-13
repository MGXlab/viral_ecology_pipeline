rule bwa_mem:
    input:
        fastp_reads=["results/{sample}/fastp/{sample}_1.clean_paired.fastq.gz", "results/{sample}/fastp/{sample}_2.clean_paired.fastq.gz"],
    output:
        "results/{sample}/remove_host_reads/{sample}.sam",
    log:
        "logs/{sample}/remove_host_reads/{sample}.bwa_mem.log",
    params:
        reference_genomes = config['BWA']['reference_genomes']
    threads: 
        config["BWA"]["threads"]
    conda:
        "../envs/bwa.yaml"
    shell:
        "bwa mem -t {threads} {params.reference_genomes} {input[0]} {input[1]} -o {output} "
        "&>{log}"

rule samtools_sort:
    input:
        "results/{sample}/remove_host_reads/{sample}.sam",
    output:
        "results/{sample}/remove_host_reads/{sample}.sorted.sam",
    log:
        "logs/{sample}/remove_host_reads/{sample}.samtools_sort.log",
    params:
    threads: 
        config["SAMTOOLS"]["threads"]
    conda:
        "../envs/samtools.yaml"
    shell:
        "samtools sort -@ {threads} {input} -o {output} "
        "&>{log}"

rule sam2bam:
    input:
        "results/{sample}/remove_host_reads/{sample}.sorted.sam",
    output:
        "results/{sample}/remove_host_reads/{sample}.sorted.bam",
    log:
        "logs/{sample}/remove_host_reads/{sample}.sam2bam.log",
    params:
    threads: 
        config["SAMTOOLS"]["threads"]
    conda:
        "../envs/samtools.yaml"
    shell:
        "samtools view -@ {threads} -bS {input} -o {output} "
        "&>{log}"

rule samtools_stats:
    input:
        "results/{sample}/remove_host_reads/{sample}.sorted.bam",
    output:
        "results/{sample}/remove_host_reads/{sample}.stats.txt",
    log:
        "logs/{sample}/remove_host_reads/{sample}.samtools_stats.log",
    params:
    threads: 
        config["SAMTOOLS"]["threads"]
    conda:
        "../envs/samtools.yaml"
    shell:
        "samtools stats -@ {threads} -d {input} > {output} "
        "&>{log}"

rule samtools_index:
    input:
        "results/{sample}/remove_host_reads/{sample}.sorted.bam",
    output:
        "results/{sample}/remove_host_reads/{sample}.sorted.bam.bai",
    log:
        "logs/{sample}/remove_host_reads/{sample}.samtools_index.log",
    params:
    threads: 
        config["SAMTOOLS"]["threads"]
    conda:
        "../envs/samtools.yaml"
    shell:
        "samtools index -@ {threads} {input} {output} "
        "&>{log}"

rule extract_paired_unmapped_reads:
    input:
        "results/{sample}/remove_host_reads/{sample}.sorted.bam",
    output:
        "results/{sample}/remove_host_reads/{sample}.paired_unmapped.bam",
    log:
        "logs/{sample}/remove_host_reads/{sample}.extract_paired_unmapped_reads.log",
    params:
    threads: 
        config["SAMTOOLS"]["threads"]
    conda:
        "../envs/samtools.yaml"
    shell:
        "samtools view -@ {threads} -b -f 12 -F 256 {input} -o {output} "
        "&>{log}"

rule samtools_sort_paired_unmapped:
    input:
        "results/{sample}/remove_host_reads/{sample}.paired_unmapped.bam",
    output:
        "results/{sample}/remove_host_reads/{sample}.paired_unmapped.sorted.bam",
    log:
        "logs/{sample}/remove_host_reads/{sample}.samtools_sort_paired_unmapped.log",
    params:
    threads: 
        config["SAMTOOLS"]["threads"]
    conda:
        "../envs/samtools.yaml"
    shell:
        "samtools sort -@ {threads} -n {input} -o {output} "
        "&>{log}"

rule split_paired_unmapped_reads:
    input:
        "results/{sample}/remove_host_reads/{sample}.paired_unmapped.sorted.bam"
    output:
        remove_host_reads=["results/{sample}/remove_host_reads/{sample}_1.remove_host_reads.fastq.gz", "results/{sample}/remove_host_reads/{sample}_2.remove_host_reads.fastq.gz"],
    log:
        "logs/{sample}/remove_host_reads/{sample}.split_paired_unmapped_reads.log",
    params:
    threads: 
        config["SAMTOOLS"]["threads"]
    conda:
        "../envs/samtools.yaml"
    shell:
        "samtools fastq -@ {threads} {input} -1 {output[0]} -2 {output[1]} -0 /dev/null -s /dev/null -n "
        "&>{log}"
