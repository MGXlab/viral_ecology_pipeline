rule salmon_index:
    input:
        jaeger_virus = config["SALMON"]["jaeger_virus_fna"],
    output:
        salmon_index = directory(config["SALMON"]["salmon_index_directory"])
    conda:
        "../envs/salmon.yaml"
    log:
        "logs/salmon_index/salmon_index.log"
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
        salmon_index = config["SALMON"]["salmon_index_directory"]
    shell:
        "salmon quant -i {params.salmon_index} -l A "
        "-1 {input[0]} "
        "-2 {input[1]} "
        "-p {threads} "
        "--validateMappings "
        "-o {output.salmon_quant} "
        "2> {log}"
