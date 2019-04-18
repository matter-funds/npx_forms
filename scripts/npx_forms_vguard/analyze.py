import pandas as pd
from pathlib import Path
import re
import os

root_path = os.path.dirname(os.path.realpath(__file__))+'/../../'
parsed_path = Path(root_path+'/data/npx_forms_parsed/VANGUARD/')
dfs = [pd.read_csv(f, index_col=0) for f in parsed_path.glob('*')]
df = pd.concat(dfs, ignore_index=True)
