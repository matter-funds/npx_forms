import pandas as pd
from bs4 import BeautifulSoup
import re
import requests
import parse
import os

root_path = os.path.dirname(os.path.realpath(__file__))+'/../../'
paths_file = root_path+'/data/npx_forms_paths/vanguard_npx.txt'
save_path_root = root_path+'data/'
urls = pd.read_csv(paths_file)

for u in urls['url']:
    print('Doing '+u)
    r = requests.get(u)
    fileid = u.split('/')[-2]
    save_path_full = save_path_root+'/npx_forms/'+fileid
    with open(save_path_full,'w')as f:
      f.write(r.text)
    print('Parsing file')
    soup = BeautifulSoup(r.text,'lxml')
    print('Got soup')

    print('Extracting ps')
    ps_grouped = parse.extract_p_from_html(soup)
    ps_grouped = [parse.strip_ps(ps) for ps in ps_grouped]
    print('Building dataframes')
    dfs = [parse.parse_votes_from_company_ps(ps) for ps in ps_grouped]
    for i in range(len(dfs)):
        dfs[i]['VoteId']='Vote'+str(i)
    df = pd.concat(dfs, ignore_index=True)
    df = parse.massage_df(df)
    save_path_full = save_path_root+'/npx_forms_parsed/VANGUARD/'+fileid
    print('Saving dataframe at: '+save_path_full)
    df.to_csv(save_path_full)
