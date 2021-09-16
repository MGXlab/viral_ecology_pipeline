rule create_wtp_input:
    input:
        viral_scaffolds="results/viral/concatenated_scaffolds/viral_scaffolds_gt1500.fasta",
        microbial_scaffolds="results/microbial/concatenated_scaffolds/microbial_scaffolds_gt1500.fasta"
    output:
        linked_viral="results/wtp/input/viral_scaffolds_gt1500.fa",
        linked_microbial="results/wtp/input/microbial_scaffolds_gt1500.fa"
    params:
        linked_viral_name="viral_scaffolds_gt1500.fa",
        linked_microbial_name="microbial_scaffolds_gt1500.fa"
    shell:
        """
        mkdir -p results/wtp/input 
        cd results/wtp/input
        ln -s ../../viral/concatenated_scaffolds/viral_scaffolds_gt1500.fasta {params.linked_viral_name}
        ln -s ../../microbial/concatenated_scaffolds/microbial_scaffolds_gt1500.fasta {params.linked_microbial_name}
        """

rule wtp:
    input:
        rules.create_wtp_input.output.linked_viral,
        rules.create_wtp_input.output.linked_microbial,

    output:
       "results/wtp/output/runinfo/execution_report.html",
       "results/wtp/output/literature/Citations.bib",
       "results/wtp/output/microbial_scaffolds_gt1500/microbial_scaffolds_gt1500_quality_summary.tsv",
       "results/wtp/output/viral_scaffolds_gt1500/viral_scaffolds_gt1500_quality_summary.tsv"
    log:
        ".nextflow.log"
    conda:
        "../envs/wtp.yaml"
    params:
        fasta="'results/wtp/input/*.fa'",
        pipeline="replikation/What_the_Phage",
        revision="v1.0.2",
        profile=["local", "singularity"],
        workdir=config["WTP"]["workdir"],
        databases=config["WTP"]["databases"],
        cachedir=config["WTP"]["cachedir"],
        output=config["WTP"]["outputdir"],
        cores=config["WTP"]["threads"],
    handover: True
    wrapper:
        "0.74.0/utils/nextflow"
