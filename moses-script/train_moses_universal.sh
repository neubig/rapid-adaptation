# Path to mosesdecoder (https://github.com/moses-smt/mosesdecoder.git)
mosesdecoder="mosesdecoder"  

dir="data"
out_dir="results/moses"
lm="data/all_eng/ted-train.mtok.spm8000.eng.lm5.bin"

src=all
output_dir="${out_dir}/all_eng"
mkdir -p $output_dir
cd "${output_dir}"

# tokenize
$mosesdecoder/scripts/tokenizer/tokenizer.perl < ${dir}/all_eng/ted-train.orig.all > ${dir}/all_eng/ted-train.mtok.all

# clean data
$mosesdecoder/scripts/training/clean-corpus-n.perl \
  ${dir}/${src}_eng/ted-train clean.orig.spm8000.all mtok.spm8000.eng \
  ${dir}/${src}_eng/ted-train.filt 1 80
echo "finish clean corpus ${src}"

wait

# clean special char 
${mosesdecoder}/scripts/tokenizer/escape-special-chars.perl < ${dir}/all_eng/ted-train.clean.orig.sepspm8000.all > ${dir}/all_eng/ted-train.clean.spe.orig.sepspm8000.all
${mosesdecoder}/scripts/tokenizer/escape-special-chars.perl < ${dir}/all_eng/ted-train.clean.mtok.spm8000.eng > ${dir}/all_eng/ted-train.clean.spe.mtok.spm8000.eng 

nohup nice ${mosesdecoder}/scripts/training/train-model.perl -root-dir train \
    -corpus ${dir}/all_eng/ted-train.filt                             \
    -f clean.orig.spm8000.all -e mtok.spm8000.eng -alignment grow-diag-final-and -reordering msd-bidirectional-fe \
    -lm 0:5:${lm}:8                          \
    -external-bin-dir ${mosesdecoder}/tools >& training.out &	
echo "finish training on ${src}"

wait

# Tune
for src in glg slk aze bel ; do # aze
    nohup nice ${mosesdecoder}/scripts/training/mert-moses.pl \
        $dir/${src}_eng/ted-dev.clean.orig.spm8000.${src} $dir/${src}_eng/ted-dev.mtok.spm8000.eng \
        ${mosesdecoder}/bin/moses train/model/moses.ini --mertdir ${mosesdecoder}/bin/ \
        --working-dir ${out_dir}/all_eng/${src}-mert-out \
        &> ${src}_mert.out &
    echo "finish tuning on ${src}"

done
wait 

# Binarize model
bin_dir="${output_dir}/binarised-model"
mkdir -p $bin_dir
cd $bin_dir
${mosesdecoder}/bin/processPhraseTableMin \
    -in $out_dir/all_eng/train/model/phrase-table.gz -nscores 4 \
    -out $bin_dir/phrase-table
${mosesdecoder}/bin/processLexicalTableMin \
    -in $out_dir/all_eng/train/model/reordering-table.wbe-msd-bidirectional-fe.gz \
    -out $bin_dir/reordering-table
echo "finsh binarize phrase table "


