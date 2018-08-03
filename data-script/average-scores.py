import sys
import re
import argparse

finalbleu_re = re.compile(r'\| BLEU4: ([^,]+),')

parser = argparse.ArgumentParser(description='Average scores.')
parser.add_argument('--reduce_idxs', default=None, help='Indices to reduce into a single index, e.g "0,1,2,3 4,5,6,7"')
parser.add_argument('files', nargs='*')
args = parser.parse_args()

reduce_map, reduce_count, reduce_idxs = None, None, None
if args.reduce_idxs:
  reduce_idxs = [[int(y) for y in x.split(',')] for x in args.reduce_idxs.split(' ')]
  reduce_count = [len(x) for x in reduce_idxs]
  reduce_map = {}
  for i, idxs in enumerate(reduce_idxs):
    for j in idxs:
      reduce_map[j] = i

vals = None
for f in args.files:
  my_vals = []
  try:
    with open(f, 'r') as infile:
      for line in infile:
        m = finalbleu_re.search(line.strip())
        if m:
          my_vals.append(float(m.group(1))) 
  except:
    print('error opening {}'.format(f))
    sys.exit(1)
  if not vals:
    if not reduce_map:
      reduce_map = {x: x for x in range(len(my_vals))}
      reduce_count = [1 for x in my_vals]
      reduce_idxs = [[x] for x in range(len(my_vals))]
    vals = [0] * len(reduce_idxs)
  if len(my_vals) != len(reduce_map):
    print('mismatched lengths {} != {} in {}'.format(len(reduce_map), len(my_vals), f))
    sys.exit(1)
  for i, v in enumerate(my_vals):
    vals[reduce_map[i]] += v

print(' '.join(['{:.4f}'.format(x/y/(len(args.files))) for x, y in zip(vals, reduce_count)]))
