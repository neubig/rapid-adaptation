mosesdecoder="/home/data/LoReHLT17/internal/MT/tools/mosesdecoder"
dir="/usr2/data/junjieh/data/multiling"
out_dir="/usr2/data/junjieh/Research/multiling-exp/data"
mkdir -p $out_dir/all_eng

echo "${mosesdecoder}/bin/lmplz -o 5 < $dir/all_eng/ted-train.mtok.spm8000.eng > $out_dir/all_eng/ted-train.mtok.spm8000.eng.lm5.arpa"
${mosesdecoder}/bin/lmplz -o 5 < $dir/all_eng/ted-train.mtok.spm8000.eng > $out_dir/all_eng/ted-train.mtok.spm8000.eng.lm5.arpa

echo "${mosesdecoder}/bin/build_binary $out_dir/all_eng/ted-train.mtok.spm8000.eng.lm5.arpa $out_dir/all_eng/ted-train.mtok.spm8000.eng.lm5.bin"
${mosesdecoder}/bin/build_binary $out_dir/all_eng/ted-train.mtok.spm8000.eng.lm5.arpa $out_dir/all_eng/ted-train.mtok.spm8000.eng.lm5.bin

echo "finish!"
