rule scaffolds_concatenate:
    input:
        get_scaffolds_by_fraction
    output:
        scaffolds_all_gt1500 = "results/{fraction}/concatenated_scaffolds/{fraction}_scaffolds_gt1500.fasta"
    shell:
        "cat {input} > {output}"

rule clustering:
    input:
        virus_scaffolds = "results/viral/concatenated_scaffolds/viral_scaffolds_gt1500.fasta",
        microbe_scaffolds = "results/microbial/concatenated_scaffolds/microbial_scaffolds_gt1500.fasta"
    output:
        minimap_viral_to_microbial_output = "results/clustering/viral_to_microbial_minimap_clustering.paf",
        minimap_microbial_to_viral_output = "results/clustering/microbial_to_viral_minimap_clustering.paf"
    log:
        ".logs/minimap/clustering.log"
    conda:
        "../envs/clustering.yaml"
    shell:
        "minimap2 {input.virus_scaffolds} {input.microbe_scaffolds} > {output.minimap_microbial_to_viral_output} && "
        "minimap2 {input.microbe_scaffolds} {input.virus_scaffolds} > {output.minimap_viral_to_microbial_output} "
        "2> {log}"
