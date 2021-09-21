LENGTH = str(config['SEQTK']['length'])

rule scaffolds_concatenate:
    input:
        get_scaffolds_by_fraction
    output:
        scaffolds_all_big = "results/{fraction}/concatenated_scaffolds/{fraction}_scaffolds_gt"+ LENGTH + ".fasta"
    shell:
        "cat {input} > {output}"

rule minimap:
    input:
        virus_scaffolds = "results/viral/concatenated_scaffolds/viral_scaffolds_gt" + LENGTH + ".fasta",
        microbe_scaffolds = "results/microbial/concatenated_scaffolds/microbial_scaffolds_gt" + LENGTH + ".fasta"
    output:
        minimap_out = "results/minimap/viral_to_microbial_minimap.paf"
    log:
        "logs/minimap/minimap.log"
    conda:
        "../envs/minimap.yaml"
    shell:
        "minimap2 -x ava-ont --dual=yes {input.microbe_scaffolds} {input.virus_scaffolds} > {output.minimap_out} "
        "2> {log}"

rule minimap_out_sum:
    input:
        minimap_out = rules.minimap.output.minimap_out
    output:
        viral_query = "results/minimap/viral_query.csv",
        microbial_target = "results/minimap/microbial_query.csv"
    params:
        scrpt = "workflow/scripts/minimap_out_sum.py"
    shell:
        "python {params.scrpt} {input} {output.viral_query} {output.microbial_target}"
