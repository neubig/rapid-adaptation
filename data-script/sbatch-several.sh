for i in `seq 4`; do
  # sbatch cfg/00-bi.sbatch.sh
  # sbatch cfg/01-tri.sbatch.sh
  sbatch cfg/02-all.sbatch.sh
  # sbatch cfg/03-adapt.sbatch.sh
  sleep 15
done
