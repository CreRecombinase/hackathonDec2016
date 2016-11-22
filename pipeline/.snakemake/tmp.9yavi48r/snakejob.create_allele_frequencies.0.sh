#!/bin/sh
# properties = {"threads": 1, "cluster": {"err": "data/log/create_allele_frequencies-%j.err", "out": "data/log/create_allele_frequencies-%j.out", "mem": "4G", "time": "12:00:00"}, "input": ["/home/jhmarcus/novembre_lab/data/external_public/1kg_phase3/ALL.wgs.phase3_shapeit2_mvncall_integrated_v5b.20130502.sites.biallelic_snps.vcf.gz"], "local": false, "output": ["data/allele_frequencies/1kg_phase3_allele_frequencies.tsv.gz"], "rule": "create_allele_frequencies", "params": {}, "resources": {}}
cd /project/jnovembre/jhmarcus/hackathonDec2016/pipeline && \
/home/jhmarcus/anaconda3/envs/hack2016_env/bin/snakemake data/allele_frequencies/1kg_phase3_allele_frequencies.tsv.gz --snakefile /project/jnovembre/jhmarcus/hackathonDec2016/pipeline/Snakefile \
--force -j --keep-target-files --keep-shadow --keep-remote \
--wait-for-files /home/jhmarcus/novembre_lab/data/external_public/1kg_phase3/ALL.wgs.phase3_shapeit2_mvncall_integrated_v5b.20130502.sites.biallelic_snps.vcf.gz /project/jnovembre/jhmarcus/hackathonDec2016/pipeline/.snakemake/tmp.9yavi48r --latency-wait 5 \
--benchmark-repeats 1 \
--force-use-threads --wrapper-prefix https://bitbucket.org/snakemake/snakemake-wrappers/raw/ \
  --nocolor \
--notemp --quiet --no-hooks --nolock --printshellcmds  --force-use-threads  --allowed-rules create_allele_frequencies  && touch "/project/jnovembre/jhmarcus/hackathonDec2016/pipeline/.snakemake/tmp.9yavi48r/0.jobfinished" || (touch "/project/jnovembre/jhmarcus/hackathonDec2016/pipeline/.snakemake/tmp.9yavi48r/0.jobfailed"; exit 1)

