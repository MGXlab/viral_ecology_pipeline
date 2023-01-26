rule transeq:
    input:
        unique_scaffolds = "results/{fraction}/concatenated_scaffolds/antarctica_unique_{fraction}_contigs.fasta"
    output:
        scaffolds_transeq_output = "results/{fraction}/transeq/{fraction}_transeq.fasta"
    log:
        "logs/{fraction}/transeq/{fraction}.transeq.log"
    params:
        frame = config['TRANSEQ']['frame']
    conda:
        "../envs/hmmsearch.yaml"
    shell:
        "transeq -sequence {input.unique_scaffolds} -outseq {output.scaffolds_transeq_output} -frame {params.frame} -clean"



rule viral_hmmsearch:
    input:
        scaffolds_transeq_output = rules.transeq.output.scaffolds_transeq_output
    output:
        table = "results/{fraction}/hmmsearch/{fraction}_viral_hmmsearch_table.out"
    log:
        "logs/{fraction}/hmmsearch/{fraction}.viral_hmmsearch.log"
    threads:
        config['HMMSEARCH']['threads']
    params:
        hmms = config['HMMSEARCH']['viral_hmms']
    conda:
        "../envs/hmmsearch.yaml"
    shell:
        "hmmsearch --domtblout {output.table} --cpu {threads} {params.hmms} {input}"

        
 rule microbial_hmmsearch:
    input:
        scaffolds_transeq_output = rules.transeq.output.scaffolds_transeq_output
    output:
        table = "results/{fraction}/hmmsearch/{fraction}_microbial_hmmsearch_table.out"
    log:
        "logs/{fraction}/hmmsearch/{fraction}.microbial_hmmsearch.log"
    threads:
        config['HMMSEARCH']['threads']
    params:
        hmms = config['HMMSEARCH']['microbial_hmms']
    conda:
        "../envs/hmmsearch.yaml"
    shell:
        "hmmsearch --domtblout {output.table} --cpu {threads} {params.hmms} {input}"
