# npx_forms
Read and parse N-PX forms from the edgar website

Currently supporting N-PX scripts for the following funds:
1. State Street
1. Vanguard
1. Blackrock

To run:
1. Place all your target URLs under `data/npx_forms_paths`
1. 
    - For State Street funds run `q scripts/npx_forms_stt/do.q`
    - For Vanguard funds run `python scripts/npx_forms_vguard/do.q`
    - For Blackrock funds run `q scripts/npx_forms_blackrock/do.q`
1. Your raw files will appear under `data/npx_forms` and parsed files under `data/npx_forms_parsed`
