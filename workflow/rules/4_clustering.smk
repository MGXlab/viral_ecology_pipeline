# rule virus_length_filter:
#     input:
#         virus_scaffolds=rules.virus_scaffolds_header_fix.output.virus_scaffolds_header_fixed
#     output:
#         virus_scaffolds_length_filtered=
#     log

rule virus_concatenate:
    input:
        virus_scaffolds_header_fixed=expand(rules.virus_scaffolds_header_fix.output.virus_scaffolds_header_fixed)
    output:
        virus_scaffolds_all="../results/scaffolds/virus_scaffolds/virus_scaffolds_all.fasta"
    log:
        "../logs/concatenate/{virus_sample}.log"
    params:
    shell:
        "cat {input} > {output}"

rule microbe_concatenate:
    input:
        microbe_scaffolds_header_fixed=expand(rules.microbe_scaffolds_header_fix.output.microbe_scaffolds_header_fixed)
    output:
        microbe_scaffolds_all="../results/scaffolds/microbe_scaffolds/microbe_scaffolds_all.fasta"
    log:
        "../logs/concatenate/{microbe_sample}.log"
    params:
    shell:
        "cat {input} > {output}"

rule clustering:
    input:
        virus_scaffolds_all=rules.virus_concatenate.output.virus_scaffolds_all,
        microbe_scaffolds_all=rules.microbe_concatenate.output.microbe_scaffolds_all
    output:
        minimap_output=
    log:
        "../logs/minimap/minimap.log"
    params:
    shell:
        
