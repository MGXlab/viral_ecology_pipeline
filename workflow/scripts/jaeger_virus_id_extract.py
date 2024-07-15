import pandas as pd
import sys

def extract_jaeger_virus_id(infile, outfile):
    # Load the data into a DataFrame
    df = pd.read_csv(infile, sep='\t')

    # Filter rows where Phage_score is the highest among the four scores and where reliability_score is at least 0.2
    filtered_df = df[(df['Phage_score'] > df['Bacteria_score']) & 
                     (df['Phage_score'] > df['Eukarya_score']) & 
                     (df['Phage_score'] > df['Archaea_score']) &
                     (df['length'] >= 10000) &
                     (df['realiability_score'] >= 0.2)]

    # Extract the contig_id of the filtered rows
    result = filtered_df['contig_id']

    # Save the result to a file
    result.to_csv(outfile, sep = '\t', header = False, index = False)

infile = sys.argv[1]
outfile = sys.argv[2]
extract_jaeger_virus_id(infile, outfile)
