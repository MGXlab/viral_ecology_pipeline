rule genomad:
    input:
        scaffolds_length_filtered = "results/{sample}/scaffolds/{sample}.scaffolds_gt" + LENGTH + ".fasta",
    output:
        genomad_output = "results/{sample}/genomad/{sample}.scaffolds_gt" + LENGTH + "_summary.log",
    conda:
        "../envs/genomad.yaml"
    log:
        "logs/{sample}/genomad/{sample}.log"
    threads:
        config["GENOMAD"]["threads"]
    params:
        out_dir = "results/{sample}/genomad",
        genomad_db_dir = config["GENOMAD"]["genomad_db"]
    shell:
        "genomad end-to-end \
        {input} \
        {params.out_dir} \
        {params.genomad_db_dir} \
        --cleanup --splits 8 "
        "2> {log}"
