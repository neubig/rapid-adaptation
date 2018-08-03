#!/bin/sh
#SBATCH --gres=gpu:1
#SBATCH --time=192:00:00
#SBATCH --nodes=1
#SBATCH --mem=32000
#SBATCH --job-name="02-all"
#SBATCH --mail-user=gneubig@cs.cmu.edu
#SBATCH --mail-type=ALL
##SBATCH --requeue
#Specifies that the job will be requeued after a node failure.
#The default is that the job will not be requeued.

source activate python3
mkdir -p results/02-all
for f in cfg/02-all/*.yaml; do
  f1=`basename $f .yaml`
  if [[ ! -e results/02-all/$f1.started ]]; then
    touch results/02-all/$f1.started
    python -m xnmt.xnmt_run_experiments --dynet-gpu $f
  fi
done
