from Bio import SeqIO
import pandas as pd

# Specify the path to your GenBank file
genbank_file = "/net/phage/linuxhome/mgx/people/jose/lingyi/almond_snakemake/combined_results/megapharokka_output/seqs0/pharokka.gbk"

# Lists to store the extracted LOCUS and VERSION values
data = []

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

    # # Print the extracted LOCUS and VERSION
    # print(f"LOCUS: {locus}, VERSION: {version}")
# Create a DataFrame from the data
df = pd.DataFrame(data, columns=["LOCUS", "VERSION"])
# Optionally, you can store the extracted values in a data structure or write them to a file

