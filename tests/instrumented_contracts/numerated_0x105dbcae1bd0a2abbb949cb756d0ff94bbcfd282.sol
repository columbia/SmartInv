1 pragma solidity ^0.4.4;
2 
3 //////////////////////////////////////////////////////////
4 //
5 // Developer: ABCoin
6 // Date: 2018-06-01
7 // author: EricShu; Panyox
8 //
9 /////////////////////////////////////////////////////////
10 
11 contract MainBet{
12 
13     bytes30 constant public name = 'CrytoWorldCup';
14     uint constant public vision = 1.0;
15 
16     uint constant internal NOWINNER = 0;
17     uint constant internal WIN = 1;
18     uint constant internal LOSE = 2;
19     uint constant internal TIE = 3;
20 
21     uint private CLAIM_TAX = 20;
22 
23     address public creatorAddress;
24 
25     //player
26     struct Player {
27         address addr;
28         uint balance;
29         uint invested;
30         uint num;
31         uint prize;
32         uint claimed;
33     }
34 
35     mapping(address => Player) public players;
36     address[] public ch_players;
37     address[][10] public st_players;
38     address[][100] public nm_players;
39 
40     function getBalance() public constant returns(uint[]){
41         Player storage player = players[msg.sender];
42 
43         uint[] memory data = new uint[](6);
44         data[0] = player.balance;
45         data[1] = player.invested;
46         data[2] = player.num;
47         data[3] = player.prize;
48         data[4] = player.claimed;
49 
50         return data;
51     }
52 
53     function claim() public returns(bool){
54 
55         Player storage player = players[msg.sender];
56         require(player.balance>0);
57 
58         uint fee = SafeMath.div(player.balance, CLAIM_TAX);
59         uint finalValue = SafeMath.sub(player.balance, fee);
60 
61         msg.sender.transfer(finalValue);
62         creatorAddress.transfer(fee);
63 
64         player.claimed = SafeMath.add(player.claimed, player.balance);
65         player.balance = 0;
66 
67         return true;
68     }
69 
70     function setClamTax(uint _tax) public onlyOwner returns(bool){
71         require(_tax>0);
72 
73         CLAIM_TAX = _tax;
74         return true;
75     }
76 
77     modifier onlyOwner(){
78         assert(msg.sender == creatorAddress);
79         _;
80     }
81     modifier beforeTime(uint time){
82         assert(now < time);
83         _;
84     }
85     modifier afterTime(uint time){
86         assert(now > time);
87         _;
88     }
89 }
90 
91 //冠军赛
92 //32	沙特阿拉伯
93 //31	俄罗斯
94 //30	韩国
95 //29	日本
96 //28	巴拿马
97 //27	尼日利亚
98 //26	埃及
99 //25	摩洛哥
100 //24	澳大利亚
101 //23	塞尔维亚
102 //22	伊朗
103 //21	塞内加尔
104 //20	哥斯达黎加
105 //19	突尼斯
106 //18	瑞典
107 //17	冰岛
108 //16	墨西哥
109 //15	克罗地亚
110 //14	哥伦比亚
111 //13	丹麦
112 //12	秘鲁
113 //11	瑞士
114 //10	波兰
115 //9	比利时
116 //8	葡萄牙
117 //7	英格兰
118 //6	法国
119 //5	西班牙
120 //4	乌拉圭
121 //3	阿根廷
122 //2	德国
123 //1	巴西
124 contract Champion is MainBet{
125     uint public startTime = 0;
126     uint public endTime = 0;
127 
128     uint private totalPrize;
129     uint private numberBets;
130     uint private winner;
131 
132     bool private isInit = false;
133 
134     struct Country{
135         uint totalNum;
136         uint totalInvest;
137     }
138 
139     mapping (address => mapping (uint => uint)) private bets;
140     mapping (uint => Country) countrys;
141 
142     uint private lucky = 0;
143 
144     modifier beforeWinner {
145         assert(winner == NOWINNER);
146         _;
147     }
148     modifier beforeInit{
149         assert(isInit);
150         _;
151     }
152     function InitCountry(uint _startTime, uint _endTime) internal returns(bool res) {
153 
154         startTime = _startTime;
155         endTime = _endTime;
156 
157         winner = 0;
158 
159         totalPrize = 0;
160         numberBets = 0;
161         isInit = true;
162         return true;
163     }
164 
165     function setChampion(uint _winner) public onlyOwner beforeWinner returns (bool){
166         require(_winner>0);
167 
168         winner = _winner;
169 
170         Country storage country = countrys[_winner];
171 
172         for(uint i=0; i<ch_players.length; i++){
173             uint myInvest = bets[ch_players[i]][winner];
174             if(myInvest>0){
175                 Player storage player = players[ch_players[i]];
176                 uint winInest = SafeMath.mul(totalPrize, myInvest);
177                 uint prize = SafeMath.div(winInest, country.totalInvest);
178                 player.balance = SafeMath.add(player.balance, prize);
179                 player.prize = SafeMath.add(player.prize, prize);
180             }
181         }
182 
183         return true;
184     }
185 
186     function getChampion() public constant returns (uint winnerTeam){
187         return winner;
188     }
189 
190     function BetChampion(uint countryId) public beforeWinner afterTime(startTime) beforeTime(endTime) payable returns (bool)  {
191         require(msg.value>0);
192         require(countryId>0);
193 
194         countrys[countryId].totalInvest = SafeMath.add(countrys[countryId].totalInvest, msg.value);
195         countrys[countryId].totalNum = SafeMath.add(countrys[countryId].totalNum, 1);
196 
197         bets[msg.sender][countryId] = SafeMath.add(bets[msg.sender][countryId], msg.value);
198 
199         totalPrize = SafeMath.add(totalPrize, msg.value);
200 
201         numberBets++;
202 
203         Player storage player = players[msg.sender];
204         if(player.invested>0){
205             player.invested = SafeMath.add(player.invested, msg.value);
206             player.num = SafeMath.add(player.num, 1);
207         }else{
208             players[msg.sender] = Player({
209                 addr: msg.sender,
210                 balance: 0,
211                 invested: msg.value,
212                 num: 1,
213                 prize: 0,
214                 claimed: 0
215             });
216         }
217 
218         bool ext = false;
219         for(uint i=0; i<ch_players.length; i++){
220             if(ch_players[i] == msg.sender) {
221                 ext = true;
222                 break;
223             }
224         }
225         if(ext == false){
226             ch_players.push(msg.sender);
227         }
228         return true;
229     }
230 
231     function getCountryBet(uint countryId) public constant returns(uint[]){
232         require(countryId>0);
233 
234         Country storage country = countrys[countryId];
235         uint[] memory data = new uint[](4);
236         data[0] = country.totalNum;
237         data[1] = country.totalInvest;
238         data[2] = winner;
239         if(isInit){
240             data[3] = 1;
241         }
242         return data;
243     }
244 
245     function getDeepInfo(uint countryId) public constant returns(uint[]){
246         require(countryId>0);
247 
248         Country storage country = countrys[countryId];
249         uint[] memory data = new uint[](10);
250         data[0] = country.totalNum;
251         data[1] = country.totalInvest;
252         data[2] = lucky;
253         data[3] = 0;
254         data[4] = 0;
255 
256         if(winner>0){
257             data[4] = 1;
258         }
259         if(winner == countryId){
260 
261             uint myInvest = bets[msg.sender][winner];
262             if(myInvest>0){
263                 uint winInest = SafeMath.mul(totalPrize, myInvest);
264                 uint prize = SafeMath.div(winInest, country.totalInvest);
265                 data[2] = 1;
266                 data[3] = prize;
267             }
268         }
269 
270         return data;
271     }
272 
273     function getMyBet(uint countryId) public constant returns (uint teamBet) {
274        return (bets[msg.sender][countryId]);
275     }
276 
277     function getChStatus() public constant returns (uint []){
278         uint[] memory data = new uint[](3);
279         data[0] = totalPrize;
280         data[1] = numberBets;
281         data[2] = 0;
282         if(isInit){
283             data[2] = 1;
284             if(now > endTime){
285                 data[2] = 2;
286             }
287             if(winner > 0){
288                 data[2] = 3;
289             }
290         }
291 
292         return data;
293     }
294 
295     function getNumberOfBets() public constant returns (uint num){
296         return numberBets;
297     }
298 
299     function () public payable {
300         throw;
301     }
302 
303 }
304 
305 //普通赛 胜-平-负
306 contract Normal is MainBet{
307 
308     struct Better {
309         address addr;
310         uint invested;
311         uint teamBet; //bet win: 1,player1; 2,player2; 3,tie
312         uint claimPrize; // 0:false; 1:true
313     }
314 
315     struct Match{
316         uint matchId;
317         uint startTime;
318         uint winner;
319         uint totalInvest;
320         uint totalNum;
321         mapping(address => mapping(uint => Better)) betters;
322     }
323 
324     mapping(uint => Match) public matchs;
325     uint[] public match_pools;
326     uint public totalNum;
327     uint public totalInvest;
328 
329     function initNormal() public returns(bool){
330         for(uint i=0;i<match_pools.length;i++){
331             match_pools[i] = 0;
332         }
333         totalNum = 0;
334         totalInvest = 0;
335         return true;
336     }
337 
338     function addMatch(uint matchId, uint startTime) public onlyOwner returns(bool res){
339         require(matchId > 0);
340         require(now<startTime);
341 
342         for(uint i=0;i<match_pools.length;i++){
343             require(matchId!=match_pools[i]);
344         }
345 
346         Match memory _match = Match(matchId, startTime, 0, 0, 0);
347         matchs[matchId] = _match;
348         match_pools.push(matchId);
349 
350         return true;
351     }
352 
353     function getMatchIndex(uint matchId) public constant returns(uint){
354         require(matchId>0);
355 
356         uint index = 100;
357         for(uint i=0;i<match_pools.length;i++){
358             if(match_pools[i] == matchId){
359                 index = i;
360                 break;
361             }
362         }
363         // require(index < 100);
364         return index;
365     }
366 
367     function betMatch(uint matchId, uint team) public payable returns(bool res){
368         require(matchId>0 && team>0);
369         require(team == WIN || team == LOSE || team == TIE);
370         require(msg.value>0);
371 
372         Match storage _match = matchs[matchId];
373         require(_match.winner == NOWINNER);
374         require(now < _match.startTime);
375 
376         Better storage better = _match.betters[msg.sender][team];
377         if(better.invested>0){
378             better.invested = SafeMath.add(better.invested, msg.value);
379         }else{
380             _match.betters[msg.sender][team] = Better(msg.sender, msg.value, team,0);
381         }
382 
383         _match.totalNum = SafeMath.add(_match.totalNum, 1);
384         _match.totalInvest = SafeMath.add(_match.totalInvest, msg.value);
385         totalNum = SafeMath.add(totalNum, 1);
386         totalInvest = SafeMath.add(totalInvest, msg.value);
387 
388         Player storage player = players[msg.sender];
389         if(player.invested>0){
390             player.invested = SafeMath.add(player.invested, msg.value);
391             player.num = SafeMath.add(player.num, 1);
392         }else{
393             players[msg.sender] = Player({
394                 addr: msg.sender,
395                 balance: 0,
396                 invested: msg.value,
397                 num: 1,
398                 prize: 0,
399                 claimed: 0
400             });
401         }
402         uint index = getMatchIndex(matchId);
403         address[] memory match_betters = nm_players[index];
404         bool ext = false;
405         for(uint i=0;i<match_betters.length;i++){
406             if(match_betters[i]==msg.sender){
407                 ext = true;
408                 break;
409             }
410         }
411         if(ext == false){
412             nm_players[index].push(msg.sender);
413         }
414         return true;
415     }
416     function getMatch(uint matchId) public constant returns(uint[]){
417         require(matchId>0);
418         Match storage _match = matchs[matchId];
419         uint[] memory data = new uint[](2);
420         data[0] = _match.totalNum;
421         data[1] = _match.totalInvest;
422         return data;
423     }
424     function getPool() public constant returns(uint[]){
425         uint[] memory data = new uint[](2);
426         data[0] = totalNum;
427         data[1] = totalInvest;
428     }
429     function setWinner(uint _matchId, uint team) public onlyOwner returns(bool){
430         require(_matchId>0);
431         require(team == WIN || team == LOSE || team == TIE);
432         Match storage _match = matchs[_matchId];
433         require(_match.winner == NOWINNER);
434 
435         _match.winner = team;
436 
437         uint index = getMatchIndex(_matchId);
438         address[] memory match_betters = nm_players[index];
439         uint teamInvest = getTeamInvest(_matchId, team);
440         for(uint i=0;i<match_betters.length;i++){
441             Better storage better = _match.betters[match_betters[i]][team];
442             if(better.invested>0){
443                 uint winVal = SafeMath.mul(_match.totalInvest, better.invested);
444                 uint prize = SafeMath.div(winVal, teamInvest);
445                 Player storage player = players[match_betters[i]];
446                 player.balance = SafeMath.add(player.balance, prize);
447                 player.prize = SafeMath.add(player.prize, prize);
448             }
449         }
450         return true;
451     }
452 
453     function getTeamInvest(uint matchId, uint team) public constant returns(uint){
454         require(matchId>0);
455         require(team == WIN || team == LOSE || team == TIE);
456 
457         Match storage _match = matchs[matchId];
458         uint index = getMatchIndex(matchId);
459         address[] storage match_betters = nm_players[index];
460         uint invest = 0;
461         for(uint i=0;i<match_betters.length;i++){
462             Better storage better = _match.betters[match_betters[i]][team];
463             invest = SafeMath.add(invest, better.invested);
464         }
465 
466         return invest;
467     }
468 
469     function getMyNmBet(uint matchId, uint team) public constant returns(uint[]){
470         require(matchId>0);
471         require(team>0);
472         Match storage _match = matchs[matchId];
473 
474         uint[] memory data = new uint[](6);
475 
476         data[0] = _match.totalInvest;
477         data[1] = _match.totalNum;
478         data[2] = 0;
479         data[3] = 0;
480         data[4] = 0;
481         if(_match.winner>0){
482             data[2] = 1;
483             if(_match.winner == team){
484                 Better storage better = _match.betters[msg.sender][team];
485                 uint teamInvest = getTeamInvest(matchId, team);
486                 uint winVal = SafeMath.mul(_match.totalInvest, better.invested);
487                 uint prize = SafeMath.div(winVal, teamInvest);
488                 data[3] = 1;
489                 data[4] = prize;
490             }
491         }
492 
493         return data;
494     }
495 
496     function () public payable {
497         throw;
498     }
499 }
500 
501 //小组出线 4选2
502 contract Stage is MainBet{
503     event InitiateBet(address indexed _from, uint group_num);
504     event Bet(address indexed _from, uint[] teams, uint value, uint group_num, uint[] groupData, uint[] totalData);
505     event Winner(address indexed _from, uint group_num, uint[] _winner, uint _prize, uint winnerNum);
506     event Claim(address indexed _from, uint group_num, uint _value, uint taxValue);
507 
508     struct StageBetter {
509         address addr;
510         uint money_invested;
511         uint bet_team1;
512         uint bet_team2;
513     }
514 
515     struct Group {
516        uint group_num;
517        uint start_time;
518        uint end_time;
519        uint winner_team1;
520        uint winner_team2;
521        uint num_betters;
522        uint total_prize;
523        mapping (address => mapping (uint => StageBetter)) betters;
524        mapping (uint => uint) num_team_bets;
525     }
526 
527     mapping (uint => Group) groups;
528     uint[] public group_pools;
529 
530     function initStage() public onlyOwner returns(bool){
531 
532         for(uint i = 0;i<group_pools.length; i++){
533             group_pools[i] = 0;
534         }
535 
536         return true;
537     }
538 
539     function addGroup(uint _group_num, uint _start_time, uint _end_time) public returns(bool) {
540         require(_group_num > 0);
541         require(now <= _start_time);
542         require(_start_time <= _end_time);
543 
544         for(uint i = 0; i < group_pools.length; i++) {
545             require(_group_num != group_pools[i]);
546         }
547 
548         Group memory group = Group(_group_num, _start_time, _end_time, 0, 0, 0, 0);
549         groups[_group_num] = group;
550         group_pools.push(_group_num);
551 
552         InitiateBet(msg.sender, _group_num);
553         return true;
554     }
555 
556     function betStage(uint _group_num, uint[] _bet_teams) public payable returns (bool) {
557 
558         require(_group_num > 0);
559         require(msg.value > 0);
560         require(_bet_teams.length == 2);
561 
562         Group storage group = groups[_group_num];
563         require(group.winner_team1 == 0 && group.winner_team2 == 0);
564 
565         require(now <= group.start_time);
566 
567         uint sumofsquares = SafeMath.sumofsquares(_bet_teams[0], _bet_teams[1]);
568 
569         StageBetter storage better = group.betters[msg.sender][sumofsquares];
570         if(better.money_invested > 0) {
571             better.money_invested = SafeMath.add(better.money_invested, msg.value);
572         } else {
573             group.betters[msg.sender][_group_num] = StageBetter({
574                 addr: msg.sender,
575                 money_invested: msg.value,
576                 bet_team1: _bet_teams[0],
577                 bet_team2: _bet_teams[1]
578             });
579         }
580 
581         group.total_prize = SafeMath.add(group.total_prize, msg.value);
582         group.num_betters = SafeMath.add(group.num_betters, 1);
583         group.num_team_bets[sumofsquares] = SafeMath.add(group.num_team_bets[sumofsquares], 1);
584 
585         Player storage player = players[msg.sender];
586         if(player.invested>0){
587             player.invested = SafeMath.add(player.invested, msg.value);
588             player.num = SafeMath.add(player.num, 1);
589         }else{
590             players[msg.sender] = Player({
591                 addr: msg.sender,
592                 balance: 0,
593                 invested: msg.value,
594                 num: 1,
595                 prize: 0,
596                 claimed: 0
597             });
598         }
599         uint index = getGroupIndex(_group_num);
600         address[] memory group_betters = st_players[index];
601         bool ext = false;
602         for(uint i=0;i<group_betters.length;i++){
603             if(group_betters[i]==msg.sender){
604                 ext = true;
605                 break;
606             }
607         }
608         if(ext==false){
609             st_players[index].push(msg.sender);
610         }
611         return true;
612     }
613 
614     function setGroupWinner(uint _group_num, uint[] _winner_teams) public onlyOwner returns(bool) {
615 
616         require(_group_num > 0);
617         require(_winner_teams.length == 2);
618 
619         Group storage group = groups[_group_num];
620         require(group.winner_team1 == 0 && group.winner_team2 == 0);
621 
622         group.winner_team1 = _winner_teams[0];
623         group.winner_team2 = _winner_teams[1];
624 
625         uint sumofsquares = SafeMath.sumofsquares(group.winner_team1, group.winner_team2);
626 
627         uint index = getGroupIndex(_group_num);
628         address[] memory group_betters = st_players[index];
629         uint teamInvest = getGroupTeamInvest(_group_num, sumofsquares);
630         for(uint i=0;i<group_betters.length;i++){
631             StageBetter storage better = group.betters[group_betters[i]][_group_num];
632             if(better.money_invested > 0){
633                 uint aux = SafeMath.mul(group.total_prize, better.money_invested);
634                 uint prize = SafeMath.div(aux, teamInvest);
635 
636                 Player storage player = players[group_betters[i]];
637                 player.balance = SafeMath.add(player.balance, prize);
638                 player.prize = SafeMath.add(player.prize, prize);
639             }
640         }
641 
642         // Winner(msg.sender, _group_num, _winner_teams, prize, winnerNum);
643         return true;
644     }
645 
646     function updateEndTimeManually(uint _group_num, uint _end_time) public onlyOwner returns (bool){
647         Group storage group = groups[_group_num];
648         require(group.winner_team1 == 0 && group.winner_team2 == 0);
649 
650         group.end_time = _end_time;
651         return true;
652     }
653 
654     function updateStartTimeManually(uint _group_num, uint _start_time) public onlyOwner returns (bool){
655         Group storage group = groups[_group_num];
656         require(group.winner_team1 == 0 && group.winner_team2 == 0);
657 
658         group.start_time = _start_time;
659         return true;
660     }
661 
662     function getWinnerTeam(uint _group_num) public constant returns (uint[]){
663         require(_group_num > 0);
664 
665         uint[] memory data = new uint[](2);
666         Group storage group = groups[_group_num];
667         require(group.winner_team1 > 0 && group.winner_team2 > 0);
668 
669         data[0] = group.winner_team1;
670         data[1] = group.winner_team2;
671 
672         return data;
673     }
674 
675     function getGroupTeamInvest(uint _group_num, uint squares) public constant returns(uint){
676         require(_group_num>0);
677 
678         uint index = getGroupIndex(_group_num);
679         address[] storage group_betters = st_players[index];
680         Group storage group = groups[_group_num];
681         uint sumofsquares = SafeMath.sumofsquares(group.winner_team1, group.winner_team2);
682 
683         uint invest = 0;
684         for(uint i=0;i<group_betters.length;i++){
685             StageBetter storage better = group.betters[group_betters[i]][_group_num];
686             if(sumofsquares == squares){
687                 invest = SafeMath.add(invest, better.money_invested);
688             }
689 
690         }
691         return invest;
692     }
693 
694     function getGroupStatistic(uint _group_num) public constant returns (uint[]){
695         require(_group_num > 0);
696 
697         uint[] memory data = new uint[](5);
698         Group storage group = groups[_group_num];
699 
700         data[0] = group.total_prize;
701         data[1] = group.num_betters;
702         return data;
703     }
704 
705     function getMyStageBet(uint _group_num, uint team1, uint team2) public constant returns(uint[]){
706         require(_group_num>0);
707         require(team1>0);
708         require(team2>0);
709 
710         Group storage group = groups[_group_num];
711         uint sumofsquares = SafeMath.sumofsquares(team1, team2);
712         uint sumofsquares1 = SafeMath.sumofsquares(group.winner_team1, group.winner_team2);
713 
714         uint[] memory data = new uint[](6);
715         data[0] = group.total_prize;
716         data[1] = group.num_betters;
717         data[2] = 0;
718         data[3] = 0;
719         data[4] = 0;
720         if(sumofsquares1>0){
721             data[2] = 1;
722         }
723         if(sumofsquares == sumofsquares1){
724             data[3] = 1;
725             StageBetter storage better = group.betters[msg.sender][_group_num];
726             uint teamInvest = getGroupTeamInvest(_group_num, sumofsquares);
727             uint aux = SafeMath.mul(group.total_prize, better.money_invested);
728             uint prize = SafeMath.div(aux, teamInvest);
729             data[4] = prize;
730         }
731 
732         return data;
733     }
734 
735     function getGroupIndex(uint group_id) public constant returns(uint){
736         require(group_id>0);
737 
738         uint index = 10;
739         for(uint i=0;i<group_pools.length;i++){
740             if(group_pools[i] == group_id){
741                 index = i;
742                 break;
743             }
744         }
745         // require(index<10);
746         return index;
747     }
748 
749     function getNumberOfBets(uint _group_num) public constant returns (uint num_betters){
750         require(_group_num > 0);
751 
752         Group storage group = groups[_group_num];
753         return group.num_betters;
754     }
755 
756     function getAllGameStatistic() public constant returns (uint[]){
757         uint[] memory data = new uint[](2);
758         uint allTotalPrize = 0;
759         uint allNumberOfBets = 0;
760 
761         for(uint i = 0; i < group_pools.length; i++) {
762             uint group_num = group_pools[i];
763             Group storage group = groups[group_num];
764             allTotalPrize = SafeMath.add(group.total_prize, allTotalPrize);
765             allNumberOfBets = SafeMath.add(group.num_betters, allNumberOfBets);
766         }
767 
768         data[0] = allTotalPrize;
769         data[1] = allNumberOfBets;
770         return data;
771     }
772 
773     function getAllTotalPrize() public constant returns (uint){
774         uint allTotalPrize = 0;
775         for(uint i = 0; i < group_pools.length; i++) {
776             uint group_num = group_pools[i];
777             Group storage group = groups[group_num];
778             allTotalPrize = SafeMath.add(group.total_prize, allTotalPrize);
779         }
780         return allTotalPrize;
781     }
782 
783     function getAllNumberOfBets() public constant returns (uint){
784         uint allNumberOfBets = 0;
785         for(uint i = 0; i < group_pools.length; i++) {
786             uint group_num = group_pools[i];
787             Group storage group = groups[group_num];
788             allNumberOfBets = SafeMath.add(group.num_betters, allNumberOfBets);
789         }
790 
791         return allNumberOfBets;
792     }
793 
794 
795     function () public payable {
796         throw;
797     }
798 }
799 
800 contract CrytoWorldCup is Champion, Normal, Stage{
801 
802     function CrytoWorldCup() public {
803         creatorAddress = msg.sender;
804     }
805 
806     //初始化冠军赛
807     function initCountry(uint startTime, uint endTime) public onlyOwner returns(bool){
808         //
809         InitCountry(startTime, endTime);
810         return true;
811     }
812 
813     // gets called when no other function matches
814     function() public payable{
815         // just being sent some cash?
816         throw;
817     }
818 }
819 
820 library SafeMath {
821 
822     /**
823     * @dev Multiplies two numbers, throws on overflow.
824     */
825     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
826         if (a == 0) {
827             return 0;
828         }
829         uint256 c = a * b;
830         assert(c / a == b);
831         return c;
832     }
833 
834     /**
835     * @dev Integer division of two numbers, truncating the quotient.
836     */
837     function div(uint256 a, uint256 b) internal pure returns (uint256) {
838         // assert(b > 0); // Solidity automatically throws when dividing by 0
839         uint256 c = a / b;
840         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
841         return c;
842     }
843 
844     /**
845     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
846     */
847     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
848         assert(b <= a);
849         return a - b;
850     }
851 
852     /**
853     * @dev Adds two numbers, throws on overflow.
854     */
855     function add(uint256 a, uint256 b) internal pure returns (uint256) {
856         uint256 c = a + b;
857         assert(c >= a);
858         return c;
859     }
860     function sumofsquares(uint256 a, uint256 b) internal pure returns (uint256) {
861         uint256 c = a * a + b * b;
862         assert(c >= a);
863         return c;
864     }
865 }