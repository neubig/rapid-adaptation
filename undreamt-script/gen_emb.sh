# Path to fastText (https://github.com/facebookresearch/fastText.git)
fasttext="$PWD/fastText/fasttext"
dir="$PWD/data"
out_dir="$PWD/embed"

# train bilingual embeddings
for src in aze bel glg slk; do
    mkdir -p "${out_dir}/${src}_eng"
    src_data="${dir}/${src}_eng/ted-train.orig.spm8000.${src}"
    echo "$fasttext skipgram -input $src_data -output ${out_dir}/${src}_eng/${src} -ws 10 -dim 300 -neg 10 -t 0.00001 -epoch 10"
    $fasttext skipgram -input $src_data -output ${out_dir}/${src}_eng/${src} -ws 10 -dim 300 -neg 10 -t 0.00001 -epoch 10 
done

# train trilingual embeddings
for src in azetur belrus glgpor slkces; do
    mkdir -p "${out_dir}/${src}_eng"
    src_data="${dir}/${src}_eng/ted-train.orig.sepspm8000.${src}"
    echo "$fasttext skipgram -input $src_data -output ${out_dir}/${src}_eng/${src} -ws 10 -dim 300 -neg 10 -t 0.00001 -epoch 10"
    $fasttext skipgram -input $src_data -output ${out_dir}/${src}_eng/${src} -ws 10 -dim 300 -neg 10 -t 0.00001 -epoch 10 
    echo "finish"
done

# allbut* 
for src in allbutaze allbutbel allbutglg allbutslk; do
    mkdir -p "${out_dir}/${src}_eng"
    src_data="${dir}/${src}_eng/ted-train.orig.sepspm8000.all"
    echo "$fasttext skipgram -input $src_data -output ${out_dir}/${src}_eng/${src} -ws 10 -dim 300 -neg 10 -t 0.00001 -epoch 10"
    $fasttext skipgram -input $src_data -output ${out_dir}/${src}_eng/${src} -ws 10 -dim 300 -neg 10 -t 0.00001 -epoch 10 
    echo "finish"
done

# train English embeddings 
trg_data="${dir}/all_eng/ted-train.mtok.spm8000.eng"
mkdir -p "${out_dir}/all_eng"
echo "$fasttext skipgram -ws 10 -dim 300 -neg 10 -t 0.00001 -epoch 10 -input $trg_data -output $out_dir ${out_dir}/${src}_eng/eng"
$fasttext skipgram -ws 10 -dim 300 -neg 10 -t 0.00001 -epoch 10 -input $trg_data -output ${out_dir}/all_eng_v1/eng
echo "finish"
