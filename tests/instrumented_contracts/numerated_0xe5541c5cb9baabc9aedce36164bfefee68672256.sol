1 pragma solidity ^0.4.24;
2  
3 
4 //
5 //                       .#########'
6 //                    .###############+
7 //                  ,####################
8 //                `#######################+
9 //               ;##########################
10 //              #############################.
11 //             ###############################,
12 //           +##################,    ###########`
13 //          .###################     .###########
14 //         ##############,          .###########+
15 //         #############`            .############`
16 //         ###########+                ############
17 //        ###########;                  ###########
18 //        ##########'                    ###########
19 //       '##########    '#.        `,     ##########
20 //       ##########    ####'      ####.   :#########;
21 //      `#########'   :#####;    ######    ##########
22 //      :#########    #######:  #######    :#########
23 //      +#########    :#######.########     #########`
24 //      #########;     ###############'     #########:
25 //      #########       #############+      '########'
26 //      #########        ############       :#########
27 //      #########         ##########        ,#########
28 //      #########         :########         ,#########
29 //      #########        ,##########        ,#########
30 //      #########       ,############       :########+
31 //      #########      .#############+      '########'
32 //      #########:    `###############'     #########,
33 //      +########+    ;#######`;#######     #########
34 //      ,#########    '######`  '######    :#########
35 //       #########;   .#####`    '#####    ##########
36 //       ##########    '###`      +###    :#########:
37 //       ;#########+     `                ##########
38 //        ##########,                    ###########
39 //         ###########;                ############
40 //         +############             .############`
41 //          ###########+           ,#############;
42 //          `###########     ;++#################
43 //           :##########,    ###################
44 //            '###########.'###################
45 //             +##############################
46 //              '############################`
47 //               .##########################
48 //                 #######################:
49 //                   ###################+
50 //                     +##############:
51 //                        :#######+`
52 //
53 //
54 //
55 // Play0x.com (The ONLY gaming platform for all ERC20 Tokens)
56 // -------------------------------------------------------------------------------------------------------
57 // * Multiple types of game platforms
58 // * Build your own game zone - Not only playing games, but also allowing other players to join your game.
59 // * Support all ERC20 tokens.
60 //
61 //
62 //
63 // 0xC Token (Contract address : 0x60d8234a662651e586173c17eb45ca9833a7aa6c)
64 // -------------------------------------------------------------------------------------------------------
65 // * 0xC Token is an ERC20 Token specifically for digital entertainment.
66 // * No ICO and private sales,fair access.
67 // * There will be hundreds of games using 0xC as a game token.
68 // * Token holders can permanently get ETH's profit sharing.
69 //
70 
71 /**
72  * @title SafeMath
73  * @dev Math operations with safety checks that revert on error
74  */
75 library SafeMath {
76 
77   /**
78   * @dev Multiplies two numbers, reverts on overflow.
79   */
80   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
81     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
82     // benefit is lost if 'b' is also tested.
83     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
84     if (a == 0) {
85       return 0;
86     }
87 
88     uint256 c = a * b;
89     require(c / a == b);
90 
91     return c;
92   }
93 
94   /**
95   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
96   */
97   function div(uint256 a, uint256 b) internal pure returns (uint256) {
98     require(b > 0); // Solidity only automatically asserts when dividing by 0
99     uint256 c = a / b;
100     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
101 
102     return c;
103   }
104 
105   /**
106   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
107   */
108   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109     require(b <= a);
110     uint256 c = a - b;
111 
112     return c;
113   }
114 
115   /**
116   * @dev Adds two numbers, reverts on overflow.
117   */
118   function add(uint256 a, uint256 b) internal pure returns (uint256) {
119     uint256 c = a + b;
120     require(c >= a);
121 
122     return c;
123   }
124 
125   /**
126   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
127   * reverts when dividing by zero.
128   */
129   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
130     require(b != 0);
131     return a % b;
132   }
133 }
134 
135 /**
136 * @title ERC20 interface
137 * @dev see https://github.com/ethereum/EIPs/issues/20
138 */
139 contract ERC20 {
140     function approve(address _spender, uint256 _value) public returns (bool success);
141     function allowance(address owner, address spender) public constant returns (uint256);
142     function balanceOf(address who) public constant returns  (uint256);
143     function transferFrom(address from, address to, uint256 value) public returns (bool);
144     function transfer(address _to, uint256 _value) public;
145     event Transfer(address indexed from, address indexed to, uint256 value);
146     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
147 }
148 
149 contract Play0x_LottoBall {
150 
151     using SafeMath for uint256;
152     using SafeMath for uint128;
153     using SafeMath for uint40;
154     using SafeMath for uint8;
155 
156     uint public jackpotSize;
157 
158     uint public MIN_BET;
159     uint public MAX_BET;
160     uint public MAX_AMOUNT;
161     uint constant MAX_MODULO = 15;
162 
163     //Adjustable max bet profit.
164     uint public maxProfit; 
165 
166     //Fee percentage
167     uint8 public platformFeePercentage = 15;
168     uint8 public jackpotFeePercentage = 5;
169     uint8 public ERC20rewardMultiple = 5;
170     
171     //0:ether 1:token
172     uint8 public currencyType = 0;
173 
174     //Bets can be refunded via invoking refundBet.
175     uint constant BetExpirationBlocks = 250;
176 
177     //Funds that are locked in potentially winning bets.
178     uint public lockedInBets; 
179 
180     //Standard contract ownership transfer.
181     address public owner;
182     address private nextOwner; 
183     address public secretSigner;
184     address public refunder; 
185 
186     //The address corresponding to a private key used to sign placeBet commits. 
187     address public ERC20ContractAddres;
188     
189     address constant DUMMY_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
190 
191     //Single bet.
192     struct Bet {
193         //Amount in wei.
194         uint amount;
195         //place tx Block number.
196         uint40 placeBlockNumber;
197         // Address of a gambler.
198         address gambler;  
199         // Game mode.
200         uint8 machineMode; 
201         // Number of draws
202         uint8 rotateTime;
203     }
204 
205     //Mapping from commits
206     mapping (uint => Bet) public bets;
207 
208     //Mapping from signer
209     mapping(address => bool) public signerList;
210     
211     //Mapping from withdrawal
212     mapping(uint8 => uint32) public withdrawalMode;
213      
214     //Admin Payment
215     event ToManagerPayment(address indexed beneficiary, uint amount);
216     event ToManagerFailedPayment(address indexed beneficiary, uint amount);
217     event ToOwnerPayment(address indexed beneficiary, uint amount);
218     event ToOwnerFailedPayment(address indexed beneficiary, uint amount);
219 
220     //Bet Payment
221     event Payment(address indexed beneficiary, uint amount);
222     event AllFundsPayment(address indexed beneficiary, uint amount);
223     event AllTokenPayment(address indexed beneficiary, uint amount);
224     event FailedPayment(address indexed beneficiary, uint amount);
225     event TokenPayment(address indexed beneficiary, uint amount);
226 
227     //JACKPOT
228     event JackpotBouns(address indexed beneficiary, uint amount);
229 
230     // Events that are issued to make statistic recovery easier.
231     event PlaceBetLog(address indexed player, uint amount,uint8 rotateTime,uint commit);
232 
233     //Play0x_LottoBall_Event
234     event BetRelatedData(
235         address indexed player,
236         uint playerBetAmount,
237         uint playerGetAmount,
238         bytes32 entropy, 
239         uint8 rotateTime
240     );
241     
242     //Refund_Event
243     event RefundLog(address indexed player, uint commit, uint amount);
244  
245     // Constructor. Deliberately does not take any parameters.
246     constructor () public {
247         owner = msg.sender;
248         secretSigner = DUMMY_ADDRESS; 
249         ERC20ContractAddres = DUMMY_ADDRESS; 
250         refunder = DUMMY_ADDRESS; 
251     }
252 
253     // Standard modifier on methods invokable only by contract owner.
254     modifier onlyOwner {
255         require (msg.sender == owner);
256         _;
257     }
258     
259     modifier onlyRefunder {
260         require (msg.sender == refunder);
261         _;
262     } 
263     
264     modifier onlySigner {
265         require (signerList[msg.sender] == true); 
266         _;
267     }
268     
269     //Init Parameter.
270     function initialParameter(
271         // address _manager,
272         address _secretSigner,
273         address _erc20tokenAddress ,
274         address _refunder,
275         
276         uint _MIN_BET,
277         uint _MAX_BET,
278         uint _maxProfit, 
279         uint _MAX_AMOUNT, 
280         
281         uint8 _platformFeePercentage,
282         uint8 _jackpotFeePercentage,
283         uint8 _ERC20rewardMultiple,
284         uint8 _currencyType,
285         
286         address[] _signerList,
287         uint32[] _withdrawalMode)public onlyOwner{
288             
289         secretSigner = _secretSigner;
290         ERC20ContractAddres = _erc20tokenAddress;
291         refunder = _refunder; 
292         
293         MIN_BET = _MIN_BET;
294         MAX_BET = _MAX_BET;
295         maxProfit = _maxProfit; 
296         MAX_AMOUNT = _MAX_AMOUNT;
297         
298         platformFeePercentage = _platformFeePercentage;
299         jackpotFeePercentage = _jackpotFeePercentage;
300         ERC20rewardMultiple = _ERC20rewardMultiple;
301         currencyType = _currencyType;
302         
303         createSignerList(_signerList);
304         createWithdrawalMode(_withdrawalMode); 
305     }
306  
307     // Standard contract ownership transfer implementation,
308     function approveNextOwner(address _nextOwner) public onlyOwner {
309         require (_nextOwner != owner);
310         nextOwner = _nextOwner;
311     }
312 
313     function acceptNextOwner() public {
314         require (msg.sender == nextOwner);
315         owner = nextOwner;
316     }
317 
318     // Fallback function deliberately left empty.
319     function () public payable {
320     }
321    
322     //Creat SignerList.
323     function createSignerList(address[] _signerList)private onlyOwner  {
324         for (uint i=0; i<_signerList.length; i++) {
325             address newSigner = _signerList[i];
326             signerList[newSigner] = true; 
327         } 
328     }
329      
330     //Creat WithdrawalMode.
331     function createWithdrawalMode(uint32[] _withdrawalMode)private onlyOwner {
332         for (uint8 i=0; i<_withdrawalMode.length; i++) {
333             uint32 newWithdrawalMode = _withdrawalMode[i];
334             uint8 mode = i + 1;
335             withdrawalMode[mode] = newWithdrawalMode;
336         } 
337     }
338      
339     //Set SecretSigner.
340     function setSecretSigner(address _secretSigner) external onlyOwner {
341         secretSigner = _secretSigner;
342     } 
343     
344     //Set settle signer.
345     function setSigner(address signer,bool isActive )external onlyOwner{
346         signerList[signer] = isActive; 
347     } 
348     
349     //Set Refunder.
350     function setRefunder(address _refunder) external onlyOwner {
351         refunder = _refunder;
352     } 
353      
354     //Set tokenAddress.
355     function setTokenAddress(address _tokenAddress) external onlyOwner {
356         ERC20ContractAddres = _tokenAddress;
357     }
358  
359     // Change max bet reward. Setting this to zero effectively disables betting.
360     function setMaxProfit(uint _maxProfit) external onlyOwner {
361         require (_maxProfit < MAX_AMOUNT && _maxProfit > 0);
362         maxProfit = _maxProfit;
363     }
364 
365     // Funds withdrawal.
366     function withdrawFunds(address beneficiary, uint withdrawAmount) external onlyOwner {
367         require (withdrawAmount <= address(this).balance && withdrawAmount > 0);
368 
369         uint safetyAmount = jackpotSize.add(lockedInBets).add(withdrawAmount);
370         safetyAmount = safetyAmount.add(withdrawAmount);
371 
372         require (safetyAmount <= address(this).balance);
373         sendFunds(beneficiary, withdrawAmount );
374     }
375 
376     // Token withdrawal.
377     function withdrawToken(address beneficiary, uint withdrawAmount) external onlyOwner {
378         require (withdrawAmount <= ERC20(ERC20ContractAddres).balanceOf(address(this)));
379 
380         uint safetyAmount = jackpotSize.add(lockedInBets);
381         safetyAmount = safetyAmount.add(withdrawAmount);
382         require (safetyAmount <= ERC20(ERC20ContractAddres).balanceOf(address(this)));
383 
384          ERC20(ERC20ContractAddres).transfer(beneficiary, withdrawAmount);
385          emit TokenPayment(beneficiary, withdrawAmount);
386     }
387 
388     //Recovery of funds
389     function withdrawAllFunds(address beneficiary) external onlyOwner {
390         if (beneficiary.send(address(this).balance)) {
391             lockedInBets = 0;
392             jackpotSize = 0;
393             emit AllFundsPayment(beneficiary, address(this).balance);
394         } else {
395             emit FailedPayment(beneficiary, address(this).balance);
396         }
397     }
398 
399     //Recovery of Token funds
400     function withdrawAlltokenFunds(address beneficiary) external onlyOwner {
401         ERC20(ERC20ContractAddres).transfer(beneficiary, ERC20(ERC20ContractAddres).balanceOf(address(this)));
402         lockedInBets = 0;
403         jackpotSize = 0;
404         emit AllTokenPayment(beneficiary, ERC20(ERC20ContractAddres).balanceOf(address(this)));
405     }
406 
407     // Contract may be destroyed only when there are no ongoing bets,
408     // either settled or refunded. All funds are transferred to contract owner.
409     function kill() external onlyOwner {
410         require (lockedInBets == 0); 
411         selfdestruct(owner);
412     }
413 
414     function getContractInformation()public view returns(
415         uint _jackpotSize, 
416         uint _MIN_BET,
417         uint _MAX_BET,
418         uint _MAX_AMOUNT,
419         uint8 _platformFeePercentage,
420         uint8 _jackpotFeePercentage,
421         uint _maxProfit, 
422         uint _lockedInBets){
423 
424         _jackpotSize = jackpotSize; 
425         _MIN_BET = MIN_BET;
426         _MAX_BET = MAX_BET;
427         _MAX_AMOUNT = MAX_AMOUNT;
428         _platformFeePercentage = platformFeePercentage;
429         _jackpotFeePercentage = jackpotFeePercentage;
430         _maxProfit = maxProfit; 
431         _lockedInBets = lockedInBets;  
432     }
433 
434     function getContractAddress()public view returns(
435         address _owner, 
436         address _ERC20ContractAddres,
437         address _secretSigner,
438         address _refunder ){
439 
440         _owner = owner; 
441         _ERC20ContractAddres = ERC20ContractAddres;
442         _secretSigner = secretSigner;  
443         _refunder = refunder; 
444     } 
445  
446     //Bet by ether: Commits are signed with a block limit to ensure that they are used at most once.
447     function placeBet(uint8 _rotateTime , uint8 _machineMode , uint _commitLastBlock, uint _commit, bytes32 r, bytes32 s ) external payable {
448          
449         // Check that the bet is in 'clean' state.
450         Bet storage bet = bets[_commit];
451         require (bet.gambler == address(0));
452         
453         //Check SecretSigner.
454         bytes32 signatureHash = keccak256(abi.encodePacked(_commitLastBlock, _commit));
455         require (secretSigner == ecrecover(signatureHash, 27, r, s));
456         
457         //Check rotateTime ,machineMode and commitLastBlock.
458         require (_rotateTime > 0 && _rotateTime <= 20); 
459         
460         //_machineMode: 1~15
461         require (_machineMode > 0 && _machineMode <= MAX_MODULO);
462         
463         require (block.number < _commitLastBlock );
464          
465         lockedInBets = lockedInBets.add( getPossibleWinPrize(withdrawalMode[_machineMode],msg.value) );
466         
467         //Check the highest profit
468         require (getPossibleWinPrize(withdrawalMode[_machineMode],msg.value) <= maxProfit && getPossibleWinPrize(withdrawalMode[_machineMode],msg.value) > 0);
469         require (lockedInBets.add(jackpotSize) <= address(this).balance);
470  
471         //Amount should be within range
472         require (msg.value >= MIN_BET && msg.value <= MAX_BET);
473         
474         emit PlaceBetLog(msg.sender, msg.value,_rotateTime,_commit);
475           
476         // Store bet parameters on blockchain.
477         bet.amount = msg.value;
478         bet.placeBlockNumber = uint40(block.number);
479         bet.gambler = msg.sender;  
480         bet.machineMode = uint8(_machineMode);  
481         bet.rotateTime = uint8(_rotateTime);  
482     }
483 
484     function placeTokenBet(uint8 _rotateTime , uint8 _machineMode , uint _commitLastBlock, uint _commit, bytes32 r, bytes32 s, uint _amount, address _playerAddress) external onlySigner {
485         
486         // Check that the bet is in 'clean' state.
487         Bet storage bet = bets[_commit];
488         require (bet.gambler == address(0));
489         
490         //Check SecretSigner.
491         bytes32 signatureHash = keccak256(abi.encodePacked(_commitLastBlock, _commit));
492         require (secretSigner == ecrecover(signatureHash, 27, r, s));
493         
494         //Check rotateTime ,machineMode and commitLastBlock.
495         require (_rotateTime > 0 && _rotateTime <= 20); 
496          
497         //_machineMode: 1~15
498         require (_machineMode > 0 && _machineMode <= MAX_MODULO); 
499         
500         require (block.number < _commitLastBlock ); 
501         
502         //Token lockedInBets 
503         lockedInBets = lockedInBets.add(getPossibleWinPrize(withdrawalMode[_machineMode],_amount));
504         
505         //Check the highest profit
506         require (getPossibleWinPrize(withdrawalMode[_machineMode],_amount) <= maxProfit && getPossibleWinPrize(withdrawalMode[_machineMode],_amount) > 0);
507         require (lockedInBets.add(jackpotSize) <= ERC20(ERC20ContractAddres).balanceOf(address(this)));
508   
509         //Amount should be within range
510         require (_amount >= MIN_BET && _amount <= MAX_BET);
511         
512         emit PlaceBetLog(_playerAddress, _amount, _rotateTime,_commit);
513         
514         // Store bet parameters on blockchain.
515         bet.amount = _amount;
516         bet.placeBlockNumber = uint40(block.number);
517         bet.gambler = _playerAddress;  
518         bet.machineMode = _machineMode;
519         bet.rotateTime = _rotateTime;
520     }
521  
522     function settleBet(bytes32 luckySeed,uint reveal, bytes32 blockHash ) external onlySigner{ 
523           
524         // "commit" for bet settlement can only be obtained by hashing a "reveal".
525         uint commit = uint(keccak256(abi.encodePacked(reveal)));
526 
527         // Fetch bet parameters into local variables (to save gas).
528         Bet storage bet = bets[commit];
529         
530         // Check that bet is in 'active' state and check that bet has not expired yet.
531         require (bet.amount != 0); 
532         require (bet.rotateTime > 0 && bet.rotateTime <= 20); 
533         require (bet.machineMode > 0 && bet.machineMode <= MAX_MODULO); 
534         require (block.number > bet.placeBlockNumber);
535         require (block.number <= bet.placeBlockNumber.add(BetExpirationBlocks));
536         require (blockhash(bet.placeBlockNumber) == blockHash);
537  
538         //check possibleWinAmount   
539         require (getPossibleWinPrize(withdrawalMode[bet.machineMode],bet.amount) < maxProfit); 
540          
541         require (luckySeed > 0); 
542 
543         //The RNG - combine "reveal" and blockhash of LuckySeed using Keccak256.
544         bytes32 _entropy = keccak256(
545             abi.encodePacked(
546                 uint(
547                     keccak256(
548                         abi.encodePacked(
549                             reveal,
550                             luckySeed
551                         )
552                     )
553                 ),
554                 blockHash
555             )
556         );
557         
558         //Player profit
559         uint totalAmount = 0;
560         
561         //Player Token profit
562         uint totalTokenAmount = 0;
563         
564         //Jackpot check default value
565         bool isGetJackpot = false; 
566         
567         //Settlement record
568         bytes32 tmp_entropy = _entropy; 
569         
570         //Billing mode
571         uint8 machineMode = bet.machineMode; 
572         
573         for (uint8 i = 0; i < bet.rotateTime; i++) {
574             
575             //every round result
576             bool isWinThisRound = false;
577             
578             //Random number of must be less than the machineMode
579             assembly {   
580                 switch gt(machineMode,and(tmp_entropy, 0xf))
581                 case 1 {
582                     isWinThisRound := 1
583                 }
584             }
585 
586             if (isWinThisRound == true ){
587                 //bet win, get single round bonus
588                 totalAmount = totalAmount.add(getPossibleWinPrize(withdrawalMode[bet.machineMode],bet.amount).div(bet.rotateTime));
589 
590                 //Platform fee determination:Ether Game Winning players must pay platform fees 
591                 totalAmount = totalAmount.sub( 
592                         (
593                             (
594                                 bet.amount.div(bet.rotateTime)
595                             ).mul(platformFeePercentage)
596                         ).div(1000) 
597                     );
598             }else if ( isWinThisRound == false && currencyType == 0 && ERC20(ERC20ContractAddres).balanceOf(address(this)) > 0){
599                 //Ether game lose, get token reward 
600                  totalTokenAmount = totalTokenAmount.add(bet.amount.div(bet.rotateTime).mul(ERC20rewardMultiple));
601             }
602 
603             //Get jackpotWin Result, only one chance to win Jackpot in each game.
604             if (isGetJackpot == false){ 
605                 //getJackpotWinBonus
606                 assembly { 
607                     let buf := and(tmp_entropy, 0xffff)  
608                     switch buf
609                     case 0xffff {
610                         isGetJackpot := 1
611                     }
612                 }
613             }
614             
615             //This round is settled, shift settlement record.
616             tmp_entropy = tmp_entropy >> 4;
617         } 
618          
619         //Player get Jackpot 
620         if (isGetJackpot == true ) { 
621             emit JackpotBouns(bet.gambler,jackpotSize);
622             
623             totalAmount = totalAmount.add(jackpotSize);
624             jackpotSize = 0; 
625         } 
626  
627         if (currencyType == 0) {
628             //Ether game
629             if (totalAmount != 0 && totalAmount < maxProfit){
630                 sendFunds(bet.gambler, totalAmount );
631             }
632 
633             //Send ERC20 Token
634             if (totalTokenAmount != 0){ 
635                 
636                 if(ERC20(ERC20ContractAddres).balanceOf(address(this)) > 0){
637                     ERC20(ERC20ContractAddres).transfer(bet.gambler, totalTokenAmount);
638                     emit TokenPayment(bet.gambler, totalTokenAmount);
639                 }
640             }
641         }else if(currencyType == 1){
642             //ERC20 game
643 
644             //Send ERC20 Token
645             if (totalAmount != 0 && totalAmount < maxProfit){
646                 if(ERC20(ERC20ContractAddres).balanceOf(address(this)) > 0){
647                     ERC20(ERC20ContractAddres).transfer(bet.gambler, totalAmount);
648                     emit TokenPayment(bet.gambler, totalAmount);
649                 }
650             }
651         }
652 
653         //Unlock the bet amount, regardless of the outcome.
654         lockedInBets = lockedInBets.sub(getPossibleWinPrize(withdrawalMode[bet.machineMode],bet.amount));
655 
656   
657         //Save jackpotSize
658         jackpotSize = jackpotSize.add(bet.amount.mul(jackpotFeePercentage).div(1000));
659          
660         emit BetRelatedData(
661             bet.gambler,
662             bet.amount,
663             totalAmount,
664             _entropy, 
665             bet.rotateTime
666         );
667         
668         //Move bet into 'processed' state already.
669         bet.amount = 0;
670     }
671 
672     function runRotateTime (Bet storage bet, bytes32 _entropy )private view returns(uint totalAmount, uint totalTokenAmount, bool isGetJackpot ) {
673            
674         bytes32 tmp_entropy = _entropy; 
675  
676         isGetJackpot = false;
677         
678         uint8 machineMode = bet.machineMode;
679         
680         for (uint8 i = 0; i < bet.rotateTime; i++) {
681             
682             //every round result
683             bool isWinThisRound = false;
684             
685             //Random number of must be less than the machineMode
686             assembly {   
687                 switch gt(machineMode,and(tmp_entropy, 0xf))
688                 case 1 {
689                     isWinThisRound := 1
690                 }
691             }
692 
693             if (isWinThisRound == true ){
694                 //bet win, get single round bonus
695                 totalAmount = totalAmount.add(getPossibleWinPrize(withdrawalMode[bet.machineMode],bet.amount).div(bet.rotateTime));
696 
697                 //Platform fee determination:Ether Game Winning players must pay platform fees 
698                 totalAmount = totalAmount.sub( 
699                         (
700                             (
701                                 bet.amount.div(bet.rotateTime)
702                             ).mul(platformFeePercentage)
703                         ).div(1000) 
704                     );
705             }else if ( isWinThisRound == false && currencyType == 0 && ERC20(ERC20ContractAddres).balanceOf(address(this)) > 0){
706                 //Ether game lose, get token reward 
707                  totalTokenAmount = totalTokenAmount.add(bet.amount.div(bet.rotateTime).mul(ERC20rewardMultiple));
708             }
709 
710             //Get jackpotWin Result, only one chance to win Jackpot in each game.
711             if (isGetJackpot == false){ 
712                 //getJackpotWinBonus
713                 assembly { 
714                     let buf := and(tmp_entropy, 0xffff)  
715                     switch buf
716                     case 0xffff {
717                         isGetJackpot := 1
718                     }
719                 }
720             } 
721             //This round is settled, shift settlement record.
722             tmp_entropy = tmp_entropy >> 4;
723         } 
724 
725         if (isGetJackpot == true ) { 
726             //gambler get jackpot. 
727             totalAmount = totalAmount.add(jackpotSize); 
728         }
729     }
730  
731     //Get deductedBalance
732     function getPossibleWinPrize(uint bonusPercentage,uint senderValue)public pure returns (uint possibleWinAmount) { 
733         //Win Amount  
734         possibleWinAmount = ((senderValue.mul(bonusPercentage))).div(10000);
735     }
736     
737     //Get deductedBalance
738     function getPossibleWinAmount(uint bonusPercentage,uint senderValue)public view returns (uint platformFee,uint jackpotFee,uint possibleWinAmount) {
739 
740         //Platform Fee
741         uint prePlatformFee = (senderValue).mul(platformFeePercentage);
742         platformFee = (prePlatformFee).div(1000);
743 
744         //Get jackpotFee
745         uint preJackpotFee = (senderValue).mul(jackpotFeePercentage);
746         jackpotFee = (preJackpotFee).div(1000);
747 
748         //Win Amount
749         uint preUserGetAmount = senderValue.mul(bonusPercentage);
750         possibleWinAmount = preUserGetAmount.div(10000);
751     }
752 
753     function settleBetVerifi(bytes32 luckySeed,uint reveal,bytes32 blockHash  )external view onlySigner returns(uint totalAmount,uint totalTokenAmount,bytes32 _entropy,bool isGetJackpot ) {
754         
755         // "commit" for bet settlement can only be obtained by hashing a "reveal".
756         uint commit = uint(keccak256(abi.encodePacked(reveal)));
757 
758         // Fetch bet parameters into local variables (to save gas).
759         Bet storage bet = bets[commit];
760          
761         //The RNG - combine "reveal" and blockhash of LuckySeed using Keccak256.
762         _entropy = keccak256(
763             abi.encodePacked(
764                 uint(
765                     keccak256(
766                         abi.encodePacked(
767                                 reveal,
768                                 luckySeed
769                             )
770                         )
771                     ),
772                 blockHash
773             )
774         );
775         
776         isGetJackpot = false;
777         (totalAmount,totalTokenAmount,isGetJackpot) = runRotateTime( 
778             bet,
779             _entropy 
780         ); 
781     }
782 
783     // Refund transaction
784     function refundBet(uint commit) external onlyRefunder{
785         // Check that bet is in 'active' state.
786         Bet storage bet = bets[commit];
787         uint amount = bet.amount; 
788         uint8 machineMode = bet.machineMode; 
789         
790         require (amount != 0, "Bet should be in an 'active' state");
791 
792         // Check that bet has already expired.
793         require (block.number > bet.placeBlockNumber.add(BetExpirationBlocks));
794   
795         //Amount unlock
796         lockedInBets = lockedInBets.sub(getPossibleWinPrize(withdrawalMode[machineMode],bet.amount));
797  
798         //Refund
799         emit RefundLog(bet.gambler,commit, amount); 
800         sendFunds(bet.gambler, amount );
801         
802         // Move bet into 'processed' state, release funds.
803         bet.amount = 0;
804     }
805 
806     function refundTokenBet(uint commit) external onlyRefunder{
807         // Check that bet is in 'active' state.
808         Bet storage bet = bets[commit];
809         uint amount = bet.amount;
810         uint8 machineMode = bet.machineMode; 
811 
812         require (amount != 0, "Bet should be in an 'active' state");
813 
814         // Check that bet has already expired.
815         require (block.number > bet.placeBlockNumber.add(BetExpirationBlocks));
816  
817         //Amount unlock
818         lockedInBets = lockedInBets.sub(getPossibleWinPrize(withdrawalMode[machineMode],bet.amount));
819 
820         emit RefundLog(bet.gambler,commit, amount); 
821          
822         //Refund
823         emit TokenPayment(bet.gambler, amount);
824         ERC20(ERC20ContractAddres).transfer(bet.gambler, amount);
825          
826         // Move bet into 'processed' state, release funds.
827         bet.amount = 0;
828     }
829 
830     // A helper routine to bulk clean the storage.
831     function clearStorage(uint[] cleanCommits) external onlyRefunder {
832         uint length = cleanCommits.length;
833 
834         for (uint i = 0; i < length; i++) {
835             clearProcessedBet(cleanCommits[i]);
836         }
837     }
838 
839     // Helper routine to move 'processed' bets into 'clean' state.
840     function clearProcessedBet(uint commit) private {
841         Bet storage bet = bets[commit];
842 
843         // Do not overwrite active bets with zeros
844         if (bet.amount != 0 || block.number <= bet.placeBlockNumber + BetExpirationBlocks) {
845             return;
846         }
847 
848         // Zero out the remaining storage
849         bet.placeBlockNumber = 0;
850         bet.gambler = address(0);
851         bet.machineMode = 0;
852         bet.rotateTime = 0; 
853     }
854 
855     // Helper routine to process the payment.
856     function sendFunds(address receiver, uint amount ) private {
857         if (receiver.send(amount)) {
858             emit Payment(receiver, amount);
859         } else {
860             emit FailedPayment(receiver, amount);
861         }
862     } 
863     
864     function sendFundsToOwner(address beneficiary, uint amount) external onlyOwner {
865         if (beneficiary.send(amount)) {
866             emit ToOwnerPayment(beneficiary, amount);
867         } else {
868             emit ToOwnerFailedPayment(beneficiary, amount);
869         }
870     }
871 
872     //Update
873     function updateMIN_BET(uint _uintNumber)external onlyOwner {
874          MIN_BET = _uintNumber;
875     }
876 
877     function updateMAX_BET(uint _uintNumber)external onlyOwner {
878          MAX_BET = _uintNumber;
879     }
880 
881     function updateMAX_AMOUNT(uint _uintNumber)external onlyOwner {
882          MAX_AMOUNT = _uintNumber;
883     } 
884     
885     function updateWithdrawalMode(uint8 _mode, uint32 _modeValue) external onlyOwner{
886        withdrawalMode[_mode]  = _modeValue;
887     } 
888 
889     function updatePlatformFeePercentage(uint8 _platformFeePercentage ) external onlyOwner{
890        platformFeePercentage = _platformFeePercentage;
891     }
892 
893     function updateJackpotFeePercentage(uint8 _jackpotFeePercentage ) external onlyOwner{
894        jackpotFeePercentage = _jackpotFeePercentage;
895     }
896 
897     function updateERC20rewardMultiple(uint8 _ERC20rewardMultiple ) external onlyOwner{
898        ERC20rewardMultiple = _ERC20rewardMultiple;
899     }
900     
901     function updateCurrencyType(uint8 _currencyType ) external onlyOwner{
902        currencyType = _currencyType;
903     }
904     
905     function updateJackpot(uint newSize) external onlyOwner {
906         require (newSize < address(this).balance && newSize > 0); 
907         jackpotSize = newSize;
908     }
909 }