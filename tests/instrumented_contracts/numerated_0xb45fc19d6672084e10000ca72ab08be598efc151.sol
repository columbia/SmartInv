1 /* ==================================================================== */
2 /* Copyright (c) 2018 The DappRound Project.  All rights reserved.                
3 /* ==================================================================== */
4 
5 pragma solidity ^0.4.24;
6 
7 contract Dappround {
8     using SafeMath for uint256;
9     
10     /*------------------------------
11                 CONFIGURABLES
12      ------------------------------*/
13     string public name = "Dappround";    // Contract name
14     string public symbol = "DappR";
15     
16     uint256 public initAmount;          // Initial stage target
17     uint256 public amountProportion;    // Stage target growth rate %
18     uint256 public dividend;            // Input to Dividend %
19     uint256 public jackpot;             // Input to Jackpot %
20     uint256 public jackpotProportion;   // Jackpot payout %
21     uint256 public scientists;          // Donation Fee % to scientists
22     uint256 public winnerFee;           // Winner donation Fee % to scientists
23     uint256 public promotionRatio;      // Promotion %
24     uint256 public duration;            // Duration per stage
25     bool public activated = false;      //Begin the dapp
26     address[] public luckBoylist;       //All LuckBoy list
27    
28     
29     address public developerAddr;
30 
31     address public luckBoyFirst; // winner for stage first
32     address public luckBoyLast; // winner for stage last
33 
34     uint256 public luckFristBonusRatio; //Frist luck boy bonus ratio %
35     uint256 public luckLastBonusRatio;  //Last luck boy bonus ratio %
36 
37 
38 
39 
40     
41 
42     
43     /*------------------------------
44                 DATASETS
45      ------------------------------*/
46     uint256 public rId;   // Current round id number
47     uint256 public sId;   // Current stage id number
48 
49 
50 
51     /*------------------------------
52                 EVENT
53      ------------------------------*/
54     event EndStage(uint256 _rId, uint256 _sId);
55     event EndRound(uint256 _rId, uint256 _sId);
56 
57 
58     
59     mapping (uint256 => Indatasets.Round) public round; // (rId => data) round data by round id
60     mapping (uint256 => mapping (uint256 => Indatasets.Stage)) public stage;    // (rId => sId => data) stage data by round id & stage id
61     mapping (address => Indatasets.Player) public player;   // (address => data) player data
62     mapping (uint256 => mapping (address => uint256)) public playerRoundAmount; // (rId => address => playerRoundAmount) round data by round id
63     mapping (uint256 => mapping (address => uint256)) public playerRoundSid; 
64     mapping (uint256 => mapping (address => uint256)) public playerRoundwithdrawAmountFlag; 
65     mapping (uint256 => mapping (uint256 => mapping (address => uint256))) public playerStageAmount;    // (rId => sId => address => playerStageAmount) round data by round id & stage id
66     mapping (uint256 => mapping (uint256 => mapping (address => uint256))) public playerStageAccAmount;  
67     
68     //Antiwhale setting, max 5% of stage target for the first 10 stages per address
69     uint256[] amountLimit = [0, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50];
70     
71 
72     /*------------------------------
73                 PUBLIC FUNCTIONS
74     ------------------------------*/
75     
76     constructor()
77         public
78     {
79         developerAddr = msg.sender;
80     }
81     
82     /*------------------------------
83                 MODIFIERS
84      ------------------------------*/
85      
86     modifier isActivated() {
87         require(activated == true, "its not ready yet.  check ?eta in discord"); 
88         _;
89     }
90     
91     modifier senderVerify() {
92         require (msg.sender == tx.origin);
93         _;
94     }
95     
96     modifier stageVerify(uint256 _rId, uint256 _sId, uint256 _amount) {
97         require(stage[_rId][_sId].amount.add(_amount) <= stage[_rId][_sId].targetAmount);
98         _;
99     }
100     
101     /**
102      * Don't toy or spam the contract.
103      * The scientists will take anything below 0.002 ETH sent to the contract.
104      * Thank you for your donation.
105      */
106     modifier amountVerify() {
107         if(msg.value < 2000000000000000){
108             developerAddr.transfer(msg.value);
109         }else{
110             require(msg.value >= 2000000000000000);
111             _;
112         }
113     }
114     
115     modifier playerVerify() {
116         require(player[msg.sender].active == true);
117         _;
118     }
119     
120     /**
121      * Activation of contract with settings
122      */
123     function activate()
124         public
125     {
126         require(msg.sender == developerAddr);
127         require(activated == false, "Dappround already activated");
128         
129         activated = true;
130         initAmount = 8000000000000000000;
131         amountProportion = 5;
132         dividend = 75;
133         jackpot = 22;  
134         jackpotProportion = 70;  
135         scientists = 3;
136         winnerFee = 5;
137         promotionRatio = 15;
138         duration = 43200;
139 
140         luckFristBonusRatio = 50; 
141         luckLastBonusRatio = 50; 
142 
143         rId = 1;
144         sId = 1;
145         
146         round[rId].start = now;
147         initStage(rId, sId);
148 
149     }
150 
151     
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
257                 
258                 buyStageDataRecord(_rId, _sId, _promotionRatio, _amount);
259                 buyPlayerDataRecord(_rId, _sId, _amount);
260                 
261             }
262         }
263     }
264     
265     
266     /**
267      * Sets the initial stage parameter. 
268      */
269     function initStage(uint256 _rId, uint256 _sId)
270         private
271     {
272         uint256 _targetAmount;
273         stage[_rId][_sId].start = now;
274         stage[_rId][_sId].end = now.add(duration);
275         if(_sId > 1){
276             stage[_rId][_sId - 1].end = now;
277             stage[_rId][_sId - 1].ended = true;
278             _targetAmount = (stage[_rId][_sId - 1].targetAmount.mul(amountProportion + 100)) / 100;
279         }else
280             _targetAmount = initAmount;
281             
282         stage[_rId][_sId].targetAmount = _targetAmount;
283         
284     }
285     
286     /**
287      * Execution of antiwhale. 
288      */
289     function limitAmount(uint256 _rId, uint256 _sId)
290         private
291         returns(uint256)
292     {
293         uint256 _amount = msg.value;
294         
295         if(amountLimit.length > _sId)
296             _amount = ((stage[_rId][_sId].targetAmount.mul(amountLimit[_sId])) / 1000).sub(playerStageAmount[_rId][_sId][msg.sender]);
297         else
298             _amount = ((stage[_rId][_sId].targetAmount.mul(500)) / 1000).sub(playerStageAmount[_rId][_sId][msg.sender]);
299             
300         if(_amount >= msg.value)
301             return msg.value;
302         else
303             msg.sender.transfer(msg.value.sub(_amount));
304         
305         return _amount;
306     }
307     
308     /**
309      * Record the addresses eligible for promotion links.
310      */
311     function promotionDataRecord(address _recommendAddr, uint256 _amount)
312         private
313         returns(uint256)
314     {
315         uint256 _promotionRatio = promotionRatio;
316         
317         if(_recommendAddr != 0x0000000000000000000000000000000000000000 
318             && _recommendAddr != msg.sender 
319             && player[_recommendAddr].active == true
320         )
321             player[_recommendAddr].promotionAmount = player[_recommendAddr].promotionAmount.add((_amount.mul(_promotionRatio)) / 100);
322         else
323             _promotionRatio = 0;
324         
325         return _promotionRatio;
326     }
327     
328     
329     /**
330      * Records the round data.
331      */
332     function buyRoundDataRecord(uint256 _rId, uint256 _amount)
333         private
334     {
335 
336         round[_rId].amount = round[_rId].amount.add(_amount);
337         developerAddr.transfer(_amount.mul(scientists) / 100);
338     }
339     
340     /**
341      * Records the stage data.
342      */
343     function buyStageDataRecord(uint256 _rId, uint256 _sId, uint256 _promotionRatio, uint256 _amount)
344         stageVerify(_rId, _sId, _amount)
345         private
346     {
347         if(_amount <= 0)
348             return;
349         stage[_rId][_sId].amount = stage[_rId][_sId].amount.add(_amount);
350         stage[_rId][_sId].dividendAmount = stage[_rId][_sId].dividendAmount.add((_amount.mul(dividend.sub(_promotionRatio))) / 100);
351     }
352     
353     /**
354      * Records the player data.
355      */
356     function buyPlayerDataRecord(uint256 _rId, uint256 _sId, uint256 _amount)
357         private
358     {
359         if(_amount <= 0)
360             return;
361             
362         if(player[msg.sender].active == false){
363             player[msg.sender].active = true;
364             player[msg.sender].withdrawRid = _rId;
365             player[msg.sender].withdrawSid = _sId;
366         }
367             
368         if(playerRoundAmount[_rId][msg.sender] == 0){
369             round[_rId].players++;
370             round[_rId].roundPlayerList.push(msg.sender);
371             playerRoundSid[_rId][msg.sender] = _sId;
372         }
373             
374         if(playerStageAmount[_rId][_sId][msg.sender] == 0){
375             stage[_rId][_sId].players++;
376             stage[_rId][_sId].stagePlayerList.push(msg.sender);
377         }
378 
379         //Add players address to order list. Find the luckboy.
380         stage[_rId][_sId].orderlistcount++;
381         stage[_rId][_sId].stagePlayerOrderList.push(msg.sender);
382             
383             
384         playerRoundAmount[_rId][msg.sender] = playerRoundAmount[_rId][msg.sender].add(_amount);
385         playerStageAmount[_rId][_sId][msg.sender] = playerStageAmount[_rId][_sId][msg.sender].add(_amount);
386         
387         player[msg.sender].amount = player[msg.sender].amount.add(_amount);
388         
389         if(playerRoundSid[_rId][msg.sender] > 0){
390             
391             if(playerStageAccAmount[_rId][_sId][msg.sender] == 0){
392                 
393                 for(uint256 i = playerRoundSid[_rId][msg.sender]; i < _sId; i++){
394                 
395                     if(playerStageAmount[_rId][i][msg.sender] > 0)
396                         playerStageAccAmount[_rId][_sId][msg.sender] = playerStageAccAmount[_rId][_sId][msg.sender].add(playerStageAmount[_rId][i][msg.sender]);
397                     
398                 }
399             }
400             
401             playerStageAccAmount[_rId][_sId][msg.sender] = playerStageAccAmount[_rId][_sId][msg.sender].add(_amount);
402         }
403     }
404     
405     /**
406      * Execute end of round events.
407      */
408     function endRound(uint256 _rId, uint256 _sId)
409         private
410     {
411         round[_rId].end = now;
412         round[_rId].ended = true;
413         round[_rId].endSid = _sId;
414         stage[_rId][_sId].end = now;
415         stage[_rId][_sId].ended = true;
416 
417 
418      
419         
420         if(stage[_rId][_sId].players == 0){
421             //Nobody get big
422             luckBoyFirst = 0x0000000000000000000000000000000000000000;
423             luckBoyLast = 0x0000000000000000000000000000000000000000;
424             luckBoylist.push(luckBoyFirst);
425             luckBoylist.push(luckBoyLast);
426             round[_rId + 1].jackpotAmount = round[_rId + 1].jackpotAmount.add(round[_rId].jackpotAmount);
427         }    
428         else{
429             //Luckboy wooo!
430             luckBoyFirst = winnerFirst(_rId,_sId);
431             luckBoyLast = winnerLast(_rId,_sId);
432             luckBoylist.push(luckBoyFirst);
433             luckBoylist.push(luckBoyLast);
434             round[_rId + 1].jackpotAmount = round[_rId + 1].jackpotAmount.add(round[_rId].jackpotAmount.mul(100 - jackpotProportion) / 100);
435         }
436 
437         //event 
438         emit EndRound(_rId,_sId);
439 
440         rId++;
441         sId = 1;
442         
443     }
444 
445     //Finally, the player who the first Order in the laset stage is the winner. 
446     function winnerFirst(uint256 _rId, uint256 _sId)
447         private
448         view
449         returns(address)
450     { 
451         return stage[_rId][_sId].stagePlayerOrderList[0];
452     }
453 
454     //Finally, the player who the last Order in the laset stage is the winner too. 
455     function winnerLast(uint256 _rId, uint256 _sId)
456         private
457         view
458         returns(address)
459     {
460         
461         uint256 lastOrder = (stage[_rId][_sId].orderlistcount - 1);
462          
463         return stage[_rId][_sId].stagePlayerOrderList[lastOrder];
464     }
465     
466     /**
467      * Execute end of stage events.
468      */
469     function endStage(uint256 _rId, uint256 _sId)
470         private
471     {
472         uint256 _jackpotAmount = stage[_rId][_sId].amount.mul(jackpot) / 100;  //jackpot = 22
473         round[_rId].endSid = _sId;
474         round[_rId].jackpotAmount = round[_rId].jackpotAmount.add(_jackpotAmount);
475         stage[_rId][_sId].end = now;
476         stage[_rId][_sId].ended = true;
477         if(_sId > 1)
478             stage[_rId][_sId].accAmount = stage[_rId][_sId].targetAmount.add(stage[_rId][_sId - 1].accAmount);
479         else
480             stage[_rId][_sId].accAmount = stage[_rId][_sId].targetAmount;
481 
482 
483         emit EndStage(_rId,_sId);
484 
485         sId++;
486     }
487 
488     
489     
490     /**
491      * Precalculations for withdraws to conserve gas.
492      */
493     function getPlayerDividendByStage(uint256 _rId, uint256 _sId, address _playerAddr)
494         private
495         view
496         returns(uint256, uint256, uint256, uint256)
497     {
498         
499         uint256 _dividend;
500         uint256 _stageNumber;
501         uint256 _startSid;
502         uint256 _playerAmount;    
503         
504         for(uint256 i = player[_playerAddr].withdrawRid; i <= _rId; i++){
505             
506             if(playerRoundAmount[i][_playerAddr] == 0)
507                 continue;
508             
509             _playerAmount = 0;    
510             _startSid = i == player[_playerAddr].withdrawRid ? player[_playerAddr].withdrawSid : 1;
511             for(uint256 j = _startSid; j < round[i].endSid; j++){
512                     
513                 if(playerStageAccAmount[i][j][_playerAddr] > 0)
514                     _playerAmount = playerStageAccAmount[i][j][_playerAddr];
515                     
516                 if(_playerAmount == 0)
517                     _playerAmount = playerRoundwithdrawAmountFlag[i][_playerAddr];
518                     
519                 if(_playerAmount == 0)
520                     continue;
521                 _dividend = _dividend.add(
522                     (
523                         _playerAmount.mul(stage[i][j].dividendAmount)
524                     ).div(stage[i][j].accAmount)
525                 );
526                 
527                 _stageNumber++;
528                 if(_stageNumber >= 50)
529                     return (_dividend, i, j + 1, _playerAmount);
530             }
531             
532             if(round[i].ended == true
533                 && stage[i][round[i].endSid].amount > 0
534                 && playerStageAmount[i][round[i].endSid][_playerAddr] > 0
535             ){
536                 _dividend = _dividend.add(getPlayerJackpot(_playerAddr, i));
537                 _stageNumber++;
538                 if(_stageNumber >= 50)
539                     return (_dividend, i + 1, 1, 0);
540             }
541         }
542         return (_dividend, _rId, _sId, _playerAmount);
543     }
544     
545     /**
546      * Get player current withdrawable dividend.
547      */
548     function getPlayerDividend(address _playerAddr)
549         public
550         view
551         returns(uint256)
552     {
553         uint256 _endRid = rId;
554         uint256 _startRid = player[_playerAddr].withdrawRid;
555         uint256 _startSid;
556         uint256 _dividend;
557         
558         for(uint256 i = _startRid; i <= _endRid; i++){
559             
560             if(i == _startRid)
561                 _startSid = player[_playerAddr].withdrawSid;
562             else
563                 _startSid = 1;
564             _dividend = _dividend.add(getPlayerDividendByRound(_playerAddr, i, _startSid));
565         }
566         
567         return _dividend;
568     }
569     
570     /**
571      * Get player data for rounds and stages.
572      */
573     function getPlayerDividendByRound(address _playerAddr, uint256 _rId, uint256 _sId)
574         public
575         view
576         returns(uint256)
577     {
578         uint256 _dividend;
579         uint256 _startSid = _sId;
580         uint256 _endSid = round[_rId].endSid;
581         
582         uint256 _playerAmount;
583         uint256 _totalAmount;
584         for(uint256 i = _startSid; i < _endSid; i++){
585             
586             if(stage[_rId][i].ended == false)
587                 continue;
588                 
589             _playerAmount = 0;    
590             _totalAmount = 0;
591             for(uint256 j = 1; j <= i; j++){
592                 
593                 if(playerStageAmount[_rId][j][_playerAddr] > 0)
594                     _playerAmount = _playerAmount.add(playerStageAmount[_rId][j][_playerAddr]);
595                 
596                 _totalAmount = _totalAmount.add(stage[_rId][j].amount);
597             }
598             
599             if(_playerAmount == 0 || stage[_rId][i].dividendAmount == 0)
600                 continue;
601             _dividend = _dividend.add((_playerAmount.mul(stage[_rId][i].dividendAmount)).div(_totalAmount));
602         }
603         
604         if(round[_rId].ended == true)
605             _dividend = _dividend.add(getPlayerJackpot(_playerAddr, _rId));
606 
607         return _dividend;
608     }
609     
610     
611     /**
612      * Get player data for jackpot winnings.
613      */
614     function getPlayerJackpot(address _playerAddr, uint256 _rId)
615         public
616         view
617         returns(uint256)
618     {
619         uint256 _dividend;
620         
621         if(round[_rId].ended == false)
622             return _dividend;
623 
624 
625         uint256 _playerStageAmount = playerStageAmount[_rId][round[_rId].endSid][_playerAddr];
626         uint256 _stageAmount = stage[_rId][round[_rId].endSid].amount;
627 
628         if(_stageAmount <= 0)
629             return _dividend;
630 
631 
632         uint256 _jackpotAmount;
633         uint256 _stageDividendAmount;
634         uint256 _stageJackpotAmount;
635 
636 
637         uint256 toScien;
638 
639 
640 
641 
642         if(luckBoyFirst != 0x0000000000000000000000000000000000000000 
643             && luckBoyLast != 0x0000000000000000000000000000000000000000 
644           ){
645 
646             _jackpotAmount = (round[_rId].jackpotAmount.mul(jackpotProportion) / 100).div(2);  //jackpotProportion = 70
647             _stageDividendAmount = stage[_rId][round[_rId].endSid].dividendAmount;
648             _stageJackpotAmount = ((_stageAmount.mul(jackpot) / 100).add(_stageDividendAmount)).div(2);  //jackpot = 22
649 
650 
651 
652             if(luckBoyFirst == _playerAddr){
653                 require(luckBoyFirst != 0x0000000000000000000000000000000000000000);
654                 require(_playerAddr != 0x0000000000000000000000000000000000000000);
655 
656                 _dividend = _dividend.add(((_playerStageAmount.mul(_jackpotAmount)).div(_stageAmount)));   
657                 _dividend = _dividend.add(((_playerStageAmount.mul(_stageJackpotAmount)).div(_stageAmount))); 
658 
659                 //winner own big
660                 _dividend = _dividend.add((_jackpotAmount.add(_stageJackpotAmount)).mul(luckFristBonusRatio).div(100)); 
661 
662 
663                 toScien = _dividend.mul(winnerFee).div(100);
664                 
665                 // winner own big
666                 _dividend = _dividend.sub(toScien);   
667                 
668                 //winnerFee to scientists
669                 developerAddr.transfer(toScien);  
670                 
671             }else if(luckBoyLast == _playerAddr){
672                 require(luckBoyLast != 0x0000000000000000000000000000000000000000);
673                 require(_playerAddr != 0x0000000000000000000000000000000000000000);
674 
675                 _dividend = _dividend.add(((_playerStageAmount.mul(_jackpotAmount)).div(_stageAmount)));   
676                 _dividend = _dividend.add(((_playerStageAmount.mul(_stageJackpotAmount)).div(_stageAmount))); 
677 
678                 //winner own big
679                 _dividend = _dividend.add((_jackpotAmount.add(_stageJackpotAmount)).mul(luckLastBonusRatio).div(100)); 
680 
681 
682                 toScien = _dividend.mul(winnerFee).div(100);
683                 
684                 // winner own big
685                 _dividend = _dividend.sub(toScien);   
686                 
687                 //winnerFee to scientists
688                 developerAddr.transfer(toScien);  
689 
690 
691             }else{
692 
693       
694                 _dividend = _dividend.add(((_playerStageAmount.mul(_jackpotAmount)).div(_stageAmount)));   
695                 _dividend = _dividend.add(((_playerStageAmount.mul(_stageJackpotAmount)).div(_stageAmount))); 
696 
697             }
698 
699         }else if(luckBoyFirst == 0x0000000000000000000000000000000000000000
700                 && luckBoyLast == 0x0000000000000000000000000000000000000000 
701             ){
702 
703             _jackpotAmount = round[_rId].jackpotAmount.mul(jackpotProportion) / 100;  
704             _stageDividendAmount = stage[_rId][round[_rId].endSid].dividendAmount;
705             _stageJackpotAmount = (_stageAmount.mul(jackpot) / 100).add(_stageDividendAmount);  
706             
707             _dividend = _dividend.add(((_playerStageAmount.mul(_jackpotAmount)).div(_stageAmount)));  
708             _dividend = _dividend.add(((_playerStageAmount.mul(_stageJackpotAmount)).div(_stageAmount)));
709 
710         }
711     
712         
713         
714         return _dividend;
715     }
716     
717     /**
718      * For frontend.
719      */
720     function getHeadInfo()
721         public
722         view
723         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, bool)
724     {
725         return
726             (
727                 rId,
728                 sId,
729                 round[rId].jackpotAmount,
730                 stage[rId][sId].targetAmount,
731                 stage[rId][sId].amount,
732                 stage[rId][sId].start,
733                 stage[rId][sId].end,
734                 stage[rId][sId].ended
735             );
736     }
737 
738 
739     /**
740      * For frontend.
741      */
742     function getLuckBoyAddrList()
743         public
744         view
745         returns(address[])
746     {
747         return
748             (
749                 luckBoylist,
750             );
751     }
752 
753 
754     /**
755      * For frontend.
756      */
757     function getRoundPlayerList(uint256 _rId)
758         public
759         view
760         returns(address[])
761     {
762         return
763             (
764                 round[_rId].roundPlayerList,
765             );
766     }
767     
768     /**
769      * For frontend.
770      */
771     function getPersonalStatus(address _playerAddr)
772         public
773         view
774         returns(uint256, uint256, uint256)
775     {
776         if (player[_playerAddr].active == true){
777             return
778             (
779                 round[rId].jackpotAmount,
780                 playerRoundAmount[rId][_playerAddr],
781                 getPlayerDividendByRound(_playerAddr, rId, 1)
782             );
783         }else{
784             return
785             (
786                 round[rId].jackpotAmount,
787                 0,
788                 0
789             );
790         }
791     }
792     
793     /**
794      * For frontend.
795      */
796     function getValueInfo(address _playerAddr)
797         public
798         view
799         returns(uint256, uint256)
800     {
801         if (player[_playerAddr].active == true){
802             return
803             (
804                 getPlayerDividend(_playerAddr),
805                 player[_playerAddr].promotionAmount
806             );
807         }else{
808             return
809             (
810                 0,
811                 0
812             );
813         }
814     }
815 
816     function getRoundStageEndInfo(uint256 _rid)
817         public
818         view
819         returns(uint256)
820     {
821         return
822             (
823                 round[_rid].endSid,
824             );
825     }
826 
827 
828     function getRoundInfo(uint256 _rid, uint256 _sid)
829         public
830         view
831         returns(uint256, uint256,uint256, uint256, uint256, uint256)
832     {
833         return
834             (
835                 round[_rid].jackpotAmount,
836                 round[_rid].endSid,
837                 stage[_rid][_sid].targetAmount,
838                 stage[_rid][_sid].amount,
839                 stage[_rid][_sid].start,
840                 stage[_rid][_sid].end
841             );
842     }
843     
844 }
845 
846 
847 
848 
849 library Indatasets {
850     
851     struct Round {
852         uint256 start;                  // time round started
853         uint256 end;                    // time round ends/ended
854         bool ended;                     // has round end function been ran
855         uint256 endSid;                 // last stage for current round
856         uint256 amount;                 // Eth recieved for current round
857         uint256 jackpotAmount;          // total jackpot for current round
858         uint256 players;                // total players for current round
859         address[] roundPlayerList;      // total players address for current round
860     }
861     
862     struct Stage {
863         uint256 start;                  // time stage started
864         uint256 end;                    // time strage ends/ended
865         bool ended;                     // has stage end function been ran
866         uint256 targetAmount;           // amount needed for current stage
867         uint256 amount;                 // Eth received for current stage
868         uint256 dividendAmount;         // total dividend for current stage
869         uint256 accAmount;              // total accumulative amount for current stage
870         uint256 players;                // total players for current stage
871         uint256 orderlistcount;         // total players order list for current stage
872         address[] stagePlayerList;      // total players address for current stage
873         address[] stagePlayerOrderList; // total players Order List for current stage
874     }
875     
876     struct Player {
877         bool active;                // Activation status of player, if false player has not been activated.
878         uint256 amount;             // Total player input.
879         uint256 promotionAmount;    // Total promotion amount of the player.
880         uint256 withdrawRid;        // Last withdraw round of the player.
881         uint256 withdrawSid;        // Last withdraw stage of the player.
882     }
883 }
884 
885 /**
886  * @title SafeMath v0.1.9
887  * @dev Math operations with safety checks that throw on error
888  */
889 library SafeMath {
890     
891     /**
892     * @dev Adds two numbers, throws on overflow.
893     */
894     function add(uint256 a, uint256 b) 
895         internal 
896         pure 
897         returns (uint256) 
898     {
899         uint256 c = a + b;
900         assert(c >= a);
901         return c;
902     }
903     
904     /**
905     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
906     */
907     function sub(uint256 a, uint256 b) 
908         internal 
909         pure 
910         returns (uint256) 
911     {
912         assert(b <= a);
913         return a - b;
914     }
915 
916     /**
917     * @dev Multiplies two numbers, throws on overflow.
918     */
919     function mul(uint256 a, uint256 b) 
920         internal 
921         pure 
922         returns (uint256) 
923     {
924         if (a == 0) {
925             return 0;
926         }
927         uint256 c = a * b;
928         assert(c / a == b);
929         return c;
930     }
931     
932     /**
933     * @dev Integer division of two numbers, truncating the quotient.
934     */
935     function div(uint256 a, uint256 b) 
936         internal 
937         pure 
938         returns (uint256) 
939     {
940         assert(b > 0); // Solidity automatically throws when dividing by 0
941         uint256 c = a / b;
942         assert(a == b * c + a % b); // There is no case in which this doesn't hold
943         return c;
944     }
945     
946     /**
947      * @dev gives square root of given x.
948      */
949     function sqrt(uint256 x)
950         internal
951         pure
952         returns (uint256 y) 
953     {
954         uint256 z = ((add(x,1)) / 2);
955         y = x;
956         while (z < y) 
957         {
958             y = z;
959             z = ((add((x / z),z)) / 2);
960         }
961     }
962     
963     /**
964      * @dev gives square. multiplies x by x
965      */
966     function sq(uint256 x)
967         internal
968         pure
969         returns (uint256)
970     {
971         return (mul(x,x));
972     }
973     
974     /**
975      * @dev x to the power of y 
976      */
977     function pwr(uint256 x, uint256 y)
978         internal 
979         pure 
980         returns (uint256)
981     {
982         if (x==0)
983             return (0);
984         else if (y==0)
985             return (1);
986         else 
987         {
988             uint256 z = x;
989             for (uint256 i=1; i < y; i++)
990                 z = mul(z,x);
991             return (z);
992         }
993     }
994 }