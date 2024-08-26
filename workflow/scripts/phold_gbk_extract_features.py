from Bio import SeqIO
import pandas as pd

# Path to your GenBank file in a pattern of "/net/phage/linuxhome/mgx/people/jose/lingyi/almond_snakemake/combined_results/phold_output/*/phold.gbk"
import pandas as pd
import glob
from Bio import SeqIO

# Initialize an empty DataFrame to store all results
df_all = pd.DataFrame(columns=["Sequence", "Product"])

for file in glob.glob("/net/phage/linuxhome/mgx/people/jose/lingyi/almond_snakemake/combined_results/phold_output/*/phold.gbk"):
    genbank_file = file
    print(f"Processing {genbank_file}")
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
                product = feature.qualifiers["product"]
                # Extract the function information
                function = feature.qualifiers["function"]
                # Add each product and funcion along with the sequence ID to the data list
                for prod, func in zip(product, function):
                    data.append([sequence_id, prod, func])

    # Create a DataFrame from the data
    df = pd.DataFrame(data, columns=["Sequence", "Product", "Function"])

    # Append the new DataFrame to the overall DataFrame
    df_all = pd.concat([df_all, df], axis=0, ignore_index=True)
    print(f"{genbank_file} results is added to the DataFrame")
# Now, df_all contains the data from all the iterations
# save the DataFrame to a CSV file
df_all.to_csv("/net/phage/linuxhome/mgx/people/jose/lingyi/almond_snakemake/combined_results/phold_gbk_product/almond_phold_products_functions.csv", index=False)
