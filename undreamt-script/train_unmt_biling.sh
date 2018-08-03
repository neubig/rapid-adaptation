multiling="/usr2/data/junjieh/Research/multiling-exp/"
dir="/usr2/data/junjieh/Research/multiling-exp/data"
data_dir="/usr2/data/junjieh/data/multiling"
undreamt="/usr2/data/junjieh/Research/undreamt"
cd $undreamt

for src in aze bel glg slk; do
  output="$multiling/output/${src}_eng"
  mkdir -p $output
  python train.py \
  --src $data_dir/${src}_eng/ted-train.orig.spm8000.${src} \
  --trg $data_dir/${src}_eng/ted-train.mtok.spm8000.eng \
  --src_embeddings ${dir}/${src}_eng/${src}.norm.map.vec \
  --trg_embeddings ${dir}/${src}_eng/eng.norm.map.vec \
  --save ${output}/model --cuda \
  --save_interval 10000
done