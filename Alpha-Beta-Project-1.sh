#!/bin/bash
#SBATCH -t 4:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --mem=24g
#SBATCH --export=NONE
#SBATCH --mail-user=alex_labossiere@uri.edu
#SBATCH --mail-type=BEGIN,END,FAIL
module load QIIME2/2019.7

rawdir=/data/mramseylab/raw_reads/AL_2022
visdir=/data/mramseylab/visualizations/al_2022_1
metadata=/data/mramseylab/metadata/plaque_meta_1.tsv
procdir=/data/mramseylab/proc_reads/al_2022_2/
cmr="core-metrics-results"

# loading program and having shortcuts to easily change files if needbe

qiime diversity core-metrics-phylogenetic \
--i-phylogeny $rawdir/rooted-tree-1.qza \
--i-table $rawdir/denoise-table-1.qza \
--p-sampling-depth 19915 \
--m-metadata-file $metadata \
--output-dir $procdir$cmr

# uses trees and denoising table, finding sampling depth (to understand which depth you need, QIIME2 'moving pictures' tutorials have can explain more)
# using metadata folders for samples information
#output-dir will give out a handful of files for alpha divertiy (shannons diverity, faiths PD, evenness)
#beta diversity files will be (jaccard distance, bray-curtist, unweighted/weighted UniFrac distace)
#these are all in QZA (artfacts) you make much from these, but you can convert the artifacts into visuals
#all codes below are just converting the .qza to specific .qzv and these files can be viewed on "view.qiime2.org"


qiime diversity alpha-group-significance \
--i-alpha-diversity $procdir$cmr/faith_pd_vector.qza \
--m-metadata-file $metadata \
--o-visualization $procdir$cmr/faith-pd-group-significance.qzv
 #calling command for alpha diverity files
 #input the wanted file for alpha diversity
 #use meta data folder for sample reference
 #output a visual

 #everything below is the same thing, an array is done for the beta diversity instead of copy and pasting the same code 6 times

qiime diversity alpha-group-significance \
--i-alpha-diversity $procdir$cmr/evenness_vector.qza \
--m-metadata-file $metadata \
--o-visualization $procdir$cmr/evenness-group-significance.qzv

array=( unweighted_unifrac_distance_matrix weighted_unifrac_distance_matrix bray_curtis_distance_matrix )

for i in "${array[@]}"
do


qiime diversity beta-group-significance \
--i-distance-matrix $procdir$cmr/$i.qza \
--m-metadata-file $metadata \
--m-metadata-column subject \
--o-visualization $procdir$cmr/$i.qzv \
--p-pairwise

done
