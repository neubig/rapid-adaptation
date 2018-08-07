# Path to mosesdecoder (https://github.com/moses-smt/mosesdecoder.git)
mosesdecoder="mosesdecoder"

# Path to SentencePiece (https://github.com/google/sentencepiece.git)
spm="sentencepiece/src"

dir="data/"
out_dir="results/moses"
spm_dir="spm/"
lm="data/all_eng/ted-train.mtok.spm8000.eng.lm5.bin"

for src in "aze" "bel" "glg" "slk"; do
    src_out="${out_dir}/allbut${src}_eng"
    cd "${src_out}"

    #rm -rf filtered-${src}
    #${mosesdecoder}/scripts/training/filter-model-given-input.pl             \
    #    filtered-${src} mert-work/moses-bin.ini $dir/${src}_eng/ted-test.orig.spm8000.${src} \
    #    -Binarizer ${mosesdecoder}/bin/processPhraseTableMin
    #echo "finish filtered decode"
    #wait

    # decode
    echo "start Moses decode on ${src_tri}"
    nohup nice ${mosesdecoder}/bin/moses            \
        -f ${src_out}/mert-work/moses.ini   \
        < $dir/${src}_eng/ted-test.orig.spm8000.${src}              \
        > ${src_out}/ted-test.decode.spm8000.eng       \
        2> ${src_out}/decode.out 
    echo "finish Moses decode on ${src}"

    wait
    # de-spm
    $spm/spm_decode --model=${spm_dir}/eng/ted-train.mtok.spm8000.eng.model --input_format=piece < ${src_out}/ted-test.decode.spm8000.eng > ${src_out}/ted-test.decode.v0.eng
    echo "finish spm decode on ${src}"

    ${mosesdecoder}/scripts/generic/multi-bleu.perl \
        -lc $dir/${src}_eng/ted-test.mtok.eng             \
        < ${src_out}/ted-test.decode.v0.eng > ${src_out}/bleu.v0.txt
    echo "finish eval on ${src}"

done


