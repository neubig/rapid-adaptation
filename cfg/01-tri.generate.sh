
mkdir -p 01-tri
for g in cfg002; do
# for g in cfg000 cfg001 cfg002; do
  cat ../lang-pairs.txt | while read f; do
  # for f in "mon tur"; do
    echo $f $g
    f1=`echo $f | cut -f 1 -d ' '`
    f2=`echo $f | cut -f 2 -d ' '`
    sed "s/SRC1/$f1/g; s/SRC2/$f2/g; s/CFGID/$g/g" < 01-tri.template.$g.yaml > 01-tri/$f1$f2.$g.yaml
  done
done
