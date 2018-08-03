mosesdecoder="/home/data/LoReHLT17/internal/MT/tools/mosesdecoder"
dir="/usr2/data/junjieh/Research/multiling-exp/data"
out_dir="/usr2/data/junjieh/Research/multiling-exp/moses"
lm="/usr2/data/junjieh/Research/multiling-exp/data/all_eng/ted-train.mtok.spm8000.eng.lm5.bin"

a1=("azetur" "belrus" "glgpor" "slkces")
a2=("aze" "bel" "glg" "slk")

for ((i=0;i<${#a1[@]};++i)); do
    src=${a1[i]}

    # clean data
    $mosesdecoder/scripts/training/clean-corpus-n.perl \
    ${dir}/${src}_eng/ted-train orig.spm8000.${src} mtok.spm8000.eng \
    ${dir}/${src}_eng/ted-train.clean 1 80

    mkdir -p "${out_dir}/${src}_eng"
    cd "${out_dir}/${src}_eng"
    nohup nice ${mosesdecoder}/scripts/training/train-model.perl -root-dir train \
        -corpus ${dir}/${src}_eng/ted-train.clean                             \
        -f orig.sepspm8000.${src} -e mtok.spm8000.eng -alignment grow-diag-final-and -reordering msd-bidirectional-fe \
        -lm 0:5:${lm}:8                          \
        -external-bin-dir ${mosesdecoder}/tools >& training.out &	
    echo "finish training on ${src}"
    wait

    # Tune
    src=${a2[i]}
    nohup nice ${mosesdecoder}/scripts/training/mert-moses.pl \
        $dir/${src}_eng/ted-dev.orig.spm8000.${src} $dir/${src}_eng/ted-dev.mtok.spm8000.eng \
        ${mosesdecoder}/bin/moses train/model/moses.ini --mertdir ${mosesdecoder}/bin/ \
        &> mert.out &
    echo "finish tuning on ${src}"

    # Binarize model
    mkdir -p "${out_dir}/${src}_eng/binarised-model"
    ${mosesdecoder}/bin/processPhraseTableMin \
        -in train/model/phrase-table.gz -nscores 4 \
        -out binarised-model/phrase-table
    ${mosesdecoder}/bin/processLexicalTableMin \
        -in train/model/reordering-table.wbe-msd-bidirectional-fe.gz \
        -out binarised-model/reordering-table
      echo "finsh binarize phrase table on ${src}"
 done

