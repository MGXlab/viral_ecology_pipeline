rule remove_contaminants:
    input:
        fq1 = "../data/{fractions}/{samples}/{samples}_1.fastq.gz",
        fq2 = "../data/{fractions}/{samples}/{samples}_2.fastq.gz"
    output:
        contamination_log = "../logs/bbduk/{samples}_contamination.log",
        fq1_bbduk_unmatched = "../tmp/bbduk/{samples}_1_bbduk_unmatched.fastq.gz",
        fq2_bbduk_unmatched = "../tmp/bbduk/{samples}_2_bbduk_unmatched.fastq.gz",
        fq1_bbduk_matched = "../tmp/bbduk/{samples}_1_bbduk_matched.fastq.gz",
        fq2_bbduk_matched = "../tmp/bbduk/{samples}_2_bbduk_matched.fastq.gz"
    log:
        "../logs/bbduk/{samples}.log"
    threads:
        config["BBDUK"]["threads"]
    params:
        ref =  config["BBDUK"]["ref"],
        k = config["BBDUK"]["k"],
        hdist = config["BBDUK"]["hdist"],
    conda:
        "../envs/trimming.yaml"
    shell:
        "bbduk.sh in={input.fq1} out={output.fq1_bbduk_unmatched} outm={output.fq1_bbduk_matched} "
                "in2={input.fq2} out2={output.fq2_bbduk_unmatched} outm2={output.fq2_bbduk_matched} "
                "ref={params.ref} threads={threads} "
                "k={params.k} "
                "hdist={params.hdist} "
                "stats={output.contamination_log} overwrite=t "
                "2> {log}"

rule virus_remove_duplicates:
    input:
        rules.virus_remove_contaminants.output.virus_fq1_bbduk_unmatched,
        rules.virus_remove_contaminants.output.virus_fq2_bbduk_unmatched
    output:
        virus_fq1_duplicates_removed = "../tmp/clumpify/{virus_sample}_1_clumpify_duplicates_removed.fastq.gz",
        virus_fq2_duplicates_removed = "../tmp/clumpify/{virus_sample}_2_clumpify_duplicates_removed.fastq.gz"
    log:
        "../logs/clumpify/{virus_sample}.log"
    threads:
        config["CLUMPIFY"]["threads"]
    conda:
        "../envs/trimming.yaml"
    shell:
        "clumpify.sh "
        "in1={input[0]} in2={input[1]} "
        "out1={output[0]} out2={output[1]} "
        "reorder "
        "2> {log}"

rule virus_trim_adapters:
    input:
        rules.virus_remove_duplicates.output.virus_fq1_duplicates_removed,
        rules.virus_remove_duplicates.output.virus_fq2_duplicates_removed
    output:
        virus_fq1_adapter_removed_paired = "../tmp/trimmomatic/{virus_sample}_1_trimmomatic_adapter_removed_paired.fastq.gz",
        virus_fq1_adapter_removed_unpaired = "../tmp/trimmomatic/{virus_sample}_1_trimmomatic_adapter_removed_unpaired.fastq.gz",
        virus_fq2_adapter_removed_paired = "../tmp/trimmomatic/{virus_sample}_2_trimmomatic_adapter_removed_paired.fastq.gz",
        virus_fq2_adapter_removed_unpaired = "../tmp/trimmomatic/{virus_sample}_2_trimmomatic_adapter_removed_unpaired.fastq.gz"
    log:
        "../logs/trimmomatic/{virus_sample}.log"
    threads:
        config["TRIMMOMATIC"]["threads"]
    params:
        adapter_seq = config["TRIMMOMATIC"]["adapter_seq"]
    conda:
        "../envs/trimming.yaml"
    shell:
        "java -jar scripts/trimmomatic-0.36.jar PE "
        "-threads {threads} "
        "{input[0]} "
        "{input[1]} "
        "{output[0]} "
        "{output[1]} "
        "{output[2]} "
        "{output[3]} "
        "ILLUMINACLIP:{params.adapter_seq}:2:30:10 MINLEN:40 "
        "2> {log}"

rule microbe_remove_contaminants:
    input:
        microbe_fq1 = "../data/fecal_microbe/{microbe_sample}/{microbe_sample}_1.fastq.gz",
        microbe_fq2 = "../data/fecal_microbe/{microbe_sample}/{microbe_sample}_2.fastq.gz"
    output:
        microbe_contamination_log = "../logs/bbduk/{microbe_sample}_contamination.log",
        microbe_fq1_bbduk_unmatched = "../tmp/bbduk/{microbe_sample}_1_bbduk_unmatched.fastq.gz",
        microbe_fq2_bbduk_unmatched = "../tmp/bbduk/{microbe_sample}_2_bbduk_unmatched.fastq.gz",
        microbe_fq1_bbduk_matched = "../tmp/bbduk/{microbe_sample}_1_bbduk_matched.fastq.gz",
        microbe_fq2_bbduk_matched = "../tmp/bbduk/{microbe_sample}_2_bbduk_matched.fastq.gz"
    log:
        "../logs/bbduk/{microbe_sample}.log"
    threads:
        config["BBDUK"]["threads"]
    params:
        ref =  config["BBDUK"]["ref"],
        k = config["BBDUK"]["k"],
        hdist = config["BBDUK"]["hdist"],
    conda:
        "../envs/trimming.yaml"
    shell:
        "bbduk.sh in={input.microbe_fq1} out={output.microbe_fq1_bbduk_unmatched} outm={output.microbe_fq1_bbduk_matched} "
                "in2={input.microbe_fq2} out2={output.microbe_fq2_bbduk_unmatched} outm2={output.microbe_fq2_bbduk_matched} "
                "ref={params.ref} threads={threads} "
                "k={params.k} "
                "hdist={params.hdist} "
                "stats={output.microbe_contamination_log} overwrite=t "
                "2> {log}"

rule microbe_remove_duplicates:
    input:
        rules.microbe_remove_contaminants.output.microbe_fq1_bbduk_unmatched,
        rules.microbe_remove_contaminants.output.microbe_fq2_bbduk_unmatched
    output:
        microbe_fq1_duplicates_removed = "../tmp/clumpify/{microbe_sample}_1_clumpify_duplicates_removed.fastq.gz",
        microbe_fq2_duplicates_removed = "../tmp/clumpify/{microbe_sample}_2_clumpify_duplicates_removed.fastq.gz"
    log:
        "../logs/clumpify/{microbe_sample}.log"
    threads:
        config["CLUMPIFY"]["threads"]
    conda:
        "../envs/trimming.yaml"
    shell:
        "clumpify.sh "
        "in1={input[0]} in2={input[1]} "
        "out1={output[0]} out2={output[1]} "
        "reorder "
        "2> {log}"

rule microbe_trim_adapters:
    input:
        rules.microbe_remove_duplicates.output.microbe_fq1_duplicates_removed,
        rules.microbe_remove_duplicates.output.microbe_fq2_duplicates_removed
    output:
        microbe_fq1_adapter_removed_paired = "../tmp/trimmomatic/{microbe_sample}_1_trimmomatic_adapter_removed_paired.fastq.gz",
        microbe_fq1_adapter_removed_unpaired = "../tmp/trimmomatic/{microbe_sample}_1_trimmomatic_adapter_removed_unpaired.fastq.gz",
        microbe_fq2_adapter_removed_paired = "../tmp/trimmomatic/{microbe_sample}_2_trimmomatic_adapter_removed_paired.fastq.gz",
        microbe_fq2_adapter_removed_unpaired = "../tmp/trimmomatic/{microbe_sample}_2_trimmomatic_adapter_removed_unpaired.fastq.gz"
    log:
        "../logs/trimmomatic/{microbe_sample}.log"
    threads:
        config["TRIMMOMATIC"]["threads"]
    params:
        adapter_seq = config["TRIMMOMATIC"]["adapter_seq"]
    conda:
        "../envs/trimming.yaml"
    shell:
        "java -jar scripts/trimmomatic-0.36.jar PE "
        "-threads {threads} "
        "{input[0]} "
        "{input[1]} "
        "{output[0]} "
        "{output[1]} "
        "{output[2]} "
        "{output[3]} "
        "ILLUMINACLIP:{params.adapter_seq}:2:30:10 MINLEN:40 "
        "2> {log}"
