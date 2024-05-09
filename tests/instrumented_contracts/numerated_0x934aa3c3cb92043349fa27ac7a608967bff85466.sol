1 pragma solidity ^0.4.24;
2 
3 /*
4 * Zlots Beta.
5 *
6 * Written August 2018 by the Zethr team for zethr.io.
7 *
8 * Code framework written by Norsefire.
9 * EV Calculations by TropicalRogue.
10 *
11 * Rolling Odds:
12 *   52.33%	Lose	
13 *   35.64%	Two Matching Icons
14 *       - 5.09% : 2x    Multiplier [Two White Pyramids]
15 *       - 5.09% : 2.5x  Multiplier [Two Gold  Pyramids]
16 *       - 5.09% : 2.32x Multiplier [Two 'Z' Symbols]
17 *       - 5.09% : 2.32x Multiplier [Two 'T' Symbols]
18 *       - 5.09% : 2.32x Multiplier [Two 'H' Symbols]
19 *       - 5.09% : 3.5x  Multiplier [Two Green Pyramids]
20 *       - 5.09% : 3.75x Multiplier [Two Ether Icons]
21 *   6.79%	One Of Each Pyramid
22 *       - 1.5x  Multiplier
23 *   2.94%	One Moon Icon
24 *       - 12.5x Multiplier
25 *   1.98%	Three Matching Icons
26 *       - 0.28% : 20x   Multiplier [Three White Pyramids]
27 *       - 0.28% : 20x   Multiplier [Three Gold  Pyramids]
28 *       - 0.28% : 25x   Multiplier [Three 'Z' Symbols]
29 *       - 0.28% : 25x   Multiplier [Three 'T' Symbols]
30 *       - 0.28% : 25x   Multiplier [Three 'H' Symbols]
31 *       - 0.28% : 40x   Multiplier [Three Green Pyramids]
32 *       - 0.28% : 50x   Multiplier [Three Ether Icons]
33 *   0.28%	Z T H Prize
34 *       - 23.2x Multiplier
35 *   0.03%	Two Moon Icons
36 *       - 232x  Multiplier
37 *   0.0001%	Three Moon Grand Jackpot
38 *       - 500x  Multiplier
39 *
40 */
41 
42 contract ZTHReceivingContract {
43     function tokenFallback(address _from, uint _value, bytes _data) public returns (bool);
44 }
45 
46 contract ZTHInterface {
47     function transfer(address _to, uint _value) public returns (bool);
48     function approve(address spender, uint tokens) public returns (bool);
49 }
50 
51 contract Zlots is ZTHReceivingContract {
52     using SafeMath for uint;
53 
54     address private owner;
55     address private bankroll;
56 
57     // How many bets have been made?
58     uint  totalSpins;
59     uint  totalZTHWagered;
60 
61     // How many ZTH are in the contract?
62     uint contractBalance;
63 
64     // Is betting allowed? (Administrative function, in the event of unforeseen bugs)
65     bool    public gameActive;
66 
67     address private ZTHTKNADDR;
68     address private ZTHBANKROLL;
69     ZTHInterface private     ZTHTKN;
70 
71     mapping (uint => bool) validTokenBet;
72 
73     // Might as well notify everyone when the house takes its cut out.
74     event HouseRetrievedTake(
75         uint timeTaken,
76         uint tokensWithdrawn
77     );
78 
79     // Fire an event whenever someone places a bet.
80     event TokensWagered(
81         address _wagerer,
82         uint _wagered
83     );
84 
85     event LogResult(
86         address _wagerer,
87         uint _result,
88         uint _profit,
89         uint _wagered,
90         uint _category,
91         bool _win
92     );
93 
94     // Result announcement events (to dictate UI output!)
95     event Loss(address _wagerer, uint _block);                  // Category 0
96     event ThreeMoonJackpot(address _wagerer, uint _block);      // Category 1
97     event TwoMoonPrize(address _wagerer, uint _block);          // Category 2
98     event ZTHJackpot(address _wagerer, uint _block);            // Category 3
99     event ThreeZSymbols(address _wagerer, uint _block);         // Category 4
100     event ThreeTSymbols(address _wagerer, uint _block);         // Category 5
101     event ThreeHSymbols(address _wagerer, uint _block);         // Category 6
102     event ThreeEtherIcons(address _wagerer, uint _block);       // Category 7
103     event ThreeGreenPyramids(address _wagerer, uint _block);    // Category 8
104     event ThreeGoldPyramids(address _wagerer, uint _block);     // Category 9
105     event ThreeWhitePyramids(address _wagerer, uint _block);    // Category 10
106     event OneMoonPrize(address _wagerer, uint _block);          // Category 11
107     event OneOfEachPyramidPrize(address _wagerer, uint _block); // Category 12
108     event TwoZSymbols(address _wagerer, uint _block);           // Category 13
109     event TwoTSymbols(address _wagerer, uint _block);           // Category 14
110     event TwoHSymbols(address _wagerer, uint _block);           // Category 15
111     event TwoEtherIcons(address _wagerer, uint _block);         // Category 16
112     event TwoGreenPyramids(address _wagerer, uint _block);      // Category 17
113     event TwoGoldPyramids(address _wagerer, uint _block);       // Category 18
114     event TwoWhitePyramids(address _wagerer, uint _block);      // Category 19
115     
116     event SpinConcluded(address _wagerer, uint _block);         // Debug event
117 
118     modifier onlyOwner {
119         require(msg.sender == owner);
120         _;
121     }
122 
123     modifier onlyBankroll {
124         require(msg.sender == bankroll);
125         _;
126     }
127 
128     modifier onlyOwnerOrBankroll {
129         require(msg.sender == owner || msg.sender == bankroll);
130         _;
131     }
132 
133     // Requires game to be currently active
134     modifier gameIsActive {
135         require(gameActive == true);
136         _;
137     }
138 
139     constructor(address ZethrAddress, address BankrollAddress) public {
140 
141         // Set Zethr & Bankroll address from constructor params
142         ZTHTKNADDR = ZethrAddress;
143         ZTHBANKROLL = BankrollAddress;
144 
145         // Set starting variables
146         owner         = msg.sender;
147         bankroll      = ZTHBANKROLL;
148 
149         // Approve "infinite" token transfer to the bankroll, as part of Zethr game requirements.
150         ZTHTKN = ZTHInterface(ZTHTKNADDR);
151         ZTHTKN.approve(ZTHBANKROLL, 2**256 - 1);
152         
153         // For testing purposes. This is to be deleted on go-live. (see testingSelfDestruct)
154         ZTHTKN.approve(owner, 2**256 - 1);
155 
156         // To start with, we only allow spins of 1, 5, 10, 25 or 50 ZTH.
157         validTokenBet[1e18]  = true;
158         validTokenBet[5e18]  = true;
159         validTokenBet[10e18] = true;
160         validTokenBet[25e18] = true;
161         validTokenBet[50e18] = true;
162 
163         gameActive  = true;
164     }
165 
166     // Zethr dividends gained are accumulated and sent to bankroll manually
167     function() public payable {  }
168 
169     // If the contract receives tokens, bundle them up in a struct and fire them over to _spinTokens for validation.
170     struct TKN { address sender; uint value; }
171     function tokenFallback(address _from, uint _value, bytes /* _data */) public returns (bool){
172         if (_from == bankroll) {
173           // Update the contract balance
174           contractBalance = contractBalance.add(_value);    
175           return true;
176         } else {
177             TKN memory          _tkn;
178             _tkn.sender       = _from;
179             _tkn.value        = _value;
180             _spinTokens(_tkn);
181             return true;
182         }
183     }
184 
185     struct playerSpin {
186         uint200 tokenValue; // Token value in uint
187         uint56 blockn;      // Block number 48 bits
188     }
189 
190     // Mapping because a player can do one spin at a time
191     mapping(address => playerSpin) public playerSpins;
192 
193     // Execute spin.
194     function _spinTokens(TKN _tkn) private {
195 
196         require(gameActive);
197         require(_zthToken(msg.sender));
198         require(validTokenBet[_tkn.value]);
199         require(jackpotGuard(_tkn.value));
200 
201         require(_tkn.value < ((2 ** 200) - 1));   // Smaller than the storage of 1 uint200;
202         require(block.number < ((2 ** 56) - 1));  // Current block number smaller than storage of 1 uint56
203 
204         address _customerAddress = _tkn.sender;
205         uint    _wagered         = _tkn.value;
206 
207         playerSpin memory spin = playerSpins[_tkn.sender];
208 
209         contractBalance = contractBalance.add(_wagered);
210 
211         // Cannot spin twice in one block
212         require(block.number != spin.blockn);
213 
214         // If there exists a spin, finish it
215         if (spin.blockn != 0) {
216           _finishSpin(_tkn.sender);
217         }
218 
219         // Set struct block number and token value
220         spin.blockn = uint56(block.number);
221         spin.tokenValue = uint200(_wagered);
222 
223         // Store the roll struct - 20k gas.
224         playerSpins[_tkn.sender] = spin;
225 
226         // Increment total number of spins
227         totalSpins += 1;
228 
229         // Total wagered
230         totalZTHWagered += _wagered;
231 
232         emit TokensWagered(_customerAddress, _wagered);
233 
234     }
235 
236      // Finish the current spin of a player, if they have one
237     function finishSpin() public
238         gameIsActive
239         returns (uint)
240     {
241       return _finishSpin(msg.sender);
242     }
243 
244     /*
245     * Pay winners, update contract balance, send rewards where applicable.
246     */
247     function _finishSpin(address target)
248         private returns (uint)
249     {
250         playerSpin memory spin = playerSpins[target];
251 
252         require(spin.tokenValue > 0); // No re-entrancy
253         require(spin.blockn != block.number);
254 
255         uint profit = 0;
256         uint category = 0;
257 
258         // If the block is more than 255 blocks old, we can't get the result
259         // Also, if the result has already happened, fail as well
260         uint result;
261         if (block.number - spin.blockn > 255) {
262           result = 999999; // Can't win: default to largest number
263         } else {
264 
265           // Generate a result - random based ONLY on a past block (future when submitted).
266           // Case statement barrier numbers defined by the current payment schema at the top of the contract.
267           result = random(1000000, spin.blockn, target);
268         }
269 
270         if (result > 476661) {
271           // Player has lost.
272           emit Loss(target, spin.blockn);
273           emit LogResult(target, result, profit, spin.tokenValue, category, false);
274         } else {
275             if (result < 1) {
276                 // Player has won the three-moon mega jackpot!
277                 profit = SafeMath.mul(spin.tokenValue, 500);
278                 category = 1;
279                 emit ThreeMoonJackpot(target, spin.blockn);
280             } else 
281                 if (result < 298) {
282                     // Player has won a two-moon prize!
283                     profit = SafeMath.mul(spin.tokenValue, 232);
284                     category = 2;
285                     emit TwoMoonPrize(target, spin.blockn);
286             } else 
287                 if (result < 3127) {
288                     // Player has won the Z T H jackpot!
289                     profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 232), 10);
290                     category = 3;
291                     emit ZTHJackpot(target, spin.blockn);
292                     
293             } else 
294                 if (result < 5956) {
295                     // Player has won a three Z symbol prize
296                     profit = SafeMath.mul(spin.tokenValue, 25);
297                     category = 4;
298                     emit ThreeZSymbols(target, spin.blockn);
299             } else 
300                 if (result < 8785) {
301                     // Player has won a three T symbol prize
302                     profit = SafeMath.mul(spin.tokenValue, 25);
303                     category = 5;
304                     emit ThreeTSymbols(target, spin.blockn);
305             } else 
306                 if (result < 11614) {
307                     // Player has won a three H symbol prize
308                     profit = SafeMath.mul(spin.tokenValue, 25);
309                     category = 6;
310                     emit ThreeHSymbols(target, spin.blockn);
311             } else 
312                 if (result < 14443) {
313                     // Player has won a three Ether icon prize
314                     profit = SafeMath.mul(spin.tokenValue, 50);
315                     category = 7;
316                     emit ThreeEtherIcons(target, spin.blockn);
317             } else 
318                 if (result < 17272) {
319                     // Player has won a three green pyramid prize
320                     profit = SafeMath.mul(spin.tokenValue, 40);
321                     category = 8;
322                     emit ThreeGreenPyramids(target, spin.blockn);
323             } else 
324                 if (result < 20101) {
325                     // Player has won a three gold pyramid prize
326                     profit = SafeMath.mul(spin.tokenValue, 20);
327                     category = 9;
328                     emit ThreeGoldPyramids(target, spin.blockn);
329             } else 
330                 if (result < 22929) {
331                     // Player has won a three white pyramid prize
332                     profit = SafeMath.mul(spin.tokenValue, 20);
333                     category = 10;
334                     emit ThreeWhitePyramids(target, spin.blockn);
335             } else 
336                 if (result < 52332) {
337                     // Player has won a one moon prize!
338                     profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 125),10);
339                     category = 11;
340                     emit OneMoonPrize(target, spin.blockn);
341             } else 
342                 if (result < 120225) {
343                     // Player has won a each-coloured-pyramid prize!
344                     profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 15),10);
345                     category = 12;
346                     emit OneOfEachPyramidPrize(target, spin.blockn);
347             } else 
348                 if (result < 171146) {
349                     // Player has won a two Z symbol prize!
350                     profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 232),100);
351                     category = 13;
352                     emit TwoZSymbols(target, spin.blockn);
353             } else 
354                 if (result < 222067) {
355                     // Player has won a two T symbol prize!
356                     profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 232),100);
357                     category = 14;
358                     emit TwoTSymbols(target, spin.blockn);
359             } else 
360                 if (result < 272988) {
361                     // Player has won a two H symbol prize!
362                     profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 232),100);
363                     category = 15;
364                     emit TwoHSymbols(target, spin.blockn);
365             } else 
366                 if (result < 323909) {
367                     // Player has won a two Ether icon prize!
368                     profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 375),100);
369                     category = 16;
370                     emit TwoEtherIcons(target, spin.blockn);
371             } else 
372                 if (result < 374830) {
373                     // Player has won a two green pyramid prize!
374                     profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 35),10);
375                     category = 17;
376                     emit TwoGreenPyramids(target, spin.blockn);
377             } else 
378                 if (result < 425751) {
379                     // Player has won a two gold pyramid prize!
380                     profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 225),100);
381                     category = 18;
382                     emit TwoGoldPyramids(target, spin.blockn);
383             } else {
384                     // Player has won a two white pyramid prize!
385                     profit = SafeMath.mul(spin.tokenValue, 2);
386                     category = 19;
387                     emit TwoWhitePyramids(target, spin.blockn);
388             }
389 
390             emit LogResult(target, result, profit, spin.tokenValue, category, true);
391             contractBalance = contractBalance.sub(profit);
392             ZTHTKN.transfer(target, profit);
393           }
394             
395         //Reset playerSpin to default values.
396         playerSpins[target] = playerSpin(uint200(0), uint56(0));
397         emit SpinConcluded(target, spin.blockn);
398         return result;
399     }   
400 
401     // This sounds like a draconian function, but it actually just ensures that the contract has enough to pay out
402     // a jackpot at the rate you've selected (i.e. 5,000 ZTH for three-moon jackpot on a 10 ZTH roll).
403     // We do this by making sure that 500 * your wager is no more than 90% of the amount currently held by the contract.
404     // If not, you're going to have to use lower betting amounts, we're afraid!
405     function jackpotGuard(uint _wager)
406         private
407         view
408         returns (bool)
409     {
410         uint maxProfit = SafeMath.mul(_wager, 500);
411         uint ninetyContractBalance = SafeMath.mul(SafeMath.div(contractBalance, 10), 9);
412         return (maxProfit <= ninetyContractBalance);
413     }
414 
415     // Returns a random number using a specified block number
416     // Always use a FUTURE block number.
417     function maxRandom(uint blockn, address entropy) private view returns (uint256 randomNumber) {
418     return uint256(keccak256(
419         abi.encodePacked(
420         address(this),
421         blockhash(blockn),
422         entropy)
423       ));
424     }
425 
426     // Random helper
427     function random(uint256 upper, uint256 blockn, address entropy) internal view returns (uint256 randomNumber) {
428     return maxRandom(blockn, entropy) % upper;
429     }
430 
431     // How many tokens are in the contract overall?
432     function balanceOf() public view returns (uint) {
433         return contractBalance;
434     }
435 
436     function addNewBetAmount(uint _tokenAmount)
437         public
438         onlyOwner
439     {
440         validTokenBet[_tokenAmount] = true;
441     }
442 
443     // If, for any reason, betting needs to be paused (very unlikely), this will freeze all bets.
444     function pauseGame() public onlyOwner {
445         gameActive = false;
446     }
447 
448     // The converse of the above, resuming betting if a freeze had been put in place.
449     function resumeGame() public onlyOwner {
450         gameActive = true;
451     }
452 
453     // Administrative function to change the owner of the contract.
454     function changeOwner(address _newOwner) public onlyOwner {
455         owner = _newOwner;
456     }
457 
458     // Administrative function to change the Zethr bankroll contract, should the need arise.
459     function changeBankroll(address _newBankroll) public onlyOwner {
460         bankroll = _newBankroll;
461     }
462 
463     function divertDividendsToBankroll()
464         public
465         onlyOwner
466     {
467         bankroll.transfer(address(this).balance);
468     }
469 
470     // Is the address that the token has come from actually ZTH?
471     function _zthToken(address _tokenContract) private view returns (bool) {
472        return _tokenContract == ZTHTKNADDR;
473     }
474 }
475 
476 // And here's the boring bit.
477 
478 /**
479  * @title SafeMath
480  * @dev Math operations with safety checks that throw on error
481  */
482 library SafeMath {
483 
484     /**
485     * @dev Multiplies two numbers, throws on overflow.
486     */
487     function mul(uint a, uint b) internal pure returns (uint) {
488         if (a == 0) {
489             return 0;
490         }
491         uint c = a * b;
492         assert(c / a == b);
493         return c;
494     }
495 
496     /**
497     * @dev Integer division of two numbers, truncating the quotient.
498     */
499     function div(uint a, uint b) internal pure returns (uint) {
500         // assert(b > 0); // Solidity automatically throws when dividing by 0
501         uint c = a / b;
502         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
503         return c;
504     }
505 
506     /**
507     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
508     */
509     function sub(uint a, uint b) internal pure returns (uint) {
510         assert(b <= a);
511         return a - b;
512     }
513 
514     /**
515     * @dev Adds two numbers, throws on overflow.
516     */
517     function add(uint a, uint b) internal pure returns (uint) {
518         uint c = a + b;
519         assert(c >= a);
520         return c;
521     }
522 }