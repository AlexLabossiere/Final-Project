#!/bin/bash
#SBATCH -t 4:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --mem=24g
#SBATCH --export=NONE
#SBATCH --mail-user=alex_labossiere@uri.edu
#SBATCH --mail-type=BEGIN,END,FAIL

module load QIIME2/2019.7
rawdir=/data/mramseylab/raw_reads/AL_2022/

# above loads package and sets definition for shortcuts

qiime tools import \
--type 'SampleData[PairedEndSequencesWithQuality]' \
--input-path $rawdir \
--input-format CasavaOneEightSingleLanePerSampleDirFmt \
--output-path $rawdir/demux-1.qza

# above starts by calling the import tools
# we input what type of demultiplex we want to do
# input where the genomes are
# output the demutiplex file/name file to whatever you want

qiime demux summarize \
--i-data $rawdir/demux-1.qza \
--o-visualization /data/mramseylab/visualizations/AL_demux-1.qzv
# calls for summery table
# inputs QZA we just made, make its into a visual to see the sequnces and IDs
# take this visual (qvz) to view.qiime2.org to have an interactive view functions
# use this visual to see where cutting/trimming need to be done
done

 #this is done when files are uploaded to wanted directory
