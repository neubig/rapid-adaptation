import sentencepiece as spm
import os
import time


for vocab_size in [8000]:
  with open('lang-pairs.txt', 'r') as lpf:
    for line in lpf:
      src1, src2 = line.strip().split()
      src12 = src1+src2
      src12trg = src12+'_eng'
      prefix = 'spm/{}/ted-train.orig.spm{}.{}'.format(src12, vocab_size, src12)
      spsrc = spm.SentencePieceProcessor()
      spsrc.Load(prefix+'.model')
      for src in [src1, src2]:
        srctrg = src+'_eng'
        for split in ['dev', 'test']:
          with open('data/{}/ted-{}.orig.{}'.format(srctrg, split, src), 'r') as infile, \
               open('data/{}/ted-{}.orig.spm{}.{}'.format(src12trg, split, vocab_size, src), 'w') as outfile:
            for line in infile:
              print(' '.join(spsrc.Encode(line.strip())), file=outfile)
