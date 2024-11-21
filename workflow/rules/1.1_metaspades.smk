rule assembly:
    input:
        rarefaction_reads_1 = "results/E5-Stomach-NA-Muc/rarefaction_reads/E5-Stomach-NA-Muc_1.rarefaction_reads.fastq",
        rarefaction_reads_2 = "results/E5-Stomach-NA-Muc/rarefaction_reads/E5-Stomach-NA-Muc_2.rarefaction_reads.fastq",
    output:
        scaffolds="results/E5-Stomach-NA-Muc/metaspades/scaffolds.fasta"
    log:
        "logs/E5-Stomach-NA-Muc/metaspades/E5-Stomach-NA-Muc.metaspades.log"
    threads:
        config["SPADES"]["threads"]
    params:
        k = config["SPADES"]["k"],
        assembly_dir = "results/E5-Stomach-NA-Muc/metaspades"
    conda:
        "../envs/metaspades.yaml"
    shell:
        "spades.py "
        "-t {threads} "
        "--meta "
        "-k {params.k} "
        "--pe1-1 {input.rarefaction_reads_1} "
        "--pe1-2 {input.rarefaction_reads_2} "
        "-o {params.assembly_dir} "
        "&>{log}"

rule scaffolds_header_fix:
    input:
        scaffolds = rules.assembly.output.scaffolds
    output:
        scaffolds_header_fixed = "results/{sample}/scaffolds/{sample}.scaffolds.fasta"
    log:
        "logs/{sample}/scaffolds_header_fix/{sample}.scaffolds_header_fix.log"
    params:
        prefix = "{sample}_"
    shell:
        "perl -p -e 's/^>/>{params.prefix}/g' {input} > {output} "
        "2> {log}"
