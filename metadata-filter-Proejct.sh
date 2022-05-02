#!/bin/bash
#SBATCH -t 8:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --mem=24g
#SBATCH --export=NONE
#SBATCH --mail-user=alex_labossiere@uri.edu
#SBATCH --mail-type=BEGIN,END,FAIL

module load QIIME2/2019.7

tablein=/data/mramseylab/raw_reads/AL_2022/denoise-table-1.qza
clsdir=/data/mramseylab/classifiers/
metadir=/data/mramseylab/metadata/plaque_meta_1.tsv
visdir=/data/mramseylab/visualizations/
filtdir=/data/mramseylab/proc_reads/

# filter status of input files, "initial" is the 1st pass no filter at all
# "initial-human" is the initial data but for only human samples, no mock or control samples

fil=metadata-filter-AL

#note must make directores needed BEFORE running the below command

mkdir $filtdir$fil

array=( "1% mucin" "25% Saliva" "1 mM Glucose" ) #issue from here is using % will mess up the name, i used a simple math array to make the files file-1, file-2, file-3 but i can overcome this by simply changing the names of the conditions within the metadata folder

x=1

for i in "${array[@]}"
do
qiime feature-table filter-samples \
--i-table $tablein \
--m-metadata-file $metadir \
--p-where "[media-types]='$i'" \
--o-filtered-table  $filtdir$fil/$x-fil-table.qza

qiime feature-table filter-features \
--i-table $filtdir$fil/$x-fil-table.qza \
--m-metadata-file  $metadir \
--o-filtered-table $filtdir$fil/$x-fil-table.qza
#SCRIPT WILL ONLY GET TO THIS POINT
# gets up to thise point, everything after this becomes empty and does not work. script false almost 30 seconds after starting
#I dont really understand why but i know it has somethign to do with the filter tables and for some reason the counts become 0
#i get 3 tables entitled 1-fil-table, 2-fil-table and 3-fil-table 

qiime taxa collapse \
--i-table $filtdir$fil/$x-fil-table.qza \
--i-taxonomy $clsdir\silva-mod-taxonomy.qza \
--p-level 6 \
--o-collapsed-table $filtdir$fil/$x-fil-collapse-table.qza

qiime feature-table relative-frequency \
--i-table $filtdir$fil/$x-fil-collapse-table.qza \
--o-relative-frequency-table $filtdir$fil/$x-fil-relative-collapse-table.qza

qiime tools export \
--input-path $filtdir$fil/$x-fil-relative-collapse-table.qza \
--output-path $filtdir$fil/$x-feature-table-AL

biom convert \
-i $filtdir$fil/$x-feature-table-AL.biom \
-o $filtdir$fil/$x-fil-relative-collapse-table.txt \
--header-key “taxonomy” \
--to- tsv

done
