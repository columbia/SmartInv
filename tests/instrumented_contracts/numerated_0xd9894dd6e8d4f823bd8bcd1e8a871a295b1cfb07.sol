1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     /**
10      * @dev Multiplies two numbers, throws on overflow.
11      */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19         c = a * b;
20         assert(c / a == b);
21         return c;
22     }
23 
24     /**
25      * @dev Integer division of two numbers, truncating the quotient.
26      */
27     function div(uint256 a, uint256 b) internal pure returns (uint256) {
28         // assert(b > 0); // Solidity automatically throws when dividing by 0
29         // uint256 c = a / b;
30         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31         return a / b;
32     }
33 
34     /**
35      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36      */
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         assert(b <= a);
39         return a - b;
40     }
41 
42     /**
43      * @dev Adds two numbers, throws on overflow.
44      */
45     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
46         c = a + b;
47         assert(c >= a);
48         return c;
49     }
50 }
51 
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59     address private owner;
60 
61     event OwnershipRenounced(address indexed previousOwner);
62 
63     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65     constructor () public {
66         owner = msg.sender;
67     }
68 
69     function getOwner() public view returns(address retOwnerAddress) {
70         return owner;
71     }
72 
73     /**
74      * @dev Throws if called by any account other than the owner.
75      */
76     modifier onlyOwner() {
77         require(msg.sender == owner);
78         _;
79     }
80 
81     /**
82      * @dev Allows the current owner to transfer control of the contract to a newOwner.
83      * @param newOwner The address to transfer ownership to.
84      */
85     function transferOwnership(address newOwner) public onlyOwner {
86         require(newOwner != address(0));
87         emit OwnershipTransferred(owner, newOwner);
88         owner = newOwner;
89     }
90 
91     /**
92      * @dev Allows the current owner to relinquish control of the contract.
93      */
94     function renounceOwnership() public onlyOwner {
95         emit OwnershipRenounced(owner);
96         owner = address(0);
97     }
98 }
99 
100 
101 contract AccessControl is Ownable {
102     address private ceoAddress;
103     address private cfoAddress;
104     address private cooAddress;
105 
106     bool private paused = false;
107 
108     constructor() public {
109         paused = true;
110 
111         ceoAddress = getOwner();
112         cooAddress = getOwner();
113         cfoAddress = getOwner();
114     }
115 
116     modifier onlyCEO() {
117         require(msg.sender == ceoAddress);
118         _;
119     }
120 
121     modifier onlyCFO() {
122         require(msg.sender == cfoAddress);
123         _;
124     }
125 
126     modifier onlyCOO() {
127         require(msg.sender == cooAddress);
128         _;
129     }
130 
131     modifier onlyCLevel() {
132         require(msg.sender == cooAddress ||
133             msg.sender == ceoAddress ||
134             msg.sender == cfoAddress);
135         _;
136     }
137 
138     function setCEO(address _newCEO) external onlyCEO {
139         require(_newCEO != address(0));
140         ceoAddress = _newCEO;
141     }
142 
143     function setCFO(address _newCFO) external onlyCEO {
144         require(_newCFO != address(0));
145         cfoAddress = _newCFO;
146     }
147 
148     function setCOO(address _newCOO) external onlyCEO {
149         require(_newCOO != address(0));
150         cooAddress = _newCOO;
151     }
152 
153     function getCFO() public view returns(address retCFOAddress) {
154         return cfoAddress;
155     }
156 
157     modifier whenNotPaused() {
158         require(!paused);
159         _;
160     }
161 
162     modifier whenPaused {
163         require(paused);
164         _;
165     }
166 
167     function pause() external onlyCLevel whenNotPaused {
168         paused = true;
169     }
170 
171     function unpause() public onlyCEO whenPaused {
172         paused = false;
173     }
174 }
175 
176 
177 contract Base {
178     uint8 constant internal INIT = 0;
179     uint8 constant internal WIN = 1;
180     uint8 constant internal LOSE = 2;
181     uint8 constant internal TIE = 3;
182     uint8 constant internal MATCH_CNT = 64;
183 
184     struct AccountInfo {
185         uint invested;
186         uint prize;
187         uint claimed;
188     }
189 
190     struct Match {
191         uint8 matchId;
192         uint8 hostTeamId;
193         uint8 guestTeamId;
194         uint startTime;
195         uint8 outcome;
196 
197         uint totalInvest;
198 
199         mapping(address => Better) betters;
200         mapping(uint8 => uint) mPredictionInvest;
201     }
202 
203     struct Better {
204         uint invested;
205         uint prize;
206 
207         mapping(uint8 => uint) bPredictionInvest;
208     }
209 
210     // 0.001 ETH =< msg.value =< 100 ETH
211     modifier validValue() {
212         require(msg.value >= 1000000000000000 && msg.value <= 100000000000000000000);
213         _;
214     }
215 
216     // 1-32 teams
217     modifier validTeam(uint8 _teamId) {
218         require(_teamId > 0 && _teamId < 33);
219         _;
220     }
221 
222     // 1-64 matches
223     modifier validMatch(uint8 _matchId) {
224         require(_matchId > 0 && _matchId < 65);
225         _;
226     }
227 
228     modifier validPredictionOrOutcome(uint8 _predictionOrOutcome) {
229         require(_predictionOrOutcome == WIN || _predictionOrOutcome == LOSE || _predictionOrOutcome == TIE);
230         _;
231     }
232 }
233 
234 
235 contract WorldCup2018 is Base, AccessControl {
236     using SafeMath for uint256;
237 
238     //<------------------------------------------------------------------------------------->
239     // /**
240     //  * @title PullPayment
241     //  * @dev Base contract supporting async send for pull payments. Inherit from this
242     //  * contract and use asyncSend instead of send or transfer.
243     //  */
244 
245     // / @dev WithdrawPayments event is emitted whenever a player withdraws the payments.
246     event WithdrawPayments(address indexed _player, uint256 _value);
247 
248     mapping(address => uint256) private payments;
249     uint256 private totalPayments;
250 
251     /**
252      * @dev To make sure the totalPayments by calling this method.
253      */
254     function getTotalPayments() public view returns(uint retTotalPayments) {
255         return totalPayments;
256     }
257 
258     /**
259      * @dev Withdraw accumulated balance, called by payee.
260      */
261     function withdrawPayments() public whenNotPaused {
262         address payee = msg.sender;
263         uint256 payment = payments[payee];
264 
265         require(payment != 0);
266         require(address(this).balance >= payment);
267 
268         totalPayments = totalPayments.sub(payment);
269         payments[payee] = 0;
270         payee.transfer(payment);
271 
272         emit WithdrawPayments(payee, payment);
273     }
274 
275     /**
276      * @dev Called by the payer to store the sent amount as credit to be pulled.
277      * @param dest The destination address of the funds.
278      * @param amount The amount to transfer.
279      */
280     function asyncSend(address dest, uint256 amount) internal onlyCLevel whenNotPaused {
281         require(address(this).balance >= amount);
282 
283         uint tempTotalPayments = totalPayments.add(amount);
284         require(address(this).balance >= tempTotalPayments);
285 
286         payments[dest] = payments[dest].add(amount);
287         // totalPayments = totalPayments.add(amount);
288         totalPayments = tempTotalPayments;
289     }
290     //<------------------------------------------------------------------------------------->
291 
292     event ContractUpgrade(address newContract);
293     event BetMatch(address indexed _betterAddress, uint _invested, uint8 _matchId, uint8 _prediction);
294     event SetOutcome(address indexed _setterAddress, uint8 _matchId, uint8 _outcome);
295     event UpdateMatch(address indexed _setterAddress, uint8 _matchId, uint8 _hostTeamId, uint8 _guestTeamId);
296     event UpdateMatchStartTime(address indexed _setterAddress, uint8 _matchId, uint _startTime);
297 
298     //<------------------------------------------------------------------------------------->
299     mapping(address => AccountInfo) private accountInfos;
300     uint8[MATCH_CNT] private match_pools;
301     mapping(uint8 => Match) private matchs;
302     address[][MATCH_CNT] private nm_players;
303     //<------------------------------------------------------------------------------------->
304     uint private totalInvest;
305     uint8 private CLAIM_TAX = 10;
306     //<------------------------------------------------------------------------------------->
307 
308     constructor() public {
309         init();
310         unpause();
311     }
312 
313     function init() 
314         private onlyCLevel {
315 
316         // 1	1 vs 2	    1528988400
317         initRegistMatch(1, 1, 2, 1528988400);
318         // 2	3 vs 4	    1529064000
319         initRegistMatch(2, 3, 4, 1529064000);
320         // 3	5 vs 6	    1529085600
321         initRegistMatch(3, 5, 6, 1529085600);
322         // 4	7 vs 8	    1529074800
323         initRegistMatch(4, 7, 8, 1529074800);
324         // 5	9 vs 10	    1529143200
325         initRegistMatch(5, 9, 10, 1529143200);
326         // 6	11 vs 12	1529164800
327         initRegistMatch(6, 11, 12, 1529164800);
328         // 7	13 vs 14	1529154000
329         initRegistMatch(7, 13, 14, 1529154000);
330         // 8	15 vs 16	1529175600
331         initRegistMatch(8, 15, 16, 1529175600);
332         // 9	17 vs 18	1529258400
333         initRegistMatch(9, 17, 18, 1529258400);
334         // 10	19 vs 20	1529236800
335         initRegistMatch(10, 19, 20, 1529236800);
336         // 11	21 vs 22	1529247600
337         initRegistMatch(11, 21, 22, 1529247600);
338         // 12	23 vs 24	1529323200
339         initRegistMatch(12, 23, 24, 1529323200);
340         // 13	25 vs 26	1529334000
341         initRegistMatch(13, 25, 26, 1529334000);
342         // 14	27 vs 28	1529344800
343         initRegistMatch(14, 27, 28, 1529344800);
344         // 15	29 vs 30	1529420400
345         initRegistMatch(15, 29, 30, 1529420400);
346         // 16	31 vs 32	1529409600
347         initRegistMatch(16, 31, 32, 1529409600);
348         // 17	1 vs 3	    1529431200
349         initRegistMatch(17, 1, 3, 1529431200);
350         // 18	4 vs 2	    1529506800
351         initRegistMatch(18, 4, 2, 1529506800);
352         // 19	5 vs 7	    1529496000
353         initRegistMatch(19, 5, 7, 1529496000);
354         // 20	8 vs 6	    1529517600
355         initRegistMatch(20, 8, 6, 1529517600);
356         // 21	9 vs 11	    1529593200
357         initRegistMatch(21, 9, 11, 1529593200);
358         // 22	12 vs 10	1529582400
359         initRegistMatch(22, 12, 10, 1529582400);
360         // 23	13 vs 15	1529604000
361         initRegistMatch(23, 13, 15, 1529604000);
362         // 24	16 vs 14	1529679600
363         initRegistMatch(24, 16, 14, 1529679600);
364         // 25	17 vs 19	1529668800
365         initRegistMatch(25, 17, 19, 1529668800);
366         // 26	20 vs 18	1529690400
367         initRegistMatch(26, 20, 18, 1529690400);
368         // 27	21 vs 23	1529776800
369         initRegistMatch(27, 21, 23, 1529776800);
370         // 28	24 vs 22	1529766000
371         initRegistMatch(28, 24, 22, 1529766000);
372         // 29	25 vs 27	1529755200
373         initRegistMatch(29, 25, 27, 1529755200);
374         // 30	28 vs 26	1529841600
375         initRegistMatch(30, 28, 26, 1529841600);
376         // 31	29 vs 31	1529863200
377         initRegistMatch(31, 29, 31, 1529863200);
378         // 32	32 vs 30	1529852400
379         initRegistMatch(32, 32, 30, 1529852400);
380         // 33	4 vs 1	    1529935200
381         initRegistMatch(33, 4, 1, 1529935200);
382         // 34	2 vs 3	    1529935200
383         initRegistMatch(34, 2, 3, 1529935200);
384         // 35	8 vs 5	    1529949600
385         initRegistMatch(35, 8, 5, 1529949600);
386         // 36	6 vs 7	    1529949600
387         initRegistMatch(36, 6, 7, 1529949600);
388         // 37	12 vs 9	    1530021600
389         initRegistMatch(37, 12, 9, 1530021600);
390         // 38	10 vs 11	1530021600
391         initRegistMatch(38, 10, 11, 1530021600);
392         // 39	16 vs 13	1530036000
393         initRegistMatch(39, 16, 13, 1530036000);
394         // 40	14 vs 15	1530036000
395         initRegistMatch(40, 14, 15, 1530036000);
396         // 41	20 vs 17	1530122400
397         initRegistMatch(41, 20, 17, 1530122400);
398         // 42	18 vs 19	1530122400
399         initRegistMatch(42, 18, 19, 1530122400);
400         // 43	24 vs 21	1530108000
401         initRegistMatch(43, 24, 21, 1530108000);
402         // 44	22 vs 23	1530108000
403         initRegistMatch(44, 22, 23, 1530108000);
404         // 45	28 vs 25	1530208800
405         initRegistMatch(45, 28, 25, 1530208800);
406         // 46	26 vs 27	1530208800
407         initRegistMatch(46, 26, 27, 1530208800);
408         // 47	32 vs 29	1530194400
409         initRegistMatch(47, 32, 29, 1530194400);
410         // 48	30 vs 31	1530194400
411         initRegistMatch(48, 30, 31, 1530194400);
412         // 49				1530367200
413         initRegistMatch(49, 0, 0, 1530367200);
414         // 50				1530381600
415         initRegistMatch(50, 0, 0, 1530381600);
416         // 51				1530453600
417         initRegistMatch(51, 0, 0, 1530453600);
418         // 52				1530468000
419         initRegistMatch(52, 0, 0, 1530468000);
420         // 53				1530540000
421         initRegistMatch(53, 0, 0, 1530540000);
422         // 54				1530554400
423         initRegistMatch(54, 0, 0, 1530554400);
424         // 55				1530626400
425         initRegistMatch(55, 0, 0, 1530626400);
426         // 56				1530640800
427         initRegistMatch(56, 0, 0, 1530640800);
428         // 57				1530885600
429         initRegistMatch(57, 0, 0, 1530885600);
430         // 58				1530900000
431         initRegistMatch(58, 0, 0, 1530900000);
432         // 59				1530972000
433         initRegistMatch(59, 0, 0, 1530972000);
434         // 60				1530986400
435         initRegistMatch(60, 0, 0, 1530986400);
436         // 61				1531245600
437         initRegistMatch(61, 0, 0, 1531245600);
438         // 62				1531332000
439         initRegistMatch(62, 0, 0, 1531332000);
440         // 63				1531576800
441         initRegistMatch(63, 0, 0, 1531576800);
442         // 64				1531666800
443         initRegistMatch(64, 0, 0, 1531666800);
444 
445         totalInvest = 0;
446     }
447 
448     function initRegistMatch(uint8 _matchId, uint8 _hostTeamId, uint8 _guestTeamId, uint _startTime) 
449         private onlyCLevel {
450 
451         Match memory _match = Match(_matchId, _hostTeamId, _guestTeamId, _startTime, 0, 0);
452         matchs[_matchId] = _match;
453         match_pools[_matchId - 1] = _matchId;
454     }
455 
456     function setClamTax(uint8 _tax) external onlyCLevel {
457         require(_tax > 0);
458         CLAIM_TAX = _tax;
459     }
460 
461     function getClamTax() public view returns(uint8 claimTax) {
462         return CLAIM_TAX;
463     }
464 
465     function getTotalInvest() 
466         public view returns(uint) {
467         return totalInvest;
468     }
469 
470     function updateMatch(uint8 _matchId, uint8 _hostTeamId, uint8 _guestTeamId) 
471         external onlyCLevel validMatch(_matchId) validTeam(_hostTeamId) validTeam(_guestTeamId) whenNotPaused {
472 
473         Match storage _match = matchs[_matchId];
474         require(_match.outcome == INIT);
475         require(now < _match.startTime);
476 
477         _match.hostTeamId = _hostTeamId;
478         _match.guestTeamId = _guestTeamId;
479 
480         emit UpdateMatch(msg.sender, _matchId, _hostTeamId, _guestTeamId);
481     }
482 
483     function updateMatchStartTime(uint8 _matchId, uint _startTime) 
484         external onlyCLevel validMatch(_matchId) whenNotPaused {
485 
486         Match storage _match = matchs[_matchId];
487         require(_match.outcome == INIT);
488         require(now < _startTime);
489 
490         _match.startTime = _startTime;
491 
492         emit UpdateMatchStartTime(msg.sender, _matchId, _startTime);
493     }
494 
495     function getMatchIndex(uint8 _matchId) 
496         private pure validMatch(_matchId) returns(uint8) {
497         return _matchId - 1;
498     }
499 
500     function betMatch(uint8 _matchId, uint8 _prediction) 
501         external payable validValue validMatch(_matchId) validPredictionOrOutcome(_prediction) whenNotPaused {
502 
503         Match storage _match = matchs[_matchId];
504         require(_match.outcome == INIT);
505         require(now < _match.startTime);
506 
507         {
508             Better storage better = _match.betters[msg.sender];
509             if (better.invested > 0) {
510                 better.invested = better.invested.add(msg.value);
511             } else {
512                 _match.betters[msg.sender] = Better(msg.value, 0);
513             }
514             _match.betters[msg.sender].bPredictionInvest[_prediction] = _match.betters[msg.sender].bPredictionInvest[_prediction].add(msg.value);
515         }
516 
517         {
518             _match.mPredictionInvest[_prediction] = _match.mPredictionInvest[_prediction].add(msg.value);
519             _match.totalInvest = _match.totalInvest.add(msg.value);
520         }
521 
522         {
523             totalInvest = totalInvest.add(msg.value);
524         }
525 
526         {
527             AccountInfo storage accountInfo = accountInfos[msg.sender];
528             if (accountInfo.invested > 0) {
529                 accountInfo.invested = accountInfo.invested.add(msg.value);
530             } else {
531                 accountInfos[msg.sender] = AccountInfo({
532                     invested: msg.value, prize: 0, claimed: 0
533                 });
534             }
535         }
536 
537         {
538             uint8 index = getMatchIndex(_matchId);
539             address[] memory match_betters = nm_players[index];
540 
541             bool ext = false;
542             for (uint i = 0; i < match_betters.length; i++) {
543                 if (match_betters[i] == msg.sender) {
544                     ext = true;
545                     break;
546                 }
547             }
548             if (ext == false) {
549                 nm_players[index].push(msg.sender);
550             }
551         }
552 
553         emit BetMatch(msg.sender, msg.value, _matchId, _prediction);
554     }
555 
556     function setOutcome(uint8 _matchId, uint8 _outcome) 
557         external onlyCLevel validMatch(_matchId) validPredictionOrOutcome(_outcome) whenNotPaused {
558 
559         Match storage _match = matchs[_matchId];
560         require(_match.outcome == INIT);
561         _match.outcome = _outcome;
562 
563         noticeWinner(_matchId);
564 
565         emit SetOutcome(msg.sender, _matchId, _outcome);
566     }
567 
568     function noticeWinner(uint8 _matchId) 
569         private onlyCLevel {
570 
571         Match storage _match = matchs[_matchId];
572         uint totalInvestForWinners = _match.mPredictionInvest[_match.outcome];
573 
574         uint fee = 0;
575         uint prizeDistributionTotal = 0;
576 
577         if (_match.totalInvest > totalInvestForWinners) {
578             (prizeDistributionTotal, fee) = feesTakenFromPrize(_match.totalInvest, totalInvestForWinners);
579         }
580 
581         if (fee > 0) {
582             asyncSend(getCFO(), fee);
583         }
584 
585         if (prizeDistributionTotal > 0 || _match.totalInvest == totalInvestForWinners) {
586             uint8 index = getMatchIndex(_matchId);
587             address[] memory match_betters = nm_players[index];
588 
589             for(uint i = 0; i < match_betters.length; i++) {
590                 Better storage better = _match.betters[match_betters[i]];
591 
592                 uint totalInvestForBetter = better.bPredictionInvest[_match.outcome];
593                 if (totalInvestForBetter > 0) {
594                     uint prize = calculatePrize(prizeDistributionTotal, totalInvestForBetter, totalInvestForWinners);
595 
596                     better.prize = prize;
597 
598                     uint refundVal = totalInvestForBetter.add(prize);
599                     asyncSend(match_betters[i], refundVal);
600 
601                     {
602                         AccountInfo storage accountInfo = accountInfos[match_betters[i]];
603                         accountInfo.prize = accountInfo.prize.add(prize);
604                         accountInfo.claimed = accountInfo.claimed.add(refundVal);
605                     }
606                 }
607             }
608         }
609     }
610 
611     function feesTakenFromPrize(uint _totalInvestForMatch, uint _totalInvestForWinners) 
612         private view returns(uint prizeDistributionTotal, uint fee) {
613 
614         require(_totalInvestForMatch >= _totalInvestForWinners);
615 
616         if (_totalInvestForWinners > 0) {
617             if (_totalInvestForMatch > _totalInvestForWinners) {
618                 uint prizeTotal = _totalInvestForMatch.sub(_totalInvestForWinners);
619                 fee = prizeTotal.div(getClamTax());
620                 prizeDistributionTotal = prizeTotal.sub(fee);
621             }
622         } else {
623             fee = _totalInvestForMatch;
624         }
625 
626         return (prizeDistributionTotal, fee);
627     }
628 
629     function calculatePrize(uint _prizeDistributionTotal, uint _totalInvestForBetter, uint _totalInvestForWinners) 
630         private pure returns(uint) {
631         return (_prizeDistributionTotal.mul(_totalInvestForBetter)).div(_totalInvestForWinners);
632     }
633 
634     function getUserAccountInfo() public view returns(
635         uint invested, 
636         uint prize, 
637         uint balance
638     ) {
639         AccountInfo storage accountInfo = accountInfos[msg.sender];
640 
641         invested = accountInfo.invested;
642         prize = accountInfo.prize;
643         balance = payments[msg.sender];
644 
645         return (invested, prize, balance);
646     }
647 
648     function getMatchInfoList01() public view returns(
649         uint8[MATCH_CNT] matchIdArray, 
650         uint8[MATCH_CNT] hostTeamIdArray, 
651         uint8[MATCH_CNT] guestTeamIdArray, 
652         uint[MATCH_CNT] startTimeArray, 
653         uint8[MATCH_CNT] outcomeArray 
654     ) {
655         for (uint8 intI = 0; intI < MATCH_CNT; intI++) {
656             Match storage _match = matchs[match_pools[intI]];
657 
658             matchIdArray[intI] = _match.matchId;
659 
660             hostTeamIdArray[intI] = _match.hostTeamId;
661             guestTeamIdArray[intI] = _match.guestTeamId;
662             startTimeArray[intI] = _match.startTime;
663             outcomeArray[intI] = _match.outcome;
664         }
665 
666         return (
667             matchIdArray,
668 
669             hostTeamIdArray,
670             guestTeamIdArray,
671             startTimeArray,
672 
673             outcomeArray
674         );
675     }
676 
677     function getMatchInfoList02() public view returns(
678         uint[MATCH_CNT] winPredictionArray, 
679         uint[MATCH_CNT] losePredictionArray, 
680         uint[MATCH_CNT] tiePredictionArray
681     ) {
682         for (uint8 intI = 0; intI < MATCH_CNT; intI++) {
683             Match storage _match = matchs[match_pools[intI]];
684 
685             winPredictionArray[intI] = _match.mPredictionInvest[WIN];
686             losePredictionArray[intI] = _match.mPredictionInvest[LOSE];
687             tiePredictionArray[intI] = _match.mPredictionInvest[TIE];
688         }
689 
690         return (
691             winPredictionArray,
692             losePredictionArray,
693             tiePredictionArray
694         );
695     }
696 
697     function getMatchInfoList03() public view returns(
698         uint[MATCH_CNT] winPredictionArrayForLoginUser, 
699         uint[MATCH_CNT] losePredictionArrayForLoginUser, 
700         uint[MATCH_CNT] tiePredictionArrayForLoginUser
701     ) {
702         for (uint8 intI = 0; intI < MATCH_CNT; intI++) {
703             Match storage _match = matchs[match_pools[intI]];
704 
705             Better storage better = _match.betters[msg.sender];
706 
707             winPredictionArrayForLoginUser[intI] = better.bPredictionInvest[WIN];
708             losePredictionArrayForLoginUser[intI] = better.bPredictionInvest[LOSE];
709             tiePredictionArrayForLoginUser[intI] = better.bPredictionInvest[TIE];
710         }
711 
712         return (
713             winPredictionArrayForLoginUser,
714             losePredictionArrayForLoginUser,
715             tiePredictionArrayForLoginUser
716         );
717     }
718 
719     function () public payable {
720         revert();
721     }
722 
723     function kill() 
724         public onlyOwner whenNotPaused {
725 
726         require(getTotalPayments() == 0);
727 
728         for (uint8 intI = 0; intI < MATCH_CNT; intI++) {
729             Match storage _match = matchs[match_pools[intI]];
730             require(_match.outcome > INIT);
731         }
732 
733         selfdestruct(getOwner());
734     }
735 }