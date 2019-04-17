download_and_save_from_url:{[save_path;url]
  -1"Downloading ",url;
  filename:first system"basename ",url;
  save_path_full:save_path,"/",filename;
  cmd:"wget -O ",save_path_full," ",url;
  res:system cmd;
  -1"Download done. Saved under: ",save_path_full;
  :save_path_full;
  }

save_parsed_portfolios:{[save_path;save_path_unparsed;company;portfolio]
  save_path_full:save_path,"/",ssr[string[company];" ";"_"],"/","."sv -1_"."vs first system"basename ",save_path_unparsed;
  save_paths:(save_path_full,"/"),/:ssr[;" ";"_"]each string key portfolio;
  -1"Saving at: ",save_path_full;
  hsym[`$save_paths] set' value portfolio;
  save_paths_csv:save_paths,\:".csv";
  hsym[`$save_paths_csv] 0:'csv 0:/:string value portfolio;
  }

first_line_contains:{[token;text]
  :1<>count token vs first"\n"vs text;
  }

parse_npx_form_state_street:{[filepath]
  form:read0 hsym`$filepath;
  form:"\n"sv form;
  raw_portfolios:-1_1_"\n=====" vs form;
  /drop sections that start with a simple "===...==="
  raw_portfolios:{x where not {enlist["="]~distinct first"\n"vs x}each x}raw_portfolios;
  portfolios:parse_portfolio each raw_portfolios;
  portfolio_names:`${trim first{x except enlist""}"="vs first"\n"vs x}each raw_portfolios;
  :portfolio_names!portfolios;
  }

parse_dates:{[date_str]
  m:`JAN`FEB`MAR`APR`MAY`JUN`JUL`AUG`SEP`OCT`NOV`DEC;
  years:date_str@\:8 9 10 11;
  months:string 1+m?/:`$date_str@\:0 1 2;
  days:date_str@\:4 5;
  :"D"${"."sv (x;y;z)}'[years;months;days];
  }

check_if_portfolio_is_empty:{[raw_portfolio]
  is_empty:0=count raze 1_"\n" vs raw_portfolio;
  if[is_empty;:1b];
  hint_text:"There is no proxy voting activity for the";
  is_empty:1<>count hint_text vs raw_portfolio;
  if[is_empty;:1b];
  hint_text:"did not hold any votable positions";
  is_empty:1<>count hint_text vs raw_portfolio;
  if[is_empty;:1b];
  :0b;
  }

add_root_vote_num:{[votes]
  r:votes;
  r:update NumType:`root from r where all each string[Num]in\:.Q.n;
  r:update NumType:`digit_first from r where null NumType, in[;.Q.n]first each string[Num];
  r:update NumType:`digit_first_fullstop from r where NumType=`digit_first, Num like"*.*";
  r:update NumType:`letter_first from r where null NumType, in[;.Q.A]upper first each string[Num];
  r:update NumType:`letter_first_fullstop from r where NumType=`letter_first, Num like"*.*";
  r:update NumRoot:Num from r where NumType=`root;
  r:update NumRoot:`$inter[;.Q.n]each string Num from r where NumType=`digit_first;
  r:update NumRoot:`$first each"."vs/:string Num from r where NumType=`digit_first_fullstop;
  r:update NumRoot:`$inter[;.Q.A]each upper string Num from r where NumType=`letter_first;
  r:update NumRoot:`$first each"."vs/:upper string Num from r where NumType=`letter_first_fullstop;
  :r;
  }

parse_portfolio:{[raw_portfolio]
  -1"Doing portfolio: ",trim first{x except enlist""}"="vs first"\n"vs raw_portfolio;
  if[check_if_portfolio_is_empty raw_portfolio;:()];
  raw_portfolio:ssr[;"&amp;";"&"]raw_portfolio;
  raw_companies:{x except enlist""} "-----------------" vs raw_portfolio;
  raw_companies:"\n"vs/:raw_companies;
  raw_companies[0]:1_ raw_companies[0];
  names:@[;2]each raw_companies;
  tickers:{trim first "Security ID:"vs @[;1]"Ticker:"vs x[4]}each raw_companies;
  secids:{trim first "\n"vs @[;1]"Security ID:"vs x[4]}each raw_companies;
  meeting_dates:{trim first "Meeting Type:"vs @[;1]"Meeting Date:"vs x[5]}each raw_companies;
  meeting_dates:parse_dates meeting_dates;
  meeting_types:{trim first "\n"vs @[;1]"Meeting Type:"vs x[5]}each raw_companies;
  record_dates:{trim first "\n"vs @[;1]"Record Date:"vs x[6]}each raw_companies;
  record_dates:parse_dates record_dates;
  raw_votes:except[;enlist""]each 8_/:raw_companies;
  portfolio:flip`Name`Ticker`secid`MeetDate`MeetType`RecDate!(`$names;`$tickers;`$secids;meeting_dates;`$meeting_types;record_dates);
  portfolio:update VoteId:(`$"VoteId",/:string i) from portfolio; 
  votes:parse_votes each raw_votes;
  votes:{`VoteId xcols update VoteId:x from y}'[portfolio`VoteId;votes];
  votes:raze[votes] lj `VoteId xkey portfolio;
  votes:add_root_vote_num votes;
  :votes;
  }

parse_votes:{[raw_vote]
  expected_cols:`$("#";"Proposal";"Mgt Rec";"Vote Cast";"Sponsor");
  header:first raw_vote;
  body:1_raw_vote;
  /pad body to ensure all rows have the same length
  max_len:max count each body;
  body:max_len#/:body,\:max_len#" ";
  /too clever code
  /this deals with tables like:
  /"#     Proposal                                Mgt Rec   
  /"2     Ratify PricewaterhouseCoopers LLP as    For       
  /"      Auditors"
  /"3     Advisory Vote to Ratify Named           For       
  /rows 1 and 2 are the same logical row in the table
  /the solution uses the headers to figure out where the breaks happens on each row
  segment_starts:count each first each string[expected_cols]vs\:header;
  /it then breaks each row at those positions
  cut_body:segment_starts cut/:body;
  /it the decides when to group consecutive rows together based on the first char in the row
  vote_idx:sums not" "=first each body;
  /it then razez and trims the relevant segments together (with some flips so the function application makes sense)
  consolidated_body:{{trim" "sv trim each x} each x}each flip[cut_body]@\:value group vote_idx;
  :`Num xcol .Q.id flip expected_cols!`$consolidated_body;
  }
