from Bio import SeqIO
import pandas as pd

# Path to your GenBank file
genbank_file = "/net/phage/linuxhome/mgx/people/jose/lingyi/almond_snakemake/combined_results/phold_output/seqs0"

# List to store sequence ID and product pairs
data = []

# Parse the GenBank file
for record in SeqIO.parse(genbank_file, "genbank"):
    # Get the sequence ID
    sequence_id = record.id

    # Iterate through features in the record
    for feature in record.features:
        # Check if the feature is a CDS (Coding Sequence) or any feature that might have a product
        if feature.type == "CDS":
            # Extract the product information
            if "product" in feature.qualifiers:
                products = feature.qualifiers["product"]
                # Add each product along with the sequence ID to the data list
                for product in products:
                    data.append([sequence_id, product])

# Create a DataFrame from the data
df = pd.DataFrame(data, columns=["Sequence", "Product"])

# Optionally, save the DataFrame to a CSV file
df.to_csv("/net/phage/linuxhome/mgx/people/jose/lingyi/almond_snakemake/combined_results/phold_gbk_product/seqs0_products.csv", index=False)
