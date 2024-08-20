samples_df = samplesheet_to_df(config['samplesheet'])
SAMPLES = samples_df['sample_id'].values.tolist()

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

rule join_salmon_files:
    input:
        expand("results/{sample}/salmon_all_metaspades_scaffolds/{sample}.salmon_num_reads.txt", sample=SAMPLES)
    output:
        "combined_results/salmon/salmon_num_reads_merged_file.txt"
    run:
        import pandas as pd
        
        # Load the first file as the base DataFrame
        base_df = pd.read_csv(input[0], delimiter='\t')
        print(f"Columns in {input[0]}: {base_df.columns.tolist()}")

        # Iterate over the remaining files and left join them based on "Name"
        for file in input[1:]:
            df = pd.read_csv(file, delimiter='\t')
            print(f"Columns in {file}: {df.columns.tolist()}")
            base_df = base_df.merge(df, on="Name", how="left")
        
        # # Rename the column "Name" to "contig_id"
        # base_df = base_df.rename(columns={"Name": "contig_id"})

        # Save the final joined DataFrame to the output file
        base_df.to_csv(output[0], index=False)

rule normalize_salmon_counts:
    input:
        "combined_results/salmon/salmon_num_reads_merged_file.txt"
    output:
        "combined_results/salmon/salmon_num_reads_normalized.txt"
    run:
        import pandas as pd
        import numpy as np

        # Load the merged file
        df = pd.read_csv(input[0])

        # Add the lengths of contigs to the df
        df['Length'] = df['Name'].str.extract(r'length_(\d+)_cov').astype(int)
        print('Lengths type is 'df['Length'].dtype)
        print('Lengths added to the DataFrame')
        # Convert the lengths to effective lengths
        df['EffectiveLength'] = np.log10(df['Length'])
        print('EffectiveLengths added to the DataFrame')
        # Normalize the counts by the effective lengths
        df_normalized = df.div(df['EffectiveLength'], axis=0)

        # Remove the "Length" and "EffectiveLength" columns
        df_normalized = df_normalized.drop(columns=['Length', 'EffectiveLength'])

        # Save the normalized counts to the output file
        df_normalized.to_csv(output[0], index=False)