rule penguin:
    input:
        clean_paired_1 = "results/{sample}/remove_host_reads/{sample}_1.remove_host_reads.fastq.gz",
        clean_paired_2 = "results/{sample}/remove_host_reads/{sample}_2.remove_host_reads.fastq.gz",
    output:
        scaffolds="results/{sample}/penguin/{sample}.fasta"
    log:
        "logs/{sample}/penguin/{sample}.penguin.log"
    threads:
        config["PENGUIN"]["threads"]
    params:
        assembly_dir = "results/{sample}/penguin/penguin_tmp"
    conda:
        "../envs/metaspades.yaml"
    shell:
        "penguin nuclassemble "
        "{input.clean_paired_1} "
        "{input.clean_paired_2} " 
        "{output} "
        "{assembly_dir} "
        "--threads {threads} "
        "&>{log}"

rule scaffolds_header_fix:
    input:
        scaffolds = rules.penguin.output.scaffolds
    output:
        scaffolds_header_fixed = "results/{sample}/penguin/{sample}.scaffolds.fasta"
    log:
        "logs/{sample}/scaffolds_header_fix/{sample}.scaffolds_header_fix.log"
    params:
        prefix = "{sample}_"
    shell:
        "perl -p -e 's/^>/>{params.prefix}/g' {input} > {output} "
        "2> {log}"
