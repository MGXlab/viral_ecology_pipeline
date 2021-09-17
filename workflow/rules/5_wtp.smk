rule create_wtp_input:
    input:
        rules.length_filter.output.scaffolds_length_filtered
    output:
        linked_sample = "results/wtp/input/{fraction}/{sample}_scaffolds_gt1500.fasta",
    params:
        linked_name="{fraction}/{sample}_scaffolds_gt1500.fasta",
    shell:
        """
        mkdir -p results/wtp/input
        cd results/wtp/input
        ln -sr {input} {params.linked_name}
        """

# rule wtp:
#     input:
#         rules.create_wtp_input.output.linked_sample,
#     output:
#        # "results/wtp/output/runinfo/execution_report.html",
#        # "results/wtp/output/literature/Citations.bib",
#        "results/wtp/output/{sample}_scaffolds_gt1500/{sample}_scaffolds_gt1500_quality_summary.tsv",
#     log:
#         ".{sample}.nextflow.log"
#     conda:
#         "../envs/wtp.yaml"
#     params:
#         fasta="'results/wtp/input/*.fasta'",
#         pipeline="replikation/What_the_Phage",
#         revision="v1.0.2",
#         profile=["local", "singularity"],
#         workdir=config["WTP"]["workdir"],
#         databases=config["WTP"]["databases"],
#         cachedir=config["WTP"]["cachedir"],
#         output=config["WTP"]["outputdir"],
#         cores=config["WTP"]["threads"],
#     handover: True
#     wrapper:
#         "0.74.0/utils/nextflow"
