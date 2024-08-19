import pandas as pd
import os
import sys

def extract_salmon_num_reads(infile, outfile):
    # Get the base name of the input file without the extension
    base_name = os.path.splitext(os.path.basename(infile))[0]

    # Read the input file into a DataFrame
    df = pd.read_csv(infile, sep='\t')

    # Extract the "Name" and "NumReads" columns
    selected_columns = df[['Name', 'NumReads']]

    # Rename the "NumReads" column to the base name of the input file
    selected_columns.rename(columns={'NumReads': base_name}, inplace=True)

    # Write the selected columns to a new file in the output folder
    selected_columns.to_csv(outfile, sep='\t', index=False)

# Get the input and output file paths from the command-line arguments
infile = sys.argv[1]
outfile = sys.argv[2]

# Call the function with the provided arguments
extract_salmon_num_reads(infile, outfile)
