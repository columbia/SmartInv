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
307     }
308 
309     // Mapping because a player can do one spin at a time
310     mapping(address => playerSpin) public playerSpins;
311 
312     // Execute spin.
313     function _spinTokens(TKN _tkn, uint divRate) 
314       private 
315       betIsValid(_tkn.value, divRate)
316     {
317 
318         require(gameActive);
319         require(block.number < ((2 ** 56) - 1));  // Current block number smaller than storage of 1 uint56
320 
321         address _customerAddress = _tkn.sender;
322         uint    _wagered         = _tkn.value;
323 
324         playerSpin memory spin = playerSpins[_tkn.sender];
325  
326         // We update the contract balance *before* the spin is over, not after
327         // This means that we don't have to worry about unresolved rolls never resolving
328         // (we also update it when a player wins)
329         addContractBalance(divRate, _wagered);
330 
331         // Cannot spin twice in one block
332         require(block.number != spin.blockn);
333 
334         // If there exists a spin, finish it
335         if (spin.blockn != 0) {
336           _finishSpin(_tkn.sender);
337         }
338 
339         // Set struct block number and token value
340         spin.blockn = uint48(block.number);
341         spin.tokenValue = uint200(_wagered);
342         spin.tier = uint8(ZethrTierLibrary.getTier(divRate));
343 
344         // Store the roll struct - 20k gas.
345         playerSpins[_tkn.sender] = spin;
346 
347         // Increment total number of spins
348         totalSpins += 1;
349 
350         // Total wagered
351         totalZTHWagered += _wagered;
352 
353         emit TokensWagered(_customerAddress, _wagered);
354     }
355 
356     // Finish the current spin of a player, if they have one
357     function finishSpin() public
358         gameIsActive
359         returns (uint)
360     {
361         return _finishSpin(msg.sender);
362     }
363 
364     // Pay winners, update contract balance, send rewards where applicable.
365     function _finishSpin(address target)
366         private returns (uint)
367     {
368         playerSpin memory spin = playerSpins[target];
369 
370         require(spin.tokenValue > 0); // No re-entrancy
371         require(spin.blockn != block.number);
372 
373         uint profit = 0;
374         uint category = 0;
375 
376         // If the block is more than 255 blocks old, we can't get the result
377         // Also, if the result has already happened, fail as well
378         uint result;
379         if (block.number - spin.blockn > 255) {
380           result = 1000000; // Can't win: default to largest number
381         } else {
382 
383           // Generate a result - random based ONLY on a past block (future when submitted).
384           // Case statement barrier numbers defined by the current payment schema at the top of the contract.
385           result = random(1000000, spin.blockn, target) + 1;
386         }
387 
388         if (result > 506856) {
389             // Player has lost. Womp womp.
390 
391             // Add one percent of player loss to the jackpot
392             // (do this by requesting a payout to the jackpot)
393             RequestBankrollPayment(zlotsJackpot, spin.tokenValue / 100, tier);
394 
395             // Null out player spin
396             playerSpins[target] = playerSpin(uint200(0), uint48(0), uint8(0));
397 
398             emit Loss(target, spin.blockn);
399             emit LogResult(target, result, profit, spin.tokenValue, category, false);
400         } else if (result < 2) {
401             // Player has won the three-moon mega jackpot!
402       
403             // Get profit amount via jackpot
404             profit = ZlotsJackpotHoldingContract(zlotsJackpot).getJackpot();
405             category = 1;
406     
407             // Emit events
408             emit ThreeMoonJackpot(target, spin.blockn);
409             emit LogResult(target, result, profit, spin.tokenValue, category, true);
410 
411             // Grab the tier
412             uint8 tier = spin.tier;
413 
414             // Null out spins
415             playerSpins[target] = playerSpin(uint200(0), uint48(0), uint8(0));
416 
417             // Pay out the winner
418             ZlotsJackpotHoldingContract(zlotsJackpot).payOutWinner(target);
419         } else {
420             if (result < 299) {
421                 // Player has won a two-moon prize!
422                 profit = SafeMath.mul(spin.tokenValue, 50);
423                 category = 2;
424                 emit TwoMoonPrize(target, spin.blockn);
425             } else if (result < 3128) {
426                 // Player has won the Z T H prize!
427                 profit = SafeMath.mul(spin.tokenValue, 20);
428                 category = 3;
429                 emit ZTHPrize(target, spin.blockn);
430             } else if (result < 16961) {
431                 // Player has won a three Z symbol prize!
432                 profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 30), 10);
433                 category = 4;
434                 emit ThreeZSymbols(target, spin.blockn);
435             } else if (result < 30794) {
436                 // Player has won a three T symbol prize!
437                 profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 30), 10);
438                 category = 5;
439                 emit ThreeTSymbols(target, spin.blockn);
440             } else if (result < 44627) {
441                 // Player has won a three H symbol prize!
442                 profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 30), 10);
443                 category = 6;
444                 emit ThreeHSymbols(target, spin.blockn);
445             } else if (result < 46627) {
446                 // Player has won a three Ether icon prize!
447                 profit = SafeMath.mul(spin.tokenValue, 11);
448                 category = 7;
449                 emit ThreeEtherIcons(target, spin.blockn);
450             } else if (result < 49127) {
451                 // Player has won a three purple pyramid prize!
452                 profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 75), 10);
453                 category = 8;
454                 emit ThreePurplePyramids(target, spin.blockn);
455             } else if (result < 51627) {
456                 // Player has won a three gold pyramid prize!
457                 profit = SafeMath.mul(spin.tokenValue, 9);
458                 category = 9;
459                 emit ThreeGoldPyramids(target, spin.blockn);
460             } else if (result < 53127) {
461                 // Player has won a three rocket prize!
462                 profit = SafeMath.mul(spin.tokenValue, 13);
463                 category = 10;
464                 emit ThreeRockets(target, spin.blockn);
465             } else if (result < 82530) {
466                 // Player has won a one moon prize!
467                 profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 25),10);
468                 category = 11;
469                 emit OneMoonPrize(target, spin.blockn);
470             } else if (result < 150423) {
471                 // Player has won a each-coloured-pyramid prize!
472                 profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 15),10);
473                 category = 12;
474                 emit OneOfEachPyramidPrize(target, spin.blockn);
475             } else if (result < 203888) {
476                 // Player has won a two Z symbol prize!
477                 profit = spin.tokenValue;
478                 category = 13;
479                  emit TwoZSymbols(target, spin.blockn);
480             } else if (result < 257353) {
481                 // Player has won a two T symbol prize!
482                 profit = spin.tokenValue;
483                 category = 14;
484                 emit TwoTSymbols(target, spin.blockn);
485             } else if (result < 310818) {
486                 // Player has won a two H symbol prize!
487                 profit = spin.tokenValue;
488                 category = 15;
489                 emit TwoHSymbols(target, spin.blockn);
490             } else if (result < 364283) {
491                 // Player has won a two Ether icon prize!
492                 profit = SafeMath.mul(spin.tokenValue, 2);
493                 category = 16;
494                 emit TwoEtherIcons(target, spin.blockn);
495             } else if (result < 417748) {
496                 // Player has won a two purple pyramid prize!
497                 profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 125), 100);
498                 category = 17;
499                 emit TwoPurplePyramids(target, spin.blockn);
500             } else if (result < 471213) {
501                 // Player has won a two gold pyramid prize!
502                 profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 133), 100);
503                 category = 18;
504                 emit TwoGoldPyramids(target, spin.blockn);
505             } else {
506                 // Player has won a two rocket prize!
507                 profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 25), 10);
508                 category = 19;
509                 emit TwoRockets(target, spin.blockn);
510             }
511 
512             emit LogResult(target, result, profit, spin.tokenValue, category, true);
513             tier = spin.tier;
514             playerSpins[target] = playerSpin(uint200(0), uint48(0), uint8(0)); // Prevent Re-entrancy
515             RequestBankrollPayment(target, profit, tier);
516           }
517             
518         emit SpinConcluded(target, spin.blockn);
519         return result;
520     }   
521 
522     // Returns a random number using a specified block number
523     // Always use a FUTURE block number.
524     function maxRandom(uint blockn, address entropy) private view returns (uint256 randomNumber) {
525     return uint256(keccak256(
526         abi.encodePacked(
527        // address(this), // adds no entropy 
528         blockhash(blockn),
529         entropy)
530       ));
531     }
532 
533     // Random helper
534     function random(uint256 upper, uint256 blockn, address entropy) internal view returns (uint256 randomNumber) {
535       return maxRandom(blockn, entropy) % upper;
536     }
537 
538     // Sets max profit (internal)
539     function setMaxProfit(uint divRate) internal {
540       maxProfit[divRate] = (contractBalance[divRate] * maxProfitAsPercentOfHouse) / maxProfitDivisor; 
541     } 
542 
543     // Gets max profit  
544     function getMaxProfit(uint divRate) public view returns (uint) {
545       return (contractBalance[divRate] * maxProfitAsPercentOfHouse) / maxProfitDivisor;
546     }
547 
548     // Subtracts from the contract balance tracking var
549     function subContractBalance(uint divRate, uint sub) internal {
550       contractBalance[divRate] = contractBalance[divRate].sub(sub);
551     }
552 
553     // Adds to the contract balance tracking var
554     function addContractBalance(uint divRate, uint add) internal {
555       contractBalance[divRate] = contractBalance[divRate].add(add);
556     }
557 
558     // An EXTERNAL update of tokens should be handled here
559     // This is due to token allocation
560     // The game should handle internal updates itself (e.g. tokens are betted)
561     function bankrollExternalUpdateTokens(uint divRate, uint newBalance) 
562       public 
563       fromBankroll 
564     {
565       contractBalance[divRate] = newBalance;
566       setMaxProfit(divRate);
567     }
568 
569     // Set the new max profit as percent of house - can be as high as 20%
570     // (1,000,000 = 100%)
571     function ownerSetMaxProfitAsPercentOfHouse(uint newMaxProfitAsPercent) public
572     onlyOwner
573     {
574       // Restricts each bet to a maximum profit of 50% contractBalance
575       require(newMaxProfitAsPercent <= 500000);
576       maxProfitAsPercentOfHouse = newMaxProfitAsPercent;
577       setMaxProfit(2);
578       setMaxProfit(5);
579       setMaxProfit(10);
580       setMaxProfit(15); 
581       setMaxProfit(20);
582       setMaxProfit(25);
583       setMaxProfit(33);
584     }
585 
586     // Only owner can set minBet   
587     function ownerSetMinBet(uint newMinimumBet) public
588     onlyOwner
589     {
590       minBet = newMinimumBet;
591     }
592 
593     // Only owner can set zlotsJackpot address
594     function ownerSetZlotsAddress(address zlotsAddress) public
595     onlyOwner
596     {
597         zlotsJackpot = zlotsAddress;
598     }
599 
600     // If, for any reason, betting needs to be paused (very unlikely), this will freeze all bets.
601     function pauseGame() public onlyOwnerOrBankroll {
602         gameActive = false;
603     }
604 
605     // The converse of the above, resuming betting if a freeze had been put in place.
606     function resumeGame() public onlyOwnerOrBankroll {
607         gameActive = true;
608     }
609 
610     // Administrative function to change the owner of the contract.
611     function changeOwner(address _newOwner) public onlyOwnerOrBankroll {
612         owner = _newOwner;
613     }
614 
615     // Administrative function to change the Zethr bankroll contract, should the need arise.
616     function changeBankroll(address _newBankroll) public onlyOwnerOrBankroll {
617         bankroll = _newBankroll;
618     }
619 
620     // Is the address that the token has come from actually ZTH?
621     function _zthToken(address _tokenContract) private view returns (bool) {
622        return _tokenContract == ZTHTKNADDR;
623     }
624 }
625 
626 // And here's the boring bit.
627 
628 /**
629  * @title SafeMath
630  * @dev Math operations with safety checks that throw on error
631  */
632 library SafeMath {
633 
634     /**
635     * @dev Multiplies two numbers, throws on overflow.
636     */
637     function mul(uint a, uint b) internal pure returns (uint) {
638         if (a == 0) {
639             return 0;
640         }
641         uint c = a * b;
642         assert(c / a == b);
643         return c;
644     }
645 
646     /**
647     * @dev Integer division of two numbers, truncating the quotient.
648     */
649     function div(uint a, uint b) internal pure returns (uint) {
650         // assert(b > 0); // Solidity automatically throws when dividing by 0
651         uint c = a / b;
652         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
653         return c;
654     }
655 
656     /**
657     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
658     */
659     function sub(uint a, uint b) internal pure returns (uint) {
660         assert(b <= a);
661         return a - b;
662     }
663 
664     /**
665     * @dev Adds two numbers, throws on overflow.
666     */
667     function add(uint a, uint b) internal pure returns (uint) {
668         uint c = a + b;
669         assert(c >= a);
670         return c;
671     }
672 }