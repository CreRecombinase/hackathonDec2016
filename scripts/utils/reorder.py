import sys,os
import gzip

"""
reorder assign.tsv.gz files

first pass of assign files were in order [SAS, AFR, EAS, EUR, AMR]
this script reorders them to [AFR, EUR, SAS, EAS, AMR]
it also modifies category ids to binary
"""

infile, outfile = sys.argv[1:3]
out_order = [1, 3, 0, 2, 4]

N_LVL = 4

def get_cat_number(cats):
    return sum(N_LVL ** i * c for (i, c)  in enumerate(cats)) + 1
        

with gzip.open(infile, 'rt') as f:
    with gzip.open(outfile, 'wt') as w:
        for l_no, line in enumerate(f):
            line = line.split()
            cats = line[4:]
            cats = [int(cats[i]) for i in out_order]
            cat_number = get_cat_number(cats)

            line[3] = str(cat_number)
            line[4:] = [str(i) for i in cats]
            w.write("\t".join(line) + "\n")

            if l_no % 10000 == 0:
                print(l_no)
            if l_no > 500000: break



