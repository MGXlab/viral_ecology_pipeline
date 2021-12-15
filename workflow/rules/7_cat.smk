LENGTH = str(config['SEQTK']['length'])

rule cat:
    input:
        scaffolds_all_big = "results/{fraction}/concatenated_scaffolds/{fraction}_scaffolds_gt"+ LENGTH + ".fasta"
    output:
        cat_out = "results/{fraction}/cat/{fraction}_scaffolds_gt" + LENGTH + ".contig2classification.txt"
    # log:
    #     "logs/cat/cat.log"
    params:
        database = config['CAT']['database'],
        taxonomy = config['CAT']['taxonomy'],
        out_prefix = "results/{fraction}/cat/{fraction}_scaffolds_gt" + LENGTH,
        path_to_diamond = config['CAT']['path_to_diamond']

    conda:
        "../envs/cat.yaml"
    shell:
        "CAT contigs "
        "-c {input.scaffolds_all_big} "
        "-d {params.database} "
        "-t {params.taxonomy} "
        "-o {params.out_prefix} "
        "--path_to_diamond {params.path_to_diamond}"
