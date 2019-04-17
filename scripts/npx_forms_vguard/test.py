import pandas as pd
from bs4 import BeautifulSoup
import re
import requests
url='https://www.sec.gov/Archives/edgar/data/36405/000093247118006895/indexfunds0040.htm'
#r = requests.get(url)

with open('example_full.html','r') as f:
  soup = BeautifulSoup(f.read(),'lxml')

ps = soup.find_all('p')
breaks = [i for i,p in enumerate(ps) if 0!=len(p.find_all('b', text='FUND:'))]
assert 1==len(breaks)
ps = ps[breaks[0]:]

breaks = [i for i,p in enumerate(ps) if 0!=len(p.find_all('b', text='SIGNATURES'))]
assert 1==len(breaks)
ps = ps[:breaks[0]]

lines_re = re.compile('----------*')
breaks = [i for i,p in enumerate(ps) if 0!=len(p.find_all('b', text=lines_re))]
ps_broken = [ps[s+1:e] for s,e in zip(breaks[:-1],breaks[1:])]

import pdb;pdb.set_trace()

#rows:
r1 = soup.find_all('p')[0]

elems = [[e.text for e in r.find_all('font')] for r in soup.find_all('p')]
elems = [[e for e in r if 0!=len(set(e) - {' ','\xa0'})] for r in elems]
elems = [[e.replace('\n',' ') for e in r] for r in elems]

def parse_votes_company(elems):
  issuer = elems[0][1]
  ticker = elems[1][1]
  cusip = elems[1][3]
  meet_date = elems[2][1]
  #elems[3] is table headers
  body = elems[4:]
  is_main = [len(r)==5 for r in body]
  is_secondary = [len(r)==1 for r in body]
  has_secondary = is_secondary[1:]+[False]
  assoc_secondary = [r[0] for r in body[1:]]+['']
  #add secondaries
  for i in range(len(body)):
      if has_secondary[i]:
          body[i][0] = body[i][0]+' '+assoc_secondary[i]
  main_rows = [r for i,r in enumerate(body) if is_main[i]]
  df = pd.DataFrame(main_rows, columns=['Proposal','Sponsor','Voted','Vote','Agree mgmt'])
  df['Issuer'] = issuer
  df['Ticker'] = ticker
  df['Cusip'] = cusip
  df['MeetDate'] = meet_date
  return df

df = parse_votes_company(elems)
