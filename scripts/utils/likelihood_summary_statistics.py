#!/usr/bin/python

"""
Calculate average credible set size for each geodist category

Input is an assignment file and likelihood file with same SNPs, output is file with the average size of credible sets for each geodist category, ordered by frequency
"""

import sys, getopt
import gzip
import math
import operator

def main(argv):
    inputfile = ''
    outputfile = ''
    try:
        opts, args = getopt.getopt(argv,"hl:o:a:",["likefile=","outfile=","assignfile="])
    except getopt.GetoptError:
        print('likelihood_summary_statistics.py -l <likelihood inputfile> -a <assignment inputfile> -o <outputfile>')
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print('likelihood_summary_statistics.py -l <likelihood inputfile> -a <assignment inputfile> -o <outputfile>')
            sys.exit()
        elif opt in ("-l","--likefile"):
            inputfile = arg
        elif opt in ("-o","--outfile"):
            outputfile = arg
        elif opt in ("-a","--assignfile"):
            assignfile = arg

    zcheck = inputfile[-2] + inputfile[-1]
    zcheck2 = assignfile[-2] + assignfile[-1]
    if zcheck != "gz" or zcheck2 != "gz":
        print('Expecting compressed files')
        sys.exit()

    #Read in assignment file and record categories for each SNP and geodist score for each category
    data = {}
    categories = {}
    cat_ids = {}
    total_seen = 0
    with gzip.open(assignfile,'rb') as afile:
        for i in range(1,1001):
            line = next(afile).decode("utf-8")
            vals = line.split()
            total_seen+=1
            categories[vals[2]] = vals[3]
            if vals[3] in data:
                data[vals[3]]["c"]+=1
            else:
                data[vals[3]] = {}
                data[vals[3]]["c"] = 1
            if vals[3] not in cat_ids:
                cat_ids[vals[3]] = vals[4:]

    #Read in likelihood file            
    with gzip.open(inputfile,'rb') as file:
        for i in range(1,1001):
            line = next(file).decode("utf-8")
            vals = line.split()
            max_like = 1
            like_sum = 0
            tlist = []

            #Get maximum likelihood value (corresponding to assignment) and sum of likelihoods
            for v in vals:
                 if v!= "-Inf" and vals.index(v) > 2: 
                     if float(v) > float(max_like) or max_like==1:
                         max_like = v

                     like_sum+=math.exp(float(v))

            #Calculate posterior probablilites of likelihoods         
            for v in vals:
                if v!= "-Inf" and vals.index(v) > 2: 
                    norm_prob = math.exp(float(v))/like_sum
                    tlist.append(norm_prob)

            #Calculate credible set size for individual SNP        
            tlist.sort(reverse=True)
            thresh = [0.5,0.75,0.9,0.95]
            needed = [0,0,0,0]
            csum = 0
            csum_cnt = 0
            ind = 0
            tlist_ind = 0
            while ind < 4:
                csum+=tlist[tlist_ind]
                tlist_ind+=1
                csum_cnt+=1
                #print("{} {}".format(csum,tlist_ind))
                if (csum > thresh[ind]):
                    needed[ind] = csum_cnt
                    ind+=1

            #Update category totals with current SNP        
            if "v" in data[categories[vals[2]]]:
                n_ind = 0
                invec = data[categories[vals[2]]]["v"]
                outvec = [0,0,0,0]
                for val in invec:
                    outvec[n_ind]= needed[n_ind] + invec[n_ind]
                    n_ind+=1
                data[categories[vals[2]]]["v"] = outvec                   
            else:
                data[categories[vals[2]]]["v"] = needed

    #Calculate category frequency and calculate average values for each credible set          
    final = {}
    for cat,lab in data.items():
        ofreq = data[cat]["c"]/total_seen
        final[cat] = ofreq
        if "v" in lab:
            outvec = []
            for val in data[cat]["v"]:
                val = float(val)/float(data[cat]["c"])               
                outvec.append(val)
            data[cat]["v"] = outvec
                
        else:
            data[cat]["v"] = [-9,-9,-9,-9]
                
    sorted_final = sorted(final.items(), key=operator.itemgetter(1),reverse=True)

    #Write to output file
    with open(outputfile,'w') as out:
        out.write("AFR\tEUR\tSAS\tEAS\tAMR\tCategory\tFrequency\tAvgCredible_0.5\tAvgCredible_0.75\tAvgCredible_0.90\tAvgCredible_0.95]\n")
        for cat,freq in sorted_final:
            nvec = [ "%.1f" % elem for elem in data[cat]["v"]]
            out.write("{lt[0]}\t{lt[1]}\t{lt[2]}\t{lt[3]}\t{lt[4]}\t{c}\t{d}\t{n[0]}\t{n[1]}\t{n[2]}\t{n[3]}\n".format(lt=cat_ids[cat],n=nvec,c=cat,d=freq))
                        
            
if __name__=="__main__":
    main(sys.argv[1:])
