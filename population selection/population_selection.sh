gzvcf=$workdir/clean.vcf.gz
window=100000
step=10000

# pi
vcftools --gzvcf $gzvcf \
--window-pi $window --window-pi-step $step \
--keep wild_popid.txt --out pi.wild
vcftools --gzvcf $gzvcf \
--window-pi $window --window-pi-step $step \
--keep cultivated_popid.txt --out pi.cultivated

# Fst
vcftools --gzvcf $gzvcf --fst-window-size $window --fst-window-step $step \
--weir-fst-pop wild_popid.txt --weir-fst-pop cultivated_popid.txt --out Fst.wild.cultivated

# ROD
./calc_rod.pl -a pi.cultivated.windowed.pi -b pi.wild.windowed.pi -o ./results -p ROD

# XP-CLR
for i in Chr1 Chr2 Chr3 Chr4 Chr5 Chr6 Chr7 Chr8 Chr9 Chr10 Chr11 Chr12 Chr13 Chr14 Chr15;do
xpclr --format vcf --input $workdir/clean.vcf.gz \
--samplesA wild_popid.txt --samplesB cultivated_popid.txt \
--out ./$i.xpclr --chr $i \
--size $window --step $step --maxsnps 200 --minsnps 5
done

awk 'FNR==1 && NR!=1{next;}{print}' *.xpclr >all.chr.xpclr