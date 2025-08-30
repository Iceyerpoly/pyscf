#!/bin/bash
#SBATCH --partition=pre                       # default "shared", if not specified
#SBATCH --job-name=test                       # Name of your task
#SBATCH --time=1-00:00:00                     # run time in days-hh:mm:ss
#SBATCH --nodes=1                             # require 1 node
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=4000                    # RAM per node in megabytes
#SBATCH --error=job.%J.err                    # Standard error file
#SBATCH --output=job.%J.out                   # Standard output file

source ~/.bashrc
conda activate Gromacs

export LD_LIBRARY_PATH=$MKLROOT/lib:$LD_LIBRARY_PATH

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK #must be equal to cpus-per-task variable above
export PYSCF_MAX_MEMORY=$(($SLURM_CPUS_PER_TASK*$SLURM_MEM_PER_CPU)) #should be equal to the number of CPUs*mem-per-cpu
export PYTHONPATH=/scratch/lhan67/pyscf:$PYTHONPATH

echo "Job $SLURM_JOB_ID started on $(hostname) at $(date +"%Y-%m-%d %H:%M:%S")"
echo "OMP_NUM_THREADS = $OMP_NUM_THREADS"

srun --exclusive --cpu-bind=cores -N 1 -n 1 -c $OMP_NUM_THREADS python test_qmmm.py >> log_$SLURM_JOB_ID.log 2>&1

echo "Job $SLURM_JOB_ID finished on $(hostname) at $(date +"%Y-%m-%d %H:%M:%S")"