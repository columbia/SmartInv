1 pragma solidity ^0.4.24;
2 
3 /*
4 * Zlots.
5 *
6 * Written August 2018 by the Zethr team for zethr.io.
7 *
8 * Initial code framework written by Norsefire.
9 *
10 * Rolling Odds:
11 *   52.33%	Lose	
12 *   35.64%	Two Matching Icons
13 *       - 5.09% : 2x    Multiplier [Two White Pyramids]
14 *       - 5.09% : 2.5x  Multiplier [Two Gold  Pyramids]
15 *       - 5.09% : 2.32x Multiplier [Two 'T' Symbols]
16 *       - 5.09% : 2.32x Multiplier [Two 'H' Symbols]
17 *       - 5.09% : 2.32x Multiplier [Two 'T' Symbols]
18 *       - 5.09% : 3.5x  Multiplier [Two Green Pyramids]
19 *       - 5.09% : 3.75x Multiplier [Two Ether Icons]
20 *   6.79%	One Of Each Pyramid
21 *       - 1.5x  Multiplier
22 *   2.94%	One Moon Icon
23 *       - 12.5x Multiplier
24 *   1.98%	Three Matching Icons
25 *       - 0.28% : 20x   Multiplier [Three White Pyramids]
26 *       - 0.28% : 20x   Multiplier [Three Gold  Pyramids]
27 *       - 0.28% : 25x   Multiplier [Three 'Z' Symbols]
28 *       - 0.28% : 25x   Multiplier [Three 'T' Symbols]
29 *       - 0.28% : 25x   Multiplier [Three 'H' Symbols]
30 *       - 0.28% : 40x   Multiplier [Three Green Pyramids]
31 *       - 0.28% : 50x   Multiplier [Three Ether Icons]
32 *   0.28%	Z T H Prize
33 *       - 23.2x Multiplier
34 *   0.03%	Two Moon Icons
35 *       - 232x  Multiplier
36 *   0.0001%	Three Moon Grand Jackpot
37 *       - 500x  Multiplier
38 *
39 */
40 
41 contract ZTHReceivingContract {
42     function tokenFallback(address _from, uint _value, bytes _data) public returns (bool);
43 }
44 
45 contract ZTHInterface {
46     function transfer(address _to, uint _value) public returns (bool);
47     function approve(address spender, uint tokens) public returns (bool);
48 }
49 
50 contract Zlots is ZTHReceivingContract {
51     using SafeMath for uint;
52 
53     address private owner;
54     address private bankroll;
55 
56     // How many bets have been made?
57     uint  totalSpins;
58     uint  totalZTHWagered;
59 
60     // How many ZTH are in the contract?
61     uint contractBalance;
62 
63     // Is betting allowed? (Administrative function, in the event of unforeseen bugs)
64     bool    public gameActive;
65 
66     address private ZTHTKNADDR;
67     address private ZTHBANKROLL;
68     ZTHInterface private     ZTHTKN;
69 
70     mapping (uint => bool) validTokenBet;
71 
72     // Might as well notify everyone when the house takes its cut out.
73     event HouseRetrievedTake(
74         uint timeTaken,
75         uint tokensWithdrawn
76     );
77 
78     // Fire an event whenever someone places a bet.
79     event TokensWagered(
80         address _wagerer,
81         uint _wagered
82     );
83 
84     event LogResult(
85         address _wagerer,
86         uint _result,
87         uint _profit,
88         uint _wagered,
89         uint _category,
90         bool _win
91     );
92 
93     // Result announcement events (to dictate UI output!)
94     event Loss(address _wagerer, uint _block);                  // Category 0
95     event ThreeMoonJackpot(address _wagerer, uint _block);      // Category 1
96     event TwoMoonPrize(address _wagerer, uint _block);          // Category 2
97     event ZTHJackpot(address _wagerer, uint _block);            // Category 3
98     event ThreeZSymbols(address _wagerer, uint _block);         // Category 4
99     event ThreeTSymbols(address _wagerer, uint _block);         // Category 5
100     event ThreeHSymbols(address _wagerer, uint _block);         // Category 6
101     event ThreeEtherIcons(address _wagerer, uint _block);       // Category 7
102     event ThreeGreenPyramids(address _wagerer, uint _block);    // Category 8
103     event ThreeGoldPyramids(address _wagerer, uint _block);     // Category 9
104     event ThreeWhitePyramids(address _wagerer, uint _block);    // Category 10
105     event OneMoonPrize(address _wagerer, uint _block);          // Category 11
106     event OneOfEachPyramidPrize(address _wagerer, uint _block); // Category 12
107     event TwoZSymbols(address _wagerer, uint _block);           // Category 13
108     event TwoTSymbols(address _wagerer, uint _block);           // Category 14
109     event TwoHSymbols(address _wagerer, uint _block);           // Category 15
110     event TwoEtherIcons(address _wagerer, uint _block);         // Category 16
111     event TwoGreenPyramids(address _wagerer, uint _block);      // Category 17
112     event TwoGoldPyramids(address _wagerer, uint _block);       // Category 18
113     event TwoWhitePyramids(address _wagerer, uint _block);      // Category 19
114 
115     event ReturnBet(
116         address _wagerer
117     );
118 
119     event TwoAndAHalfXMultiplier(
120         address _wagerer
121     );
122 
123     event OneAndAHalfXMultiplier(
124         address _wagerer
125     );
126 
127     modifier onlyOwner {
128         require(msg.sender == owner);
129         _;
130     }
131 
132     modifier onlyBankroll {
133         require(msg.sender == bankroll);
134         _;
135     }
136 
137     modifier onlyOwnerOrBankroll {
138         require(msg.sender == owner || msg.sender == bankroll);
139         _;
140     }
141 
142     // Requires game to be currently active
143     modifier gameIsActive {
144         require(gameActive == true);
145         _;
146     }
147 
148     constructor(address ZethrAddress, address BankrollAddress) public {
149 
150         // Set Zethr & Bankroll address from constructor params
151         ZTHTKNADDR = ZethrAddress;
152         ZTHBANKROLL = BankrollAddress;
153 
154         // Set starting variables
155         owner         = msg.sender;
156         bankroll      = ZTHBANKROLL;
157 
158         // Approve "infinite" token transfer to the bankroll, as part of Zethr game requirements.
159         ZTHTKN = ZTHInterface(ZTHTKNADDR);
160         ZTHTKN.approve(ZTHBANKROLL, 2**256 - 1);
161         
162         // For testing purposes. This is to be deleted on go-live. (see testingSelfDestruct)
163         ZTHTKN.approve(owner, 2**256 - 1);
164 
165         // To start with, we only allow spins of 5, 10, 25 or 50 ZTH.
166         validTokenBet[5e18]  = true;
167         validTokenBet[10e18] = true;
168         validTokenBet[25e18] = true;
169         validTokenBet[50e18] = true;
170 
171         gameActive  = true;
172     }
173 
174     // Zethr dividends gained are accumulated and sent to bankroll manually
175     function() public payable {  }
176 
177     // If the contract receives tokens, bundle them up in a struct and fire them over to _spinTokens for validation.
178     struct TKN { address sender; uint value; }
179     function tokenFallback(address _from, uint _value, bytes /* _data */) public returns (bool){
180         if (_from == bankroll) {
181           // Update the contract balance
182           contractBalance = contractBalance.add(_value);    
183           return true;
184         } else {
185             TKN memory          _tkn;
186             _tkn.sender       = _from;
187             _tkn.value        = _value;
188             _spinTokens(_tkn);
189             return true;
190         }
191     }
192 
193     struct playerSpin {
194         uint200 tokenValue; // Token value in uint
195         uint48 blockn;      // Block number 48 bits
196     }
197 
198     // Mapping because a player can do one spin at a time
199     mapping(address => playerSpin) public playerSpins;
200 
201     // Execute spin.
202     function _spinTokens(TKN _tkn) private {
203 
204         require(gameActive);
205         require(_zthToken(msg.sender));
206         require(validTokenBet[_tkn.value]);
207         require(jackpotGuard(_tkn.value));
208 
209         require(_tkn.value < ((2 ** 200) - 1));   // Smaller than the storage of 1 uint200;
210         require(block.number < ((2 ** 48) - 1));  // Current block number smaller than storage of 1 uint48
211 
212         address _customerAddress = _tkn.sender;
213         uint    _wagered         = _tkn.value;
214 
215         playerSpin memory spin = playerSpins[_tkn.sender];
216 
217         contractBalance = contractBalance.add(_wagered);
218 
219         // Cannot spin twice in one block
220         require(block.number != spin.blockn);
221 
222         // If there exists a spin, finish it
223         if (spin.blockn != 0) {
224           _finishSpin(_tkn.sender);
225         }
226 
227         // Set struct block number and token value
228         spin.blockn = uint48(block.number);
229         spin.tokenValue = uint200(_wagered);
230 
231         // Store the roll struct - 20k gas.
232         playerSpins[_tkn.sender] = spin;
233 
234         // Increment total number of spins
235         totalSpins += 1;
236 
237         // Total wagered
238         totalZTHWagered += _wagered;
239 
240         emit TokensWagered(_customerAddress, _wagered);
241 
242     }
243 
244      // Finish the current spin of a player, if they have one
245     function finishSpin() public
246         gameIsActive
247         returns (uint)
248     {
249       return _finishSpin(msg.sender);
250     }
251 
252     /*
253     * Pay winners, update contract balance, send rewards where applicable.
254     */
255     function _finishSpin(address target)
256         private returns (uint)
257     {
258         playerSpin memory spin = playerSpins[target];
259 
260         require(spin.tokenValue > 0); // No re-entrancy
261         require(spin.blockn != block.number);
262 
263         uint profit = 0;
264         uint category = 0;
265 
266         // If the block is more than 255 blocks old, we can't get the result
267         // Also, if the result has already happened, fail as well
268         uint result;
269         if (block.number - spin.blockn > 255) {
270           result = 9999; // Can't win: default to largest number
271         } else {
272 
273           // Generate a result - random based ONLY on a past block (future when submitted).
274           // Case statement barrier numbers defined by the current payment schema at the top of the contract.
275           result = random(1000000, spin.blockn, target);
276         }
277 
278         if (result > 476661) {
279           // Player has lost.
280           emit Loss(target, spin.blockn);
281           emit LogResult(target, result, profit, spin.tokenValue, category, false);
282         } else {
283             if (result < 1) {
284                 // Player has won the three-moon mega jackpot!
285                 profit = SafeMath.mul(spin.tokenValue, 500);
286                 category = 1;
287                 emit ThreeMoonJackpot(target, spin.blockn);
288             } else {
289                 if (result < 298) {
290                     // Player has won a two-moon prize!
291                     profit = SafeMath.mul(spin.tokenValue, 232);
292                     category = 2;
293                     emit TwoMoonPrize(target, spin.blockn);
294             } else {
295                 if (result < 3127) {
296                     // Player has won the Z T H jackpot!
297                     profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 232), 10);
298                     category = 3;
299                     emit ZTHJackpot(target, spin.blockn);
300                     
301             } else {
302                 if (result < 5956) {
303                     // Player has won a three Z symbol prize
304                     profit = SafeMath.mul(spin.tokenValue, 25);
305                     category = 4;
306                     emit ThreeZSymbols(target, spin.blockn);
307             } else {
308                 if (result < 8785) {
309                     // Player has won a three T symbol prize
310                     profit = SafeMath.mul(spin.tokenValue, 25);
311                     category = 5;
312                     emit ThreeTSymbols(target, spin.blockn);
313             } else {
314                 if (result < 11614) {
315                     // Player has won a three H symbol prize
316                     profit = SafeMath.mul(spin.tokenValue, 25);
317                     category = 6;
318                     emit ThreeHSymbols(target, spin.blockn);
319             } else {
320                 if (result < 14443) {
321                     // Player has won a three Ether icon prize
322                     profit = SafeMath.mul(spin.tokenValue, 50);
323                     category = 7;
324                     emit ThreeEtherIcons(target, spin.blockn);
325             } else {
326                 if (result < 17272) {
327                     // Player has won a three green pyramid prize
328                     profit = SafeMath.mul(spin.tokenValue, 40);
329                     category = 8;
330                     emit ThreeGreenPyramids(target, spin.blockn);
331             } else {
332                 if (result < 20101) {
333                     // Player has won a three gold pyramid prize
334                     profit = SafeMath.mul(spin.tokenValue, 20);
335                     category = 9;
336                     emit ThreeGoldPyramids(target, spin.blockn);
337             } else {
338                 if (result < 22929) {
339                     // Player has won a three white pyramid prize
340                     profit = SafeMath.mul(spin.tokenValue, 20);
341                     category = 10;
342                     emit ThreeWhitePyramids(target, spin.blockn);
343             } else {
344                 if (result < 52332) {
345                     // Player has won a one moon prize!
346                     profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 125),10);
347                     category = 11;
348                     emit OneMoonPrize(target, spin.blockn);
349             } else {
350                 if (result < 120225) {
351                     // Player has won a each-coloured-pyramid prize!
352                     profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 15),10);
353                     category = 12;
354                     emit OneOfEachPyramidPrize(target, spin.blockn);
355             } else {
356                 if (result < 171146) {
357                     // Player has won a two Z symbol prize!
358                     profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 232),100);
359                     category = 13;
360                     emit TwoZSymbols(target, spin.blockn);
361             } else {
362                 if (result < 222067) {
363                     // Player has won a two T symbol prize!
364                     profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 232),100);
365                     category = 14;
366                     emit TwoTSymbols(target, spin.blockn);
367             } else {
368                 if (result < 272988) {
369                     // Player has won a two H symbol prize!
370                     profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 232),100);
371                     category = 15;
372                     emit TwoHSymbols(target, spin.blockn);
373             } else {
374                 if (result < 323909) {
375                     // Player has won a two Ether icon prize!
376                     profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 375),100);
377                     category = 16;
378                     emit TwoEtherIcons(target, spin.blockn);
379             } else {
380                 if (result < 374830) {
381                     // Player has won a two green pyramid prize!
382                     profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 35),10);
383                     category = 17;
384                     emit TwoGreenPyramids(target, spin.blockn);
385             } else {
386                 if (result < 425751) {
387                     // Player has won a two gold pyramid prize!
388                     profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 225),100);
389                     category = 18;
390                     emit TwoGoldPyramids(target, spin.blockn);
391             } else {
392                     // Player has won a two white pyramid prize!
393                     profit = SafeMath.mul(spin.tokenValue, 2);
394                     category = 19;
395                     emit TwoWhitePyramids(target, spin.blockn);
396             }
397 
398             emit LogResult(target, result, profit, spin.tokenValue, category, true);
399             contractBalance = contractBalance.sub(profit);
400             ZTHTKN.transfer(target, profit);
401             
402         // God damnit I hate Solidity bracketing
403         }}}}}}}}}}}}}}}}}}
404             
405         playerSpins[target] = playerSpin(uint200(0), uint48(0));
406         return result;
407     }   
408 
409     // This sounds like a draconian function, but it actually just ensures that the contract has enough to pay out
410     // a jackpot at the rate you've selected (i.e. 5,000 ZTH for three-moon jackpot on a 10 ZTH roll).
411     // We do this by making sure that 25* your wager is no less than 90% of the amount currently held by the contract.
412     // If not, you're going to have to use lower betting amounts, we're afraid!
413     function jackpotGuard(uint _wager)
414         private
415         view
416         returns (bool)
417     {
418         uint maxProfit = SafeMath.mul(_wager, 500);
419         uint ninetyContractBalance = SafeMath.mul(SafeMath.div(contractBalance, 10), 9);
420         return (maxProfit <= ninetyContractBalance);
421     }
422 
423     // Returns a random number using a specified block number
424     // Always use a FUTURE block number.
425     function maxRandom(uint blockn, address entropy) private view returns (uint256 randomNumber) {
426     return uint256(keccak256(
427         abi.encodePacked(
428         blockhash(blockn),
429         entropy)
430       ));
431     }
432 
433     // Random helper
434     function random(uint256 upper, uint256 blockn, address entropy) internal view returns (uint256 randomNumber) {
435     return maxRandom(blockn, entropy) % upper;
436     }
437 
438     // How many tokens are in the contract overall?
439     function balanceOf() public view returns (uint) {
440         return contractBalance;
441     }
442 
443     function addNewBetAmount(uint _tokenAmount)
444         public
445         onlyOwner
446     {
447         validTokenBet[_tokenAmount] = true;
448     }
449 
450     // If, for any reason, betting needs to be paused (very unlikely), this will freeze all bets.
451     function pauseGame() public onlyOwner {
452         gameActive = false;
453     }
454 
455     // The converse of the above, resuming betting if a freeze had been put in place.
456     function resumeGame() public onlyOwner {
457         gameActive = true;
458     }
459 
460     // Administrative function to change the owner of the contract.
461     function changeOwner(address _newOwner) public onlyOwner {
462         owner = _newOwner;
463     }
464 
465     // Administrative function to change the Zethr bankroll contract, should the need arise.
466     function changeBankroll(address _newBankroll) public onlyOwner {
467         bankroll = _newBankroll;
468     }
469 
470     // Any dividends acquired by this contract is automatically triggered.
471     function divertDividendsToBankroll()
472         public
473         onlyOwner
474     {
475         bankroll.transfer(address(this).balance);
476     }
477 
478     function testingSelfDestruct()
479         public
480         onlyOwner
481     {
482         // Give me back my testing tokens :)
483         ZTHTKN.transfer(owner, contractBalance);
484         selfdestruct(owner);
485     }
486     
487     // Is the address that the token has come from actually ZTH?
488     function _zthToken(address _tokenContract) private view returns (bool) {
489        return _tokenContract == ZTHTKNADDR;
490     }
491 }
492 
493 // And here's the boring bit.
494 
495 /**
496  * @title SafeMath
497  * @dev Math operations with safety checks that throw on error
498  */
499 library SafeMath {
500 
501     /**
502     * @dev Multiplies two numbers, throws on overflow.
503     */
504     function mul(uint a, uint b) internal pure returns (uint) {
505         if (a == 0) {
506             return 0;
507         }
508         uint c = a * b;
509         assert(c / a == b);
510         return c;
511     }
512 
513     /**
514     * @dev Integer division of two numbers, truncating the quotient.
515     */
516     function div(uint a, uint b) internal pure returns (uint) {
517         // assert(b > 0); // Solidity automatically throws when dividing by 0
518         uint c = a / b;
519         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
520         return c;
521     }
522 
523     /**
524     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
525     */
526     function sub(uint a, uint b) internal pure returns (uint) {
527         assert(b <= a);
528         return a - b;
529     }
530 
531     /**
532     * @dev Adds two numbers, throws on overflow.
533     */
534     function add(uint a, uint b) internal pure returns (uint) {
535         uint c = a + b;
536         assert(c >= a);
537         return c;
538     }
539 }