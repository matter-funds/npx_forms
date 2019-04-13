pwd:first system"dirname `readlink -f ",string[.z.f],"`";

system"l ",pwd,"/lib.q";
system"l /home/bogdan/q/my.q";
system"l /home/bogdan/q/lib/piv.q";

parsed_npx_paths:system"ls ",pwd,"/../../data/npx_forms_parsed/*";
parsed_npx_paths:{x where not x like"*.csv"}parsed_npx_paths;
ps:get each hsym`$parsed_npx_paths;
ps:ps@\:`$"State Street Equity 500 Index Portfolio";
tokens:@[;1]each reverse each"-"vs/:parsed_npx_paths;
ps:{y;update VoteId:(`$string[VoteId],\:"_",y) from x}'[ps;tokens];
ps:raze ps;

/drop bogus entries (badly parsed for now)
ps:select from ps where not null Num, not null NumType;
ps:update MeetDate_adj:MeetDate - 187 from ps;
ps:update agree:MgtRec=VoteCast from ps;

-1"Number of meetings each year";
show .ut.pivr[;`year;`MeetType;`c]0!select c:count distinct VoteId by MeetType, year:`year$MeetDate_adj from ps;

-1"perc voting with management";
show 0!update p:c%sum c by year from select sum c by agree:MgtRec=VoteCast, year from `c xdesc select c:count i by MgtRec, VoteCast, year:`year$MeetDate_adj from ps;

-1"separate by Sponsor type";
show `Sponsor`agree xasc update p:c%sum c by year, Sponsor from select sum c by agree:?[MgtRec=VoteCast;`agree;`disagree], year, Sponsor from `c xdesc select c:count i by MgtRec, VoteCast, year:`year$MeetDate_adj, Sponsor from ps;

-1"perc votes with Shareholder sponsor";
show 0!update p:c%sum c by year from select c:count i by Sponsor, year:`year$MeetDate_adj from ps;

ps:update comp_related:upper[Proposal]like"*COMPENSATION*" from ps;
-1"Perc votes about comp";
show 0!update p:c%sum c from select c:count i by comp_related from ps;
show 0!update p:c%sum c by year from select c:count i by comp_related, year:`year$MeetDate_adj from ps;
-1"Among comp_related votes only:";
show 0!update p:c%sum c by year from select c:count i by agree, year:`year$MeetDate_adj from ps where comp_related;
show 0!update p:c%sum c by year from select c:count i by Sponsor, year:`year$MeetDate_adj from ps where comp_related;
