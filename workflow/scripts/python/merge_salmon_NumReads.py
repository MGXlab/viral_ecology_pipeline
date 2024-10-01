import pandas as pd
import sys

def merge_files_on_name(input_files, output_file):
    """
    Merges multiple TSV files based on the "Name" column.

    Parameters:
    input_files (list of str): List of input file paths.
    output_file (str): Path to save the merged output file.

    Returns:
    Saving the output file to the specified path.
    """
    # Load the first file as the base DataFrame
    base_df = pd.read_csv(input_files[0], delimiter='\t')
    print(f"Columns in {input_files[0]}: {base_df.columns.tolist()}")

    # Iterate over the remaining files and left join them based on "Name"
    for file in input_files[1:]:
        df = pd.read_csv(file, delimiter='\t')
        print(f"Columns in {file}: {df.columns.tolist()}")
        base_df = base_df.merge(df, on="Name", how="left")

    # Save the final joined DataFrame to the output file
    base_df.to_csv(output_file, index=False)
    print(f"Merged DataFrame saved to {output_file}")

# Get the input and output file paths from the command-line arguments
infile = sys.argv[1]
outfile = sys.argv[2]

# Call the function with the provided arguments
merge_files_on_name(infile, outfile)
