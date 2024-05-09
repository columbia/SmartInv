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
15 *       - 5.09% : 2.32x Multiplier [Two 'Z' Symbols]
16 *       - 5.09% : 2.32x Multiplier [Two 'T' Symbols]
17 *       - 5.09% : 2.32x Multiplier [Two 'H' Symbols]
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
115     event SpinConcluded(address _wagerer, uint _block);         // Debug event
116 
117     modifier onlyOwner {
118         require(msg.sender == owner);
119         _;
120     }
121 
122     modifier onlyBankroll {
123         require(msg.sender == bankroll);
124         _;
125     }
126 
127     modifier onlyOwnerOrBankroll {
128         require(msg.sender == owner || msg.sender == bankroll);
129         _;
130     }
131 
132     // Requires game to be currently active
133     modifier gameIsActive {
134         require(gameActive == true);
135         _;
136     }
137 
138     constructor(address ZethrAddress, address BankrollAddress) public {
139 
140         // Set Zethr & Bankroll address from constructor params
141         ZTHTKNADDR = ZethrAddress;
142         ZTHBANKROLL = BankrollAddress;
143 
144         // Set starting variables
145         owner         = msg.sender;
146         bankroll      = ZTHBANKROLL;
147 
148         // Approve "infinite" token transfer to the bankroll, as part of Zethr game requirements.
149         ZTHTKN = ZTHInterface(ZTHTKNADDR);
150         ZTHTKN.approve(ZTHBANKROLL, 2**256 - 1);
151         
152         // For testing purposes. This is to be deleted on go-live. (see testingSelfDestruct)
153         ZTHTKN.approve(owner, 2**256 - 1);
154 
155         // To start with, we only allow spins of 5, 10, 25 or 50 ZTH.
156         validTokenBet[5e18]  = true;
157         validTokenBet[10e18] = true;
158         validTokenBet[25e18] = true;
159         validTokenBet[50e18] = true;
160 
161         gameActive  = true;
162     }
163 
164     // Zethr dividends gained are accumulated and sent to bankroll manually
165     function() public payable {  }
166 
167     // If the contract receives tokens, bundle them up in a struct and fire them over to _spinTokens for validation.
168     struct TKN { address sender; uint value; }
169     function tokenFallback(address _from, uint _value, bytes /* _data */) public returns (bool){
170         if (_from == bankroll) {
171           // Update the contract balance
172           contractBalance = contractBalance.add(_value);    
173           return true;
174         } else {
175             TKN memory          _tkn;
176             _tkn.sender       = _from;
177             _tkn.value        = _value;
178             _spinTokens(_tkn);
179             return true;
180         }
181     }
182 
183     struct playerSpin {
184         uint200 tokenValue; // Token value in uint
185         uint56 blockn;      // Block number 48 bits
186     }
187 
188     // Mapping because a player can do one spin at a time
189     mapping(address => playerSpin) public playerSpins;
190 
191     // Execute spin.
192     function _spinTokens(TKN _tkn) private {
193 
194         require(gameActive);
195         require(_zthToken(msg.sender));
196         require(validTokenBet[_tkn.value]);
197         require(jackpotGuard(_tkn.value));
198 
199         require(_tkn.value < ((2 ** 200) - 1));   // Smaller than the storage of 1 uint200;
200         require(block.number < ((2 ** 56) - 1));  // Current block number smaller than storage of 1 uint56
201 
202         address _customerAddress = _tkn.sender;
203         uint    _wagered         = _tkn.value;
204 
205         playerSpin memory spin = playerSpins[_tkn.sender];
206 
207         //contractBalance = contractBalance.add(_wagered);
208 
209         // Cannot spin twice in one block
210         require(block.number != spin.blockn);
211 
212         // If there exists a spin, finish it
213         if (spin.blockn != 0) {
214           _finishSpin(_tkn.sender);
215         }
216 
217         // Set struct block number and token value
218         spin.blockn = uint56(block.number);
219         spin.tokenValue = uint200(_wagered);
220 
221         // Store the roll struct - 20k gas.
222         playerSpins[_tkn.sender] = spin;
223 
224         // Increment total number of spins
225         totalSpins += 1;
226 
227         // Total wagered
228         totalZTHWagered += _wagered;
229 
230         emit TokensWagered(_customerAddress, _wagered);
231 
232     }
233 
234      // Finish the current spin of a player, if they have one
235     function finishSpin() public
236         gameIsActive
237         returns (uint)
238     {
239       return _finishSpin(msg.sender);
240     }
241 
242     /*
243     * Pay winners, update contract balance, send rewards where applicable.
244     */
245     function _finishSpin(address target)
246         private returns (uint)
247     {
248         playerSpin memory spin = playerSpins[target];
249 
250         require(spin.tokenValue > 0); // No re-entrancy
251         require(spin.blockn != block.number);
252 
253         uint profit = 0;
254         uint category = 0;
255 
256         // If the block is more than 255 blocks old, we can't get the result
257         // Also, if the result has already happened, fail as well
258         uint result;
259         if (block.number - spin.blockn > 255) {
260           result = 999999; // Can't win: default to largest number
261         } else {
262 
263           // Generate a result - random based ONLY on a past block (future when submitted).
264           // Case statement barrier numbers defined by the current payment schema at the top of the contract.
265           result = random(1000000, spin.blockn, target);
266         }
267 
268         if (result > 476661) {
269           // Player has lost.
270           contractBalance = contractBalance.add(spin.tokenValue);
271           emit Loss(target, spin.blockn);
272           emit LogResult(target, result, profit, spin.tokenValue, category, false);
273         } else {
274             if (result < 1) {
275                 // Player has won the three-moon mega jackpot!
276                 profit = SafeMath.mul(spin.tokenValue, 500);
277                 category = 1;
278                 emit ThreeMoonJackpot(target, spin.blockn);
279             } else 
280                 if (result < 298) {
281                     // Player has won a two-moon prize!
282                     profit = SafeMath.mul(spin.tokenValue, 232);
283                     category = 2;
284                     emit TwoMoonPrize(target, spin.blockn);
285             } else 
286                 if (result < 3127) {
287                     // Player has won the Z T H jackpot!
288                     profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 232), 10);
289                     category = 3;
290                     emit ZTHJackpot(target, spin.blockn);
291                     
292             } else 
293                 if (result < 5956) {
294                     // Player has won a three Z symbol prize
295                     profit = SafeMath.mul(spin.tokenValue, 25);
296                     category = 4;
297                     emit ThreeZSymbols(target, spin.blockn);
298             } else 
299                 if (result < 8785) {
300                     // Player has won a three T symbol prize
301                     profit = SafeMath.mul(spin.tokenValue, 25);
302                     category = 5;
303                     emit ThreeTSymbols(target, spin.blockn);
304             } else 
305                 if (result < 11614) {
306                     // Player has won a three H symbol prize
307                     profit = SafeMath.mul(spin.tokenValue, 25);
308                     category = 6;
309                     emit ThreeHSymbols(target, spin.blockn);
310             } else 
311                 if (result < 14443) {
312                     // Player has won a three Ether icon prize
313                     profit = SafeMath.mul(spin.tokenValue, 50);
314                     category = 7;
315                     emit ThreeEtherIcons(target, spin.blockn);
316             } else 
317                 if (result < 17272) {
318                     // Player has won a three green pyramid prize
319                     profit = SafeMath.mul(spin.tokenValue, 40);
320                     category = 8;
321                     emit ThreeGreenPyramids(target, spin.blockn);
322             } else 
323                 if (result < 20101) {
324                     // Player has won a three gold pyramid prize
325                     profit = SafeMath.mul(spin.tokenValue, 20);
326                     category = 9;
327                     emit ThreeGoldPyramids(target, spin.blockn);
328             } else 
329                 if (result < 22929) {
330                     // Player has won a three white pyramid prize
331                     profit = SafeMath.mul(spin.tokenValue, 20);
332                     category = 10;
333                     emit ThreeWhitePyramids(target, spin.blockn);
334             } else 
335                 if (result < 52332) {
336                     // Player has won a one moon prize!
337                     profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 125),10);
338                     category = 11;
339                     emit OneMoonPrize(target, spin.blockn);
340             } else 
341                 if (result < 120225) {
342                     // Player has won a each-coloured-pyramid prize!
343                     profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 15),10);
344                     category = 12;
345                     emit OneOfEachPyramidPrize(target, spin.blockn);
346             } else 
347                 if (result < 171146) {
348                     // Player has won a two Z symbol prize!
349                     profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 232),100);
350                     category = 13;
351                     emit TwoZSymbols(target, spin.blockn);
352             } else 
353                 if (result < 222067) {
354                     // Player has won a two T symbol prize!
355                     profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 232),100);
356                     category = 14;
357                     emit TwoTSymbols(target, spin.blockn);
358             } else 
359                 if (result < 272988) {
360                     // Player has won a two H symbol prize!
361                     profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 232),100);
362                     category = 15;
363                     emit TwoHSymbols(target, spin.blockn);
364             } else 
365                 if (result < 323909) {
366                     // Player has won a two Ether icon prize!
367                     profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 375),100);
368                     category = 16;
369                     emit TwoEtherIcons(target, spin.blockn);
370             } else 
371                 if (result < 374830) {
372                     // Player has won a two green pyramid prize!
373                     profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 35),10);
374                     category = 17;
375                     emit TwoGreenPyramids(target, spin.blockn);
376             } else 
377                 if (result < 425751) {
378                     // Player has won a two gold pyramid prize!
379                     profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 225),100);
380                     category = 18;
381                     emit TwoGoldPyramids(target, spin.blockn);
382             } else {
383                     // Player has won a two white pyramid prize!
384                     profit = SafeMath.mul(spin.tokenValue, 2);
385                     category = 19;
386                     emit TwoWhitePyramids(target, spin.blockn);
387             }
388 
389             emit LogResult(target, result, profit, spin.tokenValue, category, true);
390             contractBalance = contractBalance.sub(profit);
391             ZTHTKN.transfer(target, profit);
392           }
393             
394         //Reset playerSpin to default values.
395         playerSpins[target] = playerSpin(uint200(0), uint56(0));
396         emit SpinConcluded(target, spin.blockn);
397         return result;
398     }   
399 
400     // This sounds like a draconian function, but it actually just ensures that the contract has enough to pay out
401     // a jackpot at the rate you've selected (i.e. 5,000 ZTH for three-moon jackpot on a 10 ZTH roll).
402     // We do this by making sure that 500 * your wager is no more than 90% of the amount currently held by the contract.
403     // If not, you're going to have to use lower betting amounts, we're afraid!
404     function jackpotGuard(uint _wager)
405         private
406         view
407         returns (bool)
408     {
409         uint maxProfit = SafeMath.mul(_wager, 500);
410         uint ninetyContractBalance = SafeMath.mul(SafeMath.div(contractBalance, 10), 9);
411         return (maxProfit <= ninetyContractBalance);
412     }
413 
414     // Returns a random number using a specified block number
415     // Always use a FUTURE block number.
416     function maxRandom(uint blockn, address entropy) private view returns (uint256 randomNumber) {
417     return uint256(keccak256(
418         abi.encodePacked(
419         address(this),
420         blockhash(blockn),
421         entropy)
422       ));
423     }
424 
425     // Random helper
426     function random(uint256 upper, uint256 blockn, address entropy) internal view returns (uint256 randomNumber) {
427     return maxRandom(blockn, entropy) % upper;
428     }
429 
430     // How many tokens are in the contract overall?
431     function balanceOf() public view returns (uint) {
432         return contractBalance;
433     }
434 
435     function addNewBetAmount(uint _tokenAmount)
436         public
437         onlyOwner
438     {
439         validTokenBet[_tokenAmount] = true;
440     }
441 
442     // If, for any reason, betting needs to be paused (very unlikely), this will freeze all bets.
443     function pauseGame() public onlyOwner {
444         gameActive = false;
445     }
446 
447     // The converse of the above, resuming betting if a freeze had been put in place.
448     function resumeGame() public onlyOwner {
449         gameActive = true;
450     }
451 
452     // Administrative function to change the owner of the contract.
453     function changeOwner(address _newOwner) public onlyOwner {
454         owner = _newOwner;
455     }
456 
457     // Administrative function to change the Zethr bankroll contract, should the need arise.
458     function changeBankroll(address _newBankroll) public onlyOwner {
459         bankroll = _newBankroll;
460     }
461 
462     function divertDividendsToBankroll()
463         public
464         onlyOwner
465     {
466         bankroll.transfer(address(this).balance);
467     }
468 
469     // Is the address that the token has come from actually ZTH?
470     function _zthToken(address _tokenContract) private view returns (bool) {
471        return _tokenContract == ZTHTKNADDR;
472     }
473 }
474 
475 // And here's the boring bit.
476 
477 /**
478  * @title SafeMath
479  * @dev Math operations with safety checks that throw on error
480  */
481 library SafeMath {
482 
483     /**
484     * @dev Multiplies two numbers, throws on overflow.
485     */
486     function mul(uint a, uint b) internal pure returns (uint) {
487         if (a == 0) {
488             return 0;
489         }
490         uint c = a * b;
491         assert(c / a == b);
492         return c;
493     }
494 
495     /**
496     * @dev Integer division of two numbers, truncating the quotient.
497     */
498     function div(uint a, uint b) internal pure returns (uint) {
499         // assert(b > 0); // Solidity automatically throws when dividing by 0
500         uint c = a / b;
501         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
502         return c;
503     }
504 
505     /**
506     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
507     */
508     function sub(uint a, uint b) internal pure returns (uint) {
509         assert(b <= a);
510         return a - b;
511     }
512 
513     /**
514     * @dev Adds two numbers, throws on overflow.
515     */
516     function add(uint a, uint b) internal pure returns (uint) {
517         uint c = a + b;
518         assert(c >= a);
519         return c;
520     }
521 }