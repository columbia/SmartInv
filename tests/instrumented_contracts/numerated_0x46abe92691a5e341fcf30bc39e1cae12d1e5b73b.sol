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
157     uint public tokenJackpotSize;
158 
159     uint public MIN_BET;
160     uint public MAX_BET;
161     uint public MAX_AMOUNT;
162 
163     //Adjustable max bet profit.
164     uint public maxProfit;
165     uint public maxTokenProfit;
166 
167     //Fee percentage
168     uint8 public platformFeePercentage = 15;
169     uint8 public jackpotFeePercentage = 5;
170     uint8 public ERC20rewardMultiple = 5;
171 
172     //Bets can be refunded via invoking refundBet.
173     uint constant BetExpirationBlocks = 250;
174 
175 
176 
177     //Funds that are locked in potentially winning bets.
178     uint public lockedInBets;
179     uint public lockedTokenInBets;
180 
181     bytes32 bitComparisonMask = 0xF;
182 
183     //Standard contract ownership transfer.
184     address public owner;
185     address private nextOwner;
186     address public manager;
187     address private nextManager;
188 
189     //The address corresponding to a private key used to sign placeBet commits.
190     address public secretSigner;
191     address public ERC20ContractAddres;
192     address constant DUMMY_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
193 
194     //Single bet.
195     struct Bet {
196         //Amount in wei.
197         uint amount;
198         //place tx Block number.
199         uint40 placeBlockNumber;
200         // Address of a gambler.
201         address gambler;
202     }
203 
204     //Mapping from commits
205     mapping (uint => Bet) public bets;
206 
207     //Withdrawal mode data.
208     uint32[] public withdrawalMode;
209 
210     // Events that are issued to make statistic recovery easier.
211     event PlaceBetLog(address indexed player, uint amount,uint8 rotateTime);
212 
213     //Admin Payment
214     event ToManagerPayment(address indexed beneficiary, uint amount);
215     event ToManagerFailedPayment(address indexed beneficiary, uint amount);
216     event ToOwnerPayment(address indexed beneficiary, uint amount);
217     event ToOwnerFailedPayment(address indexed beneficiary, uint amount);
218 
219     //Bet Payment
220     event Payment(address indexed beneficiary, uint amount);
221     event FailedPayment(address indexed beneficiary, uint amount);
222     event TokenPayment(address indexed beneficiary, uint amount);
223 
224     //JACKPOT
225     event JackpotBouns(address indexed beneficiary, uint amount);
226     event TokenJackpotBouns(address indexed beneficiary, uint amount);
227 
228     //Play0x_LottoBall_Event
229     event BetRelatedData(
230         address indexed player,
231         uint playerBetAmount,
232         uint playerGetAmount,
233         bytes32 entropy,
234         bytes32 entropy2,
235         uint8 Uplimit,
236         uint8 rotateTime
237     );
238 
239     // Constructor. Deliberately does not take any parameters.
240     constructor () public {
241         owner = msg.sender;
242         manager = DUMMY_ADDRESS;
243         secretSigner = DUMMY_ADDRESS;
244         ERC20ContractAddres = DUMMY_ADDRESS;
245     }
246 
247     // Standard modifier on methods invokable only by contract owner.
248     modifier onlyOwner {
249         require (msg.sender == owner);
250         _;
251     }
252 
253     modifier onlyManager {
254         require (msg.sender == manager);
255         _;
256     }
257 
258     modifier onlyOwnerManager {
259         require (msg.sender == owner || msg.sender == manager);
260         _;
261     }
262 
263     modifier onlySigner {
264         require (msg.sender == secretSigner);
265         _;
266     }
267 
268     //Init Parameter.
269     function initialParameter(address _manager,address _secretSigner,address _erc20tokenAddress ,uint _MIN_BET,uint _MAX_BET,uint _maxProfit,uint _maxTokenProfit, uint _MAX_AMOUNT, uint8 _platformFeePercentage,uint8 _jackpotFeePercentage,uint8 _ERC20rewardMultiple,uint32[] _withdrawalMode)external onlyOwner{
270         manager = _manager;
271         secretSigner = _secretSigner;
272         ERC20ContractAddres = _erc20tokenAddress;
273 
274         MIN_BET = _MIN_BET;
275         MAX_BET = _MAX_BET;
276         maxProfit = _maxProfit;
277         maxTokenProfit = _maxTokenProfit;
278         MAX_AMOUNT = _MAX_AMOUNT;
279         platformFeePercentage = _platformFeePercentage;
280         jackpotFeePercentage = _jackpotFeePercentage;
281         ERC20rewardMultiple = _ERC20rewardMultiple;
282         withdrawalMode = _withdrawalMode;
283     }
284 
285     // Standard contract ownership transfer implementation,
286     function approveNextOwner(address _nextOwner) external onlyOwner {
287         require (_nextOwner != owner);
288         nextOwner = _nextOwner;
289     }
290 
291     function acceptNextOwner() external {
292         require (msg.sender == nextOwner);
293         owner = nextOwner;
294     }
295 
296     // Standard contract ownership transfer implementation,
297     function approveNextManager(address _nextManager) external onlyManager {
298         require (_nextManager != manager);
299         nextManager = _nextManager;
300     }
301 
302     function acceptNextManager() external {
303         require (msg.sender == nextManager);
304         manager = nextManager;
305     }
306 
307     // Fallback function deliberately left empty.
308     function () public payable {
309     }
310 
311     //Set signer.
312     function setSecretSigner(address newSecretSigner) external onlyOwner {
313         secretSigner = newSecretSigner;
314     }
315 
316     //Set tokenAddress.
317     function setTokenAddress(address _tokenAddress) external onlyManager {
318         ERC20ContractAddres = _tokenAddress;
319     }
320 
321 
322     // Change max bet reward. Setting this to zero effectively disables betting.
323     function setMaxProfit(uint _maxProfit) public onlyOwner {
324         require (_maxProfit < MAX_AMOUNT);
325         maxProfit = _maxProfit;
326     }
327 
328     // Funds withdrawal.
329     function withdrawFunds(address beneficiary, uint withdrawAmount) external onlyOwner {
330         require (withdrawAmount <= address(this).balance);
331 
332         uint safetyAmount = jackpotSize.add(lockedInBets).add(withdrawAmount);
333         safetyAmount = safetyAmount.add(withdrawAmount);
334 
335         require (safetyAmount <= address(this).balance);
336         sendFunds(beneficiary, withdrawAmount, withdrawAmount);
337     }
338 
339     // Token withdrawal.
340     function withdrawToken(address beneficiary, uint withdrawAmount) external onlyOwner {
341         require (withdrawAmount <= ERC20(ERC20ContractAddres).balanceOf(address(this)));
342 
343         uint safetyAmount = tokenJackpotSize.add(lockedTokenInBets);
344         safetyAmount = safetyAmount.add(withdrawAmount);
345         require (safetyAmount <= ERC20(ERC20ContractAddres).balanceOf(address(this)));
346 
347          ERC20(ERC20ContractAddres).transfer(beneficiary, withdrawAmount);
348          emit TokenPayment(beneficiary, withdrawAmount);
349     }
350 
351     //Recovery of funds
352     function withdrawAllFunds(address beneficiary) external onlyOwner {
353         if (beneficiary.send(address(this).balance)) {
354             lockedInBets = 0;
355             emit Payment(beneficiary, address(this).balance);
356         } else {
357             emit FailedPayment(beneficiary, address(this).balance);
358         }
359     }
360 
361     //Recovery of Token funds
362     function withdrawAlltokenFunds(address beneficiary) external onlyOwner {
363         ERC20(ERC20ContractAddres).transfer(beneficiary, ERC20(ERC20ContractAddres).balanceOf(address(this)));
364         lockedTokenInBets = 0;
365         emit TokenPayment(beneficiary, ERC20(ERC20ContractAddres).balanceOf(address(this)));
366     }
367 
368     // Contract may be destroyed only when there are no ongoing bets,
369     // either settled or refunded. All funds are transferred to contract owner.
370     function kill() external onlyOwner {
371         require (lockedInBets == 0);
372         require (lockedTokenInBets == 0);
373         selfdestruct(owner);
374     }
375 
376     function getContractInformation()public view returns(
377         uint _jackpotSize,
378         uint _tokenJackpotSize,
379         uint _MIN_BET,
380         uint _MAX_BET,
381         uint _MAX_AMOUNT,
382         uint8 _platformFeePercentage,
383         uint8 _jackpotFeePercentage,
384         uint _maxProfit,
385         uint _maxTokenProfit,
386         uint _lockedInBets,
387         uint _lockedTokenInBets,
388         uint32[] _withdrawalMode){
389 
390         _jackpotSize = jackpotSize;
391         _tokenJackpotSize = tokenJackpotSize;
392         _MIN_BET = MIN_BET;
393         _MAX_BET = MAX_BET;
394         _MAX_AMOUNT = MAX_AMOUNT;
395         _platformFeePercentage = platformFeePercentage;
396         _jackpotFeePercentage = jackpotFeePercentage;
397         _maxProfit = maxProfit;
398         _maxTokenProfit = maxTokenProfit;
399         _lockedInBets = lockedInBets;
400         _lockedTokenInBets = lockedTokenInBets;
401         _withdrawalMode = withdrawalMode;
402     }
403 
404     function getContractAddress()public view returns(
405         address _owner,
406         address _manager,
407         address _secretSigner,
408         address _ERC20ContractAddres ){
409 
410         _owner = owner;
411         _manager= manager;
412         _secretSigner = secretSigner;
413         _ERC20ContractAddres = ERC20ContractAddres;
414     }
415 
416     // Settlement transaction
417     enum PlaceParam {
418         RotateTime,
419         possibleWinAmount
420     }
421 
422     //Bet by ether: Commits are signed with a block limit to ensure that they are used at most once.
423     function placeBet(uint[] placParameter, bytes32 _signatureHash , uint _commitLastBlock, uint _commit, bytes32 r, bytes32 s, uint8 v) external payable {
424         require (uint8(placParameter[uint8(PlaceParam.RotateTime)]) != 0);
425         require (block.number <= _commitLastBlock );
426         require (secretSigner == ecrecover(_signatureHash, v, r, s));
427 
428         // Check that the bet is in 'clean' state.
429         Bet storage bet = bets[_commit];
430         require (bet.gambler == address(0));
431 
432         //Ether balanceet
433         lockedInBets = lockedInBets.add(uint(placParameter[uint8(PlaceParam.possibleWinAmount)]));
434         require (uint(placParameter[uint8(PlaceParam.possibleWinAmount)]) <= msg.value.add(maxProfit));
435         require (lockedInBets <= address(this).balance);
436 
437         // Store bet parameters on blockchain.
438         bet.amount = msg.value;
439         bet.placeBlockNumber = uint40(block.number);
440         bet.gambler = msg.sender;
441 
442         emit PlaceBetLog(msg.sender, msg.value, uint8(placParameter[uint8(PlaceParam.RotateTime)]));
443     }
444 
445     function placeTokenBet(uint[] placParameter,bytes32 _signatureHash , uint _commitLastBlock, uint _commit, bytes32 r, bytes32 s, uint8 v,uint _amount,address _playerAddress) external {
446         require (placParameter[uint8(PlaceParam.RotateTime)] != 0);
447         require (block.number <= _commitLastBlock );
448         require (secretSigner == ecrecover(_signatureHash, v, r, s));
449 
450         // Check that the bet is in 'clean' state.
451         Bet storage bet = bets[_commit];
452         require (bet.gambler == address(0));
453 
454         //Token bet
455         lockedTokenInBets = lockedTokenInBets.add(uint(placParameter[uint8(PlaceParam.possibleWinAmount)]));
456         require (uint(placParameter[uint8(PlaceParam.possibleWinAmount)]) <= _amount.add(maxTokenProfit));
457         require (lockedTokenInBets <= ERC20(ERC20ContractAddres).balanceOf(address(this)));
458 
459         // Store bet parameters on blockchain.
460         bet.amount = _amount;
461         bet.placeBlockNumber = uint40(block.number);
462         bet.gambler = _playerAddress;
463 
464         emit PlaceBetLog(_playerAddress, _amount, uint8(placParameter[uint8(PlaceParam.RotateTime)]));
465     }
466 
467 
468     //Estimated maximum award amount
469      function getBonusPercentageByMachineMode(uint8 machineMode)public view returns( uint upperLimit,uint maxWithdrawalPercentage ){
470          uint limitIndex = machineMode.mul(2);
471          upperLimit = withdrawalMode[limitIndex];
472          maxWithdrawalPercentage = withdrawalMode[(limitIndex.add(1))];
473     }
474 
475     // Settlement transaction
476      enum SettleParam {
477         Uplimit,
478         BonusPercentage,
479         RotateTime,
480         CurrencyType,
481         MachineMode,
482         PerWinAmount,
483         PerBetAmount,
484         PossibleWinAmount,
485         LuckySeed,
486         jackpotFee
487      }
488 
489     function settleBet(uint[] combinationParameter, uint reveal) external {
490 
491         // "commit" for bet settlement can only be obtained by hashing a "reveal".
492         uint commit = uint(keccak256(abi.encodePacked(reveal)));
493 
494         // Fetch bet parameters into local variables (to save gas).
495         Bet storage bet = bets[commit];
496 
497         // Check that bet is in 'active' state and check that bet has not expired yet.
498         require (bet.amount != 0);
499         require (block.number <= bet.placeBlockNumber.add(BetExpirationBlocks));
500 
501         //The RNG - combine "reveal" and blockhash of LuckySeed using Keccak256.
502         bytes32 _entropy = keccak256(
503             abi.encodePacked(
504                 uint(
505                     keccak256(
506                         abi.encodePacked(
507                             uint(
508                                 keccak256(
509                                     abi.encodePacked(
510                                         reveal,
511                                         blockhash(combinationParameter[uint8(SettleParam.LuckySeed)])
512                                     )
513                                 )
514                             ),
515                             blockhash(block.number)
516                         )
517                     )
518                 ),
519                 blockhash(block.timestamp)
520             )
521         );
522 
523          uint totalAmount = 0;
524          uint totalTokenAmount = 0;
525          uint totalJackpotWin = 0;
526          (totalAmount,totalTokenAmount,totalJackpotWin) = runRotateTime(combinationParameter,_entropy,keccak256(abi.encodePacked(uint(_entropy), blockhash(combinationParameter[uint8(SettleParam.LuckySeed)]))));
527 
528         // Add ether JackpotBouns
529         if (totalJackpotWin > 0 && combinationParameter[uint8(SettleParam.CurrencyType)] == 0) {
530 
531             emit JackpotBouns(bet.gambler,totalJackpotWin);
532             totalAmount = totalAmount.add(totalJackpotWin);
533             jackpotSize = uint128(jackpotSize.sub(totalJackpotWin));
534 
535         }else if (totalJackpotWin > 0 && combinationParameter[uint8(SettleParam.CurrencyType)] == 1) {
536 
537             // Add token TokenJackpotBouns
538             emit TokenJackpotBouns(bet.gambler,totalJackpotWin);
539             totalAmount = totalAmount.add(totalJackpotWin);
540             tokenJackpotSize = uint128(tokenJackpotSize.sub(totalJackpotWin));
541         }
542 
543         emit BetRelatedData(bet.gambler,bet.amount,totalAmount,_entropy,keccak256(abi.encodePacked(uint(_entropy), blockhash(combinationParameter[uint8(SettleParam.LuckySeed)]))),uint8(combinationParameter[uint8(SettleParam.Uplimit)]),uint8(combinationParameter[uint8(SettleParam.RotateTime)]));
544 
545         if (combinationParameter[uint8(SettleParam.CurrencyType)] == 0) {
546              //Ether game
547             if (totalAmount != 0){
548                 sendFunds(bet.gambler, totalAmount , totalAmount);
549             }
550 
551             //Send ERC20 Token
552             if (totalTokenAmount != 0){
553 
554                 if(ERC20(ERC20ContractAddres).balanceOf(address(this)) > 0){
555                     ERC20(ERC20ContractAddres).transfer(bet.gambler, totalTokenAmount);
556                     emit TokenPayment(bet.gambler, totalTokenAmount);
557                 }
558             }
559         }else if(combinationParameter[uint8(SettleParam.CurrencyType)] == 1){
560               //ERC20 game
561 
562             //Send ERC20 Token
563             if (totalAmount != 0){
564                 if(ERC20(ERC20ContractAddres).balanceOf(address(this)) > 0){
565                     ERC20(ERC20ContractAddres).transfer(bet.gambler, totalAmount);
566                     emit TokenPayment(bet.gambler, totalAmount);
567                 }
568             }
569         }
570 
571                 // Unlock the bet amount, regardless of the outcome.
572         if (combinationParameter[uint8(SettleParam.CurrencyType)] == 0) {
573                 lockedInBets = lockedInBets.sub(combinationParameter[uint8(SettleParam.PossibleWinAmount)]);
574         } else if (combinationParameter[uint8(SettleParam.CurrencyType)] == 1){
575                 lockedTokenInBets = lockedTokenInBets.sub(combinationParameter[uint8(SettleParam.PossibleWinAmount)]);
576         }
577 
578         //Move bet into 'processed' state already.
579         bet.amount = 0;
580 
581         //Save jackpotSize
582         if (uint16(combinationParameter[uint8(SettleParam.CurrencyType)]) == 0) {
583             jackpotSize = jackpotSize.add(uint(combinationParameter[uint8(SettleParam.jackpotFee)]));
584         }else if (uint16(combinationParameter[uint8(SettleParam.CurrencyType)]) == 1) {
585             tokenJackpotSize = tokenJackpotSize.add(uint(combinationParameter[uint8(SettleParam.jackpotFee)]));
586         }
587     }
588 
589 
590     function runRotateTime ( uint[] combinationParameter, bytes32 _entropy ,bytes32 _entropy2)private view  returns(uint totalAmount,uint totalTokenAmount,uint totalJackpotWin) {
591 
592         bytes32 resultMask = 0xF000000000000000000000000000000000000000000000000000000000000000;
593         bytes32 tmp_entropy;
594         bytes32 tmp_Mask = resultMask;
595 
596         bool isGetJackpot = false;
597 
598         for (uint8 i = 0; i < combinationParameter[uint8(SettleParam.RotateTime)]; i++) {
599             if (i < 64){
600                 tmp_entropy = _entropy & tmp_Mask;
601                 tmp_entropy = tmp_entropy >> (4*(64 - (i.add(1))));
602                 tmp_Mask =  tmp_Mask >> 4;
603             }else{
604                 if ( i == 64){
605                     tmp_Mask = resultMask;
606                 }
607                 tmp_entropy = _entropy2 & tmp_Mask;
608                 tmp_entropy = tmp_entropy >> (4*( 64 - (i%63)));
609                 tmp_Mask =  tmp_Mask >> 4;
610             }
611 
612             if ( uint(tmp_entropy) < uint(combinationParameter[uint8(SettleParam.Uplimit)]) ){
613                 //bet win
614                 totalAmount = totalAmount.add(combinationParameter[uint8(SettleParam.PerWinAmount)]);
615 
616                 //Platform fee determination:Ether Game Winning players must pay platform fees
617                 uint platformFees = combinationParameter[uint8(SettleParam.PerBetAmount)].mul(platformFeePercentage);
618                 platformFees = platformFees.div(1000);
619                 totalAmount = totalAmount.sub(platformFees);
620             }else{
621                 //bet lose
622                 if (uint(combinationParameter[uint8(SettleParam.CurrencyType)]) == 0){
623 
624                     if(ERC20(ERC20ContractAddres).balanceOf(address(this)) > 0){
625                         //get token reward
626                         uint rewardAmount = uint(combinationParameter[uint8(SettleParam.PerBetAmount)]).mul(ERC20rewardMultiple);
627                         totalTokenAmount = totalTokenAmount.add(rewardAmount);
628                     }
629                 }
630             }
631 
632             //Get jackpotWin Result
633             if (isGetJackpot == false){
634                 isGetJackpot = getJackpotWinBonus(i,_entropy,_entropy2);
635             }
636         }
637 
638         if (isGetJackpot == true && combinationParameter[uint8(SettleParam.CurrencyType)] == 0) {
639             //gambler get ether bonus.
640             totalJackpotWin = jackpotSize;
641         }else if (isGetJackpot == true && combinationParameter[uint8(SettleParam.CurrencyType)] == 1) {
642             //gambler get token bonus.
643             totalJackpotWin = tokenJackpotSize;
644         }
645     }
646 
647     function getJackpotWinBonus (uint8 i,bytes32 entropy,bytes32 entropy2) private pure returns (bool isGetJackpot) {
648         bytes32 one;
649         bytes32 two;
650         bytes32 three;
651         bytes32 four;
652 
653         bytes32 resultMask = 0xF000000000000000000000000000000000000000000000000000000000000000;
654         bytes32 jackpo_Mask = resultMask;
655 
656         if (i < 61){
657             one = (entropy & jackpo_Mask) >> 4*(64 - (i + 1));
658                 jackpo_Mask =  jackpo_Mask >> 4;
659             two = (entropy & jackpo_Mask)  >> (4*(64 - (i + 2)));
660                 jackpo_Mask =  jackpo_Mask >> 4;
661             three = (entropy & jackpo_Mask) >> (4*(64 - (i + 3)));
662                 jackpo_Mask =  jackpo_Mask >> 4;
663             four = (entropy & jackpo_Mask) >> (4*(64 - (i + 4)));
664                 jackpo_Mask =  jackpo_Mask << 8;
665         }
666         else if(i >= 61){
667             if(i == 61){
668                 one = (entropy & jackpo_Mask) >> 4*(64 - (i + 1));
669                     jackpo_Mask =  jackpo_Mask >> 4;
670                 two = (entropy & jackpo_Mask)  >> (4*(64 - (i + 2)));
671                     jackpo_Mask =  jackpo_Mask >> 4;
672                 three = (entropy & jackpo_Mask) >> (4*(64 - (i + 3)));
673                     jackpo_Mask =  jackpo_Mask << 4;
674                 four = (entropy2 & 0xF000000000000000000000000000000000000000000000000000000000000000) >> 4*63;
675             }
676             else if(i == 62){
677                 one = (entropy & jackpo_Mask) >> 4*(64 - (i + 1));
678                     jackpo_Mask =  jackpo_Mask >> 4;
679                 two = (entropy & jackpo_Mask)  >> (4*(64 - (i + 2)));
680                 three = (entropy2 & 0xF000000000000000000000000000000000000000000000000000000000000000) >> 4*63;
681                 four =  (entropy2 & 0x0F00000000000000000000000000000000000000000000000000000000000000) >> 4*62;
682             }
683             else if(i == 63){
684                 one = (entropy & jackpo_Mask) >> 4*(64 - (i + 1));
685                 two = (entropy2 & 0xF000000000000000000000000000000000000000000000000000000000000000)  >> 4*63;
686                     jackpo_Mask =  jackpo_Mask >> 4;
687                 three = (entropy2 & 0x0F00000000000000000000000000000000000000000000000000000000000000) >> 4*62;
688                     jackpo_Mask =  jackpo_Mask << 4;
689                 four = (entropy2 & 0x00F0000000000000000000000000000000000000000000000000000000000000) >> 4*61;
690 
691                     jackpo_Mask = 0xF000000000000000000000000000000000000000000000000000000000000000;
692             }
693             else {
694                 one = (entropy2 & jackpo_Mask) >>  (4*( 64 - (i%64 + 1)));
695                     jackpo_Mask =  jackpo_Mask >> 4;
696                 two = (entropy2 & jackpo_Mask)  >> (4*( 64 - (i%64 + 2)))   ;
697                     jackpo_Mask =  jackpo_Mask >> 4;
698                 three = (entropy2 & jackpo_Mask) >> (4*( 64 - (i%64 + 3))) ;
699                     jackpo_Mask =  jackpo_Mask >> 4;
700                 four = (entropy2 & jackpo_Mask) >>(4*( 64 - (i%64 + 4)));
701                     jackpo_Mask =  jackpo_Mask << 8;
702             }
703         }
704 
705         if ((one ^ 0xF) == 0 && (two ^ 0xF) == 0 && (three ^ 0xF) == 0 && (four ^ 0xF) == 0){
706             isGetJackpot = true;
707        }
708     }
709 
710     //Get deductedBalance
711     function getPossibleWinAmount(uint bonusPercentage,uint senderValue)public view returns (uint platformFee,uint jackpotFee,uint possibleWinAmount) {
712 
713         //Platform Fee
714         uint prePlatformFee = (senderValue).mul(platformFeePercentage);
715         platformFee = (prePlatformFee).div(1000);
716 
717         //Get jackpotFee
718         uint preJackpotFee = (senderValue).mul(jackpotFeePercentage);
719         jackpotFee = (preJackpotFee).div(1000);
720 
721         //Win Amount
722         uint preUserGetAmount = senderValue.mul(bonusPercentage);
723         possibleWinAmount = preUserGetAmount.div(10000);
724     }
725 
726     // Refund transaction
727     function refundBet(uint commit,uint8 machineMode) external {
728         // Check that bet is in 'active' state.
729         Bet storage bet = bets[commit];
730         uint amount = bet.amount;
731 
732         require (amount != 0, "Bet should be in an 'active' state");
733 
734         // Check that bet has already expired.
735         require (block.number > bet.placeBlockNumber.add(BetExpirationBlocks));
736 
737         // Move bet into 'processed' state, release funds.
738         bet.amount = 0;
739 
740         //Maximum amount to be confirmed
741         uint platformFee;
742         uint jackpotFee;
743         uint possibleWinAmount;
744         uint upperLimit;
745         uint maxWithdrawalPercentage;
746         (upperLimit,maxWithdrawalPercentage) = getBonusPercentageByMachineMode(machineMode);
747         (platformFee, jackpotFee, possibleWinAmount) = getPossibleWinAmount(maxWithdrawalPercentage,amount);
748 
749         //Amount unlock
750         lockedInBets = lockedInBets.sub(possibleWinAmount);
751 
752         //Refund
753         sendFunds(bet.gambler, amount, amount);
754     }
755 
756     function refundTokenBet(uint commit,uint8 machineMode) external {
757         // Check that bet is in 'active' state.
758         Bet storage bet = bets[commit];
759         uint amount = bet.amount;
760 
761         require (amount != 0, "Bet should be in an 'active' state");
762 
763         // Check that bet has already expired.
764         require (block.number > bet.placeBlockNumber.add(BetExpirationBlocks));
765 
766         // Move bet into 'processed' state, release funds.
767         bet.amount = 0;
768 
769         //Maximum amount to be confirmed
770         uint platformFee;
771         uint jackpotFee;
772         uint possibleWinAmount;
773         uint upperLimit;
774         uint maxWithdrawalPercentage;
775         (upperLimit,maxWithdrawalPercentage) = getBonusPercentageByMachineMode(machineMode);
776         (platformFee, jackpotFee, possibleWinAmount) = getPossibleWinAmount(maxWithdrawalPercentage,amount);
777 
778         //Amount unlock
779         lockedTokenInBets = uint128(lockedTokenInBets.sub(possibleWinAmount));
780 
781         //Refund
782         ERC20(ERC20ContractAddres).transfer(bet.gambler, amount);
783         emit TokenPayment(bet.gambler, amount);
784     }
785 
786     // A helper routine to bulk clean the storage.
787     function clearStorage(uint[] cleanCommits) external {
788         uint length = cleanCommits.length;
789 
790         for (uint i = 0; i < length; i++) {
791             clearProcessedBet(cleanCommits[i]);
792         }
793     }
794 
795     // Helper routine to move 'processed' bets into 'clean' state.
796     function clearProcessedBet(uint commit) private {
797         Bet storage bet = bets[commit];
798 
799         // Do not overwrite active bets with zeros
800         if (bet.amount != 0 || block.number <= bet.placeBlockNumber + BetExpirationBlocks) {
801             return;
802         }
803 
804         // Zero out the remaining storage
805         bet.placeBlockNumber = 0;
806         bet.gambler = address(0);
807     }
808 
809     // Helper routine to process the payment.
810     function sendFunds(address beneficiary, uint amount, uint successLogAmount) private {
811         if (beneficiary.send(amount)) {
812             emit Payment(beneficiary, successLogAmount);
813         } else {
814             emit FailedPayment(beneficiary, amount);
815         }
816     }
817 
818      function sendFundsToManager(uint amount) external onlyOwner {
819         if (manager.send(amount)) {
820             emit ToManagerPayment(manager, amount);
821         } else {
822             emit ToManagerFailedPayment(manager, amount);
823         }
824     }
825 
826     function sendTokenFundsToManager( uint amount) external onlyOwner {
827         ERC20(ERC20ContractAddres).transfer(manager, amount);
828         emit TokenPayment(manager, amount);
829     }
830 
831     function sendFundsToOwner(address beneficiary, uint amount) external onlyOwner {
832         if (beneficiary.send(amount)) {
833             emit ToOwnerPayment(beneficiary, amount);
834         } else {
835             emit ToOwnerFailedPayment(beneficiary, amount);
836         }
837     }
838 
839     //Update
840     function updateMIN_BET(uint _uintNumber)public onlyManager {
841          MIN_BET = _uintNumber;
842     }
843 
844     function updateMAX_BET(uint _uintNumber)public onlyManager {
845          MAX_BET = _uintNumber;
846     }
847 
848     function updateMAX_AMOUNT(uint _uintNumber)public onlyManager {
849          MAX_AMOUNT = _uintNumber;
850     }
851 
852     function updateWithdrawalModeByIndex(uint8 _index, uint32 _value) public onlyManager{
853        withdrawalMode[_index]  = _value;
854     }
855 
856     function updateWithdrawalMode( uint32[] _withdrawalMode) public onlyManager{
857        withdrawalMode  = _withdrawalMode;
858     }
859 
860     function updateBitComparisonMask(bytes32 _newBitComparisonMask ) public onlyOwner{
861        bitComparisonMask = _newBitComparisonMask;
862     }
863 
864     function updatePlatformFeePercentage(uint8 _platformFeePercentage ) public onlyOwner{
865        platformFeePercentage = _platformFeePercentage;
866     }
867 
868     function updateJackpotFeePercentage(uint8 _jackpotFeePercentage ) public onlyOwner{
869        jackpotFeePercentage = _jackpotFeePercentage;
870     }
871 
872     function updateERC20rewardMultiple(uint8 _ERC20rewardMultiple ) public onlyManager{
873        ERC20rewardMultiple = _ERC20rewardMultiple;
874     }
875 }