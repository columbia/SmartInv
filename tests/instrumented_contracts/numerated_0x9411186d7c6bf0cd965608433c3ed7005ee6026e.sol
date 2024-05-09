1 pragma solidity ^0.4.24;
2 
3 /*
4 * ZETHR PRESENTS: SLOTS
5 *
6 * Written August 2018 by the Zethr team for zethr.game.
7 *
8 * Code framework written by Norsefire.
9 * EV calculations written by TropicalRogue.
10 * Audit and edits written by Klob.
11 * Multiroll framework written by Etherguy.
12 *
13 * Rolling Odds:
14 *   49.31%  Lose / 50.69% Win  
15 *   35.64%  Two Matching Icons
16 *       - 10.00% : 2.50x    Multiplier [Two Rockets]
17 *       - 15.00% : 1.33x    Multiplier [Two Gold  Pyramids]
18 *       - 15.00% : 1.00x    Multiplier [Two 'Z' Symbols]
19 *       - 15.00% : 1.00x    Multiplier [Two 'T' Symbols]
20 *       - 15.00% : 1.00x    Multiplier [Two 'H' Symbols]
21 *       - 15.00% : 1.25x    Multiplier [Two Purple Pyramids]
22 *       - 15.00% : 2.00x    Multiplier [Two Ether Icons]
23 *   6.79%   One Of Each Pyramid
24 *       - 1.50x  Multiplier
25 *   2.94%   One Moon Icon
26 *       - 2.50x Multiplier
27 *   5.00%   Three Matching Icons
28 *       - 03.00% : 13.00x   Multiplier [Three Rockets]
29 *       - 05.00% : 09.00x   Multiplier [Three Gold  Pyramids]
30 *       - 27.67% : 03.00x   Multiplier [Three 'Z' Symbols]
31 *       - 27.67% : 03.00x   Multiplier [Three 'T' Symbols]
32 *       - 27.67% : 03.00x   Multiplier [Three 'H' Symbols]
33 *       - 05.00% : 07.50x   Multiplier [Three Purple Pyramids]
34 *       - 04.00% : 11.00x   Multiplier [Three Ether Icons]
35 *   0.28%   Z T H Prize
36 *       - 20x Multiplier
37 *   0.03%   Two Moon Icons
38 *       - 50x  Multiplier
39 *   0.0001% Three Moon Grand Jackpot
40 *       - Jackpot Amount (variable)
41 *
42 *   From all of us at Zethr, thank you for playing!    
43 *
44 */
45 
46 // Zethr Token Bankroll interface
47 contract ZethrTokenBankroll{
48   // Game request token transfer to player 
49   function gameRequestTokens(address target, uint tokens) public;
50   function gameTokenAmount(address what) public returns (uint);
51 }
52 
53 // Zether Main Bankroll interface
54 contract ZethrMainBankroll{
55   function gameGetTokenBankrollList() public view returns (address[7]);
56 }
57 
58 // Zethr main contract interface
59 contract ZethrInterface{
60   function withdraw() public;
61 }
62 
63 // Library for figuring out the "tier" (1-7) of a dividend rate
64 library ZethrTierLibrary{
65 
66   function getTier(uint divRate) 
67     internal 
68     pure 
69     returns (uint)
70   {
71     // Tier logic 
72     // Returns the index of the UsedBankrollAddresses which should be used to call into to withdraw tokens 
73         
74     // We can divide by magnitude
75     // Remainder is removed so we only get the actual number we want
76     uint actualDiv = divRate; 
77     if (actualDiv >= 30){
78       return 6;
79     } else if (actualDiv >= 25){
80       return 5;
81     } else if (actualDiv >= 20){
82       return 4;
83     } else if (actualDiv >= 15){
84       return 3;
85     } else if (actualDiv >= 10){
86       return 2; 
87     } else if (actualDiv >= 5){
88       return 1;
89     } else if (actualDiv >= 2){
90       return 0;
91     } else{
92       // Impossible
93       revert(); 
94     }
95   }
96 }
97 
98 // Contract that contains the functions to interact with the ZlotsJackpotHoldingContract
99 contract ZlotsJackpotHoldingContract {
100   function payOutWinner(address winner) public; 
101   function getJackpot() public view returns (uint);
102 }
103  
104 // Contract that contains the functions to interact with the bankroll system
105 contract ZethrBankrollBridge {
106   // Must have an interface with the main Zethr token contract 
107   ZethrInterface Zethr;
108    
109   // Store the bankroll addresses 
110   // address[0] is tier1: 2-5% 
111   // address[1] is tier2: 5-10, etc
112   address[7] UsedBankrollAddresses; 
113 
114   // Mapping for easy checking
115   mapping(address => bool) ValidBankrollAddress;
116     
117   // Set up the tokenbankroll stuff 
118   function setupBankrollInterface(address ZethrMainBankrollAddress) 
119     internal 
120   {
121     // Instantiate Zethr
122     Zethr = ZethrInterface(0xb9ab8eed48852de901c13543042204c6c569b811);
123 
124     // Get the bankroll addresses from the main bankroll
125     UsedBankrollAddresses = ZethrMainBankroll(ZethrMainBankrollAddress).gameGetTokenBankrollList();
126     for(uint i=0; i<7; i++){
127       ValidBankrollAddress[UsedBankrollAddresses[i]] = true;
128     }
129   }
130     
131   // Require a function to be called from a *token* bankroll 
132   modifier fromBankroll() {
133     require(ValidBankrollAddress[msg.sender], "msg.sender should be a valid bankroll");
134     _;
135   }
136     
137   // Request a payment in tokens to a user FROM the appropriate tokenBankroll 
138   // Figure out the right bankroll via divRate 
139   function RequestBankrollPayment(address to, uint tokens, uint tier) 
140     internal 
141   {
142     address tokenBankrollAddress = UsedBankrollAddresses[tier];
143     ZethrTokenBankroll(tokenBankrollAddress).gameRequestTokens(to, tokens);
144   }
145     
146   function getZethrTokenBankroll(uint divRate) 
147     public 
148     view 
149     returns (ZethrTokenBankroll)
150   {
151     return ZethrTokenBankroll(UsedBankrollAddresses[ZethrTierLibrary.getTier(divRate)]);
152   }
153 }
154 
155 // Contract that contains functions to move divs to the main bankroll
156 contract ZethrShell is ZethrBankrollBridge {
157 
158   // Dump ETH balance to main bankroll
159   function WithdrawToBankroll() 
160     public 
161   {
162     address(UsedBankrollAddresses[0]).transfer(address(this).balance);
163   }
164 
165   // Dump divs and dump ETH into bankroll
166   function WithdrawAndTransferToBankroll() 
167     public 
168   {
169     Zethr.withdraw();
170     WithdrawToBankroll();
171   }
172 }
173 
174 // Zethr game data setup
175 // Includes all necessary to run with Zethr
176 contract ZlotsMulti is ZethrShell {
177   using SafeMath for uint;
178 
179   // ---------------------- Events
180 
181   // Might as well notify everyone when the house takes its cut out.
182   event HouseRetrievedTake(
183     uint timeTaken,
184     uint tokensWithdrawn
185   );
186 
187   // Fire an event whenever someone places a bet.
188   event TokensWagered(
189     address _wagerer,
190     uint _wagered
191   );
192 
193   event LogResult(
194     address _wagerer,
195     uint _result,
196     uint _profit,
197     uint _wagered,
198     uint _category,
199     bool _win
200   );
201 
202   // Result announcement events (to dictate UI output!)
203   event Loss(address _wagerer, uint _block);                  // Category 0
204   event ThreeMoonJackpot(address _wagerer, uint _block);      // Category 1
205   event TwoMoonPrize(address _wagerer, uint _block);          // Category 2
206   event ZTHPrize(address _wagerer, uint _block);              // Category 3
207   event ThreeZSymbols(address _wagerer, uint _block);         // Category 4
208   event ThreeTSymbols(address _wagerer, uint _block);         // Category 5
209   event ThreeHSymbols(address _wagerer, uint _block);         // Category 6
210   event ThreeEtherIcons(address _wagerer, uint _block);       // Category 7
211   event ThreePurplePyramids(address _wagerer, uint _block);   // Category 8
212   event ThreeGoldPyramids(address _wagerer, uint _block);     // Category 9
213   event ThreeRockets(address _wagerer, uint _block);          // Category 10
214   event OneMoonPrize(address _wagerer, uint _block);          // Category 11
215   event OneOfEachPyramidPrize(address _wagerer, uint _block); // Category 12
216   event TwoZSymbols(address _wagerer, uint _block);           // Category 13
217   event TwoTSymbols(address _wagerer, uint _block);           // Category 14
218   event TwoHSymbols(address _wagerer, uint _block);           // Category 15
219   event TwoEtherIcons(address _wagerer, uint _block);         // Category 16
220   event TwoPurplePyramids(address _wagerer, uint _block);     // Category 17
221   event TwoGoldPyramids(address _wagerer, uint _block);       // Category 18
222   event TwoRockets(address _wagerer, uint _block);            // Category 19    
223   event SpinConcluded(address _wagerer, uint _block);         // Debug event
224 
225   // ---------------------- Modifiers
226 
227   // Makes sure that player porfit can't exceed a maximum amount
228   // We use the max win here - 50x
229   modifier betIsValid(uint _betSize, uint divRate, uint8 spins) {
230     require(_betSize.div(spins).mul(50) <= getMaxProfit(divRate));
231     require(_betSize.div(spins) >= minBet);
232     _;
233   }
234 
235   // Requires the game to be currently active
236   modifier gameIsActive {
237     require(gamePaused == false);
238     _;
239   }
240 
241   // Require msg.sender to be owner
242   modifier onlyOwner {
243     require(msg.sender == owner); 
244     _;
245   }
246 
247   // Requires msg.sender to be bankroll
248   modifier onlyBankroll {
249     require(msg.sender == bankroll);
250     _;
251   }
252 
253   // Requires msg.sender to be owner or bankroll
254   modifier onlyOwnerOrBankroll {
255     require(msg.sender == owner || msg.sender == bankroll);
256     _;
257   }
258 
259   // ---------------------- Variables
260 
261   // Configurables
262   uint constant public maxProfitDivisor = 1000000;
263   uint constant public houseEdgeDivisor = 1000;
264   mapping (uint => uint) public maxProfit;
265   uint public maxProfitAsPercentOfHouse;
266   uint public minBet = 1e18;
267   address public zlotsJackpot;
268   address private owner;
269   address private bankroll;
270   bool public gamePaused;
271   bool public canMining = true;
272   uint public miningProfit = 100;
273   uint public minBetMining = 1e18;
274   // Trackers
275   uint  public totalSpins;
276   uint  public totalZTHWagered;
277   mapping (uint => uint) public contractBalance;
278     
279   // Is betting allowed? (Administrative function, in the event of unforeseen bugs)
280   //bool public gameActive;
281 
282   // Bankroll & token addresses
283   address private ZTHTKNADDR;
284   address private ZTHBANKROLL;
285 
286   // ---------------------- Functions 
287 
288   // Constructor; must supply bankroll address
289   constructor(address BankrollAddress) 
290     public 
291   {
292     // Set up the bankroll interface
293     setupBankrollInterface(BankrollAddress); 
294 
295     // Owner is deployer
296     owner = msg.sender;
297 
298     // Default max profit to 5% of contract balance
299     ownerSetMaxProfitAsPercentOfHouse(500000);
300 
301     // Set starting variables
302     bankroll      = ZTHBANKROLL;
303     //gameActive  = true;
304 
305     // Init min bet (1 ZTH)
306     ownerSetMinBet(1e18);
307     
308     canMining = false;
309     miningProfit = 100;
310     minBetMining = 1e18;
311   }
312 
313   // Zethr dividends gained are accumulated and sent to bankroll manually
314   function() public payable {  }
315 
316   // If the contract receives tokens, bundle them up in a struct and fire them over to _spinTokens for validation.
317   struct TKN { address sender; uint value; }
318   function execute(address _from, uint _value, uint divRate, bytes _data) 
319     public 
320     fromBankroll gameIsActive
321     returns (bool)
322   {
323       TKN memory _tkn;
324       _tkn.sender = _from;
325       _tkn.value = _value;
326       _spinTokens(_tkn, divRate, uint8(_data[0]));
327       return true;
328   }
329 
330   struct playerSpin {
331     uint192 tokenValue; // Token value in uint
332     uint48 blockn;      // Block number 48 bits
333     uint8 tier;
334     uint8 spins;
335     uint divRate;
336   }
337 
338   // Mapping because a player can do one spin at a time
339   mapping(address => playerSpin) public playerSpins;
340 
341   // Execute spin.
342   function _spinTokens(TKN _tkn, uint divRate, uint8 spins) 
343     private gameIsActive
344     betIsValid(_tkn.value, divRate, spins)
345   {
346     //require(gameActive);
347     require(block.number <= ((2 ** 48) - 1));  // Current block number smaller than storage of 1 uint56
348     require(_tkn.value <= ((2 ** 192) - 1));
349     require(divRate < (2 ** 8 - 1)); // This should never throw 
350     address _customerAddress = _tkn.sender;
351     uint    _wagered         = _tkn.value;
352 
353     playerSpin memory spin = playerSpins[_tkn.sender];
354  
355     // We update the contract balance *before* the spin is over, not after
356     // This means that we don't have to worry about unresolved rolls never resolving
357     // (we also update it when a player wins)
358     addContractBalance(divRate, _wagered);
359 
360     // Cannot spin twice in one block
361     require(block.number != spin.blockn);
362 
363     // If there exists a spin, finish it
364     if (spin.blockn != 0) {
365       _finishSpin(_tkn.sender);
366     }
367 
368     // Set struct block number and token value
369     spin.blockn = uint48(block.number);
370     spin.tokenValue = uint192(_wagered.div(spins));
371     spin.tier = uint8(ZethrTierLibrary.getTier(divRate));
372     spin.divRate = divRate;
373     spin.spins = spins;
374 
375     // Store the roll struct - 40k gas.
376     playerSpins[_tkn.sender] = spin;
377 
378     // Increment total number of spins
379     totalSpins += spins;
380 
381     // Total wagered
382     totalZTHWagered += _wagered;
383 
384     // game mining
385     if(canMining && spin.tokenValue >= minBetMining){
386         uint miningAmout = SafeMath.div(SafeMath.mul(_wagered, miningProfit) , 10000);
387         RequestBankrollPayment(_tkn.sender, miningAmout, spin.divRate);
388     }
389 
390     emit TokensWagered(_customerAddress, _wagered);
391   }
392 
393   // Finish the current spin of a player, if they have one
394   function finishSpin() 
395     public
396     gameIsActive
397     returns (uint[])
398   {
399     return _finishSpin(msg.sender);
400   }
401 
402   // Stores the data for the roll (spin)
403   struct rollData {
404     uint win;
405     uint loss; 
406     uint jp;
407   }
408 
409   // Pay winners, update contract balance, send rewards where applicable.
410   function _finishSpin(address target)
411     private 
412     returns (uint[])
413   {
414     playerSpin memory spin = playerSpins[target];
415 
416     require(spin.tokenValue > 0); // No re-entrancy
417     require(spin.blockn != block.number);
418         
419     uint[] memory output = new uint[](spin.spins);
420     rollData memory outcomeTrack = rollData(0,0,0);
421     uint category = 0;
422     uint profit;
423     uint playerDivrate = spin.divRate;
424         
425     for(uint i=0; i<spin.spins; i++) {
426         
427       // If the block is more than 255 blocks old, we can't get the result
428       // Also, if the result has already happened, fail as well
429       uint result;
430       if (block.number - spin.blockn > 255) {
431         result = 1000000; // Can't win: default to largest number
432         output[i] = 1000000;
433       } else {
434         // Generate a result - random based ONLY on a past block (future when submitted).
435         // Case statement barrier numbers defined by the current payment schema at the top of the contract.
436         result = random(1000000, spin.blockn, target, i) + 1;
437         output[i] = result;
438       }
439 
440       if (result > 506856) {
441         // Player has lost. Womp womp.
442 
443         // Add one percent of player loss to the jackpot
444         // (do this by requesting a payout to the jackpot)
445         outcomeTrack.loss += spin.tokenValue/100;
446 
447         emit Loss(target, spin.blockn);
448         emit LogResult(target, result, profit, spin.tokenValue, category, false);
449       } else if (result < 2) {
450         // Player has won the three-moon mega jackpot!
451       
452         // Get profit amount via jackpot
453         profit = ZlotsJackpotHoldingContract(zlotsJackpot).getJackpot();
454         category = 1;
455     
456         // Emit events
457         emit ThreeMoonJackpot(target, spin.blockn);
458         emit LogResult(target, result, profit, spin.tokenValue, category, true);
459 
460         outcomeTrack.jp += 1;
461 
462       } else {
463         if (result < 299) {
464           // Player has won a two-moon prize!
465           profit = SafeMath.mul(spin.tokenValue, 50);
466           category = 2;
467           emit TwoMoonPrize(target, spin.blockn);
468         } else if (result < 3128) {
469           // Player has won the Z T H prize!
470           profit = SafeMath.mul(spin.tokenValue, 20);
471           category = 3;
472           emit ZTHPrize(target, spin.blockn);
473         } else if (result < 16961) {
474           // Player has won a three Z symbol prize!
475           profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 30), 10);
476           category = 4;
477           emit ThreeZSymbols(target, spin.blockn);
478         } else if (result < 30794) {
479           // Player has won a three T symbol prize!
480           profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 30), 10);
481           category = 5;
482           emit ThreeTSymbols(target, spin.blockn);
483         } else if (result < 44627) {
484           // Player has won a three H symbol prize!
485           profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 30), 10);
486           category = 6;
487           emit ThreeHSymbols(target, spin.blockn);
488         } else if (result < 46627) {
489           // Player has won a three Ether icon prize!
490           profit = SafeMath.mul(spin.tokenValue, 11);
491           category = 7;
492           emit ThreeEtherIcons(target, spin.blockn);
493         } else if (result < 49127) {
494           // Player has won a three purple pyramid prize!
495           profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 75), 10);
496           category = 8;
497           emit ThreePurplePyramids(target, spin.blockn);
498         } else if (result < 51627) {
499           // Player has won a three gold pyramid prize!
500           profit = SafeMath.mul(spin.tokenValue, 9);
501           category = 9;
502           emit ThreeGoldPyramids(target, spin.blockn);
503         } else if (result < 53127) {
504           // Player has won a three rocket prize!
505           profit = SafeMath.mul(spin.tokenValue, 13);
506           category = 10;
507           emit ThreeRockets(target, spin.blockn);
508         } else if (result < 82530) {
509           // Player has won a one moon prize!
510           profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 25),10);
511           category = 11;
512           emit OneMoonPrize(target, spin.blockn);
513         } else if (result < 150423) {
514           // Player has won a each-coloured-pyramid prize!
515           profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 15),10);
516           category = 12;
517           emit OneOfEachPyramidPrize(target, spin.blockn);
518         } else if (result < 203888) {
519           // Player has won a two Z symbol prize!
520           profit = spin.tokenValue;
521           category = 13;
522           emit TwoZSymbols(target, spin.blockn);
523         } else if (result < 257353) {
524           // Player has won a two T symbol prize!
525           profit = spin.tokenValue;
526           category = 14;
527           emit TwoTSymbols(target, spin.blockn);
528         } else if (result < 310818) {
529           // Player has won a two H symbol prize!
530           profit = spin.tokenValue;
531           category = 15;
532           emit TwoHSymbols(target, spin.blockn);
533         } else if (result < 364283) {
534           // Player has won a two Ether icon prize!
535           profit = SafeMath.mul(spin.tokenValue, 2);
536           category = 16;
537           emit TwoEtherIcons(target, spin.blockn);
538         } else if (result < 417748) {
539           // Player has won a two purple pyramid prize!
540           profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 125), 100);
541           category = 17;
542           emit TwoPurplePyramids(target, spin.blockn);
543         } else if (result < 471213) {
544           // Player has won a two gold pyramid prize!
545           profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 133), 100);
546           category = 18;
547           emit TwoGoldPyramids(target, spin.blockn);
548         } else {
549           // Player has won a two rocket prize!
550           profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 25), 10);
551           category = 19;
552           emit TwoRockets(target, spin.blockn);
553         }
554 
555         uint newMaxProfit = getNewMaxProfit(playerDivrate, outcomeTrack.win);
556         if (profit > newMaxProfit){
557           profit = newMaxProfit;
558         }
559 
560         emit LogResult(target, result, profit, spin.tokenValue, category, true);
561         outcomeTrack.win += profit;
562       }
563     }
564 
565     playerSpins[target] = playerSpin(uint192(0), uint48(0), uint8(0), uint8(0),  uint(0));
566     if (outcomeTrack.jp > 0) {
567       for (i = 0; i < outcomeTrack.jp; i++) {
568         // In the weird case a player wins two jackpots, we of course pay them twice 
569         ZlotsJackpotHoldingContract(zlotsJackpot).payOutWinner(target);
570       }
571     }
572 
573     if (outcomeTrack.win > 0) {
574       RequestBankrollPayment(target, outcomeTrack.win, spin.tier);
575     }
576 
577     if (outcomeTrack.loss > 0) {
578       // This loss is the loss to pay to the jackpot account 
579       // The delta in contractBalance is already updated in a pending bet.
580       RequestBankrollPayment(zlotsJackpot, outcomeTrack.loss, spin.tier);
581     }
582             
583     emit SpinConcluded(target, spin.blockn);
584     return output;
585   }   
586 
587   // Returns a random number using a specified block number
588   // Always use a FUTURE block number.
589   function maxRandom(uint blockn, address entropy, uint index) 
590     private 
591     view
592     returns (uint256 randomNumber) 
593   {
594     return uint256(keccak256(
595         abi.encodePacked(
596           blockhash(blockn),
597           entropy,
598           index
599     )));
600   }
601 
602   // Random helper
603   function random(uint256 upper, uint256 blockn, address entropy, uint index)
604     internal 
605     view 
606     returns (uint256 randomNumber)
607   {
608     return maxRandom(blockn, entropy, index) % upper;
609   }
610 
611   // Sets max profit (internal)
612   function setMaxProfit(uint divRate) 
613     internal 
614   {
615     maxProfit[divRate] = (contractBalance[divRate] * maxProfitAsPercentOfHouse) / maxProfitDivisor; 
616   } 
617 
618   // Gets max profit  
619   function getMaxProfit(uint divRate) 
620     public 
621     view 
622     returns (uint) 
623   {
624     return (contractBalance[divRate] * maxProfitAsPercentOfHouse) / maxProfitDivisor;
625   }
626 
627   function getNewMaxProfit(uint divRate, uint currentWin) 
628     public 
629     view 
630     returns (uint) 
631   {
632     return ((contractBalance[divRate] - currentWin) * maxProfitAsPercentOfHouse) / maxProfitDivisor;
633   }
634 
635   // Subtracts from the contract balance tracking var
636   function subContractBalance(uint divRate, uint sub) 
637     internal 
638   {
639     contractBalance[divRate] = contractBalance[divRate].sub(sub);
640   }
641 
642   // Adds to the contract balance tracking var
643   function addContractBalance(uint divRate, uint add) 
644     internal 
645   {
646     contractBalance[divRate] = contractBalance[divRate].add(add);
647   }
648   // Only owner adjust contract balance variable (only used for max profit calc)
649   function ownerUpdateContractBalance(uint newContractBalance, uint divRate) public
650   onlyOwner
651   {
652     contractBalance[divRate] = newContractBalance;
653   }
654   
655   function updateContractBalance(uint newContractBalance) public
656   onlyOwner
657   {
658     contractBalance[2] = newContractBalance;
659     setMaxProfit(2);
660     contractBalance[5] = newContractBalance;
661     setMaxProfit(5);
662     contractBalance[10] = newContractBalance;
663     setMaxProfit(10);
664     contractBalance[15] = newContractBalance;
665     setMaxProfit(15);
666     contractBalance[20] = newContractBalance;
667     setMaxProfit(20);
668     contractBalance[25] = newContractBalance;
669     setMaxProfit(25);
670     contractBalance[33] = newContractBalance;
671     setMaxProfit(33);
672   }  
673   // An EXTERNAL update of tokens should be handled here
674   // This is due to token allocation
675   // The game should handle internal updates itself (e.g. tokens are betted)
676   function bankrollExternalUpdateTokens(uint divRate, uint newBalance) 
677     public 
678     fromBankroll 
679   {
680     contractBalance[divRate] = newBalance;
681     setMaxProfit(divRate);
682   }
683 
684   // Set the new max profit as percent of house - can be as high as 20%
685   // (1,000,000 = 100%)
686   function ownerSetMaxProfitAsPercentOfHouse(uint newMaxProfitAsPercent) 
687     public
688     onlyOwner
689   {
690     // Restricts each bet to a maximum profit of 50% contractBalance
691     require(newMaxProfitAsPercent <= 500000);
692     maxProfitAsPercentOfHouse = newMaxProfitAsPercent;
693     setMaxProfit(2);
694     setMaxProfit(5);
695     setMaxProfit(10);
696     setMaxProfit(15); 
697     setMaxProfit(20);
698     setMaxProfit(25);
699     setMaxProfit(33);
700   }
701 
702   // Only owner can set minBet
703   function ownerSetupBankrollInterface(address ZethrMainBankrollAddress) public
704   onlyOwner
705   {
706     setupBankrollInterface(ZethrMainBankrollAddress);
707   }  
708   function ownerSetMinBet(uint newMinimumBet) 
709     public
710     onlyOwner
711   {
712     minBet = newMinimumBet;
713   }
714   function ownerPauseGame(bool newStatus) public
715   onlyOwner
716   {
717     gamePaused = newStatus;
718   }
719   function ownerSetCanMining(bool newStatus) public
720   onlyOwner
721   {
722     canMining = newStatus;
723   }
724   function ownerSetMiningProfit(uint newProfit) public
725   onlyOwner
726   {
727     miningProfit = newProfit;
728   }
729   function ownerSetMinBetMining(uint newMinBetMining) public
730   onlyOwner
731   {
732     minBetMining = newMinBetMining;
733   }    
734   // Only owner can set zlotsJackpot address
735   function ownerSetZlotsAddress(address zlotsAddress) 
736     public
737     onlyOwner
738   {
739     zlotsJackpot = zlotsAddress;
740   }
741 
742   // If, for any reason, betting needs to be paused (very unlikely), this will freeze all bets.
743   /*function pauseGame() 
744     public 
745     onlyOwnerOrBankroll 
746   {
747     gameActive = false;
748   }
749 
750   // The converse of the above, resuming betting if a freeze had been put in place.
751   function resumeGame() 
752     public 
753     onlyOwnerOrBankroll 
754   {
755     gameActive = true;
756   }*/
757 
758   // Administrative function to change the owner of the contract.
759   function changeOwner(address _newOwner) 
760     public 
761     onlyOwnerOrBankroll 
762   {
763     owner = _newOwner;
764   }
765 
766   // Administrative function to change the Zethr bankroll contract, should the need arise.
767   function changeBankroll(address _newBankroll) 
768     public 
769     onlyOwnerOrBankroll 
770   {
771     bankroll = _newBankroll;
772   }
773 
774   // Is the address that the token has come from actually ZTH?
775   function _zthToken(address _tokenContract) 
776     private 
777     view 
778     returns (bool) 
779   {
780     return _tokenContract == ZTHTKNADDR;
781   }
782 }
783 
784 /**
785  * @title SafeMath
786  * @dev Math operations with safety checks that throw on error
787  */
788 library SafeMath {
789 
790   /**
791   * @dev Multiplies two numbers, throws on overflow.
792   */
793   function mul(uint a, uint b) 
794     internal 
795     pure 
796     returns (uint) 
797   {
798     if (a == 0) {
799       return 0;
800     }
801     uint c = a * b;
802     assert(c / a == b);
803     return c;
804   }
805 
806   /**
807   * @dev Integer division of two numbers, truncating the quotient.
808   */
809   function div(uint a, uint b) 
810     internal 
811     pure 
812     returns (uint) 
813   {
814     uint c = a / b;
815     return c;
816   }
817 
818   /**
819   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
820   */
821   function sub(uint a, uint b) 
822     internal 
823     pure 
824     returns (uint) 
825   {
826     assert(b <= a);
827     return a - b;
828   }
829 
830   /**
831   * @dev Adds two numbers, throws on overflow.
832   */
833   function add(uint a, uint b) 
834     internal 
835     pure returns (uint) 
836   {
837     uint c = a + b;
838     assert(c >= a);
839     return c;
840   }
841 }