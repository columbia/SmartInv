1 pragma solidity ^0.4.25;
2 
3 /**
4  *
5  *  https://fairdapp.com/bankfomo/  https://fairdapp.com/bankfomo/   https://fairdapp.com/bankfomo/
6  *   
7  *       _______     _       ______  _______ ______ ______  
8  *      (_______)   (_)     (______)(_______|_____ (_____ \ 
9  *       _____ _____ _  ____ _     _ _______ _____) )____) )
10  *      |  ___|____ | |/ ___) |   | |  ___  |  ____/  ____/ 
11  *      | |   / ___ | | |   | |__/ /| |   | | |    | |      
12  *      |_|   \_____|_|_|   |_____/ |_|   |_|_|    |_|      
13  *                                                     
14  *               ______              _                              
15  *              (____  \            | |                             
16  *               ____)  )_____ ____ | |  _                          
17  *              |  __  ((____ |  _ \| |_/ )                         
18  *              | |__)  ) ___ | | | |  _ (                          
19  *              |______/\_____|_| |_|_| \_)                         
20  *                                                    
21  * 				  _______                
22  * 				 (_______)               
23  * 				  _____ ___  ____   ___  
24  * 				 |  ___) _ \|    \ / _ \ 
25  * 				 | |  | |_| | | | | |_| |
26  * 				 |_|   \___/|_|_|_|\___/
27  *   
28  *  Warning:
29  *     
30  *  FairDAPP – Bank Fomo is a re-release of the original game FairDAPP - Bank Simulator.
31  *  This version ties into the FairExchange and has about 3x more aggressive scaling. 
32  *  This contract may only be used internally for study purposes and all could be 
33  *  lost by sending anything to this contract address. 
34  *  All users are prohibited to interact with this contract if this 
35  *  contract is in conflict with user’s local regulations or laws.
36  * 
37  *  -Original Contract built by the FairDAPP Community
38  *  -Code Audited by 8Bit & Etherguy (formula calculations are excluded from the audit)
39  *  
40  *  -The resetTime and reduceTime functions have an on and off switch which the developer owner can control.
41  *  -No one can change anything else once the contract has been deployed.
42  *  
43  *  -The contract is fully solvent in any event (assuming there are no bugs).
44  *  -ie. The contract will always payout what it owes. 
45  *
46 **/
47 
48 
49 contract ERC721{
50     
51     function totalSupply() public view returns (uint256 total);
52     function balanceOf(address _owner) public view returns (uint256 balance);
53     function ownerOf(uint256 _tokenId) public view returns (address owner);
54     function approve(address _to, uint256 _tokenId) public;
55     function takeOwnership(uint256 _tokenId) public;
56     function transfer(address _to, uint256 _tokenId) public;
57     function transferFrom(address _from, address _to, uint256 _tokenId) public;
58     
59     event Transfer(address from, address to, uint256 tokenId);
60     event Approval(address owner, address approved, uint256 tokenId);
61 }
62 
63 contract FairBankFomo is ERC721{
64     using SafeMath for uint256;
65        
66     address public developerAddr = 0xbC817A495f0114755Da5305c5AA84fc5ca7ebaBd;
67     address public fairProfitContract = 0x53a39eeF083c4A91e36145176Cc9f52bE29B7288;
68 
69     string public name = "FairDAPP - Bank Simulator - Fomo";
70     string public symbol = "FBankFomo";
71     
72     uint256 public stageDuration = 3600;
73     uint256 public standardProtectRatio = 57;
74     bool public modifyCountdown = false;
75     uint256 public startTime = 1539997200;
76     uint256 public cardTime = 1539993600;
77     
78     uint256 public rId = 1;
79     uint256 public sId = 1;
80     
81     mapping (uint256 => FBankdatasets.Round) public round;
82     mapping (uint256 => mapping (uint256 => FBankdatasets.Stage)) public stage;
83     
84     mapping (address => bool) public player;
85     mapping (address => uint256[]) public playerGoodsList;
86     mapping (address => uint256[]) public playerWithdrawList;
87     
88     /**
89      * Anti clone protection.
90      * Do not clone this contract without permission even if you manage to break the conceal. 
91      * The concealed code contains core calculations necessary for this contract to function, read line 1058. 
92      * This contract can be licensed for a fee, contact us instead of cloning!
93      */ 
94     FairBankCompute constant private bankCompute = FairBankCompute(0xdd033Ff7e98792694F6b358DaEB065d4FF01Bd5A);
95     
96     FBankdatasets.Goods[] public goodsList;
97     
98     FBankdatasets.Card[6] public cardList;
99     mapping (uint256 => address) public cardIndexToApproved;
100     
101     modifier isDeveloperAddr() {
102         require(msg.sender == developerAddr, "Permission denied");
103         _;
104     }
105     
106     modifier startTimeVerify() {
107         require(now >= startTime); 
108         _;
109     }
110     
111     modifier cardTimeVerify() {
112         require(now >= cardTime); 
113         _;
114     }
115     
116     modifier modifyCountdownVerify() {
117         require(modifyCountdown == true, "this feature is not turned on or has been turned off"); 
118         require(now >= stage[rId][sId].start, "Can only use the addtime/reduce time functions when game has started");  
119         _;
120     }
121      
122     modifier senderVerify() {
123         require (msg.sender == tx.origin, "sender does not meet the rules");
124         if(!player[msg.sender])
125             player[msg.sender] = true;
126         _;
127     }
128     
129     /**
130      * Don't toy or spam the contract, it may raise the gas cost for everyone else.
131      * The scientists will take anything below 0.001 ETH sent to the contract.
132      * Also added antiwhale settings. 	 
133      * Thank you for your donation.
134      */
135     modifier buyVerify() {
136           
137         if(msg.value < 1000000000000000){
138             developerAddr.send(msg.value);
139         }else{
140             require(msg.value >= 1000000000000000, "minimum amount is 0.001 ether");
141             
142             if(sId < 25)
143                 require(tx.gasprice <= 25000000000);
144                 
145             if(sId < 25)
146                 require(msg.value <= 10 ether);
147          _;
148         }
149     }
150     
151     modifier withdrawVerify() {
152         require(playerGoodsList[msg.sender].length > 0, "user has not purchased the product or has completed the withdrawal");
153         _;
154     }
155     
156     modifier stepSizeVerify(uint256 _stepSize) {
157         require(_stepSize <= 1000000, "step size must not exceed 1000000");
158         _;
159     }
160     
161     constructor()
162         public
163     {
164         round[rId].start = startTime;
165         stage[rId][sId].start = startTime;
166         uint256 i;
167         while(i < cardList.length){
168             cardList[i].playerAddress = fairProfitContract;
169             cardList[i].amount = 1 ether; 
170             i++;
171         }
172     }
173     
174     function openModifyCountdown()
175         senderVerify()
176         isDeveloperAddr()
177         public
178     {
179         require(modifyCountdown == false, "Time service is already open");
180         
181         modifyCountdown = true;
182         
183     }
184     
185     function closeModifyCountdown()
186         senderVerify()
187         isDeveloperAddr()
188         public
189     {
190         require(modifyCountdown == true, "Time service is already open");
191         
192         modifyCountdown = false;
193         
194     }
195     
196     function purchaseCard(uint256 _cId)
197         cardTimeVerify()
198         senderVerify()
199         payable
200         public
201     {
202         
203         address _player = msg.sender;
204         uint256 _amount = msg.value;
205         uint256 _purchasePrice = cardList[_cId].amount.mul(110) / 100;
206         
207         require(
208             cardList[_cId].playerAddress != address(0) 
209             && cardList[_cId].playerAddress != _player 
210             && _amount >= _purchasePrice, 
211             "Failed purchase"
212         );
213         
214         if(cardIndexToApproved[_cId] != address(0)){
215             cardIndexToApproved[_cId].send(
216                 cardList[_cId].amount.mul(105) / 100
217                 );
218             delete cardIndexToApproved[_cId];
219         }else
220             cardList[_cId].playerAddress.send(
221                 cardList[_cId].amount.mul(105) / 100
222                 );
223         
224         fairProfitContract.send(cardList[_cId].amount.mul(5) / 100);
225         if(_amount > _purchasePrice)
226             _player.send(_amount.sub(_purchasePrice));
227             
228         cardList[_cId].amount = _purchasePrice;
229         cardList[_cId].playerAddress = _player;
230         
231     }
232     
233     /**
234      * Fallback function to handle ethereum that was send straight to the contract
235      * Unfortunately we cannot use a referral address this way.
236      */
237     function()
238         startTimeVerify()
239         senderVerify()
240         buyVerify()
241         payable
242         public
243     {
244         buyAnalysis(100, standardProtectRatio);
245     }
246 
247     function buy(uint256 _stepSize, uint256 _protectRatio)
248         startTimeVerify()
249         senderVerify()
250         buyVerify()
251         stepSizeVerify(_stepSize)
252         public
253         payable
254     {
255         buyAnalysis(
256             _stepSize <= 0 ? 100 : _stepSize, 
257             _protectRatio <= 100 ? _protectRatio : standardProtectRatio
258             );
259     }
260     
261     /**
262      * Standard withdraw function.
263      */
264     function withdraw()
265         startTimeVerify()
266         senderVerify()
267         withdrawVerify()
268         public
269     {
270         
271         address _player = msg.sender;
272         uint256[] memory _playerGoodsList = playerGoodsList[_player];
273         uint256 length = _playerGoodsList.length;
274         uint256 _totalAmount;
275         uint256 _amount;
276         uint256 _withdrawSid;
277         uint256 _reachAmount;
278         bool _finish;
279         uint256 i;
280         
281         delete playerGoodsList[_player];
282         while(i < length){
283             
284             (_amount, _withdrawSid, _reachAmount, _finish) = getEarningsAmountByGoodsIndex(_playerGoodsList[i]);
285             
286             if(_finish == true){
287                 playerWithdrawList[_player].push(_playerGoodsList[i]);
288             }else{
289                 goodsList[_playerGoodsList[i]].withdrawSid = _withdrawSid;
290                 goodsList[_playerGoodsList[i]].reachAmount = _reachAmount;
291                 playerGoodsList[_player].push(_playerGoodsList[i]);
292             }
293             
294             _totalAmount = _totalAmount.add(_amount);
295             i++;
296         }
297         _player.transfer(_totalAmount);
298     }
299      
300      /**
301      * Backup withdraw function in case gas is too high to use standard withdraw.
302      */
303     function withdrawByGid(uint256 _gId)
304         startTimeVerify()
305         senderVerify()
306         withdrawVerify()
307         public
308     {
309         address _player = msg.sender;
310         uint256 _amount;
311         uint256 _withdrawSid;
312         uint256 _reachAmount;
313         bool _finish;
314         
315         (_amount, _withdrawSid, _reachAmount, _finish) = getEarningsAmountByGoodsIndex(_gId);
316             
317         if(_finish == true){
318             
319             for(uint256 i = 0; i < playerGoodsList[_player].length; i++){
320                 if(playerGoodsList[_player][i] == _gId)
321                     break;
322             }
323             require(i < playerGoodsList[_player].length, "gid is wrong");
324             
325             playerWithdrawList[_player].push(_gId);
326             playerGoodsList[_player][i] = playerGoodsList[_player][playerGoodsList[_player].length - 1];
327             playerGoodsList[_player].length--;
328         }else{
329             goodsList[_gId].withdrawSid = _withdrawSid;
330             goodsList[_gId].reachAmount = _reachAmount;
331         }
332         
333         _player.transfer(_amount);
334     }
335     
336     function resetTime()
337         modifyCountdownVerify()
338         senderVerify()
339         public
340         payable
341     {
342         uint256 _rId = rId;
343         uint256 _sId = sId;
344         uint256 _amount = msg.value;
345         uint256 _targetExpectedAmount = getStageTargetAmount(_sId);
346         uint256 _targetAmount = 
347             stage[_rId][_sId].dividendAmount <= _targetExpectedAmount ? 
348             _targetExpectedAmount : stage[_rId][_sId].dividendAmount;
349             _targetAmount = _targetAmount.mul(100) / 88;
350         uint256 _costAmount = _targetAmount.mul(20) / 100;
351         
352         if(_costAmount > 3 ether)
353             _costAmount = 3 ether;
354         require(_amount >= _costAmount, "Not enough price");
355         
356         stage[_rId][_sId].start = now;
357         
358         cardList[5].playerAddress.send(_costAmount / 2);
359         developerAddr.send(_costAmount / 2);
360         
361         if(_amount > _costAmount)
362             msg.sender.send(_amount.sub(_costAmount));
363         
364     }
365     
366     function reduceTime()
367         modifyCountdownVerify()
368         senderVerify()
369         public
370         payable
371     {
372         uint256 _rId = rId;
373         uint256 _sId = sId;
374         uint256 _amount = msg.value;
375         uint256 _targetExpectedAmount = getStageTargetAmount(_sId);
376         uint256 _targetAmount = 
377             stage[_rId][_sId].dividendAmount <= _targetExpectedAmount ?
378             _targetExpectedAmount : stage[_rId][_sId].dividendAmount;
379             _targetAmount = _targetAmount.mul(100) / 88;
380         uint256 _costAmount = _targetAmount.mul(30) / 100;
381         
382         if(_costAmount > 3 ether)
383             _costAmount = 3 ether;
384         require(_amount >= _costAmount, "Not enough price");
385         
386         stage[_rId][_sId].start = now - stageDuration + 900;
387         
388         cardList[5].playerAddress.send(_costAmount / 2);
389         developerAddr.send(_costAmount / 2);
390         
391         if(_amount > _costAmount)
392             msg.sender.send(_amount.sub(_costAmount));
393         
394     }
395     
396     /**
397      * Core logic to analyse buy behaviour. 
398      */
399     function buyAnalysis(uint256 _stepSize, uint256 _protectRatio)
400         private
401     {
402         uint256 _rId = rId;
403         uint256 _sId = sId;
404         uint256 _targetExpectedAmount = getStageTargetAmount(_sId);
405         uint256 _targetAmount = 
406             stage[_rId][_sId].dividendAmount <= _targetExpectedAmount ? 
407             _targetExpectedAmount : stage[_rId][_sId].dividendAmount;
408             _targetAmount = _targetAmount.mul(100) / 88;
409         uint256 _stageTargetBalance = 
410             stage[_rId][_sId].amount > 0 ? 
411             _targetAmount.sub(stage[_rId][_sId].amount) : _targetAmount;
412         
413         if(now > stage[_rId][_sId].start.add(stageDuration) 
414             && _targetAmount > stage[_rId][_sId].amount
415         ){
416             
417             endRound(_rId, _sId);
418             
419             _rId = rId;
420             _sId = sId;
421             stage[_rId][_sId].start = now;
422             
423             _targetExpectedAmount = getStageTargetAmount(_sId);
424             _targetAmount = 
425                 stage[_rId][_sId].dividendAmount <= _targetExpectedAmount ? 
426                 _targetExpectedAmount : stage[_rId][_sId].dividendAmount;
427             _targetAmount = _targetAmount.mul(100) / 88;
428             _stageTargetBalance = 
429                 stage[_rId][_sId].amount > 0 ? 
430                 _targetAmount.sub(stage[_rId][_sId].amount) : _targetAmount;
431         }
432         if(_stageTargetBalance > msg.value)
433             buyDataRecord(
434                 _rId, 
435                 _sId, 
436                 _targetAmount, 
437                 msg.value, 
438                 _stepSize, 
439                 _protectRatio
440                 );
441         else
442             multiStake(
443                 msg.value, 
444                 _stepSize, 
445                 _protectRatio, 
446                 _targetAmount, 
447                 _stageTargetBalance
448                 );
449         /* This is a backstop check to ensure that the contract will always be solvent.
450         It would reject any stakes with a protection ratio that the contract may not be able to repay.
451         This backstop should never be needed under current settings. */
452         require(
453             (
454                 round[_rId].jackpotAmount.add(round[_rId].amount.mul(88) / 100)
455                 .sub(round[_rId].protectAmount)
456                 .sub(round[_rId].dividendAmount)
457             ) > 0, "data error"
458         );    
459         bankerFeeDataRecord(msg.value, _protectRatio);    
460     }
461     
462     function multiStake(uint256 _amount, uint256 _stepSize, uint256 _protectRatio, uint256 _targetAmount, uint256 _stageTargetBalance)
463         private
464     {
465         uint256 _rId = rId;
466         uint256 _sId = sId;
467         uint256 _crossStageNum = 1;
468         uint256 _protectTotalAmount;
469         uint256 _dividendTotalAmount;
470             
471         while(true){
472 
473             if(_crossStageNum == 1){
474                 playerDataRecord(
475                     _rId, 
476                     _sId, 
477                     _amount, 
478                     _stageTargetBalance, 
479                     _stepSize, 
480                     _protectRatio, 
481                     _crossStageNum
482                     );
483                 round[_rId].amount = round[_rId].amount.add(_amount);
484                 round[_rId].protectAmount = round[_rId].protectAmount.add(
485                     _amount.mul(_protectRatio.mul(88)) / 10000);    
486             }
487                 
488             buyStageDataRecord(
489                 _rId, 
490                 _sId, 
491                 _targetAmount, 
492                 _stageTargetBalance, 
493                 _sId.
494                 add(_stepSize), 
495                 _protectRatio
496                 );
497             _dividendTotalAmount = _dividendTotalAmount.add(stage[_rId][_sId].dividendAmount);
498             _protectTotalAmount = _protectTotalAmount.add(stage[_rId][_sId].protectAmount);
499             
500             _sId++;
501             _amount = _amount.sub(_stageTargetBalance);
502             _targetAmount = 
503                 stage[_rId][_sId].dividendAmount <= getStageTargetAmount(_sId) ? 
504                 getStageTargetAmount(_sId) : stage[_rId][_sId].dividendAmount;
505             _targetAmount = _targetAmount.mul(100) / 88;
506             _stageTargetBalance = _targetAmount;
507             _crossStageNum++;
508             if(_stageTargetBalance >= _amount){
509                 buyStageDataRecord(
510                     _rId, 
511                     _sId, 
512                     _targetAmount, 
513                     _amount, 
514                     _sId.add(_stepSize), 
515                     _protectRatio
516                     );
517                 playerDataRecord(
518                     _rId, 
519                     _sId, 
520                     0, 
521                     _amount, 
522                     _stepSize, 
523                     _protectRatio, 
524                     _crossStageNum
525                     );
526                     
527                 if(_targetAmount == _amount)
528                     _sId++;
529                     
530                 stage[_rId][_sId].start = now;
531                 sId = _sId;
532                 
533                 round[_rId].protectAmount = round[_rId].protectAmount.sub(_protectTotalAmount);
534                 round[_rId].dividendAmount = round[_rId].dividendAmount.add(_dividendTotalAmount);
535                 break;
536             }
537         }
538     }
539     
540     /**
541      * Records all data.
542      */
543     function buyDataRecord(uint256 _rId, uint256 _sId, uint256 _targetAmount, uint256 _amount, uint256 _stepSize, uint256 _protectRatio)
544         private
545     {
546         uint256 _expectEndSid = _sId.add(_stepSize);
547         uint256 _protectAmount = _amount.mul(_protectRatio.mul(88)) / 10000;
548         
549         round[_rId].amount = round[_rId].amount.add(_amount);
550         round[_rId].protectAmount = round[_rId].protectAmount.add(_protectAmount);
551         
552         stage[_rId][_sId].amount = stage[_rId][_sId].amount.add(_amount);
553         stage[_rId][_expectEndSid].protectAmount = stage[_rId][_expectEndSid].protectAmount.add(_protectAmount);
554         stage[_rId][_expectEndSid].dividendAmount = 
555             stage[_rId][_expectEndSid].dividendAmount.add(
556                 computeEarningsAmount(_sId, 
557                 _amount, 
558                 _targetAmount, 
559                 _expectEndSid, 
560                 100 - _protectRatio
561                 )
562                 );
563                 
564         FBankdatasets.Goods memory _goods;
565         _goods.rId = _rId;
566         _goods.startSid = _sId;
567         _goods.amount = _amount;
568         _goods.endSid = _expectEndSid;
569         _goods.protectRatio = _protectRatio;
570         playerGoodsList[msg.sender].push(goodsList.push(_goods) - 1);
571     }
572     
573     /**
574      * Records the stage data.
575      */
576     function buyStageDataRecord(uint256 _rId, uint256 _sId, uint256 _targetAmount, uint256 _amount, uint256 _expectEndSid, uint256 _protectRatio)
577         private
578     {
579         uint256 _protectAmount = _amount.mul(_protectRatio.mul(88)) / 10000;
580         
581         if(_targetAmount != _amount)
582             stage[_rId][_sId].amount = stage[_rId][_sId].amount.add(_amount);
583         stage[_rId][_expectEndSid].protectAmount = stage[_rId][_expectEndSid].protectAmount.add(_protectAmount);
584         stage[_rId][_expectEndSid].dividendAmount = 
585             stage[_rId][_expectEndSid].dividendAmount.add(
586                 computeEarningsAmount(
587                     _sId, 
588                     _amount, 
589                     _targetAmount, 
590                     _expectEndSid, 
591                     100 - _protectRatio
592                     )
593                 );
594     }
595     
596     /**
597      * Records the player data.
598      */
599     function playerDataRecord(uint256 _rId, uint256 _sId, uint256 _totalAmount, uint256 _stageBuyAmount, uint256 _stepSize, uint256 _protectRatio, uint256 _crossStageNum)
600         private
601     {    
602         if(_crossStageNum <= 1){
603             FBankdatasets.Goods memory _goods;
604             _goods.rId = _rId;
605             _goods.startSid = _sId;
606             _goods.amount = _totalAmount;
607             _goods.stepSize = _stepSize;
608             _goods.protectRatio = _protectRatio;
609             if(_crossStageNum == 1)
610                 _goods.startAmount = _stageBuyAmount;
611             playerGoodsList[msg.sender].push(goodsList.push(_goods) - 1);
612         }
613         else{
614             uint256 _goodsIndex = goodsList.length - 1;
615             goodsList[_goodsIndex].endAmount = _stageBuyAmount;
616             goodsList[_goodsIndex].endSid = _sId;
617         }
618         
619     }
620     
621     function bankerFeeDataRecord(uint256 _amount, uint256 _protectRatio)
622         private
623     {
624         round[rId].jackpotAmount = round[rId].jackpotAmount.add(_amount.mul(9).div(100));
625 
626         uint256 _cardAmount = _amount / 100;
627         if(_protectRatio == 0)
628             cardList[0].playerAddress.send(_cardAmount);
629         else if(_protectRatio > 0 && _protectRatio < 57)
630             cardList[1].playerAddress.send(_cardAmount);   
631         else if(_protectRatio == 57)
632             cardList[2].playerAddress.send(_cardAmount);   
633         else if(_protectRatio > 57 && _protectRatio < 100)
634             cardList[3].playerAddress.send(_cardAmount);   
635         else if(_protectRatio == 100)
636             cardList[4].playerAddress.send(_cardAmount);   
637         
638         fairProfitContract.send(_amount.div(50));
639     }
640     
641     function endRound(uint256 _rId, uint256 _sId)
642         private
643     {
644         round[_rId].end = now;
645         round[_rId].ended = true;
646         round[_rId].endSid = _sId;
647         
648         if(stage[_rId][_sId].amount > 0)
649             round[_rId + 1].jackpotAmount = (
650                 round[_rId].jackpotAmount.add(round[_rId].amount.mul(88) / 100)
651                 .sub(round[_rId].protectAmount)
652                 .sub(round[_rId].dividendAmount)
653             ).mul(20).div(100);
654         else
655             round[_rId + 1].jackpotAmount = (
656                 round[_rId].jackpotAmount.add(round[_rId].amount.mul(88) / 100)
657                 .sub(round[_rId].protectAmount)
658                 .sub(round[_rId].dividendAmount)
659             );
660         
661         round[_rId + 1].start = now;
662         rId++;
663         sId = 1;
664     }
665     
666     function getStageTargetAmount(uint256 _sId)
667         public
668         view
669         returns(uint256)
670     {
671         return bankCompute.getStageTargetAmount(_sId);
672     }
673     
674     function computeEarningsAmount(uint256 _sId, uint256 _amount, uint256 _currentTargetAmount, uint256 _expectEndSid, uint256 _ratio)
675         public
676         view
677         returns(uint256)
678     {
679         return bankCompute.computeEarningsAmount(_sId, _amount, _currentTargetAmount, _expectEndSid, _ratio);
680     }
681     
682     function getEarningsAmountByGoodsIndex(uint256 _goodsIndex)
683         public
684         view
685         returns(uint256, uint256, uint256, bool)
686     {
687         FBankdatasets.Goods memory _goods = goodsList[_goodsIndex];
688         uint256 _sId = sId;
689         uint256 _amount;
690         uint256 _targetExpectedAmount;
691         uint256 _targetAmount;
692         if(_goods.stepSize == 0){
693             if(round[_goods.rId].ended == true){
694                 if(round[_goods.rId].endSid > _goods.endSid){
695                     _targetExpectedAmount = getStageTargetAmount(_goods.startSid);
696                     _targetAmount = 
697                         stage[_goods.rId][_goods.startSid].dividendAmount <= _targetExpectedAmount ? 
698                         _targetExpectedAmount : stage[_goods.rId][_goods.startSid].dividendAmount;
699                     _targetAmount = _targetAmount.mul(100) / 88;
700                     _amount = computeEarningsAmount(
701                         _goods.startSid, 
702                         _goods.amount, 
703                         _targetAmount, 
704                         _goods.endSid, 
705                         100 - _goods.protectRatio
706                         );
707                     
708                 }else
709                     _amount = _goods.amount.mul(_goods.protectRatio.mul(88)) / 10000;
710                     
711                 if(round[_goods.rId].endSid == _goods.startSid)
712                     _amount = _amount.add(
713                         _goods.amount.mul(
714                             getRoundJackpot(_goods.rId)
715                             ).div(stage[_goods.rId][_goods.startSid].amount)
716                             );
717                 
718                 return (_amount, 0, 0, true);
719             }else{
720                 if(_sId > _goods.endSid){
721                     _targetExpectedAmount = getStageTargetAmount(_goods.startSid);
722                     _targetAmount = 
723                         stage[_goods.rId][_goods.startSid].dividendAmount <= _targetExpectedAmount ?
724                         _targetExpectedAmount : stage[_goods.rId][_goods.startSid].dividendAmount;
725                     _targetAmount = _targetAmount.mul(100) / 88;
726                     _amount = computeEarningsAmount(
727                         _goods.startSid, 
728                         _goods.amount, 
729                         _targetAmount, 
730                         _goods.endSid, 
731                         100 - _goods.protectRatio
732                         );
733                 }else
734                     return (0, 0, 0, false);
735             }
736             return (_amount, 0, 0, true);
737             
738         }else{
739             
740             uint256 _startSid = _goods.withdrawSid == 0 ? _goods.startSid : _goods.withdrawSid;
741             uint256 _ratio = 100 - _goods.protectRatio;
742             uint256 _reachAmount = _goods.reachAmount;
743             if(round[_goods.rId].ended == true){
744                 
745                 while(true){
746                     
747                     if(_startSid - (_goods.withdrawSid == 0 ? _goods.startSid : _goods.withdrawSid) > 100){
748                         return (_amount, _startSid, _reachAmount, false);
749                     }
750                     
751                     if(round[_goods.rId].endSid > _startSid.add(_goods.stepSize)){
752                         _targetExpectedAmount = getStageTargetAmount(_startSid);
753                         _targetAmount = 
754                             stage[_goods.rId][_startSid].dividendAmount <= _targetExpectedAmount ? 
755                             _targetExpectedAmount : stage[_goods.rId][_startSid].dividendAmount;
756                         _targetAmount = _targetAmount.mul(100) / 88;
757                         if(_startSid == _goods.endSid){
758                             _amount = _amount.add(
759                                 computeEarningsAmount(
760                                     _startSid, 
761                                     _goods.endAmount, 
762                                     _targetAmount, 
763                                     _startSid.add(_goods.stepSize), 
764                                     _ratio
765                                     )
766                                 );
767                             return (_amount, _goods.endSid, 0, true);
768                         }
769                         _amount = _amount.add(
770                             computeEarningsAmount(
771                                 _startSid, 
772                                 _startSid == _goods.startSid ? _goods.startAmount : _targetAmount, 
773                                 _targetAmount, 
774                                 _startSid.add(_goods.stepSize), 
775                                 _ratio
776                                 )
777                             );
778                         _reachAmount = 
779                             _reachAmount.add(
780                                 _startSid == _goods.startSid ? _goods.startAmount : _targetAmount
781                             );
782                     }else{
783                         
784                         _amount = _amount.add(
785                             (_goods.amount.sub(_reachAmount))
786                             .mul(_goods.protectRatio.mul(88)) / 10000
787                             );
788                         
789                         if(round[_goods.rId].endSid == _goods.endSid)
790                             _amount = _amount.add(
791                                 _goods.endAmount.mul(getRoundJackpot(_goods.rId))
792                                 .div(stage[_goods.rId][_goods.endSid].amount)
793                                 );
794                         
795                         return (_amount, _goods.endSid, 0, true);
796                     }
797                     
798                     _startSid++;
799                 }
800                 
801             }else{
802                 while(true){
803                     
804                     if(_startSid - (_goods.withdrawSid == 0 ? _goods.startSid : _goods.withdrawSid) > 100){
805                         return (_amount, _startSid, _reachAmount, false);
806                     }
807                     
808                     if(_sId > _startSid.add(_goods.stepSize)){
809                         _targetExpectedAmount = getStageTargetAmount(_startSid);
810                         _targetAmount = 
811                             stage[_goods.rId][_startSid].dividendAmount <= _targetExpectedAmount ? 
812                             _targetExpectedAmount : stage[_goods.rId][_startSid].dividendAmount;
813                         _targetAmount = _targetAmount.mul(100) / 88;
814                         if(_startSid == _goods.endSid){
815                             _amount = _amount.add(
816                                 computeEarningsAmount(
817                                     _startSid, 
818                                     _goods.endAmount, 
819                                     _targetAmount, 
820                                     _startSid.add(_goods.stepSize), 
821                                     _ratio
822                                     )
823                                 );
824                             return (_amount, _goods.endSid, 0, true);
825                         }
826                         _amount = _amount.add(
827                             computeEarningsAmount(
828                                 _startSid, 
829                                 _startSid == _goods.startSid ? _goods.startAmount : _targetAmount, 
830                                 _targetAmount, 
831                                 _startSid.add(_goods.stepSize), 
832                                 _ratio
833                                 )
834                             );
835                         _reachAmount = 
836                             _reachAmount.add(
837                                 _startSid == _goods.startSid ? 
838                                 _goods.startAmount : _targetAmount
839                             );
840                     }else    
841                         return (_amount, _startSid, _reachAmount, false);
842                     
843                     _startSid++;
844                 }
845             }
846         }
847     }
848     
849     function getRoundJackpot(uint256 _rId)
850         public
851         view
852         returns(uint256)
853     {
854         return (
855             (
856                 round[_rId].jackpotAmount
857                 .add(round[_rId].amount.mul(88) / 100))
858                 .sub(round[_rId].protectAmount)
859                 .sub(round[_rId].dividendAmount)
860             ).mul(80).div(100);
861     }
862     
863     function getHeadInfo()
864         public
865         view
866         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256)
867     {
868         uint256 _targetExpectedAmount = getStageTargetAmount(sId);
869         
870         return
871             (
872                 rId,
873                 sId,
874                 startTime,
875                 stage[rId][sId].start.add(stageDuration),
876                 stage[rId][sId].amount,
877                 (
878                     stage[rId][sId].dividendAmount <= _targetExpectedAmount ? 
879                     _targetExpectedAmount : stage[rId][sId].dividendAmount
880                 ).mul(100) / 88,
881                 round[rId].jackpotAmount.add(round[rId].amount.mul(88) / 100)
882                 .sub(round[rId].protectAmount)
883                 .sub(round[rId].dividendAmount)
884             );
885     }
886     
887     function getPlayerGoodList(address _player)
888         public
889         view
890         returns(uint256[])
891     {
892         return playerGoodsList[_player];
893     }
894 
895     function totalSupply() 
896         public 
897         view 
898         returns (uint256 total)
899     {
900         return cardList.length;
901     }
902     
903     function balanceOf(address _owner) 
904         public 
905         view 
906         returns (uint256 balance)
907     {
908         uint256 _length = cardList.length;
909         uint256 _count;
910         for(uint256 i = 0; i < _length; i++){
911             if(cardList[i].playerAddress == _owner)
912                 _count++;
913         }
914         
915         return _count;
916     }
917     
918     function ownerOf(uint256 _tokenId) 
919         public 
920         view 
921         returns (address owner)
922     {
923         require(cardList.length > _tokenId, "tokenId error");
924         owner = cardList[_tokenId].playerAddress;
925         require(owner != address(0), "No owner");
926     }
927     
928     function approve(address _to, uint256 _tokenId)
929         senderVerify()
930         public
931     {
932         require (player[_to], "Not a registered user");
933         require (msg.sender == cardList[_tokenId].playerAddress, "The card does not belong to you");
934         require (cardList.length > _tokenId, "tokenId error");
935         require (cardIndexToApproved[_tokenId] == address(0), "Approved");
936         
937         cardIndexToApproved[_tokenId] = _to;
938         
939         emit Approval(msg.sender, _to, _tokenId);
940     }
941     
942     function takeOwnership(uint256 _tokenId)
943         senderVerify()
944         public
945     {
946         address _newOwner = msg.sender;
947         address _oldOwner = cardList[_tokenId].playerAddress;
948         
949         require(_newOwner != address(0), "Address error");
950         require(_newOwner == cardIndexToApproved[_tokenId], "Without permission");
951         
952         cardList[_tokenId].playerAddress = _newOwner;
953         delete cardIndexToApproved[_tokenId];
954         
955         emit Transfer(_oldOwner, _newOwner, _tokenId);
956     }
957     
958     function transfer(address _to, uint256 _tokenId) 
959         senderVerify()
960         public
961     {
962         require (msg.sender == cardList[_tokenId].playerAddress, "The card does not belong to you");
963         require(_to != address(0), "Address error");
964         require(_to == cardIndexToApproved[_tokenId], "Without permission");
965         
966         cardList[_tokenId].playerAddress = _to;
967         
968         if(cardIndexToApproved[_tokenId] != address(0))
969             delete cardIndexToApproved[_tokenId];
970         
971         emit Transfer(msg.sender, _to, _tokenId);
972     }
973     
974     function transferFrom(address _from, address _to, uint256 _tokenId)
975         senderVerify()
976         public
977     {
978         require (_from == cardList[_tokenId].playerAddress, "Owner error");
979         require(_to != address(0), "Address error");
980         require(_to == cardIndexToApproved[_tokenId], "Without permission");
981         
982         cardList[_tokenId].playerAddress = _to;
983         delete cardIndexToApproved[_tokenId];
984         
985         emit Transfer(_from, _to, _tokenId);
986     }
987     
988 }
989 
990 library FBankdatasets {
991     
992     struct Round {
993         uint256 start;
994         uint256 end;
995         bool ended;
996         uint256 endSid;
997         uint256 amount;
998         uint256 protectAmount;
999         uint256 dividendAmount;
1000         uint256 jackpotAmount;
1001     }
1002     
1003     struct Stage {
1004         uint256 start;
1005         uint256 amount;
1006         uint256 protectAmount;
1007         uint256 dividendAmount;
1008     }
1009     
1010     struct Goods {
1011         uint256 rId;
1012         uint256 startSid;
1013         uint256 endSid;
1014         uint256 withdrawSid;
1015         uint256 amount;
1016         uint256 startAmount;
1017         uint256 endAmount;
1018         uint256 reachAmount;
1019         uint256 stepSize;
1020         uint256 protectRatio;
1021     }
1022     
1023     struct Card {
1024         address playerAddress;
1025         uint256 amount;
1026     }
1027 }
1028 
1029 /**
1030  * Anti clone protection.
1031  * Do not clone this contract without permission even if you manage to break the conceal. 
1032  * The concealed code contains core calculations necessary for this contract to function. 
1033  * This contract can be licensed for a fee, contact us instead of cloning!
1034  */ 
1035 interface FairBankCompute {
1036     function getStageTargetAmount(uint256 _sId) external view returns(uint256);
1037     function computeEarningsAmount(uint256 _sId, uint256 _amount, uint256 _currentTargetAmount, uint256 _expectEndSid, uint256 _ratio) external view returns(uint256);
1038 }
1039 
1040 /**
1041  * @title SafeMath v0.1.9
1042  * @dev Math operations with safety checks that throw on error
1043  */
1044 library SafeMath {
1045     
1046     /**
1047     * @dev Adds two numbers, throws on overflow.
1048     */
1049     function add(uint256 a, uint256 b) 
1050         internal 
1051         pure 
1052         returns (uint256) 
1053     {
1054         uint256 c = a + b;
1055         assert(c >= a);
1056         return c;
1057     }
1058     
1059     /**
1060     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1061     */
1062     function sub(uint256 a, uint256 b) 
1063         internal 
1064         pure 
1065         returns (uint256) 
1066     {
1067         assert(b <= a);
1068         return a - b;
1069     }
1070 
1071     /**
1072     * @dev Multiplies two numbers, throws on overflow.
1073     */
1074     function mul(uint256 a, uint256 b) 
1075         internal 
1076         pure 
1077         returns (uint256) 
1078     {
1079         if (a == 0) {
1080             return 0;
1081         }
1082         uint256 c = a * b;
1083         assert(c / a == b);
1084         return c;
1085     }
1086     
1087     /**
1088     * @dev Integer division of two numbers, truncating the quotient.
1089     */
1090     function div(uint256 a, uint256 b) 
1091         internal 
1092         pure 
1093         returns (uint256) 
1094     {
1095         assert(b > 0); // Solidity automatically throws when dividing by 0
1096         uint256 c = a / b;
1097         assert(a == b * c + a % b); // There is no case in which this doesn't hold
1098         return c;
1099     }
1100     
1101     /**
1102      * @dev gives square root of given x.
1103      */
1104     function sqrt(uint256 x)
1105         internal
1106         pure
1107         returns (uint256 y) 
1108     {
1109         uint256 z = ((add(x,1)) / 2);
1110         y = x;
1111         while (z < y) 
1112         {
1113             y = z;
1114             z = ((add((x / z),z)) / 2);
1115         }
1116     }
1117     
1118     /**
1119      * @dev gives square. multiplies x by x
1120      */
1121     function sq(uint256 x)
1122         internal
1123         pure
1124         returns (uint256)
1125     {
1126         return (mul(x,x));
1127     }
1128     
1129     /**
1130      * @dev x to the power of y 
1131      */
1132     function pwr(uint256 x, uint256 y)
1133         internal 
1134         pure 
1135         returns (uint256)
1136     {
1137         if (x==0)
1138             return (0);
1139         else if (y==0)
1140             return (1);
1141         else 
1142         {
1143             uint256 z = x;
1144             for (uint256 i=1; i < y; i++)
1145                 z = mul(z,x);
1146             return (z);
1147         }
1148     }
1149 }