#!/bin/sh
#SBATCH --gres=gpu:1
#SBATCH --time=200:00:00
#SBATCH --nodes=1
#SBATCH --mem=15000
#SBATCH --job-name="03-adapt"
#SBATCH --mail-user=gneubig@cs.cmu.edu
#SBATCH --mail-type=ALL
##SBATCH --requeue
#Specifies that the job will be requeued after a node failure.
#The default is that the job will not be requeued.

source activate python3
mkdir -p results/03-adapt

for f in cfg/03-adapt/*.yaml; do
  f1=`basename $f .yaml`
  if [[ ! -e results/03-adapt/$f1.started ]]; then
    touch results/03-adapt/$f1.started
    python -m xnmt.xnmt_run_experiments --dynet-gpu $f
  fi
done
