1 pragma solidity ^0.4.24;
2 
3 /*
4 * ZETHR PRESENTS: SLOTS
5 *
6 * Written August 2018 by the Zethr team for zethr.io.
7 *
8 * Code framework written by Norsefire.
9 * EV calculations written by TropicalRogue.
10 *
11 * Rolling Odds:
12 *   52.33%  Lose    
13 *   35.64%  Two Matching Icons
14 *       - 5.09% : 2x    Multiplier [Two Rockets]
15 *       - 5.09% : 1.33x Multiplier [Two Gold  Pyramids]
16 *       - 5.09% : 1x    Multiplier [Two 'Z' Symbols]
17 *       - 5.09% : 1x    Multiplier [Two 'T' Symbols]
18 *       - 5.09% : 1x    Multiplier [Two 'H' Symbols]
19 *       - 5.09% : 1.33x Multiplier [Two Purple Pyramids]
20 *       - 5.09% : 2x    Multiplier [Two Ether Icons]
21 *   6.79%   One Of Each Pyramid
22 *       - 1.5x  Multiplier
23 *   2.94%   One Moon Icon
24 *       - 2.5x Multiplier
25 *   1.98%   Three Matching Icons
26 *       - 0.28% : 12x   Multiplier [Three Rockets]
27 *       - 0.28% : 10x   Multiplier [Three Gold  Pyramids]
28 *       - 0.28% : 7.5x Multiplier [Three 'Z' Symbols]
29 *       - 0.28% : 7.5x Multiplier [Three 'T' Symbols]
30 *       - 0.28% : 7.5x Multiplier [Three 'H' Symbols]
31 *       - 0.28% : 10x    Multiplier [Three Purple Pyramids]
32 *       - 0.28% : 15x    Multiplier [Three Ether Icons]
33 *   0.28%   Z T H Prize
34 *       - 20x Multiplier
35 *   0.03%   Two Moon Icons
36 *       - 100x  Multiplier
37 *   0.0001% Three Moon Grand Jackpot
38 *       - Jackpot Amount (variable)
39 *
40 *   Note: this contract is currently in beta. It is a one-payline, one-transaction-per-spin contract.
41 *         These will be expanded on in later versions of the contract.
42 *   From all of us at Zethr, thank you for playing!    
43 *
44 */
45 
46 // Zethr Token Bankroll interface
47 contract ZethrTokenBankroll{
48     // Game request token transfer to player 
49     function gameRequestTokens(address target, uint tokens) public;
50     function gameTokenAmount(address what) public returns (uint);
51 }
52 
53 // Zether Main Bankroll interface
54 contract ZethrMainBankroll{
55     function gameGetTokenBankrollList() public view returns (address[7]);
56 }
57 
58 // Zethr main contract interface
59 contract ZethrInterface{
60     function withdraw() public;
61 }
62 
63 // Library for figuring out the "tier" (1-7) of a dividend rate
64 library ZethrTierLibrary{
65 
66     function getTier(uint divRate) internal pure returns (uint){
67         // Tier logic 
68         // Returns the index of the UsedBankrollAddresses which should be used to call into to withdraw tokens 
69         
70         // We can divide by magnitude
71         // Remainder is removed so we only get the actual number we want
72         uint actualDiv = divRate; 
73         if (actualDiv >= 30){
74             return 6;
75         } else if (actualDiv >= 25){
76             return 5;
77         } else if (actualDiv >= 20){
78             return 4;
79         } else if (actualDiv >= 15){
80             return 3;
81         } else if (actualDiv >= 10){
82             return 2; 
83         } else if (actualDiv >= 5){
84             return 1;
85         } else if (actualDiv >= 2){
86             return 0;
87         } else{
88             // Impossible
89             revert(); 
90         }
91     }
92 }
93 
94 // Contract that contains the functions to interact with the ZlotsJackpotHoldingContract
95 contract ZlotsJackpotHoldingContract {
96   function payOutWinner(address winner) public; 
97   function getJackpot() public view returns (uint);
98 }
99  
100 // Contract that contains the functions to interact with the bankroll system
101 contract ZethrBankrollBridge {
102     // Must have an interface with the main Zethr token contract 
103     ZethrInterface Zethr;
104    
105     // Store the bankroll addresses 
106     // address[0] is main bankroll 
107     // address[1] is tier1: 2-5% 
108     // address[2] is tier2: 5-10, etc
109     address[7] UsedBankrollAddresses; 
110 
111     // Mapping for easy checking
112     mapping(address => bool) ValidBankrollAddress;
113     
114     // Set up the tokenbankroll stuff 
115     function setupBankrollInterface(address ZethrMainBankrollAddress) internal {
116 
117         // Instantiate Zethr
118         Zethr = ZethrInterface(0xD48B633045af65fF636F3c6edd744748351E020D);
119 
120         // Get the bankroll addresses from the main bankroll
121         UsedBankrollAddresses = ZethrMainBankroll(ZethrMainBankrollAddress).gameGetTokenBankrollList();
122         for(uint i=0; i<7; i++){
123             ValidBankrollAddress[UsedBankrollAddresses[i]] = true;
124         }
125     }
126     
127     // Require a function to be called from a *token* bankroll 
128     modifier fromBankroll(){
129         require(ValidBankrollAddress[msg.sender], "msg.sender should be a valid bankroll");
130         _;
131     }
132     
133     // Request a payment in tokens to a user FROM the appropriate tokenBankroll 
134     // Figure out the right bankroll via divRate 
135     function RequestBankrollPayment(address to, uint tokens, uint tier) internal {
136         address tokenBankrollAddress = UsedBankrollAddresses[tier];
137         ZethrTokenBankroll(tokenBankrollAddress).gameRequestTokens(to, tokens);
138     }
139     
140     function getZethrTokenBankroll(uint divRate) public constant returns (ZethrTokenBankroll){
141         return ZethrTokenBankroll(UsedBankrollAddresses[ZethrTierLibrary.getTier(divRate)]);
142     }
143 }
144 
145 // Contract that contains functions to move divs to the main bankroll
146 contract ZethrShell is ZethrBankrollBridge {
147 
148     // Dump ETH balance to main bankroll
149     function WithdrawToBankroll() public {
150         address(UsedBankrollAddresses[0]).transfer(address(this).balance);
151     }
152 
153     // Dump divs and dump ETH into bankroll
154     function WithdrawAndTransferToBankroll() public {
155         Zethr.withdraw();
156         WithdrawToBankroll();
157     }
158 }
159 
160 // Zethr game data setup
161 // Includes all necessary to run with Zethr
162 contract Zlots is ZethrShell {
163     using SafeMath for uint;
164 
165     // ---------------------- Events
166 
167     // Might as well notify everyone when the house takes its cut out.
168     event HouseRetrievedTake(
169         uint timeTaken,
170         uint tokensWithdrawn
171     );
172 
173     // Fire an event whenever someone places a bet.
174     event TokensWagered(
175         address _wagerer,
176         uint _wagered
177     );
178 
179     event LogResult(
180         address _wagerer,
181         uint _result,
182         uint _profit,
183         uint _wagered,
184         uint _category,
185         bool _win
186     );
187 
188     // Result announcement events (to dictate UI output!)
189     event Loss(address _wagerer, uint _block);                  // Category 0
190     event ThreeMoonJackpot(address _wagerer, uint _block);      // Category 1
191     event TwoMoonPrize(address _wagerer, uint _block);          // Category 2
192     event ZTHPrize(address _wagerer, uint _block);              // Category 3
193     event ThreeZSymbols(address _wagerer, uint _block);         // Category 4
194     event ThreeTSymbols(address _wagerer, uint _block);         // Category 5
195     event ThreeHSymbols(address _wagerer, uint _block);         // Category 6
196     event ThreeEtherIcons(address _wagerer, uint _block);       // Category 7
197     event ThreePurplePyramids(address _wagerer, uint _block);   // Category 8
198     event ThreeGoldPyramids(address _wagerer, uint _block);     // Category 9
199     event ThreeRockets(address _wagerer, uint _block);          // Category 10
200     event OneMoonPrize(address _wagerer, uint _block);          // Category 11
201     event OneOfEachPyramidPrize(address _wagerer, uint _block); // Category 12
202     event TwoZSymbols(address _wagerer, uint _block);           // Category 13
203     event TwoTSymbols(address _wagerer, uint _block);           // Category 14
204     event TwoHSymbols(address _wagerer, uint _block);           // Category 15
205     event TwoEtherIcons(address _wagerer, uint _block);         // Category 16
206     event TwoPurplePyramids(address _wagerer, uint _block);     // Category 17
207     event TwoGoldPyramids(address _wagerer, uint _block);       // Category 18
208     event TwoRockets(address _wagerer, uint _block);            // Category 19    
209     event SpinConcluded(address _wagerer, uint _block);         // Debug event
210 
211     // ---------------------- Modifiers
212 
213     // Makes sure that player porfit can't exceed a maximum amount
214     // We use the max win here - 100x
215     modifier betIsValid(uint _betSize, uint divRate) {
216       require(_betSize.mul(100) <= getMaxProfit(divRate));
217       _;
218     }
219 
220     // Requires the game to be currently active
221     modifier gameIsActive {
222       require(gamePaused == false);
223       _;
224     }
225 
226     // Require msg.sender to be owner
227     modifier onlyOwner {
228       require(msg.sender == owner); 
229       _;
230     }
231 
232     // Requires msg.sender to be bankroll
233     modifier onlyBankroll {
234       require(msg.sender == bankroll);
235       _;
236     }
237 
238     // Requires msg.sender to be owner or bankroll
239     modifier onlyOwnerOrBankroll {
240       require(msg.sender == owner || msg.sender == bankroll);
241       _;
242     }
243 
244     // ---------------------- Variables
245 
246     // Configurables
247     uint constant public maxProfitDivisor = 1000000;
248     uint constant public houseEdgeDivisor = 1000;
249     mapping (uint => uint) public maxProfit;
250     uint public maxProfitAsPercentOfHouse;
251     uint public minBet = 1e18;
252     address public zlotsJackpot;
253     address private owner;
254     address private bankroll;
255     bool gamePaused;
256 
257     // Trackers
258     uint  public totalSpins;
259     uint  public totalZTHWagered;
260     mapping (uint => uint) public contractBalance;
261 
262     // How many ZTH are in the contract?
263     mapping(uint => uint) public maxBet;
264     
265     // Is betting allowed? (Administrative function, in the event of unforeseen bugs)
266     bool public gameActive;
267 
268     address private ZTHTKNADDR;
269     address private ZTHBANKROLL;
270 
271     // ---------------------- Functions 
272 
273     // Constructor; must supply bankroll address
274     constructor(address BankrollAddress) public {
275         // Set up the bankroll interface
276         setupBankrollInterface(BankrollAddress); 
277 
278         // Owner is deployer
279         owner = msg.sender;
280 
281         // Default max profit to 5% of contract balance
282         ownerSetMaxProfitAsPercentOfHouse(50000);
283 
284         // Set starting variables
285         bankroll      = ZTHBANKROLL;
286         gameActive  = true;
287 
288         // Init min bet (1 ZTH)
289         ownerSetMinBet(1e18);
290     }
291 
292     // Zethr dividends gained are accumulated and sent to bankroll manually
293     function() public payable {  }
294 
295     // If the contract receives tokens, bundle them up in a struct and fire them over to _spinTokens for validation.
296     struct TKN { address sender; uint value; }
297     function execute(address _from, uint _value, uint divRate, bytes /* _data */) public fromBankroll returns (bool){
298             TKN memory          _tkn;
299             _tkn.sender       = _from;
300             _tkn.value        = _value;
301             _spinTokens(_tkn, divRate);
302             return true;
303     }
304 
305     struct playerSpin {
306         uint200 tokenValue; // Token value in uint
307         uint48 blockn;      // Block number 48 bits
308         uint8 tier;
309     }
310 
311     // Mapping because a player can do one spin at a time
312     mapping(address => playerSpin) public playerSpins;
313 
314     // Execute spin.
315     function _spinTokens(TKN _tkn, uint divRate) 
316       private 
317       betIsValid(_tkn.value, divRate)
318     {
319 
320         require(gameActive);
321         require(1e18 <= _tkn.value); // Must send at least one ZTH per spin.
322         
323         require(_tkn.value < ((2 ** 200) - 1));   // Smaller than the storage of 1 uint200;
324         require(block.number < ((2 ** 56) - 1));  // Current block number smaller than storage of 1 uint56
325 
326         address _customerAddress = _tkn.sender;
327         uint    _wagered         = _tkn.value;
328 
329         playerSpin memory spin = playerSpins[_tkn.sender];
330  
331         // We update the contract balance *before* the spin is over, not after
332         // This means that we don't have to worry about unresolved rolls never resolving
333         // (we also update it when a player wins)
334         addContractBalance(divRate, _wagered);
335 
336         // Cannot spin twice in one block
337         require(block.number != spin.blockn);
338 
339         // If there exists a spin, finish it
340         if (spin.blockn != 0) {
341           _finishSpin(_tkn.sender);
342         }
343 
344         // Set struct block number and token value
345         spin.blockn = uint48(block.number);
346         spin.tokenValue = uint200(_wagered);
347         spin.tier = uint8(ZethrTierLibrary.getTier(divRate));
348 
349         // Store the roll struct - 20k gas.
350         playerSpins[_tkn.sender] = spin;
351 
352         // Increment total number of spins
353         totalSpins += 1;
354 
355         // Total wagered
356         totalZTHWagered += _wagered;
357 
358         emit TokensWagered(_customerAddress, _wagered);
359 
360     }
361 
362     // Finish the current spin of a player, if they have one
363     function finishSpin() public
364         gameIsActive
365         returns (uint)
366     {
367       return _finishSpin(msg.sender);
368     }
369 
370     // Pay winners, update contract balance, send rewards where applicable.
371     function _finishSpin(address target)
372         private returns (uint)
373     {
374         playerSpin memory spin = playerSpins[target];
375 
376         require(spin.tokenValue > 0); // No re-entrancy
377         require(spin.blockn != block.number);
378 
379         uint profit = 0;
380         uint category = 0;
381 
382         // If the block is more than 255 blocks old, we can't get the result
383         // Also, if the result has already happened, fail as well
384         uint result;
385         if (block.number - spin.blockn > 255) {
386           result = 1000000; // Can't win: default to largest number
387         } else {
388 
389           // Generate a result - random based ONLY on a past block (future when submitted).
390           // Case statement barrier numbers defined by the current payment schema at the top of the contract.
391           result = random(1000000, spin.blockn, target) + 1;
392         }
393 
394         if (result > 476662) {
395             // Player has lost. Womp womp.
396 
397             // Add one percent of player loss to the jackpot
398             // (do this by requesting a payout to the jackpot)
399             RequestBankrollPayment(zlotsJackpot, profit, tier);
400 
401             // Null out player spin
402             playerSpins[target] = playerSpin(uint200(0), uint48(0), uint8(0));
403 
404             emit Loss(target, spin.blockn);
405             emit LogResult(target, result, profit, spin.tokenValue, category, false);
406         } else if (result < 2) {
407             // Player has won the three-moon mega jackpot!
408       
409             // Get profit amount via jackpot
410             profit = ZlotsJackpotHoldingContract(zlotsJackpot).getJackpot();
411             category = 1;
412     
413             // Emit events
414             emit ThreeMoonJackpot(target, spin.blockn);
415             emit LogResult(target, result, profit, spin.tokenValue, category, true);
416 
417             // Grab the tier
418             uint8 tier = spin.tier;
419 
420             // Null out spins
421             playerSpins[target] = playerSpin(uint200(0), uint48(0), uint8(0));
422 
423             // Pay out the winner
424             ZlotsJackpotHoldingContract(zlotsJackpot).payOutWinner(target);
425         } else {
426             if (result < 299) {
427                 // Player has won a two-moon prize!
428                 profit = SafeMath.mul(spin.tokenValue, 100);
429                 category = 2;
430                 emit TwoMoonPrize(target, spin.blockn);
431             } else if (result < 3128) {
432                 // Player has won the Z T H prize!
433                 profit = SafeMath.mul(spin.tokenValue, 20);
434                 category = 3;
435                 emit ZTHPrize(target, spin.blockn);
436             } else if (result < 5957) {
437                 // Player has won a three Z symbol prize!
438                 profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 75), 10);
439                 category = 4;
440                 emit ThreeZSymbols(target, spin.blockn);
441             } else if (result < 8786) {
442                 // Player has won a three T symbol prize!
443                 profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 75), 10);
444                 category = 5;
445                 emit ThreeTSymbols(target, spin.blockn);
446             } else if (result < 11615) {
447                 // Player has won a three H symbol prize!
448                 profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 75), 10);
449                 category = 6;
450                 emit ThreeHSymbols(target, spin.blockn);
451             } else if (result < 14444) {
452                 // Player has won a three Ether icon prize!
453                 profit = SafeMath.mul(spin.tokenValue, 15);
454                 category = 7;
455                 emit ThreeEtherIcons(target, spin.blockn);
456             } else if (result < 17273) {
457                 // Player has won a three purple pyramid prize!
458                 profit = SafeMath.mul(spin.tokenValue, 10);
459                 category = 8;
460                 emit ThreePurplePyramids(target, spin.blockn);
461             } else if (result < 20102) {
462                 // Player has won a three gold pyramid prize!
463                 profit = SafeMath.mul(spin.tokenValue, 10);
464                 category = 9;
465                 emit ThreeGoldPyramids(target, spin.blockn);
466             } else if (result < 22930) {
467                 // Player has won a three rocket prize!
468                 profit = SafeMath.mul(spin.tokenValue, 12);
469                 category = 10;
470                 emit ThreeRockets(target, spin.blockn);
471             } else if (result < 52333) {
472                 // Player has won a one moon prize!
473                 profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 25),10);
474                 category = 11;
475                 emit OneMoonPrize(target, spin.blockn);
476             } else if (result < 120226) {
477                 // Player has won a each-coloured-pyramid prize!
478                 profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 15),10);
479                 category = 12;
480                 emit OneOfEachPyramidPrize(target, spin.blockn);
481             } else if (result < 171147) {
482                 // Player has won a two Z symbol prize!
483                 profit = spin.tokenValue;
484                 category = 13;
485                  emit TwoZSymbols(target, spin.blockn);
486             } else if (result < 222068) {
487                 // Player has won a two T symbol prize!
488                 profit = spin.tokenValue;
489                 category = 14;
490                 emit TwoTSymbols(target, spin.blockn);
491             } else if (result < 272989) {
492                 // Player has won a two H symbol prize!
493                 profit = spin.tokenValue;
494                 category = 15;
495                 emit TwoHSymbols(target, spin.blockn);
496             } else if (result < 323910) {
497                 // Player has won a two Ether icon prize!
498                 profit = SafeMath.mul(spin.tokenValue, 2);
499                 category = 16;
500                 emit TwoEtherIcons(target, spin.blockn);
501             } else if (result < 374831) {
502                 // Player has won a two purple pyramid prize!
503                 profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 133),100);
504                 category = 17;
505                 emit TwoPurplePyramids(target, spin.blockn);
506             } else if (result < 425752) {
507                 // Player has won a two gold pyramid prize!
508                 profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 133),100);
509                 category = 18;
510                 emit TwoGoldPyramids(target, spin.blockn);
511             } else {
512                 // Player has won a two rocket prize!
513                 profit = SafeMath.mul(spin.tokenValue, 2);
514                 category = 19;
515                 emit TwoRockets(target, spin.blockn);
516             }
517 
518             emit LogResult(target, result, profit, spin.tokenValue, category, true);
519             tier = spin.tier;
520             playerSpins[target] = playerSpin(uint200(0), uint48(0), uint8(0)); // Prevent Re-entrancy
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
580       // Restricts each bet to a maximum profit of 20% contractBalance
581       require(newMaxProfitAsPercent <= 200000);
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