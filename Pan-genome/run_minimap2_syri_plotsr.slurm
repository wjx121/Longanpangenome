snakemake --cluster "sbatch --output=/tomato/slurm.logs/%j.out \
--error=/tomato/slurm.logs/%j.out --cpus-per-task={threads} \
--mail-type=END,FAIL --mail-user=2222@126.com --mem={resources.mem_mb} --partition=tcum256c128Partition" \
--jobs 20 -s minimap2_syri_plotsr.smk --configfiles config.yaml -k -p