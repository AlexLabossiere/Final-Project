#!/bin/bash
#SBATCH -t 4:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --mem=48g
#SBATCH --export=NONE
#SBATCH --mail-user=alex_labossiere@uri.edu
#SBATCH --mail-type=BEGIN,END,FAIL

module load QIIME2/2019.7

rawdir=/data/mramseylab/raw_reads/AL_2022
clsdir=/data/mramseylab/classifiers
metadata=/data/mramseylab/metadata/plaque_meta_1.tsv

#for the silva release 132 99 .fna file
#file is present and already converted to .qza for this version of silva

qiime feature-classifier classify-sklearn \
  --i-classifier $clsdir/silva-132-99-nb-classifier.qza \
  --i-reads $rawdir/rep-seqs-1.qza \
  --o-classification $clsdir/silva-taxonomy-AL.qza

#output the taxonomy table to check for classification/contamination strains afterwards.

qiime metadata tabulate \
  --m-input-file $clsdir/silva-taxonomy-AL.qza \
  --o-visualization $clsdir/silva-taxonomy-1.qzv

#SILVA 16s rRNA data base is used to compared the 16s sequences within our samples, these sequences are compared and labeled and placed as a .qza file
#all that needs to be done is to convert the qza to a qzv to then get percent abundaces of the labeled sequences on the species level 
