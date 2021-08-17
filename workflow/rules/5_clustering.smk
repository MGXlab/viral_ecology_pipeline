rule virus_to_microbe_clustering:
    input:
        virus_scaffolds_all=rules.virus_concatenate.output.virus_scaffolds_all,
        microbe_scaffolds_all=rules.microbe_concatenate.output.microbe_scaffolds_all
    output:
        minimap_output="../results/clustering/virus_to_microbe_all_minimap_clustering.paf"
    log:
        "../logs/minimap/virus_to_microbe_all_minimap_clustering.log"
    conda:
        "../envs/clustering.yaml"
    shell:
        "minimap2 {input.microbe_scaffolds_all} {input.virus_scaffolds_all} > {output} "
        "2> {log}"

rule microbe_to_virus_clustering:
    input:
        virus_scaffolds_all=rules.virus_concatenate.output.virus_scaffolds_all,
        microbe_scaffolds_all=rules.microbe_concatenate.output.microbe_scaffolds_all
    output:
        minimap_output="../results/clustering/microbe_to_virus_all_minimap_clustering.paf"
    log:
        "../logs/minimap/microbe_to_virus_all_minimap_clustering.log"
    conda:
        "../envs/clustering.yaml"
    shell:
        "minimap2 {input.virus_scaffolds_all} {input.microbe_scaffolds_all} > {output} "
        "2> {log}"
