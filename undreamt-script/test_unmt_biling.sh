#!/bin/sh
export CUDA_VISIBLE_DEVICES=$1
mosesdecoder="/home/data/LoReHLT17/internal/MT/tools/mosesdecoder"
home_dir="/usr2/data/junjieh/Research"
multiling="${home_dir}/multiling-exp"
embed_dir="${multiling-exp}/embed"
data_dir="${multiling-exp}/data"
spm_dir="/home/junjieh/usr2/Research/multiling-exp/spm"
spm="/home/data/LoReHLT17/internal/MT/tools/sentencepiece/src"

undreamt="${home_dir}/undreamt"
cd $undreamt

for src in bel glg aze; do #glg slk aze bel 
  output="$multiling/output/${src}_eng"

  train_log="${output}/test.log"

  # CMD="python3 train.py \
  # --src $data_dir/${src}_eng/ted-train.orig.spm8000.${src} \
  # --trg $data_dir/${src}_eng/ted-train.mtok.spm8000.eng \
  # --src_embeddings ${embed_dir}/${src}_eng/${src}.norm.map.vec \
  # --trg_embeddings ${embed_dir}/${src}_eng/eng.norm.map.vec \
  # --save ${output}/model --cuda \
  # --save_interval 30000"
  #CMD="python3 translate.py ${output}/model.final.src2trg.pth < $data_dir/${src}_eng/ted-test.orig.spm8000.${src}  > $output/ted-test.decode.spm8000.eng"

  #echo "$CMD >> $train_log" 
  #echo "$CMD >> $train_log" > $train_log
  #bash -c  "$CMD >> $train_log" 

  #echo "finish unmt decode"

  #wait
  # de-spm
  $spm/spm_decode --model=${spm_dir}/eng/ted-train.mtok.spm8000.eng.model --input_format=piece < ${output}/ted-test.decode.spm8000.eng > ${output}/ted-test.decode.v0.eng
  echo "finish spm decode"

 ${mosesdecoder}/scripts/generic/multi-bleu.perl \
   -lc $data_dir/${src}_eng/ted-test.mtok.eng             \
   < $output/ted-test.decode.v0.eng > ${output}/bleu.v0.txt
 echo "finish bleu $src"
done

