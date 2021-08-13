rule virus_assembly:
    input:
        virus_fq1_paired=rules.virus_trim_adapters.output.virus_fq1_adapter_removed_paired,
        virus_fq2_paired=rules.virus_trim_adapters.output.virus_fq2_adapter_removed_paired,
        virus_fq1_unpaired=rules.virus_trim_adapters.output.virus_fq1_adapter_removed_unpaired,
        virus_fq2_unpaired=rules.virus_trim_adapters.output.virus_fq2_adapter_removed_unpaired
    output:
        virus_scaffolds="../tmp/spades/{virus_sample}/scaffolds.fasta"
    log:
        "../logs/spades/{virus_sample}.log"
    threads:
        config["SPADES"]["threads"]
    params:
        m = config["SPADES"]["m"],
        k = config["SPADES"]["k"],
        assembly_dir = config["SPADES"]["assembly_dir"]
    conda:
        "../envs/assembly.yaml"
    shell:
        "spades.py "
        "-t {threads} "
        "--meta -m {params.m} "
        "-k {params.k} "
        "--pe1-1 {input.virus_fq1_paired} "
        "--pe1-2 {input.virus_fq2_paired} "
        "--pe1-s {input.virus_fq1_unpaired} "
        "--pe1-s {input.virus_fq2_unpaired} "
        "-o {params.assembly_dir} "
        "2> {log}"

# rule virus_scaffolds_header_fix:
#     input:
#         virus_scaffolds=rules.virus_assembly.output.virus_scaffolds
#     output:
#         virus_scaffolds_moved="../results/scaffolds/virus_scaffolds/{virus_sample}_scaffolds.fasta",
#         virus_scaffolds_header_fixed="../results/scaffolds/virus_scaffolds/{virus_sample}_scaffolds_header_fixed.fasta"
#     log:
#         "../logs/hearder_fix/{virus_sample}.log"
#     params:
#         prefix = "{virus_sample}_"
#     conda:
#         "../envs/assembly.yaml"
#     shell:
#         "cp {input.virus_scaffolds}  {output.virus_scaffolds_moved} &&"
#         "seqtk rename {output.virus_scaffolds_moved} {params.prefix} > {output.virus_scaffolds_header_fixed}"

rule microbe_assembly:
    input:
        microbe_fq1_paired=rules.microbe_trim_adapters.output.microbe_fq1_adapter_removed_paired,
        microbe_fq2_paired=rules.microbe_trim_adapters.output.microbe_fq2_adapter_removed_paired,
        microbe_fq1_unpaired=rules.microbe_trim_adapters.output.microbe_fq1_adapter_removed_unpaired,
        microbe_fq2_unpaired=rules.microbe_trim_adapters.output.microbe_fq2_adapter_removed_unpaired
    output:
        microbe_scaffolds="../tmp/spades/{microbe_sample}/scaffolds.fasta"
    log:
        "../logs/spades/{virus_sample}.log"
    threads:
        config["SPADES"]["threads"]
    params:
        m = config["SPADES"]["m"],
        k = config["SPADES"]["k"],
        assembly_dir = config["SPADES"]["assembly_dir"]
    conda:
        "../envs/assembly.yaml"
    shell:
        "spades.py "
        "-t {threads} "
        "--meta -m {params.m} "
        "-k {params.k} "
        "--pe1-1 {input.microbe_fq1_paired} "
        "--pe1-2 {input.microbe_fq2_paired} "
        "--pe1-s {input.microbe_fq1_unpaired} "
        "--pe1-s {input.microbe_fq2_unpaired} "
        "-o {params.assembly_dir} "
        "2> {log}"

# rule microbe_scaffolds_header_fix:
#     input:
#         microbe_scaffolds=rules.microbe_assembly.output.microbe_scaffolds
#     output:
#         microbe_scaffolds_moved="../results/scaffolds/microbe_scaffolds/{microbe_sample}_scaffolds.fasta",
#         microbe_scaffolds_header_fixed="../results/scaffolds/microbe_scaffolds/{microbe_sample}_scaffolds_header_fixed.fasta"
#     log:
#         "../logs/hearder_fix/{microbe_sample}.log"
#     params:
#         prefix = "{microbe_sample}_"
#     conda:
#         "../envs/assembly.yaml"
#     shell:
#         "cp {input.microbe_scaffolds}  {output.microbe_scaffolds_moved} &&"
#         "seqtk rename {output.microbe_scaffolds_moved} {params.prefix} > {output.microbe_scaffolds_header_fixed}"
