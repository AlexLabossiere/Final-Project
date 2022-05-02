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
visdir=/data/mramseylab/visualizations/al_2022_1/
filtdir=/data/mramseylab/proc_reads/
# filter status of input files, "ctrl-filter" is just for taxa belonging to no template controls
fil=ctrl-filter-AL


# must make the directory you are filtering to 1st or else it will error
mkdir $filtdir$fil


qiime feature-table filter-samples \
  --i-table $tablein \
  --m-metadata-file $metadir \
  --p-where "[body-site]='control'" \
  --o-filtered-table $filtdir$fil/$fil-table-AL.qza
# this command is for the purpose of filtering, in this command i am telling the program to input already made denoise table and align the information from the
# meta data to the table, and only include the reads from the control, filter that into a QZA

qiime taxa collapse \
  --i-table $filtdir$fil/$fil-table-AL.qza \
  --i-taxonomy $clsdir\silva-mod-taxonomy.qza \
  --p-level 6 \
  --o-collapsed-table $filtdir$fil/$fil-collapse-table-AL.qza

  # this calls for the QZA we just made and to use the SILVA QZA reference we made eariler, using the genus level collapse that information into a qza table

qiime feature-table relative-frequency \
  --i-table $filtdir$fil/$fil-collapse-table-AL.qza \
  --o-relative-frequency-table $filtdir$fil/$fil-relative-collapse-table-AL.qza

  # here is just an extra line in order to get certain IDs for each sqeuncces

qiime tools export \
  --input-path $filtdir$fil/$fil-relative-collapse-table-AL.qza \
  --output-path $filtdir$fil/

biom convert \
-i $filtdir$fil/feature-table-.biom \
-o $filtdir$fil/$fil-relative-collapse-table-AL.txt \
--header-key “taxonomy” \
--to-tsv
# Not sure where the .biom file comes from, i think this come from the exporting tool which makes the qza into a .biom
# this is where I had mentioned in the paper that this is where everything gets a little funky
# apparently this just makes out qza into a tsv through a middle step but using our previously established pipeline, and i still have to understand
# if this part is even needed
# Use above taxa table to filter out based on taxa present in controls

qiime feature-table filter-features \
  --i-table $tablein \
  --m-metadata-file $filtdir$fil/$fil-collapse-table-AL.qza \
  --o-filtered-table $filtdir$fil/$fil-excluded-table-AL.qza \
  --p-exclude-ids

# Use excluded table to generate barplot for checking

qiime taxa barplot \
  --i-table $filtdir$fil/$fil-excluded-table-AL.qza \
  --i-taxonomy $clsdir\silva-mod-taxonomy.qza \
  --m-metadata-file $metadir \
  --o-visualization $filtdir$fil\$fil-excluded-table-AL.qzv
 
# Is this all to make sure we can properly filter out just the control
# Had just noticed while making these edits too a '\' was acutal facing the wrong way. This could be one soltuion to a few issues that arise from this script
# for example nothing from this script will be made,an error occurs because a file is empty but im not sure where
# however the other metadata filter works up to a certain point,  getting this 'control only' data is where i was stuck at the start of this semester
# As of now I havet to look back into the slurms to figure out what went wrong, but i certainly have more of an idea of what went wrong now rather than the starting
# of this semester
