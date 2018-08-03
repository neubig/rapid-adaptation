
# cat lang-pairs.txt | while read f; do
for f in 'mon tur'; do
  echo $f
  f1=`echo $f | cut -f 1 -d ' '`
  f2=`echo $f | cut -f 2 -d ' '`
  fd=data/${f1}${f2}_eng
  mkdir -p $fd
  for split in train dev test; do
    cat data/${f1}_eng/ted-$split.orig.$f1 data/${f2}_eng/ted-$split.orig.$f2 > $fd/ted-$split.orig.${f1}${f2}
    cat data/${f1}_eng/ted-$split.mtok.eng data/${f2}_eng/ted-$split.mtok.eng > $fd/ted-$split.mtok.eng
    cat data/${f1}_eng/ted-$split.orig.spm8000.$f1 data/${f2}_eng/ted-$split.orig.spm8000.$f2 > $fd/ted-$split.orig.sepspm8000.${f1}${f2}
    cat data/${f1}_eng/ted-$split.mtok.spm8000.eng data/${f2}_eng/ted-$split.mtok.spm8000.eng > $fd/ted-$split.mtok.spm8000.eng
  done
done
