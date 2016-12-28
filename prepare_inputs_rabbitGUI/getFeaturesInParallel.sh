#!/bin/bash
RABBIT_SHINY=${PWD}
PIPELINE_ROUTE=/restricted/projectnb/pulmseq/Allegro/Bronch_microRNA/edrn243/Analysis/Biomarker_Pipeline/rabbit/rabbit_upd_joe_2016/rabbit/Pipeline_Output_2016_12_16_good
#export PATH=${PIPELINE_ROUTE}R/bin/:$PATH
#export R_LIBS=${PIPELINE_ROUTE}R_libs_3.2.3
mkdir ${RABBIT_SHINY}/modelFeatures ${RABBIT_SHINY}/featureOutputs ${RABBIT_SHINY}/featureErrors
rm -f ${RABBIT_SHINY}/modelFeatures/*.txt ${RABBIT_SHINY}/featureOutputs/*.txt ${RABBIT_SHINY}/featureErrors/*.txt
cd ${PIPELINE_ROUTE}/cv_loop_1
for modelFolder in $(ls -d */)
do
    modelName=${modelFolder%%/}
   qsub -o ${RABBIT_SHINY}/featureOutputs/${modelName}.txt -e ${RABBIT_SHINY}/featureErrors/${modelName}.txt ${RABBIT_SHINY}/processModelFeatures.sh ${PIPELINE_ROUTE} ${modelName} ${RABBIT_SHINY}/modelFeatures
done