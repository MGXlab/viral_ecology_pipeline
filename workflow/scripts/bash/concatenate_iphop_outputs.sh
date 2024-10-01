# Define the base directory and output file
base_dir="/net/phage/linuxhome/mgx/people/lingyi/gradient_virome/almond/almond_20240903/combined_results/abundant_genera/iphop_output"
output_file="/net/phage/linuxhome/mgx/people/lingyi/gradient_virome/almond/almond_20240903/combined_results/abundant_genera/iphop_output/concatenated_outputs/concatenated_Detailed_output_by_tool.csv"

# Find all files matching the pattern and store them in an array
files=(${base_dir}/seqs*/Detailed_output_by_tool.csv)

# Check if any files were found
if [ ${#files[@]} -eq 0 ]; then
    echo "No files found matching the pattern ${base_dir}/seqs*/Detailed_output_by_tool.csv"
    exit 1
fi

# Extract the header from the first file
head -n 1 "${files[0]}" > "$output_file"

# Loop through all files and append the content (excluding headers) to the output file
for file in "${files[@]}"; do
    tail -n +2 "$file" >> "$output_file"
done

echo "Concatenation complete. Output saved to $output_file."
