#!/bin/bash

#SBATCH -A m2_datamining
#SBATCH -p longtime 
#SBATCH -J "MRS Analysis" # gives SLURM_JOB_NAME
#SBATCH -n 1 # gives SLURM_NTASKS
#SBATCH -t 10-00 
#SBATCH --cpus-per-task=5
#SBATCH --mem=16G
#SBATCH --array=1-3

N_CV_REPEATS=50

source ~/.bashrc
conda_initialize
micromamba activate feature_weighted_mrs

CONFIG=gbs_statistical_analysis.config
MRS_FUNCTION=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $CONFIG)
DATASET=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $3}' $CONFIG)
DROP=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $4}' $CONFIG)

srun python ../src/weighting_experiment.py --data_set_name $DATASET  --n_cv_repeats $N_CV_REPEATS  \
            --drop $DROP --mrs_function $MRS_FUNCTION --load_previous_results --experiment_name=statistical_analysis