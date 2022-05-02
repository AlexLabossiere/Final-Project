#!/bin/bash
#SBATCH -t 4:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --mem=24g
#SBATCH --export=NONE
#SBATCH --mail-user=alex_labossiere@uri.edu
#SBATCH --mail-type=BEGIN,END,FAIL


module load QIIME2/2019.7

procdir=/data/mramseylab/proc_reads/al_2022_2/core-metrics-results
clsdir=/data/mramseylab/classifiers
metadata=/data/mramseylab/metadata/plaque_meta_1.tsv
visdir=/data/mramseylab/visualizations/al_2022_1

qiime taxa barplot \
  --i-table $procdir/rarefied_table.qza \
  --i-taxonomy $clsdir/silva-taxonomy-AL.qza \
  --m-metadata-file $metadata \
  --o-visualization $visdir/taxa-bar-plots-1.qzv

# takes the output file from classifier and uses it as imput, uses metadata from user to place taxa within samples, visualization shows % abundance of organisms
# within given samples. Can use dropdown from view.qiime2.org to seperate samples based on subject and days, you can now see how the difference in organisms %
# abundaces changes over time of the expirment
# recall this is what we need but there is bias within our samples, we need to put this data through a series of filters in order to take out
# any remainder "noise" or bias within samples (this can be bias from gDNA found in water, saliva, mucin, etc.)
