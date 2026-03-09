mkdir fastq
mkdir references
mkdir restriction_sites
cd references
ln -s ${name}.asm.hic.p_ctg.fna ./${sname}.fasta
bwa index $sname.fasta
python /software/juicer/misc/generate_site_positions.py DpnII $sname ${sname}.fasta
cd ..
mv references/${sname}_DpnII.txt restriction_sites/${sname}_DpnII.txt
awk 'BEGIN { OFS = "\t" } { print $1, $NF }' restriction_sites/${sname}_DpnII.txt > restriction_sites/${sname}.chrom.sizes
ln -s ${hic}1.fq.gz fastq/reads_R1.fastq.gz
ln -s ${hic}2.fq.gz fastq/reads_R2.fastq.gz
ln -s /software/juicer/SLURM/scripts/ scripts
/software/juicer/SLURM/scripts/juicer.sh -g ${sname} -z references/${sname}.fasta -p restriction_sites/${sname}.chrom.sizes -y restriction_sites/${sname}_DpnII.txt -s DpnII -t 120 -q tcum256c128Partition -l tcum256c128Partition -D . --assembly


