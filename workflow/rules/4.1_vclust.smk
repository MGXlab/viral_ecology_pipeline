rule vclust_prefilter:
    input:
        "results/{sample}/jaeger/{sample}_jaeger_virus_seqs.fasta",
    output:
        "results/{sample}/vclust/{sample}.vclust_fltr.txt",
    log:
        "logs/{sample}/vclust/{sample}.vclust_prefilter.log"
    params:
        script = "/net/phage/linuxhome/mgx/people/lingyi/bin/software/vclust-1.0.3_x64-linux/vclust.py"
        min-kmers = config["VCLUST"]["min-kmers"]
        min-ident = config["VCLUST"]["min-ident"]
    threads:
        config["VCLUST"]["threads"]
    shell:
        "python3.8 {params.script} prefilter "
        "-i {input} "
        "-o {output} "
        "--min-kmers {params.min-kmers} "
        "--min-ident {params.min-ident} "
        "-t {threads} "
        "--verbose "
        "&>{log}"

rule vclust_align:
    input:
        "results/{sample}/jaeger/{sample}_jaeger_virus_seqs.fasta",
    output:
        "results/{sample}/vclust/{sample}.vclust_ani.txt",
    log:
        "logs/{sample}/vclust/{sample}.vclust_align.log"
    params:
        script = "/net/phage/linuxhome/mgx/people/lingyi/bin/software/vclust-1.0.3_x64-linux/vclust.py"
        filtered_file = "results/{sample}/vclust/{sample}.vclust_fltr.txt",
    threads:
        config["VCLUST"]["threads"]
    shell:
        "python3.8 {params.script} align "
        "-i {input} "
        "-o {output} "
        "--filter {params.filtered_file} "
        "-t {threads} "
        "--verbose "
        "&>{log}"

rule vclust_cluster_species:
    input:
        "results/{sample}/vclust/{sample}.vclust_ani.txt",
    output:
        "results/{sample}/vclust/{sample}.vclust_species.txt",
    log:
        "logs/{sample}/vclust/{sample}.vclust_cluster_species.log"
    params:
        script = "/net/phage/linuxhome/mgx/people/lingyi/bin/software/vclust-1.0.3_x64-linux/vclust.py"
        ids = "results/{sample}/vclust/{sample}.vclust_ani.ids.txt",
    threads:
        config["VCLUST"]["threads"]
    shell:
        "python3.8 {params.script} cluster "
        "-i {input} "
        "-o {output} "
        "--ids {params.ids} "
        "--algorithm complete "
        "--metric tani "
        "--tani 0.95 "
        "-t 94 "
        "--verbose "
        "&>{log}"

rule vclust_cluster_genera:
    input:
        "results/{sample}/vclust/{sample}.vclust_ani.txt",
    output:
        "results/{sample}/vclust/{sample}.vclust_genera.txt",
    log:
        "logs/{sample}/vclust/{sample}.vclust_cluster_genera.log"
    params:
        script = "/net/phage/linuxhome/mgx/people/lingyi/bin/software/vclust-1.0.3_x64-linux/vclust.py"
        ids = "results/{sample}/vclust/{sample}.vclust_ani.ids.txt",
    threads:
        config["VCLUST"]["threads"]
    shell:
        "python3.8 {params.script} cluster "
        "-i {input} "
        "-o {output} "
        "--ids {params.ids} "
        "--algorithm complete "
        "--metric tani "
        "--tani 0.70 "
        "-t 94 "
        "--verbose "
        "&>{log}"
