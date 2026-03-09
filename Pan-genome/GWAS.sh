
# 1. Data Quality Control & Filtering
# Filters the dataset based on sample list, MAF, and missingness.
plink --bfile $plink_file --keep $keep_sample --maf 0.05 --geno 0.1 --make-bed --out $out_file 

# 2. Data Format Conversion
# Converts the filtered data to transposed format for downstream EMMAX.
plink --bfile $out_file --recode 12 --output-missing-genotype 0 --transpose --out $out_file 

# 3. Kinship Matrix Calculation (K-matrix)
# Generates the genetic relationship matrix (kinship) using EMMAX.
emmax-kin -v -h -d 10 $out_file

# 4. Principal Component Analysis (PCA)
# Performs PCA to infer population structure (for use as covariates).
plink --allow-extra-chr --bfile $out_file --noweb --maf 0.05 --geno 0.1 --pca 10 --out ${out_file}_PCA

# 5. GWAS using EMMAX (with PCA Covariates)
# Runs a genome-wide association study using the EMMAX mixed model.
# PCA components are included as covariates to control for population structure.
emmax -v -d 10 -c $PCA10 -t $GENOTYPE -p ${name}_SV.pheno -k $BN -o ${name}_SV_PCA10.BN