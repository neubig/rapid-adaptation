# path to vecmap (https://github.com/artetxem/vecmap.git)
vecmap="$PWD/vecmap"
dir="$PWD"

cd $vecmap
trg_vec="${dir}/embed/all_eng/eng.vec"
trg_norm_vec="${dir}/embed/all_eng/eng.norm.vec"
echo "python3 normalize_embeddings.py unit center -i ${trg_vec} -o ${trg_norm_vec}"
python3 normalize_embeddings.py unit center -i ${trg_vec} -o ${trg_norm_vec}
echo "Finish normalize eng embeddings"

for src in aze bel glg slk azetur belrus glgpor slkces ; do  # all allbutaze allbutbel allbutglg allbutslk
	src_vec="${dir}/embed/${src}_eng/${src}.vec"
	src_norm_vec="${dir}/embed/${src}_eng/${src}.norm.vec"
	src_map_vec="${dir}/embed/${src}_eng/${src}.norm.map.vec"
	trg_map_vec="${dir}/embed/${src}_eng/eng.norm.map.vec"
	echo "python3 normalize_embeddings.py unit center -i ${src_vec} -o ${src_norm_vec}"
	python3 normalize_embeddings.py unit center -i ${src_vec} -o ${src_norm_vec}
	echo "Finish normalize ${src} embeddings"

	echo "python3 map_embeddings.py --orthogonal ${src_norm_vec} ${trg_norm_vec} ${src_map_vec} ${trg_map_vec} --numerals --self_learning -v"
	python3 map_embeddings.py --orthogonal ${src_norm_vec} ${trg_norm_vec} ${src_map_vec} ${trg_map_vec} --numerals --self_learning -v
	echo "Finish mapping $src to English space"
done

cd $dir
