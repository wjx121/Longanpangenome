hifiasm -o ${name}.asm -t 120 --ul $ont $hifi
awk '/^S/{print ">"$2;print $3}' ${name}.asm.bp.p_ctg.gfa > ${name}.asm.hic.p_ctg.fna
samtools faidx ${name}.asm.hic.p_ctg.fna
assembly-stats ${name}.asm.hic.p_ctg.fna >> ${name}.asm.stats
