pwd:first system"dirname `readlink -f ",string[.z.f],"`";

system"l ",pwd,"/lib.q";

data_dir:pwd,"/../../data";
save_path_form:data_dir,"/npx_forms/";
/STATE STREET
stt_npx_path:data_dir,"/npx_forms_paths/state_street_npx.txt";
stt_npx:("IS*";enlist",")0: hsym `$stt_npx_path;

save_filepaths:download_and_save_from_url[save_path_form;]each stt_npx`url;

ps:parse_npx_form_state_street each save_filepaths;
save_path_parsed:data_dir,"/npx_forms_parsed/";
save_parsed_portfolios[save_path_parsed]'[save_filepaths;stt_npx`company;ps];

exit 0;
