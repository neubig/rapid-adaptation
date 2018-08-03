for f in `cat ../langs.txt`; do
  sed "s/SRC/$f/g; s/CFGID/cfg001/g" < 00-bi.template.yaml > 00-bi/$f.cfg001.yaml
done
