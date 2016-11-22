'''
'''

import argparse
import pysam
import sys

parser = argparse.ArgumentParser()
parser.add_argument('--sites', default=None, type=str, help='Sites only vcf assume bi-allelic snps and annonated with frequency and ancestral allele information.', required=True)

def sites_to_allele_frequencies(args):
    '''
    converts sites vcf to table of derived allele frequencies when ancestral state is avaliable or
    alternate allele frequencies otherwise 
    '''
    vcf = pysam.VariantFile(args.sites)
    sys.stdout.write('chrom\tpos\tsnp\ta1\ta2\tf_eas\tf_amr\tf_afr\tf_eur\tf_sas\tallele_type\n')
    for rec in vcf.fetch():
        chrom = rec.chrom
        pos = rec.pos
        rsid = rec.id
        ref_allele = rec.ref
        alt_allele = rec.alts[0]
        # ancestral allele annotation is present at variant
        if 'AA' in list(rec.info):
            ances_allele = rec.info['AA'][0].upper() 
            # ancestral allele is annotated with a base
            if ances_allele in ['A', 'C', 'T', 'G']:
                allele_type = 'derived-ancestral'
                # reference allele is ancestral allele
                if ref_allele == ances_allele:
                    derived_allele = alt_allele
                    f_eas = rec.info['EAS_AF'][0]
                    f_amr = rec.info['AMR_AF'][0]
                    f_afr = rec.info['AFR_AF'][0]
                    f_eur = rec.info['EUR_AF'][0] 
                    f_sas = rec.info['SAS_AF'][0]
                # alternate allele is ancestral allele
                else:
                    derived_allele = ref_allele             
                    f_eas = 1.0 - rec.info['EAS_AF'][0]
                    f_amr = 1.0 - rec.info['AMR_AF'][0]
                    f_afr = 1.0 - rec.info['AFR_AF'][0]
                    f_eur = 1.0 - rec.info['EUR_AF'][0] 
                    f_sas = 1.0 - rec.info['SAS_AF'][0]
            # ancestral allele is not annotated with a base
            else:
                allele_type = 'alternate-reference'
                ances_allele = ref_allele
                derived_allele = alt_allele             
                f_eas = rec.info['EAS_AF'][0]
                f_amr = rec.info['AMR_AF'][0]
                f_afr = rec.info['AFR_AF'][0]
                f_eur = rec.info['EUR_AF'][0] 
                f_sas = rec.info['SAS_AF'][0]
        # ancestral allele annotation is not present at variant
        else:
            allele_type = 'alternate-reference'
            ances_allele = ref_allele
            derived_allele = alt_allele             
            f_eas = rec.info['EAS_AF'][0]
            f_amr = rec.info['AMR_AF'][0]
            f_afr = rec.info['AFR_AF'][0]
            f_eur = rec.info['EUR_AF'][0] 
            f_sas = rec.info['SAS_AF'][0]
        # write to stdout    
        sys.stdout.write('{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\n'.format(chrom, pos, rsid, derived_allele, ances_allele,
                                                                               f_eas, f_amr, f_afr, f_eur, f_sas, allele_type)) 
    
if __name__ == '__main__':
    sites_to_allele_frequencies(parser.parse_args())
