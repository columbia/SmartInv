1 pragma solidity ^0.4.24;
2 
3 /**
4 *
5 *  https://fundingsecured.me/fair/
6 *
7 *
8 *  ________ ________  ___  ________
9 * |\  _____\\   __  \|\  \|\   __  \
10 * \ \  \__/\ \  \|\  \ \  \ \  \|\  \
11 *  \ \   __\\ \   __  \ \  \ \   _  _\
12 *   \ \  \_| \ \  \ \  \ \  \ \  \\  \|
13 *    \ \__\   \ \__\ \__\ \__\ \__\\ _\
14 *     \|__|    \|__|\|__|\|__|\|__|\|__|
15 *  ________ ___  ___  ________   ________  ________
16 * |\  _____\\  \|\  \|\   ___  \|\   ___ \|\   ____\
17 * \ \  \__/\ \  \\\  \ \  \\ \  \ \  \_|\ \ \  \___|_
18 *  \ \   __\\ \  \\\  \ \  \\ \  \ \  \ \\ \ \_____  \
19 *   \ \  \_| \ \  \\\  \ \  \\ \  \ \  \_\\ \|____|\  \
20 *    \ \__\   \ \_______\ \__\\ \__\ \_______\____\_\  \
21 *     \|__|    \|_______|\|__| \|__|\|_______|\_________\
22 *                                            \|_________|
23 *
24 *  https://fundingsecured.me/fair/
25 *
26 *
27 * Warning:
28 *
29 * FAIR FUNDS is a game system built on FUNDING SECURED, using infinite loops of token redistribution through open source smart contract codes and pre-defined rules.
30 * This system is for internal use only and all could be lost by sending anything to this contract address.
31 * No one can change anything once the contract has been deployed.
32 * Built in Antiwhale for initial stages for a fairer system.
33 *
34 * Official Website: https://fundingsecured.me/
35 * Official Exchange: https://fundingsecured.me/exchange
36 * Official Discord: https://discordapp.com/invite/3FrBqBa
37 * Official Twitter: https://twitter.com/FundingSecured_
38 * Official Telegram: https://t.me/fundingsecured
39  *
40 **/
41 
42 
43 contract FAIRFUNDS {
44     using SafeMath for uint256;
45 
46     /*------------------------------
47                 CONFIGURABLES
48      ------------------------------*/
49     string public name = "FAIRFUNDS";    // Contract name
50     string public symbol = "FAIRFUNDS";
51 
52     uint256 public initAmount;          // Initial stage target
53     uint256 public amountProportion;    // Stage target growth rate %
54     uint256 public dividend;            // Input to Dividend %
55     uint256 public jackpot;             // Input to Jackpot %
56     uint256 public jackpotProportion;   // Jackpot payout %
57     uint256 public fundsTokenDividend;  // Dividend fee % to FUNDS token holders
58     uint256 public promotionRatio;      // Promotion %
59     uint256 public duration;            // Duration per stage
60     bool public activated = false;
61 
62     address public developerAddr;
63     address public fundsDividendAddr;
64 
65     /*------------------------------
66                 DATASETS
67      ------------------------------*/
68     uint256 public rId;   // Current round id number
69     uint256 public sId;   // Current stage id number
70 
71     mapping (uint256 => Indatasets.Round) public round; // (rId => data) round data by round id
72     mapping (uint256 => mapping (uint256 => Indatasets.Stage)) public stage;    // (rId => sId => data) stage data by round id & stage id
73     mapping (address => Indatasets.Player) public player;   // (address => data) player data
74     mapping (uint256 => mapping (address => uint256)) public playerRoundAmount; // (rId => address => playerRoundAmount) round data by round id
75     mapping (uint256 => mapping (address => uint256)) public playerRoundSid;
76     mapping (uint256 => mapping (address => uint256)) public playerRoundwithdrawAmountFlag;
77     mapping (uint256 => mapping (uint256 => mapping (address => uint256))) public playerStageAmount;    // (rId => sId => address => playerStageAmount) round data by round id & stage id
78     mapping (uint256 => mapping (uint256 => mapping (address => uint256))) public playerStageAccAmount;
79 
80     //Antiwhale setting, max 5% of stage target for the first 10 stages per address
81     uint256[] amountLimit = [0, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250];
82 
83     /*------------------------------
84                 PUBLIC FUNCTIONS
85     ------------------------------*/
86 
87     constructor()
88         public
89     {
90         developerAddr = msg.sender;
91         fundsDividendAddr = 0xd529ADaE263048f495A05B858c8E7C077F047813;
92     }
93 
94     /*------------------------------
95                 MODIFIERS
96      ------------------------------*/
97 
98     modifier isActivated() {
99         require(activated == true, "its not ready yet.  check ?eta in discord");
100         _;
101     }
102 
103     modifier senderVerify() {
104         require (msg.sender == tx.origin);
105         _;
106     }
107 
108     modifier stageVerify(uint256 _rId, uint256 _sId, uint256 _amount) {
109         require(stage[_rId][_sId].amount.add(_amount) <= stage[_rId][_sId].targetAmount);
110         _;
111     }
112 
113     /**
114      * Don't toy or spam the contract.
115      */
116     modifier amountVerify() {
117         require(msg.value >= 100000000000000);
118         _;
119     }
120 
121     modifier playerVerify() {
122         require(player[msg.sender].active == true);
123         _;
124     }
125 
126     /**
127      * Activation of contract with settings
128      */
129     function activate()
130         public
131     {
132         require(msg.sender == developerAddr);
133         require(activated == false, "FUNDS already activated");
134 
135         activated = true;
136         initAmount = 10000000000000000000;
137         amountProportion = 10;
138         dividend = 70;
139         jackpot = 20;
140         jackpotProportion = 70;
141         fundsTokenDividend = 10;
142         promotionRatio = 10;
143         duration = 15600;
144         rId = 1;
145         sId = 1;
146 
147         round[rId].start = now;
148         initStage(rId, sId);
149 
150     }
151 
152     /**
153      * Fallback function to handle ethereum that was send straight to the contract
154      * Unfortunately we cannot use a referral address this way.
155      */
156     function()
157         isActivated()
158         senderVerify()
159         amountVerify()
160         payable
161         public
162     {
163         buyAnalysis(0x0);
164     }
165 
166     /**
167      * Standard buy function.
168      */
169     function buy(address _recommendAddr)
170         isActivated()
171         senderVerify()
172         amountVerify()
173         public
174         payable
175         returns(uint256)
176     {
177         buyAnalysis(_recommendAddr);
178     }
179 
180     /**
181      * Withdraw function.
182      * Withdraw 50 stages at once on current settings.
183      * May require to request withdraw more than once to withdraw everything.
184      */
185     function withdraw()
186         isActivated()
187         senderVerify()
188         playerVerify()
189         public
190     {
191         uint256 _rId = rId;
192         uint256 _sId = sId;
193         uint256 _amount;
194         uint256 _playerWithdrawAmountFlag;
195 
196         (_amount, player[msg.sender].withdrawRid, player[msg.sender].withdrawSid, _playerWithdrawAmountFlag) = getPlayerDividendByStage(_rId, _sId, msg.sender);
197 
198         if(_playerWithdrawAmountFlag > 0)
199             playerRoundwithdrawAmountFlag[player[msg.sender].withdrawRid][msg.sender] = _playerWithdrawAmountFlag;
200 
201         if(player[msg.sender].promotionAmount > 0 ){
202             _amount = _amount.add(player[msg.sender].promotionAmount);
203             player[msg.sender].promotionAmount = 0;
204         }
205         msg.sender.transfer(_amount);
206     }
207 
208 
209     /**
210      * Core logic to analyse buy behaviour.
211      */
212     function buyAnalysis(address _recommendAddr)
213         private
214     {
215         uint256 _rId = rId;
216         uint256 _sId = sId;
217         uint256 _amount = msg.value;
218         uint256 _promotionRatio = promotionRatio;
219 
220         if(now > stage[_rId][_sId].end && stage[_rId][_sId].targetAmount > stage[_rId][_sId].amount){
221 
222             endRound(_rId, _sId);
223 
224             _rId = rId;
225             _sId = sId;
226             round[_rId].start = now;
227             initStage(_rId, _sId);
228 
229             _amount = limitAmount(_rId, _sId);
230             buyRoundDataRecord(_rId, _amount);
231             _promotionRatio = promotionDataRecord(_recommendAddr, _amount);
232             buyStageDataRecord(_rId, _sId, _promotionRatio, _amount);
233             buyPlayerDataRecord(_rId, _sId, _amount);
234 
235         }else if(now <= stage[_rId][_sId].end){
236 
237             _amount = limitAmount(_rId, _sId);
238             buyRoundDataRecord(_rId, _amount);
239             _promotionRatio = promotionDataRecord(_recommendAddr, _amount);
240 
241             if(stage[_rId][_sId].amount.add(_amount) >= stage[_rId][_sId].targetAmount){
242 
243                 uint256 differenceAmount = (stage[_rId][_sId].targetAmount).sub(stage[_rId][_sId].amount);
244                 buyStageDataRecord(_rId, _sId, _promotionRatio, differenceAmount);
245                 buyPlayerDataRecord(_rId, _sId, differenceAmount);
246 
247                 endStage(_rId, _sId);
248 
249                 _sId = sId;
250                 initStage(_rId, _sId);
251                 round[_rId].endSid = _sId;
252                 buyStageDataRecord(_rId, _sId, _promotionRatio, _amount.sub(differenceAmount));
253                 buyPlayerDataRecord(_rId, _sId, _amount.sub(differenceAmount));
254 
255             }else{
256                 buyStageDataRecord(_rId, _sId, _promotionRatio, _amount);
257                 buyPlayerDataRecord(_rId, _sId, _amount);
258 
259             }
260         }
261     }
262 
263 
264     /**
265      * Sets the initial stage parameter.
266      */
267     function initStage(uint256 _rId, uint256 _sId)
268         private
269     {
270         uint256 _targetAmount;
271         stage[_rId][_sId].start = now;
272         stage[_rId][_sId].end = now.add(duration);
273         if(_sId > 1){
274             stage[_rId][_sId - 1].end = now;
275             stage[_rId][_sId - 1].ended = true;
276             _targetAmount = (stage[_rId][_sId - 1].targetAmount.mul(amountProportion + 100)) / 100;
277         }else
278             _targetAmount = initAmount;
279 
280         stage[_rId][_sId].targetAmount = _targetAmount;
281 
282     }
283 
284     /**
285      * Execution of antiwhale.
286      */
287     function limitAmount(uint256 _rId, uint256 _sId)
288         private
289         returns(uint256)
290     {
291         uint256 _amount = msg.value;
292 
293         if(amountLimit.length > _sId)
294             _amount = ((stage[_rId][_sId].targetAmount.mul(amountLimit[_sId])) / 1000).sub(playerStageAmount[_rId][_sId][msg.sender]);
295         else
296             _amount = ((stage[_rId][_sId].targetAmount.mul(500)) / 1000).sub(playerStageAmount[_rId][_sId][msg.sender]);
297 
298         if(_amount >= msg.value)
299             return msg.value;
300         else
301             msg.sender.transfer(msg.value.sub(_amount));
302 
303         return _amount;
304     }
305 
306     /**
307      * Record the addresses eligible for promotion links.
308      */
309     function promotionDataRecord(address _recommendAddr, uint256 _amount)
310         private
311         returns(uint256)
312     {
313         uint256 _promotionRatio = promotionRatio;
314 
315         if(_recommendAddr != 0x0000000000000000000000000000000000000000
316             && _recommendAddr != msg.sender
317             && player[_recommendAddr].active == true
318         )
319             player[_recommendAddr].promotionAmount = player[_recommendAddr].promotionAmount.add((_amount.mul(_promotionRatio)) / 100);
320         else
321             _promotionRatio = 0;
322 
323         return _promotionRatio;
324     }
325 
326 
327     /**
328      * Records the round data.
329      */
330     function buyRoundDataRecord(uint256 _rId, uint256 _amount)
331         private
332     {
333 
334         round[_rId].amount = round[_rId].amount.add(_amount);
335         fundsDividendAddr.transfer(_amount.mul(fundsTokenDividend) / 100);
336     }
337 
338     /**
339      * Records the stage data.
340      */
341     function buyStageDataRecord(uint256 _rId, uint256 _sId, uint256 _promotionRatio, uint256 _amount)
342         stageVerify(_rId, _sId, _amount)
343         private
344     {
345         if(_amount <= 0)
346             return;
347         stage[_rId][_sId].amount = stage[_rId][_sId].amount.add(_amount);
348         stage[_rId][_sId].dividendAmount = stage[_rId][_sId].dividendAmount.add((_amount.mul(dividend.sub(_promotionRatio))) / 100);
349     }
350 
351     /**
352      * Records the player data.
353      */
354     function buyPlayerDataRecord(uint256 _rId, uint256 _sId, uint256 _amount)
355         private
356     {
357         if(_amount <= 0)
358             return;
359 
360         if(player[msg.sender].active == false){
361             player[msg.sender].active = true;
362             player[msg.sender].withdrawRid = _rId;
363             player[msg.sender].withdrawSid = _sId;
364         }
365 
366         if(playerRoundAmount[_rId][msg.sender] == 0){
367             round[_rId].players++;
368             playerRoundSid[_rId][msg.sender] = _sId;
369         }
370 
371         if(playerStageAmount[_rId][_sId][msg.sender] == 0)
372             stage[_rId][_sId].players++;
373 
374         playerRoundAmount[_rId][msg.sender] = playerRoundAmount[_rId][msg.sender].add(_amount);
375         playerStageAmount[_rId][_sId][msg.sender] = playerStageAmount[_rId][_sId][msg.sender].add(_amount);
376 
377         player[msg.sender].amount = player[msg.sender].amount.add(_amount);
378 
379         if(playerRoundSid[_rId][msg.sender] > 0){
380 
381             if(playerStageAccAmount[_rId][_sId][msg.sender] == 0){
382 
383                 for(uint256 i = playerRoundSid[_rId][msg.sender]; i < _sId; i++){
384 
385                     if(playerStageAmount[_rId][i][msg.sender] > 0)
386                         playerStageAccAmount[_rId][_sId][msg.sender] = playerStageAccAmount[_rId][_sId][msg.sender].add(playerStageAmount[_rId][i][msg.sender]);
387 
388                 }
389             }
390 
391             playerStageAccAmount[_rId][_sId][msg.sender] = playerStageAccAmount[_rId][_sId][msg.sender].add(_amount);
392         }
393     }
394 
395     /**
396      * Execute end of round events.
397      */
398     function endRound(uint256 _rId, uint256 _sId)
399         private
400     {
401         round[_rId].end = now;
402         round[_rId].ended = true;
403         round[_rId].endSid = _sId;
404         stage[_rId][_sId].end = now;
405         stage[_rId][_sId].ended = true;
406 
407         if(stage[_rId][_sId].players == 0)
408             round[_rId + 1].jackpotAmount = round[_rId + 1].jackpotAmount.add(round[_rId].jackpotAmount);
409         else
410             round[_rId + 1].jackpotAmount = round[_rId + 1].jackpotAmount.add(round[_rId].jackpotAmount.mul(100 - jackpotProportion) / 100);
411 
412         rId++;
413         sId = 1;
414 
415     }
416 
417     /**
418      * Execute end of stage events.
419      */
420     function endStage(uint256 _rId, uint256 _sId)
421         private
422     {
423         uint256 _jackpotAmount = stage[_rId][_sId].amount.mul(jackpot) / 100;
424         round[_rId].endSid = _sId;
425         round[_rId].jackpotAmount = round[_rId].jackpotAmount.add(_jackpotAmount);
426         stage[_rId][_sId].end = now;
427         stage[_rId][_sId].ended = true;
428         if(_sId > 1)
429             stage[_rId][_sId].accAmount = stage[_rId][_sId].targetAmount.add(stage[_rId][_sId - 1].accAmount);
430         else
431             stage[_rId][_sId].accAmount = stage[_rId][_sId].targetAmount;
432 
433         sId++;
434     }
435 
436     /**
437      * Precalculations for withdraws to conserve gas.
438      */
439     function getPlayerDividendByStage(uint256 _rId, uint256 _sId, address _playerAddr)
440         private
441         view
442         returns(uint256, uint256, uint256, uint256)
443     {
444 
445         uint256 _dividend;
446         uint256 _stageNumber;
447         uint256 _startSid;
448         uint256 _playerAmount;
449 
450         for(uint256 i = player[_playerAddr].withdrawRid; i <= _rId; i++){
451 
452             if(playerRoundAmount[i][_playerAddr] == 0)
453                 continue;
454 
455             _playerAmount = 0;
456             _startSid = i == player[_playerAddr].withdrawRid ? player[_playerAddr].withdrawSid : 1;
457             for(uint256 j = _startSid; j < round[i].endSid; j++){
458 
459                 if(playerStageAccAmount[i][j][_playerAddr] > 0)
460                     _playerAmount = playerStageAccAmount[i][j][_playerAddr];
461 
462                 if(_playerAmount == 0)
463                     _playerAmount = playerRoundwithdrawAmountFlag[i][_playerAddr];
464 
465                 if(_playerAmount == 0)
466                     continue;
467                 _dividend = _dividend.add(
468                     (
469                         _playerAmount.mul(stage[i][j].dividendAmount)
470                     ).div(stage[i][j].accAmount)
471                 );
472 
473                 _stageNumber++;
474                 if(_stageNumber >= 50)
475                     return (_dividend, i, j + 1, _playerAmount);
476             }
477 
478             if(round[i].ended == true
479                 && stage[i][round[i].endSid].amount > 0
480                 && playerStageAmount[i][round[i].endSid][_playerAddr] > 0
481             ){
482                 _dividend = _dividend.add(getPlayerJackpot(_playerAddr, i));
483                 _stageNumber++;
484                 if(_stageNumber >= 50)
485                     return (_dividend, i + 1, 1, 0);
486             }
487         }
488         return (_dividend, _rId, _sId, _playerAmount);
489     }
490 
491     /**
492      * Get player current withdrawable dividend.
493      */
494     function getPlayerDividend(address _playerAddr)
495         public
496         view
497         returns(uint256)
498     {
499         uint256 _endRid = rId;
500         uint256 _startRid = player[_playerAddr].withdrawRid;
501         uint256 _startSid;
502         uint256 _dividend;
503 
504         for(uint256 i = _startRid; i <= _endRid; i++){
505 
506             if(i == _startRid)
507                 _startSid = player[_playerAddr].withdrawSid;
508             else
509                 _startSid = 1;
510             _dividend = _dividend.add(getPlayerDividendByRound(_playerAddr, i, _startSid));
511         }
512 
513         return _dividend;
514     }
515 
516     /**
517      * Get player data for rounds and stages.
518      */
519     function getPlayerDividendByRound(address _playerAddr, uint256 _rId, uint256 _sId)
520         public
521         view
522         returns(uint256)
523     {
524         uint256 _dividend;
525         uint256 _startSid = _sId;
526         uint256 _endSid = round[_rId].endSid;
527 
528         uint256 _playerAmount;
529         uint256 _totalAmount;
530         for(uint256 i = _startSid; i < _endSid; i++){
531 
532             if(stage[_rId][i].ended == false)
533                 continue;
534 
535             _playerAmount = 0;
536             _totalAmount = 0;
537             for(uint256 j = 1; j <= i; j++){
538 
539                 if(playerStageAmount[_rId][j][_playerAddr] > 0)
540                     _playerAmount = _playerAmount.add(playerStageAmount[_rId][j][_playerAddr]);
541 
542                 _totalAmount = _totalAmount.add(stage[_rId][j].amount);
543             }
544 
545             if(_playerAmount == 0 || stage[_rId][i].dividendAmount == 0)
546                 continue;
547             _dividend = _dividend.add((_playerAmount.mul(stage[_rId][i].dividendAmount)).div(_totalAmount));
548         }
549 
550         if(round[_rId].ended == true)
551             _dividend = _dividend.add(getPlayerJackpot(_playerAddr, _rId));
552 
553         return _dividend;
554     }
555 
556 
557     /**
558      * Get player data for jackpot winnings.
559      */
560     function getPlayerJackpot(address _playerAddr, uint256 _rId)
561         public
562         view
563         returns(uint256)
564     {
565         uint256 _dividend;
566 
567         if(round[_rId].ended == false)
568             return _dividend;
569 
570         uint256 _endSid = round[_rId].endSid;
571         uint256 _playerStageAmount = playerStageAmount[_rId][_endSid][_playerAddr];
572         uint256 _stageAmount = stage[_rId][_endSid].amount;
573         if(_stageAmount <= 0)
574             return _dividend;
575 
576         uint256 _jackpotAmount = round[_rId].jackpotAmount.mul(jackpotProportion) / 100;
577         uint256 _stageDividendAmount = stage[_rId][_endSid].dividendAmount;
578         uint256 _stageJackpotAmount = (_stageAmount.mul(jackpot) / 100).add(_stageDividendAmount);
579 
580         _dividend = _dividend.add(((_playerStageAmount.mul(_jackpotAmount)).div(_stageAmount)));
581         _dividend = _dividend.add(((_playerStageAmount.mul(_stageJackpotAmount)).div(_stageAmount)));
582 
583         return _dividend;
584     }
585 
586     /**
587      * For frontend.
588      */
589     function getHeadInfo()
590         public
591         view
592         returns(uint256, uint256, uint256, uint256, uint256, uint256, bool)
593     {
594         return
595             (
596                 rId,
597                 sId,
598                 round[rId].jackpotAmount,
599                 stage[rId][sId].targetAmount,
600                 stage[rId][sId].amount,
601                 stage[rId][sId].end,
602                 stage[rId][sId].ended
603             );
604     }
605 
606     /**
607      * For frontend.
608      */
609     function getPersonalStatus(address _playerAddr)
610         public
611         view
612         returns(uint256, uint256, uint256)
613     {
614         if (player[_playerAddr].active == true){
615             return
616             (
617                 round[rId].jackpotAmount,
618                 playerRoundAmount[rId][_playerAddr],
619                 getPlayerDividendByRound(_playerAddr, rId, 1)
620             );
621         }else{
622             return
623             (
624                 round[rId].jackpotAmount,
625                 0,
626                 0
627             );
628         }
629     }
630 
631     /**
632      * For frontend.
633      */
634     function getValueInfo(address _playerAddr)
635         public
636         view
637         returns(uint256, uint256)
638     {
639         if (player[_playerAddr].active == true){
640             return
641             (
642                 getPlayerDividend(_playerAddr),
643                 player[_playerAddr].promotionAmount
644             );
645         }else{
646             return
647             (
648                 0,
649                 0
650             );
651         }
652     }
653 
654 }
655 
656 library Indatasets {
657 
658     struct Round {
659         uint256 start;          // time round started
660         uint256 end;            // time round ends/ended
661         bool ended;             // has round end function been ran
662         uint256 endSid;         // last stage for current round
663         uint256 amount;         // Eth recieved for current round
664         uint256 jackpotAmount;  // total jackpot for current round
665         uint256 players;        // total players for current round
666     }
667 
668     struct Stage {
669         uint256 start;          // time stage started
670         uint256 end;            // time strage ends/ended
671         bool ended;             // has stage end function been ran
672         uint256 targetAmount;   // amount needed for current stage
673         uint256 amount;         // Eth received for current stage
674         uint256 dividendAmount; // total dividend for current stage
675         uint256 accAmount;      // total accumulative amount for current stage
676         uint256 players;        // total players for current stage
677     }
678 
679     struct Player {
680         bool active;                // Activation status of player, if false player has not been activated.
681         uint256 amount;             // Total player input.
682         uint256 promotionAmount;    // Total promotion amount of the player.
683         uint256 withdrawRid;        // Last withdraw round of the player.
684         uint256 withdrawSid;        // Last withdraw stage of the player.
685     }
686 }
687 
688 /**
689  * @title SafeMath v0.1.9
690  * @dev Math operations with safety checks that throw on error
691  */
692 library SafeMath {
693 
694     /**
695     * @dev Adds two numbers, throws on overflow.
696     */
697     function add(uint256 a, uint256 b)
698         internal
699         pure
700         returns (uint256)
701     {
702         uint256 c = a + b;
703         assert(c >= a);
704         return c;
705     }
706 
707     /**
708     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
709     */
710     function sub(uint256 a, uint256 b)
711         internal
712         pure
713         returns (uint256)
714     {
715         assert(b <= a);
716         return a - b;
717     }
718 
719     /**
720     * @dev Multiplies two numbers, throws on overflow.
721     */
722     function mul(uint256 a, uint256 b)
723         internal
724         pure
725         returns (uint256)
726     {
727         if (a == 0) {
728             return 0;
729         }
730         uint256 c = a * b;
731         assert(c / a == b);
732         return c;
733     }
734 
735     /**
736     * @dev Integer division of two numbers, truncating the quotient.
737     */
738     function div(uint256 a, uint256 b)
739         internal
740         pure
741         returns (uint256)
742     {
743         assert(b > 0); // Solidity automatically throws when dividing by 0
744         uint256 c = a / b;
745         assert(a == b * c + a % b); // There is no case in which this doesn't hold
746         return c;
747     }
748 
749     /**
750      * @dev gives square root of given x.
751      */
752     function sqrt(uint256 x)
753         internal
754         pure
755         returns (uint256 y)
756     {
757         uint256 z = ((add(x,1)) / 2);
758         y = x;
759         while (z < y)
760         {
761             y = z;
762             z = ((add((x / z),z)) / 2);
763         }
764     }
765 
766     /**
767      * @dev gives square. multiplies x by x
768      */
769     function sq(uint256 x)
770         internal
771         pure
772         returns (uint256)
773     {
774         return (mul(x,x));
775     }
776 
777     /**
778      * @dev x to the power of y
779      */
780     function pwr(uint256 x, uint256 y)
781         internal
782         pure
783         returns (uint256)
784     {
785         if (x==0)
786             return (0);
787         else if (y==0)
788             return (1);
789         else
790         {
791             uint256 z = x;
792             for (uint256 i=1; i < y; i++)
793                 z = mul(z,x);
794             return (z);
795         }
796     }
797 }