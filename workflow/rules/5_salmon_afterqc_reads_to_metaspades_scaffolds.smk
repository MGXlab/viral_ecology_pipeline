rule salmon_quant:
    input:
        afterqc_reads=["results/{sample}/remove_host_reads/{sample}_1.remove_host_reads.fastq.gz", "results/{sample}/remove_host_reads/{sample}_2.remove_host_reads.fastq.gz"],
    output:
        "results/{sample}/salmon_all_metaspades_scaffolds/quant.sf"
    conda:
        "../envs/salmon.yaml"
    log:
        "logs/{sample}/salmon/{sample}.salmon_all_metaspades_scaffolds.log"
    threads:
        config["SALMON"]["threads"]
    params:
        salmon_index = config["SALMON"]["salmon_index_directory"],
        salmon_direcotry = "results/{sample}/salmon_all_metaspades_scaffolds"
    shell:
        "salmon quant -i {params.salmon_index} -l A "
        "-1 {input.afterqc_reads[0]} "
        "-2 {input.afterqc_reads[1]} "
        "-p {threads} "
        "--validateMappings "
        "-o {params.salmon_directory} "
        "--minAssignedFrags 0 "
        "2> {log}"

rule extract_salmon_num_reads:
    input:
        "results/{sample}/salmon_all_metaspades_scaffolds/quant.sf"
    output:
        "results/{sample}/salmon_all_metaspades_scaffolds/{sample}.salmon_num_reads.txt"
    log:
        "logs/{sample}/extract_salmon_NumReads/{sample}.extract_salmon_NumReads.log",
    params:
        script = "workflow/scripts/extract_salmon_NumReads.py",
        samples_from_wc=lambda wc: wc.get("sample_id")
    threads:
        48
    shell:
        "python3.8 {params.script} {input} {output} {params.samples_from_wc} -t {threads} &>{log}"

# rule merge_files:
#     input:
#         expand("results/{sample}.salmon_num_reads.txt", sample=glob_wildcards("results/{sample}.salmon_num_reads.txt").sample)
#     output:
#         "combined_results/salmon_num_reads_merged_file.txt"
#     script:
#         "workflow/scripts/merge_salmon_NumReads.py"
#     params:
#         input_files = ",".join(expand("results/{sample}.salmon_num_reads.txt", sample=glob_wildcards("results/{sample}.salmon_num_reads.txt").sample)),
#         output_file = "combined_results/salmon_num_reads_merged_file.txt"
#     run:
#         import subprocess
#         subprocess.check_call(["python3.8", "workflow/scripts/merge_salmon_NumReads.py", params.input_files, params.output_file])