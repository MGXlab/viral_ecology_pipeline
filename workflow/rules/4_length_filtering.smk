rule virus_concatenate:
    input:
        virus_scaffolds=expand(rules.virus_scaffolds_header_fix.output.virus_scaffolds_header_fixed, virus_sample = virus_samples)
    output:
        virus_scaffolds_all="../results/scaffolds/virus_by_length/virus_scaffolds_all.fasta"
    log:
        "../logs/concatenate/virus_concatenate.log"
    shell:
        "cat {input} > {output} "
        "2> {log}"

rule virus_length_filter:
    input:
        virus_scaffolds=rules.virus_concatenate.output.virus_scaffolds_all
    output:
        virus_scaffolds_length_filtered="../results/scaffolds/virus_by_length/virus_scaffolds_gt1500.fasta"
    log:
        "../logs/seqtk/virus_length_filter.log"
    params:
        length = config["SEQTK"]["length"]
    conda:
        "../envs/seqtk.yaml"
    shell:
        "seqtk seq -L {params.length} {input} > {output}"

rule microbe_concatenate:
    input:
        microbe_scaffolds=expand(rules.microbe_scaffolds_header_fix.output.microbe_scaffolds_header_fixed, microbe_sample = microbe_samples)
    output:
        microbe_scaffolds_all="../results/scaffolds/microbe_by_length/microbe_scaffolds_all.fasta"
    log:
        "../logs/concatenate/microbe_concatenate.log"
    shell:
        "cat {input} > {output} "
        "2> {log}"

rule microbe_length_filter:
    input:
        microbe_scaffolds=rules.microbe_concatenate.output.microbe_scaffolds_all
    output:
        microbe_scaffolds_length_filtered="../results/scaffolds/microbe_by_length/microbe_scaffolds_gt1500.fasta"
    log:
        "../logs/seqtk/microbe_length_filter.log"
    params:
        length = config["SEQTK"]["length"]
    conda:
        "../envs/seqtk.yaml"
    shell:
        "seqtk seq -L {params.length} {input} > {output}"
