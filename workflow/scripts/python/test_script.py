import glob
from Bio import SeqIO
import pandas as pd

# Initialize an empty DataFrame to store all results
df_all = pd.DataFrame(columns=["LOCUS", "VERSION"])

for file in glob.glob("/net/phage/linuxhome/mgx/people/jose/lingyi/almond_snakemake/combined_results/megapharokka_output/*/pharokka.gbk"):
    genbank_file = file
    print(f"Processing {genbank_file}")
    # List to store sequence ID and product pairs
    data = []

    print("create a emtpy list to store the extracted LOCUS and VERSION values")
    # Parse the GenBank file
    for record in SeqIO.parse(genbank_file, "genbank"):
        # Extract LOCUS (which is the ID of the sequence record)
        locus = record.name

        # Extract VERSION (stored in the annotations dictionary)
        version = record.annotations.get("accessions", ["No VERSION available"])[0]  # Default to first accession
        if "sequence_version" in record.annotations:
            version += "." + str(record.annotations["sequence_version"])

        # Append the values to the respective lists
        data.append([locus, version])
        
    # Create a DataFrame from the data
    df = pd.DataFrame(data, columns=["LOCUS", "VERSION"])
    print("create a DataFrame from the data")

     # Append the new DataFrame to the overall DataFrame
    df_all = pd.concat([df_all, df], axis=0, ignore_index=True)
    print(f"{genbank_file} results is added to the DataFrame")

# Write the DataFrame to a CSV file
df_all.to_csv("/net/phage/linuxhome/mgx/people/jose/lingyi/almond_snakemake/combined_results/megapharokka_gbk_locus_version/almond_megapharokka_gbk_locus_version.csv", index=False)
print("write the DataFrame to a CSV file")
