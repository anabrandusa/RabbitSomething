#!/bin/bash
RABBIT_SHINY=${PWD}
PIPELINE_ROUTE=/restricted/projectnb/pulmseq/Allegro/Bronch_microRNA/edrn243/Analysis/Biomarker_Pipeline/rabbit/rabbit_upd_joe_2016/rabbit/Pipeline_Output
#export PATH=${PIPELINE_ROUTE}R/bin/:$PATH
#export R_LIBS=${PIPELINE_ROUTE}R_libs_3.2.3
Rscript ${RABBIT_SHINY}/getWeightedVotingModels.R ${RABBIT_SHINY}
mkdir ${RABBIT_SHINY}/outputs ${RABBIT_SHINY}/errors ${RABBIT_SHINY}/AUC_Result ${RABBIT_SHINY}/Pipeline_Result ${RABBIT_SHINY}/weightedVoting
cd ${PIPELINE_ROUTE}
for localedir in $(ls -d *)
do
    echo $localedir" in directory "$PWD
    qsub -o ${RABBIT_SHINY}/outputs/${localedir}.txt -e ${RABBIT_SHINY}/errors/${localedir}.txt ${RABBIT_SHINY}/run.rabbit.shiny.sh ${RABBIT_SHINY} ${PIPELINE_ROUTE}/${localedir} ${localedir}_out.csv ${localedir}_auc_out.csv
done