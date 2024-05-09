1 pragma solidity ^0.4.24;
2 
3 contract Xplan {
4     using SafeMath for uint256;
5 
6     /*------------------------------
7                 CONFIGURABLES
8      ------------------------------*/
9     string public name = "Xplan";    // Contract name
10     string public symbol = "Xplan";
11 
12     uint256 public initAmount;          // Initial stage target
13     uint256 public amountProportion;    // Stage target growth rate %
14     uint256 public dividend;            // Input to Dividend %
15     uint256 public jackpot;             // Input to Jackpot %
16     uint256 public jackpotProportion;   // Jackpot payout %
17     uint256 public scientists;          // Donation Fee % to scientists
18     uint256 public promotionRatio;      // Promotion %
19     uint256 public duration;            // Duration per stage
20     bool public activated = false;
21 
22     address public developerAddr;
23 
24     /*------------------------------
25                 DATASETS
26      ------------------------------*/
27     uint256 public rId;   // Current round id number
28     uint256 public sId;   // Current stage id number
29 
30     mapping (uint256 => Indatasets.Round) public round; // (rId => data) round data by round id
31     mapping (uint256 => mapping (uint256 => Indatasets.Stage)) public stage;    // (rId => sId => data) stage data by round id & stage id
32     mapping (address => Indatasets.Player) public player;   // (address => data) player data
33     mapping (uint256 => mapping (address => uint256)) public playerRoundAmount; // (rId => address => playerRoundAmount) round data by round id
34     mapping (uint256 => mapping (address => uint256)) public playerRoundSid;
35     mapping (uint256 => mapping (address => uint256)) public playerRoundwithdrawAmountFlag;
36     mapping (uint256 => mapping (uint256 => mapping (address => uint256))) public playerStageAmount;    // (rId => sId => address => playerStageAmount) round data by round id & stage id
37     mapping (uint256 => mapping (uint256 => mapping (address => uint256))) public playerStageAccAmount;
38 
39     //Antiwhale setting, max 5% of stage target for the first 10 stages per address
40     uint256[] amountLimit = [0, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50];
41 
42     /*------------------------------
43                 PUBLIC FUNCTIONS
44     ------------------------------*/
45 
46     constructor()
47     public
48     {
49         developerAddr = msg.sender;
50     }
51 
52     /*------------------------------
53                 MODIFIERS
54      ------------------------------*/
55 
56     modifier isActivated() {
57         require(activated == true, "its not ready yet.  check ?eta in discord");
58         _;
59     }
60 
61     modifier senderVerify() {
62         require (msg.sender == tx.origin);
63         _;
64     }
65 
66     modifier stageVerify(uint256 _rId, uint256 _sId, uint256 _amount) {
67         require(stage[_rId][_sId].amount.add(_amount) <= stage[_rId][_sId].targetAmount);
68         _;
69     }
70 
71     /**
72      * Don't toy or spam the contract.
73      * The scientists will take anything below 0.0001 ETH sent to the contract.
74      * Thank you for your donation.
75      */
76     modifier amountVerify() {
77         if(msg.value < 100000000000000){
78             developerAddr.transfer(msg.value);
79         }else{
80             require(msg.value >= 100000000000000);
81             _;
82         }
83     }
84 
85     modifier playerVerify() {
86         require(player[msg.sender].active == true);
87         _;
88     }
89 
90     /**
91      * Activation of contract with settings
92      */
93     function activate()
94     public
95     {
96         require(msg.sender == developerAddr);
97         require(activated == false, "Infinity already activated");
98 
99         activated = true;
100         initAmount = 10000000000000000000;
101         amountProportion = 10;
102         dividend = 70;
103         jackpot = 28;
104         jackpotProportion = 70;
105         scientists = 2;
106         promotionRatio = 10;
107         duration = 86400;
108         rId = 1;
109         sId = 1;
110 
111         round[rId].start = now;
112         initStage(rId, sId);
113 
114     }
115 
116     /**
117      * Fallback function to handle ethereum that was send straight to the contract
118      * Unfortunately we cannot use a referral address this way.
119      */
120     function()
121     isActivated()
122     senderVerify()
123     amountVerify()
124     payable
125     public
126     {
127         buyAnalysis(0x0);
128     }
129 
130     /**
131      * Standard buy function.
132      */
133     function buy(address _recommendAddr)
134     isActivated()
135     senderVerify()
136     amountVerify()
137     public
138     payable
139     returns(uint256)
140     {
141         buyAnalysis(_recommendAddr);
142     }
143 
144     /**
145      * Withdraw function.
146      * Withdraw 50 stages at once on current settings.
147      * May require to request withdraw more than once to withdraw everything.
148      */
149     function withdraw()
150     isActivated()
151     senderVerify()
152     playerVerify()
153     public
154     {
155         uint256 _rId = rId;
156         uint256 _sId = sId;
157         uint256 _amount;
158         uint256 _playerWithdrawAmountFlag;
159 
160         (_amount, player[msg.sender].withdrawRid, player[msg.sender].withdrawSid, _playerWithdrawAmountFlag) = getPlayerDividendByStage(_rId, _sId, msg.sender);
161 
162         if(_playerWithdrawAmountFlag > 0)
163             playerRoundwithdrawAmountFlag[player[msg.sender].withdrawRid][msg.sender] = _playerWithdrawAmountFlag;
164 
165         if(player[msg.sender].promotionAmount > 0 ){
166             _amount = _amount.add(player[msg.sender].promotionAmount);
167             player[msg.sender].promotionAmount = 0;
168         }
169         msg.sender.transfer(_amount);
170     }
171 
172 
173     /**
174      * Core logic to analyse buy behaviour.
175      */
176     function buyAnalysis(address _recommendAddr)
177     private
178     {
179         uint256 _rId = rId;
180         uint256 _sId = sId;
181         uint256 _amount = msg.value;
182         uint256 _promotionRatio = promotionRatio;
183 
184         if(now > stage[_rId][_sId].end && stage[_rId][_sId].targetAmount > stage[_rId][_sId].amount){
185 
186             endRound(_rId, _sId);
187 
188             _rId = rId;
189             _sId = sId;
190             round[_rId].start = now;
191             initStage(_rId, _sId);
192 
193             _amount = limitAmount(_rId, _sId);
194             buyRoundDataRecord(_rId, _amount);
195             _promotionRatio = promotionDataRecord(_recommendAddr, _amount);
196             buyStageDataRecord(_rId, _sId, _promotionRatio, _amount);
197             buyPlayerDataRecord(_rId, _sId, _amount);
198 
199         }else if(now <= stage[_rId][_sId].end){
200 
201             _amount = limitAmount(_rId, _sId);
202             buyRoundDataRecord(_rId, _amount);
203             _promotionRatio = promotionDataRecord(_recommendAddr, _amount);
204 
205             if(stage[_rId][_sId].amount.add(_amount) >= stage[_rId][_sId].targetAmount){
206 
207                 uint256 differenceAmount = (stage[_rId][_sId].targetAmount).sub(stage[_rId][_sId].amount);
208                 buyStageDataRecord(_rId, _sId, _promotionRatio, differenceAmount);
209                 buyPlayerDataRecord(_rId, _sId, differenceAmount);
210 
211                 endStage(_rId, _sId);
212 
213                 _sId = sId;
214                 initStage(_rId, _sId);
215                 round[_rId].endSid = _sId;
216                 buyStageDataRecord(_rId, _sId, _promotionRatio, _amount.sub(differenceAmount));
217                 buyPlayerDataRecord(_rId, _sId, _amount.sub(differenceAmount));
218 
219             }else{
220                 buyStageDataRecord(_rId, _sId, _promotionRatio, _amount);
221                 buyPlayerDataRecord(_rId, _sId, _amount);
222 
223             }
224         }
225     }
226 
227 
228     /**
229      * Sets the initial stage parameter.
230      */
231     function initStage(uint256 _rId, uint256 _sId)
232     private
233     {
234         uint256 _targetAmount;
235         stage[_rId][_sId].start = now;
236         stage[_rId][_sId].end = now.add(duration);
237         if(_sId > 1){
238             stage[_rId][_sId - 1].end = now;
239             stage[_rId][_sId - 1].ended = true;
240             _targetAmount = (stage[_rId][_sId - 1].targetAmount.mul(amountProportion + 100)) / 100;
241         }else
242             _targetAmount = initAmount;
243 
244         stage[_rId][_sId].targetAmount = _targetAmount;
245 
246     }
247 
248     /**
249      * Execution of antiwhale.
250      */
251     function limitAmount(uint256 _rId, uint256 _sId)
252     private
253     returns(uint256)
254     {
255         uint256 _amount = msg.value;
256 
257         if(amountLimit.length > _sId)
258             _amount = ((stage[_rId][_sId].targetAmount.mul(amountLimit[_sId])) / 1000).sub(playerStageAmount[_rId][_sId][msg.sender]);
259         else
260             _amount = ((stage[_rId][_sId].targetAmount.mul(500)) / 1000).sub(playerStageAmount[_rId][_sId][msg.sender]);
261 
262         if(_amount >= msg.value)
263             return msg.value;
264         else
265             msg.sender.transfer(msg.value.sub(_amount));
266 
267         return _amount;
268     }
269 
270     /**
271      * Record the addresses eligible for promotion links.
272      */
273     function promotionDataRecord(address _recommendAddr, uint256 _amount)
274     private
275     returns(uint256)
276     {
277         uint256 _promotionRatio = promotionRatio;
278 
279         if(_recommendAddr != 0x0000000000000000000000000000000000000000
280         && _recommendAddr != msg.sender
281         && player[_recommendAddr].active == true
282         )
283             player[_recommendAddr].promotionAmount = player[_recommendAddr].promotionAmount.add((_amount.mul(_promotionRatio)) / 100);
284         else
285             _promotionRatio = 0;
286 
287         return _promotionRatio;
288     }
289 
290 
291     /**
292      * Records the round data.
293      */
294     function buyRoundDataRecord(uint256 _rId, uint256 _amount)
295     private
296     {
297 
298         round[_rId].amount = round[_rId].amount.add(_amount);
299         developerAddr.transfer(_amount.mul(scientists) / 100);
300     }
301 
302     /**
303      * Records the stage data.
304      */
305     function buyStageDataRecord(uint256 _rId, uint256 _sId, uint256 _promotionRatio, uint256 _amount)
306     stageVerify(_rId, _sId, _amount)
307     private
308     {
309         if(_amount <= 0)
310             return;
311         stage[_rId][_sId].amount = stage[_rId][_sId].amount.add(_amount);
312         stage[_rId][_sId].dividendAmount = stage[_rId][_sId].dividendAmount.add((_amount.mul(dividend.sub(_promotionRatio))) / 100);
313     }
314 
315     /**
316      * Records the player data.
317      */
318     function buyPlayerDataRecord(uint256 _rId, uint256 _sId, uint256 _amount)
319     private
320     {
321         if(_amount <= 0)
322             return;
323 
324         if(player[msg.sender].active == false){
325             player[msg.sender].active = true;
326             player[msg.sender].withdrawRid = _rId;
327             player[msg.sender].withdrawSid = _sId;
328         }
329 
330         if(playerRoundAmount[_rId][msg.sender] == 0){
331             round[_rId].players++;
332             playerRoundSid[_rId][msg.sender] = _sId;
333         }
334 
335         if(playerStageAmount[_rId][_sId][msg.sender] == 0)
336             stage[_rId][_sId].players++;
337 
338         playerRoundAmount[_rId][msg.sender] = playerRoundAmount[_rId][msg.sender].add(_amount);
339         playerStageAmount[_rId][_sId][msg.sender] = playerStageAmount[_rId][_sId][msg.sender].add(_amount);
340 
341         player[msg.sender].amount = player[msg.sender].amount.add(_amount);
342 
343         if(playerRoundSid[_rId][msg.sender] > 0){
344 
345             if(playerStageAccAmount[_rId][_sId][msg.sender] == 0){
346 
347                 for(uint256 i = playerRoundSid[_rId][msg.sender]; i < _sId; i++){
348 
349                     if(playerStageAmount[_rId][i][msg.sender] > 0)
350                         playerStageAccAmount[_rId][_sId][msg.sender] = playerStageAccAmount[_rId][_sId][msg.sender].add(playerStageAmount[_rId][i][msg.sender]);
351 
352                 }
353             }
354 
355             playerStageAccAmount[_rId][_sId][msg.sender] = playerStageAccAmount[_rId][_sId][msg.sender].add(_amount);
356         }
357     }
358 
359     /**
360      * Execute end of round events.
361      */
362     function endRound(uint256 _rId, uint256 _sId)
363     private
364     {
365         round[_rId].end = now;
366         round[_rId].ended = true;
367         round[_rId].endSid = _sId;
368         stage[_rId][_sId].end = now;
369         stage[_rId][_sId].ended = true;
370 
371         if(stage[_rId][_sId].players == 0)
372             round[_rId + 1].jackpotAmount = round[_rId + 1].jackpotAmount.add(round[_rId].jackpotAmount);
373         else
374             round[_rId + 1].jackpotAmount = round[_rId + 1].jackpotAmount.add(round[_rId].jackpotAmount.mul(100 - jackpotProportion) / 100);
375 
376         rId++;
377         sId = 1;
378 
379     }
380 
381     /**
382      * Execute end of stage events.
383      */
384     function endStage(uint256 _rId, uint256 _sId)
385     private
386     {
387         uint256 _jackpotAmount = stage[_rId][_sId].amount.mul(jackpot) / 100;
388         round[_rId].endSid = _sId;
389         round[_rId].jackpotAmount = round[_rId].jackpotAmount.add(_jackpotAmount);
390         stage[_rId][_sId].end = now;
391         stage[_rId][_sId].ended = true;
392         if(_sId > 1)
393             stage[_rId][_sId].accAmount = stage[_rId][_sId].targetAmount.add(stage[_rId][_sId - 1].accAmount);
394         else
395             stage[_rId][_sId].accAmount = stage[_rId][_sId].targetAmount;
396 
397         sId++;
398     }
399 
400     /**
401      * Precalculations for withdraws to conserve gas.
402      */
403     function getPlayerDividendByStage(uint256 _rId, uint256 _sId, address _playerAddr)
404     private
405     view
406     returns(uint256, uint256, uint256, uint256)
407     {
408 
409         uint256 _dividend;
410         uint256 _stageNumber;
411         uint256 _startSid;
412         uint256 _playerAmount;
413 
414         for(uint256 i = player[_playerAddr].withdrawRid; i <= _rId; i++){
415 
416             if(playerRoundAmount[i][_playerAddr] == 0)
417                 continue;
418 
419             _playerAmount = 0;
420             _startSid = i == player[_playerAddr].withdrawRid ? player[_playerAddr].withdrawSid : 1;
421             for(uint256 j = _startSid; j < round[i].endSid; j++){
422 
423                 if(playerStageAccAmount[i][j][_playerAddr] > 0)
424                     _playerAmount = playerStageAccAmount[i][j][_playerAddr];
425 
426                 if(_playerAmount == 0)
427                     _playerAmount = playerRoundwithdrawAmountFlag[i][_playerAddr];
428 
429                 if(_playerAmount == 0)
430                     continue;
431                 _dividend = _dividend.add(
432                     (
433                     _playerAmount.mul(stage[i][j].dividendAmount)
434                     ).div(stage[i][j].accAmount)
435                 );
436 
437                 _stageNumber++;
438                 if(_stageNumber >= 50)
439                     return (_dividend, i, j + 1, _playerAmount);
440             }
441 
442             if(round[i].ended == true
443             && stage[i][round[i].endSid].amount > 0
444             && playerStageAmount[i][round[i].endSid][_playerAddr] > 0
445             ){
446                 _dividend = _dividend.add(getPlayerJackpot(_playerAddr, i));
447                 _stageNumber++;
448                 if(_stageNumber >= 50)
449                     return (_dividend, i + 1, 1, 0);
450             }
451         }
452         return (_dividend, _rId, _sId, _playerAmount);
453     }
454 
455     /**
456      * Get player current withdrawable dividend.
457      */
458     function getPlayerDividend(address _playerAddr)
459     public
460     view
461     returns(uint256)
462     {
463         uint256 _endRid = rId;
464         uint256 _startRid = player[_playerAddr].withdrawRid;
465         uint256 _startSid;
466         uint256 _dividend;
467 
468         for(uint256 i = _startRid; i <= _endRid; i++){
469 
470             if(i == _startRid)
471                 _startSid = player[_playerAddr].withdrawSid;
472             else
473                 _startSid = 1;
474             _dividend = _dividend.add(getPlayerDividendByRound(_playerAddr, i, _startSid));
475         }
476 
477         return _dividend;
478     }
479 
480     /**
481      * Get player data for rounds and stages.
482      */
483     function getPlayerDividendByRound(address _playerAddr, uint256 _rId, uint256 _sId)
484     public
485     view
486     returns(uint256)
487     {
488         uint256 _dividend;
489         uint256 _startSid = _sId;
490         uint256 _endSid = round[_rId].endSid;
491 
492         uint256 _playerAmount;
493         uint256 _totalAmount;
494         for(uint256 i = _startSid; i < _endSid; i++){
495 
496             if(stage[_rId][i].ended == false)
497                 continue;
498 
499             _playerAmount = 0;
500             _totalAmount = 0;
501             for(uint256 j = 1; j <= i; j++){
502 
503                 if(playerStageAmount[_rId][j][_playerAddr] > 0)
504                     _playerAmount = _playerAmount.add(playerStageAmount[_rId][j][_playerAddr]);
505 
506                 _totalAmount = _totalAmount.add(stage[_rId][j].amount);
507             }
508 
509             if(_playerAmount == 0 || stage[_rId][i].dividendAmount == 0)
510                 continue;
511             _dividend = _dividend.add((_playerAmount.mul(stage[_rId][i].dividendAmount)).div(_totalAmount));
512         }
513 
514         if(round[_rId].ended == true)
515             _dividend = _dividend.add(getPlayerJackpot(_playerAddr, _rId));
516 
517         return _dividend;
518     }
519 
520 
521     /**
522      * Get player data for jackpot winnings.
523      */
524     function getPlayerJackpot(address _playerAddr, uint256 _rId)
525     public
526     view
527     returns(uint256)
528     {
529         uint256 _dividend;
530 
531         if(round[_rId].ended == false)
532             return _dividend;
533 
534         uint256 _endSid = round[_rId].endSid;
535         uint256 _playerStageAmount = playerStageAmount[_rId][_endSid][_playerAddr];
536         uint256 _stageAmount = stage[_rId][_endSid].amount;
537         if(_stageAmount <= 0)
538             return _dividend;
539 
540         uint256 _jackpotAmount = round[_rId].jackpotAmount.mul(jackpotProportion) / 100;
541         uint256 _stageDividendAmount = stage[_rId][_endSid].dividendAmount;
542         uint256 _stageJackpotAmount = (_stageAmount.mul(jackpot) / 100).add(_stageDividendAmount);
543 
544         _dividend = _dividend.add(((_playerStageAmount.mul(_jackpotAmount)).div(_stageAmount)));
545         _dividend = _dividend.add(((_playerStageAmount.mul(_stageJackpotAmount)).div(_stageAmount)));
546 
547         return _dividend;
548     }
549 
550     /**
551      * For frontend.
552      */
553     function getHeadInfo()
554     public
555     view
556     returns(uint256, uint256, uint256, uint256, uint256, uint256, bool)
557     {
558         return
559         (
560         rId,
561         sId,
562         round[rId].jackpotAmount,
563         stage[rId][sId].targetAmount,
564         stage[rId][sId].amount,
565         stage[rId][sId].end,
566         stage[rId][sId].ended
567         );
568     }
569 
570     /**
571      * For frontend.
572      */
573     function getPersonalStatus(address _playerAddr)
574     public
575     view
576     returns(uint256, uint256, uint256)
577     {
578         if (player[_playerAddr].active == true){
579             return
580             (
581             round[rId].jackpotAmount,
582             playerRoundAmount[rId][_playerAddr],
583             getPlayerDividendByRound(_playerAddr, rId, 1)
584             );
585         }else{
586             return
587             (
588             round[rId].jackpotAmount,
589             0,
590             0
591             );
592         }
593     }
594 
595     /**
596      * For frontend.
597      */
598     function getValueInfo(address _playerAddr)
599     public
600     view
601     returns(uint256, uint256)
602     {
603         if (player[_playerAddr].active == true){
604             return
605             (
606             getPlayerDividend(_playerAddr),
607             player[_playerAddr].promotionAmount
608             );
609         }else{
610             return
611             (
612             0,
613             0
614             );
615         }
616     }
617 
618 }
619 
620 library Indatasets {
621 
622     struct Round {
623         uint256 start;          // time round started
624         uint256 end;            // time round ends/ended
625         bool ended;             // has round end function been ran
626         uint256 endSid;         // last stage for current round
627         uint256 amount;         // Eth recieved for current round
628         uint256 jackpotAmount;  // total jackpot for current round
629         uint256 players;        // total players for current round
630     }
631 
632     struct Stage {
633         uint256 start;          // time stage started
634         uint256 end;            // time strage ends/ended
635         bool ended;             // has stage end function been ran
636         uint256 targetAmount;   // amount needed for current stage
637         uint256 amount;         // Eth received for current stage
638         uint256 dividendAmount; // total dividend for current stage
639         uint256 accAmount;      // total accumulative amount for current stage
640         uint256 players;        // total players for current stage
641     }
642 
643     struct Player {
644         bool active;                // Activation status of player, if false player has not been activated.
645         uint256 amount;             // Total player input.
646         uint256 promotionAmount;    // Total promotion amount of the player.
647         uint256 withdrawRid;        // Last withdraw round of the player.
648         uint256 withdrawSid;        // Last withdraw stage of the player.
649     }
650 }
651 
652 /**
653  * @title SafeMath v0.1.9
654  * @dev Math operations with safety checks that throw on error
655  */
656 library SafeMath {
657 
658     /**
659     * @dev Adds two numbers, throws on overflow.
660     */
661     function add(uint256 a, uint256 b)
662     internal
663     pure
664     returns (uint256)
665     {
666         uint256 c = a + b;
667         assert(c >= a);
668         return c;
669     }
670 
671     /**
672     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
673     */
674     function sub(uint256 a, uint256 b)
675     internal
676     pure
677     returns (uint256)
678     {
679         assert(b <= a);
680         return a - b;
681     }
682 
683     /**
684     * @dev Multiplies two numbers, throws on overflow.
685     */
686     function mul(uint256 a, uint256 b)
687     internal
688     pure
689     returns (uint256)
690     {
691         if (a == 0) {
692             return 0;
693         }
694         uint256 c = a * b;
695         assert(c / a == b);
696         return c;
697     }
698 
699     /**
700     * @dev Integer division of two numbers, truncating the quotient.
701     */
702     function div(uint256 a, uint256 b)
703     internal
704     pure
705     returns (uint256)
706     {
707         assert(b > 0); // Solidity automatically throws when dividing by 0
708         uint256 c = a / b;
709         assert(a == b * c + a % b); // There is no case in which this doesn't hold
710         return c;
711     }
712 
713     /**
714      * @dev gives square root of given x.
715      */
716     function sqrt(uint256 x)
717     internal
718     pure
719     returns (uint256 y)
720     {
721         uint256 z = ((add(x,1)) / 2);
722         y = x;
723         while (z < y)
724         {
725             y = z;
726             z = ((add((x / z),z)) / 2);
727         }
728     }
729 
730     /**
731      * @dev gives square. multiplies x by x
732      */
733     function sq(uint256 x)
734     internal
735     pure
736     returns (uint256)
737     {
738         return (mul(x,x));
739     }
740 
741     /**
742      * @dev x to the power of y
743      */
744     function pwr(uint256 x, uint256 y)
745     internal
746     pure
747     returns (uint256)
748     {
749         if (x==0)
750             return (0);
751         else if (y==0)
752             return (1);
753         else
754         {
755             uint256 z = x;
756             for (uint256 i=1; i < y; i++)
757                 z = mul(z,x);
758             return (z);
759         }
760     }
761 }