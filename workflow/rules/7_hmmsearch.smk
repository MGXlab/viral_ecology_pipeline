rule transeq:
    input:
        scaffolds_length_filtered = rules.length_filter.output.scaffolds_length_filtered,
    output:
        scaffolds_transeq_output = "results/{fraction}/transeq/{fraction}_transeq.fasta"
    log:
        "logs/{fraction}/transeq/{fraction}.transeq.log"
    params:
        frame = config['TRANSEQ']['frame']
    conda:
        "../envs/hmmsearch.yaml"
    shell:
        "transeq -sequence {input.scaffolds_length_filtered} -outseq {output.scaffolds_transeq_output} -frame {params.frame} -clean"



rule hmmsearch:
    input:
        scaffolds_transeq_output = rules.transeq.output.scaffolds_transeq_output
    output:
        scaffolds_hmmsearch_output = "results/{fraction}/hmmsearch/{fraction}_hmmsearch.out"
    log:
        "logs/{fraction}/hmmsearch/{fraction}.transeq.log"
    threads:
        config['HMMSEARCH']['threads']
    params:
        hmms = config['HMMSEARCH']['hmms']
    conda:
        "../envs/hmmsearch.yaml"
    shell:
        "hmmsearch -o {output} --cpu {threads} {params.hmms} {input}"
