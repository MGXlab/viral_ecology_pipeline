import pandas as pd

phold_products_f = '/net/phage/linuxhome/mgx/people/jose/lingyi/almond_snakemake/combined_results/phold_gbk_product/almond_phold_products_functions.csv'
phold_products_df = pd.read_csv(phold_products_f, sep=",")
print('phold_products_df is loaded')
abundance_f = '/net/phage/linuxhome/mgx/people/jose/lingyi/almond_snakemake/combined_results/vclust_salmon/vclust_genera_drep_abundance_gt0_file.csv'
abundance_df = pd.read_csv(abundance_f , sep=",")
print('abundance_df is loaded')

# Merge the two DataFrames on the "Sequence" column from the phold_products_df and 'genera_drep_id' column from the abundance_df
merged_df = pd.merge(phold_products_df, abundance_df, left_on="Sequence", right_on="genera_drep_id", how="left")
print('merged_df is created')

# Drop the "genera_drep_id", "Sequence", and "Product" columns
merged_df = merged_df.drop(columns=["genera_drep_id", "Sequence", "Product"])
print('columns "genera_drep_id", "Sequence", and "Product" are dropped')
# Save the merged DataFrame to a CSV file
merged_output_file = '/net/phage/linuxhome/mgx/people/jose/lingyi/almond_snakemake/combined_results/phold_gbk_product/almond_phold_functions_merged_file.csv'
merged_df.to_csv(merged_output_file, index=False)
print(f"Merged output file is saved to {merged_output_file}")

# Group merged DataFrame by "Product" and sum the abundance for each product
grouped_df = merged_df.groupby('Function').sum().reset_index()
print('grouped_df is created')

# Save the grouped DataFrame to a CSV file
grouped_output_file = '/net/phage/linuxhome/mgx/people/jose/lingyi/almond_snakemake/combined_results/phold_gbk_product/almond_phold_functions_abundance_across_samples.csv'
grouped_df.to_csv(grouped_output_file, index=False)
print(f"Grouped output file is saved to {grouped_output_file}")