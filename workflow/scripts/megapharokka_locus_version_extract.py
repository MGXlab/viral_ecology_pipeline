from Bio import SeqIO

# Specify the path to your GenBank file
genbank_file = "/net/phage/linuxhome/mgx/people/jose/lingyi/almond_snakemake/combined_results/megapharokka_output/seqs0/pharokka.gbk"

# Lists to store the extracted LOCUS and VERSION values
locus_list = []
version_list = []

# Parse the GenBank file
for record in SeqIO.parse(genbank_file, "genbank"):
    # Extract LOCUS (which is the ID of the sequence record)
    locus = record.name

    # Extract VERSION (stored in the annotations dictionary)
    version = record.annotations.get("accessions", ["No VERSION available"])[0]  # Default to first accession
    if "sequence_version" in record.annotations:
        version += "." + str(record.annotations["sequence_version"])

    # Append the values to the respective lists
    locus_list.append(locus)
    version_list.append(version)

    # Print the extracted LOCUS and VERSION
    print(f"LOCUS: {locus}, VERSION: {version}")

# Optionally, you can store the extracted values in a data structure or write them to a file
