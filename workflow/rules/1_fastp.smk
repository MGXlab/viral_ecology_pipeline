rule fastp:
    input:
        fqs = get_sample_fastqs
    output:
        paired_1 = "results/fastp/{sample}/{sample}_1.clean_paired.fastq.gz",
        paired_2 = "results/fastp/{sample}/{sample}_2.clean_paired.fastq.gz",
        unpaired_1 = "results/fastp/{sample}/{sample}_1.clean_unpaired.fastq.gz",
        unpaired_2 = "results/fastp/{sample}/{sample}_2.clean_unpaired.fastq.gz",
        html = "results/fastp/{sample}/{sample}.fastp.html",
        json = "results/fastp/{sample}/{sample}.fastp.json"
    log:
        "logs/fastp/{sample}/{sample}.fastp.log"
    threads:
        config["FASTP"]["threads"]
#    conda:
#       "../envs/fastp.yaml"
    shell:
        "source /home/groups/VEO/tools/anaconda3/etc/profile.d/conda.sh "
        "conda activate fastp_v0.23.4 "
        "fastp -i {input[0]} -I {input[1]} "
        "-o {output.paired_1} -O {output.paired_2} "
        "--unpaired1 {output.unpaired_1} --unpaired2 {output.unpaired_2} "
        "--html {output.html} --json {output.json} "
        "--dedup --detect_adapter_for_pe "
        "&> {log}"

