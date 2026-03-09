# Input
bowtie2 -p 120 -x Ref -1 Input-CENH3_1.clean.fq.gz -2 Input-CENH3_2.clean.fq.gz -S Input-CENH3.sam --no-mixed --no-discordant --maxins 1000
samtools sort -@ 120 -o Input-CENH3_sorted.bam Input-CENH3.sam
samtools index -c Input-CENH3_sorted.bam
alignmentSieve --numberOfProcessors 120 --bam Input-CENH3_sorted.bam --outFile Input-CENH3_final.bam --filterMetrics Input-CENH3_alignment.log --ignoreDuplicates --minMappingQuality 25 --samFlagExclude 260
samtools index -c Input-CENH3_final.bam

# CENH3
bowtie2 -p 120 -x Ref -1 CENH3_1.clean.fq.gz -2 CENH3_2.clean.fq.gz -S IP-CENH3.sam --no-mixed --no-discordant --maxins 1000
samtools sort -@ 120 -o IP-CENH3_sorted.bam IP-CENH3.sam
samtools index -c IP-CENH3_sorted.bam
alignmentSieve --numberOfProcessors 120 --bam IP-CENH3_sorted.bam --outFile IP-CENH3_final.bam --filterMetrics IP-CENH3_alignment.log --ignoreDuplicates --minMappingQuality 25 --samFlagExclude 260
samtools index -c IP-CENH3_final.bam


bamCompare -p 50 -b1 IP-CENH3_final.bam -b2 Input-CENH3_final.bam --binSize 1000 -o CENH3.log2ratio_1k.bdg --outFileFormat bedgraph
bamCompare -p 50 -b1 IP-CENH3_final.bam -b2 Input-CENH3_final.bam --binSize 1000 -o CENH3.log2ratio_1k.bw --outFileFormat bigwig