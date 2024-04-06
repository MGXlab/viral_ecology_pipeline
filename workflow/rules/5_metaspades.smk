rule assembly:
    input:
        clean_paired_1 = rules.samtools_collate_fastq_paired.output.filtered_paired_1,
        clean_paired_2 = rules.samtools_collate_fastq_paired.output.filtered_paired_2,
    output:
        scaffolds="results/{sample}/metaspades/scaffolds.fasta"
    log:
        "logs/{sample}/metaspades/{sample}.metaspades.log"
    threads:
        config["SPADES"]["threads"]
    params:
        k = config["SPADES"]["k"],
        assembly_dir = "results/{sample}/metaspades"
    conda:
        "../envs/metaspades.yaml"
    shell:
        "spades.py "
        "-t {threads} "
        "--meta "
        "-k {params.k} "
        "--pe1-1 {input.clean_paired_1} "
        "--pe1-2 {input.clean_paired_2} "
        "-o {params.assembly_dir} "
        "&>{log}"

rule scaffolds_header_fix:
    input:
        scaffolds = rules.assembly.output.scaffolds
    output:
        scaffolds_header_fixed = "results/{sample}/scaffolds/{sample}_scaffolds.fasta"
    log:
        "logs/{sample}/hearder_fix/{sample}.header_fix.log"
    params:
        prefix = "{sample}_"
    shell:
        "perl -p -e 's/^>/>{params.prefix}/g' {input} > {output} "
        "2> {log}"
