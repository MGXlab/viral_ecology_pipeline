import os
import argparse
from Bio import SeqIO
from concurrent.futures import ThreadPoolExecutor

def read_headers(headers_file):
    with open(headers_file) as f:
        return set(line.strip().split()[0] for line in f)

def process_chunk(fasta_chunk, headers, output_file):
    with open(output_file, 'w') as out_fasta:
        for record in SeqIO.parse(fasta_chunk, "fasta"):
            if record.id in headers:
                SeqIO.write(record, out_fasta, "fasta")

def extract_sequences(fasta_file, headers_file, output_file, threads):
    headers = read_headers(headers_file)

    # Determine size of chunks
    file_size = os.path.getsize(fasta_file)
    chunk_size = file_size // threads

    # Create temporary directory for chunks
    os.makedirs("chunks", exist_ok=True)

    with open(fasta_file) as fasta:
        futures = []
        with ThreadPoolExecutor(max_workers=threads) as executor:
            for i in range(threads):
                chunk_file = f"chunks/chunk_{i}.fasta"
                with open(chunk_file, 'w') as chunk_out:
                    chunk_out.write(fasta.read(chunk_size))
                future = executor.submit(process_chunk, chunk_file, headers, f"chunks/output_{i}.fasta")
                futures.append(future)

            # Wait for all threads to complete
            for future in futures:
                future.result()

    # Combine all the output files
    with open(output_file, 'w') as out_fasta:
        for i in range(threads):
            chunk_output_file = f"chunks/output_{i}.fasta"
            with open(chunk_output_file) as chunk_out:
                out_fasta.write(chunk_out.read())

    # Cleanup
    for i in range(threads):
        os.remove(f"chunks/chunk_{i}.fasta")
        os.remove(f"chunks/output_{i}.fasta")
    os.rmdir("chunks")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Extract sequences from a large FASTA file using a list of headers.")
    parser.add_argument('-i', '--input', required=True, help="Path to the input FASTA file.")
    parser.add_argument('-ids', '--headers', required=True, help="Path to the headers file.")
    parser.add_argument('-o', '--output', required=True, help="Path to the output FASTA file.")
    parser.add_argument('-t', '--threads', type=int, default=1, help="Number of threads to use (default: 1).")

    args = parser.parse_args()

    extract_sequences(args.input, args.headers, args.output, args.threads)
