rule vclust_prefilter:
    input:
        fasta = "results/{sample}/jaeger/{sample}_jaeger_virus_seqs.fasta",
    output:
        filtered_file = "results/{sample}/vclust/{sample}.vclust_fltr.txt",
    log:
        "logs/{sample}/vclust/{sample}.vclust_prefilter.log"
    params:
        script = "/net/phage/linuxhome/mgx/people/lingyi/bin/software/vclust-1.0.3_x64-linux/vclust.py",
        min_kmers = 10,
        min_ident = 0.7,
    threads:
        config["VCLUST"]["threads"]
    shell:
        "python3.8 {params.script} prefilter "
        "-i {input.fasta} "
        "-o {output.filtered_file} "
        "--min-kmers {params.min_kmers} "
        "--min-ident {params.min_ident} "
        "-t {threads} "
        "--verbose "
        "&>{log}"

rule vclust_align:
    input:
        fasta = "results/{sample}/jaeger/{sample}_jaeger_virus_seqs.fasta",
        filtered_file = "results/{sample}/vclust/{sample}.vclust_fltr.txt",
    output:
        ani_file = "results/{sample}/vclust/{sample}.vclust_ani.txt",
    log:
        "logs/{sample}/vclust/{sample}.vclust_align.log"
    params:
        script = "/net/phage/linuxhome/mgx/people/lingyi/bin/software/vclust-1.0.3_x64-linux/vclust.py",  
    threads:
        config["VCLUST"]["threads"]
    shell:
        "python3.8 {params.script} align "
        "-i {input.fasta} "
        "-o {output.ani_file} "
        "--filter {input.filtered_file} "
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
        script = "/net/phage/linuxhome/mgx/people/lingyi/bin/software/vclust-1.0.3_x64-linux/vclust.py",
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
        script = "/net/phage/linuxhome/mgx/people/lingyi/bin/software/vclust-1.0.3_x64-linux/vclust.py",
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
        "--verbose "
        "&>{log}"
