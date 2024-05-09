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
11 *
12 * Rolling Odds:
13 *   49.31%  Lose    
14 *   35.64%  Two Matching Icons
15 *       - 10.00% : 2x    Multiplier [Two Rockets]
16 *       - 15.00% : 1.33x Multiplier [Two Gold  Pyramids]
17 *       - 15.00% : 1x    Multiplier [Two 'Z' Symbols]
18 *       - 15.00% : 1x    Multiplier [Two 'T' Symbols]
19 *       - 15.00% : 1x    Multiplier [Two 'H' Symbols]
20 *       - 15.00% : 1.33x Multiplier [Two Purple Pyramids]
21 *       - 15.00% : 2x    Multiplier [Two Ether Icons]
22 *   6.79%   One Of Each Pyramid
23 *       - 1.5x  Multiplier
24 *   2.94%   One Moon Icon
25 *       - 2.5x Multiplier
26 *   5.00%   Three Matching Icons
27 *       - 03.00% : 12x   Multiplier [Three Rockets]
28 *       - 05.00% : 10x   Multiplier [Three Gold  Pyramids]
29 *       - 27.67% : 7.5x Multiplier [Three 'Z' Symbols]
30 *       - 27.67% : 7.5x Multiplier [Three 'T' Symbols]
31 *       - 27.67% : 7.5x Multiplier [Three 'H' Symbols]
32 *       - 05.00% : 10x    Multiplier [Three Purple Pyramids]
33 *       - 04.00% : 15x    Multiplier [Three Ether Icons]
34 *   0.28%   Z T H Prize
35 *       - 20x Multiplier
36 *   0.03%   Two Moon Icons
37 *       - 50x  Multiplier
38 *   0.0001% Three Moon Grand Jackpot
39 *       - Jackpot Amount (variable)
40 *
41 *   Note: this contract is currently in beta. It is a one-payline, one-transaction-per-spin contract.
42 *         These will be expanded on in later versions of the contract.
43 *   From all of us at Zethr, thank you for playing!    
44 *
45 */
46 
47 // Zethr Token Bankroll interface
48 contract ZethrTokenBankroll{
49     // Game request token transfer to player 
50     function gameRequestTokens(address target, uint tokens) public;
51     function gameTokenAmount(address what) public returns (uint);
52 }
53 
54 // Zether Main Bankroll interface
55 contract ZethrMainBankroll{
56     function gameGetTokenBankrollList() public view returns (address[7]);
57 }
58 
59 // Zethr main contract interface
60 contract ZethrInterface{
61     function withdraw() public;
62 }
63 
64 // Library for figuring out the "tier" (1-7) of a dividend rate
65 library ZethrTierLibrary{
66 
67     function getTier(uint divRate) internal pure returns (uint){
68         // Tier logic 
69         // Returns the index of the UsedBankrollAddresses which should be used to call into to withdraw tokens 
70         
71         // We can divide by magnitude
72         // Remainder is removed so we only get the actual number we want
73         uint actualDiv = divRate; 
74         if (actualDiv >= 30){
75             return 6;
76         } else if (actualDiv >= 25){
77             return 5;
78         } else if (actualDiv >= 20){
79             return 4;
80         } else if (actualDiv >= 15){
81             return 3;
82         } else if (actualDiv >= 10){
83             return 2; 
84         } else if (actualDiv >= 5){
85             return 1;
86         } else if (actualDiv >= 2){
87             return 0;
88         } else{
89             // Impossible
90             revert(); 
91         }
92     }
93 }
94 
95 // Contract that contains the functions to interact with the ZlotsJackpotHoldingContract
96 contract ZlotsJackpotHoldingContract {
97   function payOutWinner(address winner) public; 
98   function getJackpot() public view returns (uint);
99 }
100  
101 // Contract that contains the functions to interact with the bankroll system
102 contract ZethrBankrollBridge {
103     // Must have an interface with the main Zethr token contract 
104     ZethrInterface Zethr;
105    
106     // Store the bankroll addresses 
107     // address[0] is main bankroll 
108     // address[1] is tier1: 2-5% 
109     // address[2] is tier2: 5-10, etc
110     address[7] UsedBankrollAddresses; 
111 
112     // Mapping for easy checking
113     mapping(address => bool) ValidBankrollAddress;
114     
115     // Set up the tokenbankroll stuff 
116     function setupBankrollInterface(address ZethrMainBankrollAddress) internal {
117 
118         // Instantiate Zethr
119         Zethr = ZethrInterface(0xD48B633045af65fF636F3c6edd744748351E020D);
120 
121         // Get the bankroll addresses from the main bankroll
122         UsedBankrollAddresses = ZethrMainBankroll(ZethrMainBankrollAddress).gameGetTokenBankrollList();
123         for(uint i=0; i<7; i++){
124             ValidBankrollAddress[UsedBankrollAddresses[i]] = true;
125         }
126     }
127     
128     // Require a function to be called from a *token* bankroll 
129     modifier fromBankroll(){
130         require(ValidBankrollAddress[msg.sender], "msg.sender should be a valid bankroll");
131         _;
132     }
133     
134     // Request a payment in tokens to a user FROM the appropriate tokenBankroll 
135     // Figure out the right bankroll via divRate 
136     function RequestBankrollPayment(address to, uint tokens, uint tier) internal {
137         address tokenBankrollAddress = UsedBankrollAddresses[tier];
138         ZethrTokenBankroll(tokenBankrollAddress).gameRequestTokens(to, tokens);
139     }
140     
141     function getZethrTokenBankroll(uint divRate) public constant returns (ZethrTokenBankroll){
142         return ZethrTokenBankroll(UsedBankrollAddresses[ZethrTierLibrary.getTier(divRate)]);
143     }
144 }
145 
146 // Contract that contains functions to move divs to the main bankroll
147 contract ZethrShell is ZethrBankrollBridge {
148 
149     // Dump ETH balance to main bankroll
150     function WithdrawToBankroll() public {
151         address(UsedBankrollAddresses[0]).transfer(address(this).balance);
152     }
153 
154     // Dump divs and dump ETH into bankroll
155     function WithdrawAndTransferToBankroll() public {
156         Zethr.withdraw();
157         WithdrawToBankroll();
158     }
159 }
160 
161 // Zethr game data setup
162 // Includes all necessary to run with Zethr
163 contract Zlots is ZethrShell {
164     using SafeMath for uint;
165 
166     // ---------------------- Events
167 
168     // Might as well notify everyone when the house takes its cut out.
169     event HouseRetrievedTake(
170         uint timeTaken,
171         uint tokensWithdrawn
172     );
173 
174     // Fire an event whenever someone places a bet.
175     event TokensWagered(
176         address _wagerer,
177         uint _wagered
178     );
179 
180     event LogResult(
181         address _wagerer,
182         uint _result,
183         uint _profit,
184         uint _wagered,
185         uint _category,
186         bool _win
187     );
188 
189     // Result announcement events (to dictate UI output!)
190     event Loss(address _wagerer, uint _block);                  // Category 0
191     event ThreeMoonJackpot(address _wagerer, uint _block);      // Category 1
192     event TwoMoonPrize(address _wagerer, uint _block);          // Category 2
193     event ZTHPrize(address _wagerer, uint _block);              // Category 3
194     event ThreeZSymbols(address _wagerer, uint _block);         // Category 4
195     event ThreeTSymbols(address _wagerer, uint _block);         // Category 5
196     event ThreeHSymbols(address _wagerer, uint _block);         // Category 6
197     event ThreeEtherIcons(address _wagerer, uint _block);       // Category 7
198     event ThreePurplePyramids(address _wagerer, uint _block);   // Category 8
199     event ThreeGoldPyramids(address _wagerer, uint _block);     // Category 9
200     event ThreeRockets(address _wagerer, uint _block);          // Category 10
201     event OneMoonPrize(address _wagerer, uint _block);          // Category 11
202     event OneOfEachPyramidPrize(address _wagerer, uint _block); // Category 12
203     event TwoZSymbols(address _wagerer, uint _block);           // Category 13
204     event TwoTSymbols(address _wagerer, uint _block);           // Category 14
205     event TwoHSymbols(address _wagerer, uint _block);           // Category 15
206     event TwoEtherIcons(address _wagerer, uint _block);         // Category 16
207     event TwoPurplePyramids(address _wagerer, uint _block);     // Category 17
208     event TwoGoldPyramids(address _wagerer, uint _block);       // Category 18
209     event TwoRockets(address _wagerer, uint _block);            // Category 19    
210     event SpinConcluded(address _wagerer, uint _block);         // Debug event
211 
212     // ---------------------- Modifiers
213 
214     // Makes sure that player porfit can't exceed a maximum amount
215     // We use the max win here - 100x
216     modifier betIsValid(uint _betSize, uint divRate) {
217       require(_betSize.mul(100) <= getMaxProfit(divRate));
218       _;
219     }
220 
221     // Requires the game to be currently active
222     modifier gameIsActive {
223       require(gamePaused == false);
224       _;
225     }
226 
227     // Require msg.sender to be owner
228     modifier onlyOwner {
229       require(msg.sender == owner); 
230       _;
231     }
232 
233     // Requires msg.sender to be bankroll
234     modifier onlyBankroll {
235       require(msg.sender == bankroll);
236       _;
237     }
238 
239     // Requires msg.sender to be owner or bankroll
240     modifier onlyOwnerOrBankroll {
241       require(msg.sender == owner || msg.sender == bankroll);
242       _;
243     }
244 
245     // ---------------------- Variables
246 
247     // Configurables
248     uint constant public maxProfitDivisor = 1000000;
249     uint constant public houseEdgeDivisor = 1000;
250     mapping (uint => uint) public maxProfit;
251     uint public maxProfitAsPercentOfHouse;
252     uint public minBet = 1e18;
253     address public zlotsJackpot;
254     address private owner;
255     address private bankroll;
256     bool gamePaused;
257 
258     // Trackers
259     uint  public totalSpins;
260     uint  public totalZTHWagered;
261     mapping (uint => uint) public contractBalance;
262     
263     // Is betting allowed? (Administrative function, in the event of unforeseen bugs)
264     bool public gameActive;
265 
266     address private ZTHTKNADDR;
267     address private ZTHBANKROLL;
268 
269     // ---------------------- Functions 
270 
271     // Constructor; must supply bankroll address
272     constructor(address BankrollAddress) public {
273         // Set up the bankroll interface
274         setupBankrollInterface(BankrollAddress); 
275 
276         // Owner is deployer
277         owner = msg.sender;
278 
279         // Default max profit to 5% of contract balance
280         ownerSetMaxProfitAsPercentOfHouse(50000);
281 
282         // Set starting variables
283         bankroll      = ZTHBANKROLL;
284         gameActive  = true;
285 
286         // Init min bet (1 ZTH)
287         ownerSetMinBet(1e18);
288     }
289 
290     // Zethr dividends gained are accumulated and sent to bankroll manually
291     function() public payable {  }
292 
293     // If the contract receives tokens, bundle them up in a struct and fire them over to _spinTokens for validation.
294     struct TKN { address sender; uint value; }
295     function execute(address _from, uint _value, uint divRate, bytes /* _data */) public fromBankroll returns (bool){
296             TKN memory          _tkn;
297             _tkn.sender       = _from;
298             _tkn.value        = _value;
299             _spinTokens(_tkn, divRate);
300             return true;
301     }
302 
303     struct playerSpin {
304         uint200 tokenValue; // Token value in uint
305         uint48 blockn;      // Block number 48 bits
306         uint8 tier;
307         uint divRate;
308     }
309 
310     // Mapping because a player can do one spin at a time
311     mapping(address => playerSpin) public playerSpins;
312 
313     // Execute spin.
314     function _spinTokens(TKN _tkn, uint divRate) 
315       private 
316       betIsValid(_tkn.value, divRate)
317     {
318 
319         require(gameActive);
320         require(block.number < ((2 ** 56) - 1));  // Current block number smaller than storage of 1 uint56
321 
322         address _customerAddress = _tkn.sender;
323         uint    _wagered         = _tkn.value;
324 
325         playerSpin memory spin = playerSpins[_tkn.sender];
326  
327         // We update the contract balance *before* the spin is over, not after
328         // This means that we don't have to worry about unresolved rolls never resolving
329         // (we also update it when a player wins)
330         addContractBalance(divRate, _wagered);
331 
332         // Cannot spin twice in one block
333         require(block.number != spin.blockn);
334 
335         // If there exists a spin, finish it
336         if (spin.blockn != 0) {
337           _finishSpin(_tkn.sender);
338         }
339 
340         // Set struct block number and token value
341         spin.blockn = uint48(block.number);
342         spin.tokenValue = uint200(_wagered);
343         spin.tier = uint8(ZethrTierLibrary.getTier(divRate));
344         spin.divRate = divRate;
345 
346         // Store the roll struct - 20k gas.
347         playerSpins[_tkn.sender] = spin;
348 
349         // Increment total number of spins
350         totalSpins += 1;
351 
352         // Total wagered
353         totalZTHWagered += _wagered;
354 
355         emit TokensWagered(_customerAddress, _wagered);
356     }
357 
358     // Finish the current spin of a player, if they have one
359     function finishSpin() public
360         gameIsActive
361         returns (uint)
362     {
363         return _finishSpin(msg.sender);
364     }
365 
366     // Pay winners, update contract balance, send rewards where applicable.
367     function _finishSpin(address target)
368         private returns (uint)
369     {
370         playerSpin memory spin = playerSpins[target];
371 
372         require(spin.tokenValue > 0); // No re-entrancy
373         require(spin.blockn != block.number);
374 
375         uint profit = 0;
376         uint category = 0;
377         uint playerDivrate = spin.divRate;
378 
379         // If the block is more than 255 blocks old, we can't get the result
380         // Also, if the result has already happened, fail as well
381         uint result;
382         if (block.number - spin.blockn > 255) {
383           result = 1000000; // Can't win: default to largest number
384         } else {
385 
386           // Generate a result - random based ONLY on a past block (future when submitted).
387           // Case statement barrier numbers defined by the current payment schema at the top of the contract.
388           result = random(1000000, spin.blockn, target) + 1;
389         }
390 
391         if (result > 506856) {
392             // Player has lost. Womp womp.
393 
394             // Add one percent of player loss to the jackpot
395             // (do this by requesting a payout to the jackpot)
396             RequestBankrollPayment(zlotsJackpot, spin.tokenValue / 100, tier);
397 
398             // Null out player spin
399             playerSpins[target] = playerSpin(uint200(0), uint48(0), uint8(0), uint(0));
400 
401             emit Loss(target, spin.blockn);
402             emit LogResult(target, result, profit, spin.tokenValue, category, false);
403         } else if (result < 2) {
404             // Player has won the three-moon mega jackpot!
405       
406             // Get profit amount via jackpot
407             profit = ZlotsJackpotHoldingContract(zlotsJackpot).getJackpot();
408             category = 1;
409     
410             // Emit events
411             emit ThreeMoonJackpot(target, spin.blockn);
412             emit LogResult(target, result, profit, spin.tokenValue, category, true);
413 
414             // Grab the tier
415             uint8 tier = spin.tier;
416 
417             // Null out spins
418             playerSpins[target] = playerSpin(uint200(0), uint48(0), uint8(0), uint(0));
419 
420             // Pay out the winner
421             ZlotsJackpotHoldingContract(zlotsJackpot).payOutWinner(target);
422         } else {
423             if (result < 299) {
424                 // Player has won a two-moon prize!
425                 profit = SafeMath.mul(spin.tokenValue, 50);
426                 category = 2;
427                 emit TwoMoonPrize(target, spin.blockn);
428             } else if (result < 3128) {
429                 // Player has won the Z T H prize!
430                 profit = SafeMath.mul(spin.tokenValue, 20);
431                 category = 3;
432                 emit ZTHPrize(target, spin.blockn);
433             } else if (result < 16961) {
434                 // Player has won a three Z symbol prize!
435                 profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 30), 10);
436                 category = 4;
437                 emit ThreeZSymbols(target, spin.blockn);
438             } else if (result < 30794) {
439                 // Player has won a three T symbol prize!
440                 profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 30), 10);
441                 category = 5;
442                 emit ThreeTSymbols(target, spin.blockn);
443             } else if (result < 44627) {
444                 // Player has won a three H symbol prize!
445                 profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 30), 10);
446                 category = 6;
447                 emit ThreeHSymbols(target, spin.blockn);
448             } else if (result < 46627) {
449                 // Player has won a three Ether icon prize!
450                 profit = SafeMath.mul(spin.tokenValue, 11);
451                 category = 7;
452                 emit ThreeEtherIcons(target, spin.blockn);
453             } else if (result < 49127) {
454                 // Player has won a three purple pyramid prize!
455                 profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 75), 10);
456                 category = 8;
457                 emit ThreePurplePyramids(target, spin.blockn);
458             } else if (result < 51627) {
459                 // Player has won a three gold pyramid prize!
460                 profit = SafeMath.mul(spin.tokenValue, 9);
461                 category = 9;
462                 emit ThreeGoldPyramids(target, spin.blockn);
463             } else if (result < 53127) {
464                 // Player has won a three rocket prize!
465                 profit = SafeMath.mul(spin.tokenValue, 13);
466                 category = 10;
467                 emit ThreeRockets(target, spin.blockn);
468             } else if (result < 82530) {
469                 // Player has won a one moon prize!
470                 profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 25),10);
471                 category = 11;
472                 emit OneMoonPrize(target, spin.blockn);
473             } else if (result < 150423) {
474                 // Player has won a each-coloured-pyramid prize!
475                 profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 15),10);
476                 category = 12;
477                 emit OneOfEachPyramidPrize(target, spin.blockn);
478             } else if (result < 203888) {
479                 // Player has won a two Z symbol prize!
480                 profit = spin.tokenValue;
481                 category = 13;
482                  emit TwoZSymbols(target, spin.blockn);
483             } else if (result < 257353) {
484                 // Player has won a two T symbol prize!
485                 profit = spin.tokenValue;
486                 category = 14;
487                 emit TwoTSymbols(target, spin.blockn);
488             } else if (result < 310818) {
489                 // Player has won a two H symbol prize!
490                 profit = spin.tokenValue;
491                 category = 15;
492                 emit TwoHSymbols(target, spin.blockn);
493             } else if (result < 364283) {
494                 // Player has won a two Ether icon prize!
495                 profit = SafeMath.mul(spin.tokenValue, 2);
496                 category = 16;
497                 emit TwoEtherIcons(target, spin.blockn);
498             } else if (result < 417748) {
499                 // Player has won a two purple pyramid prize!
500                 profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 125), 100);
501                 category = 17;
502                 emit TwoPurplePyramids(target, spin.blockn);
503             } else if (result < 471213) {
504                 // Player has won a two gold pyramid prize!
505                 profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 133), 100);
506                 category = 18;
507                 emit TwoGoldPyramids(target, spin.blockn);
508             } else {
509                 // Player has won a two rocket prize!
510                 profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 25), 10);
511                 category = 19;
512                 emit TwoRockets(target, spin.blockn);
513             }
514 
515             // Subtact from contract balance their profit
516             subContractBalance(playerDivrate, profit);
517 
518             emit LogResult(target, result, profit, spin.tokenValue, category, true);
519             tier = spin.tier;
520             playerSpins[target] = playerSpin(uint200(0), uint48(0), uint8(0), uint(0)); // Prevent Re-entrancy
521             RequestBankrollPayment(target, profit, tier);
522           }
523             
524         emit SpinConcluded(target, spin.blockn);
525         return result;
526     }   
527 
528     // Returns a random number using a specified block number
529     // Always use a FUTURE block number.
530     function maxRandom(uint blockn, address entropy) private view returns (uint256 randomNumber) {
531     return uint256(keccak256(
532         abi.encodePacked(
533        // address(this), // adds no entropy 
534         blockhash(blockn),
535         entropy)
536       ));
537     }
538 
539     // Random helper
540     function random(uint256 upper, uint256 blockn, address entropy) internal view returns (uint256 randomNumber) {
541       return maxRandom(blockn, entropy) % upper;
542     }
543 
544     // Sets max profit (internal)
545     function setMaxProfit(uint divRate) internal {
546       maxProfit[divRate] = (contractBalance[divRate] * maxProfitAsPercentOfHouse) / maxProfitDivisor; 
547     } 
548 
549     // Gets max profit  
550     function getMaxProfit(uint divRate) public view returns (uint) {
551       return (contractBalance[divRate] * maxProfitAsPercentOfHouse) / maxProfitDivisor;
552     }
553 
554     // Subtracts from the contract balance tracking var
555     function subContractBalance(uint divRate, uint sub) internal {
556       contractBalance[divRate] = contractBalance[divRate].sub(sub);
557     }
558 
559     // Adds to the contract balance tracking var
560     function addContractBalance(uint divRate, uint add) internal {
561       contractBalance[divRate] = contractBalance[divRate].add(add);
562     }
563 
564     // An EXTERNAL update of tokens should be handled here
565     // This is due to token allocation
566     // The game should handle internal updates itself (e.g. tokens are betted)
567     function bankrollExternalUpdateTokens(uint divRate, uint newBalance) 
568       public 
569       fromBankroll 
570     {
571       contractBalance[divRate] = newBalance;
572       setMaxProfit(divRate);
573     }
574 
575     // Set the new max profit as percent of house - can be as high as 20%
576     // (1,000,000 = 100%)
577     function ownerSetMaxProfitAsPercentOfHouse(uint newMaxProfitAsPercent) public
578     onlyOwner
579     {
580       // Restricts each bet to a maximum profit of 50% contractBalance
581       require(newMaxProfitAsPercent <= 500000);
582       maxProfitAsPercentOfHouse = newMaxProfitAsPercent;
583       setMaxProfit(2);
584       setMaxProfit(5);
585       setMaxProfit(10);
586       setMaxProfit(15); 
587       setMaxProfit(20);
588       setMaxProfit(25);
589       setMaxProfit(33);
590     }
591 
592     // Only owner can set minBet   
593     function ownerSetMinBet(uint newMinimumBet) public
594     onlyOwner
595     {
596       minBet = newMinimumBet;
597     }
598 
599     // Only owner can set zlotsJackpot address
600     function ownerSetZlotsAddress(address zlotsAddress) public
601     onlyOwner
602     {
603         zlotsJackpot = zlotsAddress;
604     }
605 
606     // If, for any reason, betting needs to be paused (very unlikely), this will freeze all bets.
607     function pauseGame() public onlyOwnerOrBankroll {
608         gameActive = false;
609     }
610 
611     // The converse of the above, resuming betting if a freeze had been put in place.
612     function resumeGame() public onlyOwnerOrBankroll {
613         gameActive = true;
614     }
615 
616     // Administrative function to change the owner of the contract.
617     function changeOwner(address _newOwner) public onlyOwnerOrBankroll {
618         owner = _newOwner;
619     }
620 
621     // Administrative function to change the Zethr bankroll contract, should the need arise.
622     function changeBankroll(address _newBankroll) public onlyOwnerOrBankroll {
623         bankroll = _newBankroll;
624     }
625 
626     // Is the address that the token has come from actually ZTH?
627     function _zthToken(address _tokenContract) private view returns (bool) {
628        return _tokenContract == ZTHTKNADDR;
629     }
630 }
631 
632 // And here's the boring bit.
633 
634 /**
635  * @title SafeMath
636  * @dev Math operations with safety checks that throw on error
637  */
638 library SafeMath {
639 
640     /**
641     * @dev Multiplies two numbers, throws on overflow.
642     */
643     function mul(uint a, uint b) internal pure returns (uint) {
644         if (a == 0) {
645             return 0;
646         }
647         uint c = a * b;
648         assert(c / a == b);
649         return c;
650     }
651 
652     /**
653     * @dev Integer division of two numbers, truncating the quotient.
654     */
655     function div(uint a, uint b) internal pure returns (uint) {
656         // assert(b > 0); // Solidity automatically throws when dividing by 0
657         uint c = a / b;
658         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
659         return c;
660     }
661 
662     /**
663     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
664     */
665     function sub(uint a, uint b) internal pure returns (uint) {
666         assert(b <= a);
667         return a - b;
668     }
669 
670     /**
671     * @dev Adds two numbers, throws on overflow.
672     */
673     function add(uint a, uint b) internal pure returns (uint) {
674         uint c = a + b;
675         assert(c >= a);
676         return c;
677     }
678 }