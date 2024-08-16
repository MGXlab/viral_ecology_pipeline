import sys
import pandas as pd

def extract_jaeger_virus_id(infile, outfile):
    # Read the input file into a DataFrame
    df = pd.read_csv(infile, sep='\t')

    # Extract only the columns with headers "name" and rename "NumReads" to the input file name
    selected_columns = df[['Name', 'NumReads']]

    # Write the selected columns to a new file in the output folder
    selected_columns.to_csv(outfile, sep='\t', index=False)

infile = sys.argv[1]
outfile = sys.argv[2]
extract_jaeger_virus_id(infile, outfile)