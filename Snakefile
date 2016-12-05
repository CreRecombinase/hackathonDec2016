"""
Hackathlon Snakemake file 

This snakefile is intended to coordinate / interaction between projects, so
do not add things here directly unnecessarily.

- To start a new project, make a subfolder and use `include` to
    add the Snakefile.

- To add a new type of data, add its location on RCC midway to
   config/data.yaml in yaml format

"""


configfile: "config/data.yaml"
DATA_GEODIST = config['data']['geodist']



include: "projects/archaic/Snakefile"
"""
Get all called Denisovan and Neandertal sites as annotation
"""

rule none:
    input: "Snakefile"
    run: print(DATA_GEODIST)
    
