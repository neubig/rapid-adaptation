#!/bin/sh
#SBATCH --gres=gpu:1
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --mem=15000
#SBATCH --job-name="00-bi"
#SBATCH --mail-user=gneubig@cs.cmu.edu
#SBATCH --mail-type=ALL
##SBATCH --requeue
#Specifies that the job will be requeued after a node failure.
#The default is that the job will not be requeued.

source activate python3
mkdir -p results/00-bi

for f in cfg/00-bi/*.cfg001.yaml; do
# for f in cfg/00-bi/{bel,slk,glg,aze}.cfg001.yaml; do
  f1=`basename $f .yaml`
  if [[ ! -e results/00-bi/$f1.started ]]; then
    touch results/00-bi/$f1.started
    python -m xnmt.xnmt_run_experiments --dynet-gpu $f
  fi
done
