1 pragma solidity ^0.4.24;
2 
3 /**
4  *
5  *
6  *  http://fairdapp.com     http://fairdapp.com     http://fairdapp.com
7  *   
8  *                       _______     _       ______  _______ ______ ______  
9  *                      (_______)   (_)     (______)(_______|_____ (_____ \ 
10  *                       _____ _____ _  ____ _     _ _______ _____) )____) )
11  *                      |  ___|____ | |/ ___) |   | |  ___  |  ____/  ____/ 
12  *                      | |   / ___ | | |   | |__/ /| |   | | |    | |      
13  *                      |_|   \_____|_|_|   |_____/ |_|   |_|_|    |_|      
14  *                                                                    
15  *                               _         ___ _       _             
16  *                              | |       / __|_)     (_)  _         
17  *                              | |____ _| |__ _ ____  _ _| |_ _   _ 
18  *                              | |  _ (_   __) |  _ \| (_   _) | | |
19  *                              | | | | || |  | | | | | | | |_| |_| |
20  *                              |_|_| |_||_|  |_|_| |_|_|  \__)\__  |
21  *                                                            (____/                                                                  
22  *   
23  *  Warning:
24  *     
25  *  FairDAPP – Infinity is a system designed to explore human behavior
26  *  using infinite loops of token redistribution through open source 
27  *  smart contract codes and pre-defined rules.
28  *   
29  *  This system is for internal use only and all could be lost
30  *  by sending anything to this contract address.
31  *   
32  *  -The contract has an activation switch to activate the system.
33  *  -No one can change anything once the contract has been deployed.
34  *   
35  *  -Built in Antiwhale for initial stages for a fairer system.
36  *
37 **/
38 
39 
40 contract Infinity {
41     using SafeMath for uint256;
42     
43     /*------------------------------
44                 CONFIGURABLES
45      ------------------------------*/
46     string public name = "Infinity";    // Contract name
47     string public symbol = "Inf";
48     
49     uint256 public initAmount;          // Initial stage target
50     uint256 public amountProportion;    // Stage target growth rate %
51     uint256 public dividend;            // Input to Dividend %
52     uint256 public jackpot;             // Input to Jackpot %
53     uint256 public jackpotProportion;   // Jackpot payout %
54     uint256 public scientists;          // Donation Fee % to scientists
55     uint256 public promotionRatio;      // Promotion %
56     uint256 public duration;            // Duration per stage
57     bool public activated = false;
58     
59     address public developerAddr;
60     
61     /*------------------------------
62                 DATASETS
63      ------------------------------*/
64     uint256 public rId;   // Current round id number
65     uint256 public sId;   // Current stage id number
66     
67     mapping (uint256 => Indatasets.Round) public round; // (rId => data) round data by round id
68     mapping (uint256 => mapping (uint256 => Indatasets.Stage)) public stage;    // (rId => sId => data) stage data by round id & stage id
69     mapping (address => Indatasets.Player) public player;   // (address => data) player data
70     mapping (uint256 => mapping (address => uint256)) public playerRoundAmount; // (rId => address => playerRoundAmount) round data by round id
71     mapping (uint256 => mapping (address => uint256)) public playerRoundSid; 
72     mapping (uint256 => mapping (address => uint256)) public playerRoundwithdrawAmountFlag; 
73     mapping (uint256 => mapping (uint256 => mapping (address => uint256))) public playerStageAmount;    // (rId => sId => address => playerStageAmount) round data by round id & stage id
74     mapping (uint256 => mapping (uint256 => mapping (address => uint256))) public playerStageAccAmount;  
75     
76     //Antiwhale setting, max 5% of stage target for the first 10 stages per address
77     uint256[] amountLimit = [0, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50];
78 
79     /*------------------------------
80                 PUBLIC FUNCTIONS
81     ------------------------------*/
82     
83     constructor()
84         public
85     {
86         developerAddr = msg.sender;
87     }
88     
89     /*------------------------------
90                 MODIFIERS
91      ------------------------------*/
92      
93     modifier isActivated() {
94         require(activated == true, "its not ready yet.  check ?eta in discord"); 
95         _;
96     }
97     
98     modifier senderVerify() {
99         require (msg.sender == tx.origin);
100         _;
101     }
102     
103     modifier stageVerify(uint256 _rId, uint256 _sId, uint256 _amount) {
104         require(stage[_rId][_sId].amount.add(_amount) <= stage[_rId][_sId].targetAmount);
105         _;
106     }
107     
108     /**
109      * Don't toy or spam the contract.
110      * The scientists will take anything below 0.0001 ETH sent to the contract.
111      * Thank you for your donation.
112      */
113     modifier amountVerify() {
114         if(msg.value < 100000000000000){
115             developerAddr.transfer(msg.value);
116         }else{
117             require(msg.value >= 100000000000000);
118             _;
119         }
120     }
121     
122     modifier playerVerify() {
123         require(player[msg.sender].active == true);
124         _;
125     }
126     
127     /**
128      * Activation of contract with settings
129      */
130     function activate()
131         public
132     {
133         require(msg.sender == developerAddr);
134         require(activated == false, "Infinity already activated");
135         
136         activated = true;
137         initAmount = 10000000000000000000;
138         amountProportion = 10;
139         dividend = 70;
140         jackpot = 28;  
141         jackpotProportion = 70;  
142         scientists = 2;
143         promotionRatio = 10;
144         duration = 86400;
145         rId = 1;
146         sId = 1;
147         
148         round[rId].start = now;
149         initStage(rId, sId);
150     
151     }
152     
153     /**
154      * Fallback function to handle ethereum that was send straight to the contract
155      * Unfortunately we cannot use a referral address this way.
156      */
157     function()
158         isActivated()
159         senderVerify()
160         amountVerify()
161         payable
162         public
163     {
164         buyAnalysis(0x0);
165     }
166 
167     /**
168      * Standard buy function.
169      */
170     function buy(address _recommendAddr)
171         isActivated()
172         senderVerify()
173         amountVerify()
174         public
175         payable
176         returns(uint256)
177     {
178         buyAnalysis(_recommendAddr);
179     }
180     
181     /**
182      * Withdraw function.
183      * Withdraw 50 stages at once on current settings.
184      * May require to request withdraw more than once to withdraw everything.
185      */
186     function withdraw()
187         isActivated()
188         senderVerify()
189         playerVerify()
190         public
191     {
192         uint256 _rId = rId;
193         uint256 _sId = sId;
194         uint256 _amount;
195         uint256 _playerWithdrawAmountFlag;
196         
197         (_amount, player[msg.sender].withdrawRid, player[msg.sender].withdrawSid, _playerWithdrawAmountFlag) = getPlayerDividendByStage(_rId, _sId, msg.sender);
198 
199         if(_playerWithdrawAmountFlag > 0)
200             playerRoundwithdrawAmountFlag[player[msg.sender].withdrawRid][msg.sender] = _playerWithdrawAmountFlag;
201         
202         if(player[msg.sender].promotionAmount > 0 ){
203             _amount = _amount.add(player[msg.sender].promotionAmount);
204             player[msg.sender].promotionAmount = 0;
205         }    
206         msg.sender.transfer(_amount);
207     }
208 
209     
210     /**
211      * Core logic to analyse buy behaviour. 
212      */
213     function buyAnalysis(address _recommendAddr)
214         private
215     {
216         uint256 _rId = rId;
217         uint256 _sId = sId;
218         uint256 _amount = msg.value;
219         uint256 _promotionRatio = promotionRatio;
220         
221         if(now > stage[_rId][_sId].end && stage[_rId][_sId].targetAmount > stage[_rId][_sId].amount){
222             
223             endRound(_rId, _sId);
224             
225             _rId = rId;
226             _sId = sId;
227             round[_rId].start = now;
228             initStage(_rId, _sId);
229             
230             _amount = limitAmount(_rId, _sId);
231             buyRoundDataRecord(_rId, _amount);
232             _promotionRatio = promotionDataRecord(_recommendAddr, _amount);
233             buyStageDataRecord(_rId, _sId, _promotionRatio, _amount);
234             buyPlayerDataRecord(_rId, _sId, _amount);
235             
236         }else if(now <= stage[_rId][_sId].end){
237             
238             _amount = limitAmount(_rId, _sId);
239             buyRoundDataRecord(_rId, _amount);
240             _promotionRatio = promotionDataRecord(_recommendAddr, _amount);
241             
242             if(stage[_rId][_sId].amount.add(_amount) >= stage[_rId][_sId].targetAmount){
243                 
244                 uint256 differenceAmount = (stage[_rId][_sId].targetAmount).sub(stage[_rId][_sId].amount);
245                 buyStageDataRecord(_rId, _sId, _promotionRatio, differenceAmount);
246                 buyPlayerDataRecord(_rId, _sId, differenceAmount);
247                 
248                 endStage(_rId, _sId);
249 
250                 _sId = sId;
251                 initStage(_rId, _sId);
252                 round[_rId].endSid = _sId;
253                 buyStageDataRecord(_rId, _sId, _promotionRatio, _amount.sub(differenceAmount));
254                 buyPlayerDataRecord(_rId, _sId, _amount.sub(differenceAmount));
255                 
256             }else{
257                 buyStageDataRecord(_rId, _sId, _promotionRatio, _amount);
258                 buyPlayerDataRecord(_rId, _sId, _amount);
259                 
260             }
261         }
262     }
263     
264     
265     /**
266      * Sets the initial stage parameter. 
267      */
268     function initStage(uint256 _rId, uint256 _sId)
269         private
270     {
271         uint256 _targetAmount;
272         stage[_rId][_sId].start = now;
273         stage[_rId][_sId].end = now.add(duration);
274         if(_sId > 1){
275             stage[_rId][_sId - 1].end = now;
276             stage[_rId][_sId - 1].ended = true;
277             _targetAmount = (stage[_rId][_sId - 1].targetAmount.mul(amountProportion + 100)) / 100;
278         }else
279             _targetAmount = initAmount;
280             
281         stage[_rId][_sId].targetAmount = _targetAmount;
282         
283     }
284     
285     /**
286      * Execution of antiwhale. 
287      */
288     function limitAmount(uint256 _rId, uint256 _sId)
289         private
290         returns(uint256)
291     {
292         uint256 _amount = msg.value;
293         
294         if(amountLimit.length > _sId)
295             _amount = ((stage[_rId][_sId].targetAmount.mul(amountLimit[_sId])) / 1000).sub(playerStageAmount[_rId][_sId][msg.sender]);
296         else
297             _amount = ((stage[_rId][_sId].targetAmount.mul(500)) / 1000).sub(playerStageAmount[_rId][_sId][msg.sender]);
298             
299         if(_amount >= msg.value)
300             return msg.value;
301         else
302             msg.sender.transfer(msg.value.sub(_amount));
303         
304         return _amount;
305     }
306     
307     /**
308      * Record the addresses eligible for promotion links.
309      */
310     function promotionDataRecord(address _recommendAddr, uint256 _amount)
311         private
312         returns(uint256)
313     {
314         uint256 _promotionRatio = promotionRatio;
315         
316         if(_recommendAddr != 0x0000000000000000000000000000000000000000 
317             && _recommendAddr != msg.sender 
318             && player[_recommendAddr].active == true
319         )
320             player[_recommendAddr].promotionAmount = player[_recommendAddr].promotionAmount.add((_amount.mul(_promotionRatio)) / 100);
321         else
322             _promotionRatio = 0;
323         
324         return _promotionRatio;
325     }
326     
327     
328     /**
329      * Records the round data.
330      */
331     function buyRoundDataRecord(uint256 _rId, uint256 _amount)
332         private
333     {
334 
335         round[_rId].amount = round[_rId].amount.add(_amount);
336         developerAddr.transfer(_amount.mul(scientists) / 100);
337     }
338     
339     /**
340      * Records the stage data.
341      */
342     function buyStageDataRecord(uint256 _rId, uint256 _sId, uint256 _promotionRatio, uint256 _amount)
343         stageVerify(_rId, _sId, _amount)
344         private
345     {
346         if(_amount <= 0)
347             return;
348         stage[_rId][_sId].amount = stage[_rId][_sId].amount.add(_amount);
349         stage[_rId][_sId].dividendAmount = stage[_rId][_sId].dividendAmount.add((_amount.mul(dividend.sub(_promotionRatio))) / 100);
350     }
351     
352     /**
353      * Records the player data.
354      */
355     function buyPlayerDataRecord(uint256 _rId, uint256 _sId, uint256 _amount)
356         private
357     {
358         if(_amount <= 0)
359             return;
360             
361         if(player[msg.sender].active == false){
362             player[msg.sender].active = true;
363             player[msg.sender].withdrawRid = _rId;
364             player[msg.sender].withdrawSid = _sId;
365         }
366             
367         if(playerRoundAmount[_rId][msg.sender] == 0){
368             round[_rId].players++;
369             playerRoundSid[_rId][msg.sender] = _sId;
370         }
371             
372         if(playerStageAmount[_rId][_sId][msg.sender] == 0)
373             stage[_rId][_sId].players++;
374             
375         playerRoundAmount[_rId][msg.sender] = playerRoundAmount[_rId][msg.sender].add(_amount);
376         playerStageAmount[_rId][_sId][msg.sender] = playerStageAmount[_rId][_sId][msg.sender].add(_amount);
377         
378         player[msg.sender].amount = player[msg.sender].amount.add(_amount);
379         
380         if(playerRoundSid[_rId][msg.sender] > 0){
381             
382             if(playerStageAccAmount[_rId][_sId][msg.sender] == 0){
383                 
384                 for(uint256 i = playerRoundSid[_rId][msg.sender]; i < _sId; i++){
385                 
386                     if(playerStageAmount[_rId][i][msg.sender] > 0)
387                         playerStageAccAmount[_rId][_sId][msg.sender] = playerStageAccAmount[_rId][_sId][msg.sender].add(playerStageAmount[_rId][i][msg.sender]);
388                     
389                 }
390             }
391             
392             playerStageAccAmount[_rId][_sId][msg.sender] = playerStageAccAmount[_rId][_sId][msg.sender].add(_amount);
393         }
394     }
395     
396     /**
397      * Execute end of round events.
398      */
399     function endRound(uint256 _rId, uint256 _sId)
400         private
401     {
402         round[_rId].end = now;
403         round[_rId].ended = true;
404         round[_rId].endSid = _sId;
405         stage[_rId][_sId].end = now;
406         stage[_rId][_sId].ended = true;
407         
408         if(stage[_rId][_sId].players == 0)
409             round[_rId + 1].jackpotAmount = round[_rId + 1].jackpotAmount.add(round[_rId].jackpotAmount);
410         else
411             round[_rId + 1].jackpotAmount = round[_rId + 1].jackpotAmount.add(round[_rId].jackpotAmount.mul(100 - jackpotProportion) / 100);
412         
413         rId++;
414         sId = 1;
415         
416     }
417     
418     /**
419      * Execute end of stage events.
420      */
421     function endStage(uint256 _rId, uint256 _sId)
422         private
423     {
424         uint256 _jackpotAmount = stage[_rId][_sId].amount.mul(jackpot) / 100;
425         round[_rId].endSid = _sId;
426         round[_rId].jackpotAmount = round[_rId].jackpotAmount.add(_jackpotAmount);
427         stage[_rId][_sId].end = now;
428         stage[_rId][_sId].ended = true;
429         if(_sId > 1)
430             stage[_rId][_sId].accAmount = stage[_rId][_sId].targetAmount.add(stage[_rId][_sId - 1].accAmount);
431         else
432             stage[_rId][_sId].accAmount = stage[_rId][_sId].targetAmount;
433         
434         sId++;
435     }
436     
437     /**
438      * Precalculations for withdraws to conserve gas.
439      */
440     function getPlayerDividendByStage(uint256 _rId, uint256 _sId, address _playerAddr)
441         private
442         view
443         returns(uint256, uint256, uint256, uint256)
444     {
445         
446         uint256 _dividend;
447         uint256 _stageNumber;
448         uint256 _startSid;
449         uint256 _playerAmount;    
450         
451         for(uint256 i = player[_playerAddr].withdrawRid; i <= _rId; i++){
452             
453             if(playerRoundAmount[i][_playerAddr] == 0)
454                 continue;
455             
456             _playerAmount = 0;    
457             _startSid = i == player[_playerAddr].withdrawRid ? player[_playerAddr].withdrawSid : 1;
458             for(uint256 j = _startSid; j < round[i].endSid; j++){
459                     
460                 if(playerStageAccAmount[i][j][_playerAddr] > 0)
461                     _playerAmount = playerStageAccAmount[i][j][_playerAddr];
462                     
463                 if(_playerAmount == 0)
464                     _playerAmount = playerRoundwithdrawAmountFlag[i][_playerAddr];
465                     
466                 if(_playerAmount == 0)
467                     continue;
468                 _dividend = _dividend.add(
469                     (
470                         _playerAmount.mul(stage[i][j].dividendAmount)
471                     ).div(stage[i][j].accAmount)
472                 );
473                 
474                 _stageNumber++;
475                 if(_stageNumber >= 50)
476                     return (_dividend, i, j + 1, _playerAmount);
477             }
478             
479             if(round[i].ended == true
480                 && stage[i][round[i].endSid].amount > 0
481                 && playerStageAmount[i][round[i].endSid][_playerAddr] > 0
482             ){
483                 _dividend = _dividend.add(getPlayerJackpot(_playerAddr, i));
484                 _stageNumber++;
485                 if(_stageNumber >= 50)
486                     return (_dividend, i + 1, 1, 0);
487             }
488         }
489         return (_dividend, _rId, _sId, _playerAmount);
490     }
491     
492     /**
493      * Get player current withdrawable dividend.
494      */
495     function getPlayerDividend(address _playerAddr)
496         public
497         view
498         returns(uint256)
499     {
500         uint256 _endRid = rId;
501         uint256 _startRid = player[_playerAddr].withdrawRid;
502         uint256 _startSid;
503         uint256 _dividend;
504         
505         for(uint256 i = _startRid; i <= _endRid; i++){
506             
507             if(i == _startRid)
508                 _startSid = player[_playerAddr].withdrawSid;
509             else
510                 _startSid = 1;
511             _dividend = _dividend.add(getPlayerDividendByRound(_playerAddr, i, _startSid));
512         }
513         
514         return _dividend;
515     }
516     
517     /**
518      * Get player data for rounds and stages.
519      */
520     function getPlayerDividendByRound(address _playerAddr, uint256 _rId, uint256 _sId)
521         public
522         view
523         returns(uint256)
524     {
525         uint256 _dividend;
526         uint256 _startSid = _sId;
527         uint256 _endSid = round[_rId].endSid;
528         
529         uint256 _playerAmount;
530         uint256 _totalAmount;
531         for(uint256 i = _startSid; i < _endSid; i++){
532             
533             if(stage[_rId][i].ended == false)
534                 continue;
535                 
536             _playerAmount = 0;    
537             _totalAmount = 0;
538             for(uint256 j = 1; j <= i; j++){
539                 
540                 if(playerStageAmount[_rId][j][_playerAddr] > 0)
541                     _playerAmount = _playerAmount.add(playerStageAmount[_rId][j][_playerAddr]);
542                 
543                 _totalAmount = _totalAmount.add(stage[_rId][j].amount);
544             }
545             
546             if(_playerAmount == 0 || stage[_rId][i].dividendAmount == 0)
547                 continue;
548             _dividend = _dividend.add((_playerAmount.mul(stage[_rId][i].dividendAmount)).div(_totalAmount));
549         }
550         
551         if(round[_rId].ended == true)
552             _dividend = _dividend.add(getPlayerJackpot(_playerAddr, _rId));
553 
554         return _dividend;
555     }
556     
557     
558     /**
559      * Get player data for jackpot winnings.
560      */
561     function getPlayerJackpot(address _playerAddr, uint256 _rId)
562         public
563         view
564         returns(uint256)
565     {
566         uint256 _dividend;
567         
568         if(round[_rId].ended == false)
569             return _dividend;
570         
571         uint256 _endSid = round[_rId].endSid;
572         uint256 _playerStageAmount = playerStageAmount[_rId][_endSid][_playerAddr];
573         uint256 _stageAmount = stage[_rId][_endSid].amount;
574         if(_stageAmount <= 0)
575             return _dividend;
576             
577         uint256 _jackpotAmount = round[_rId].jackpotAmount.mul(jackpotProportion) / 100;
578         uint256 _stageDividendAmount = stage[_rId][_endSid].dividendAmount;
579         uint256 _stageJackpotAmount = (_stageAmount.mul(jackpot) / 100).add(_stageDividendAmount);
580         
581         _dividend = _dividend.add(((_playerStageAmount.mul(_jackpotAmount)).div(_stageAmount)));
582         _dividend = _dividend.add(((_playerStageAmount.mul(_stageJackpotAmount)).div(_stageAmount)));
583         
584         return _dividend;
585     }
586     
587     /**
588      * For frontend.
589      */
590     function getHeadInfo()
591         public
592         view
593         returns(uint256, uint256, uint256, uint256, uint256, uint256, bool)
594     {
595         return
596             (
597                 rId,
598                 sId,
599                 round[rId].jackpotAmount,
600                 stage[rId][sId].targetAmount,
601                 stage[rId][sId].amount,
602                 stage[rId][sId].end,
603                 stage[rId][sId].ended
604             );
605     }
606     
607     /**
608      * For frontend.
609      */
610     function getPersonalStatus(address _playerAddr)
611         public
612         view
613         returns(uint256, uint256, uint256)
614     {
615         if (player[_playerAddr].active == true){
616             return
617             (
618                 round[rId].jackpotAmount,
619                 playerRoundAmount[rId][_playerAddr],
620                 getPlayerDividendByRound(_playerAddr, rId, 1)
621             );
622         }else{
623             return
624             (
625                 round[rId].jackpotAmount,
626                 0,
627                 0
628             );
629         }
630     }
631     
632     /**
633      * For frontend.
634      */
635     function getValueInfo(address _playerAddr)
636         public
637         view
638         returns(uint256, uint256)
639     {
640         if (player[_playerAddr].active == true){
641             return
642             (
643                 getPlayerDividend(_playerAddr),
644                 player[_playerAddr].promotionAmount
645             );
646         }else{
647             return
648             (
649                 0,
650                 0
651             );
652         }
653     }
654     
655 }
656 
657 library Indatasets {
658     
659     struct Round {
660         uint256 start;          // time round started
661         uint256 end;            // time round ends/ended
662         bool ended;             // has round end function been ran
663         uint256 endSid;         // last stage for current round
664         uint256 amount;         // Eth recieved for current round
665         uint256 jackpotAmount;  // total jackpot for current round
666         uint256 players;        // total players for current round
667     }
668     
669     struct Stage {
670         uint256 start;          // time stage started
671         uint256 end;            // time strage ends/ended
672         bool ended;             // has stage end function been ran
673         uint256 targetAmount;   // amount needed for current stage
674         uint256 amount;         // Eth received for current stage
675         uint256 dividendAmount; // total dividend for current stage
676         uint256 accAmount;      // total accumulative amount for current stage
677         uint256 players;        // total players for current stage
678     }
679     
680     struct Player {
681         bool active;                // Activation status of player, if false player has not been activated.
682         uint256 amount;             // Total player input.
683         uint256 promotionAmount;    // Total promotion amount of the player.
684         uint256 withdrawRid;        // Last withdraw round of the player.
685         uint256 withdrawSid;        // Last withdraw stage of the player.
686     }
687 }
688 
689 /**
690  * @title SafeMath v0.1.9
691  * @dev Math operations with safety checks that throw on error
692  */
693 library SafeMath {
694     
695     /**
696     * @dev Adds two numbers, throws on overflow.
697     */
698     function add(uint256 a, uint256 b) 
699         internal 
700         pure 
701         returns (uint256) 
702     {
703         uint256 c = a + b;
704         assert(c >= a);
705         return c;
706     }
707     
708     /**
709     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
710     */
711     function sub(uint256 a, uint256 b) 
712         internal 
713         pure 
714         returns (uint256) 
715     {
716         assert(b <= a);
717         return a - b;
718     }
719 
720     /**
721     * @dev Multiplies two numbers, throws on overflow.
722     */
723     function mul(uint256 a, uint256 b) 
724         internal 
725         pure 
726         returns (uint256) 
727     {
728         if (a == 0) {
729             return 0;
730         }
731         uint256 c = a * b;
732         assert(c / a == b);
733         return c;
734     }
735     
736     /**
737     * @dev Integer division of two numbers, truncating the quotient.
738     */
739     function div(uint256 a, uint256 b) 
740         internal 
741         pure 
742         returns (uint256) 
743     {
744         assert(b > 0); // Solidity automatically throws when dividing by 0
745         uint256 c = a / b;
746         assert(a == b * c + a % b); // There is no case in which this doesn't hold
747         return c;
748     }
749     
750     /**
751      * @dev gives square root of given x.
752      */
753     function sqrt(uint256 x)
754         internal
755         pure
756         returns (uint256 y) 
757     {
758         uint256 z = ((add(x,1)) / 2);
759         y = x;
760         while (z < y) 
761         {
762             y = z;
763             z = ((add((x / z),z)) / 2);
764         }
765     }
766     
767     /**
768      * @dev gives square. multiplies x by x
769      */
770     function sq(uint256 x)
771         internal
772         pure
773         returns (uint256)
774     {
775         return (mul(x,x));
776     }
777     
778     /**
779      * @dev x to the power of y 
780      */
781     function pwr(uint256 x, uint256 y)
782         internal 
783         pure 
784         returns (uint256)
785     {
786         if (x==0)
787             return (0);
788         else if (y==0)
789             return (1);
790         else 
791         {
792             uint256 z = x;
793             for (uint256 i=1; i < y; i++)
794                 z = mul(z,x);
795             return (z);
796         }
797     }
798 }