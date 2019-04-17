import pandas as pd
from pathlib import Path
import re

parsed_path = Path('/home/bogdan/projects/proxymonitor/data/npx_forms_parsed/VANGUARD/')
dfs = [pd.read_csv(f, index_col=0) for f in parsed_path.glob('*')]
df = pd.concat(dfs, ignore_index=True)
