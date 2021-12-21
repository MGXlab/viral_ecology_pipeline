LENGTH =str(config['SEQTK']['length'])

rule length_filter:
    input:
        scaffolds_header_fixed = rules.scaffolds_header_fix.output.scaffolds_header_fixed
    output:
        scaffolds_length_filtered = "results/{fraction}/{sample}/scaffolds/{sample}_scaffolds_gt" + LENGTH + ".fasta"
    params:
        length = LENGTH
    conda:
        "../envs/seqtk.yaml"
    shell:
        "seqtk seq -L {params.length} {input.scaffolds_header_fixed} > {output.scaffolds_length_filtered}"

rule scaffolds_concatenate:
    input:
        get_scaffolds_by_fraction
    output:
        scaffolds_concatenated = "results/{fraction}/concatenated_scaffolds/{fraction}_scaffolds_gt"+ LENGTH + ".fasta"
    shell:
        "cat {input} > {output}"

rule split_fasta:
    input:
        scaffolds_concatenated = rules.scaffolds_concatenate.output.scaffolds_concatenated
    output:
       scaffolds_splitted = "results/{fraction}/concatenated_scaffolds/{fraction}_scaffolds_gt"+ LENGTH + "_0.fasta"
    shell:
        "awk 'BEGIN {n_seq=0;} /^>/ {if(n_seq%10000==0){file=sprintf("{params.output_prefix}%d.fa",n_seq);} print >> file; n_seq++; next;} { print >> file; }' < {input}"
