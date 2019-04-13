pwd:first system"dirname `readlink -f ",string[.z.f],"`";

system"l ",pwd,"/lib.q";
system"l /home/bogdan/q/lib/piv.q";

csv_path:pwd,"/../../data/ProxyMonitor.csv";
pm:.Q.id("*SSSSSSSF**";enlist",") 0: hsym`$csv_path;
pm:update MeetingDate:{"D"$"."sv reverse"/"vs x}'[MeetingDate] from pm;

ps:get each hsym`$(pwd,"/../../data/npx_forms_parsed/0001193125-17-273099";pwd,"/../../data/npx_forms_parsed/0001193125-18-263427");
ps:(,'/)ps;
ps:ps`$"State Street Equity 500 Index Portfolio";

ps:select from ps where MeetDate within (min;max)@\:pm`MeetingDate;

pm_univ:distinct pm`Company;
pm_canonical:{" ",x," "}each upper string pm_univ;
pm_canonical:ssr[;"&";"AND"]each pm_canonical;
pm_canonical:ssr[;", ";" "]each pm_canonical;
pm_canonical:ssr[;",";" "]each pm_canonical;
pm_canonical:ssr[;". ";" "]each pm_canonical;
pm_canonical:ssr[;".";" "]each pm_canonical;
pm_canonical:ssr[;" GRP ";" GROUP "]each pm_canonical;
pm_canonical:ssr[;" CORP ";" CORPORATION "]each pm_canonical;
pm_canonical:ssr[;" CO ";" COMPANY "]each pm_canonical;
pm_canonical:ssr[;" INC ";" INCORPORATED "]each pm_canonical;
pm_canonical:ssr[;" INTL ";" INTERNATIONAL "]each pm_canonical;
pm_canonical:ssr[;" INT'L ";" INTERNATIONAL "]each pm_canonical;
pm_canonical:`${-1_1_x}each pm_canonical;
pm:update Name_canon:(pm_univ!pm_canonical)Company from pm;
ps_univ:distinct ps`Name;
ps_canonical:{" ",x," "}each upper string ps_univ;
ps_canonical:ssr[;"&";"AND"]each ps_canonical;
ps_canonical:ssr[;", ";" "]each ps_canonical;
ps_canonical:ssr[;",";" "]each ps_canonical;
ps_canonical:ssr[;". ";" "]each ps_canonical;
ps_canonical:ssr[;".";" "]each ps_canonical;
ps_canonical:ssr[;" GRP ";" GROUP "]each ps_canonical;
ps_canonical:ssr[;" CORP ";" CORPORATION "]each ps_canonical;
ps_canonical:ssr[;" CO ";" COMPANY "]each ps_canonical;
ps_canonical:ssr[;" INC ";" INCORPORATED "]each ps_canonical;
ps_canonical:ssr[;" INTL ";" INTERNATIONAL "]each ps_canonical;
ps_canonical:ssr[;" INT'L ";" INTERNATIONAL "]each ps_canonical;
ps_canonical:`${-1_1_x}each ps_canonical;
ps:update Name_canon:(ps_univ!ps_canonical)Name from ps;

comp:.ut.pivr[;`name;`src;`c] 0!raze (select c:count i by name:Name_canon, src:`pm from pm;select c:count distinct NumRoot by name:Name_canon, src:`ps from ps);
