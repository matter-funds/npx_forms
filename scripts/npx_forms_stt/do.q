pwd:first system"dirname `readlink -f ",string[.z.f],"`";

system"l ",pwd,"/lib.q";

save_path_form:pwd,"/../../data/npx_forms/";
/STT MASTER FUNDS
stt_npx_path:pwd,"/../../data/npx_forms_paths/state_street_npx.txt";
stt_npx:("I*";enlist",")0: hsym `$stt_npx_path;

save_filepaths:download_and_save_from_url[save_path_form;]each stt_npx`url;

ps:parse_npx_form_state_street each save_filepaths;
save_path_parsed:pwd,"/../../data/npx_forms_parsed/";
save_parsed_portfolios[save_path_parsed]'[save_filepaths;ps];

exit 0;
