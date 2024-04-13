rule bwa_index_assemblies:
    input:
        scaffolds = "results/{sample}/scaffolds/{sample}.scaffolds_gt" + LENGTH + ".fasta",
    output:
        idx = multiext("results/{sample}/scaffolds/{sample}.scaffolds_gt" + LENGTH + ".fasta", ".amb", ".ann", ".bwt", ".pac", ".sa"),
    log:
        "logs/{sample}/bwa_index_assemblies/{sample}.log",
    params:
    threads:
        config["BWA"]["threads"]
    wrapper:
        "v3.8.0/bio/bwa/index"

rule bwa_mem_reads_to_assemblies:
    input:
        reads = ["results/{sample}/remove_host_reads/{sample}_1.remove_host_reads.fastq.gz", "results/{sample}/remove_host_reads/{sample}_2.remove_host_reads.fastq.gz"],
        idx = multiext("results/{sample}/scaffolds/{sample}.scaffolds_gt" + LENGTH + ".fasta", ".amb", ".ann", ".bwt", ".pac", ".sa"),
    output:
        bam = "results/{sample}/bwa_mem_reads_to_assemblies/{sample}.reads_to_assemblies.bam",
    log:
        "logs/{sample}/bwa_mem_reads_to_assemblies/{sample}.log",
    params:
        extra=r"-R '@RG\tID:{sample}\tSM:{sample}'",
        sorting="none",  # Can be 'none', 'samtools' or 'picard'.
        sort_order="queryname",  # Can be 'queryname' or 'coordinate'.
        sort_extra="",  # Extra args for samtools/picard.
    threads:
        config["BWA"]["threads"]
    wrapper:
        "v3.8.0/bio/bwa/mem"

rule samtools_stats_reads_to_assemblies:
    input:
        bam = "results/{sample}/bwa_mem_reads_to_assemblies/{sample}.bam",
    output:
        "results/{sample}/bwa_mem_reads_to_assemblies/{sample}.reads_to_assemblies.samtools_stats.txt",
    params:
        extra="",  # Optional: extra arguments.
    log:
        "logs/{sample}/bwa_mem_reads_to_assemblies/{sample}.samtools_stats.log",
    wrapper:
        "v3.8.0/bio/samtools/stats"
