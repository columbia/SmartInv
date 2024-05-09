1 pragma solidity ^0.4.25;
2 
3 /**
4  *
5  *  https://fairdapp.com/bank/  https://fairdapp.com/bank/   https://fairdapp.com/bank/
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
21  *         ______ _             _                            
22  *        / _____|_)           | |         _                 
23  *       ( (____  _ ____  _   _| | _____ _| |_ ___   ____    
24  *        \____ \| |    \| | | | |(____ (_   _) _ \ / ___)   
25  *        _____) ) | | | | |_| | |/ ___ | | || |_| | |       
26  *       (______/|_|_|_|_|____/ \_)_____|  \__)___/|_|       
27  *                                                   
28  *   
29  *  Warning:
30  *     
31  *  FairDAPP – Bank Simulator (actually this probably has more resemblance 
32  *  of a government bond simulator but Bank is a more catchy name)
33  *  is a system designed to explore how a real world financial bank would
34  *  operate during a financial collapse without quantitative easing and bail outs.
35  *  This system is simulated through open source smart contract codes and pre-defined rules.
36  *  This contract may only be used internally for study purposes and all could be 
37  *  lost by sending anything to this contract address. 
38  *  All users are prohibited to interact with this contract if this 
39  *  contract is in conflict with user’s local regulations or laws.
40  * 
41  *  -Original Contract built by the FairDAPP Community
42  *  -Code Audited by 8Bit & Etherguy (formula calculations are excluded from the audit)
43  *  
44  *  -The contract has an activation switch to activate the system.
45  *  -The resetTime and reduceTime functions have an on and off switch which the developer owner can control.
46  *  -No one can change anything else once the contract has been deployed.
47  *  
48  *  -No anti-whales and almost no restrictions on what a user can do!
49  *  -There is no need to FOMO, early players have no significant advantage over later players.
50  *      -Scaling is slow, the system is designed for players to stake many stages. 
51  *  -The contract is fully solvent in any event (assuming there are no bugs).
52  *      -ie. The contract will always payout what it owes. 
53  *
54 **/
55 
56 
57 contract ERC721{
58     
59     function totalSupply() public view returns (uint256 total);
60     function balanceOf(address _owner) public view returns (uint256 balance);
61     function ownerOf(uint256 _tokenId) public view returns (address owner);
62     function approve(address _to, uint256 _tokenId) public;
63     function takeOwnership(uint256 _tokenId) public;
64     function transfer(address _to, uint256 _tokenId) public;
65     function transferFrom(address _from, address _to, uint256 _tokenId) public;
66     
67     event Transfer(address from, address to, uint256 tokenId);
68     event Approval(address owner, address approved, uint256 tokenId);
69 }
70 
71 contract FairBank is ERC721{
72     using SafeMath for uint256;
73     using NameFilter for string;
74     address public developerAddr;
75 
76     string public name = "FairDAPP - Bank Simulator";
77     string public symbol = "FBank";
78     
79     uint256 public stageDuration;
80     uint256 public standardProtectRatio;
81     bool public activated = false;
82     bool public modifyCountdown = false;
83     
84     uint256 public rId;
85     uint256 public sId;
86     
87     mapping (uint256 => FBankdatasets.Round) public round;
88     mapping (uint256 => mapping (uint256 => FBankdatasets.Stage)) public stage;
89     
90     mapping (address => bytes32) public register;
91     mapping (bytes32 => address) public playerName;
92     
93     mapping (address => uint256[]) public playerGoodsList;
94     mapping (address => uint256[]) public playerWithdrawList;
95     
96     /**
97      * Anti clone protection.
98      * Do not clone this contract without permission even if you manage to break the conceal. 
99      * The concealed code contains core calculations necessary for this contract to function, read line 1058. 
100      * This contract can be licensed for a fee, contact us instead of cloning!
101      */ 
102     FairBankCompute constant private bankCompute = FairBankCompute(0x26DA117A72DBcB686c2FCF88c4BFC6110cAe0464);
103     
104     FBankdatasets.Goods[] public goodsList;
105     
106     FBankdatasets.Card[6] public cardList;
107     mapping (uint256 => address) public cardIndexToApproved;
108     
109     modifier registerVerify() {
110         require(msg.value == 10000000000000000, "registration fee is 0.01 ether, please set the exact amount");
111         _;
112     }
113     
114     modifier isActivated() {
115         require(activated == true, "FairBank its not ready yet.  check ?eta in discord"); 
116         _;
117     }
118     
119     modifier isDeveloperAddr() {
120         require(msg.sender == developerAddr, "Permission denied");
121         _;
122     }
123     
124     modifier modifyCountdownVerify() {
125         require(modifyCountdown == true, "this feature is not turned on or has been turned off"); 
126         _;
127     }
128      
129     modifier senderVerify() {
130         require (msg.sender == tx.origin, "sender does not meet the rules");
131         _;
132     }
133     
134     /**
135      * Don't toy or spam the contract, it may raise the gas cost for everyone else.
136      * The scientists will take anything below 0.001 ETH sent to the contract.
137      * Thank you for your donation.
138      */
139     modifier amountVerify() {
140         if(msg.value < 1000000000000000){
141             developerAddr.send(msg.value);
142         }else{
143             require(msg.value >= 1000000000000000, "minimum amount is 0.001 ether");
144             _;
145         }
146     }
147     
148     modifier playerVerify() {
149         require(playerGoodsList[msg.sender].length > 0, "user has not purchased the product or has completed the withdrawal");
150         _;
151     }
152     
153     modifier stepSizeVerify(uint256 _stepSize) {
154         require(_stepSize <= 1000000, "step size must not exceed 1000000");
155         _;
156     }
157     
158     constructor()
159         public
160     {
161         developerAddr = msg.sender;
162         
163         stageDuration = 64800;
164         standardProtectRatio = 57;
165         uint256 i;
166         while(i < cardList.length){
167             cardList[i].playerAddress = developerAddr;
168             cardList[i].amount = 5000000000000000000; 
169             i++;
170         }
171     }
172     
173     function registered(string _playerName)
174         senderVerify()
175         registerVerify()
176         payable
177         public
178     {
179         bytes32 _name = _playerName.nameFilter();
180         require(_name != bytes32(0), "name cannot be empty");
181         require(playerName[_name] == address(0), "this name has already been registered");
182         require(register[msg.sender] == bytes32(0), "please do not repeat registration");
183         
184         playerName[_name] = msg.sender;
185         register[msg.sender] = _name;
186         developerAddr.send(msg.value);
187     }
188     
189     /**
190      * Activation of contract with settings
191      */
192     function activate()
193         senderVerify()
194         isDeveloperAddr()
195         public
196     {
197         require(activated == false, "FairBank already activated");
198         
199         activated = true;
200         rId = 1;
201         sId = 1;
202         round[rId].start = now;
203         stage[rId][sId].start = now;
204     }
205     
206     function openModifyCountdown()
207         senderVerify()
208         isDeveloperAddr()
209         public
210     {
211         require(modifyCountdown == false, "Time service is already open");
212         
213         modifyCountdown = true;
214         
215     }
216     
217     function closeModifyCountdown()
218         senderVerify()
219         isDeveloperAddr()
220         public
221     {
222         require(modifyCountdown == true, "Time service is already open");
223         
224         modifyCountdown = false;
225         
226     }
227     
228     function purchaseCard(uint256 _cId)
229         isActivated()
230         senderVerify()
231         payable
232         public
233     {
234         
235         address _player = msg.sender;
236         uint256 _amount = msg.value;
237         uint256 _purchasePrice = cardList[_cId].amount.mul(110) / 100;
238         
239         require(
240             cardList[_cId].playerAddress != address(0) 
241             && cardList[_cId].playerAddress != _player 
242             && _amount >= _purchasePrice, 
243             "Failed purchase"
244         );
245         
246         if(cardIndexToApproved[_cId] != address(0)){
247             cardIndexToApproved[_cId].send(
248                 cardList[_cId].amount.mul(105) / 100
249                 );
250             delete cardIndexToApproved[_cId];
251         }else
252             cardList[_cId].playerAddress.send(
253                 cardList[_cId].amount.mul(105) / 100
254                 );
255                 
256         developerAddr.send(cardList[_cId].amount.mul(5) / 100);
257         if(_amount > _purchasePrice)
258             _player.send(_amount.sub(_purchasePrice));
259             
260         cardList[_cId].amount = _purchasePrice;
261         cardList[_cId].playerAddress = _player;
262         
263     }
264     
265     /**
266      * Fallback function to handle ethereum that was send straight to the contract
267      * Unfortunately we cannot use a referral address this way.
268      */
269     function()
270         isActivated()
271         senderVerify()
272         amountVerify()
273         payable
274         public
275     {
276         buyAnalysis(100, standardProtectRatio, address(0));
277     }
278 
279     function buy(uint256 _stepSize, uint256 _protectRatio, address _recommendAddr)
280         isActivated()
281         senderVerify()
282         amountVerify()
283         stepSizeVerify(_stepSize)
284         public
285         payable
286     {
287         buyAnalysis(
288             _stepSize <= 0 ? 100 : _stepSize, 
289             _protectRatio <= 100 ? _protectRatio : standardProtectRatio, 
290             _recommendAddr
291             );
292     }
293     
294     function buyXname(uint256 _stepSize, uint256 _protectRatio, string _recommendName)
295         isActivated()
296         senderVerify()
297         amountVerify()
298         stepSizeVerify(_stepSize)
299         public
300         payable
301     {
302         buyAnalysis(
303             _stepSize <= 0 ? 100 : _stepSize, 
304             _protectRatio <= 100 ? _protectRatio : standardProtectRatio, 
305             playerName[_recommendName.nameFilter()]
306             );
307     }
308     
309     /**
310      * Standard withdraw function.
311      */
312     function withdraw()
313         isActivated()
314         senderVerify()
315         playerVerify()
316         public
317     {
318         
319         address _player = msg.sender;
320         uint256[] memory _playerGoodsList = playerGoodsList[_player];
321         uint256 length = _playerGoodsList.length;
322         uint256 _totalAmount;
323         uint256 _amount;
324         uint256 _withdrawSid;
325         uint256 _reachAmount;
326         bool _finish;
327         uint256 i;
328         
329         delete playerGoodsList[_player];
330         while(i < length){
331             
332             (_amount, _withdrawSid, _reachAmount, _finish) = getEarningsAmountByGoodsIndex(_playerGoodsList[i]);
333             
334             if(_finish == true){
335                 playerWithdrawList[_player].push(_playerGoodsList[i]);
336             }else{
337                 goodsList[_playerGoodsList[i]].withdrawSid = _withdrawSid;
338                 goodsList[_playerGoodsList[i]].reachAmount = _reachAmount;
339                 playerGoodsList[_player].push(_playerGoodsList[i]);
340             }
341             
342             _totalAmount = _totalAmount.add(_amount);
343             i++;
344         }
345         _player.transfer(_totalAmount);
346     }
347      
348      /**
349      * Backup withdraw function in case gas is too high to use standard withdraw.
350      */
351     function withdrawByGid(uint256 _gId)
352         isActivated()
353         senderVerify()
354         playerVerify()
355         public
356     {
357         address _player = msg.sender;
358         uint256 _amount;
359         uint256 _withdrawSid;
360         uint256 _reachAmount;
361         bool _finish;
362         
363         (_amount, _withdrawSid, _reachAmount, _finish) = getEarningsAmountByGoodsIndex(_gId);
364             
365         if(_finish == true){
366             
367             for(uint256 i = 0; i < playerGoodsList[_player].length; i++){
368                 if(playerGoodsList[_player][i] == _gId)
369                     break;
370             }
371             require(i < playerGoodsList[_player].length, "gid is wrong");
372             
373             playerWithdrawList[_player].push(_gId);
374             playerGoodsList[_player][i] = playerGoodsList[_player][playerGoodsList[_player].length - 1];
375             playerGoodsList[_player].length--;
376         }else{
377             goodsList[_gId].withdrawSid = _withdrawSid;
378             goodsList[_gId].reachAmount = _reachAmount;
379         }
380         
381         _player.transfer(_amount);
382     }
383     
384     function resetTime()
385         modifyCountdownVerify()
386         senderVerify()
387         public
388         payable
389     {
390         uint256 _rId = rId;
391         uint256 _sId = sId;
392         uint256 _amount = msg.value;
393         uint256 _targetExpectedAmount = getStageTargetAmount(_sId);
394         uint256 _targetAmount = 
395             stage[_rId][_sId].dividendAmount <= _targetExpectedAmount ? 
396             _targetExpectedAmount : stage[_rId][_sId].dividendAmount;
397             _targetAmount = _targetAmount.mul(100) / 88;
398         uint256 _costAmount = _targetAmount.mul(20) / 100;
399         
400         if(_costAmount > 3 ether)
401             _costAmount = 3 ether;
402         require(_amount >= _costAmount, "Not enough price");
403         
404         stage[_rId][_sId].start = now;
405         
406         cardList[5].playerAddress.send(_costAmount / 2);
407         developerAddr.send(_costAmount / 2);
408         
409         if(_amount > _costAmount)
410             msg.sender.send(_amount.sub(_costAmount));
411         
412     }
413     
414     function reduceTime()
415         modifyCountdownVerify()
416         senderVerify()
417         public
418         payable
419     {
420         uint256 _rId = rId;
421         uint256 _sId = sId;
422         uint256 _amount = msg.value;
423         uint256 _targetExpectedAmount = getStageTargetAmount(_sId);
424         uint256 _targetAmount = 
425             stage[_rId][_sId].dividendAmount <= _targetExpectedAmount ?
426             _targetExpectedAmount : stage[_rId][_sId].dividendAmount;
427             _targetAmount = _targetAmount.mul(100) / 88;
428         uint256 _costAmount = _targetAmount.mul(30) / 100;
429         
430         if(_costAmount > 3 ether)
431             _costAmount = 3 ether;
432         require(_amount >= _costAmount, "Not enough price");
433         
434         stage[_rId][_sId].start = now - stageDuration + 1800;
435         
436         cardList[5].playerAddress.send(_costAmount / 2);
437         developerAddr.send(_costAmount / 2);
438         
439         if(_amount > _costAmount)
440             msg.sender.send(_amount.sub(_costAmount));
441         
442     }
443     
444     /**
445      * Core logic to analyse buy behaviour. 
446      */
447     function buyAnalysis(uint256 _stepSize, uint256 _protectRatio, address _recommendAddr)
448         private
449     {
450         uint256 _rId = rId;
451         uint256 _sId = sId;
452         uint256 _targetExpectedAmount = getStageTargetAmount(_sId);
453         uint256 _targetAmount = 
454             stage[_rId][_sId].dividendAmount <= _targetExpectedAmount ? 
455             _targetExpectedAmount : stage[_rId][_sId].dividendAmount;
456             _targetAmount = _targetAmount.mul(100) / 88;
457         uint256 _stageTargetBalance = 
458             stage[_rId][_sId].amount > 0 ? 
459             _targetAmount.sub(stage[_rId][_sId].amount) : _targetAmount;
460         
461         if(now > stage[_rId][_sId].start.add(stageDuration) 
462             && _targetAmount > stage[_rId][_sId].amount
463         ){
464             
465             endRound(_rId, _sId);
466             
467             _rId = rId;
468             _sId = sId;
469             stage[_rId][_sId].start = now;
470             
471             _targetExpectedAmount = getStageTargetAmount(_sId);
472             _targetAmount = 
473                 stage[_rId][_sId].dividendAmount <= _targetExpectedAmount ? 
474                 _targetExpectedAmount : stage[_rId][_sId].dividendAmount;
475             _targetAmount = _targetAmount.mul(100) / 88;
476             _stageTargetBalance = 
477                 stage[_rId][_sId].amount > 0 ? 
478                 _targetAmount.sub(stage[_rId][_sId].amount) : _targetAmount;
479         }
480         if(_stageTargetBalance > msg.value)
481             buyDataRecord(
482                 _rId, 
483                 _sId, 
484                 _targetAmount, 
485                 msg.value, 
486                 _stepSize, 
487                 _protectRatio
488                 );
489         else
490             multiStake(
491                 msg.value, 
492                 _stepSize, 
493                 _protectRatio, 
494                 _targetAmount, 
495                 _stageTargetBalance
496                 );
497         /* This is a backstop check to ensure that the contract will always be solvent.
498         It would reject any stakes with a protection ratio that the contract may not be able to repay.
499         This backstop should never be needed under current settings. */
500         require(
501             (
502                 round[_rId].jackpotAmount.add(round[_rId].amount.mul(88) / 100)
503                 .sub(round[_rId].protectAmount)
504                 .sub(round[_rId].dividendAmount)
505             ) > 0, "data error"
506         );    
507         bankerFeeDataRecord(_recommendAddr, msg.value, _protectRatio);    
508     }
509     
510     function multiStake(uint256 _amount, uint256 _stepSize, uint256 _protectRatio, uint256 _targetAmount, uint256 _stageTargetBalance)
511         private
512     {
513         uint256 _rId = rId;
514         uint256 _sId = sId;
515         uint256 _crossStageNum = 1;
516         uint256 _protectTotalAmount;
517         uint256 _dividendTotalAmount;
518             
519         while(true){
520 
521             if(_crossStageNum == 1){
522                 playerDataRecord(
523                     _rId, 
524                     _sId, 
525                     _amount, 
526                     _stageTargetBalance, 
527                     _stepSize, 
528                     _protectRatio, 
529                     _crossStageNum
530                     );
531                 round[_rId].amount = round[_rId].amount.add(_amount);
532                 round[_rId].protectAmount = round[_rId].protectAmount.add(
533                     _amount.mul(_protectRatio.mul(88)) / 10000);    
534             }
535                 
536             buyStageDataRecord(
537                 _rId, 
538                 _sId, 
539                 _targetAmount, 
540                 _stageTargetBalance, 
541                 _sId.
542                 add(_stepSize), 
543                 _protectRatio
544                 );
545             _dividendTotalAmount = _dividendTotalAmount.add(stage[_rId][_sId].dividendAmount);
546             _protectTotalAmount = _protectTotalAmount.add(stage[_rId][_sId].protectAmount);
547             
548             _sId++;
549             _amount = _amount.sub(_stageTargetBalance);
550             _targetAmount = 
551                 stage[_rId][_sId].dividendAmount <= getStageTargetAmount(_sId) ? 
552                 getStageTargetAmount(_sId) : stage[_rId][_sId].dividendAmount;
553             _targetAmount = _targetAmount.mul(100) / 88;
554             _stageTargetBalance = _targetAmount;
555             _crossStageNum++;
556             if(_stageTargetBalance >= _amount){
557                 buyStageDataRecord(
558                     _rId, 
559                     _sId, 
560                     _targetAmount, 
561                     _amount, 
562                     _sId.add(_stepSize), 
563                     _protectRatio
564                     );
565                 playerDataRecord(
566                     _rId, 
567                     _sId, 
568                     0, 
569                     _amount, 
570                     _stepSize, 
571                     _protectRatio, 
572                     _crossStageNum
573                     );
574                     
575                 if(_targetAmount == _amount)
576                     _sId++;
577                     
578                 stage[_rId][_sId].start = now;
579                 sId = _sId;
580                 
581                 round[_rId].protectAmount = round[_rId].protectAmount.sub(_protectTotalAmount);
582                 round[_rId].dividendAmount = round[_rId].dividendAmount.add(_dividendTotalAmount);
583                 break;
584             }
585         }
586     }
587     
588     /**
589      * Records all data.
590      */
591     function buyDataRecord(uint256 _rId, uint256 _sId, uint256 _targetAmount, uint256 _amount, uint256 _stepSize, uint256 _protectRatio)
592         private
593     {
594         uint256 _expectEndSid = _sId.add(_stepSize);
595         uint256 _protectAmount = _amount.mul(_protectRatio.mul(88)) / 10000;
596         
597         round[_rId].amount = round[_rId].amount.add(_amount);
598         round[_rId].protectAmount = round[_rId].protectAmount.add(_protectAmount);
599         
600         stage[_rId][_sId].amount = stage[_rId][_sId].amount.add(_amount);
601         stage[_rId][_expectEndSid].protectAmount = stage[_rId][_expectEndSid].protectAmount.add(_protectAmount);
602         stage[_rId][_expectEndSid].dividendAmount = 
603             stage[_rId][_expectEndSid].dividendAmount.add(
604                 computeEarningsAmount(_sId, 
605                 _amount, 
606                 _targetAmount, 
607                 _expectEndSid, 
608                 100 - _protectRatio
609                 )
610                 );
611                 
612         FBankdatasets.Goods memory _goods;
613         _goods.rId = _rId;
614         _goods.startSid = _sId;
615         _goods.amount = _amount;
616         _goods.endSid = _expectEndSid;
617         _goods.protectRatio = _protectRatio;
618         playerGoodsList[msg.sender].push(goodsList.push(_goods) - 1);
619     }
620     
621     /**
622      * Records the stage data.
623      */
624     function buyStageDataRecord(uint256 _rId, uint256 _sId, uint256 _targetAmount, uint256 _amount, uint256 _expectEndSid, uint256 _protectRatio)
625         private
626     {
627         uint256 _protectAmount = _amount.mul(_protectRatio.mul(88)) / 10000;
628         
629         if(_targetAmount != _amount)
630             stage[_rId][_sId].amount = stage[_rId][_sId].amount.add(_amount);
631         stage[_rId][_expectEndSid].protectAmount = stage[_rId][_expectEndSid].protectAmount.add(_protectAmount);
632         stage[_rId][_expectEndSid].dividendAmount = 
633             stage[_rId][_expectEndSid].dividendAmount.add(
634                 computeEarningsAmount(
635                     _sId, 
636                     _amount, 
637                     _targetAmount, 
638                     _expectEndSid, 
639                     100 - _protectRatio
640                     )
641                 );
642     }
643     
644     /**
645      * Records the player data.
646      */
647     function playerDataRecord(uint256 _rId, uint256 _sId, uint256 _totalAmount, uint256 _stageBuyAmount, uint256 _stepSize, uint256 _protectRatio, uint256 _crossStageNum)
648         private
649     {    
650         if(_crossStageNum <= 1){
651             FBankdatasets.Goods memory _goods;
652             _goods.rId = _rId;
653             _goods.startSid = _sId;
654             _goods.amount = _totalAmount;
655             _goods.stepSize = _stepSize;
656             _goods.protectRatio = _protectRatio;
657             if(_crossStageNum == 1)
658                 _goods.startAmount = _stageBuyAmount;
659             playerGoodsList[msg.sender].push(goodsList.push(_goods) - 1);
660         }
661         else{
662             uint256 _goodsIndex = goodsList.length - 1;
663             goodsList[_goodsIndex].endAmount = _stageBuyAmount;
664             goodsList[_goodsIndex].endSid = _sId;
665         }
666         
667     }
668     
669     function bankerFeeDataRecord(address _recommendAddr, uint256 _amount, uint256 _protectRatio)
670         private
671     {
672         uint256 _jackpotProportion = 80;
673         if(_recommendAddr != address(0) 
674             && _recommendAddr != msg.sender 
675             && (register[_recommendAddr] != bytes32(0))
676         ){
677             _recommendAddr.send(_amount / 50);
678             msg.sender.send(_amount / 100);
679         }
680         else
681             _jackpotProportion = 110;
682             
683         round[rId].jackpotAmount = round[rId].jackpotAmount.add(_amount.mul(_jackpotProportion).div(1000));
684 
685         uint256 _cardAmount = _amount / 200;
686         if(_protectRatio == 0)
687             cardList[0].playerAddress.send(_cardAmount);
688         else if(_protectRatio > 0 && _protectRatio < 57)
689             cardList[1].playerAddress.send(_cardAmount);   
690         else if(_protectRatio == 57)
691             cardList[2].playerAddress.send(_cardAmount);   
692         else if(_protectRatio > 57 && _protectRatio < 100)
693             cardList[3].playerAddress.send(_cardAmount);   
694         else if(_protectRatio == 100)
695             cardList[4].playerAddress.send(_cardAmount);   
696         
697         developerAddr.send(_amount / 200);
698     }
699     
700     function endRound(uint256 _rId, uint256 _sId)
701         private
702     {
703         round[_rId].end = now;
704         round[_rId].ended = true;
705         round[_rId].endSid = _sId;
706         
707         if(stage[_rId][_sId].amount > 0)
708             round[_rId + 1].jackpotAmount = (
709                 round[_rId].jackpotAmount.add(round[_rId].amount.mul(88) / 100)
710                 .sub(round[_rId].protectAmount)
711                 .sub(round[_rId].dividendAmount)
712             ).mul(20).div(100);
713         else
714             round[_rId + 1].jackpotAmount = (
715                 round[_rId].jackpotAmount.add(round[_rId].amount.mul(88) / 100)
716                 .sub(round[_rId].protectAmount)
717                 .sub(round[_rId].dividendAmount)
718             );
719         
720         round[_rId + 1].start = now;
721         rId++;
722         sId = 1;
723     }
724     
725     function getStageTargetAmount(uint256 _sId)
726         public
727         view
728         returns(uint256)
729     {
730         return bankCompute.getStageTargetAmount(_sId);
731     }
732     
733     function computeEarningsAmount(uint256 _sId, uint256 _amount, uint256 _currentTargetAmount, uint256 _expectEndSid, uint256 _ratio)
734         public
735         view
736         returns(uint256)
737     {
738         return bankCompute.computeEarningsAmount(_sId, _amount, _currentTargetAmount, _expectEndSid, _ratio);
739     }
740     
741     function getEarningsAmountByGoodsIndex(uint256 _goodsIndex)
742         public
743         view
744         returns(uint256, uint256, uint256, bool)
745     {
746         FBankdatasets.Goods memory _goods = goodsList[_goodsIndex];
747         uint256 _sId = sId;
748         uint256 _amount;
749         uint256 _targetExpectedAmount;
750         uint256 _targetAmount;
751         if(_goods.stepSize == 0){
752             if(round[_goods.rId].ended == true){
753                 if(round[_goods.rId].endSid > _goods.endSid){
754                     _targetExpectedAmount = getStageTargetAmount(_goods.startSid);
755                     _targetAmount = 
756                         stage[_goods.rId][_goods.startSid].dividendAmount <= _targetExpectedAmount ? 
757                         _targetExpectedAmount : stage[_goods.rId][_goods.startSid].dividendAmount;
758                     _targetAmount = _targetAmount.mul(100) / 88;
759                     _amount = computeEarningsAmount(
760                         _goods.startSid, 
761                         _goods.amount, 
762                         _targetAmount, 
763                         _goods.endSid, 
764                         100 - _goods.protectRatio
765                         );
766                     
767                 }else
768                     _amount = _goods.amount.mul(_goods.protectRatio.mul(88)) / 10000;
769                     
770                 if(round[_goods.rId].endSid == _goods.startSid)
771                     _amount = _amount.add(
772                         _goods.amount.mul(
773                             getRoundJackpot(_goods.rId)
774                             ).div(stage[_goods.rId][_goods.startSid].amount)
775                             );
776                 
777                 return (_amount, 0, 0, true);
778             }else{
779                 if(_sId > _goods.endSid){
780                     _targetExpectedAmount = getStageTargetAmount(_goods.startSid);
781                     _targetAmount = 
782                         stage[_goods.rId][_goods.startSid].dividendAmount <= _targetExpectedAmount ?
783                         _targetExpectedAmount : stage[_goods.rId][_goods.startSid].dividendAmount;
784                     _targetAmount = _targetAmount.mul(100) / 88;
785                     _amount = computeEarningsAmount(
786                         _goods.startSid, 
787                         _goods.amount, 
788                         _targetAmount, 
789                         _goods.endSid, 
790                         100 - _goods.protectRatio
791                         );
792                 }else
793                     return (0, 0, 0, false);
794             }
795             return (_amount, 0, 0, true);
796             
797         }else{
798             
799             uint256 _startSid = _goods.withdrawSid == 0 ? _goods.startSid : _goods.withdrawSid;
800             uint256 _ratio = 100 - _goods.protectRatio;
801             uint256 _reachAmount = _goods.reachAmount;
802             if(round[_goods.rId].ended == true){
803                 
804                 while(true){
805                     
806                     if(_startSid - (_goods.withdrawSid == 0 ? _goods.startSid : _goods.withdrawSid) > 100){
807                         return (_amount, _startSid, _reachAmount, false);
808                     }
809                     
810                     if(round[_goods.rId].endSid > _startSid.add(_goods.stepSize)){
811                         _targetExpectedAmount = getStageTargetAmount(_startSid);
812                         _targetAmount = 
813                             stage[_goods.rId][_startSid].dividendAmount <= _targetExpectedAmount ? 
814                             _targetExpectedAmount : stage[_goods.rId][_startSid].dividendAmount;
815                         _targetAmount = _targetAmount.mul(100) / 88;
816                         if(_startSid == _goods.endSid){
817                             _amount = _amount.add(
818                                 computeEarningsAmount(
819                                     _startSid, 
820                                     _goods.endAmount, 
821                                     _targetAmount, 
822                                     _startSid.add(_goods.stepSize), 
823                                     _ratio
824                                     )
825                                 );
826                             return (_amount, _goods.endSid, 0, true);
827                         }
828                         _amount = _amount.add(
829                             computeEarningsAmount(
830                                 _startSid, 
831                                 _startSid == _goods.startSid ? _goods.startAmount : _targetAmount, 
832                                 _targetAmount, 
833                                 _startSid.add(_goods.stepSize), 
834                                 _ratio
835                                 )
836                             );
837                         _reachAmount = 
838                             _reachAmount.add(
839                                 _startSid == _goods.startSid ? _goods.startAmount : _targetAmount
840                             );
841                     }else{
842                         
843                         _amount = _amount.add(
844                             (_goods.amount.sub(_reachAmount))
845                             .mul(_goods.protectRatio.mul(88)) / 10000
846                             );
847                         
848                         if(round[_goods.rId].endSid == _goods.endSid)
849                             _amount = _amount.add(
850                                 _goods.endAmount.mul(getRoundJackpot(_goods.rId))
851                                 .div(stage[_goods.rId][_goods.endSid].amount)
852                                 );
853                         
854                         return (_amount, _goods.endSid, 0, true);
855                     }
856                     
857                     _startSid++;
858                 }
859                 
860             }else{
861                 while(true){
862                     
863                     if(_startSid - (_goods.withdrawSid == 0 ? _goods.startSid : _goods.withdrawSid) > 100){
864                         return (_amount, _startSid, _reachAmount, false);
865                     }
866                     
867                     if(_sId > _startSid.add(_goods.stepSize)){
868                         _targetExpectedAmount = getStageTargetAmount(_startSid);
869                         _targetAmount = 
870                             stage[_goods.rId][_startSid].dividendAmount <= _targetExpectedAmount ? 
871                             _targetExpectedAmount : stage[_goods.rId][_startSid].dividendAmount;
872                         _targetAmount = _targetAmount.mul(100) / 88;
873                         if(_startSid == _goods.endSid){
874                             _amount = _amount.add(
875                                 computeEarningsAmount(
876                                     _startSid, 
877                                     _goods.endAmount, 
878                                     _targetAmount, 
879                                     _startSid.add(_goods.stepSize), 
880                                     _ratio
881                                     )
882                                 );
883                             return (_amount, _goods.endSid, 0, true);
884                         }
885                         _amount = _amount.add(
886                             computeEarningsAmount(
887                                 _startSid, 
888                                 _startSid == _goods.startSid ? _goods.startAmount : _targetAmount, 
889                                 _targetAmount, 
890                                 _startSid.add(_goods.stepSize), 
891                                 _ratio
892                                 )
893                             );
894                         _reachAmount = 
895                             _reachAmount.add(
896                                 _startSid == _goods.startSid ? 
897                                 _goods.startAmount : _targetAmount
898                             );
899                     }else    
900                         return (_amount, _startSid, _reachAmount, false);
901                     
902                     _startSid++;
903                 }
904             }
905         }
906     }
907     
908     function getRoundJackpot(uint256 _rId)
909         public
910         view
911         returns(uint256)
912     {
913         return (
914             (
915                 round[_rId].jackpotAmount
916                 .add(round[_rId].amount.mul(88) / 100))
917                 .sub(round[_rId].protectAmount)
918                 .sub(round[_rId].dividendAmount)
919             ).mul(80).div(100);
920     }
921     
922     function getHeadInfo()
923         public
924         view
925         returns(uint256, uint256, uint256, uint256, uint256, uint256)
926     {
927         uint256 _targetExpectedAmount = getStageTargetAmount(sId);
928         
929         return
930             (
931                 rId,
932                 sId,
933                 stage[rId][sId].start.add(stageDuration),
934                 stage[rId][sId].amount,
935                 (
936                     stage[rId][sId].dividendAmount <= _targetExpectedAmount ? 
937                     _targetExpectedAmount : stage[rId][sId].dividendAmount
938                 ).mul(100) / 88,
939                 round[rId].jackpotAmount.add(round[rId].amount.mul(88) / 100)
940                 .sub(round[rId].protectAmount)
941                 .sub(round[rId].dividendAmount)
942             );
943     }
944     
945     function getPlayerGoodList(address _player)
946         public
947         view
948         returns(uint256[])
949     {
950         return playerGoodsList[_player];
951     }
952 
953     function totalSupply() 
954         public 
955         view 
956         returns (uint256 total)
957     {
958         return cardList.length;
959     }
960     
961     function balanceOf(address _owner) 
962         public 
963         view 
964         returns (uint256 balance)
965     {
966         uint256 _length = cardList.length;
967         uint256 _count;
968         for(uint256 i = 0; i < _length; i++){
969             if(cardList[i].playerAddress == _owner)
970                 _count++;
971         }
972         
973         return _count;
974     }
975     
976     function ownerOf(uint256 _tokenId) 
977         public 
978         view 
979         returns (address owner)
980     {
981         require(cardList.length > _tokenId, "tokenId error");
982         owner = cardList[_tokenId].playerAddress;
983         require(owner != address(0), "No owner");
984     }
985     
986     function approve(address _to, uint256 _tokenId)
987         senderVerify()
988         public
989     {
990         require (register[_to] != bytes32(0), "Not a registered user");
991         require (msg.sender == cardList[_tokenId].playerAddress, "The card does not belong to you");
992         require (cardList.length > _tokenId, "tokenId error");
993         require (cardIndexToApproved[_tokenId] == address(0), "Approved");
994         
995         cardIndexToApproved[_tokenId] = _to;
996         
997         emit Approval(msg.sender, _to, _tokenId);
998     }
999     
1000     function takeOwnership(uint256 _tokenId)
1001         senderVerify()
1002         public
1003     {
1004         address _newOwner = msg.sender;
1005         address _oldOwner = cardList[_tokenId].playerAddress;
1006         
1007         require(_newOwner != address(0), "Address error");
1008         require(_newOwner == cardIndexToApproved[_tokenId], "Without permission");
1009         
1010         cardList[_tokenId].playerAddress = _newOwner;
1011         delete cardIndexToApproved[_tokenId];
1012         
1013         emit Transfer(_oldOwner, _newOwner, _tokenId);
1014     }
1015     
1016     function transfer(address _to, uint256 _tokenId) 
1017         senderVerify()
1018         public
1019     {
1020         require (msg.sender == cardList[_tokenId].playerAddress, "The card does not belong to you");
1021         require(_to != address(0), "Address error");
1022         require(_to == cardIndexToApproved[_tokenId], "Without permission");
1023         
1024         cardList[_tokenId].playerAddress = _to;
1025         
1026         if(cardIndexToApproved[_tokenId] != address(0))
1027             delete cardIndexToApproved[_tokenId];
1028         
1029         emit Transfer(msg.sender, _to, _tokenId);
1030     }
1031     
1032     function transferFrom(address _from, address _to, uint256 _tokenId)
1033         senderVerify()
1034         public
1035     {
1036         require (_from == cardList[_tokenId].playerAddress, "Owner error");
1037         require(_to != address(0), "Address error");
1038         require(_to == cardIndexToApproved[_tokenId], "Without permission");
1039         
1040         cardList[_tokenId].playerAddress = _to;
1041         delete cardIndexToApproved[_tokenId];
1042         
1043         emit Transfer(_from, _to, _tokenId);
1044     }
1045     
1046 }
1047 
1048 library FBankdatasets {
1049     
1050     struct Round {
1051         uint256 start;
1052         uint256 end;
1053         bool ended;
1054         uint256 endSid;
1055         uint256 amount;
1056         uint256 protectAmount;
1057         uint256 dividendAmount;
1058         uint256 jackpotAmount;
1059     }
1060     
1061     struct Stage {
1062         uint256 start;
1063         uint256 amount;
1064         uint256 protectAmount;
1065         uint256 dividendAmount;
1066     }
1067     
1068     struct Goods {
1069         uint256 rId;
1070         uint256 startSid;
1071         uint256 endSid;
1072         uint256 withdrawSid;
1073         uint256 amount;
1074         uint256 startAmount;
1075         uint256 endAmount;
1076         uint256 reachAmount;
1077         uint256 stepSize;
1078         uint256 protectRatio;
1079     }
1080     
1081     struct Card {
1082         address playerAddress;
1083         uint256 amount;
1084     }
1085 }
1086 
1087 /**
1088  * Anti clone protection.
1089  * Do not clone this contract without permission even if you manage to break the conceal. 
1090  * The concealed code contains core calculations necessary for this contract to function. 
1091  * This contract can be licensed for a fee, contact us instead of cloning!
1092  */ 
1093 interface FairBankCompute {
1094     function getStageTargetAmount(uint256 _sId) external view returns(uint256);
1095     function computeEarningsAmount(uint256 _sId, uint256 _amount, uint256 _currentTargetAmount, uint256 _expectEndSid, uint256 _ratio) external view returns(uint256);
1096 }
1097 
1098 library NameFilter {
1099     
1100     function nameFilter(string _input)
1101         internal
1102         pure
1103         returns(bytes32)
1104     {
1105         bytes memory _temp = bytes(_input);
1106         uint256 _length = _temp.length;
1107         
1108         //sorry limited to 32 characters
1109         require (_length <= 32 && _length > 3, "string must be between 4 and 32 characters");
1110         // make sure it doesnt start with or end with space
1111         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1112         // make sure first two characters are not 0x
1113         if (_temp[0] == 0x30)
1114         {
1115             require(_temp[1] != 0x78, "string cannot start with 0x");
1116             require(_temp[1] != 0x58, "string cannot start with 0X");
1117         }
1118         
1119         for (uint256 i = 0; i < _length; i++)
1120         {
1121             require
1122             (
1123                 // OR uppercase A-Z
1124                 (_temp[i] > 0x40 && _temp[i] < 0x5b) ||
1125                 // OR lowercase a-z
1126                 (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1127                 // or 0-9
1128                 (_temp[i] > 0x2f && _temp[i] < 0x3a),
1129                 "string contains invalid characters"
1130             );
1131         }
1132         
1133         bytes32 _ret;
1134         assembly {
1135             _ret := mload(add(_temp, 32))
1136         }
1137         return (_ret);
1138     }
1139 }
1140 
1141 /**
1142  * @title SafeMath v0.1.9
1143  * @dev Math operations with safety checks that throw on error
1144  */
1145 library SafeMath {
1146     
1147     /**
1148     * @dev Adds two numbers, throws on overflow.
1149     */
1150     function add(uint256 a, uint256 b) 
1151         internal 
1152         pure 
1153         returns (uint256) 
1154     {
1155         uint256 c = a + b;
1156         assert(c >= a);
1157         return c;
1158     }
1159     
1160     /**
1161     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1162     */
1163     function sub(uint256 a, uint256 b) 
1164         internal 
1165         pure 
1166         returns (uint256) 
1167     {
1168         assert(b <= a);
1169         return a - b;
1170     }
1171 
1172     /**
1173     * @dev Multiplies two numbers, throws on overflow.
1174     */
1175     function mul(uint256 a, uint256 b) 
1176         internal 
1177         pure 
1178         returns (uint256) 
1179     {
1180         if (a == 0) {
1181             return 0;
1182         }
1183         uint256 c = a * b;
1184         assert(c / a == b);
1185         return c;
1186     }
1187     
1188     /**
1189     * @dev Integer division of two numbers, truncating the quotient.
1190     */
1191     function div(uint256 a, uint256 b) 
1192         internal 
1193         pure 
1194         returns (uint256) 
1195     {
1196         assert(b > 0); // Solidity automatically throws when dividing by 0
1197         uint256 c = a / b;
1198         assert(a == b * c + a % b); // There is no case in which this doesn't hold
1199         return c;
1200     }
1201     
1202     /**
1203      * @dev gives square root of given x.
1204      */
1205     function sqrt(uint256 x)
1206         internal
1207         pure
1208         returns (uint256 y) 
1209     {
1210         uint256 z = ((add(x,1)) / 2);
1211         y = x;
1212         while (z < y) 
1213         {
1214             y = z;
1215             z = ((add((x / z),z)) / 2);
1216         }
1217     }
1218     
1219     /**
1220      * @dev gives square. multiplies x by x
1221      */
1222     function sq(uint256 x)
1223         internal
1224         pure
1225         returns (uint256)
1226     {
1227         return (mul(x,x));
1228     }
1229     
1230     /**
1231      * @dev x to the power of y 
1232      */
1233     function pwr(uint256 x, uint256 y)
1234         internal 
1235         pure 
1236         returns (uint256)
1237     {
1238         if (x==0)
1239             return (0);
1240         else if (y==0)
1241             return (1);
1242         else 
1243         {
1244             uint256 z = x;
1245             for (uint256 i=1; i < y; i++)
1246                 z = mul(z,x);
1247             return (z);
1248         }
1249     }
1250 }