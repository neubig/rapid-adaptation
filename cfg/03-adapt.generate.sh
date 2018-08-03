mkdir -p 03-adapt
for cfg in cfg01{2,3,4,5,6,7}; do
  grep -v mon ../lang-pairs.txt | while read f; do
    echo $f
    f1=`echo $f | cut -f 1 -d ' '`
    f2=`echo $f | cut -f 2 -d ' '`
    sed "s/SRC1/$f1/g; s/SRC2/$f2/g; s/CFGID/$cfg/g" < 03-adapt.template.$cfg.yaml > 03-adapt/$f1$f2.$cfg.yaml
  done
done
