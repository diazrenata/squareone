#!/bin/bash
#SBATCH --job-name=ldats-soar-2020   # Job name
#SBATCH --mail-type=ALL               # Mail events (NONE, BEGIN, END, FAIL, AL$
#SBATCH --mail-user=diaz.renata@ufl.edu   # Where to send mail
#SBATCH --account=ewhite
#SBATCH --qos=ewhite-b
#SBATCH --ntasks=1                 # Number of MPI ranks
#SBATCH --cpus-per-task=1            # Number of cores per MPI rank
#SBATCH --mem-per-cpu=8GB
#SBATCH --time=24:00:00       #Time limit hrs:min:sec
#SBATCH --output analyses/plants/ldats/pipeline%j.out
#SBATCH --error analyses/plants/ldats/pipeline%j.err

#This is a generic R submission script
module load R
Rscript analyses/plants/ldats/crossval_soar_pipeline.R
