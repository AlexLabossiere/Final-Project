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

# load package and set short cuts to allow easy reproducibility
# table summarize will give info on how many sequences are associated with each sample. This has useful graphs and info w/ sum. stats.
# table tabulate-seqs will map feature IDs to sequences and BLAST that to NCBI. this stuff will be used later on

  qiime dada2 denoise-single \
    --i-demultiplexed-seqs $rawdir/demux-1.qza \
    --p-trim-left 7 \
    --p-trunc-len 260 \
    --o-table $rawdir/denoise-table-1.qza \
    --o-representative-sequences $rawdir/rep-seqs-1.qza \
    --o-denoising-stats $rawdir/denoising-stats-1.qza

# Single denoise was done over double due to the lost in reads we get, single reads allow trunication to appropirate quality without throwing away too many samples
# input is qza from last script (input.sh) output is more qzas
# output is ASVs that are denoised or "cleaner"


# table summarize will give info on how many sequences are associated with each sample. This has useful graphs and info w/ sum. stats.
# table tabulate-seqs will map feature IDs to sequences and BLAST that to NCBI. this stuff will be used later on
#will likely be the slowest script to run

qiime feature-table summarize \
  --i-table $rawdir/denoise-table-1.qza \
  --o-visualization $visdir/table_sum.qzv \
  --m-sample-metadata-file $metadata \

# call command to make a feature table
# input is denoised table that was just made, output is visual that allows us to
# using data from metadata file

qiime feature-table tabulate-seqs \
  --i-data $rawdir/rep-seqs-1.qza \
  --o-visualization $visdir/rep-seqs-1.qzv
  
# taking that QZA we made previous and making it into a visual of sequences with IDs

qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences $rawdir/rep-seqs-1.qza \
  --o-alignment $rawdir/aligned-rep-seqs-1.qza \
  --o-masked-alignment $rawdir/masked-aligned-rep-seqs-1.qza \
  --o-tree $rawdir/unrooted-tree-1.qza \
  --o-rooted-tree $rawdir/rooted-tree-1.qza

# now we us a command that will take out IDs an sequences, and start tree phylogeny in order to do diversity core metrics
# will producde an unrooted and rooted tree these are cruical for work downstream, keep the output of all these files in a place where they wont get lost easily
