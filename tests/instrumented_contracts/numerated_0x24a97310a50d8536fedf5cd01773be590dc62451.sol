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
149 
150 contract Play0x_LottoBall {
151 
152     using SafeMath for uint256;
153     using SafeMath for uint128;
154     using SafeMath for uint40;
155     using SafeMath for uint8;
156 
157     uint public jackpotSize;
158     uint public tokenJackpotSize;
159 
160     uint public MIN_BET;
161     uint public MAX_BET;
162     uint public MAX_AMOUNT;
163 
164     //Adjustable max bet profit.
165     uint public maxProfit;
166     uint public maxTokenProfit;
167 
168     //Fee percentage
169     uint8 public platformFeePercentage = 15;
170     uint8 public jackpotFeePercentage = 5;
171     uint8 public ERC20rewardMultiple = 5;
172 
173     //Bets can be refunded via invoking refundBet.
174     uint constant BetExpirationBlocks = 250;
175 
176 
177 
178     //Funds that are locked in potentially winning bets.
179     uint public lockedInBets;
180     uint public lockedTokenInBets;
181 
182     bytes32 bitComparisonMask = 0xF;
183 
184     //Standard contract ownership transfer.
185     address public owner;
186     address private nextOwner;
187     address public manager;
188     address private nextManager;
189 
190     //The address corresponding to a private key used to sign placeBet commits.
191     address public secretSigner;
192     address public ERC20ContractAddres;
193     address constant DUMMY_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
194 
195     //Single bet.
196     struct Bet {
197         //Amount in wei.
198         uint amount;
199         //place tx Block number.
200         uint40 placeBlockNumber;
201         // Address of a gambler.
202         address gambler;
203     }
204 
205     //Mapping from commits
206     mapping (uint => Bet) public bets;
207 
208     //Withdrawal mode data.
209     uint32[] public withdrawalMode;
210 
211     // Events that are issued to make statistic recovery easier.
212     event PlaceBetLog(address indexed player, uint amount,uint8 rotateTime);
213 
214     //Admin Payment
215     event ToManagerPayment(address indexed beneficiary, uint amount);
216     event ToManagerFailedPayment(address indexed beneficiary, uint amount);
217     event ToOwnerPayment(address indexed beneficiary, uint amount);
218     event ToOwnerFailedPayment(address indexed beneficiary, uint amount);
219 
220     //Bet Payment
221     event Payment(address indexed beneficiary, uint amount);
222     event FailedPayment(address indexed beneficiary, uint amount);
223     event TokenPayment(address indexed beneficiary, uint amount);
224 
225     //JACKPOT
226     event JackpotBouns(address indexed beneficiary, uint amount);
227     event TokenJackpotBouns(address indexed beneficiary, uint amount);
228 
229     //Play0x_LottoBall_Event
230     event BetRelatedData(
231         address indexed player,
232         uint playerBetAmount,
233         uint playerGetAmount,
234         bytes32 entropy,
235         bytes32 entropy2,
236         uint8 Uplimit,
237         uint8 rotateTime
238     );
239 
240     // Constructor. Deliberately does not take any parameters.
241     constructor () public {
242         owner = msg.sender;
243         manager = DUMMY_ADDRESS;
244         secretSigner = DUMMY_ADDRESS;
245         ERC20ContractAddres = DUMMY_ADDRESS;
246     }
247 
248     // Standard modifier on methods invokable only by contract owner.
249     modifier onlyOwner {
250         require (msg.sender == owner);
251         _;
252     }
253 
254     modifier onlyManager {
255         require (msg.sender == manager);
256         _;
257     }
258 
259     modifier onlyOwnerManager {
260         require (msg.sender == owner || msg.sender == manager);
261         _;
262     }
263 
264     modifier onlySigner {
265         require (msg.sender == secretSigner);
266         _;
267     }
268 
269     //Init Parameter.
270     function initialParameter(address _manager,address _secretSigner,address _erc20tokenAddress ,uint _MIN_BET,uint _MAX_BET,uint _maxProfit,uint _maxTokenProfit, uint _MAX_AMOUNT, uint8 _platformFeePercentage,uint8 _jackpotFeePercentage,uint8 _ERC20rewardMultiple,uint32[] _withdrawalMode)external onlyOwner{
271         manager = _manager;
272         secretSigner = _secretSigner;
273         ERC20ContractAddres = _erc20tokenAddress;
274 
275         MIN_BET = _MIN_BET;
276         MAX_BET = _MAX_BET;
277         maxProfit = _maxProfit;
278         maxTokenProfit = _maxTokenProfit;
279         MAX_AMOUNT = _MAX_AMOUNT;
280         platformFeePercentage = _platformFeePercentage;
281         jackpotFeePercentage = _jackpotFeePercentage;
282         ERC20rewardMultiple = _ERC20rewardMultiple;
283         withdrawalMode = _withdrawalMode;
284     }
285 
286     // Standard contract ownership transfer implementation,
287     function approveNextOwner(address _nextOwner) external onlyOwner {
288         require (_nextOwner != owner);
289         nextOwner = _nextOwner;
290     }
291 
292     function acceptNextOwner() external {
293         require (msg.sender == nextOwner);
294         owner = nextOwner;
295     }
296 
297     // Standard contract ownership transfer implementation,
298     function approveNextManager(address _nextManager) external onlyManager {
299         require (_nextManager != manager);
300         nextManager = _nextManager;
301     }
302 
303     function acceptNextManager() external {
304         require (msg.sender == nextManager);
305         manager = nextManager;
306     }
307 
308     // Fallback function deliberately left empty.
309     function () public payable {
310     }
311 
312     //Set signer.
313     function setSecretSigner(address newSecretSigner) external onlyOwner {
314         secretSigner = newSecretSigner;
315     }
316 
317     //Set tokenAddress.
318     function setTokenAddress(address _tokenAddress) external onlyManager {
319         ERC20ContractAddres = _tokenAddress;
320     }
321 
322 
323     // Change max bet reward. Setting this to zero effectively disables betting.
324     function setMaxProfit(uint _maxProfit) public onlyOwner {
325         require (_maxProfit < MAX_AMOUNT);
326         maxProfit = _maxProfit;
327     }
328 
329     // Funds withdrawal.
330     function withdrawFunds(address beneficiary, uint withdrawAmount) external onlyOwner {
331         require (withdrawAmount <= address(this).balance);
332 
333         uint safetyAmount = jackpotSize.add(lockedInBets).add(withdrawAmount);
334         safetyAmount = safetyAmount.add(withdrawAmount);
335 
336         require (safetyAmount <= address(this).balance);
337         sendFunds(beneficiary, withdrawAmount, withdrawAmount);
338     }
339 
340     // Token withdrawal.
341     function withdrawToken(address beneficiary, uint withdrawAmount) external onlyOwner {
342         require (withdrawAmount <= ERC20(ERC20ContractAddres).balanceOf(address(this)));
343 
344         uint safetyAmount = tokenJackpotSize.add(lockedTokenInBets);
345         safetyAmount = safetyAmount.add(withdrawAmount);
346         require (safetyAmount <= ERC20(ERC20ContractAddres).balanceOf(address(this)));
347 
348          ERC20(ERC20ContractAddres).transfer(beneficiary, withdrawAmount);
349          emit TokenPayment(beneficiary, withdrawAmount);
350     }
351 
352     //Recovery of funds
353     function withdrawAllFunds(address beneficiary) external onlyOwner {
354         if (beneficiary.send(address(this).balance)) {
355             lockedInBets = 0;
356             emit Payment(beneficiary, address(this).balance);
357         } else {
358             emit FailedPayment(beneficiary, address(this).balance);
359         }
360     }
361 
362     //Recovery of Token funds
363     function withdrawAlltokenFunds(address beneficiary) external onlyOwner {
364         ERC20(ERC20ContractAddres).transfer(beneficiary, ERC20(ERC20ContractAddres).balanceOf(address(this)));
365         lockedTokenInBets = 0;
366         emit TokenPayment(beneficiary, ERC20(ERC20ContractAddres).balanceOf(address(this)));
367     }
368 
369     // Contract may be destroyed only when there are no ongoing bets,
370     // either settled or refunded. All funds are transferred to contract owner.
371     function kill() external onlyOwner {
372         require (lockedInBets == 0);
373         require (lockedTokenInBets == 0);
374         selfdestruct(owner);
375     }
376 
377     function getContractInformation()public view returns(
378         uint _jackpotSize,
379         uint _tokenJackpotSize,
380         uint _MIN_BET,
381         uint _MAX_BET,
382         uint _MAX_AMOUNT,
383         uint8 _platformFeePercentage,
384         uint8 _jackpotFeePercentage,
385         uint _maxProfit,
386         uint _maxTokenProfit,
387         uint _lockedInBets,
388         uint _lockedTokenInBets,
389         uint32[] _withdrawalMode){
390 
391         _jackpotSize = jackpotSize;
392         _tokenJackpotSize = tokenJackpotSize;
393         _MIN_BET = MIN_BET;
394         _MAX_BET = MAX_BET;
395         _MAX_AMOUNT = MAX_AMOUNT;
396         _platformFeePercentage = platformFeePercentage;
397         _jackpotFeePercentage = jackpotFeePercentage;
398         _maxProfit = maxProfit;
399         _maxTokenProfit = maxTokenProfit;
400         _lockedInBets = lockedInBets;
401         _lockedTokenInBets = lockedTokenInBets;
402         _withdrawalMode = withdrawalMode;
403     }
404 
405     function getContractAddress()public view returns(
406         address _owner,
407         address _manager,
408         address _secretSigner,
409         address _ERC20ContractAddres ){
410 
411         _owner = owner;
412         _manager= manager;
413         _secretSigner = secretSigner;
414         _ERC20ContractAddres = ERC20ContractAddres;
415     }
416 
417     // Settlement transaction
418     enum PlaceParam {
419         RotateTime,
420         possibleWinAmount
421     }
422 
423     //Bet by ether: Commits are signed with a block limit to ensure that they are used at most once.
424     function placeBet(uint[] placParameter, bytes32 _signatureHash , uint _commitLastBlock, uint _commit, bytes32 r, bytes32 s, uint8 v) external payable {
425         require (uint8(placParameter[uint8(PlaceParam.RotateTime)]) != 0);
426         require (block.number <= _commitLastBlock );
427         require (secretSigner == ecrecover(_signatureHash, v, r, s));
428 
429         // Check that the bet is in 'clean' state.
430         Bet storage bet = bets[_commit];
431         require (bet.gambler == address(0));
432 
433         //Ether balanceet
434         lockedInBets = lockedInBets.add(uint(placParameter[uint8(PlaceParam.possibleWinAmount)]));
435         require (uint(placParameter[uint8(PlaceParam.possibleWinAmount)]) <= msg.value.add(maxProfit));
436         require (lockedInBets <= address(this).balance);
437 
438         // Store bet parameters on blockchain.
439         bet.amount = msg.value;
440         bet.placeBlockNumber = uint40(block.number);
441         bet.gambler = msg.sender;
442 
443         emit PlaceBetLog(msg.sender, msg.value, uint8(placParameter[uint8(PlaceParam.RotateTime)]));
444     }
445 
446     function placeTokenBet(uint[] placParameter,bytes32 _signatureHash , uint _commitLastBlock, uint _commit, bytes32 r, bytes32 s, uint8 v,uint _amount,address _playerAddress) external {
447         require (placParameter[uint8(PlaceParam.RotateTime)] != 0);
448         require (block.number <= _commitLastBlock );
449         require (secretSigner == ecrecover(_signatureHash, v, r, s));
450 
451         // Check that the bet is in 'clean' state.
452         Bet storage bet = bets[_commit];
453         require (bet.gambler == address(0));
454 
455         //Token bet
456         lockedTokenInBets = lockedTokenInBets.add(uint(placParameter[uint8(PlaceParam.possibleWinAmount)]));
457         require (uint(placParameter[uint8(PlaceParam.possibleWinAmount)]) <= _amount.add(maxTokenProfit));
458         require (lockedTokenInBets <= ERC20(ERC20ContractAddres).balanceOf(address(this)));
459 
460         // Store bet parameters on blockchain.
461         bet.amount = _amount;
462         bet.placeBlockNumber = uint40(block.number);
463         bet.gambler = _playerAddress;
464 
465         emit PlaceBetLog(_playerAddress, _amount, uint8(placParameter[uint8(PlaceParam.RotateTime)]));
466     }
467 
468 
469     //Estimated maximum award amount
470      function getBonusPercentageByMachineMode(uint8 machineMode)public view returns( uint upperLimit,uint maxWithdrawalPercentage ){
471          uint limitIndex = machineMode.mul(2);
472          upperLimit = withdrawalMode[limitIndex];
473          maxWithdrawalPercentage = withdrawalMode[(limitIndex.add(1))];
474     }
475 
476     // Settlement transaction
477      enum SettleParam {
478         Uplimit,
479         BonusPercentage,
480         RotateTime,
481         CurrencyType,
482         MachineMode,
483         PerWinAmount,
484         PerBetAmount,
485         PossibleWinAmount,
486         LuckySeed,
487         jackpotFee
488      }
489 
490     function settleBet(uint[] combinationParameter, uint reveal) external {
491 
492         // "commit" for bet settlement can only be obtained by hashing a "reveal".
493         uint commit = uint(keccak256(abi.encodePacked(reveal)));
494 
495         // Fetch bet parameters into local variables (to save gas).
496         Bet storage bet = bets[commit];
497 
498         // Check that bet is in 'active' state and check that bet has not expired yet.
499         require (bet.amount != 0);
500         require (block.number <= bet.placeBlockNumber.add(BetExpirationBlocks));
501 
502         //The RNG - combine "reveal" and blockhash of LuckySeed using Keccak256.
503         bytes32 _entropy = keccak256(
504             abi.encodePacked(
505                 uint(
506                     keccak256(
507                         abi.encodePacked(
508                             uint(
509                                 keccak256(
510                                     abi.encodePacked(
511                                         reveal,
512                                         blockhash(combinationParameter[uint8(SettleParam.LuckySeed)])
513                                     )
514                                 )
515                             ),
516                             blockhash(block.number)
517                         )
518                     )
519                 ),
520                 blockhash(block.timestamp)
521             )
522         );
523 
524          uint totalAmount = 0;
525          uint totalTokenAmount = 0;
526          uint totalJackpotWin = 0;
527          (totalAmount,totalTokenAmount,totalJackpotWin) = runRotateTime(combinationParameter,_entropy,keccak256(abi.encodePacked(uint(_entropy), blockhash(combinationParameter[uint8(SettleParam.LuckySeed)]))));
528 
529         // Add ether JackpotBouns
530         if (totalJackpotWin > 0 && combinationParameter[uint8(SettleParam.CurrencyType)] == 0) {
531 
532             emit JackpotBouns(bet.gambler,totalJackpotWin);
533             totalAmount = totalAmount.add(totalJackpotWin);
534             jackpotSize = uint128(jackpotSize.sub(totalJackpotWin));
535 
536         }else if (totalJackpotWin > 0 && combinationParameter[uint8(SettleParam.CurrencyType)] == 1) {
537 
538             // Add token TokenJackpotBouns
539             emit TokenJackpotBouns(bet.gambler,totalJackpotWin);
540             totalAmount = totalAmount.add(totalJackpotWin);
541             tokenJackpotSize = uint128(tokenJackpotSize.sub(totalJackpotWin));
542         }
543 
544         emit BetRelatedData(bet.gambler,bet.amount,totalAmount,_entropy,keccak256(abi.encodePacked(uint(_entropy), blockhash(combinationParameter[uint8(SettleParam.LuckySeed)]))),uint8(combinationParameter[uint8(SettleParam.Uplimit)]),uint8(combinationParameter[uint8(SettleParam.RotateTime)]));
545 
546         if (combinationParameter[uint8(SettleParam.CurrencyType)] == 0) {
547              //Ether game
548             if (totalAmount != 0){
549                 sendFunds(bet.gambler, totalAmount , totalAmount);
550             }
551 
552             //Send ERC20 Token
553             if (totalTokenAmount != 0){
554 
555                 if(ERC20(ERC20ContractAddres).balanceOf(address(this)) > 0){
556                     ERC20(ERC20ContractAddres).transfer(bet.gambler, totalTokenAmount);
557                     emit TokenPayment(bet.gambler, totalTokenAmount);
558                 }
559             }
560         }else if(combinationParameter[uint8(SettleParam.CurrencyType)] == 1){
561               //ERC20 game
562 
563             //Send ERC20 Token
564             if (totalAmount != 0){
565                 if(ERC20(ERC20ContractAddres).balanceOf(address(this)) > 0){
566                     ERC20(ERC20ContractAddres).transfer(bet.gambler, totalAmount);
567                     emit TokenPayment(bet.gambler, totalAmount);
568                 }
569             }
570         }
571 
572                 // Unlock the bet amount, regardless of the outcome.
573         if (combinationParameter[uint8(SettleParam.CurrencyType)] == 0) {
574                 lockedInBets = lockedInBets.sub(combinationParameter[uint8(SettleParam.PossibleWinAmount)]);
575         } else if (combinationParameter[uint8(SettleParam.CurrencyType)] == 1){
576                 lockedTokenInBets = lockedTokenInBets.sub(combinationParameter[uint8(SettleParam.PossibleWinAmount)]);
577         }
578 
579         //Move bet into 'processed' state already.
580         bet.amount = 0;
581 
582         //Save jackpotSize
583         if (uint16(combinationParameter[uint8(SettleParam.CurrencyType)]) == 0) {
584             jackpotSize = jackpotSize.add(uint(combinationParameter[uint8(SettleParam.jackpotFee)]));
585         }else if (uint16(combinationParameter[uint8(SettleParam.CurrencyType)]) == 1) {
586             tokenJackpotSize = tokenJackpotSize.add(uint(combinationParameter[uint8(SettleParam.jackpotFee)]));
587         }
588     }
589 
590 
591     function runRotateTime ( uint[] combinationParameter, bytes32 _entropy ,bytes32 _entropy2)private view  returns(uint totalAmount,uint totalTokenAmount,uint totalJackpotWin) {
592 
593         bytes32 resultMask = 0xF000000000000000000000000000000000000000000000000000000000000000;
594         bytes32 tmp_entropy;
595         bytes32 tmp_Mask = resultMask;
596 
597         bool isGetJackpot = false;
598 
599         for (uint8 i = 0; i < combinationParameter[uint8(SettleParam.RotateTime)]; i++) {
600             if (i < 64){
601                 tmp_entropy = _entropy & tmp_Mask;
602                 tmp_entropy = tmp_entropy >> (4*(64 - (i.add(1))));
603                 tmp_Mask =  tmp_Mask >> 4;
604             }else{
605                 if ( i == 64){
606                     tmp_Mask = resultMask;
607                 }
608                 tmp_entropy = _entropy2 & tmp_Mask;
609                 tmp_entropy = tmp_entropy >> (4*( 64 - (i%63)));
610                 tmp_Mask =  tmp_Mask >> 4;
611             }
612 
613             if ( uint(tmp_entropy) < uint(combinationParameter[uint8(SettleParam.Uplimit)]) ){
614                 //bet win
615                 totalAmount = totalAmount.add(combinationParameter[uint8(SettleParam.PerWinAmount)]);
616 
617                 //Platform fee determination:Ether Game Winning players must pay platform fees
618                 uint platformFees = combinationParameter[uint8(SettleParam.PerBetAmount)].mul(platformFeePercentage);
619                 platformFees = platformFees.div(1000);
620                 totalAmount = totalAmount.sub(platformFees);
621             }else{
622                 //bet lose
623                 if (uint(combinationParameter[uint8(SettleParam.CurrencyType)]) == 0){
624 
625                     if(ERC20(ERC20ContractAddres).balanceOf(address(this)) > 0){
626                         //get token reward
627                         uint rewardAmount = uint(combinationParameter[uint8(SettleParam.PerBetAmount)]).mul(ERC20rewardMultiple);
628                         totalTokenAmount = totalTokenAmount.add(rewardAmount);
629                     }
630                 }
631             }
632 
633             //Get jackpotWin Result
634             if (isGetJackpot == false){
635                 isGetJackpot = getJackpotWinBonus(i,_entropy,_entropy2);
636             }
637         }
638 
639         if (isGetJackpot == true && combinationParameter[uint8(SettleParam.CurrencyType)] == 0) {
640             //gambler get ether bonus.
641             totalJackpotWin = jackpotSize;
642         }else if (isGetJackpot == true && combinationParameter[uint8(SettleParam.CurrencyType)] == 1) {
643             //gambler get token bonus.
644             totalJackpotWin = tokenJackpotSize;
645         }
646     }
647 
648     function getJackpotWinBonus (uint8 i,bytes32 entropy,bytes32 entropy2) private pure returns (bool isGetJackpot) {
649         bytes32 one;
650         bytes32 two;
651         bytes32 three;
652         bytes32 four;
653 
654         bytes32 resultMask = 0xF000000000000000000000000000000000000000000000000000000000000000;
655         bytes32 jackpo_Mask = resultMask;
656 
657         if (i < 61){
658             one = (entropy & jackpo_Mask) >> 4*(64 - (i + 1));
659                 jackpo_Mask =  jackpo_Mask >> 4;
660             two = (entropy & jackpo_Mask)  >> (4*(64 - (i + 2)));
661                 jackpo_Mask =  jackpo_Mask >> 4;
662             three = (entropy & jackpo_Mask) >> (4*(64 - (i + 3)));
663                 jackpo_Mask =  jackpo_Mask >> 4;
664             four = (entropy & jackpo_Mask) >> (4*(64 - (i + 4)));
665                 jackpo_Mask =  jackpo_Mask << 8;
666         }
667         else if(i >= 61){
668             if(i == 61){
669                 one = (entropy & jackpo_Mask) >> 4*(64 - (i + 1));
670                     jackpo_Mask =  jackpo_Mask >> 4;
671                 two = (entropy & jackpo_Mask)  >> (4*(64 - (i + 2)));
672                     jackpo_Mask =  jackpo_Mask >> 4;
673                 three = (entropy & jackpo_Mask) >> (4*(64 - (i + 3)));
674                     jackpo_Mask =  jackpo_Mask << 4;
675                 four = (entropy2 & 0xF000000000000000000000000000000000000000000000000000000000000000) >> 4*63;
676             }
677             else if(i == 62){
678                 one = (entropy & jackpo_Mask) >> 4*(64 - (i + 1));
679                     jackpo_Mask =  jackpo_Mask >> 4;
680                 two = (entropy & jackpo_Mask)  >> (4*(64 - (i + 2)));
681                 three = (entropy2 & 0xF000000000000000000000000000000000000000000000000000000000000000) >> 4*63;
682                 four =  (entropy2 & 0x0F00000000000000000000000000000000000000000000000000000000000000) >> 4*62;
683             }
684             else if(i == 63){
685                 one = (entropy & jackpo_Mask) >> 4*(64 - (i + 1));
686                 two = (entropy2 & 0xF000000000000000000000000000000000000000000000000000000000000000)  >> 4*63;
687                     jackpo_Mask =  jackpo_Mask >> 4;
688                 three = (entropy2 & 0x0F00000000000000000000000000000000000000000000000000000000000000) >> 4*62;
689                     jackpo_Mask =  jackpo_Mask << 4;
690                 four = (entropy2 & 0x00F0000000000000000000000000000000000000000000000000000000000000) >> 4*61;
691 
692                     jackpo_Mask = 0xF000000000000000000000000000000000000000000000000000000000000000;
693             }
694             else {
695                 one = (entropy2 & jackpo_Mask) >>  (4*( 64 - (i%64 + 1)));
696                     jackpo_Mask =  jackpo_Mask >> 4;
697                 two = (entropy2 & jackpo_Mask)  >> (4*( 64 - (i%64 + 2)))   ;
698                     jackpo_Mask =  jackpo_Mask >> 4;
699                 three = (entropy2 & jackpo_Mask) >> (4*( 64 - (i%64 + 3))) ;
700                     jackpo_Mask =  jackpo_Mask >> 4;
701                 four = (entropy2 & jackpo_Mask) >>(4*( 64 - (i%64 + 4)));
702                     jackpo_Mask =  jackpo_Mask << 8;
703             }
704         }
705 
706         if ((one ^ 0xF) == 0 && (two ^ 0xF) == 0 && (three ^ 0xF) == 0 && (four ^ 0xF) == 0){
707             isGetJackpot = true;
708        }
709     }
710 
711     //Get deductedBalance
712     function getPossibleWinAmount(uint bonusPercentage,uint senderValue)public view returns (uint platformFee,uint jackpotFee,uint possibleWinAmount) {
713 
714         //Platform Fee
715         uint prePlatformFee = (senderValue).mul(platformFeePercentage);
716         platformFee = (prePlatformFee).div(1000);
717 
718         //Get jackpotFee
719         uint preJackpotFee = (senderValue).mul(jackpotFeePercentage);
720         jackpotFee = (preJackpotFee).div(1000);
721 
722         //Win Amount
723         uint preUserGetAmount = senderValue.mul(bonusPercentage);
724         possibleWinAmount = preUserGetAmount.div(10000);
725     }
726 
727     // Refund transaction
728     function refundBet(uint commit,uint8 machineMode) external {
729         // Check that bet is in 'active' state.
730         Bet storage bet = bets[commit];
731         uint amount = bet.amount;
732 
733         require (amount != 0, "Bet should be in an 'active' state");
734 
735         // Check that bet has already expired.
736         require (block.number > bet.placeBlockNumber.add(BetExpirationBlocks));
737 
738         // Move bet into 'processed' state, release funds.
739         bet.amount = 0;
740 
741         //Maximum amount to be confirmed
742         uint platformFee;
743         uint jackpotFee;
744         uint possibleWinAmount;
745         uint upperLimit;
746         uint maxWithdrawalPercentage;
747         (upperLimit,maxWithdrawalPercentage) = getBonusPercentageByMachineMode(machineMode);
748         (platformFee, jackpotFee, possibleWinAmount) = getPossibleWinAmount(maxWithdrawalPercentage,amount);
749 
750         //Amount unlock
751         lockedInBets = lockedInBets.sub(possibleWinAmount);
752 
753         //Refund
754         sendFunds(bet.gambler, amount, amount);
755     }
756 
757     function refundTokenBet(uint commit,uint8 machineMode) external {
758         // Check that bet is in 'active' state.
759         Bet storage bet = bets[commit];
760         uint amount = bet.amount;
761 
762         require (amount != 0, "Bet should be in an 'active' state");
763 
764         // Check that bet has already expired.
765         require (block.number > bet.placeBlockNumber.add(BetExpirationBlocks));
766 
767         // Move bet into 'processed' state, release funds.
768         bet.amount = 0;
769 
770         //Maximum amount to be confirmed
771         uint platformFee;
772         uint jackpotFee;
773         uint possibleWinAmount;
774         uint upperLimit;
775         uint maxWithdrawalPercentage;
776         (upperLimit,maxWithdrawalPercentage) = getBonusPercentageByMachineMode(machineMode);
777         (platformFee, jackpotFee, possibleWinAmount) = getPossibleWinAmount(maxWithdrawalPercentage,amount);
778 
779         //Amount unlock
780         lockedTokenInBets = uint128(lockedTokenInBets.sub(possibleWinAmount));
781 
782         //Refund
783         ERC20(ERC20ContractAddres).transfer(bet.gambler, amount);
784         emit TokenPayment(bet.gambler, amount);
785     }
786 
787     // A helper routine to bulk clean the storage.
788     function clearStorage(uint[] cleanCommits) external {
789         uint length = cleanCommits.length;
790 
791         for (uint i = 0; i < length; i++) {
792             clearProcessedBet(cleanCommits[i]);
793         }
794     }
795 
796     // Helper routine to move 'processed' bets into 'clean' state.
797     function clearProcessedBet(uint commit) private {
798         Bet storage bet = bets[commit];
799 
800         // Do not overwrite active bets with zeros
801         if (bet.amount != 0 || block.number <= bet.placeBlockNumber + BetExpirationBlocks) {
802             return;
803         }
804 
805         // Zero out the remaining storage
806         bet.placeBlockNumber = 0;
807         bet.gambler = address(0);
808     }
809 
810     // Helper routine to process the payment.
811     function sendFunds(address beneficiary, uint amount, uint successLogAmount) private {
812         if (beneficiary.send(amount)) {
813             emit Payment(beneficiary, successLogAmount);
814         } else {
815             emit FailedPayment(beneficiary, amount);
816         }
817     }
818 
819      function sendFundsToManager(uint amount) external onlyOwner {
820         if (manager.send(amount)) {
821             emit ToManagerPayment(manager, amount);
822         } else {
823             emit ToManagerFailedPayment(manager, amount);
824         }
825     }
826 
827     function sendTokenFundsToManager( uint amount) external onlyOwner {
828         ERC20(ERC20ContractAddres).transfer(manager, amount);
829         emit TokenPayment(manager, amount);
830     }
831 
832     function sendFundsToOwner(address beneficiary, uint amount) external onlyOwner {
833         if (beneficiary.send(amount)) {
834             emit ToOwnerPayment(beneficiary, amount);
835         } else {
836             emit ToOwnerFailedPayment(beneficiary, amount);
837         }
838     }
839 
840     //Update
841     function updateMIN_BET(uint _uintNumber)public onlyManager {
842          MIN_BET = _uintNumber;
843     }
844 
845     function updateMAX_BET(uint _uintNumber)public onlyManager {
846          MAX_BET = _uintNumber;
847     }
848 
849     function updateMAX_AMOUNT(uint _uintNumber)public onlyManager {
850          MAX_AMOUNT = _uintNumber;
851     }
852 
853     function updateWithdrawalModeByIndex(uint8 _index, uint32 _value) public onlyManager{
854        withdrawalMode[_index]  = _value;
855     }
856 
857     function updateWithdrawalMode( uint32[] _withdrawalMode) public onlyManager{
858        withdrawalMode  = _withdrawalMode;
859     }
860 
861     function updateBitComparisonMask(bytes32 _newBitComparisonMask ) public onlyOwner{
862        bitComparisonMask = _newBitComparisonMask;
863     }
864 
865     function updatePlatformFeePercentage(uint8 _platformFeePercentage ) public onlyOwner{
866        platformFeePercentage = _platformFeePercentage;
867     }
868 
869     function updateJackpotFeePercentage(uint8 _jackpotFeePercentage ) public onlyOwner{
870        jackpotFeePercentage = _jackpotFeePercentage;
871     }
872 
873     function updateERC20rewardMultiple(uint8 _ERC20rewardMultiple ) public onlyManager{
874        ERC20rewardMultiple = _ERC20rewardMultiple;
875     }
876 }