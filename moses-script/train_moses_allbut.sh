mosesdecoder="/home/data/LoReHLT17/internal/MT/tools/mosesdecoder"
dir="/usr2/data/junjieh/Research/multiling-exp/data/clean"
out_dir="/usr2/data/junjieh/Research/multiling-exp/moses/clean/new"
lm="/usr2/data/junjieh/Research/multiling-exp/lm_eng/ted-train.mtok.spm8000.eng.lm5.bin"

for src in aze bel glg slk; do # aze bel glg slk
    mkdir -p "${out_dir}/allbut${src}_eng"
    cd "${out_dir}/allbut${src}_eng"

    # clean data
    $mosesdecoder/scripts/training/clean-corpus-n.perl \
    ${dir}/allbut${src}_eng/ted-train clean.orig.spm8000.all mtok.spm8000.eng \
    ${dir}/allbut${src}_eng/ted-train.filt 1 80
    echo "finish clean corpus ${src}"
    wait

    nohup nice ${mosesdecoder}/scripts/training/train-model.perl -root-dir train \
        -corpus ${dir}/allbut${src}_eng/ted-train.filt                            \
        -f clean.orig.spm8000.all -e mtok.spm8000.eng -alignment grow-diag-final-and -reordering msd-bidirectional-fe \
        -lm 0:5:${lm}:8                          \
        -external-bin-dir ${mosesdecoder}/tools >& training.out &	
    echo "finish training on ${src}"
    wait

    # Tune
    nohup nice ${mosesdecoder}/scripts/training/mert-moses.pl \
        $dir/${src}_eng/ted-dev.clean.orig.spm8000.${src} $dir/${src}_eng/ted-dev.mtok.spm8000.eng \
        ${mosesdecoder}/bin/moses train/model/moses.ini --mertdir ${mosesdecoder}/bin/ \
        &> mert.out &
    echo "finish tuning on ${src}"

    wait
    mkdir -p "${out_dir}/allbut${src}_eng/binarised-model"
    ${mosesdecoder}/bin/processPhraseTableMin \
        -in ${out_dir}/allbut${src}_eng/train/model/phrase-table.gz -nscores 4 \
        -out ${out_dir}/allbut${src}_eng/binarised-model/phrase-table
    ${mosesdecoder}/bin/processLexicalTableMin \
        -in ${out_dir}/allbut${src}_eng/train/model/reordering-table.wbe-msd-bidirectional-fe.gz \
        -out ${out_dir}/allbut${src}_eng/binarised-model/reordering-table
    echo "finsh binarize phrase table on ${src}"
 done

