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

    # Parse the GenBank file
    for record in SeqIO.parse(genbank_file, "genbank"):
        # Extract LOCUS (which is the ID of the sequence record)
        locus = record.name
        # Extract VERSION (stored in the annotations dictionary)
        version = record.annotations.get("accessions", ["No VERSION available"])[0]  # Default to first accession
        if "sequence_version" in record.annotations:
            version += "." + str(record.annotations["sequence_version"])

            # Append the values to a list
            for loc, ver in zip(locus, version):
                data.append([loc, ver])

    # Create a DataFrame from the data
    df = pd.DataFrame(data, columns=["LOCUS", "VERSION"])

    # Append the new DataFrame to the overall DataFrame
    df_all = pd.concat([df_all, df], axis=0, ignore_index=True)
    print(f"{genbank_file} results is added to the DataFrame")

# Now, df_all contains the data from all the iterations
# save the DataFrame to a CSV file
df_all.to_csv("/net/phage/linuxhome/mgx/people/jose/lingyi/almond_snakemake/combined_results/magapharokka_gbk_locus_version/almond_magapharokka_gbk_locus_version.csv", index=False)