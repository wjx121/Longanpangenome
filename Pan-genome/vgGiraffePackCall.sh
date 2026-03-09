gbz="tomato.giraffe.gbz"
dist="tomato.dist"
min="tomato.min"


metafile="tomato.csv"
input="$(awk -v var="$SLURM_ARRAY_TASK_ID" -F "," ' $1 == var {print;} ' $metafile)"
name=`echo $input | awk -F "," '{ print $2}'`
vg giraffe -p -t 128 -Z $gbz -d $dist -m $min -f ${name}_R1_clean.fq.gz -f ${name}_R2_clean.fq.gz >${name}.gam
vg pack -t 128 -x $gbz -g ${name}.gam -Q 5 -s 5 -o ${name}.pack
vg call -t 128 -a -s ${name} -k ${name}.pack $gbz > ${name}.vcf
bgzip ${name}.vcf
bcftools index ${name}.vcf.gz