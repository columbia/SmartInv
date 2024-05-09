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
115     modifier onlyOwner {
116         require(msg.sender == owner);
117         _;
118     }
119 
120     modifier onlyBankroll {
121         require(msg.sender == bankroll);
122         _;
123     }
124 
125     modifier onlyOwnerOrBankroll {
126         require(msg.sender == owner || msg.sender == bankroll);
127         _;
128     }
129 
130     // Requires game to be currently active
131     modifier gameIsActive {
132         require(gameActive == true);
133         _;
134     }
135 
136     constructor(address ZethrAddress, address BankrollAddress) public {
137 
138         // Set Zethr & Bankroll address from constructor params
139         ZTHTKNADDR = ZethrAddress;
140         ZTHBANKROLL = BankrollAddress;
141 
142         // Set starting variables
143         owner         = msg.sender;
144         bankroll      = ZTHBANKROLL;
145 
146         // Approve "infinite" token transfer to the bankroll, as part of Zethr game requirements.
147         ZTHTKN = ZTHInterface(ZTHTKNADDR);
148         ZTHTKN.approve(ZTHBANKROLL, 2**256 - 1);
149         
150         // For testing purposes. This is to be deleted on go-live. (see testingSelfDestruct)
151         ZTHTKN.approve(owner, 2**256 - 1);
152 
153         // To start with, we only allow spins of 5, 10, 25 or 50 ZTH.
154         validTokenBet[5e18]  = true;
155         validTokenBet[10e18] = true;
156         validTokenBet[25e18] = true;
157         validTokenBet[50e18] = true;
158 
159         gameActive  = true;
160     }
161 
162     // Zethr dividends gained are accumulated and sent to bankroll manually
163     function() public payable {  }
164 
165     // If the contract receives tokens, bundle them up in a struct and fire them over to _spinTokens for validation.
166     struct TKN { address sender; uint value; }
167     function tokenFallback(address _from, uint _value, bytes /* _data */) public returns (bool){
168         if (_from == bankroll) {
169           // Update the contract balance
170           contractBalance = contractBalance.add(_value);    
171           return true;
172         } else {
173             TKN memory          _tkn;
174             _tkn.sender       = _from;
175             _tkn.value        = _value;
176             _spinTokens(_tkn);
177             return true;
178         }
179     }
180 
181     struct playerSpin {
182         uint200 tokenValue; // Token value in uint
183         uint48 blockn;      // Block number 48 bits
184     }
185 
186     // Mapping because a player can do one spin at a time
187     mapping(address => playerSpin) public playerSpins;
188 
189     // Execute spin.
190     function _spinTokens(TKN _tkn) private {
191 
192         require(gameActive);
193         require(_zthToken(msg.sender));
194         require(validTokenBet[_tkn.value]);
195         require(jackpotGuard(_tkn.value));
196 
197         require(_tkn.value < ((2 ** 200) - 1));   // Smaller than the storage of 1 uint200;
198         require(block.number < ((2 ** 48) - 1));  // Current block number smaller than storage of 1 uint48
199 
200         address _customerAddress = _tkn.sender;
201         uint    _wagered         = _tkn.value;
202 
203         playerSpin memory spin = playerSpins[_tkn.sender];
204 
205         contractBalance = contractBalance.add(_wagered);
206 
207         // Cannot spin twice in one block
208         require(block.number != spin.blockn);
209 
210         // If there exists a spin, finish it
211         if (spin.blockn != 0) {
212           _finishSpin(_tkn.sender);
213         }
214 
215         // Set struct block number and token value
216         spin.blockn = uint48(block.number);
217         spin.tokenValue = uint200(_wagered);
218 
219         // Store the roll struct - 20k gas.
220         playerSpins[_tkn.sender] = spin;
221 
222         // Increment total number of spins
223         totalSpins += 1;
224 
225         // Total wagered
226         totalZTHWagered += _wagered;
227 
228         emit TokensWagered(_customerAddress, _wagered);
229 
230     }
231 
232      // Finish the current spin of a player, if they have one
233     function finishSpin() public
234         gameIsActive
235         returns (uint)
236     {
237       return _finishSpin(msg.sender);
238     }
239 
240     /*
241     * Pay winners, update contract balance, send rewards where applicable.
242     */
243     function _finishSpin(address target)
244         private returns (uint)
245     {
246         playerSpin memory spin = playerSpins[target];
247 
248         require(spin.tokenValue > 0); // No re-entrancy
249         require(spin.blockn != block.number);
250 
251         uint profit = 0;
252         uint category = 0;
253 
254         // If the block is more than 255 blocks old, we can't get the result
255         // Also, if the result has already happened, fail as well
256         uint result;
257         if (block.number - spin.blockn > 255) {
258           result = 9999; // Can't win: default to largest number
259         } else {
260 
261           // Generate a result - random based ONLY on a past block (future when submitted).
262           // Case statement barrier numbers defined by the current payment schema at the top of the contract.
263           result = random(1000000, spin.blockn, target);
264         }
265 
266         if (result > 476661) {
267           // Player has lost.
268           emit Loss(target, spin.blockn);
269           emit LogResult(target, result, profit, spin.tokenValue, category, false);
270         } else 
271             if (result < 1) {
272                 // Player has won the three-moon mega jackpot!
273                 profit = SafeMath.mul(spin.tokenValue, 500);
274                 category = 1;
275                 emit ThreeMoonJackpot(target, spin.blockn);
276             } else 
277                 if (result < 298) {
278                     // Player has won a two-moon prize!
279                     profit = SafeMath.mul(spin.tokenValue, 232);
280                     category = 2;
281                     emit TwoMoonPrize(target, spin.blockn);
282             } else 
283                 if (result < 3127) {
284                     // Player has won the Z T H jackpot!
285                     profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 232), 10);
286                     category = 3;
287                     emit ZTHJackpot(target, spin.blockn);
288                     
289             } else 
290                 if (result < 5956) {
291                     // Player has won a three Z symbol prize
292                     profit = SafeMath.mul(spin.tokenValue, 25);
293                     category = 4;
294                     emit ThreeZSymbols(target, spin.blockn);
295             } else 
296                 if (result < 8785) {
297                     // Player has won a three T symbol prize
298                     profit = SafeMath.mul(spin.tokenValue, 25);
299                     category = 5;
300                     emit ThreeTSymbols(target, spin.blockn);
301             } else 
302                 if (result < 11614) {
303                     // Player has won a three H symbol prize
304                     profit = SafeMath.mul(spin.tokenValue, 25);
305                     category = 6;
306                     emit ThreeHSymbols(target, spin.blockn);
307             } else 
308                 if (result < 14443) {
309                     // Player has won a three Ether icon prize
310                     profit = SafeMath.mul(spin.tokenValue, 50);
311                     category = 7;
312                     emit ThreeEtherIcons(target, spin.blockn);
313             } else 
314                 if (result < 17272) {
315                     // Player has won a three green pyramid prize
316                     profit = SafeMath.mul(spin.tokenValue, 40);
317                     category = 8;
318                     emit ThreeGreenPyramids(target, spin.blockn);
319             } else 
320                 if (result < 20101) {
321                     // Player has won a three gold pyramid prize
322                     profit = SafeMath.mul(spin.tokenValue, 20);
323                     category = 9;
324                     emit ThreeGoldPyramids(target, spin.blockn);
325             } else 
326                 if (result < 22929) {
327                     // Player has won a three white pyramid prize
328                     profit = SafeMath.mul(spin.tokenValue, 20);
329                     category = 10;
330                     emit ThreeWhitePyramids(target, spin.blockn);
331             } else 
332                 if (result < 52332) {
333                     // Player has won a one moon prize!
334                     profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 125),10);
335                     category = 11;
336                     emit OneMoonPrize(target, spin.blockn);
337             } else 
338                 if (result < 120225) {
339                     // Player has won a each-coloured-pyramid prize!
340                     profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 15),10);
341                     category = 12;
342                     emit OneOfEachPyramidPrize(target, spin.blockn);
343             } else 
344                 if (result < 171146) {
345                     // Player has won a two Z symbol prize!
346                     profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 232),100);
347                     category = 13;
348                     emit TwoZSymbols(target, spin.blockn);
349             } else 
350                 if (result < 222067) {
351                     // Player has won a two T symbol prize!
352                     profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 232),100);
353                     category = 14;
354                     emit TwoTSymbols(target, spin.blockn);
355             } else 
356                 if (result < 272988) {
357                     // Player has won a two H symbol prize!
358                     profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 232),100);
359                     category = 15;
360                     emit TwoHSymbols(target, spin.blockn);
361             } else 
362                 if (result < 323909) {
363                     // Player has won a two Ether icon prize!
364                     profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 375),100);
365                     category = 16;
366                     emit TwoEtherIcons(target, spin.blockn);
367             } else 
368                 if (result < 374830) {
369                     // Player has won a two green pyramid prize!
370                     profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 35),10);
371                     category = 17;
372                     emit TwoGreenPyramids(target, spin.blockn);
373             } else 
374                 if (result < 425751) {
375                     // Player has won a two gold pyramid prize!
376                     profit = SafeMath.div(SafeMath.mul(spin.tokenValue, 225),100);
377                     category = 18;
378                     emit TwoGoldPyramids(target, spin.blockn);
379             } else {
380                     // Player has won a two white pyramid prize!
381                     profit = SafeMath.mul(spin.tokenValue, 2);
382                     category = 19;
383                     emit TwoWhitePyramids(target, spin.blockn);
384             }
385 
386             emit LogResult(target, result, profit, spin.tokenValue, category, true);
387             contractBalance = contractBalance.sub(profit);
388             ZTHTKN.transfer(target, profit);
389             
390         //Reset playerSpin to default values.
391         playerSpins[target] = playerSpin(uint200(0), uint48(0));
392         return result;
393     }   
394 
395     // This sounds like a draconian function, but it actually just ensures that the contract has enough to pay out
396     // a jackpot at the rate you've selected (i.e. 5,000 ZTH for three-moon jackpot on a 10 ZTH roll).
397     // We do this by making sure that 25* your wager is no less than 90% of the amount currently held by the contract.
398     // If not, you're going to have to use lower betting amounts, we're afraid!
399     function jackpotGuard(uint _wager)
400         private
401         view
402         returns (bool)
403     {
404         uint maxProfit = SafeMath.mul(_wager, 500);
405         uint ninetyContractBalance = SafeMath.mul(SafeMath.div(contractBalance, 10), 9);
406         return (maxProfit <= ninetyContractBalance);
407     }
408 
409     // Returns a random number using a specified block number
410     // Always use a FUTURE block number.
411     function maxRandom(uint blockn, address entropy) private view returns (uint256 randomNumber) {
412     return uint256(keccak256(
413         abi.encodePacked(
414         blockhash(blockn),
415         entropy)
416       ));
417     }
418 
419     // Random helper
420     function random(uint256 upper, uint256 blockn, address entropy) internal view returns (uint256 randomNumber) {
421     return maxRandom(blockn, entropy) % upper;
422     }
423 
424     // How many tokens are in the contract overall?
425     function balanceOf() public view returns (uint) {
426         return contractBalance;
427     }
428 
429     function addNewBetAmount(uint _tokenAmount)
430         public
431         onlyOwner
432     {
433         validTokenBet[_tokenAmount] = true;
434     }
435 
436     // If, for any reason, betting needs to be paused (very unlikely), this will freeze all bets.
437     function pauseGame() public onlyOwner {
438         gameActive = false;
439     }
440 
441     // The converse of the above, resuming betting if a freeze had been put in place.
442     function resumeGame() public onlyOwner {
443         gameActive = true;
444     }
445 
446     // Administrative function to change the owner of the contract.
447     function changeOwner(address _newOwner) public onlyOwner {
448         owner = _newOwner;
449     }
450 
451     // Administrative function to change the Zethr bankroll contract, should the need arise.
452     function changeBankroll(address _newBankroll) public onlyOwner {
453         bankroll = _newBankroll;
454     }
455 
456     function divertDividendsToBankroll()
457         public
458         onlyOwner
459     {
460         bankroll.transfer(address(this).balance);
461     }
462 
463     // Is the address that the token has come from actually ZTH?
464     function _zthToken(address _tokenContract) private view returns (bool) {
465        return _tokenContract == ZTHTKNADDR;
466     }
467 }
468 
469 // And here's the boring bit.
470 
471 /**
472  * @title SafeMath
473  * @dev Math operations with safety checks that throw on error
474  */
475 library SafeMath {
476 
477     /**
478     * @dev Multiplies two numbers, throws on overflow.
479     */
480     function mul(uint a, uint b) internal pure returns (uint) {
481         if (a == 0) {
482             return 0;
483         }
484         uint c = a * b;
485         assert(c / a == b);
486         return c;
487     }
488 
489     /**
490     * @dev Integer division of two numbers, truncating the quotient.
491     */
492     function div(uint a, uint b) internal pure returns (uint) {
493         // assert(b > 0); // Solidity automatically throws when dividing by 0
494         uint c = a / b;
495         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
496         return c;
497     }
498 
499     /**
500     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
501     */
502     function sub(uint a, uint b) internal pure returns (uint) {
503         assert(b <= a);
504         return a - b;
505     }
506 
507     /**
508     * @dev Adds two numbers, throws on overflow.
509     */
510     function add(uint a, uint b) internal pure returns (uint) {
511         uint c = a + b;
512         assert(c >= a);
513         return c;
514     }
515 }