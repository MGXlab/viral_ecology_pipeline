rule wtp:
    input:
        input=rules.microbe_length_filter.output.microbe_scaffolds_length_filtered
    output:
        "../results/wtp/microbe/microbe_scaffolds_gt1500/identified_contigs_by_tools/deepvirfinder.txt",
        "../results/wtp/microbe/microbe_scaffolds_gt1500/literature/Citations.bib"
    log:
        "../logs/wtp/microbe_wtp.log"
    conda:
        "../envs/wtp.yaml"
    params:
        pipeline="replikation/What_the_Phage",
        revision="1.0.2",
        profile=["local", "singularity"],
        workdir=config["WTP"]["workdir"],
        databases=config["WTP"]["databases"],
        cachedir=config["WTP"]["cachedir"],
        output=config["WTP"]["outputdir"],
        threads=config["WTP"]["threads"]
    handover: True
    wrapper:
        "0.74.0/utils/nextflow"
