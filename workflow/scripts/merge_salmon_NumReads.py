import pandas as pd
import os
import sys

def merge_files(input_files, output_file):
    merged_df = None
    
    for infile in input_files:
        # Extract sample name from the filename
        sample_name = os.path.basename(infile).split('.')[0]
        
        # Read the CSV file
        df = pd.read_csv(infile, sep='\t')  # Adjust the separator if needed
        
        # Rename the 'NumReads' column to the sample name
        df = df.rename(columns={'NumReads': sample_name})
        
        # Merge the DataFrame
        if merged_df is None:
            merged_df = df
        else:
            merged_df = pd.merge(merged_df, df, on="Name")
    
    # Save the final merged DataFrame to the output file
    merged_df.to_csv(output_file, index=False)

if __name__ == "__main__":
    # Expect input and output file paths as command line arguments
    input_files = sys.argv[1].split(',')
    output_file = sys.argv[2]
    merge_files(input_files, output_file)
