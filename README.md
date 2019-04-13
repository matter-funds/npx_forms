# npx_forms
Read and parse N-PX forms from the edgar website

Currently only supporting State Street N-PX scripts.

To run:
1. Place all your target URLs under `data/npx_forms_paths`
1. For State Street funds run `q scripts/npx_forms_stt/do.q`
1. Your raw files will appear under `data/npx_forms` and parsed files under `data/npx_forms_parsed`
