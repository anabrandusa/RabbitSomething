# 10/29/2016. Author: Ana Brandusa Pavel

#!/bin/bash
#
# Run this file using 'qsub job.sh'
#
# All lines starting with "#$" are SGE qsub commands
#

# Specify which shell to use
#$ -S /bin/bash

# Run on the current working directory
#$ -cwd

# Join standard output and error to a single file
#$ -j y

#$ -l h_rt=48:00:00
#$ -V

# Set Memory allocation
#$ -l mem_free=30g

# Set group
#$ -P pulmseq

# Send an email when the job begins and when it ends running
## $ -m e

# Whom to send the email to
## $ -M anapavel@bu.edu
# Now let's keep track of some information just in case anything goes wrong

#module load R/R-3.1.1
#export R_LIBS=/restricted/projectnb/pulmseq/Allegro/Bronch_microRNA/edrn243/Analysis/Biomarker_Pipeline/R_libs_rabbit/

echo "=========================================================="
echo "Starting on       : $(date)"
echo "Running on node   : $(hostname)"
echo "Current directory : $(pwd)"
echo "Current job ID    : $JOB_ID"
echo "Current job name  : $JOB_NAME"
echo "Task index number : $TASK_ID"
echo "=========================================================="
echo ""

Rscript ./buildJoinIterationFileClust.R $1 $2 $3 $4