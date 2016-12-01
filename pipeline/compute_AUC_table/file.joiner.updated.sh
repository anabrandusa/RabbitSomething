### 10/29/2016. Author: Ana Brandusa Pavel

#!/bin/bash
PIPELINE_ROUTE=/restricted/projectnb/pulmseq/Allegro/Bronch_microRNA/edrn243/Analysis/Biomarker_Pipeline/
RABBIT=.
export PATH=${PIPELINE_ROUTE}R/bin/:$PATH
export R_LIBS=${PIPELINE_ROUTE}R_libs_3.2.3
cd ${RABBIT}/Pipeline_Output/
mkdir ${RABBIT}/outputs ${RABBIT}/errors ${RABBIT}/AUC_Result ${RABBIT}/Pipeline_Result  ${RABBIT}/data 
for localedir in $(ls -d *)
do
    echo $localedir" in directory "$PWD
    qsub -o ${RABBIT}/outputs/${localedir}.txt -e ${RABBIT}/errors/${localedir}.txt ${RABBIT}/run.rabbit.shiny.sh ${RABBIT} ${localedir} ${localedir}_out.csv ${localedir}_auc_out.csv
done