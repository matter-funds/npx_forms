import pandas as pd
from bs4 import BeautifulSoup
import re

def extract_p_from_html(soup):
    ps = soup.find_all('p')
    fund_re = re.compile('FUND:\s*')
    breaks = [i for i,p in enumerate(ps) if 0!=len(p.find_all('b', text=fund_re))]
    assert 1==len(breaks)
    ps = ps[breaks[0]:]
    
    signatures_re = re.compile('SIGNATURES\s*')
    breaks = [i for i,p in enumerate(ps) if 0!=len(p.find_all('b', text=signatures_re))]
    assert 1==len(breaks)
    ps = ps[:breaks[0]]
    
    lines_re = re.compile('----------*')
    breaks = [i for i,p in enumerate(ps) if 0!=len(p.find_all('b', text=lines_re))]
    ps_grouped = [ps[s+1:e] for s,e in zip(breaks[:-1],breaks[1:])]
    return ps_grouped


def strip_ps(ps):
    ps_strip = [[e.text for e in p.find_all('font')] for p in ps]
    ps_strip = [[e for e in p if 0!=len(set(e) - {' ','\xa0'})] for p in ps_strip]
    ps_strip = [[e.replace('\n',' ') for e in p] for p in ps_strip]
    ps_strip = [p for p in ps_strip if 0!=len(p)]
    for i in range(len(ps_strip)):
        for j in range(len(ps_strip[i])):
            ps_strip[i][j] = ps_strip[i][j].strip()
    return ps_strip


def parse_votes_from_company_ps(elems):
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
    df = pd.DataFrame(main_rows, columns=['Proposal','Sponsor','Voted','VoteCast','ForAgainstMgmt'])
    df['Name'] = issuer
    df['Ticker'] = ticker
    df['Cusip'] = cusip
    df['MeetDate'] = meet_date
    return df


def massage_df(df):
    df['MeetDate'] = pd.to_datetime(df['MeetDate'])
    df['Num'] = df['Proposal'].apply(lambda x:re.sub('\s','',x.split(' ')[1])[1:-1])
    df['Proposal'] = df['Proposal'].apply(lambda x:' '.join(x.split(' ')[2:]))
    df['NumRoot'] = df['Num'].apply(get_numroot)
    return df


def get_numroot(num):
    if num.isdigit():
        return num
    if '.' in num:
        return num.split('.')[0]
    if num[0].isdigit():
        return re.match('\d*',num).group()
    return num[0]
