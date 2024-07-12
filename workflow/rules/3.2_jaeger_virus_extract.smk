rule jaeger_virus_id_extract:
    input:
        "results/{sample}/jaeger/{sample}.scaffolds_gt" + LENGTH + "_default_jaeger.tsv",
    output:
        "results/{sample}/jaeger/{sample}_jaeger_virus_ids.txt",
    log:
        "logs/{sample}/jaeger/{sample}.jaeger_virus_id_extract.log",
    params:
        script = "workflow/scripts/jaeger_virus_id_extract.py"
    shell:
        "python3.8 {params.script} {input} {output} &>{log}"

rule jaeger_virus_seq_extract:
    input:
        fasta = "results/{sample}/penguin/{sample}.scaffolds_gt" + LENGTH + ".fasta",
        ids = "results/{sample}/jaeger/{sample}_jaeger_virus_ids.txt",
    output:
        "results/{sample}/jaeger/{sample}_jaeger_virus_seqs.fasta",
    log:
        "logs/{sample}/jaeger/{sample}.jaeger_virus_seq_extract.log",
    params:
        script = "workflow/scripts/jaeger_virus_seq_extract.py"
    threads:
        48
    shell:
        "python3.8 {params.script} -i {input.fasta} -ids {input.ids} -o {output} -t {threads} &>{log}"
