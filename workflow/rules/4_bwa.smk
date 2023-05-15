rule bwa_index:
    input:
        scaffolds = rules.assembly.output.scaffolds,
    output:
        idx = multiext(rules.assembly.output.scaffolds, ".amb", ".ann", ".bwt", ".pac", ".sa"),
    log:
        "logs/{sample}/bwa_index/{sample}.log",
    params:
        algorithm="bwtsw",
    threads:
        config["BWA"]["threads"]
    wrapper:
        "v1.7.1/bio/bwa/index"

rule bwa_mem:
    input:
        reads = ["results/{sample}/fastp/{sample}_1.clean_paired.fastq.gz", "results/{fraction}/{sample}/qc/{sample}_2.clean_paired.fastq.gz"],,
        idx = multiext(rules.assembly.output.scaffolds, ".amb", ".ann", ".bwt", ".pac", ".sa"),
    output:
        bam = "results/bwa/{sample}/{sample}.bam",
    log:
        "logs/{sample}/bwa_mem/{sample}.log",
    params:
        extra=r"-R '@RG\tID:{sample}\tSM:{sample}'",
        sorting="none",  # Can be 'none', 'samtools' or 'picard'.
        sort_order="queryname",  # Can be 'queryname' or 'coordinate'.
        sort_extra="",  # Extra args for samtools/picard.
    threads:
        config["BWA"]["threads"]
    wrapper:
        "v1.10.0/bio/bwa/mem"

rule samtools_stats:
    input:
        bam = rules.bwa_mem.output.bam,
    output:
        samtools_stats = "results/bwa/{sample}/{sample}.samtools_stats.txt",
    params:
        extra="",  # Optional: extra arguments.
    log:
        "logs/{sample}/samtools_stats/{sample}.log",
    wrapper:
        "v1.7.1/bio/samtools/stats"
