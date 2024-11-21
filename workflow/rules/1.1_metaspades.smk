rule assembly:
    input:
        rarefaction_reads_1 = "results/{sample}/rarefaction_reads/{sample}_1.rarefaction_reads.fastq.gz",
        rarefactio_reads_2 = "results/{sample}/remove_host_reads/{sample}_2.rarefaction_reads.fastq.gz",
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
