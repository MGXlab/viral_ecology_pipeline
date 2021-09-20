rule create_wtp_input:
    input:
        rules.length_filter.output.scaffolds_length_filtered
    output:
        linked_sample = temp("results/wtp/{fraction}/input/{sample}_scaffolds_gt1500.fasta"),
    params:
        output_dir = "results/wtp/input"
    shell:
        """
        cp {input} {params.output_dir}
        """

rule wtp:
    input:
        rules.create_wtp_input.output.linked_sample,
    output:
       # "results/wtp/output/runinfo/execution_report.html",
       # "results/wtp/output/literature/Citations.bib",
       "results/wtp/{fraction}/output/{sample}_scaffolds_gt1500/{sample}_scaffolds_gt1500_quality_summary.tsv",
    log:
        "wtp/{fraction}/{sample}.nextflow.log"
    conda:
        "../envs/wtp.yaml"
    params:
        fasta="'results/wtp/input/*.fasta'",
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
