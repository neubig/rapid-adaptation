
for f in cfg001; do 
  s=`python script/average-scores.py results/00-bi/{aze,bel,glg,slk}.$f.log`
  echo "bi.$f	$s"
done

for f in cfg000 cfg001 cfg002; do 
  s=`python script/average-scores.py results/01-tri/{azetur,belrus,glgpor,slkces}.$f.log`
  echo "tri.$f	$s"
done

for f in cfg000; do 
  s=`python script/average-scores.py --reduce_idxs "0,1,2,3 4,5,6,7" results/02-all/all.$f.log`
  echo "all.$f	$s"
done

for f in cfg002 cfg003 cfg008 cfg009 cfg010 cfg011; do 
  s=`python script/average-scores.py results/03-adapt/{azetur,belrus,glgpor,slkces}.$f.log`
  echo "adapt.$f	$s"
done
