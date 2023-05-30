samples_df = samplesheet_to_df(config['samplesheet'])
SAMPLES = samples_df['sample_id'].values.tolist()

rule create_ppr_input:
    input:
        expand("results/{sample}/scaffolds/{sample}_scaffolds.fasta", sample = SAMPLES),
    
    output:
        expand("/net/phage/linuxhome/mgx/people/lingyi/bin/software/PPR-Meta/{sample}_scaffolds.fasta", sample = SAMPLES),
    shell:
        """
        mkdir -p /net/phage/linuxhome/mgx/people/lingyi/bin/software/PPR-Meta
        for f in {input};do
            ln -sr $f -d /net/phage/linuxhome/mgx/people/lingyi/bin/software/PPR-Meta;
        done
        """
        
        
rule ppr:
    input:
        "results/{sample}/scaffolds/{sample}_scaffolds.fasta",
    output:
        "results/ppr/{sample}/{sample}_ppr_output.tsv",
    conda:
        "../envs/ppr.yaml"
    log:
        "logs/{sample}/ppr/{sample}.log"
    threads:
        config["PPR"]["threads"]
    shell:
        "singularity run --bind /net/phage/linuxhome/mgx/people/lingyi/bin/software/pprmeta.sif /net/phage/linuxhome/mgx/people/lingyi/bin/software/PPR-Meta/PPR_Meta {input} {output}"
        "2> {log}"
