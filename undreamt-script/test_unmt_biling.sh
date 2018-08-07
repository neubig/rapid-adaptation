#!/bin/sh
# Path to mosesdecoder (https://github.com/moses-smt/mosesdecoder.git)
mosesdecoder="mosesdecoder"

# Path to SentencePiece (https://github.com/google/sentencepiece.git)
spm="sentencepiece/src"

# Path to undreamt (https://github.com/artetxem/undreamt.git)
undreamt="undreamt"

home_dir=$PWD
multiling="${home_dir}/results/undreamt"
embed_dir="${home_dir}/embed"
data_dir="${home_dir}/data"
spm_dir="${home_dir}/spm"

cd $undreamt
for src in bel glg aze; do #glg slk aze bel 
  output="$multiling/${src}_eng"

  train_log="${output}/test.log"

  CMD="python3 translate.py ${output}/model.final.src2trg.pth < $data_dir/${src}_eng/ted-test.orig.spm8000.${src}  > $output/ted-test.decode.spm8000.eng"
  
  wait
  # de-spm
  $spm/spm_decode --model=${spm_dir}/eng/ted-train.mtok.spm8000.eng.model --input_format=piece < ${output}/ted-test.decode.spm8000.eng > ${output}/ted-test.decode.v0.eng
  echo "finish spm decode"

 ${mosesdecoder}/scripts/generic/multi-bleu.perl \
   -lc $data_dir/${src}_eng/ted-test.mtok.eng             \
   < $output/ted-test.decode.v0.eng > ${output}/bleu.v0.txt
 echo "finish bleu $src"
done

