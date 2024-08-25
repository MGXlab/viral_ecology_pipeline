import pandas as pd

phold_products_f = '/net/phage/linuxhome/mgx/people/jose/lingyi/almond_snakemake/combined_results/phold_gbk_product/almond_phold_products.csv'
phold_products_df = pd.read_csv(phold_products_f, sep=",")
print('phold_products_df is loaded')
abundance_f = '/net/phage/linuxhome/mgx/people/jose/lingyi/almond_snakemake/combined_results/vclust_salmon/vclust_genera_drep_abundance_gt0_file.csv'
abundance_df = pd.read_csv(abundance_f , sep=",")
print('abundance_df is loaded')

# Merge the two DataFrames on the "Sequence" column from the phold_products_df and 'genera_drep_id' column from the abundance_df
merged_df = pd.merge(phold_products_df, abundance_df, left_on="Sequence", right_on="genera_drep_id", how="left")
print('merged_df is created')
# Save the merged DataFrame to a CSV file
output_file = '/net/phage/linuxhome/mgx/people/jose/lingyi/almond_snakemake/combined_results/phold_gbk_product/almond_phold_products_abundance.csv'
merged_df.to_csv(output_file, index=False)
print(f"Merged DataFrame saved to {output_file}")