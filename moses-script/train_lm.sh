# Path to mosesdecoder (https://github.com/moses-smt/mosesdecoder.git)
mosesdecoder="mosesdecoder"  

dir="data/"
out_dir="data/"
mkdir -p $out_dir/all_eng

echo "${mosesdecoder}/bin/lmplz -o 5 < $dir/all_eng/ted-train.mtok.spm8000.eng > $out_dir/all_eng/ted-train.mtok.spm8000.eng.lm5.arpa"
${mosesdecoder}/bin/lmplz -o 5 < $dir/all_eng/ted-train.mtok.spm8000.eng > $out_dir/all_eng/ted-train.mtok.spm8000.eng.lm5.arpa

echo "${mosesdecoder}/bin/build_binary $out_dir/all_eng/ted-train.mtok.spm8000.eng.lm5.arpa $out_dir/all_eng/ted-train.mtok.spm8000.eng.lm5.bin"
${mosesdecoder}/bin/build_binary $out_dir/all_eng/ted-train.mtok.spm8000.eng.lm5.arpa $out_dir/all_eng/ted-train.mtok.spm8000.eng.lm5.bin

echo "finish!"
