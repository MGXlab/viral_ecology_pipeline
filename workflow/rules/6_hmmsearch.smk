rule transeq:
    input:
        scaffolds_concatenated = rules.scaffolds_concatenate.scaffolds_concatenated
    output:
        scaffolds_transeq_output = "results/{fraction}/transeq/{fraction}_transeq.fasta"
    log:
        "logs/{fraction}/transeq/{fraction}.transeq.log"
    params:
        frame = config['TRANSEQ']['frame']
    conda:
        "../envs/hmmsearch.yaml"
    shell:
        "transeq -sequence {input.scaffolds_concatenated} -outseq {output.scaffolds_transeq_output} -frame {params.frame} -clean"



rule hmmsearch:
    input:
        scaffolds_transeq_output = rules.transeq.output.scaffolds_transeq_output
    output:
        direct = "results/{fraction}/hmmsearch/{fraction}_hmmsearch_direct.out",
        table = "results/{fraction}/hmmsearch/{fraction}_hmmsearch_table.out"
    log:
        "logs/{fraction}/hmmsearch/{fraction}.hmmsearch.log"
    threads:
        config['HMMSEARCH']['threads']
    params:
        hmms = config['HMMSEARCH']['hmms']
    conda:
        "../envs/hmmsearch.yaml"
    shell:
        "hmmsearch -o {output.direct} --domtblout {output.table} --cpu {threads} {params.hmms} {input}"
