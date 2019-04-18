# npx_forms
Read and parse N-PX forms from the edgar website

Currently supporting N-PX scripts for the following funds:
1. State Street
1. Vanguard
1. Blackrock

To install:
All paths used by the scripts are relative.
To run the Python scripts, you need to be an environment where the libraries in requirements.txt are availabile.
You can create a virtual environment for this project by doing:

```
cd npx_forms
virtualenv env
source env/bin/activate
pip install -r scripts/requirements.txt
```

To run:
1. Place all your target URLs under `data/npx_forms_paths`
1. 
    - For State Street funds run `q scripts/npx_forms_stt/do.q`
    - For Vanguard funds run `python scripts/npx_forms_vguard/do.q`
    - For Blackrock funds run `q scripts/npx_forms_blackrock/do.q`
1. Your raw files will appear under `data/npx_forms` and parsed files under `data/npx_forms_parsed`
