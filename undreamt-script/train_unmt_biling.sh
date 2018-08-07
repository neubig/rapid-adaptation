# Path to undreamt (https://github.com/artetxem/undreamt.git)
undreamt="$PWD/undreamt"
out_dir="$PWD/results/undreamt"
dir="$PWD/embed"
data_dir="$PWD/data"

cd $undreamt
for src in aze bel glg slk; do
  output="$out_dir/${src}_eng"
  mkdir -p $output
  python train.py \
  --src $data_dir/${src}_eng/ted-train.orig.spm8000.${src} \
  --trg $data_dir/${src}_eng/ted-train.mtok.spm8000.eng \
  --src_embeddings ${dir}/${src}_eng/${src}.norm.map.vec \
  --trg_embeddings ${dir}/${src}_eng/eng.norm.map.vec \
  --save ${output}/model --cuda \
  --save_interval 10000
done