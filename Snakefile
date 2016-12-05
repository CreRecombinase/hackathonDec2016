"""
Hackathlon Snakemake file 

This snakefile is intended to coordinate / interaction between projects, so
do not add things here directly unnecessarily.

To start a new project, make a subfolder and use `include` to
add the Snakefile.
"""




include: "projects/archaic/Snakefile"
    """
    Get all called Denisovan and Neandertal sites as annotation
    """

