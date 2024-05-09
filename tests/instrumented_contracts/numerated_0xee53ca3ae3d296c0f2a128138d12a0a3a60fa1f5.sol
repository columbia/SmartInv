1 pragma solidity ^0.4.24;
2 
3 /*
4 * ZETHR PRESENTS: SLOTS
5 *
6 * Written August 2018 by the Zethr team for zethr.io.
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
122     Zethr = ZethrInterface(0xD48B633045af65fF636F3c6edd744748351E020D);
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
148     constant 
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
270   bool gamePaused;
271 
272   // Trackers
273   uint  public totalSpins;
274   uint  public totalZTHWagered;
275   mapping (uint => uint) public contractBalance;
276     
277   // Is betting allowed? (Administrative function, in the event of unforeseen bugs)
278   bool public gameActive;
279 
280   // Bankroll & token addresses
281   address private ZTHTKNADDR;
282   address private ZTHBANKROLL;
283 
284   // ---------------------- Functions 
285 
286   // Constructor; must supply bankroll address
287   constructor(address BankrollAddress) 
288     public 
289   {
290     // Set up the bankroll interface
291     setupBankrollInterface(BankrollAddress); 
292 
293     // Owner is deployer
294     owner = msg.sender;
295 
296     // Default max profit to 5% of contract balance
297     ownerSetMaxProfitAsPercentOfHouse(50000);
298 
299     // Set starting variables
300     bankroll      = ZTHBANKROLL;
301     gameActive  = true;
302 
303     // Init min bet (1 ZTH)
304     ownerSetMinBet(1e18);
305   }
306 
307   // Zethr dividends gained are accumulated and sent to bankroll manually
308   function() public payable {  }
309 
310   // If the contract receives tokens, bundle them up in a struct and fire them over to _spinTokens for validation.
311   struct TKN { address sender; uint value; }
312   function execute(address _from, uint _value, uint divRate, bytes _data) 
313     public 
314     fromBankroll 
315     returns (bool)
316   {
317       TKN memory _tkn;
318       _tkn.sender = _from;
319       _tkn.value = _value;
320       _spinTokens(_tkn, divRate, uint8(_data[0]));
321       return true;
322   }
323 
324   struct playerSpin {
325     uint192 tokenValue; // Token value in uint
326     uint48 blockn;      // Block number 48 bits
327     uint8 tier;
328     uint8 spins;
329     uint divRate;
330   }
331 
332   // Mapping because a player can do one spin at a time
333   mapping(address => playerSpin) public playerSpins;
334 
335   // Execute spin.
336   function _spinTokens(TKN _tkn, uint divRate, uint8 spins) 
337     private 
338     betIsValid(_tkn.value, divRate, spins)
339   {
340     require(gameActive);
341     require(block.number <= ((2 ** 48) - 1));  // Current block number smaller than storage of 1 uint56
342     require(_tkn.value <= ((2 ** 192) - 1));
343     address _customerAddress = _tkn.sender;
344     uint    _wagered         = _tkn.value;
345 
346     playerSpin memory spin = playerSpins[_tkn.sender];
347  
348     // We update the contract balance *before* the spin is over, not after
349     // This means that we don't have to worry about unresolved rolls never resolving
350     // (we also update it when a player wins)
351     addContractBalance(divRate, _wagered);
352 
353     // Cannot spin twice in one block
354     require(block.number != spin.blockn);
355 
356     // If there exists a spin, finish it
357     if (spin.blockn != 0) {
358       _finishSpin(_tkn.sender);
359     }
360 
361     // Set struct block number and token value
362     spin.blockn = uint48(block.number);
363     spin.tokenValue = uint192(_wagered.div(spins));
364     spin.tier = uint8(ZethrTierLibrary.getTier(divRate));
365     spin.divRate = divRate;
366     spin.spins = spins;
367 
368     // Store the roll struct - 40k gas.
369     playerSpins[_tkn.sender] = spin;
370 
371     // Increment total number of spins
372     totalSpins += spins;
373 
374     // Total wagered
375     totalZTHWagered += _wagered;
376 
377     emit TokensWagered(_customerAddress, _wagered);
378   }
379 
380   // Finish the current spin of a player, if they have one
381   function finishSpin() 
382     public
383     gameIsActive
384     returns (uint[])
385   {
386     return _finishSpin(msg.sender);
387   }
388 
389   // Stores the data for the roll (spin)
390   struct rollData {
391     uint win;
392     uint loss; 
393     uint jp;
394   }
395 
396   // Pay winners, update contract balance, send rewards where applicable.
397   function _finishSpin(address target)
398     private 
399     returns (uint[])
400   {
401     playerSpin memory spin = playerSpins[target];
402 
403     require(spin.tokenValue > 0); // No re-entrancy
404     require(spin.blockn != block.number);
405         
406     uint[] memory output = new uint[](spin.spins);
407     rollData memory outcomeTrack = rollData(0,0,0);
408     uint category = 0;
409     uint profit;
410     uint playerDivrate = spin.divRate;
411         
412     for(uint i=0; i<spin.spins; i++) {
413         
414       // If the block is more than 255 blocks old, we can't get the result
415       // Also, if the result has already happened, fail as well
416       uint result;
417       if (block.number - spin.blockn > 255) {
418         result = 1000000; // Can't win: default to largest number
419         output[i] = 1000000;
420       } else {
421         // Generate a result - random based ONLY on a past block (future when submitted).
422         // Case statement barrier numbers defined by the current payment schema at the top of the contract.
423         result = random(1000000, spin.blockn, target, i) + 1;
424         output[i] = result;
425       }
426 
427       if (result > 506856) {
428         // Player has lost. Womp womp.
429 
430         // Add one percent of player loss to the jackpot
431         // (do this by requesting a payout to the jackpot)
432         outcomeTrack.loss += spin.tokenValue/100;
433 
434         emit Loss(target, spin.blockn);
435         emit LogResult(target, result, profit, spin.tokenValue, category, false);
436       } else if (result < 2) {
437         // Player has won the three-moon mega jackpot!
438       
439         // Get profit amount via jackpot
440         profit = ZlotsJackpotHoldingContract(zlotsJackpot).getJackpot();
441         category = 1;
442     
443         // Emit events
444         emit ThreeMoonJackpot(target, spin.blockn);
445         emit LogResult(target, result, profit, spin.tokenValue, category, true);
446 
447         outcomeTrack.jp += 1;
448 
449       } else {
450         if (result < 299) {
451           // Player has won a two-moon prize!
452           profit = SafeMath.mul(spin.tokenValue, 50);
453           category = 2;
454           emit TwoMoonPrize(target, spin.blockn);
455         } else if (result < 3128) {
456           // Player has won the Z T H prize!
457           profit = SafeMath.mul(spin.tokenValue, 20);
458           category = 3;
459           emit ZTHPrize(target, spin.blockn);
460         } else if (result < 16961) {
461           // Player has won a three Z symbol prize!
462           profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 30), 10);
463           category = 4;
464           emit ThreeZSymbols(target, spin.blockn);
465         } else if (result < 30794) {
466           // Player has won a three T symbol prize!
467           profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 30), 10);
468           category = 5;
469           emit ThreeTSymbols(target, spin.blockn);
470         } else if (result < 44627) {
471           // Player has won a three H symbol prize!
472           profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 30), 10);
473           category = 6;
474           emit ThreeHSymbols(target, spin.blockn);
475         } else if (result < 46627) {
476           // Player has won a three Ether icon prize!
477           profit = SafeMath.mul(spin.tokenValue, 11);
478           category = 7;
479           emit ThreeEtherIcons(target, spin.blockn);
480         } else if (result < 49127) {
481           // Player has won a three purple pyramid prize!
482           profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 75), 10);
483           category = 8;
484           emit ThreePurplePyramids(target, spin.blockn);
485         } else if (result < 51627) {
486           // Player has won a three gold pyramid prize!
487           profit = SafeMath.mul(spin.tokenValue, 9);
488           category = 9;
489           emit ThreeGoldPyramids(target, spin.blockn);
490         } else if (result < 53127) {
491           // Player has won a three rocket prize!
492           profit = SafeMath.mul(spin.tokenValue, 13);
493           category = 10;
494           emit ThreeRockets(target, spin.blockn);
495         } else if (result < 82530) {
496           // Player has won a one moon prize!
497           profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 25),10);
498           category = 11;
499           emit OneMoonPrize(target, spin.blockn);
500         } else if (result < 150423) {
501           // Player has won a each-coloured-pyramid prize!
502           profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 15),10);
503           category = 12;
504           emit OneOfEachPyramidPrize(target, spin.blockn);
505         } else if (result < 203888) {
506           // Player has won a two Z symbol prize!
507           profit = spin.tokenValue;
508           category = 13;
509           emit TwoZSymbols(target, spin.blockn);
510         } else if (result < 257353) {
511           // Player has won a two T symbol prize!
512           profit = spin.tokenValue;
513           category = 14;
514           emit TwoTSymbols(target, spin.blockn);
515         } else if (result < 310818) {
516           // Player has won a two H symbol prize!
517           profit = spin.tokenValue;
518           category = 15;
519           emit TwoHSymbols(target, spin.blockn);
520         } else if (result < 364283) {
521           // Player has won a two Ether icon prize!
522           profit = SafeMath.mul(spin.tokenValue, 2);
523           category = 16;
524           emit TwoEtherIcons(target, spin.blockn);
525         } else if (result < 417748) {
526           // Player has won a two purple pyramid prize!
527           profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 125), 100);
528           category = 17;
529           emit TwoPurplePyramids(target, spin.blockn);
530         } else if (result < 471213) {
531           // Player has won a two gold pyramid prize!
532           profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 133), 100);
533           category = 18;
534           emit TwoGoldPyramids(target, spin.blockn);
535         } else {
536           // Player has won a two rocket prize!
537           profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 25), 10);
538           category = 19;
539           emit TwoRockets(target, spin.blockn);
540         }
541 
542         uint newMaxProfit = getNewMaxProfit(playerDivrate, outcomeTrack.win);
543         if (profit > newMaxProfit){
544           profit = newMaxProfit;
545         }
546 
547         emit LogResult(target, result, profit, spin.tokenValue, category, true);
548         outcomeTrack.win += profit;
549       }
550     }
551 
552     playerSpins[target] = playerSpin(uint192(0), uint48(0), uint8(0), uint8(0),  uint(0));
553     if (outcomeTrack.jp > 0) {
554       for (i = 0; i < outcomeTrack.jp; i++) {
555         // In the weird case a player wins two jackpots, we of course pay them twice 
556         ZlotsJackpotHoldingContract(zlotsJackpot).payOutWinner(target);
557       }
558     }
559 
560     if (outcomeTrack.win > 0) {
561       RequestBankrollPayment(target, outcomeTrack.win, spin.tier);
562     }
563 
564     if (outcomeTrack.loss > 0) {
565       // This loss is the loss to pay to the jackpot account 
566       // The delta in contractBalance is already updated in a pending bet.
567       RequestBankrollPayment(zlotsJackpot, outcomeTrack.loss, spin.tier);
568     }
569             
570     emit SpinConcluded(target, spin.blockn);
571     return output;
572   }   
573 
574   // Returns a random number using a specified block number
575   // Always use a FUTURE block number.
576   function maxRandom(uint blockn, address entropy, uint index) 
577     private 
578     view
579     returns (uint256 randomNumber) 
580   {
581     return uint256(keccak256(
582         abi.encodePacked(
583           blockhash(blockn),
584           entropy,
585           index
586     )));
587   }
588 
589   // Random helper
590   function random(uint256 upper, uint256 blockn, address entropy, uint index)
591     internal 
592     view 
593     returns (uint256 randomNumber)
594   {
595     return maxRandom(blockn, entropy, index) % upper;
596   }
597 
598   // Sets max profit (internal)
599   function setMaxProfit(uint divRate) 
600     internal 
601   {
602     maxProfit[divRate] = (contractBalance[divRate] * maxProfitAsPercentOfHouse) / maxProfitDivisor; 
603   } 
604 
605   // Gets max profit  
606   function getMaxProfit(uint divRate) 
607     public 
608     view 
609     returns (uint) 
610   {
611     return (contractBalance[divRate] * maxProfitAsPercentOfHouse) / maxProfitDivisor;
612   }
613 
614   function getNewMaxProfit(uint divRate, uint currentWin) 
615     public 
616     view 
617     returns (uint) 
618   {
619     return ((contractBalance[divRate] - currentWin) * maxProfitAsPercentOfHouse) / maxProfitDivisor;
620   }
621 
622   // Subtracts from the contract balance tracking var
623   function subContractBalance(uint divRate, uint sub) 
624     internal 
625   {
626     contractBalance[divRate] = contractBalance[divRate].sub(sub);
627   }
628 
629   // Adds to the contract balance tracking var
630   function addContractBalance(uint divRate, uint add) 
631     internal 
632   {
633     contractBalance[divRate] = contractBalance[divRate].add(add);
634   }
635 
636   // An EXTERNAL update of tokens should be handled here
637   // This is due to token allocation
638   // The game should handle internal updates itself (e.g. tokens are betted)
639   function bankrollExternalUpdateTokens(uint divRate, uint newBalance) 
640     public 
641     fromBankroll 
642   {
643     contractBalance[divRate] = newBalance;
644     setMaxProfit(divRate);
645   }
646 
647   // Set the new max profit as percent of house - can be as high as 20%
648   // (1,000,000 = 100%)
649   function ownerSetMaxProfitAsPercentOfHouse(uint newMaxProfitAsPercent) 
650     public
651     onlyOwner
652   {
653     // Restricts each bet to a maximum profit of 50% contractBalance
654     require(newMaxProfitAsPercent <= 500000);
655     maxProfitAsPercentOfHouse = newMaxProfitAsPercent;
656     setMaxProfit(2);
657     setMaxProfit(5);
658     setMaxProfit(10);
659     setMaxProfit(15); 
660     setMaxProfit(20);
661     setMaxProfit(25);
662     setMaxProfit(33);
663   }
664 
665   // Only owner can set minBet   
666   function ownerSetMinBet(uint newMinimumBet) 
667     public
668     onlyOwner
669   {
670     minBet = newMinimumBet;
671   }
672 
673   // Only owner can set zlotsJackpot address
674   function ownerSetZlotsAddress(address zlotsAddress) 
675     public
676     onlyOwner
677   {
678     zlotsJackpot = zlotsAddress;
679   }
680 
681   // If, for any reason, betting needs to be paused (very unlikely), this will freeze all bets.
682   function pauseGame() 
683     public 
684     onlyOwnerOrBankroll 
685   {
686     gameActive = false;
687   }
688 
689   // The converse of the above, resuming betting if a freeze had been put in place.
690   function resumeGame() 
691     public 
692     onlyOwnerOrBankroll 
693   {
694     gameActive = true;
695   }
696 
697   // Administrative function to change the owner of the contract.
698   function changeOwner(address _newOwner) 
699     public 
700     onlyOwnerOrBankroll 
701   {
702     owner = _newOwner;
703   }
704 
705   // Administrative function to change the Zethr bankroll contract, should the need arise.
706   function changeBankroll(address _newBankroll) 
707     public 
708     onlyOwnerOrBankroll 
709   {
710     bankroll = _newBankroll;
711   }
712 
713   // Is the address that the token has come from actually ZTH?
714   function _zthToken(address _tokenContract) 
715     private 
716     view 
717     returns (bool) 
718   {
719     return _tokenContract == ZTHTKNADDR;
720   }
721 }
722 
723 /**
724  * @title SafeMath
725  * @dev Math operations with safety checks that throw on error
726  */
727 library SafeMath {
728 
729   /**
730   * @dev Multiplies two numbers, throws on overflow.
731   */
732   function mul(uint a, uint b) 
733     internal 
734     pure 
735     returns (uint) 
736   {
737     if (a == 0) {
738       return 0;
739     }
740     uint c = a * b;
741     assert(c / a == b);
742     return c;
743   }
744 
745   /**
746   * @dev Integer division of two numbers, truncating the quotient.
747   */
748   function div(uint a, uint b) 
749     internal 
750     pure 
751     returns (uint) 
752   {
753     uint c = a / b;
754     return c;
755   }
756 
757   /**
758   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
759   */
760   function sub(uint a, uint b) 
761     internal 
762     pure 
763     returns (uint) 
764   {
765     assert(b <= a);
766     return a - b;
767   }
768 
769   /**
770   * @dev Adds two numbers, throws on overflow.
771   */
772   function add(uint a, uint b) 
773     internal 
774     pure returns (uint) 
775   {
776     uint c = a + b;
777     assert(c >= a);
778     return c;
779   }
780 }