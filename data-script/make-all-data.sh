

fd=data/all_eng
# mkdir -p $fd
# rm -f $fd/ted-$split.orig.all $fd/ted-$split.mtok.eng $fd/ted-$split.orig.sepspm8000.all $fd/ted-$split.mtok.spm8000.eng
# for f in `cat langs.txt`; do
#   for split in train dev test; do
#     cat data/${f}_eng/ted-$split.orig.$f >> $fd/ted-$split.orig.all
#     cat data/${f}_eng/ted-$split.mtok.eng >> $fd/ted-$split.mtok.eng
#     cat data/${f}_eng/ted-$split.orig.spm8000.$f >> $fd/ted-$split.orig.sepspm8000.all
#     cat data/${f}_eng/ted-$split.mtok.spm8000.eng >> $fd/ted-$split.mtok.spm8000.eng
#   done
# done

# for g in `cat lang-pairs.txt | sed 's/ .*//g'`; do
for g in mon; do
  fd=data/allbut${g}_eng
  mkdir -p $fd
  rm -f $fd/ted-$split.orig.all $fd/ted-$split.mtok.eng $fd/ted-$split.orig.sepspm8000.all $fd/ted-$split.mtok.spm8000.eng
  for f in `cat langs.txt`; do
    if [[ $g != $f ]]; then 
      split=train
      cat data/${f}_eng/ted-$split.orig.$f >> $fd/ted-$split.orig.all
      cat data/${f}_eng/ted-$split.mtok.eng >> $fd/ted-$split.mtok.eng
      cat data/${f}_eng/ted-$split.orig.spm8000.$f >> $fd/ted-$split.orig.sepspm8000.all
      cat data/${f}_eng/ted-$split.mtok.spm8000.eng >> $fd/ted-$split.mtok.spm8000.eng
    fi
  done
done
