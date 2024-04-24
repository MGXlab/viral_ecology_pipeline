rule length_filter:
    input:
        scaffolds_header_fixed = rules.scaffolds_header_fix.output.scaffolds_header_fixed
    output:
        scaffolds_length_filtered = "results/{sample}/scaffolds/{sample}.scaffolds_gt" + LENGTH + ".fasta"
    params:
        length = LENGTH
    conda:
        "../envs/seqtk.yaml"
    shell:
        "seqtk seq -L {params.length} {input.scaffolds_header_fixed} > {output.scaffolds_length_filtered}"

rule concatenate_files:
    input:
        dynamic(scaffolds_length_filtered = "results/{sample}/scaffolds/{sample}.scaffolds_gt" + LENGTH + ".fasta")
    output:
        "all_results/scaffolds/scaffolds_gt" + LENGTH + ".fasta",
    run:
        with open(output[0], "w") as outfile:
            for infile in input:
                with open(infile) as infile_handle:
                    for line in infile_handle:
                        outfile.write(line)
    
