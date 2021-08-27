rule scaffolds_concatenate:
    input:
        get_scaffolds_by_fraction
    output:
        scaffolds_all = "results/{fraction}/concatenated_scaffolds/{fraction}_scaffolds_all.fasta"
    shell:
        "cat {input} > {output}"

rule length_filter:
    input:
        scaffolds_all = rules.scaffolds_concatenate.output.scaffolds_all
    output:
        scaffolds_length_filtered = "results/{fraction}/concatenated_scaffolds/{fraction}_scaffolds_gt1500.fasta"
    params:
        length = config["SEQTK"]["length"]
    conda:
        "../envs/seqtk.yaml"
    shell:
        "seqtk seq -L {params.length} {input.scaffolds_all} > {output.scaffolds_length_filtered}"
