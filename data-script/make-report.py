import sys
import re
import numpy as np

pairs = [
  ('aze', 'tur'),
  ('bel', 'rus'),
  ('glg', 'por'),
  ('slk', 'ces')
]

final_bleu_re = re.compile(r'\| BLEU4: (0.[0-9]+)')
time_re = re.compile(r'time=(\d)-(\d\d):(\d\d):(\d\d)')

def get_bleus_and_times(fname, dev_id, test_id):
  ret = []
  last_time = 0
  try:
    with open(fname, 'r') as f:
      for line in f:
        line = line.strip()
        m = re.search(final_bleu_re, line)
        if m:
          ret.append(float(m.group(1)))
        m = re.search(time_re, line)
        if m:
          last_time = float(m.group(1))*24 + float(m.group(2)) + float(m.group(3))/60
    return ret[dev_id], ret[test_id], last_time
  except:
    return None, None, None

def create_table(header, rows, tblname, caption, show_time=False):
  if show_time:
    print('\\begin{table*}')
    print('\\resizebox{\\textwidth}{!}{')
    print('\\begin{tabular}{'+('l'*len(header)+'|rrrrrrrr|rr')+'}')
    my_header = header + ['\multicolumn{2}{c}{'+s1+'/'+s2+'}' for (s1, s2) in pairs] + ['\multicolumn{2}{c}{Average}']
  else:
    print('\\begin{table}')
    print('\\resizebox{\\columnwidth}{!}{')
    print('\\begin{tabular}{'+('l'*len(header)+'|rrrr|r')+'}')
  my_header = header + [''+s1+'/'+s2+'' for (s1, s2) in pairs] + ['Average']
  print(' & '.join(my_header) + ' \\\\ \\hline \\hline')
  stats = []
  first_row = 0
  BAD = -1
  for row_id, (num, train, strategy, template, devrows, testrows, add_hline) in enumerate(rows):
    dev_avg = 0
    test_avg = 0
    time_avg = 0
    valid_num = 0
    my_stats = []
    for (src1, src2), devrow, testrow in zip(pairs, devrows, testrows):
      filename = template.replace('SRC1', src1).replace('SRC2', src2)
      my_dev, my_test, my_time = get_bleus_and_times(filename, devrow, testrow)
      if my_test != None:
        my_stats.extend([my_test*100, my_time])
      else:
        my_stats.extend([BAD, BAD]) 
    if all([x != BAD for x in my_stats]):
      my_stats.extend([sum([my_stats[i] for i in [0,2,4,6]])/4, sum([my_stats[i] for i in [1,3,5,7]])/4])
    else:
      my_stats.extend([BAD, BAD])
    stats.append(my_stats)
    if add_hline or len(rows)-1 == row_id:
      max_stats = [max([x[i] for x in stats]) for i in range(10)]
      for stat_id, ((num, train, strategy, template, devrows, testrows, add_hline), my_stats) in enumerate(zip(rows[first_row:row_id+1], stats)):
        my_strs = ['\multirow{{ {} }}{{*}}{{\\rotatebox{{90}}{{ {} }}}}'.format(len(stats), train) if stat_id == 0 else '', strategy]
        for i in range(0, 10, 2):
          if show_time:
            if my_stats[i] == BAD:
              my_strs.append('\multicolumn{2}{c}{TODO}')
            elif my_stats[i] == max_stats[i]:
              my_strs.append('\\textbf{{{:.1f}}} & ({:.1f})'.format(my_stats[i], my_stats[i+1]))
            else:
              my_strs.append('{:.1f} & ({:.1f})'.format(my_stats[i], my_stats[i+1]))
          else:
            if my_stats[i] == BAD:
              my_strs.append('TODO')
            elif my_stats[i] == max_stats[i]:
              my_strs.append('\\textbf{{{:.1f}}}'.format(my_stats[i]))
            else:
              my_strs.append('{:.1f}'.format(my_stats[i], my_stats[i+1]))
        print(' & '.join(my_strs) + '\\\\' + (' \\hline' if add_hline else ''))
      stats = []
      first_row = row_id+1
  print('\\end{tabular}')
  print('}') # Resizebox
  print('\\caption{'+caption+' \label{tab:'+tblname+'}}')
  if show_time:
    print('\\end{table*}')
  else:
    print('\\end{table}')

# Create main table
tb1_header = ['Type', 'Strategy']
tb1_rows = [
  ('1',  'Warm', 'Bi',                       'results/00-bi/SRC1.cfg001.log',        [0,0,0,0], [1,1,1,1], False),
  ('2',  'Warm', 'Tri',                      'results/01-tri/SRC1SRC2.cfg000.log',   [0,0,0,0], [1,1,1,1], False),
  ('3',  'Warm', 'All',                      'results/02-all/all.cfg000.log',        [0,1,2,3], [4,5,6,7], False),
  ('4',  'Warm', 'Tri$\\rightarrow$Bi',      'results/03-adapt/SRC1SRC2.cfg008.log', [0,0,0,0], [1,1,1,1], False),
  ('5',  'Warm', 'All$\\rightarrow$Bi',      'results/03-adapt/SRC1SRC2.cfg002.log', [0,0,0,0], [1,1,1,1], False),
  ('6',  'Warm', 'All$\\rightarrow$Tri',     'results/03-adapt/SRC1SRC2.cfg010.log', [0,0,0,0], [1,1,1,1], False),
  ('7',  'Warm', 'All$\\rightarrow$Tri 1-1', 'results/03-adapt/SRC1SRC2.cfg012.log', [0,0,0,0], [1,1,1,1], False),
  ('8',  'Warm', 'All$\\rightarrow$Tri 1-2', 'results/03-adapt/SRC1SRC2.cfg014.log', [0,0,0,0], [1,1,1,1], False),
  ('9',  'Warm', 'All$\\rightarrow$Tri 1-4', 'results/03-adapt/SRC1SRC2.cfg016.log', [0,0,0,0], [1,1,1,1], True),
  ('10', 'Cold', 'Tri',                      'results/01-tri/SRC1SRC2.cfg002.log',   [0,0,0,0], [1,1,1,1], False),
  ('11', 'Cold', 'All',                      'results/02-all/allbutSRC1.cfg002.log', [0,1,2,4], [5,6,7,9], False),
  ('12', 'Cold', 'Tri$\\rightarrow$Bi',      'results/03-adapt/SRC1SRC2.cfg009.log', [0,0,0,0], [1,1,1,1], False),
  ('13', 'Cold', 'All$\\rightarrow$Bi',      'results/03-adapt/SRC1SRC2.cfg003.log', [0,0,0,0], [1,1,1,1], False),
  ('14', 'Cold', 'All$\\rightarrow$Tri',     'results/03-adapt/SRC1SRC2.cfg011.log', [0,0,0,0], [1,1,1,1], False),
  ('15', 'Cold', 'All$\\rightarrow$Tri 1-1', 'results/03-adapt/SRC1SRC2.cfg013.log', [0,0,0,0], [1,1,1,1], False),
  ('16', 'Cold', 'All$\\rightarrow$Tri 1-2', 'results/03-adapt/SRC1SRC2.cfg015.log', [0,0,0,0], [1,1,1,1], False),
  ('17', 'Cold', 'All$\\rightarrow$Tri 1-4', 'results/03-adapt/SRC1SRC2.cfg017.log', [0,0,0,0], [1,1,1,1], False),
]
tb1_name = 'main'
# tb1_caption = 'BLEU scores and training time (hours, in parentheses) for bilingual, trilingual, universal, and adapted models. Bold indicates highest score.'
tb1_caption = 'BLEU scores for bilingual, trilingual, universal, and adapted models. Bold indicates highest score for each training setting.'
create_table(tb1_header, tb1_rows, tb1_name, tb1_caption)

#   ('(3)', 'Tri', 'no src',     'results/01-tri/SRC1SRC2.cfg002.log',   [0,0,0,0], [1,1,1,1]),
#   ('(5)', 'Uni', 'no src',     'results/01-all/allbutSRC1.cfg001.log', [0,2,4,6], [1,3,5,7]),
# 
# tb2_lines = [
#   ('Tri', 'joint subword', 'results/01-tri/SRC1SRC2.cfg001.log',   [0,0,0,0], [1,1,1,1]),
#   ('Tri', '-',             'results/01-tri/SRC1SRC2.cfg000.log',   [0,0,0,0], [1,1,1,1]),
# ]


