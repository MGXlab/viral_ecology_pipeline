import sys

def process_fasta(input_file, output_file, sample_name):
    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        for line in infile:
            if line.startswith('>'):
                # Replace spaces and colons with underscores and add sample name
                new_header = f">{sample_name}_" + line[1:].replace(' ', '_').replace(':', '_')
                outfile.write(new_header)
            else:
                outfile.write(line)

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python script.py input.fasta output.fasta sample_name")
    else:
        input_file = sys.argv[1]
        output_file = sys.argv[2]
        sample_name = sys.argv[3]
        process_fasta(input_file, output_file, sample_name)
