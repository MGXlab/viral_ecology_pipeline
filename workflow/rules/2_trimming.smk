rule remove_contaminants:
    input:
        fqs = get_sample_fastqs
    output:
        matched_1 = "results/{fraction}/{sample}/trim/{sample}_1.bbduk_matched.fastq.gz",
        matched_2 = "results/{fraction}/{sample}/trim/{sample}_2.bbduk_matched.fastq.gz",
        unmatched_1 = "results/{fraction}/{sample}/trim/{sample}_1.bbduk_unmatched.fastq.gz",
        unmatched_2 = "results/{fraction}/{sample}/trim/{sample}_2.bbduk_unmatched.fastq.gz",
        stats = "results/{fraction}/{sample}/trim/{sample}.contamination_stats.txt"
    params:
        ref = ','.join(config['BBDUK']['ref']),
        k = config['BBDUK']['k'],
        hdist = config['BBDUK']['hdist'],
    threads: 4
    log:
        "logs/{fraction}/{sample}/trim/{sample}.remove_contaminants.log"
    conda:
        "../envs/trimming.yaml"
    shell:
        "bbduk.sh in={input.fqs[0]} in2={input.fqs[1]} "
        "outm={output.matched_1} outm2={output.matched_2} "
        "out={output.unmatched_1} out2={output.unmatched_2} "
        "stats={output.stats} "
        "threads={threads} "
        "k={params.k} "
        "ref={params.ref} "
        "hdist={params.hdist} "
        "overwrite=t "
        "2>{log}"


rule remove_duplicates:
    input:
        unmatched_1 = rules.remove_contaminants.output.unmatched_1,
        unmatched_2 = rules.remove_contaminants.output.unmatched_2
    output:
        dedup_1 = "results/{fraction}/{sample}/trim/{sample}_1.dedup.fastq.gz",
        dedup_2 = "results/{fraction}/{sample}/trim/{sample}_2.dedup.fastq.gz"
    log:
        "logs/{fraction}/{sample}/trim/{sample}.dedup.log"
    threads: 2
    conda:
        "../envs/trimming.yaml"
    shell:
        "clumpify.sh in1={input.unmatched_1} in2={input.unmatched_2} "
        "out1={output.dedup_1} out2={output.dedup_2} "
        "threads={threads} "
        "reorder "
        "2>{log}"


rule trim_adapters:
    input:
        dedup_1 = rules.remove_duplicates.output.dedup_1,
        dedup_2 = rules.remove_duplicates.output.dedup_2
    output:
        clean_paired_1 = "results/{fraction}/{sample}/trim/{sample}_1.clean_paired.fastq.gz",
        clean_paired_2 = "results/{fraction}/{sample}/trim/{sample}_2.clean_paired.fastq.gz",
        clean_unpaired_1 = "results/{fraction}/{sample}/trim/{sample}_1.clean_unpaired.fastq.gz",
        clean_unpaired_2 = "results/{fraction}/{sample}/trim/{sample}_2.clean_unpaired.fastq.gz",
        summary_txt = "results/{fraction}/{sample}/trim/{sample}.trimmomatic_summary.txt"
    params:
        adapter_seq = config['TRIMMOMATIC']['adapter_seq']
    threads: 4
    log:
        "logs/{fraction}/{sample}/trim/{sample}.trim_adapters.log"
    conda:
        "../envs/trimming.yaml"
    shell:
        "trimmomatic PE "
        "-threads {threads} "
        "-trimlog {log} "
        "-quiet "
        "-summary {output.summary_txt} "
        "{input.dedup_1} {input.dedup_2} "
        "{output.clean_paired_1} {output.clean_unpaired_1} "
        "{output.clean_paired_2} {output.clean_unpaired_2} "
        "ILLUMINACLIP:{params.adapter_seq}:2:30:10 MINLEN:40"
