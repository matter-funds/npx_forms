pwd:first system"dirname `readlink -f ",string[.z.f],"`";

system"l ",pwd,"/lib.q";

data_dir:pwd,"/../../data";
save_path_form:data_dir,"/npx_forms/";
/BLACK ROCK
br_npx_path:data_dir,"/npx_forms_paths/blackrock_npx.txt";
br_npx:("IS*";enlist",")0: hsym `$br_npx_path;
br_npx:3_br_npx;

save_filepaths:download_and_save_from_url[save_path_form;]each br_npx`url;

ps:parse_npx_form_blackrock each save_filepaths;
save_path_parsed:data_dir,"/npx_forms_parsed/";
save_parsed_portfolios[save_path_parsed]'[save_filepaths;br_npx`company;ps];

exit 0;
