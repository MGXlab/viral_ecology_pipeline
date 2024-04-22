rule salmon_index:
    input:
        jaeger_virus = "all_results/jaeger/gut_jaeger_virus_contigs.fna",
    output:
        salmon_index = directory("all_results/jaeger/gut_jaeger_virus_salmon_index/")
    conda:
        "../envs/salmon.yaml"
    log:
        "logs/{sample}/salmon/{sample}.salmon_index.log"
    threads:
        config["SALMON"]["threads"]
    params:
    shell:
        "salmon index -t {input} -i {output} "
        "2> {log}"

rule salmon_quant:
    input:
        afterqc_reads=["results/{sample}/remove_host_reads/{sample}_1.remove_host_reads.fastq.gz", "results/{sample}/remove_host_reads/{sample}_2.remove_host_reads.fastq.gz"],
    output:
        salmon_quant=directory("results/{sample}/salmon_jaeger/")
    conda:
        "../envs/salmon.yaml"
    log:
        "logs/{sample}/salmon/{sample}.salmon_count.log"
    threads:
        config["SALMON"]["threads"]
    params:
        contigs_index = "all_results/jaeger/gut_jaeger_virus_salmon_index/",
    shell:
        "salmon quant -i {params.contigs_index} -l A "
        "-1 {input[0]} "
        "-2 {input[1]} "
        "-p {threads} "
        "--validateMappings "
        "-o {output.salmon_quant} "
        "2> {log}"
