bash  /software/3d-dna/run-asm-pipeline-post-review.sh --sort-output -i 10000 -q 0 -r /tomato1/assembly/assembly/${sname}/3ddna2/${sname}.p_ctg.final.review.assembly ${name}.asm.hic.p_ctg.fna /tomato1/assembly/assembly/${sname}/juicer/aligned/merged_nodups.txt
assembly-stats ${sname}.p_ctg.hifiont.FINAL.fasta >> ${maindir}${name}/${name}.asm.stats
