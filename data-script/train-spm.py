import sentencepiece as spm
import os
import time

def touch(fname, times=None):
  with open(fname, 'a'):
    os.utime(fname, times)

if not os.path.exists('spm'):
  os.mkdir('spm')

for vocab_size in [8000]:
  # English side
  if not os.path.exists('spm/eng'):
    os.mkdir('spm/eng')
  prefix = 'spm/eng/ted-train.mtok.spm{}.eng'.format(vocab_size)
  if not os.path.exists(prefix+'.lock'):
    touch(prefix+'.lock')
    spm.SentencePieceTrainer.Train('--input=data/eng/ted-train.mtok.eng --model_prefix={} --vocab_size={} --hard_vocab_limit=false'.format(prefix, vocab_size))
    touch(prefix+'.done') 
  while not os.path.exists(prefix+'.done'):
    time.sleep(5)

  sptrg = spm.SentencePieceProcessor()
  sptrg.Load(prefix+'.model')
  
  # Other side
  dirs = os.listdir('data')
  for srctrg in dirs:
    if srctrg == 'eng':
      continue
    assert(srctrg[-4:] == '_eng')
    src = srctrg[:-4]
    if not os.path.exists('spm/'+src):
      os.mkdir('spm/'+src)
    print(srctrg, vocab_size)
    prefix = 'spm/{}/ted-train.orig.spm{}.{}'.format(src, vocab_size, src)
    indata = 'data/{}/ted-train.orig.{}'.format(srctrg, src)
    # Do model training and processing
    if not os.path.exists(prefix+'.lock'):
      touch(prefix+'.lock')
      spm.SentencePieceTrainer.Train('--input={} --model_prefix={} --vocab_size={} --hard_vocab_limit=false'.format(indata, prefix, vocab_size))
      spsrc = spm.SentencePieceProcessor()
      spsrc.Load(prefix+'.model')
      for split in ['train', 'dev', 'test']:
        with open('data/{}/ted-{}.orig.{}'.format(srctrg, split, src), 'r') as infile, \
             open('data/{}/ted-{}.orig.spm{}.{}'.format(srctrg, split, vocab_size, src), 'w') as outfile:
          for line in infile:
            print(' '.join(spsrc.Encode(line.strip())), file=outfile)
        with open('data/{}/ted-{}.mtok.eng'.format(srctrg, split), 'r') as infile, \
             open('data/{}/ted-{}.mtok.spm{}.eng'.format(srctrg, split, vocab_size), 'w') as outfile:
          for line in infile:
            print(' '.join(sptrg.Encode(line.strip())), file=outfile)

