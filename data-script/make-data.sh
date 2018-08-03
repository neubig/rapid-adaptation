#!/bin/bash

CDIR=$HOME/usr/local/cdec
MDIR=$HOME/usr/local/mosesdecoder
TDIR=/projects/tir1/corpora/multiling-text/ted

for d in $TDIR/*_eng; do
  d1=`basename $d`
  echo $d1
  mkdir -p data/$d1
  for f in $d/*orig*-eng; do
    f1=`basename $f -eng`
    perl $CDIR/corpus/cut-corpus.pl 1 < $f > data/$d1/$f1
  done
  
  for f in $d/*mtok*-eng; do
    f1=`basename $f`
    f1=`echo $f1 | sed 's/\.[^\.]*$/.eng/g'`
    perl $CDIR/corpus/cut-corpus.pl 2 < $f > data/$d1/$f1
  done
done

mkdir -p data/eng
for split in train dev test; do
  tail -n +2 $TDIR/__multialign/all_talks_$split.tsv | cut -f 1 | perl $MDIR/scripts/tokenizer/tokenizer.perl > data/eng/ted-$split.mtok.eng
done
