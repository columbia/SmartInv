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
176     //Funds that are locked in potentially winning bets.
177     uint public lockedInBets;
178     uint public lockedTokenInBets;
179 
180     bytes32 bitComparisonMask = 0xF;
181 
182     //Standard contract ownership transfer.
183     address public owner;
184     address private nextOwner;
185     address public manager;
186     address private nextManager;
187 
188     //The address corresponding to a private key used to sign placeBet commits.
189     address[] public secretSignerList;
190     address public ERC20ContractAddres;
191     address constant DUMMY_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
192 
193     //Single bet.
194     struct Bet {
195         //Amount in wei.
196         uint amount;
197         //place tx Block number.
198         uint40 placeBlockNumber;
199         // Address of a gambler.
200         address gambler;
201     }
202 
203     //Mapping from commits
204     mapping (uint => Bet) public bets;
205 
206     //Withdrawal mode data.
207     uint32[] public withdrawalMode;
208 
209 
210     //Admin Payment
211     event ToManagerPayment(address indexed beneficiary, uint amount);
212     event ToManagerFailedPayment(address indexed beneficiary, uint amount);
213     event ToOwnerPayment(address indexed beneficiary, uint amount);
214     event ToOwnerFailedPayment(address indexed beneficiary, uint amount);
215 
216     //Bet Payment
217     event Payment(address indexed beneficiary, uint amount);
218     event FailedPayment(address indexed beneficiary, uint amount);
219     event TokenPayment(address indexed beneficiary, uint amount);
220 
221     //JACKPOT
222     event JackpotBouns(address indexed beneficiary, uint amount);
223     event TokenJackpotBouns(address indexed beneficiary, uint amount);
224 
225     // Events that are issued to make statistic recovery easier.
226     event PlaceBetLog(address indexed player, uint amount,uint8 rotateTime);
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
243         ERC20ContractAddres = DUMMY_ADDRESS;
244     }
245 
246     // Standard modifier on methods invokable only by contract owner.
247     modifier onlyOwner {
248         require (msg.sender == owner);
249         _;
250     }
251 
252     modifier onlyManager {
253         require (msg.sender == manager);
254         _;
255     }
256 
257     //Init Parameter.
258     function initialParameter(address _manager,address[] _secretSignerList,address _erc20tokenAddress ,uint _MIN_BET,uint _MAX_BET,uint _maxProfit,uint _maxTokenProfit, uint _MAX_AMOUNT, uint8 _platformFeePercentage,uint8 _jackpotFeePercentage,uint8 _ERC20rewardMultiple,uint32[] _withdrawalMode)external onlyOwner{
259         manager = _manager;
260         secretSignerList = _secretSignerList;
261         ERC20ContractAddres = _erc20tokenAddress;
262 
263         MIN_BET = _MIN_BET;
264         MAX_BET = _MAX_BET;
265         maxProfit = _maxProfit;
266         maxTokenProfit = _maxTokenProfit;
267         MAX_AMOUNT = _MAX_AMOUNT;
268         platformFeePercentage = _platformFeePercentage;
269         jackpotFeePercentage = _jackpotFeePercentage;
270         ERC20rewardMultiple = _ERC20rewardMultiple;
271         withdrawalMode = _withdrawalMode;
272     }
273 
274     // Standard contract ownership transfer implementation,
275     function approveNextOwner(address _nextOwner) external onlyOwner {
276         require (_nextOwner != owner);
277         nextOwner = _nextOwner;
278     }
279 
280     function acceptNextOwner() external {
281         require (msg.sender == nextOwner);
282         owner = nextOwner;
283     }
284 
285     // Standard contract ownership transfer implementation,
286     function approveNextManager(address _nextManager) external onlyManager {
287         require (_nextManager != manager);
288         nextManager = _nextManager;
289     }
290 
291     function acceptNextManager() external {
292         require (msg.sender == nextManager);
293         manager = nextManager;
294     }
295 
296     // Fallback function deliberately left empty.
297     function () public payable {
298     }
299 
300     //Set signer.
301     function setSecretSignerList(address[] newSecretSignerList) external onlyOwner {
302         secretSignerList = newSecretSignerList;
303     }
304 
305     //Set signer by index
306     function setSecretSignerByIndex(address newSecretSigner,uint newSecretSignerIndex) external onlyOwner {
307         secretSignerList[newSecretSignerIndex] = newSecretSigner;
308     }
309 
310     //Set tokenAddress.
311     function setTokenAddress(address _tokenAddress) external onlyManager {
312         ERC20ContractAddres = _tokenAddress;
313     }
314 
315     // Change max bet reward. Setting this to zero effectively disables betting.
316     function setMaxProfit(uint _maxProfit) public onlyOwner {
317         require (_maxProfit < MAX_AMOUNT);
318         maxProfit = _maxProfit;
319     }
320 
321     // Funds withdrawal.
322     function withdrawFunds(address beneficiary, uint withdrawAmount) external onlyOwner {
323         require (withdrawAmount <= address(this).balance);
324 
325         uint safetyAmount = jackpotSize.add(lockedInBets).add(withdrawAmount);
326         safetyAmount = safetyAmount.add(withdrawAmount);
327 
328         require (safetyAmount <= address(this).balance);
329         sendFunds(beneficiary, withdrawAmount, withdrawAmount);
330     }
331 
332     // Token withdrawal.
333     function withdrawToken(address beneficiary, uint withdrawAmount) external onlyOwner {
334         require (withdrawAmount <= ERC20(ERC20ContractAddres).balanceOf(address(this)));
335 
336         uint safetyAmount = tokenJackpotSize.add(lockedTokenInBets);
337         safetyAmount = safetyAmount.add(withdrawAmount);
338         require (safetyAmount <= ERC20(ERC20ContractAddres).balanceOf(address(this)));
339 
340          ERC20(ERC20ContractAddres).transfer(beneficiary, withdrawAmount);
341          emit TokenPayment(beneficiary, withdrawAmount);
342     }
343 
344     //Recovery of funds
345     function withdrawAllFunds(address beneficiary) external onlyOwner {
346         if (beneficiary.send(address(this).balance)) {
347             lockedInBets = 0;
348             emit Payment(beneficiary, address(this).balance);
349         } else {
350             emit FailedPayment(beneficiary, address(this).balance);
351         }
352     }
353 
354     //Recovery of Token funds
355     function withdrawAlltokenFunds(address beneficiary) external onlyOwner {
356         ERC20(ERC20ContractAddres).transfer(beneficiary, ERC20(ERC20ContractAddres).balanceOf(address(this)));
357         lockedTokenInBets = 0;
358         emit TokenPayment(beneficiary, ERC20(ERC20ContractAddres).balanceOf(address(this)));
359     }
360 
361     // Contract may be destroyed only when there are no ongoing bets,
362     // either settled or refunded. All funds are transferred to contract owner.
363     function kill() external onlyOwner {
364         require (lockedInBets == 0);
365         require (lockedTokenInBets == 0);
366         selfdestruct(owner);
367     }
368 
369     function getContractInformation()public view returns(
370         uint _jackpotSize,
371         uint _tokenJackpotSize,
372         uint _MIN_BET,
373         uint _MAX_BET,
374         uint _MAX_AMOUNT,
375         uint8 _platformFeePercentage,
376         uint8 _jackpotFeePercentage,
377         uint _maxProfit,
378         uint _maxTokenProfit,
379         uint _lockedInBets,
380         uint _lockedTokenInBets,
381         uint32[] _withdrawalMode){
382 
383         _jackpotSize = jackpotSize;
384         _tokenJackpotSize = tokenJackpotSize;
385         _MIN_BET = MIN_BET;
386         _MAX_BET = MAX_BET;
387         _MAX_AMOUNT = MAX_AMOUNT;
388         _platformFeePercentage = platformFeePercentage;
389         _jackpotFeePercentage = jackpotFeePercentage;
390         _maxProfit = maxProfit;
391         _maxTokenProfit = maxTokenProfit;
392         _lockedInBets = lockedInBets;
393         _lockedTokenInBets = lockedTokenInBets;
394         _withdrawalMode = withdrawalMode;
395     }
396 
397     function getContractAddress()public view returns(
398         address _owner,
399         address _manager,
400         address[] _secretSignerList,
401         address _ERC20ContractAddres ){
402 
403         _owner = owner;
404         _manager= manager;
405         _secretSignerList = secretSignerList;
406         _ERC20ContractAddres = ERC20ContractAddres;
407     }
408 
409     // Settlement transaction
410     enum PlaceParam {
411         RotateTime,
412         possibleWinAmount,
413         secretSignerIndex
414     }
415 
416     //Bet by ether: Commits are signed with a block limit to ensure that they are used at most once.
417     function placeBet(uint[] placParameter, bytes32 _signatureHash , uint _commitLastBlock, uint _commit, bytes32 r, bytes32 s, uint8 v) external payable {
418         require (uint8(placParameter[uint8(PlaceParam.RotateTime)]) != 0);
419         require (block.number <= _commitLastBlock );
420         require (secretSignerList[placParameter[uint8(PlaceParam.secretSignerIndex)]] == ecrecover(_signatureHash, v, r, s));
421 
422         // Check that the bet is in 'clean' state.
423         Bet storage bet = bets[_commit];
424         require (bet.gambler == address(0));
425 
426         //Ether balanceet
427         lockedInBets = lockedInBets.add(uint(placParameter[uint8(PlaceParam.possibleWinAmount)]));
428         require (uint(placParameter[uint8(PlaceParam.possibleWinAmount)]) <= msg.value.add(maxProfit));
429         require (lockedInBets <= address(this).balance);
430 
431         // Store bet parameters on blockchain.
432         bet.amount = msg.value;
433         bet.placeBlockNumber = uint40(block.number);
434         bet.gambler = msg.sender;
435 
436         emit PlaceBetLog(msg.sender, msg.value, uint8(placParameter[uint8(PlaceParam.RotateTime)]));
437     }
438 
439     function placeTokenBet(uint[] placParameter,bytes32 _signatureHash , uint _commitLastBlock, uint _commit, bytes32 r, bytes32 s, uint8 v,uint _amount,address _playerAddress) external {
440         require (placParameter[uint8(PlaceParam.RotateTime)] != 0);
441         require (block.number <= _commitLastBlock );
442         require (secretSignerList[placParameter[uint8(PlaceParam.secretSignerIndex)]] == ecrecover(_signatureHash, v, r, s));
443 
444         // Check that the bet is in 'clean' state.
445         Bet storage bet = bets[_commit];
446         require (bet.gambler == address(0));
447 
448         //Token bet
449         lockedTokenInBets = lockedTokenInBets.add(uint(placParameter[uint8(PlaceParam.possibleWinAmount)]));
450         require (uint(placParameter[uint8(PlaceParam.possibleWinAmount)]) <= _amount.add(maxTokenProfit));
451         require (lockedTokenInBets <= ERC20(ERC20ContractAddres).balanceOf(address(this)));
452 
453         // Store bet parameters on blockchain.
454         bet.amount = _amount;
455         bet.placeBlockNumber = uint40(block.number);
456         bet.gambler = _playerAddress;
457 
458         emit PlaceBetLog(_playerAddress, _amount, uint8(placParameter[uint8(PlaceParam.RotateTime)]));
459     }
460 
461     //Estimated maximum award amount
462      function getBonusPercentageByMachineMode(uint8 machineMode)public view returns( uint upperLimit,uint maxWithdrawalPercentage ){
463          uint limitIndex = machineMode.mul(2);
464          upperLimit = withdrawalMode[limitIndex];
465          maxWithdrawalPercentage = withdrawalMode[(limitIndex.add(1))];
466     }
467 
468     // Settlement transaction
469      enum SettleParam {
470         Uplimit,
471         BonusPercentage,
472         RotateTime,
473         CurrencyType,
474         MachineMode,
475         PerWinAmount,
476         PerBetAmount,
477         PossibleWinAmount,
478         LuckySeed,
479         jackpotFee,
480         secretSignerIndex,
481         Reveal
482      }
483 
484      enum TotalParam {
485         TotalAmount,
486         TotalTokenAmount,
487         TotalJackpotWin
488      }
489 
490     function settleBet(uint[] combinationParameter, bytes32 blockHash ) external{
491 
492         // "commit" for bet settlement can only be obtained by hashing a "reveal".
493         uint commit = uint(keccak256(abi.encodePacked(combinationParameter[uint8(SettleParam.Reveal)])));
494 
495         // Fetch bet parameters into local variables (to save gas).
496         Bet storage bet = bets[commit];
497 
498         // Check that bet is in 'active' state and check that bet has not expired yet.
499         require (bet.amount != 0);
500         require (block.number <= bet.placeBlockNumber.add(BetExpirationBlocks));
501         require (blockhash(bet.placeBlockNumber) == blockHash);
502 
503         //The RNG - combine "reveal" and blockhash of LuckySeed using Keccak256.
504         bytes32 _entropy = keccak256(
505             abi.encodePacked(
506                 uint(
507                     keccak256(
508                         abi.encodePacked(
509                             combinationParameter[uint8(SettleParam.Reveal)],
510                             combinationParameter[uint8(SettleParam.LuckySeed)]
511                         )
512                     )
513                 ),
514                 blockHash
515             )
516         );
517 
518 
519          uint totalAmount = 0;
520          uint totalTokenAmount = 0;
521          uint totalJackpotWin = 0;
522          (totalAmount,totalTokenAmount,totalJackpotWin) = runRotateTime(
523             combinationParameter,
524             _entropy,
525             keccak256(
526                  abi.encodePacked(uint(_entropy),
527                  combinationParameter[uint8(SettleParam.LuckySeed)])
528             )
529         );
530 
531         // Add ether JackpotBouns
532         if (totalJackpotWin > 0 && combinationParameter[uint8(SettleParam.CurrencyType)] == 0) {
533 
534             emit JackpotBouns(bet.gambler,totalJackpotWin);
535             totalAmount = totalAmount.add(totalJackpotWin);
536             jackpotSize = uint128(jackpotSize.sub(totalJackpotWin));
537 
538         }else if (totalJackpotWin > 0 && combinationParameter[uint8(SettleParam.CurrencyType)] == 1) {
539 
540             // Add token TokenJackpotBouns
541             emit TokenJackpotBouns(bet.gambler,totalJackpotWin);
542             totalAmount = totalAmount.add(totalJackpotWin);
543             tokenJackpotSize = uint128(tokenJackpotSize.sub(totalJackpotWin));
544         }
545 
546         emit BetRelatedData(
547             bet.gambler,
548             bet.amount,
549             totalAmount,
550             _entropy,
551             keccak256(abi.encodePacked(uint(_entropy), combinationParameter[uint8(SettleParam.LuckySeed)])),
552             uint8(combinationParameter[uint8(SettleParam.Uplimit)]),
553             uint8(combinationParameter[uint8(SettleParam.RotateTime)])
554         );
555 
556         if (combinationParameter[uint8(SettleParam.CurrencyType)] == 0) {
557              //Ether game
558             if (totalAmount != 0){
559                 sendFunds(bet.gambler, totalAmount , totalAmount);
560             }
561 
562             //Send ERC20 Token
563             if (totalTokenAmount != 0){
564 
565                 if(ERC20(ERC20ContractAddres).balanceOf(address(this)) > 0){
566                     ERC20(ERC20ContractAddres).transfer(bet.gambler, totalTokenAmount);
567                     emit TokenPayment(bet.gambler, totalTokenAmount);
568                 }
569             }
570         }else if(combinationParameter[uint8(SettleParam.CurrencyType)] == 1){
571               //ERC20 game
572 
573             //Send ERC20 Token
574             if (totalAmount != 0){
575                 if(ERC20(ERC20ContractAddres).balanceOf(address(this)) > 0){
576                     ERC20(ERC20ContractAddres).transfer(bet.gambler, totalAmount);
577                     emit TokenPayment(bet.gambler, totalAmount);
578                 }
579             }
580         }
581 
582                 // Unlock the bet amount, regardless of the outcome.
583         if (combinationParameter[uint8(SettleParam.CurrencyType)] == 0) {
584                 lockedInBets = lockedInBets.sub(combinationParameter[uint8(SettleParam.PossibleWinAmount)]);
585         } else if (combinationParameter[uint8(SettleParam.CurrencyType)] == 1){
586                 lockedTokenInBets = lockedTokenInBets.sub(combinationParameter[uint8(SettleParam.PossibleWinAmount)]);
587         }
588 
589         //Move bet into 'processed' state already.
590         bet.amount = 0;
591 
592         //Save jackpotSize
593         if (uint16(combinationParameter[uint8(SettleParam.CurrencyType)]) == 0) {
594             jackpotSize = jackpotSize.add(uint(combinationParameter[uint8(SettleParam.jackpotFee)]));
595         }else if (uint16(combinationParameter[uint8(SettleParam.CurrencyType)]) == 1) {
596             tokenJackpotSize = tokenJackpotSize.add(uint(combinationParameter[uint8(SettleParam.jackpotFee)]));
597         }
598     }
599 
600     function runRotateTime ( uint[] combinationParameter, bytes32 _entropy ,bytes32 _entropy2)private view  returns(uint totalAmount,uint totalTokenAmount,uint totalJackpotWin) {
601 
602         bytes32 resultMask = 0xF000000000000000000000000000000000000000000000000000000000000000;
603         bytes32 tmp_entropy;
604         bytes32 tmp_Mask = resultMask;
605 
606         bool isGetJackpot = false;
607 
608         for (uint8 i = 0; i < combinationParameter[uint8(SettleParam.RotateTime)]; i++) {
609             if (i < 64){
610                 tmp_entropy = _entropy & tmp_Mask;
611                 tmp_entropy = tmp_entropy >> (4*(64 - (i.add(1))));
612                 tmp_Mask =  tmp_Mask >> 4;
613             }else{
614                 if ( i == 64){
615                     tmp_Mask = resultMask;
616                 }
617                 tmp_entropy = _entropy2 & tmp_Mask;
618                 tmp_entropy = tmp_entropy >> (4*( 64 - (i%63)));
619                 tmp_Mask =  tmp_Mask >> 4;
620             }
621 
622             if ( uint(tmp_entropy) < uint(combinationParameter[uint8(SettleParam.Uplimit)]) ){
623                 //bet win
624                 totalAmount = totalAmount.add(combinationParameter[uint8(SettleParam.PerWinAmount)]);
625 
626                 //Platform fee determination:Ether Game Winning players must pay platform fees
627                 uint platformFees = combinationParameter[uint8(SettleParam.PerBetAmount)].mul(platformFeePercentage);
628                 platformFees = platformFees.div(1000);
629                 totalAmount = totalAmount.sub(platformFees);
630             }else{
631                 //bet lose
632                 if (uint(combinationParameter[uint8(SettleParam.CurrencyType)]) == 0){
633 
634                     if(ERC20(ERC20ContractAddres).balanceOf(address(this)) > 0){
635                         //get token reward
636                         uint rewardAmount = uint(combinationParameter[uint8(SettleParam.PerBetAmount)]).mul(ERC20rewardMultiple);
637                         totalTokenAmount = totalTokenAmount.add(rewardAmount);
638                     }
639                 }
640             }
641 
642             //Get jackpotWin Result
643             if (isGetJackpot == false){
644                 isGetJackpot = getJackpotWinBonus(i,_entropy,_entropy2);
645             }
646         }
647 
648         if (isGetJackpot == true && combinationParameter[uint8(SettleParam.CurrencyType)] == 0) {
649             //gambler get ether bonus.
650             totalJackpotWin = jackpotSize;
651         }else if (isGetJackpot == true && combinationParameter[uint8(SettleParam.CurrencyType)] == 1) {
652             //gambler get token bonus.
653             totalJackpotWin = tokenJackpotSize;
654         }
655     }
656 
657     function getJackpotWinBonus (uint8 i,bytes32 entropy,bytes32 entropy2) private pure returns (bool isGetJackpot) {
658         bytes32 one;
659         bytes32 two;
660         bytes32 three;
661         bytes32 four;
662 
663         bytes32 resultMask = 0xF000000000000000000000000000000000000000000000000000000000000000;
664         bytes32 jackpo_Mask = resultMask;
665 
666         if (i < 61){
667             one = (entropy & jackpo_Mask) >> 4*(64 - (i + 1));
668                 jackpo_Mask =  jackpo_Mask >> 4;
669             two = (entropy & jackpo_Mask)  >> (4*(64 - (i + 2)));
670                 jackpo_Mask =  jackpo_Mask >> 4;
671             three = (entropy & jackpo_Mask) >> (4*(64 - (i + 3)));
672                 jackpo_Mask =  jackpo_Mask >> 4;
673             four = (entropy & jackpo_Mask) >> (4*(64 - (i + 4)));
674                 jackpo_Mask =  jackpo_Mask << 8;
675         }
676         else if(i >= 61){
677             if(i == 61){
678                 one = (entropy & jackpo_Mask) >> 4*(64 - (i + 1));
679                     jackpo_Mask =  jackpo_Mask >> 4;
680                 two = (entropy & jackpo_Mask)  >> (4*(64 - (i + 2)));
681                     jackpo_Mask =  jackpo_Mask >> 4;
682                 three = (entropy & jackpo_Mask) >> (4*(64 - (i + 3)));
683                     jackpo_Mask =  jackpo_Mask << 4;
684                 four = (entropy2 & 0xF000000000000000000000000000000000000000000000000000000000000000) >> 4*63;
685             }
686             else if(i == 62){
687                 one = (entropy & jackpo_Mask) >> 4*(64 - (i + 1));
688                     jackpo_Mask =  jackpo_Mask >> 4;
689                 two = (entropy & jackpo_Mask)  >> (4*(64 - (i + 2)));
690                 three = (entropy2 & 0xF000000000000000000000000000000000000000000000000000000000000000) >> 4*63;
691                 four =  (entropy2 & 0x0F00000000000000000000000000000000000000000000000000000000000000) >> 4*62;
692             }
693             else if(i == 63){
694                 one = (entropy & jackpo_Mask) >> 4*(64 - (i + 1));
695                 two = (entropy2 & 0xF000000000000000000000000000000000000000000000000000000000000000)  >> 4*63;
696                     jackpo_Mask =  jackpo_Mask >> 4;
697                 three = (entropy2 & 0x0F00000000000000000000000000000000000000000000000000000000000000) >> 4*62;
698                     jackpo_Mask =  jackpo_Mask << 4;
699                 four = (entropy2 & 0x00F0000000000000000000000000000000000000000000000000000000000000) >> 4*61;
700 
701                     jackpo_Mask = 0xF000000000000000000000000000000000000000000000000000000000000000;
702             }
703             else {
704                 one = (entropy2 & jackpo_Mask) >>  (4*( 64 - (i%64 + 1)));
705                     jackpo_Mask =  jackpo_Mask >> 4;
706                 two = (entropy2 & jackpo_Mask)  >> (4*( 64 - (i%64 + 2)))   ;
707                     jackpo_Mask =  jackpo_Mask >> 4;
708                 three = (entropy2 & jackpo_Mask) >> (4*( 64 - (i%64 + 3))) ;
709                     jackpo_Mask =  jackpo_Mask >> 4;
710                 four = (entropy2 & jackpo_Mask) >>(4*( 64 - (i%64 + 4)));
711                     jackpo_Mask =  jackpo_Mask << 8;
712             }
713         }
714 
715         if ((one ^ 0xF) == 0 && (two ^ 0xF) == 0 && (three ^ 0xF) == 0 && (four ^ 0xF) == 0){
716             isGetJackpot = true;
717        }
718     }
719 
720     //Get deductedBalance
721     function getPossibleWinAmount(uint bonusPercentage,uint senderValue)public view returns (uint platformFee,uint jackpotFee,uint possibleWinAmount) {
722 
723         //Platform Fee
724         uint prePlatformFee = (senderValue).mul(platformFeePercentage);
725         platformFee = (prePlatformFee).div(1000);
726 
727         //Get jackpotFee
728         uint preJackpotFee = (senderValue).mul(jackpotFeePercentage);
729         jackpotFee = (preJackpotFee).div(1000);
730 
731         //Win Amount
732         uint preUserGetAmount = senderValue.mul(bonusPercentage);
733         possibleWinAmount = preUserGetAmount.div(10000);
734     }
735 
736     function settleBetVerifi(uint[] combinationParameter,bytes32 blockHash )external view returns(uint totalAmount,uint totalTokenAmount,uint totalJackpotWin,bytes32 _entropy,bytes32 _entropy2) {
737 
738         require (secretSignerList[combinationParameter[uint8(SettleParam.secretSignerIndex)]] == msg.sender);
739 
740         //The RNG - combine "reveal" and blockhash of LuckySeed using Keccak256.
741         _entropy = keccak256(
742             abi.encodePacked(
743                 uint(
744                     keccak256(
745                         abi.encodePacked(
746                                 combinationParameter[uint8(SettleParam.Reveal)],
747                                 combinationParameter[uint8(SettleParam.LuckySeed)]
748                             )
749                         )
750                     ),
751                 blockHash
752             )
753         );
754 
755         _entropy2 = keccak256(
756             abi.encodePacked(
757                 uint(_entropy),
758                 combinationParameter[uint8(SettleParam.LuckySeed)]
759             )
760         );
761 
762         (totalAmount,totalTokenAmount,totalJackpotWin) = runRotateTime(combinationParameter,_entropy,_entropy2);
763     }
764 
765     // Refund transaction
766     function refundBet(uint commit,uint8 machineMode) external {
767         // Check that bet is in 'active' state.
768         Bet storage bet = bets[commit];
769         uint amount = bet.amount;
770 
771         require (amount != 0, "Bet should be in an 'active' state");
772 
773         // Check that bet has already expired.
774         require (block.number > bet.placeBlockNumber.add(BetExpirationBlocks));
775 
776         // Move bet into 'processed' state, release funds.
777         bet.amount = 0;
778 
779         //Maximum amount to be confirmed
780         uint platformFee;
781         uint jackpotFee;
782         uint possibleWinAmount;
783         uint upperLimit;
784         uint maxWithdrawalPercentage;
785         (upperLimit,maxWithdrawalPercentage) = getBonusPercentageByMachineMode(machineMode);
786         (platformFee, jackpotFee, possibleWinAmount) = getPossibleWinAmount(maxWithdrawalPercentage,amount);
787 
788         //Amount unlock
789         lockedInBets = lockedInBets.sub(possibleWinAmount);
790 
791         //Refund
792         sendFunds(bet.gambler, amount, amount);
793     }
794 
795     function refundTokenBet(uint commit,uint8 machineMode) external {
796         // Check that bet is in 'active' state.
797         Bet storage bet = bets[commit];
798         uint amount = bet.amount;
799 
800         require (amount != 0, "Bet should be in an 'active' state");
801 
802         // Check that bet has already expired.
803         require (block.number > bet.placeBlockNumber.add(BetExpirationBlocks));
804 
805         // Move bet into 'processed' state, release funds.
806         bet.amount = 0;
807 
808         //Maximum amount to be confirmed
809         uint platformFee;
810         uint jackpotFee;
811         uint possibleWinAmount;
812         uint upperLimit;
813         uint maxWithdrawalPercentage;
814         (upperLimit,maxWithdrawalPercentage) = getBonusPercentageByMachineMode(machineMode);
815         (platformFee, jackpotFee, possibleWinAmount) = getPossibleWinAmount(maxWithdrawalPercentage,amount);
816 
817         //Amount unlock
818         lockedTokenInBets = uint128(lockedTokenInBets.sub(possibleWinAmount));
819 
820         //Refund
821         ERC20(ERC20ContractAddres).transfer(bet.gambler, amount);
822         emit TokenPayment(bet.gambler, amount);
823     }
824 
825     // A helper routine to bulk clean the storage.
826     function clearStorage(uint[] cleanCommits) external {
827         uint length = cleanCommits.length;
828 
829         for (uint i = 0; i < length; i++) {
830             clearProcessedBet(cleanCommits[i]);
831         }
832     }
833 
834     // Helper routine to move 'processed' bets into 'clean' state.
835     function clearProcessedBet(uint commit) private {
836         Bet storage bet = bets[commit];
837 
838         // Do not overwrite active bets with zeros
839         if (bet.amount != 0 || block.number <= bet.placeBlockNumber + BetExpirationBlocks) {
840             return;
841         }
842 
843         // Zero out the remaining storage
844         bet.placeBlockNumber = 0;
845         bet.gambler = address(0);
846     }
847 
848     // Helper routine to process the payment.
849     function sendFunds(address beneficiary, uint amount, uint successLogAmount) private {
850         if (beneficiary.send(amount)) {
851             emit Payment(beneficiary, successLogAmount);
852         } else {
853             emit FailedPayment(beneficiary, amount);
854         }
855     }
856 
857      function sendFundsToManager(uint amount) external onlyOwner {
858         if (manager.send(amount)) {
859             emit ToManagerPayment(manager, amount);
860         } else {
861             emit ToManagerFailedPayment(manager, amount);
862         }
863     }
864 
865     function sendTokenFundsToManager( uint amount) external onlyOwner {
866         ERC20(ERC20ContractAddres).transfer(manager, amount);
867         emit TokenPayment(manager, amount);
868     }
869 
870     function sendFundsToOwner(address beneficiary, uint amount) external onlyOwner {
871         if (beneficiary.send(amount)) {
872             emit ToOwnerPayment(beneficiary, amount);
873         } else {
874             emit ToOwnerFailedPayment(beneficiary, amount);
875         }
876     }
877 
878     //Update
879     function updateMIN_BET(uint _uintNumber)public onlyManager {
880          MIN_BET = _uintNumber;
881     }
882 
883     function updateMAX_BET(uint _uintNumber)public onlyManager {
884          MAX_BET = _uintNumber;
885     }
886 
887     function updateMAX_AMOUNT(uint _uintNumber)public onlyManager {
888          MAX_AMOUNT = _uintNumber;
889     }
890 
891     function updateWithdrawalModeByIndex(uint8 _index, uint32 _value) public onlyManager{
892        withdrawalMode[_index]  = _value;
893     }
894 
895     function updateWithdrawalMode( uint32[] _withdrawalMode) public onlyManager{
896        withdrawalMode  = _withdrawalMode;
897     }
898 
899     function updateBitComparisonMask(bytes32 _newBitComparisonMask ) public onlyOwner{
900        bitComparisonMask = _newBitComparisonMask;
901     }
902 
903     function updatePlatformFeePercentage(uint8 _platformFeePercentage ) public onlyOwner{
904        platformFeePercentage = _platformFeePercentage;
905     }
906 
907     function updateJackpotFeePercentage(uint8 _jackpotFeePercentage ) public onlyOwner{
908        jackpotFeePercentage = _jackpotFeePercentage;
909     }
910 
911     function updateERC20rewardMultiple(uint8 _ERC20rewardMultiple ) public onlyManager{
912        ERC20rewardMultiple = _ERC20rewardMultiple;
913     }
914 }