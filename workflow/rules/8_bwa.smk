rule bwa_index:
    input:
        scaffolds = rules.length_filter.output.scaffolds_length_filtered,
    output:
        idx = multiext(rules.length_filter.output.scaffolds_length_filtered, ".amb", ".ann", ".bwt", ".pac", ".sa"),
    log:
        "logs/{fraction}/{sample}/bwa_index/{sample}.log",
    params:
        algorithm="bwtsw",
    threads:
        config["SPADES"]["threads"]
    wrapper:
        "v1.7.1/bio/bwa/index"

rule bwa_aln:
    input:
        fastq = "/net/phage/linuxhome/mgx/people/lingyi/virus_id_benchmarking/data/antarctica/{fraction}/{sample}/{sample}_{pair}.fastq.gz",
        idx = multiext(rules.length_filter.output.scaffolds_length_filtered, ".amb", ".ann", ".bwt", ".pac", ".sa"),
    output:
        aln = "results/{fraction}/{sample}/bwa/{sample}_{pair}.sai",
    log:
        "logs/{fraction}/{sample}/bwa_aln/{sample}_{pair}.log",
    params:
        extra="",
    threads:
        config["SPADES"]["threads"]
    wrapper:
        "v1.7.1/bio/bwa/aln"

rule bwa_sampe:
    input:
        fastq = get_sample_fastqs,
        sai = ["results/{fraction}/{sample}/bwa/{sample}_1.sai", "results/{fraction}/{sample}/bwa/{sample}_2.sai"],
        idx = multiext(rules.length_filter.output.scaffolds_length_filtered, ".amb", ".ann", ".bwt", ".pac", ".sa"),
    output:
        bam = "results/{fraction}/{sample}/bwa/{sample}.bam",
    log:
        "logs/{fraction}/{sample}/bwa_sampe/{sample}.log",
    params:
        extra=r"-r '@RG\tID:{sample}\tSM:{sample}'",  # optional: Extra parameters for bwa.
        sort="none",  # optional: Enable sorting. Possible values: 'none', 'samtools' or 'picard'`
        sort_order="queryname",  # optional: Sort by 'queryname' or 'coordinate'
        sort_extra="",  # optional: extra arguments for samtools/picard
    threads:
        config["SPADES"]["threads"]
    wrapper:
        "v1.7.1/bio/bwa/sampe"

rule samtools_sort:
    input:
        rules.bwa_sampe.output.bam,
    output:
        sorted_bam = "results/{fraction}/{sample}/bwa/{sample}.sorted.bam",
    log:
        "logs/{fraction}/{sample}/samtools_sort/{sample}.log",
    params:
        extra="-m 4G",
    threads:
        config["SPADES"]["threads"]
    wrapper:
        "v1.7.1/bio/samtools/sort"

rule samtools_stats:
    input:
        bam = rules.bwa_sampe.output.bam,
    output:
        samtools_stats = "results/{fraction}/{sample}/bwa/{sample}.samtools_stats.txt",
    params:
        extra="",  # Optional: extra arguments.
    log:
        "logs/{fraction}/{sample}/samtools_stats/{sample}.log",
    wrapper:
        "v1.7.1/bio/samtools/stats"
