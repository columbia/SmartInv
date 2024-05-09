1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     uint256 c = a * b;
21     require(c / a == b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 /**
68  * @title Ownable
69  * @dev The Ownable contract has an owner address, and provides basic authorization control
70  * functions, this simplifies the implementation of "user permissions".
71  **/
72 contract Ownable {
73     //using library SafeMath
74     using SafeMath for uint;
75     
76     enum RequestType {
77         None,
78         Owner,
79         CoOwner1,
80         CoOwner2
81     }
82     
83     address public owner;
84     address coOwner1;
85     address coOwner2;
86     RequestType requestType;
87     address newOwnerRequest;
88     
89     mapping(address => bool) voterList;
90     
91     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
92 
93     /**
94      * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
95      **/
96     constructor() public {
97       owner = msg.sender;
98       coOwner1 = address(0x625789684cE563Fe1f8477E8B3c291855E3470dF);
99       coOwner2 = address(0xe80a08C003b0b601964b4c78Fb757506d2640055);
100     }
101     
102     /**
103      * @dev Throws if called by any account other than the owner.
104      **/
105     modifier onlyOwner() {
106       require(msg.sender == owner);
107       _;
108     }
109     modifier onlyCoOwner1() {
110         require(msg.sender == coOwner1);
111         _;
112     }
113     modifier onlyCoOwner2() {
114         require(msg.sender == coOwner2);
115         _;
116     }
117     
118     /**
119      * @dev Allows the current owner to transfer control of the contract to a newOwner.
120      * @param newOwner The address to transfer ownership to.
121      **/
122     function transferOwnership(address newOwner) public {
123       require(msg.sender == owner || msg.sender == coOwner1 || msg.sender == coOwner2);
124       require(newOwner != address(0));
125       
126       if(msg.sender == owner) {
127           requestType = RequestType.Owner;
128       }
129       else if(msg.sender == coOwner1) {
130           requestType = RequestType.CoOwner1;
131       }
132       else if(msg.sender == coOwner2) {
133           requestType = RequestType.CoOwner2;
134       }
135       newOwnerRequest = newOwner;
136       voterList[msg.sender] = true;
137     }
138     
139     function voteChangeOwner(bool isAgree) public {
140         require(msg.sender == owner || msg.sender == coOwner1 || msg.sender == coOwner2);
141         require(requestType != RequestType.None);
142         voterList[msg.sender] = isAgree;
143         checkVote();
144     }
145     
146     function checkVote() private {
147         uint iYesCount = 0;
148         uint iNoCount = 0;
149         if(voterList[owner] == true) {
150             iYesCount = iYesCount.add(1);
151         }
152         else {
153             iNoCount = iNoCount.add(1);
154         }
155         if(voterList[coOwner1] == true) {
156             iYesCount = iYesCount.add(1);
157         }
158         else {
159             iNoCount = iNoCount.add(1);
160         }
161         if(voterList[coOwner2] == true) {
162             iYesCount = iYesCount.add(1);
163         }
164         else {
165             iNoCount = iNoCount.add(1);
166         }
167         
168         if(iYesCount >= 2) {
169             emit OwnershipTransferred(owner, newOwnerRequest);
170             if(requestType == RequestType.Owner) {
171                 owner = newOwnerRequest;
172             }
173             else if(requestType == RequestType.CoOwner1) {
174                 coOwner1 = newOwnerRequest;
175             }
176             else if(requestType == RequestType.CoOwner2) {
177                 coOwner2 = newOwnerRequest;
178             }
179             
180             newOwnerRequest = address(0);
181             requestType = RequestType.None;
182         }
183         else if(iNoCount >= 2) {
184             newOwnerRequest = address(0);
185             requestType = RequestType.None;
186         }
187     }
188 }
189 
190 /**
191  * @title Configurable
192  * @dev Configurable varriables of the contract
193  **/
194 contract Configurable {
195     uint256 constant cfgPercentDivider = 10000;
196     uint256 constant cfgPercentMaxReceive = 30000;
197     
198     uint256 public cfgMinDepositRequired = 2 * 10**17; //0.2 ETH
199     uint256 public cfgMaxDepositRequired = 100*10**18; //100 ETH
200     
201     uint256 public minReceiveCommission = 2 * 10**16; //0.02 ETH
202     uint256 public maxReceiveCommissionPercent = 15000; //150 %
203     
204     uint256 public supportWaitingTime;
205     uint256 public supportPercent;
206     uint256 public receiveWaitingTime;
207     uint256 public receivePercent;
208     
209     uint256 public systemFeePercent = 300;          //3%
210     address public systemFeeAddress;
211     
212     uint256 public commissionFeePercent = 300;      //3%
213     address public commissionFeeAddress;
214     
215     uint256 public tokenSupportPercent = 500;       //5%
216     address public tokenSupportAddress;
217     
218     uint256 public directCommissionPercent = 1000;
219 }
220     
221 /**
222  * @title EbcFund 
223  * @dev Contract to create the game
224  **/
225 contract EbcFund is Ownable, Configurable {
226     
227     /**
228      * @dev enum
229      **/
230     enum Stages {
231         Preparing,
232         Started,
233         Paused
234     }
235     enum GameStatus {
236         none,
237         processing,
238         completed
239     }
240     
241     /**
242      * @dev Structs 
243      **/
244     struct Player {
245         address parentAddress;
246         uint256 totalDeposited;
247         uint256 totalAmountInGame;
248         uint256 totalReceived;
249         uint256 totalCommissionReceived;
250         uint lastReceiveCommission;
251         bool isKyc;
252         uint256 directCommission;
253     }
254     
255     struct Game {
256         address playerAddress;
257         uint256 depositAmount;
258         uint256 receiveAmount;
259         GameStatus status;
260         //
261         uint nextRoundTime;
262         uint256 nextRoundAmount;
263     }
264     
265     /**
266      * @dev Variables
267      **/
268     Stages public currentStage;
269     address transporter;
270     
271     /**
272      * @dev Events
273      **/
274     event Logger(string _label, uint256 _note);
275     
276     /**
277      * @dev Mapping
278      **/
279     mapping(address => bool) public donateList;
280     mapping(address => Player) public playerList;
281     mapping(uint => Game) public gameList;
282     
283     /**
284      * @dev constructor
285      **/
286     constructor() public {
287         // set configs value
288         systemFeeAddress = owner;
289         commissionFeeAddress = address(0x4c0037cd34804aB3EB6f54d6596A22A68b05c8CF);
290         tokenSupportAddress = address(0xC739c85ffE468fA7a6f2B8A005FF0eacAb4D5f0e);
291         //
292         supportWaitingTime = 20*86400;//20 days
293         supportPercent = 70;//0.7%
294         receiveWaitingTime = 5*86400;//5 days
295         receivePercent = 10;//0.1%
296         // 
297         currentStage = Stages.Preparing;
298         //
299         donateList[owner] = true;
300         donateList[commissionFeeAddress] = true;
301         donateList[tokenSupportAddress] = true;
302     }
303     
304     /**
305      * @dev Modifiers
306      **/
307     modifier onlyPreparing() {
308         require (currentStage == Stages.Preparing);
309         _;
310     }
311     modifier onlyStarted() {
312         require (currentStage == Stages.Started);
313         _;
314     }
315     modifier onlyPaused() {
316         require (currentStage == Stages.Paused);
317         _;
318     }
319     
320 /* payments */
321     /**
322      * @dev fallback function to send ether to smart contract
323      **/
324     function () public payable {
325         require(currentStage == Stages.Started);
326         require(cfgMinDepositRequired <= msg.value && msg.value <= cfgMaxDepositRequired);
327         
328         if(donateList[msg.sender] == false) {
329             if(transporter != address(0) && msg.sender == transporter) {
330                 //validate msg.data
331                 if(msg.data.length > 0) {
332                     //init new game
333                     processDeposit(bytesToAddress(msg.data));
334                 }
335                 else {
336                      emit Logger("Thank you for your contribution!.", msg.value);
337                 }
338             }
339             else {
340                 //init new game
341                 processDeposit(msg.sender);
342             }
343         }
344         else {
345             emit Logger("Thank you for your contribution!", msg.value);
346         }
347     }
348     
349 /* administrative functions */
350     /**
351      * @dev get transporter address
352      **/
353     function getTransporter() public view onlyOwner returns(address) {
354         return transporter;
355     }
356 
357     /**
358      * @dev update "transporter"
359      **/
360     function updateTransporter(address _address) public onlyOwner{
361         require (_address != address(0));
362         transporter = _address;
363     }
364     
365     /**
366      * @dev update "donateList"
367      **/
368     function updateDonator(address _address, bool _isDonator) public onlyOwner{
369         donateList[_address] = _isDonator;
370     }
371     
372     /**
373      * @dev update config "systemFeeAddress"
374      **/
375     function updateSystemAddress(address _address) public onlyOwner{
376         require(_address != address(0) && _address != systemFeeAddress);
377         //
378         systemFeeAddress = _address;
379     }
380     
381     /**
382      * @dev update config "systemFeePercent"
383      **/
384     function updateSystemFeePercent(uint256 _percent) public onlyOwner{
385         require(0 < _percent && _percent != systemFeePercent && _percent <= 500); //maximum is 5%
386         systemFeePercent = _percent;
387     }
388     
389     /**
390      * @dev update config "commissionFeeAddress"
391      **/
392     function updateCommissionAddress(address _address) public onlyOwner{
393         require(_address != address(0) && _address != commissionFeeAddress);
394         //
395         commissionFeeAddress = _address;
396     }
397     
398     /**
399      * @dev update config "commissionFeePercent"
400      **/
401     function updateCommissionFeePercent(uint256 _percent) public onlyOwner{
402         require(0 < _percent && _percent != commissionFeePercent && _percent <= 500); //maximum is 5%
403         commissionFeePercent = _percent;
404     }
405     
406     /**
407      * @dev update config "tokenSupportAddress"
408      **/
409     function updateTokenSupportAddress(address _address) public onlyOwner{
410         require(_address != address(0) && _address != tokenSupportAddress);
411         //
412         tokenSupportAddress = _address;
413     }
414     
415     /**
416      * @dev update config "tokenSupportPercent"
417      **/
418     function updateTokenSupportPercent(uint256 _percent) public onlyOwner{
419         require(0 < _percent && _percent != tokenSupportPercent && _percent <= 1000); //maximum is 10%
420         tokenSupportPercent = _percent;
421     }
422     
423     /**
424      * @dev update config "directCommissionPercent"
425      **/
426     function updateDirectCommissionPercent(uint256 _percent) public onlyOwner{
427         require(0 < _percent && _percent != directCommissionPercent && _percent <= 2000); //maximum is 20%
428         directCommissionPercent = _percent;
429     }
430     
431     /**
432      * @dev update config "cfgMinDepositRequired"
433      **/
434     function updateMinDeposit(uint256 _amount) public onlyOwner{
435         require(0 < _amount && _amount < cfgMaxDepositRequired);
436         require(_amount != cfgMinDepositRequired);
437         //
438         cfgMinDepositRequired = _amount;
439     }
440     
441     /**
442      * @dev update config "cfgMaxDepositRequired"
443      **/
444     function updateMaxDeposit(uint256 _amount) public onlyOwner{
445         require(cfgMinDepositRequired < _amount && _amount != cfgMaxDepositRequired);
446         //
447         cfgMaxDepositRequired = _amount;
448     }
449     
450     /**
451      * @dev update config "minReceiveCommission"
452      **/
453     function updateMinReceiveCommission(uint256 _amount) public onlyOwner{
454         require(0 < _amount && _amount != minReceiveCommission);
455         minReceiveCommission = _amount;
456     }
457     
458     /**
459      * @dev update config "maxReceiveCommissionPercent"
460      **/
461     function updateMaxReceiveCommissionPercent(uint256 _percent) public onlyOwner{
462         require(5000 <= _percent && _percent <= 20000); //require from 50% to 200%
463         //
464         maxReceiveCommissionPercent = _percent;
465     }
466     
467     /**
468      * @dev update config "supportWaitingTime"
469      **/
470     function updateSupportWaitingTime(uint256 _time) public onlyOwner{
471         require(86400 <= _time);
472         require(_time != supportWaitingTime);
473         //
474         supportWaitingTime = _time;
475     }
476     
477     /**
478      * @dev update config "supportPercent"
479      **/
480     function updateSupportPercent(uint256 _percent) public onlyOwner{
481         require(0 < _percent && _percent < 1000);
482         require(_percent != supportPercent);
483         //
484         supportPercent = _percent;
485     }
486     
487     /**
488      * @dev update config "receiveWaitingTime"
489      **/
490     function updateReceiveWaitingTime(uint256 _time) public onlyOwner{
491         require(86400 <= _time);
492         require(_time != receiveWaitingTime);
493         //
494         receiveWaitingTime = _time;
495     }
496     
497     /**
498      * @dev update config "receivePercent"
499      **/
500     function updateRecivePercent(uint256 _percent) public onlyOwner{
501         require(0 < _percent && _percent < 1000);
502         require(_percent != receivePercent);
503         //
504         receivePercent = _percent;
505     }
506     
507     /**
508      * @dev update parent address
509      **/
510     function updatePlayerParent(address[] _address, address[] _parentAddress) public onlyOwner{
511         
512         for(uint i = 0; i < _address.length; i++) {
513             require(_address[i] != address(0));
514             require(_parentAddress[i] != address(0));
515             require(_address[i] != _parentAddress[i]);
516             
517             Player storage currentPlayer = playerList[_address[i]];
518             //
519             currentPlayer.parentAddress = _parentAddress[i];
520             if(0 < currentPlayer.directCommission && currentPlayer.directCommission < address(this).balance) {
521                 uint256 comAmount = currentPlayer.directCommission;
522                 currentPlayer.directCommission = 0;
523                 //Logger
524                 emit Logger("Send direct commission", comAmount);
525                 //send direct commission
526                 _parentAddress[i].transfer(comAmount);
527             }
528         }
529         
530     }
531     
532     /**
533      * @dev update kyc
534      **/
535     function updatePlayerKyc(address[] _address, bool[] _isKyc) public onlyOwner{
536         
537         for(uint i = 0; i < _address.length; i++) {
538             require(_address[i] != address(0));
539             //
540             playerList[_address[i]].isKyc = _isKyc[i];
541         }
542     }
543     
544     /**
545      * @dev start game
546      **/
547     function startGame() public onlyOwner {
548         require(currentStage == Stages.Preparing || currentStage == Stages.Paused);
549         currentStage = Stages.Started;
550     }
551     
552     /**
553      * @dev pause game
554      **/
555     function pauseGame() public onlyOwner onlyStarted {
556         currentStage = Stages.Paused;
557     }
558     
559     /**
560      * @dev insert multi games
561      **/
562     function importPlayers(
563         address[] _playerAddress, 
564         address[] _parentAddress,
565         uint256[] _totalDeposited,
566         uint256[] _totalReceived,
567         uint256[] _totalCommissionReceived,
568         bool[] _isKyc) public onlyOwner onlyPreparing {
569             
570             for(uint i = 0; i < _playerAddress.length; i++) {
571                 processImportPlayer(
572                     _playerAddress[i], 
573                     _parentAddress[i],
574                     _totalDeposited[i],
575                     _totalReceived[i],
576                     _totalCommissionReceived[i],
577                     _isKyc[i]);
578             }
579             
580         }
581     
582     function importGames(
583         address[] _playerAddress,
584         uint[] _gameHash,
585         uint256[] _gameAmount,
586         uint256[] _gameReceived) public onlyOwner onlyPreparing {
587             
588             for(uint i = 0; i < _playerAddress.length; i++) {
589                 processImportGame(
590                     _playerAddress[i], 
591                     _gameHash[i],
592                     _gameAmount[i],
593                     _gameReceived[i]);
594             }
595             
596         }
597     
598     /**
599      * @dev confirm game information
600      **/  
601     function confirmGames(address[] _playerAddress, uint[] _gameHash, uint256[] _gameAmount) public onlyCoOwner1 onlyStarted {
602         
603         for(uint i = 0; i < _playerAddress.length; i++) {
604             confirmGame(_playerAddress[i], _gameHash[i], _gameAmount[i]);
605         }
606         
607     }
608     
609     /**
610      * @dev confirm game information
611      **/  
612     function confirmGame(address _playerAddress, uint _gameHash, uint256 _gameAmount) public onlyCoOwner1 onlyStarted {
613         //validate _gameHash
614         require(100000000000 <= _gameHash && _gameHash <= 999999999999);
615         //validate player information
616         Player storage currentPlayer = playerList[_playerAddress];
617         require(cfgMinDepositRequired <= playerList[_playerAddress].totalDeposited);
618         assert(currentPlayer.totalDeposited <= currentPlayer.totalAmountInGame.add(_gameAmount));
619         //update player information
620         currentPlayer.totalAmountInGame = currentPlayer.totalAmountInGame.add(_gameAmount);
621         //init game
622         initGame(_playerAddress, _gameHash, _gameAmount, 0);
623         //Logger
624         emit Logger("Game started", _gameAmount);
625     }
626     
627     /**
628      * @dev process send direct commission missing
629      **/
630     function sendMissionDirectCommission(address _address) public onlyCoOwner2 onlyStarted {
631         
632         require(donateList[_address] == false);
633         require(playerList[_address].parentAddress != address(0));
634         require(playerList[_address].directCommission > 0);
635         
636         Player memory currentPlayer = playerList[_address];
637         if(0 < currentPlayer.directCommission && currentPlayer.directCommission < address(this).balance) {
638             uint256 comAmount = currentPlayer.directCommission;
639             playerList[_address].directCommission = 0;
640             //Logger
641             emit Logger("Send direct commission", comAmount);
642             //send direct commission
643             currentPlayer.parentAddress.transfer(comAmount);
644         }
645         
646     }
647     
648     /**
649      * @dev process send commission
650      **/
651     function sendCommission(address _address, uint256 _amountCom) public onlyCoOwner2 onlyStarted {
652         
653         require(donateList[_address] == false);
654         require(minReceiveCommission <= _amountCom && _amountCom < address(this).balance);
655         require(playerList[_address].isKyc == true);
656         require(playerList[_address].lastReceiveCommission.add(86400) < now);
657         
658         //current player
659         Player storage currentPlayer = playerList[_address];
660         //
661         uint256 maxCommissionAmount = getMaximumCommissionAmount(
662             currentPlayer.totalAmountInGame, 
663             currentPlayer.totalReceived, 
664             currentPlayer.totalCommissionReceived, 
665             _amountCom);
666         if(maxCommissionAmount > 0) {
667             //update total receive
668             currentPlayer.totalReceived = currentPlayer.totalReceived.add(maxCommissionAmount);
669             currentPlayer.totalCommissionReceived = currentPlayer.totalCommissionReceived.add(maxCommissionAmount);
670             currentPlayer.lastReceiveCommission = now;
671             //fee commission
672             uint256 comFee = maxCommissionAmount.mul(commissionFeePercent).div(cfgPercentDivider);
673             //Logger
674             emit Logger("Send commission successfully", _amountCom);
675             
676             if(comFee > 0) {
677                 maxCommissionAmount = maxCommissionAmount.sub(comFee);
678                 //send commission to store address
679                 commissionFeeAddress.transfer(comFee);
680             }
681             if(maxCommissionAmount > 0) {
682                 //send eth
683                 _address.transfer(maxCommissionAmount);
684             }
685         }
686         
687     }
688     
689     /**
690      * @dev process send profit in game
691      **/
692     function sendProfits(
693         uint[] _gameHash,
694         uint256[] _profitAmount) public onlyCoOwner2 onlyStarted {
695             
696             for(uint i = 0; i < _gameHash.length; i++) {
697                 sendProfit(_gameHash[i], _profitAmount[i]);
698             }
699             
700         }
701     
702     /**
703      * @dev process send profit in game
704      **/
705     function sendProfit(
706         uint _gameHash,
707         uint256 _profitAmount) public onlyCoOwner2 onlyStarted {
708             
709             //validate game information
710             Game memory game = gameList[_gameHash];
711             require(game.status == GameStatus.processing);
712             require(0 < _profitAmount && _profitAmount <= game.nextRoundAmount && _profitAmount < address(this).balance);
713             require(now <= game.nextRoundTime);
714             //validate player information
715             Player memory currentPlayer = playerList[gameList[_gameHash].playerAddress];
716             assert(currentPlayer.isKyc == true);
717             //do sendProfit
718             processSendProfit(_gameHash, _profitAmount);
719             
720         }
721     
722 /* public functions */
723     
724 /* private functions */
725     /**
726      * @dev process new game by deposit
727      **/
728     function processDeposit(address _address) private {
729         
730         //update player information
731         Player storage currentPlayer = playerList[_address];
732         currentPlayer.totalDeposited = currentPlayer.totalDeposited.add(msg.value);
733         
734         //Logger
735         emit Logger("Game deposited", msg.value);
736         
737         //send token support
738         uint256 tokenSupportAmount = tokenSupportPercent.mul(msg.value).div(cfgPercentDivider);
739         if(tokenSupportPercent > 0) {
740             tokenSupportAddress.transfer(tokenSupportAmount);
741         }
742         
743         //send parent address
744         uint256 directComAmount = directCommissionPercent.mul(msg.value).div(cfgPercentDivider);
745         if(currentPlayer.parentAddress != address(0)) {
746             currentPlayer.parentAddress.transfer(directComAmount);
747         }
748         else {
749             currentPlayer.directCommission = currentPlayer.directCommission.add(directComAmount);
750         }
751         
752     }
753     
754     /**
755      * @dev convert bytes to address
756      **/
757     function bytesToAddress(bytes b) public pure returns (address) {
758 
759         uint result = 0;
760         for (uint i = 0; i < b.length; i++) {
761             uint c = uint(b[i]);
762             if (c >= 48 && c <= 57) {
763                 result = result * 16 + (c - 48);
764             }
765             if(c >= 65 && c<= 90) {
766                 result = result * 16 + (c - 55);
767             }
768             if(c >= 97 && c<= 122) {
769                 result = result * 16 + (c - 87);
770             }
771         }
772         return address(result);
773           
774     }
775     
776     /**
777      * @dev process import player information
778      **/ 
779     function processImportPlayer(
780         address _playerAddress, 
781         address _parentAddress, 
782         uint256 _totalDeposited,
783         uint256 _totalReceived,
784         uint256 _totalCommissionReceived,
785         bool _isKyc) private {
786             
787             //update player information
788             Player storage currentPlayer = playerList[_playerAddress];
789             currentPlayer.parentAddress = _parentAddress;
790             currentPlayer.totalDeposited = _totalDeposited;
791             currentPlayer.totalReceived = _totalReceived;
792             currentPlayer.totalCommissionReceived = _totalCommissionReceived;
793             currentPlayer.isKyc = _isKyc;
794             
795             //Logger
796             emit Logger("Player imported", _totalDeposited);
797             
798         }
799      
800     /**
801      * @dev process import game information
802      **/ 
803     function processImportGame(
804         address _playerAddress, 
805         uint _gameHash,
806         uint256 _gameAmount,
807         uint256 _gameReceived) private {
808             
809             //update player information
810             Player storage currentPlayer = playerList[_playerAddress];
811             currentPlayer.totalAmountInGame = currentPlayer.totalAmountInGame.add(_gameAmount);
812             currentPlayer.totalReceived = currentPlayer.totalReceived.add(_gameReceived);
813             
814             //init game
815             initGame(_playerAddress, _gameHash, _gameAmount, _gameReceived);
816             
817             //Logger
818             emit Logger("Game imported", _gameAmount);
819             
820         }
821      
822     /**
823      * @dev init new game
824      **/ 
825     function initGame(
826         address _playerAddress,
827         uint _gameHash,
828         uint256 _gameAmount,
829         uint256 _gameReceived) private {
830             
831             Game storage game = gameList[_gameHash];
832             game.playerAddress = _playerAddress;
833             game.depositAmount = _gameAmount;
834             game.receiveAmount = _gameReceived;
835             game.status = GameStatus.processing;
836             game.nextRoundTime = now.add(supportWaitingTime);
837             game.nextRoundAmount = getProfitNextRound(_gameAmount);
838             
839         }
840     
841     /**
842      * @dev process check & send profit
843      **/
844     function processSendProfit(
845         uint _gameHash,
846         uint256 _profitAmount) private {
847         
848             Game storage game = gameList[_gameHash];
849             Player storage currentPlayer = playerList[game.playerAddress];
850             
851             //total receive by game
852             uint256 maxGameReceive = game.depositAmount.mul(cfgPercentMaxReceive).div(cfgPercentDivider);
853             //total receive by player
854             uint256 maxPlayerReceive = currentPlayer.totalAmountInGame.mul(cfgPercentMaxReceive).div(cfgPercentDivider);
855             
856             if(maxGameReceive <= game.receiveAmount || maxPlayerReceive <= currentPlayer.totalReceived) {
857                 emit Logger("ERR: Player cannot break game's rule [amount].", currentPlayer.totalReceived);
858                 game.status = GameStatus.completed;
859             }
860             else {
861                 if(maxGameReceive < game.receiveAmount.add(_profitAmount)) {
862                     _profitAmount = maxGameReceive.sub(game.receiveAmount);
863                 }
864                 if(maxPlayerReceive < currentPlayer.totalReceived.add(_profitAmount)) {
865                     _profitAmount = maxPlayerReceive.sub(currentPlayer.totalReceived);
866                 }
867                 
868                 //update game totalReceived
869                 game.receiveAmount = game.receiveAmount.add(_profitAmount);
870                 game.nextRoundTime = now.add(supportWaitingTime);
871                 game.nextRoundAmount = getProfitNextRound(game.depositAmount);
872                 
873                 //Logger
874                 emit Logger("Info: send profit", _profitAmount);
875                 
876                 //update player total received 
877                 currentPlayer.totalReceived = currentPlayer.totalReceived.add(_profitAmount);
878                 
879                 //send systemFeeAddress
880                 uint256 feeAmount = systemFeePercent.mul(_profitAmount).div(cfgPercentDivider);
881                 if(feeAmount > 0) {
882                     _profitAmount = _profitAmount.sub(feeAmount);
883                     //send fee
884                     systemFeeAddress.transfer(feeAmount);
885                 }
886                 
887                 //send profit
888                 game.playerAddress.transfer(_profitAmount);
889             }
890             
891         }
892     
893     /**
894      * @dev get profit next round
895      **/
896     function getProfitNextRound(uint256 _amount) private constant returns(uint256) {
897         
898         uint256 support = supportPercent.mul(supportWaitingTime);
899         uint256 receive = receivePercent.mul(receiveWaitingTime);
900         uint256 totalPercent = support.add(receive);
901         //
902         return _amount.mul(totalPercent).div(cfgPercentDivider).div(86400);
903         
904     }
905     
906     /**
907      * @dev get maximum amount commission avariable
908      **/
909     function getMaximumCommissionAmount(
910         uint256 _totalDeposited,
911         uint256 _totalReceived,
912         uint256 _totalCommissionReceived,
913         uint256 _amountCom) private returns(uint256) {
914         
915         //maximum commission can receive
916         uint256 maxCommissionAmount = _totalDeposited.mul(maxReceiveCommissionPercent).div(cfgPercentDivider);
917         //check total receive commission
918         if(maxCommissionAmount <= _totalCommissionReceived) {
919             emit Logger("Not enough balance [total commission receive]", _totalCommissionReceived);
920             return 0;
921         }
922         else if(maxCommissionAmount < _totalCommissionReceived.add(_amountCom)) {
923             _amountCom = maxCommissionAmount.sub(_totalCommissionReceived);
924         }
925         //check player total maxout
926         uint256 maxProfitCanReceive = _totalDeposited.mul(cfgPercentMaxReceive).div(cfgPercentDivider);
927         if(maxProfitCanReceive <= _totalReceived) {
928             emit Logger("Not enough balance [total maxout receive]", _totalReceived);
929             return 0;
930         }
931         else if(maxProfitCanReceive < _totalReceived.add(_amountCom)) {
932             _amountCom = maxProfitCanReceive.sub(_totalReceived);
933         }
934         
935         return _amountCom;
936     }
937 }