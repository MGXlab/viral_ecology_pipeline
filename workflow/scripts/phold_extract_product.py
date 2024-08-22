from Bio import SeqIO
import pandas as pd

# Path to your GenBank file
genbank_file = "/net/phage/linuxhome/mgx/people/jose/lingyi/almond_snakemake/combined_results/phold_output/seqs0/phold.gbk"

# Dictionary to store product presence for each sequence
sequence_products = {}

# Parse the GenBank file
for record in SeqIO.parse(genbank_file, "genbank"):
    # Initialize a set to store products for the current sequence
    products_set = set()

    # Iterate through features in the record
    for feature in record.features:
        # Check if the feature is a CDS (Coding Sequence) or any feature that might have a product
        if feature.type == "CDS":
            # Extract the product information
            if "product" in feature.qualifiers:
                products = feature.qualifiers["product"]
                # Add each product to the set for this sequence
                products_set.update(products)

    # Store the products for this sequence in the dictionary
    sequence_products[record.id] = products_set

# Extract a sorted list of all unique products across all sequences
all_products = sorted(set(product for products in sequence_products.values() for product in products))

# Create a DataFrame with sequences as rows and products as columns
df = pd.DataFrame(0, index=sequence_products.keys(), columns=all_products)

# Populate the DataFrame with 1 where a product is present
for sequence, products in sequence_products.items():
    for product in products:
        df.at[sequence, product] = 1

# Optionally, save the DataFrame to a CSV file
df.to_csv("/net/phage/linuxhome/mgx/people/jose/lingyi/almond_snakemake/combined_results/phold_gbk_product/seqs0_products.csv")
