#!/bin/bash

# After xnmt has been installed properly according to README.md, and the data has
# been downloaded, run this script to run all experiments

for f in cfg/{00-bi,01-tri,02-all,03-adapt}/*.yaml; do
  echo "xnmt $f --dynet-gpu"
done
