

mkdir -p 02-all
cid=cfg002
for f in `cat ../lang-pairs.txt | sed 's/ .*//g'`; do
  sed "s/CFGID/$cid/g; s/SRC/$f/g" < 02-all.template.$cid.yaml > 02-all/allbut$f.$cid.yaml
done
