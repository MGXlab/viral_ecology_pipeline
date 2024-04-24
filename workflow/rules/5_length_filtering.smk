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

rule concat:
    input:
        scaffolds_length_filtered = "results/{sample}/scaffolds/{sample}.scaffolds_gt" + LENGTH + ".fasta"
    output:
        concat_scaffolds = "all_results/scaffolds/scaffolds_gt" + LENGTH + ".fasta"
    params:
    shell:
        "cat {input} > {output}"

    
