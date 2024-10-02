samples_df = samplesheet_to_df(config['samplesheet'])
SAMPLES = samples_df['sample_id'].values.tolist()

rule salmon_quant:
    input:
        afterqc_reads=["results/qc_reads/{sample}/{sample}_1.remove_host_reads.fastq.gz", "results/qc_reads/{sample}/{sample}_2.remove_host_reads.fastq.gz"],
    output:
        "results/salmon/{sample}/quant.sf"
    conda:
        "../envs/salmon.yaml"
    log:
        "logs/{sample}/salmon/{sample}.salmon_all_metaspades_scaffolds.log"
    threads:
        config["SALMON"]["threads"]
    params:
        salmon_index = config["SALMON"]["salmon_index_directory"],
        salmon_directory = "results/salmon/{sample}"
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
        "results/salmon/{sample}/quant.sf"
    output:
        "results/salmon_reads/{sample}/{sample}.salmon_num_reads.txt"
    log:
        "logs/{sample}/extract_salmon_NumReads/{sample}.extract_salmon_NumReads.log",
    params:
        script = "workflow/scripts/python/extract_salmon_NumReads.py",
        sample_id=lambda wildcards: wildcards.sample,
    threads:
        48
    shell:
        "python3.8 {params.script} {input} {output} {params.sample_id} -t {threads} &>{log}"

rule merge_salmon_NumReads:
    input:
        expand("results/salmon_reads/{sample}/{sample}.salmon_num_reads.txt", sample=SAMPLES)
    output:
        "results/salmon_combined/salmon_num_reads_merged_file.csv"
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
        
        # Rename the column "Name" to "contig_id"
        base_df = base_df.rename(columns={"Name": "contig_id"})

        # Save the final joined DataFrame to the output file
        base_df.to_csv(output[0], index=False)

rule normalize_salmon_counts:
    input:
        "results/salmon_combined/salmon_num_reads_merged_file.csv"
    output:
        "results/salmon_combined/salmon_num_reads_normalized.csv"
    run:
        import pandas as pd
        import numpy as np

        # Load the merged file
        df = pd.read_csv(input[0])

        # Add the lengths of contigs to the df
        df['Length'] = df['contig_id'].str.extract(r'length_(\d+)_cov').astype(int)
        print('Lengths type is', df['Length'].dtype)
        print('Lengths added to the DataFrame')

        # Convert the lengths to effective lengths
        df['EffectiveLength'] = np.log10(df['Length'])
        print('EffectiveLengths added to the DataFrame')

        # Normalize the counts by the effective lengths, excluding the "contig_id" column, and keep two decimal places
        df_normalized = df.iloc[:, 1:].div(df['EffectiveLength'], axis=0).round(2)
        print('Data normalized by EffectiveLength')

        # Remove the "Length" and "EffectiveLength" columns
        df_normalized = df_normalized.drop(columns=['Length', 'EffectiveLength'])
        print('Length and EffectiveLength columns removed')
        
        # Add the "contig_id" column back to the DataFrame
        df_normalized.insert(0, 'contig_id', df['contig_id'])

        # Save the normalized counts to the output file
        df_normalized.to_csv(output[0], index=False)
        print('Normalized counts saved to the output file')

rule combine_jaeger_salmon_counts:
    input:
        salmon_counts = "results/salmon_combined/salmon_num_reads_normalized.csv",
        jaeger_virus_headers = '/net/phage/linuxhome/mgx/people/lingyi/gradient_virome/gut/gut_per_sample_metaspades_vclust_20240924/jaeger/gut_jaeger_virus_contig_ids.txt',
    output:
        "results/salmon_combined/jaeger_virus_salmon_num_reads_normalized.csv"
    run:
        import pandas as pd
        import numpy as np

        # Load the files
        salmon_df = pd.read_csv(input.salmon_counts)
        jaeger_df = pd.read_csv(input.jaeger_virus_headers, header=None, names=['contig_id'])
        
        # Left join jaeger_df with salmon_df based on "contig_id", discard rows with no matching "contig_id"
        combined_df = jaeger_df.merge(salmon_df, on="contig_id", how="inner")
        print('Combined jaeger and salmon data')

        # Save the combined DataFrame to the output file
        combined_df.to_csv(output[0], index=False)
        print('Combined jaeger and salmon data saved to the output file')

rule combine_vclust_jaeger_salmon_counts:
    input:
        salmon_counts = "results/salmon_combined/jaeger_virus_salmon_num_reads_normalized.csv",
        vclust_f = '/net/phage/linuxhome/mgx/people/lingyi/gradient_virome/gut/gut_per_sample_metaspades_vclust_20240924/vclust_drep/vclust_drep_genera_contig_id.txt',
    output:
        "results/salmon_combined/genera_salmon_num_reads_normalized.csv"
    run:
        import pandas as pd
        import numpy as np

        # Load the files
        salmon_df = pd.read_csv(input.salmon_counts)
        print(salmon_df.head())
        vclust_df = pd.read_csv(input.vclust_f, delimiter='\t')
        print(vclust_df.head())
        
        # Left join vclust_df with salmon_df based on "contig_id"
        combined_df = vclust_df.merge(salmon_df, on="contig_id", how="left")
        print('Combined vclust and salmon data')

        # Remove the "contig_id" column from the combined DataFrame
        combined_df = combined_df.drop(columns=['contig_id'])

        # Group the combined DataFrame by genera and sum the normalized counts
        combined_df = combined_df.groupby('genera').sum().reset_index()

        # Save the combined DataFrame to the output file
        combined_df.to_csv(output[0], index=False)
        print('Combined vclust and salmon data saved to the output file')