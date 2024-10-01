import pandas as pd
import numpy as np
import sys

def normalize_salmon_counts(input_file, output_file):
    # Load the merged file
    df = pd.read_csv(input_file)

    # Add the lengths of contigs to the df
    df['Length'] = df['Name'].str.extract(r'length_(\d+)_cov').astype(int)
    print('Lengths type is', df['Length'].dtype)
    print('Lengths added to the DataFrame')

    # Convert the lengths to effective lengths
    df['EffectiveLength'] = np.log10(df['Length'])
    print('EffectiveLengths added to the DataFrame')

    # Normalize the counts by the effective lengths, excluding the "Name" column, and keep two decimal places
    df_normalized = df.iloc[:, 1:].div(df['EffectiveLength'], axis=0).round(2)
    print('Data normalized by EffectiveLength')

    # Remove the "Length" and "EffectiveLength" columns
    df_normalized = df_normalized.drop(columns=['Length', 'EffectiveLength'])
    print('Length and EffectiveLength columns removed')

    # Add the "Name" column back to the DataFrame
    df_normalized.insert(0, 'Name', df['Name'])

    # Save the normalized counts to the output file
    df_normalized.to_csv(output_file, index=False)
    print('Normalized counts saved to the output file')

# Get the input and output file paths from the command-line arguments
infile = sys.argv[1]
outfile = sys.argv[2]

# Call the function with the provided arguments
normalize_salmon_counts(infile, outfile)