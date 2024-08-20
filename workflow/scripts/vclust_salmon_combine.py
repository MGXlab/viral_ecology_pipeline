import pandas as pd
import sys

def vclust_salmon_genera_merge(vclust_file, salmon_normalized_file, vclust_drep_abundance_file):
    
    # load the vclust file
    vclust_df = pd.read_csv(vclust_file, sep = '\t')
    
    # load the salmon_normalized file
    salmon_normalized_df = pd.read_csv(salmon_normalized_file)
    
    # merge the vclust_df and salmon_normalized_df based on "contig_id" column in vclust_df
    merged_df = pd.merge(vclust_df, salmon_normalized_df, left_on="contig_id", right_on="contig_id", how="left")

    # remove the "contig_id" and "genera_id" columns from the merged_df
    merged_df = merged_df.drop(columns=["contig_id", "genera_id"])

    # group the merged_df by "genera_drep_id" and sum the values
    merged_df = merged_df.groupby("genera_drep_id").sum()

    # save the merged_df to the output file
    merged_df.to_csv(vclust_drep_abundance_file, sep=',')

# Get the input and output file paths from the command-line arguments
vclust_file = sys.argv[1]
salmon_normalized_file = sys.argv[2]
vclust_drep_abundance_file = sys.argv[3]

# Call the function with the provided arguments
vclust_salmon_genera_merge(vclust_file, salmon_normalized_file , vclust_drep_abundance_file)