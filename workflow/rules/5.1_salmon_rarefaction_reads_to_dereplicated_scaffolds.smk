samples_df = samplesheet_to_df(sample_config['samplesheet'])
SAMPLES = samples_df['sample_id'].values.tolist()

rule salmon_quant:
    input:
        rarefaction_reads=["results/{sample}/rarefaction_reads/{sample}_1.rarefaction_reads.fastq", "results/{sample}/rarefaction_reads/{sample}_2.rarefaction_reads.fastq"],
    output:
        "results/{sample}/salmon/quant.sf"
    conda:
        "../envs/salmon.yaml"
    log:
        "logs/{sample}/salmon/{sample}.salmon.log"
    threads:
        config["SALMON"]["threads"]
    params:
        salmon_index = config["SALMON"]["salmon_index_directory"],
        salmon_directory = "results/{sample}/salmon"
    shell:
        "salmon quant -i {params.salmon_index} -l A "
        "-1 {input.rarefaction_reads[0]} "
        "-2 {input.rarefaction_reads[1]} "
        "-p {threads} "
        "--validateMappings "
        "-o {params.salmon_directory} "
        "--minAssignedFrags 0 "
        "2> {log}"
