rule create_wtp_input:
    input:
        expand("results/{sample}/scaffolds/{sample}_scaffolds.fasta"),
    
    output:
        expand("results/wtp/input/{sample}_scaffolds.fasta"),
    shell:
        """
        mkdir -p results/wtp/input
        for f in {input};do
            ln -sr $f -d results/wtp/input;
        done
        """

rule wtp:
    input:
        expand("results/wtp/input/{sample}_scaffolds.fasta")
    output:
        expand("results/wtp/output/{sample}_scaffolds/raw_data/pprmeta_results_{sample}_scaffolds.tar.gz"),

    log:
        ".nextflow.log"
    conda:
        "../envs/wtp.yaml"
    params:
        fasta="'results/wtp/input/*.fasta'",
        pipeline="replikation/What_the_Phage",
        revision="v1.0.2",
        profile=["local", "singularity"],
        workdir=config["WTP"]["workdir"],
        databases=config["WTP"]["databases"],
        cachedir=config["WTP"]["cachedir"],
        output=config["WTP"]["outputdir"],
        cores=config["WTP"]["threads"],
        identify=config["WTP"]["identify"],
        annotate=config["WTP"]["annotate"],
        dv=config["WTP"]["dv"],
        ma=config["WTP"]["ma"],
        mp=config["WTP"]["mp"],
        pp=config["WTP"]["pp"],
        sm=config["WTP"]["sm"],
        vb=config["WTP"]["vb"],
        vf=config["WTP"]["vf"],
        vn=config["WTP"]["vn"],
        vs=config["WTP"]["vs"],
        ph=config["WTP"]["ph"],
        vs2=config["WTP"]["vs2"],
        sk=config["WTP"]["sk"]

    handover: True
    wrapper:
        "0.74.0/utils/nextflow"
