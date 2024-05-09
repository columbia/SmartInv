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
149 contract Play0x_Gashapon_MITH {
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
208     uint32[] public withdrawalMode = [1,140770,2,75400,3,51600,4,39200,5,30700,6,25900,7,22300,8,19700,9,17200,10,15600,11,14200,12,13300,13,12000,14,11000,15,10400 ];
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
223     event FailedTokenPayment(address indexed beneficiary, uint amount);
224 
225     //JACKPOT
226     event JackpotBouns(address indexed beneficiary, uint amount);
227     event TokenJackpotBouns(address indexed beneficiary, uint amount);
228 
229     //Play0x_Gashapon_Event
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
270     function initialParameter(address _manager,address _secretSigner,address _erc20tokenAddress ,uint _MIN_BET,uint _MAX_BET,uint _maxProfit,uint _maxTokenProfit, uint _MAX_AMOUNT, uint8 _platformFeePercentage,uint8 _jackpotFeePercentage,uint8 _ERC20rewardMultiple)external onlyOwner{
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
467     //Estimated maximum award amount
468      function getBonusPercentageByMachineMode(uint8 machineMode)public view returns( uint upperLimit,uint maxWithdrawalPercentage ){
469          uint limitIndex = machineMode.mul(2);
470          upperLimit = withdrawalMode[limitIndex];
471          maxWithdrawalPercentage = withdrawalMode[(limitIndex.add(1))];
472     }
473 
474     // Settlement transaction
475      enum SettleParam {
476         Uplimit,
477         BonusPercentage,
478         RotateTime,
479         CurrencyType,
480         MachineMode,
481         PerWinAmount,
482         PerBetAmount,
483         PossibleWinAmount,
484         LuckySeed,
485         jackpotFee
486      }
487 
488     function settleBet(uint[] combinationParameter, uint reveal) external {
489 
490         // "commit" for bet settlement can only be obtained by hashing a "reveal".
491         uint commit = uint(keccak256(abi.encodePacked(reveal)));
492 
493         // Fetch bet parameters into local variables (to save gas).
494         Bet storage bet = bets[commit];
495 
496         // Check that bet is in 'active' state and check that bet has not expired yet.
497         require (bet.amount != 0);
498         require (block.number <= bet.placeBlockNumber.add(BetExpirationBlocks));
499 
500         //The RNG - combine "reveal" and blockhash of LuckySeed using Keccak256.
501         bytes32 _entropy = keccak256(
502             abi.encodePacked(
503                 uint(
504                     keccak256(
505                         abi.encodePacked(
506                             uint(
507                                 keccak256(
508                                     abi.encodePacked(
509                                         reveal,
510                                         blockhash(combinationParameter[uint8(SettleParam.LuckySeed)])
511                                     )
512                                 )
513                             ),
514                             blockhash(block.number)
515                         )
516                     )
517                 ),
518                 blockhash(block.timestamp)
519             )
520         );
521 
522          uint totalAmount = 0;
523          uint totalTokenAmount = 0;
524          uint totalJackpotWin = 0;
525          (totalAmount,totalTokenAmount,totalJackpotWin) = runRotateTime(combinationParameter,_entropy,keccak256(abi.encodePacked(uint(_entropy), blockhash(combinationParameter[uint8(SettleParam.LuckySeed)]))));
526 
527         // Add ether JackpotBouns
528         if (totalJackpotWin > 0 && combinationParameter[uint8(SettleParam.CurrencyType)] == 0) {
529               emit JackpotBouns(bet.gambler,totalJackpotWin);
530               totalAmount = totalAmount.add(totalJackpotWin);
531               jackpotSize = uint128(jackpotSize.sub(totalJackpotWin));
532         }else if (totalJackpotWin > 0 && combinationParameter[uint8(SettleParam.CurrencyType)] == 1) {
533               // Add token TokenJackpotBouns
534 
535               emit TokenJackpotBouns(bet.gambler,totalJackpotWin);
536               totalAmount = totalAmount.add(totalJackpotWin);
537                 tokenJackpotSize = uint128(tokenJackpotSize.sub(totalJackpotWin));
538         }
539 
540         emit BetRelatedData(bet.gambler,bet.amount,totalAmount,_entropy,keccak256(abi.encodePacked(uint(_entropy), blockhash(combinationParameter[uint8(SettleParam.LuckySeed)]))),uint8(combinationParameter[uint8(SettleParam.Uplimit)]),uint8(combinationParameter[uint8(SettleParam.RotateTime)]));
541 
542         if (combinationParameter[uint8(SettleParam.CurrencyType)] == 0) {
543               //Ether game
544             if (totalAmount != 0){
545                 sendFunds(bet.gambler, totalAmount , totalAmount);
546             }
547 
548             //Send ERC20 Token
549             if (totalTokenAmount != 0){
550 
551                 if(ERC20(ERC20ContractAddres).balanceOf(address(this)) > 0){
552                     ERC20(ERC20ContractAddres).transfer(bet.gambler, totalTokenAmount);
553                     emit TokenPayment(bet.gambler, totalTokenAmount);
554                 }
555             }
556         }else if(combinationParameter[uint8(SettleParam.CurrencyType)] == 1){
557               //ERC20 game
558 
559             //Send ERC20 Token
560             if (totalAmount != 0){
561                 if(ERC20(ERC20ContractAddres).balanceOf(address(this)) > 0){
562                     ERC20(ERC20ContractAddres).transfer(bet.gambler, totalAmount);
563                     emit TokenPayment(bet.gambler, totalAmount);
564                 }
565             }
566         }
567 
568                 // Unlock the bet amount, regardless of the outcome.
569         if (combinationParameter[uint8(SettleParam.CurrencyType)] == 0) {
570                 lockedInBets = lockedInBets.sub(combinationParameter[uint8(SettleParam.PossibleWinAmount)]);
571         } else if (combinationParameter[uint8(SettleParam.CurrencyType)] == 1){
572                 lockedTokenInBets = lockedTokenInBets.sub(combinationParameter[uint8(SettleParam.PossibleWinAmount)]);
573         }
574 
575         //Move bet into 'processed' state already.
576         bet.amount = 0;
577 
578         //Save jackpotSize
579          if (uint16(combinationParameter[uint8(SettleParam.CurrencyType)]) == 0) {
580             jackpotSize = jackpotSize.add(uint(combinationParameter[uint8(SettleParam.jackpotFee)]));
581         }else if (uint16(combinationParameter[uint8(SettleParam.CurrencyType)]) == 1) {
582             tokenJackpotSize = tokenJackpotSize.add(uint(combinationParameter[uint8(SettleParam.jackpotFee)]));
583         }
584     }
585 
586 
587     function runRotateTime ( uint[] combinationParameter, bytes32 _entropy ,bytes32 _entropy2)private view  returns(uint totalAmount,uint totalTokenAmount,uint totalJackpotWin) {
588 
589         bytes32 resultMask = 0xF000000000000000000000000000000000000000000000000000000000000000;
590         bytes32 tmp_entropy;
591         bytes32 tmp_Mask = resultMask;
592 
593         bool isGetJackpot = false;
594 
595         for (uint8 i = 0; i < combinationParameter[uint8(SettleParam.RotateTime)]; i++) {
596             if (i < 64){
597                 tmp_entropy = _entropy & tmp_Mask;
598                 tmp_entropy = tmp_entropy >> (4*(64 - (i.add(1))));
599                 tmp_Mask =  tmp_Mask >> 4;
600             }else{
601                 if ( i == 64){
602                     tmp_Mask = resultMask;
603                 }
604                 tmp_entropy = _entropy2 & tmp_Mask;
605                 tmp_entropy = tmp_entropy >> (4*( 64 - (i%63)));
606                 tmp_Mask =  tmp_Mask >> 4;
607             }
608 
609             if ( uint(tmp_entropy) < uint(combinationParameter[uint8(SettleParam.Uplimit)]) ){
610                 //bet win
611                 totalAmount = totalAmount.add(combinationParameter[uint8(SettleParam.PerWinAmount)]);
612 
613                 //Platform fee determination:Winning players must pay platform fees
614                 uint platformFees = combinationParameter[uint8(SettleParam.PerBetAmount)].mul(platformFeePercentage);
615                 platformFees = platformFees.div(1000);
616                 totalAmount = totalAmount.sub(platformFees);
617             }else{
618                 //bet lose
619                 if (uint(combinationParameter[uint8(SettleParam.CurrencyType)]) == 0){
620 
621                     if(ERC20(ERC20ContractAddres).balanceOf(address(this)) > 0){
622                         //get token reward
623                         uint rewardAmount = uint(combinationParameter[uint8(SettleParam.PerBetAmount)]).mul(ERC20rewardMultiple);
624                         totalTokenAmount = totalTokenAmount.add(rewardAmount);
625                     }
626                 }
627             }
628 
629             //Get jackpotWin Result
630             if (isGetJackpot == false){
631                 isGetJackpot = getJackpotWinBonus(i,_entropy,_entropy2);
632             }
633         }
634 
635         if (isGetJackpot == true && combinationParameter[uint8(SettleParam.CurrencyType)] == 0) {
636             //gambler get ether bonus.
637             totalJackpotWin = jackpotSize;
638         }else if (isGetJackpot == true && combinationParameter[uint8(SettleParam.CurrencyType)] == 1) {
639             //gambler get token bonus.
640             totalJackpotWin = tokenJackpotSize;
641         }
642     }
643 
644     function getJackpotWinBonus (uint8 i,bytes32 entropy,bytes32 entropy2) private pure returns (bool isGetJackpot) {
645         bytes32 one;
646         bytes32 two;
647         bytes32 three;
648         bytes32 four;
649 
650         bytes32 resultMask = 0xF000000000000000000000000000000000000000000000000000000000000000;
651         bytes32 jackpo_Mask = resultMask;
652 
653         if (i < 61){
654             one = (entropy & jackpo_Mask) >> 4*(64 - (i + 1));
655                 jackpo_Mask =  jackpo_Mask >> 4;
656             two = (entropy & jackpo_Mask)  >> (4*(64 - (i + 2)));
657                 jackpo_Mask =  jackpo_Mask >> 4;
658             three = (entropy & jackpo_Mask) >> (4*(64 - (i + 3)));
659                 jackpo_Mask =  jackpo_Mask >> 4;
660             four = (entropy & jackpo_Mask) >> (4*(64 - (i + 4)));
661                 jackpo_Mask =  jackpo_Mask << 8;
662         }
663         else if(i >= 61){
664             if(i == 61){
665                 one = (entropy & jackpo_Mask) >> 4*(64 - (i + 1));
666                     jackpo_Mask =  jackpo_Mask >> 4;
667                 two = (entropy & jackpo_Mask)  >> (4*(64 - (i + 2)));
668                     jackpo_Mask =  jackpo_Mask >> 4;
669                 three = (entropy & jackpo_Mask) >> (4*(64 - (i + 3)));
670                     jackpo_Mask =  jackpo_Mask << 4;
671                 four = (entropy2 & 0xF000000000000000000000000000000000000000000000000000000000000000) >> 4*63;
672             }
673             else if(i == 62){
674                 one = (entropy & jackpo_Mask) >> 4*(64 - (i + 1));
675                     jackpo_Mask =  jackpo_Mask >> 4;
676                 two = (entropy & jackpo_Mask)  >> (4*(64 - (i + 2)));
677                 three = (entropy2 & 0xF000000000000000000000000000000000000000000000000000000000000000) >> 4*63;
678                 four =  (entropy2 & 0x0F00000000000000000000000000000000000000000000000000000000000000) >> 4*62;
679             }
680             else if(i == 63){
681                 one = (entropy & jackpo_Mask) >> 4*(64 - (i + 1));
682                 two = (entropy2 & 0xF000000000000000000000000000000000000000000000000000000000000000)  >> 4*63;
683                     jackpo_Mask =  jackpo_Mask >> 4;
684                 three = (entropy2 & 0x0F00000000000000000000000000000000000000000000000000000000000000) >> 4*62;
685                     jackpo_Mask =  jackpo_Mask << 4;
686                 four = (entropy2 & 0x00F0000000000000000000000000000000000000000000000000000000000000) >> 4*61;
687 
688                     jackpo_Mask = 0xF000000000000000000000000000000000000000000000000000000000000000;
689             }
690             else {
691                 one = (entropy2 & jackpo_Mask) >>  (4*( 64 - (i%64 + 1)));
692                     jackpo_Mask =  jackpo_Mask >> 4;
693                 two = (entropy2 & jackpo_Mask)  >> (4*( 64 - (i%64 + 2)))   ;
694                     jackpo_Mask =  jackpo_Mask >> 4;
695                 three = (entropy2 & jackpo_Mask) >> (4*( 64 - (i%64 + 3))) ;
696                     jackpo_Mask =  jackpo_Mask >> 4;
697                 four = (entropy2 & jackpo_Mask) >>(4*( 64 - (i%64 + 4)));
698                     jackpo_Mask =  jackpo_Mask << 8;
699             }
700         }
701 
702         if ((one ^ 0xF) == 0 && (two ^ 0xF) == 0 && (three ^ 0xF) == 0 && (four ^ 0xF) == 0){
703             isGetJackpot = true;
704        }
705     }
706 
707     //Get deductedBalance
708     function getPossibleWinAmount(uint bonusPercentage,uint senderValue)public view returns (uint platformFee,uint jackpotFee,uint possibleWinAmount) {
709 
710         //Platform Fee
711         uint prePlatformFee = (senderValue).mul(platformFeePercentage);
712         platformFee = (prePlatformFee).div(1000);
713 
714         //Get jackpotFee
715         uint preJackpotFee = (senderValue).mul(jackpotFeePercentage);
716         jackpotFee = (preJackpotFee).div(1000);
717 
718         //Win Amount
719         uint preUserGetAmount = senderValue.mul(bonusPercentage);
720         possibleWinAmount = preUserGetAmount.div(10000);
721     }
722 
723     // Refund transaction
724     function refundBet(uint commit,uint8 machineMode) external {
725         // Check that bet is in 'active' state.
726         Bet storage bet = bets[commit];
727         uint amount = bet.amount;
728 
729         require (amount != 0, "Bet should be in an 'active' state");
730 
731         // Check that bet has already expired.
732         require (block.number > bet.placeBlockNumber.add(BetExpirationBlocks));
733 
734         // Move bet into 'processed' state, release funds.
735         bet.amount = 0;
736 
737         //Maximum amount to be confirmed
738         uint platformFee;
739         uint jackpotFee;
740         uint possibleWinAmount;
741         uint upperLimit;
742         uint maxWithdrawalPercentage;
743         (upperLimit,maxWithdrawalPercentage) = getBonusPercentageByMachineMode(machineMode);
744         (platformFee, jackpotFee, possibleWinAmount) = getPossibleWinAmount(maxWithdrawalPercentage,amount);
745 
746         //Amount unlock
747         lockedInBets = lockedInBets.sub(possibleWinAmount);
748 
749         //Refund
750         sendFunds(bet.gambler, amount, amount);
751     }
752 
753     function refundTokenBet(uint commit,uint8 machineMode) external {
754         // Check that bet is in 'active' state.
755         Bet storage bet = bets[commit];
756         uint amount = bet.amount;
757 
758         require (amount != 0, "Bet should be in an 'active' state");
759 
760         // Check that bet has already expired.
761         require (block.number > bet.placeBlockNumber.add(BetExpirationBlocks));
762 
763         // Move bet into 'processed' state, release funds.
764         bet.amount = 0;
765 
766         //Maximum amount to be confirmed
767         uint platformFee;
768         uint jackpotFee;
769         uint possibleWinAmount;
770         uint upperLimit;
771         uint maxWithdrawalPercentage;
772         (upperLimit,maxWithdrawalPercentage) = getBonusPercentageByMachineMode(machineMode);
773         (platformFee, jackpotFee, possibleWinAmount) = getPossibleWinAmount(maxWithdrawalPercentage,amount);
774 
775         //Amount unlock
776         lockedTokenInBets = uint128(lockedTokenInBets.sub(possibleWinAmount));
777 
778         //Refund
779         ERC20(ERC20ContractAddres).transfer(bet.gambler, amount);
780         emit TokenPayment(bet.gambler, amount);
781     }
782 
783     // A helper routine to bulk clean the storage.
784     function clearStorage(uint[] cleanCommits) external {
785         uint length = cleanCommits.length;
786 
787         for (uint i = 0; i < length; i++) {
788             clearProcessedBet(cleanCommits[i]);
789         }
790     }
791 
792     // Helper routine to move 'processed' bets into 'clean' state.
793     function clearProcessedBet(uint commit) private {
794         Bet storage bet = bets[commit];
795 
796         // Do not overwrite active bets with zeros
797         if (bet.amount != 0 || block.number <= bet.placeBlockNumber + BetExpirationBlocks) {
798             return;
799         }
800 
801         // Zero out the remaining storage
802         bet.placeBlockNumber = 0;
803         bet.gambler = address(0);
804     }
805 
806     // Helper routine to process the payment.
807     function sendFunds(address beneficiary, uint amount, uint successLogAmount) private {
808         if (beneficiary.send(amount)) {
809             emit Payment(beneficiary, successLogAmount);
810         } else {
811             emit FailedPayment(beneficiary, amount);
812         }
813     }
814 
815      function sendFundsToManager(uint amount) external onlyOwner {
816         if (manager.send(amount)) {
817             emit ToManagerPayment(manager, amount);
818         } else {
819             emit ToManagerFailedPayment(manager, amount);
820         }
821     }
822 
823     function sendTokenFundsToManager( uint amount) external onlyOwner {
824         ERC20(ERC20ContractAddres).transfer(manager, amount);
825         emit TokenPayment(manager, amount);
826     }
827 
828     function sendFundsToOwner(address beneficiary, uint amount) external onlyOwner {
829         if (beneficiary.send(amount)) {
830             emit ToOwnerPayment(beneficiary, amount);
831         } else {
832             emit ToOwnerFailedPayment(beneficiary, amount);
833         }
834     }
835 
836     //Update
837     function updateMIN_BET(uint _uintNumber)public onlyManager {
838          MIN_BET = _uintNumber;
839     }
840 
841     function updateMAX_BET(uint _uintNumber)public onlyManager {
842          MAX_BET = _uintNumber;
843     }
844 
845     function updateMAX_AMOUNT(uint _uintNumber)public onlyManager {
846          MAX_AMOUNT = _uintNumber;
847     }
848 
849     function updateWithdrawalModeByIndex(uint8 _index, uint32 _value) public onlyManager{
850        withdrawalMode[_index]  = _value;
851     }
852 
853     function updateWithdrawalMode( uint32[] _withdrawalMode) public onlyManager{
854        withdrawalMode  = _withdrawalMode;
855     }
856 
857     function updateBitComparisonMask(bytes32 _newBitComparisonMask ) public onlyOwner{
858        bitComparisonMask = _newBitComparisonMask;
859     }
860 
861     function updatePlatformFeePercentage(uint8 _platformFeePercentage ) public onlyOwner{
862        platformFeePercentage = _platformFeePercentage;
863     }
864 
865     function updateJackpotFeePercentage(uint8 _jackpotFeePercentage ) public onlyOwner{
866        jackpotFeePercentage = _jackpotFeePercentage;
867     }
868 
869     function updateERC20rewardMultiple(uint8 _ERC20rewardMultiple ) public onlyManager{
870        ERC20rewardMultiple = _ERC20rewardMultiple;
871     }
872 }