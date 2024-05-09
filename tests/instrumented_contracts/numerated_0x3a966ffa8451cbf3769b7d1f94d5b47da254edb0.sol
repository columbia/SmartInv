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
175     //Funds that are locked in potentially winning bets.
176     uint public lockedInBets;
177     uint public lockedTokenInBets;
178 
179     bytes32 bitComparisonMask = 0xF;
180 
181     //Standard contract ownership transfer.
182     address public owner;
183     address private nextOwner;
184     address public manager;
185     address private nextManager;
186 
187     //The address corresponding to a private key used to sign placeBet commits.
188     address[] public secretSignerList;
189     address public ERC20ContractAddres;
190     address constant DUMMY_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
191 
192     //Single bet.
193     struct Bet {
194         //Amount in wei.
195         uint amount;
196         //place tx Block number.
197         uint40 placeBlockNumber;
198         // Address of a gambler.
199         address gambler;
200     }
201 
202     //Mapping from commits
203     mapping (uint => Bet) public bets;
204 
205     //Withdrawal mode data.
206     uint32[] public withdrawalMode;
207 
208 
209     //Admin Payment
210     event ToManagerPayment(address indexed beneficiary, uint amount);
211     event ToManagerFailedPayment(address indexed beneficiary, uint amount);
212     event ToOwnerPayment(address indexed beneficiary, uint amount);
213     event ToOwnerFailedPayment(address indexed beneficiary, uint amount);
214 
215     //Bet Payment
216     event Payment(address indexed beneficiary, uint amount);
217     event FailedPayment(address indexed beneficiary, uint amount);
218     event TokenPayment(address indexed beneficiary, uint amount);
219 
220     //JACKPOT
221     event JackpotBouns(address indexed beneficiary, uint amount);
222     event TokenJackpotBouns(address indexed beneficiary, uint amount);
223 
224     // Events that are issued to make statistic recovery easier.
225     event PlaceBetLog(address indexed player, uint amount,uint8 rotateTime);
226 
227     //Play0x_LottoBall_Event
228     event BetRelatedData(
229         address indexed player,
230         uint playerBetAmount,
231         uint playerGetAmount,
232         bytes32 entropy,
233         bytes32 entropy2,
234         uint8 Uplimit,
235         uint8 rotateTime
236     );
237 
238     // Constructor. Deliberately does not take any parameters.
239     constructor () public {
240         owner = msg.sender;
241         manager = DUMMY_ADDRESS;
242         ERC20ContractAddres = DUMMY_ADDRESS;
243     }
244 
245     // Standard modifier on methods invokable only by contract owner.
246     modifier onlyOwner {
247         require (msg.sender == owner);
248         _;
249     }
250 
251     modifier onlyManager {
252         require (msg.sender == manager);
253         _;
254     }
255 
256     //Init Parameter.
257     function initialParameter(address _manager,address[] _secretSignerList,address _erc20tokenAddress ,uint _MIN_BET,uint _MAX_BET,uint _maxProfit,uint _maxTokenProfit, uint _MAX_AMOUNT, uint8 _platformFeePercentage,uint8 _jackpotFeePercentage,uint8 _ERC20rewardMultiple,uint32[] _withdrawalMode)external onlyOwner{
258         manager = _manager;
259         secretSignerList = _secretSignerList;
260         ERC20ContractAddres = _erc20tokenAddress;
261 
262         MIN_BET = _MIN_BET;
263         MAX_BET = _MAX_BET;
264         maxProfit = _maxProfit;
265         maxTokenProfit = _maxTokenProfit;
266         MAX_AMOUNT = _MAX_AMOUNT;
267         platformFeePercentage = _platformFeePercentage;
268         jackpotFeePercentage = _jackpotFeePercentage;
269         ERC20rewardMultiple = _ERC20rewardMultiple;
270         withdrawalMode = _withdrawalMode;
271     }
272 
273     // Standard contract ownership transfer implementation,
274     function approveNextOwner(address _nextOwner) external onlyOwner {
275         require (_nextOwner != owner);
276         nextOwner = _nextOwner;
277     }
278 
279     function acceptNextOwner() external {
280         require (msg.sender == nextOwner);
281         owner = nextOwner;
282     }
283 
284     // Standard contract ownership transfer implementation,
285     function approveNextManager(address _nextManager) external onlyManager {
286         require (_nextManager != manager);
287         nextManager = _nextManager;
288     }
289 
290     function acceptNextManager() external {
291         require (msg.sender == nextManager);
292         manager = nextManager;
293     }
294 
295     // Fallback function deliberately left empty.
296     function () public payable {
297     }
298 
299     //Set signer.
300     function setSecretSignerList(address[] newSecretSignerList) external onlyOwner {
301         secretSignerList = newSecretSignerList;
302     }
303 
304     //Set signer by index
305     function setSecretSignerByIndex(address newSecretSigner,uint newSecretSignerIndex) external onlyOwner {
306         secretSignerList[newSecretSignerIndex] = newSecretSigner;
307     }
308 
309     //Set tokenAddress.
310     function setTokenAddress(address _tokenAddress) external onlyManager {
311         ERC20ContractAddres = _tokenAddress;
312     }
313 
314     // Change max bet reward. Setting this to zero effectively disables betting.
315     function setMaxProfit(uint _maxProfit) public onlyOwner {
316         require (_maxProfit < MAX_AMOUNT);
317         maxProfit = _maxProfit;
318     }
319 
320     // Funds withdrawal.
321     function withdrawFunds(address beneficiary, uint withdrawAmount) external onlyOwner {
322         require (withdrawAmount <= address(this).balance);
323 
324         uint safetyAmount = jackpotSize.add(lockedInBets).add(withdrawAmount);
325         safetyAmount = safetyAmount.add(withdrawAmount);
326 
327         require (safetyAmount <= address(this).balance);
328         sendFunds(beneficiary, withdrawAmount, withdrawAmount);
329     }
330 
331     // Token withdrawal.
332     function withdrawToken(address beneficiary, uint withdrawAmount) external onlyOwner {
333         require (withdrawAmount <= ERC20(ERC20ContractAddres).balanceOf(address(this)));
334 
335         uint safetyAmount = tokenJackpotSize.add(lockedTokenInBets);
336         safetyAmount = safetyAmount.add(withdrawAmount);
337         require (safetyAmount <= ERC20(ERC20ContractAddres).balanceOf(address(this)));
338 
339          ERC20(ERC20ContractAddres).transfer(beneficiary, withdrawAmount);
340          emit TokenPayment(beneficiary, withdrawAmount);
341     }
342 
343     //Recovery of funds
344     function withdrawAllFunds(address beneficiary) external onlyOwner {
345         if (beneficiary.send(address(this).balance)) {
346             lockedInBets = 0;
347             emit Payment(beneficiary, address(this).balance);
348         } else {
349             emit FailedPayment(beneficiary, address(this).balance);
350         }
351     }
352 
353     //Recovery of Token funds
354     function withdrawAlltokenFunds(address beneficiary) external onlyOwner {
355         ERC20(ERC20ContractAddres).transfer(beneficiary, ERC20(ERC20ContractAddres).balanceOf(address(this)));
356         lockedTokenInBets = 0;
357         emit TokenPayment(beneficiary, ERC20(ERC20ContractAddres).balanceOf(address(this)));
358     }
359 
360     // Contract may be destroyed only when there are no ongoing bets,
361     // either settled or refunded. All funds are transferred to contract owner.
362     function kill() external onlyOwner {
363         require (lockedInBets == 0);
364         require (lockedTokenInBets == 0);
365         selfdestruct(owner);
366     }
367 
368     function getContractInformation()public view returns(
369         uint _jackpotSize,
370         uint _tokenJackpotSize,
371         uint _MIN_BET,
372         uint _MAX_BET,
373         uint _MAX_AMOUNT,
374         uint8 _platformFeePercentage,
375         uint8 _jackpotFeePercentage,
376         uint _maxProfit,
377         uint _maxTokenProfit,
378         uint _lockedInBets,
379         uint _lockedTokenInBets,
380         uint32[] _withdrawalMode){
381 
382         _jackpotSize = jackpotSize;
383         _tokenJackpotSize = tokenJackpotSize;
384         _MIN_BET = MIN_BET;
385         _MAX_BET = MAX_BET;
386         _MAX_AMOUNT = MAX_AMOUNT;
387         _platformFeePercentage = platformFeePercentage;
388         _jackpotFeePercentage = jackpotFeePercentage;
389         _maxProfit = maxProfit;
390         _maxTokenProfit = maxTokenProfit;
391         _lockedInBets = lockedInBets;
392         _lockedTokenInBets = lockedTokenInBets;
393         _withdrawalMode = withdrawalMode;
394     }
395 
396     function getContractAddress()public view returns(
397         address _owner,
398         address _manager,
399         address[] _secretSignerList,
400         address _ERC20ContractAddres ){
401 
402         _owner = owner;
403         _manager= manager;
404         _secretSignerList = secretSignerList;
405         _ERC20ContractAddres = ERC20ContractAddres;
406     }
407 
408     // Settlement transaction
409     enum PlaceParam {
410         RotateTime,
411         possibleWinAmount,
412         secretSignerIndex
413     }
414 
415     //Bet by ether: Commits are signed with a block limit to ensure that they are used at most once.
416     function placeBet(uint[] placParameter, bytes32 _signatureHash , uint _commitLastBlock, uint _commit, bytes32 r, bytes32 s, uint8 v) external payable {
417         require (uint8(placParameter[uint8(PlaceParam.RotateTime)]) != 0);
418         require (block.number <= _commitLastBlock );
419         require (secretSignerList[placParameter[uint8(PlaceParam.secretSignerIndex)]] == ecrecover(_signatureHash, v, r, s));
420 
421         // Check that the bet is in 'clean' state.
422         Bet storage bet = bets[_commit];
423         require (bet.gambler == address(0));
424 
425         //Ether balanceet
426         lockedInBets = lockedInBets.add(uint(placParameter[uint8(PlaceParam.possibleWinAmount)]));
427         require (uint(placParameter[uint8(PlaceParam.possibleWinAmount)]) <= msg.value.add(maxProfit));
428         require (lockedInBets <= address(this).balance);
429 
430         // Store bet parameters on blockchain.
431         bet.amount = msg.value;
432         bet.placeBlockNumber = uint40(block.number);
433         bet.gambler = msg.sender;
434 
435         emit PlaceBetLog(msg.sender, msg.value, uint8(placParameter[uint8(PlaceParam.RotateTime)]));
436     }
437 
438     function placeTokenBet(uint[] placParameter,bytes32 _signatureHash , uint _commitLastBlock, uint _commit, bytes32 r, bytes32 s, uint8 v,uint _amount,address _playerAddress) external {
439         require (placParameter[uint8(PlaceParam.RotateTime)] != 0);
440         require (block.number <= _commitLastBlock );
441         require (secretSignerList[placParameter[uint8(PlaceParam.secretSignerIndex)]] == ecrecover(_signatureHash, v, r, s));
442 
443         // Check that the bet is in 'clean' state.
444         Bet storage bet = bets[_commit];
445         require (bet.gambler == address(0));
446 
447         //Token bet
448         lockedTokenInBets = lockedTokenInBets.add(uint(placParameter[uint8(PlaceParam.possibleWinAmount)]));
449         require (uint(placParameter[uint8(PlaceParam.possibleWinAmount)]) <= _amount.add(maxTokenProfit));
450         require (lockedTokenInBets <= ERC20(ERC20ContractAddres).balanceOf(address(this)));
451 
452         // Store bet parameters on blockchain.
453         bet.amount = _amount;
454         bet.placeBlockNumber = uint40(block.number);
455         bet.gambler = _playerAddress;
456 
457         emit PlaceBetLog(_playerAddress, _amount, uint8(placParameter[uint8(PlaceParam.RotateTime)]));
458     }
459 
460     //Estimated maximum award amount
461      function getBonusPercentageByMachineMode(uint8 machineMode)public view returns( uint upperLimit,uint maxWithdrawalPercentage ){
462          uint limitIndex = machineMode.mul(2);
463          upperLimit = withdrawalMode[limitIndex];
464          maxWithdrawalPercentage = withdrawalMode[(limitIndex.add(1))];
465     }
466 
467     // Settlement transaction
468      enum SettleParam {
469         Uplimit,
470         BonusPercentage,
471         RotateTime,
472         CurrencyType,
473         MachineMode,
474         PerWinAmount,
475         PerBetAmount,
476         PossibleWinAmount,
477         LuckySeed,
478         jackpotFee,
479         secretSignerIndex,
480         Reveal
481      }
482 
483      enum TotalParam {
484         TotalAmount,
485         TotalTokenAmount,
486         TotalJackpotWin
487      }
488 
489     function settleBet(uint[] combinationParameter, bytes32 blockHash ) external{
490 
491         // "commit" for bet settlement can only be obtained by hashing a "reveal".
492         uint commit = uint(keccak256(abi.encodePacked(combinationParameter[uint8(SettleParam.Reveal)])));
493 
494         // Fetch bet parameters into local variables (to save gas).
495         Bet storage bet = bets[commit];
496 
497         // Check that bet is in 'active' state and check that bet has not expired yet.
498         require (bet.amount != 0);
499         require (block.number <= bet.placeBlockNumber.add(BetExpirationBlocks));
500         require (blockhash(bet.placeBlockNumber) == blockHash);
501 
502         //The RNG - combine "reveal" and blockhash of LuckySeed using Keccak256.
503         bytes32 _entropy = keccak256(
504             abi.encodePacked(
505                 uint(
506                     keccak256(
507                         abi.encodePacked(
508                             combinationParameter[uint8(SettleParam.Reveal)],
509                             combinationParameter[uint8(SettleParam.LuckySeed)]
510                         )
511                     )
512                 ),
513                 blockHash
514             )
515         );
516 
517 
518          uint totalAmount = 0;
519          uint totalTokenAmount = 0;
520          uint totalJackpotWin = 0;
521          (totalAmount,totalTokenAmount,totalJackpotWin) = runRotateTime(
522             combinationParameter,
523             _entropy,
524             keccak256(
525                  abi.encodePacked(uint(_entropy),
526                  combinationParameter[uint8(SettleParam.LuckySeed)])
527             )
528         );
529 
530         // Add ether JackpotBouns
531         if (totalJackpotWin > 0 && combinationParameter[uint8(SettleParam.CurrencyType)] == 0) {
532 
533             emit JackpotBouns(bet.gambler,totalJackpotWin);
534             totalAmount = totalAmount.add(totalJackpotWin);
535             jackpotSize = uint128(jackpotSize.sub(totalJackpotWin));
536 
537         }else if (totalJackpotWin > 0 && combinationParameter[uint8(SettleParam.CurrencyType)] == 1) {
538 
539             // Add token TokenJackpotBouns
540             emit TokenJackpotBouns(bet.gambler,totalJackpotWin);
541             totalAmount = totalAmount.add(totalJackpotWin);
542             tokenJackpotSize = uint128(tokenJackpotSize.sub(totalJackpotWin));
543         }
544 
545         emit BetRelatedData(
546             bet.gambler,
547             bet.amount,
548             totalAmount,
549             _entropy,
550             keccak256(abi.encodePacked(uint(_entropy), combinationParameter[uint8(SettleParam.LuckySeed)])),
551             uint8(combinationParameter[uint8(SettleParam.Uplimit)]),
552             uint8(combinationParameter[uint8(SettleParam.RotateTime)])
553         );
554 
555         if (combinationParameter[uint8(SettleParam.CurrencyType)] == 0) {
556              //Ether game
557             if (totalAmount != 0){
558                 sendFunds(bet.gambler, totalAmount , totalAmount);
559             }
560 
561             //Send ERC20 Token
562             if (totalTokenAmount != 0){
563 
564                 if(ERC20(ERC20ContractAddres).balanceOf(address(this)) > 0){
565                     ERC20(ERC20ContractAddres).transfer(bet.gambler, totalTokenAmount);
566                     emit TokenPayment(bet.gambler, totalTokenAmount);
567                 }
568             }
569         }else if(combinationParameter[uint8(SettleParam.CurrencyType)] == 1){
570               //ERC20 game
571 
572             //Send ERC20 Token
573             if (totalAmount != 0){
574                 if(ERC20(ERC20ContractAddres).balanceOf(address(this)) > 0){
575                     ERC20(ERC20ContractAddres).transfer(bet.gambler, totalAmount);
576                     emit TokenPayment(bet.gambler, totalAmount);
577                 }
578             }
579         }
580 
581                 // Unlock the bet amount, regardless of the outcome.
582         if (combinationParameter[uint8(SettleParam.CurrencyType)] == 0) {
583                 lockedInBets = lockedInBets.sub(combinationParameter[uint8(SettleParam.PossibleWinAmount)]);
584         } else if (combinationParameter[uint8(SettleParam.CurrencyType)] == 1){
585                 lockedTokenInBets = lockedTokenInBets.sub(combinationParameter[uint8(SettleParam.PossibleWinAmount)]);
586         }
587 
588         //Move bet into 'processed' state already.
589         bet.amount = 0;
590 
591         //Save jackpotSize
592         if (uint16(combinationParameter[uint8(SettleParam.CurrencyType)]) == 0) {
593             jackpotSize = jackpotSize.add(uint(combinationParameter[uint8(SettleParam.jackpotFee)]));
594         }else if (uint16(combinationParameter[uint8(SettleParam.CurrencyType)]) == 1) {
595             tokenJackpotSize = tokenJackpotSize.add(uint(combinationParameter[uint8(SettleParam.jackpotFee)]));
596         }
597     }
598 
599     function runRotateTime ( uint[] combinationParameter, bytes32 _entropy ,bytes32 _entropy2)private view  returns(uint totalAmount,uint totalTokenAmount,uint totalJackpotWin) {
600 
601         bytes32 resultMask = 0xF000000000000000000000000000000000000000000000000000000000000000;
602         bytes32 tmp_entropy;
603         bytes32 tmp_Mask = resultMask;
604 
605         bool isGetJackpot = false;
606 
607         for (uint8 i = 0; i < combinationParameter[uint8(SettleParam.RotateTime)]; i++) {
608             if (i < 64){
609                 tmp_entropy = _entropy & tmp_Mask;
610                 tmp_entropy = tmp_entropy >> (4*(64 - (i.add(1))));
611                 tmp_Mask =  tmp_Mask >> 4;
612             }else{
613                 if ( i == 64){
614                     tmp_Mask = resultMask;
615                 }
616                 tmp_entropy = _entropy2 & tmp_Mask;
617                 tmp_entropy = tmp_entropy >> (4*( 64 - (i%63)));
618                 tmp_Mask =  tmp_Mask >> 4;
619             }
620 
621             if ( uint(tmp_entropy) < uint(combinationParameter[uint8(SettleParam.Uplimit)]) ){
622                 //bet win
623                 totalAmount = totalAmount.add(combinationParameter[uint8(SettleParam.PerWinAmount)]);
624 
625                 //Platform fee determination:Ether Game Winning players must pay platform fees
626                 uint platformFees = combinationParameter[uint8(SettleParam.PerBetAmount)].mul(platformFeePercentage);
627                 platformFees = platformFees.div(1000);
628                 totalAmount = totalAmount.sub(platformFees);
629             }else{
630                 //bet lose
631                 if (uint(combinationParameter[uint8(SettleParam.CurrencyType)]) == 0){
632 
633                     if(ERC20(ERC20ContractAddres).balanceOf(address(this)) > 0){
634                         //get token reward
635                         uint rewardAmount = uint(combinationParameter[uint8(SettleParam.PerBetAmount)]).mul(ERC20rewardMultiple);
636                         totalTokenAmount = totalTokenAmount.add(rewardAmount);
637                     }
638                 }
639             }
640 
641             //Get jackpotWin Result
642             if (isGetJackpot == false){
643                 isGetJackpot = getJackpotWinBonus(i,_entropy,_entropy2);
644             }
645         }
646 
647         if (isGetJackpot == true && combinationParameter[uint8(SettleParam.CurrencyType)] == 0) {
648             //gambler get ether bonus.
649             totalJackpotWin = jackpotSize;
650         }else if (isGetJackpot == true && combinationParameter[uint8(SettleParam.CurrencyType)] == 1) {
651             //gambler get token bonus.
652             totalJackpotWin = tokenJackpotSize;
653         }
654     }
655 
656     function getJackpotWinBonus (uint8 i,bytes32 entropy,bytes32 entropy2) private pure returns (bool isGetJackpot) {
657         bytes32 one;
658         bytes32 two;
659         bytes32 three;
660         bytes32 four;
661 
662         bytes32 resultMask = 0xF000000000000000000000000000000000000000000000000000000000000000;
663         bytes32 jackpo_Mask = resultMask;
664 
665         if (i < 61){
666             one = (entropy & jackpo_Mask) >> 4*(64 - (i + 1));
667                 jackpo_Mask =  jackpo_Mask >> 4;
668             two = (entropy & jackpo_Mask)  >> (4*(64 - (i + 2)));
669                 jackpo_Mask =  jackpo_Mask >> 4;
670             three = (entropy & jackpo_Mask) >> (4*(64 - (i + 3)));
671                 jackpo_Mask =  jackpo_Mask >> 4;
672             four = (entropy & jackpo_Mask) >> (4*(64 - (i + 4)));
673                 jackpo_Mask =  jackpo_Mask << 8;
674         }
675         else if(i >= 61){
676             if(i == 61){
677                 one = (entropy & jackpo_Mask) >> 4*(64 - (i + 1));
678                     jackpo_Mask =  jackpo_Mask >> 4;
679                 two = (entropy & jackpo_Mask)  >> (4*(64 - (i + 2)));
680                     jackpo_Mask =  jackpo_Mask >> 4;
681                 three = (entropy & jackpo_Mask) >> (4*(64 - (i + 3)));
682                     jackpo_Mask =  jackpo_Mask << 4;
683                 four = (entropy2 & 0xF000000000000000000000000000000000000000000000000000000000000000) >> 4*63;
684             }
685             else if(i == 62){
686                 one = (entropy & jackpo_Mask) >> 4*(64 - (i + 1));
687                     jackpo_Mask =  jackpo_Mask >> 4;
688                 two = (entropy & jackpo_Mask)  >> (4*(64 - (i + 2)));
689                 three = (entropy2 & 0xF000000000000000000000000000000000000000000000000000000000000000) >> 4*63;
690                 four =  (entropy2 & 0x0F00000000000000000000000000000000000000000000000000000000000000) >> 4*62;
691             }
692             else if(i == 63){
693                 one = (entropy & jackpo_Mask) >> 4*(64 - (i + 1));
694                 two = (entropy2 & 0xF000000000000000000000000000000000000000000000000000000000000000)  >> 4*63;
695                     jackpo_Mask =  jackpo_Mask >> 4;
696                 three = (entropy2 & 0x0F00000000000000000000000000000000000000000000000000000000000000) >> 4*62;
697                     jackpo_Mask =  jackpo_Mask << 4;
698                 four = (entropy2 & 0x00F0000000000000000000000000000000000000000000000000000000000000) >> 4*61;
699 
700                     jackpo_Mask = 0xF000000000000000000000000000000000000000000000000000000000000000;
701             }
702             else {
703                 one = (entropy2 & jackpo_Mask) >>  (4*( 64 - (i%64 + 1)));
704                     jackpo_Mask =  jackpo_Mask >> 4;
705                 two = (entropy2 & jackpo_Mask)  >> (4*( 64 - (i%64 + 2)))   ;
706                     jackpo_Mask =  jackpo_Mask >> 4;
707                 three = (entropy2 & jackpo_Mask) >> (4*( 64 - (i%64 + 3))) ;
708                     jackpo_Mask =  jackpo_Mask >> 4;
709                 four = (entropy2 & jackpo_Mask) >>(4*( 64 - (i%64 + 4)));
710                     jackpo_Mask =  jackpo_Mask << 8;
711             }
712         }
713 
714         if ((one ^ 0xF) == 0 && (two ^ 0xF) == 0 && (three ^ 0xF) == 0 && (four ^ 0xF) == 0){
715             isGetJackpot = true;
716        }
717     }
718 
719     //Get deductedBalance
720     function getPossibleWinAmount(uint bonusPercentage,uint senderValue)public view returns (uint platformFee,uint jackpotFee,uint possibleWinAmount) {
721 
722         //Platform Fee
723         uint prePlatformFee = (senderValue).mul(platformFeePercentage);
724         platformFee = (prePlatformFee).div(1000);
725 
726         //Get jackpotFee
727         uint preJackpotFee = (senderValue).mul(jackpotFeePercentage);
728         jackpotFee = (preJackpotFee).div(1000);
729 
730         //Win Amount
731         uint preUserGetAmount = senderValue.mul(bonusPercentage);
732         possibleWinAmount = preUserGetAmount.div(10000);
733     }
734 
735     function settleBetVerifi(uint[] combinationParameter,bytes32 blockHash )external view returns(uint totalAmount,uint totalTokenAmount,uint totalJackpotWin,bytes32 _entropy,bytes32 _entropy2) {
736 
737         require (secretSignerList[combinationParameter[uint8(SettleParam.secretSignerIndex)]] == msg.sender);
738 
739         //The RNG - combine "reveal" and blockhash of LuckySeed using Keccak256.
740         _entropy = keccak256(
741             abi.encodePacked(
742                 uint(
743                     keccak256(
744                         abi.encodePacked(
745                                 combinationParameter[uint8(SettleParam.Reveal)],
746                                 combinationParameter[uint8(SettleParam.LuckySeed)]
747                             )
748                         )
749                     ),
750                 blockHash
751             )
752         );
753 
754         _entropy2 = keccak256(
755             abi.encodePacked(
756                 uint(_entropy),
757                 combinationParameter[uint8(SettleParam.LuckySeed)]
758             )
759         );
760 
761         (totalAmount,totalTokenAmount,totalJackpotWin) = runRotateTime(combinationParameter,_entropy,_entropy2);
762     }
763 
764     // Refund transaction
765     function refundBet(uint commit,uint8 machineMode) external {
766         // Check that bet is in 'active' state.
767         Bet storage bet = bets[commit];
768         uint amount = bet.amount;
769 
770         require (amount != 0, "Bet should be in an 'active' state");
771 
772         // Check that bet has already expired.
773         require (block.number > bet.placeBlockNumber.add(BetExpirationBlocks));
774 
775         // Move bet into 'processed' state, release funds.
776         bet.amount = 0;
777 
778         //Maximum amount to be confirmed
779         uint platformFee;
780         uint jackpotFee;
781         uint possibleWinAmount;
782         uint upperLimit;
783         uint maxWithdrawalPercentage;
784         (upperLimit,maxWithdrawalPercentage) = getBonusPercentageByMachineMode(machineMode);
785         (platformFee, jackpotFee, possibleWinAmount) = getPossibleWinAmount(maxWithdrawalPercentage,amount);
786 
787         //Amount unlock
788         lockedInBets = lockedInBets.sub(possibleWinAmount);
789 
790         //Refund
791         sendFunds(bet.gambler, amount, amount);
792     }
793 
794     function refundTokenBet(uint commit,uint8 machineMode) external {
795         // Check that bet is in 'active' state.
796         Bet storage bet = bets[commit];
797         uint amount = bet.amount;
798 
799         require (amount != 0, "Bet should be in an 'active' state");
800 
801         // Check that bet has already expired.
802         require (block.number > bet.placeBlockNumber.add(BetExpirationBlocks));
803 
804         // Move bet into 'processed' state, release funds.
805         bet.amount = 0;
806 
807         //Maximum amount to be confirmed
808         uint platformFee;
809         uint jackpotFee;
810         uint possibleWinAmount;
811         uint upperLimit;
812         uint maxWithdrawalPercentage;
813         (upperLimit,maxWithdrawalPercentage) = getBonusPercentageByMachineMode(machineMode);
814         (platformFee, jackpotFee, possibleWinAmount) = getPossibleWinAmount(maxWithdrawalPercentage,amount);
815 
816         //Amount unlock
817         lockedTokenInBets = uint128(lockedTokenInBets.sub(possibleWinAmount));
818 
819         //Refund
820         ERC20(ERC20ContractAddres).transfer(bet.gambler, amount);
821         emit TokenPayment(bet.gambler, amount);
822     }
823 
824     // A helper routine to bulk clean the storage.
825     function clearStorage(uint[] cleanCommits) external {
826         uint length = cleanCommits.length;
827 
828         for (uint i = 0; i < length; i++) {
829             clearProcessedBet(cleanCommits[i]);
830         }
831     }
832 
833     // Helper routine to move 'processed' bets into 'clean' state.
834     function clearProcessedBet(uint commit) private {
835         Bet storage bet = bets[commit];
836 
837         // Do not overwrite active bets with zeros
838         if (bet.amount != 0 || block.number <= bet.placeBlockNumber + BetExpirationBlocks) {
839             return;
840         }
841 
842         // Zero out the remaining storage
843         bet.placeBlockNumber = 0;
844         bet.gambler = address(0);
845     }
846 
847     // Helper routine to process the payment.
848     function sendFunds(address beneficiary, uint amount, uint successLogAmount) private {
849         if (beneficiary.send(amount)) {
850             emit Payment(beneficiary, successLogAmount);
851         } else {
852             emit FailedPayment(beneficiary, amount);
853         }
854     }
855 
856      function sendFundsToManager(uint amount) external onlyOwner {
857         if (manager.send(amount)) {
858             emit ToManagerPayment(manager, amount);
859         } else {
860             emit ToManagerFailedPayment(manager, amount);
861         }
862     }
863 
864     function sendTokenFundsToManager( uint amount) external onlyOwner {
865         ERC20(ERC20ContractAddres).transfer(manager, amount);
866         emit TokenPayment(manager, amount);
867     }
868 
869     function sendFundsToOwner(address beneficiary, uint amount) external onlyOwner {
870         if (beneficiary.send(amount)) {
871             emit ToOwnerPayment(beneficiary, amount);
872         } else {
873             emit ToOwnerFailedPayment(beneficiary, amount);
874         }
875     }
876 
877     //Update
878     function updateMIN_BET(uint _uintNumber)public onlyManager {
879          MIN_BET = _uintNumber;
880     }
881 
882     function updateMAX_BET(uint _uintNumber)public onlyManager {
883          MAX_BET = _uintNumber;
884     }
885 
886     function updateMAX_AMOUNT(uint _uintNumber)public onlyManager {
887          MAX_AMOUNT = _uintNumber;
888     }
889 
890     function updateWithdrawalModeByIndex(uint8 _index, uint32 _value) public onlyManager{
891        withdrawalMode[_index]  = _value;
892     }
893 
894     function updateWithdrawalMode( uint32[] _withdrawalMode) public onlyManager{
895        withdrawalMode  = _withdrawalMode;
896     }
897 
898     function updateBitComparisonMask(bytes32 _newBitComparisonMask ) public onlyOwner{
899        bitComparisonMask = _newBitComparisonMask;
900     }
901 
902     function updatePlatformFeePercentage(uint8 _platformFeePercentage ) public onlyOwner{
903        platformFeePercentage = _platformFeePercentage;
904     }
905 
906     function updateJackpotFeePercentage(uint8 _jackpotFeePercentage ) public onlyOwner{
907        jackpotFeePercentage = _jackpotFeePercentage;
908     }
909 
910     function updateERC20rewardMultiple(uint8 _ERC20rewardMultiple ) public onlyManager{
911        ERC20rewardMultiple = _ERC20rewardMultiple;
912     }
913 }