# Final-Project
Final project for  DSP539

Recall from the paper, this information is for an _in vitro_ supragingal biofilm model. The main goal of this research is to be able idenitfy and maintain the a beta diverstiy to that of the initial plaque inocluum and have it maintained throughout a given time period. We want to see which media conditions is best at mantianing the inital plaque diversity.  

--------------KEY NOTE--------------
This scripts for meta filters and control filters are NOT functional 100%, they will give some .qza files but will not excute entire script. Need more testing in order ot progress this 

-----------KEY NOTE-----------
  QZA vs QZV
 QIIME2 takes in raw FASTQ/FASTA files but will convert files into "artifacts" these are files the the computer can make sense of, converting QZA to QZV via qiime can be found on a mulitplex of forms for your specific files
 
----------FILES output----------------
--input.sh----
AL_demuz-temp.qzv 

-----dada2_single.sh ----- 

folder: al_2022_1
  - AL_dmeux-1.qzv
  - rep-seqs-1.qzv
  - table_su.qzv
  - tabluated-feature-metadada.qzv
  - taxa-bar-plots-1.qzv

-----Alpha-Beta-project-1.sh---------- 

- folder al_2022_2
    - holds core-metrics-results (visuals are .qzv)
        - holds bray curits distance matrix
        - evenness group/vector
        - faith pd group/vector
        - jaccard distance
        - emperor plots
        - PCOA plots

--------control-filter-project.sh--------
file: ctrl-filter-AL
        - ctrl-filter-AL-table-AL.qza
        
 --------metadata-filter.sh-----------
 
files: metadata-filter-AL
gives
1-fil-table.qza
2-fil-table.qza
3-fil-table.qza
