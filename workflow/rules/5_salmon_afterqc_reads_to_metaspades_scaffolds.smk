rule salmon_quant:
    input:
        afterqc_reads=["results/{sample}/remove_host_reads/{sample}_1.remove_host_reads.fastq.gz", "results/{sample}/remove_host_reads/{sample}_2.remove_host_reads.fastq.gz"],
    output:
        "results/{sample}/salmon_all_metaspades_scaffolds/quant.sf"
    conda:
        "../envs/salmon.yaml"
    log:
        "logs/{sample}/salmon/{sample}.salmon_all_metaspades_scaffolds.log"
    threads:
        config["SALMON"]["threads"]
    params:
        salmon_index = config["SALMON"]["salmon_index_directory"],
        salmon_direcotry = "results/{sample}/salmon_all_metaspades_scaffolds"
    shell:
        "salmon quant -i {params.salmon_index} -l A "
        "-1 {input.afterqc_reads[0]} "
        "-2 {input.afterqc_reads[1]} "
        "-p {threads} "
        "--validateMappings "
        "-o {params.salmon_directory} "
        "--minAssignedFrags 0 "
        "2> {log}"

rule extract_salmon_num_reads:
    input:
        "results/{sample}/salmon_all_metaspades_scaffolds/quant.sf"
    output:
        "results/{sample}/salmon_all_metaspades_scaffolds/{sample}.salmon_num_reads.txt"
    log:
        "logs/{sample}/extract_salmon_NumReads/{sample}.extract_salmon_NumReads.log",
    params:
        script = "workflow/scripts/extract_salmon_NumReads.py",
        sample_id=lambda wildcards: wildcards.sample,
    threads:
        48
    shell:
        "python3.8 {params.script} {input} {output} {params.sample_id} -t {threads} &>{log}"

rule join_files:
    input:
        "results/{sample}/salmon_all_metaspades_scaffolds/{sample}.salmon_num_reads.txt"
    output:
        "combined_results/salmon_num_reads_merged_file.txt"
    run:
        import pandas as pd
        
        # Load the first file as the base DataFrame
        base_df = pd.read_csv(input[0])
        
        # Iterate over the remaining files and left join them based on "Name"
        for file in input[1:]:
            df = pd.read_csv(file)
            base_df = base_df.merge(df, on="Name", how="left")
        
        # Save the final joined DataFrame to the output file
        base_df.to_csv(output[0], index=False)