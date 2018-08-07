# Rapid Adaptation of Neural Machine Translation to New Languages
by [Graham Neubig](http://phontron.com) and [Junjie Hu](http://www.cs.cmu.edu/~junjieh/)

This is the repository for the EMNLP 2018 paper
[Rapid Adaptation of Neural Machine Translation to New Languages](http://TODO).

In this paper we:
* Show that it is possible to take massively multilingually trained neural MT systems (e.g. trained on 50+ languages) and adapt them to new languages that have very little data (e.g. 5000 or so sentences).
* Propose a method called "similar language regularization," where when adapting to new languages you train on another similar language.
* Demonstrate that it is possible to do *fully unsupervsed adaptation* to new languages by simply applying an existing MT system to new languages. The results are suprising, it is possible to get BLEU scores of up to 15.5 based entirely on the similarity of the existing languages to other languages in the original training data.
* Show that unsupervised machine translation methods do not do as well as adapting for new language pairs.

##  Downloading Data

The data we use is the [multilingual TED corpus](https://github.com/neulab/word-embeddings-for-nmt) by Qi et al.

For convenience, we provide a pre-processed version of the data, which can be downloaded and expanded here by using the following commands:

    wget http://www.phontron.com/download/rapid-annotation-data.tar.gz
    tar -xzf rapid-annotation-data.tar.gz

If you want to see how we did preprocessing, you can take a look at the `data-script` directory. The sentencepiece models used to perform tokenization can be downloaded [here](http://www.phontron.com/download/rapid-annotation-spm.tar.gz) if you need them (you shouldn't to run experiments, as the pre-tokenized data is included).

## Running Experiments

In order to run the experiments, first install [xnmt](https://github.com/neulab/xnmt), specifically git commit `8173b1f`.
All of the experiments can be run using configuration files included in this repository. An easy way to run all the experiments is to run the following script

    bash xnmt-script/run-all.sh

However, this will take a long time because there are a ton of experiments, so you would probably want to run the experiments in parallel. The log files will be written to the `results` directory.

## Baseline Scripts

We've also provided the baseline for the [Moses](http://www.statmt.org/moses/) phrase-based system (in the `moses-script` directory) and the [undreamt](https://github.com/artetxem/undreamt) unsupervised NMT system (in the `undreamt-script` directory).

## Downloading Results

Of course we assume that people want to run the experiments themselves, but for completeness we've also included all our result logs and translations so you can read the experimental results without actually running the experiments yourself:

    wget http://www.phontron.com/download/rapid-annotation-results.tar.gz
    tar -xzf rapid-annotation-results.tar.gz
