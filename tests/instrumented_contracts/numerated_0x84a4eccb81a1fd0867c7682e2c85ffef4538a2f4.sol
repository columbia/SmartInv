1 /*
2     SPDX-License-Identifier: MIT
3     A Bankteller Production
4     Bankroll Network
5     Copyright 2020
6 */
7 pragma solidity ^0.4.25;
8 
9 
10 contract Token {
11     function transferFrom(address from, address to, uint256 value) public returns (bool);
12 
13     function transfer(address to, uint256 value) public returns (bool);
14 
15     function balanceOf(address who) public view returns (uint256);
16 }
17 
18 
19 /*
20  * @dev Life is a perpetual rewards contract the collects 9% fee for a dividend pool that drips 2% daily.
21  * A 1% fee is used to buy back a specified ERC20/TRC20 token and distribute to LYF holders via a 2% drip
22 */
23 
24 
25 contract BankrollNetworkStack  {
26 
27     using SafeMath for uint;
28 
29     /*=================================
30     =            MODIFIERS            =
31     =================================*/
32 
33     /// @dev Only people with tokens
34     modifier onlyBagholders {
35         require(myTokens() > 0);
36         _;
37     }
38 
39     /// @dev Only people with profits
40     modifier onlyStronghands {
41         require(myDividends() > 0);
42         _;
43     }
44 
45 
46 
47     /*==============================
48     =            EVENTS            =
49     ==============================*/
50 
51 
52     event onLeaderBoard(
53         address indexed customerAddress,
54         uint256 invested,
55         uint256 tokens,
56         uint256 soldTokens,
57         uint timestamp
58     );
59 
60     event onTokenPurchase(
61         address indexed customerAddress,
62         uint256 incomingeth,
63         uint256 tokensMinted,
64         uint timestamp
65     );
66 
67     event onTokenSell(
68         address indexed customerAddress,
69         uint256 tokensBurned,
70         uint256 ethEarned,
71         uint timestamp
72     );
73 
74     event onReinvestment(
75         address indexed customerAddress,
76         uint256 ethReinvested,
77         uint256 tokensMinted,
78         uint timestamp
79     );
80 
81     event onWithdraw(
82         address indexed customerAddress,
83         uint256 ethWithdrawn,
84         uint timestamp
85     );
86 
87 
88     event onTransfer(
89         address indexed from,
90         address indexed to,
91         uint256 tokens,
92         uint timestamp
93     );
94 
95     event onBalance(
96         uint256 balance,
97         uint256 timestamp
98     );
99 
100     event onDonation(
101         address indexed from,
102         uint256 amount,
103         uint timestamp
104     );
105 
106     // Onchain Stats!!!
107     struct Stats {
108         uint invested;
109         uint reinvested;
110         uint withdrawn;
111         uint rewarded;
112         uint contributed;
113         uint transferredTokens;
114         uint receivedTokens;
115         uint xInvested;
116         uint xReinvested;
117         uint xRewarded;
118         uint xContributed;
119         uint xWithdrawn;
120         uint xTransferredTokens;
121         uint xReceivedTokens;
122     }
123 
124 
125     /*=====================================
126     =            CONFIGURABLES            =
127     =====================================*/
128 
129     /// @dev 15% dividends for token purchase
130     uint8 constant internal entryFee_ = 10;
131 
132 
133     /// @dev 5% dividends for token selling
134     uint8 constant internal exitFee_ = 10;
135 
136     uint8 constant internal dripFee = 80;  //80% of fees go to drip, the rest to the Swap buyback
137 
138     uint8 constant payoutRate_ = 2;
139 
140     uint256 constant internal magnitude = 2 ** 64;
141 
142     /*=================================
143      =            DATASETS            =
144      ================================*/
145 
146     // amount of shares for each address (scaled number)
147     mapping(address => uint256) private tokenBalanceLedger_;
148     mapping(address => int256) private payoutsTo_;
149     mapping(address => Stats) private stats;
150     //on chain referral tracking
151     uint256 private tokenSupply_;
152     uint256 private profitPerShare_;
153     uint256 public totalDeposits;
154     uint256 internal lastBalance_;
155 
156     uint public players;
157     uint public totalTxs;
158     uint public dividendBalance_;
159     uint public lastPayout;
160     uint public totalClaims;
161 
162     uint256 public balanceInterval = 6 hours;
163     uint256 public distributionInterval = 2 seconds;
164 
165     address public tokenAddress;
166 
167     Token private token;
168 
169 
170     /*=======================================
171     =            PUBLIC FUNCTIONS           =
172     =======================================*/
173 
174     constructor(address _tokenAddress) public {
175 
176         tokenAddress = _tokenAddress;
177         token = Token(_tokenAddress);
178 
179         lastPayout = now;
180 
181     }
182 
183 
184     /// @dev This is how you pump pure "drip" dividends into the system
185     function donatePool(uint amount) public returns (uint256) {
186         require(token.transferFrom(msg.sender, address(this),amount));
187 
188         dividendBalance_ += amount;
189 
190         emit onDonation(msg.sender, amount,now);
191     }
192 
193     /// @dev Converts all incoming eth to tokens for the caller, and passes down the referral addy (if any)
194     function buy(uint buy_amount) public returns (uint256)  {
195         return buyFor(msg.sender, buy_amount);
196     }
197 
198 
199     /// @dev Converts all incoming eth to tokens for the caller, and passes down the referral addy (if any)
200     function buyFor(address _customerAddress, uint buy_amount) public returns (uint256)  {
201         require(token.transferFrom(_customerAddress, address(this), buy_amount));
202         totalDeposits += buy_amount;
203         uint amount = purchaseTokens(_customerAddress, buy_amount);
204 
205         emit onLeaderBoard(_customerAddress,
206             stats[_customerAddress].invested,
207             tokenBalanceLedger_[_customerAddress],
208             stats[_customerAddress].withdrawn,
209             now
210         );
211 
212         //distribute
213         distribute();
214 
215         return amount;
216     }
217 
218 
219 
220 
221     /**
222      * @dev Fallback function to return any TRX/ETH accidentally sent to the contract
223      */
224     function() payable public {
225         require(false);
226     }
227 
228     /// @dev Converts all of caller's dividends to tokens.
229     function reinvest() onlyStronghands public {
230         // fetch dividends
231         uint256 _dividends = myDividends();
232         // retrieve ref. bonus later in the code
233 
234         // pay out the dividends virtually
235         address _customerAddress = msg.sender;
236         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
237 
238         // dispatch a buy order with the virtualized "withdrawn dividends"
239         uint256 _tokens = purchaseTokens(msg.sender, _dividends);
240 
241         // fire event
242         emit onReinvestment(_customerAddress, _dividends, _tokens, now);
243 
244         //Stats
245         stats[_customerAddress].reinvested = SafeMath.add(stats[_customerAddress].reinvested, _dividends);
246         stats[_customerAddress].xReinvested += 1;
247 
248         emit onLeaderBoard(_customerAddress,
249             stats[_customerAddress].invested,
250             tokenBalanceLedger_[_customerAddress],
251             stats[_customerAddress].withdrawn,
252             now
253         );
254 
255         //distribute
256         distribute();
257     }
258 
259     /// @dev Withdraws all of the callers earnings.
260     function withdraw() onlyStronghands public {
261         // setup data
262         address _customerAddress = msg.sender;
263         uint256 _dividends = myDividends();
264 
265         // update dividend tracker
266         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
267 
268 
269         // lambo delivery service
270         token.transfer(_customerAddress,_dividends);
271 
272         //stats
273         stats[_customerAddress].withdrawn = SafeMath.add(stats[_customerAddress].withdrawn, _dividends);
274         stats[_customerAddress].xWithdrawn += 1;
275         totalTxs += 1;
276         totalClaims += _dividends;
277 
278         // fire event
279         emit onWithdraw(_customerAddress, _dividends, now);
280 
281         //distribute
282         distribute();
283     }
284 
285 
286     /// @dev Liquifies tokens to eth.
287     function sell(uint256 _amountOfTokens) onlyBagholders public {
288         // setup data
289         address _customerAddress = msg.sender;
290 
291         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
292 
293 
294         // data setup
295         uint256 _undividedDividends = SafeMath.mul(_amountOfTokens, exitFee_) / 100;
296         uint256 _taxedeth = SafeMath.sub(_amountOfTokens, _undividedDividends);
297 
298         //drip and buybacks
299         allocateFees(_undividedDividends);
300 
301         // burn the sold tokens
302         tokenSupply_ = SafeMath.sub(tokenSupply_, _amountOfTokens);
303         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
304 
305         // update dividends tracker
306         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens + (_taxedeth * magnitude));
307         payoutsTo_[_customerAddress] -= _updatedPayouts;
308 
309         // fire event
310         emit onTokenSell(_customerAddress, _amountOfTokens, _taxedeth, now);
311 
312         emit onLeaderBoard(_customerAddress,
313             stats[_customerAddress].invested,
314             tokenBalanceLedger_[_customerAddress],
315             stats[_customerAddress].withdrawn,
316             now
317         );
318 
319         //distribute
320         distribute();
321     }
322 
323     /**
324     * @dev Transfer tokens from the caller to a new holder.
325     *  Zero fees
326     */
327     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders external returns (bool) {
328         // setup
329         address _customerAddress = msg.sender;
330 
331         // make sure we have the requested tokens
332         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
333 
334         // withdraw all outstanding dividends first
335         if (myDividends() > 0) {
336             withdraw();
337         }
338 
339 
340         // exchange tokens
341         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
342         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
343 
344         // update dividend trackers
345         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
346         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
347 
348 
349 
350         /* Members
351             A player can be initialized by buying or receiving and we want to add the user ASAP
352          */
353         if (stats[_toAddress].invested == 0 && stats[_toAddress].receivedTokens == 0) {
354             players += 1;
355         }
356 
357         //Stats
358         stats[_customerAddress].xTransferredTokens += 1;
359         stats[_customerAddress].transferredTokens += _amountOfTokens;
360         stats[_toAddress].receivedTokens += _amountOfTokens;
361         stats[_toAddress].xReceivedTokens += 1;
362         totalTxs += 1;
363 
364         // fire event
365         emit onTransfer(_customerAddress, _toAddress, _amountOfTokens,now);
366 
367         emit onLeaderBoard(_customerAddress,
368             stats[_customerAddress].invested,
369             tokenBalanceLedger_[_customerAddress],
370             stats[_customerAddress].withdrawn,
371             now
372         );
373 
374         emit onLeaderBoard(_toAddress,
375             stats[_toAddress].invested,
376             tokenBalanceLedger_[_toAddress],
377             stats[_toAddress].withdrawn,
378             now
379         );
380 
381         // ERC20
382         return true;
383     }
384 
385 
386     /*=====================================
387     =      HELPERS AND CALCULATORS        =
388     =====================================*/
389 
390     /**
391      * @dev Method to view the current eth stored in the contract
392      */
393     function totalTokenBalance() public view returns (uint256) {
394         return token.balanceOf(address(this));
395     }
396 
397     /// @dev Retrieve the total token supply.
398     function totalSupply() public view returns (uint256) {
399         return tokenSupply_;
400     }
401 
402     /// @dev Retrieve the tokens owned by the caller.
403     function myTokens() public view returns (uint256) {
404         address _customerAddress = msg.sender;
405         return balanceOf(_customerAddress);
406     }
407 
408     /**
409      * @dev Retrieve the dividends owned by the caller.
410      */
411     function myDividends() public view returns (uint256) {
412         address _customerAddress = msg.sender;
413         return dividendsOf(_customerAddress);
414     }
415 
416     /// @dev Retrieve the token balance of any single address.
417     function balanceOf(address _customerAddress) public view returns (uint256) {
418         return tokenBalanceLedger_[_customerAddress];
419     }
420 
421     /// @dev Retrieve the token balance of any single address.
422     function tokenBalance(address _customerAddress) public view returns (uint256) {
423         return _customerAddress.balance;
424     }
425 
426     /// @dev Retrieve the dividend balance of any single address.
427     function dividendsOf(address _customerAddress) public view returns (uint256) {
428         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
429     }
430 
431 
432     /// @dev Return the sell price of 1 individual token.
433     function sellPrice() public pure returns (uint256) {
434         uint256 _eth = 1e18;
435         uint256 _dividends = SafeMath.div(SafeMath.mul(_eth, exitFee_), 100);
436         uint256 _taxedeth = SafeMath.sub(_eth, _dividends);
437 
438         return _taxedeth;
439 
440     }
441 
442     /// @dev Return the buy price of 1 individual token.
443     function buyPrice() public pure returns (uint256) {
444         uint256 _eth = 1e18;
445         uint256 _dividends = SafeMath.div(SafeMath.mul(_eth, entryFee_), 100);
446         uint256 _taxedeth = SafeMath.add(_eth, _dividends);
447 
448         return _taxedeth;
449 
450     }
451 
452     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
453     function calculateTokensReceived(uint256 _ethToSpend) public pure returns (uint256) {
454         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethToSpend, entryFee_), 100);
455         uint256 _taxedeth = SafeMath.sub(_ethToSpend, _dividends);
456         uint256 _amountOfTokens = _taxedeth;
457 
458         return _amountOfTokens;
459     }
460 
461     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
462     function calculateethReceived(uint256 _tokensToSell) public view returns (uint256) {
463         require(_tokensToSell <= tokenSupply_);
464         uint256 _eth = _tokensToSell;
465         uint256 _dividends = SafeMath.div(SafeMath.mul(_eth, exitFee_), 100);
466         uint256 _taxedeth = SafeMath.sub(_eth, _dividends);
467         return _taxedeth;
468     }
469 
470 
471     /// @dev Stats of any single address
472     function statsOf(address _customerAddress) public view returns (uint256[14] memory){
473         Stats memory s = stats[_customerAddress];
474         uint256[14] memory statArray = [s.invested, s.withdrawn, s.rewarded, s.contributed, s.transferredTokens, s.receivedTokens, s.xInvested, s.xRewarded, s.xContributed, s.xWithdrawn, s.xTransferredTokens, s.xReceivedTokens, s.reinvested, s.xReinvested];
475         return statArray;
476     }
477 
478 
479     function dailyEstimate(address _customerAddress) public view returns (uint256){
480         uint256 share = dividendBalance_.mul(payoutRate_).div(100);
481 
482         return (tokenSupply_ > 0) ? share.mul(tokenBalanceLedger_[_customerAddress]).div(tokenSupply_) : 0;
483     }
484 
485 
486     function allocateFees(uint fee) private {
487         //Add to dividend drip pools
488         dividendBalance_ += fee;
489     }
490 
491     function distribute() private {
492 
493         if (now.safeSub(lastBalance_) > balanceInterval) {
494             emit onBalance(totalTokenBalance(), now);
495             lastBalance_ = now;
496         }
497 
498 
499         if (SafeMath.safeSub(now, lastPayout) > distributionInterval && tokenSupply_ > 0) {
500 
501             //A portion of the dividend is paid out according to the rate
502             uint256 share = dividendBalance_.mul(payoutRate_).div(100).div(24 hours);
503             //divide the profit by seconds in the day
504             uint256 profit = share * now.safeSub(lastPayout);
505             //share times the amount of time elapsed
506             dividendBalance_ = dividendBalance_.safeSub(profit);
507 
508             //Apply divs
509             profitPerShare_ = SafeMath.add(profitPerShare_, (profit * magnitude) / tokenSupply_);
510 
511             lastPayout = now;
512         }
513 
514     }
515 
516 
517 
518     /*==========================================
519     =            INTERNAL FUNCTIONS            =
520     ==========================================*/
521 
522     /// @dev Internal function to actually purchase the tokens.
523     function purchaseTokens(address _customerAddress, uint256 _incomingeth) internal returns (uint256) {
524 
525         /* Members */
526         if (stats[_customerAddress].invested == 0 && stats[_customerAddress].receivedTokens == 0) {
527             players += 1;
528         }
529 
530         totalTxs += 1;
531 
532         // data setup
533         uint256 _undividedDividends = SafeMath.mul(_incomingeth, entryFee_) / 100;
534         uint256 _amountOfTokens = SafeMath.sub(_incomingeth, _undividedDividends);
535 
536         //drip and buybacks
537         allocateFees(_undividedDividends);
538 
539         // fire event
540         emit onTokenPurchase(_customerAddress, _incomingeth, _amountOfTokens, now);
541 
542         // yes we know that the safemath function automatically rules out the "greater then" equation.
543         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
544 
545 
546         // we can't give people infinite eth
547         if (tokenSupply_ > 0) {
548             // add tokens to the pool
549             tokenSupply_ += _amountOfTokens;
550 
551         } else {
552             // add tokens to the pool
553             tokenSupply_ = _amountOfTokens;
554         }
555 
556         // update circulating supply & the ledger address for the customer
557         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
558 
559         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
560         // really i know you think you do but you don't
561         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens);
562         payoutsTo_[_customerAddress] += _updatedPayouts;
563 
564 
565         //Stats
566         stats[_customerAddress].invested += _incomingeth;
567         stats[_customerAddress].xInvested += 1;
568 
569         return _amountOfTokens;
570     }
571 
572 
573 }
574 
575 /**
576  * @title SafeMath
577  * @dev Math operations with safety checks that throw on error
578  */
579 library SafeMath {
580 
581     /**
582     * @dev Multiplies two numbers, throws on overflow.
583     */
584     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
585         if (a == 0) {
586             return 0;
587         }
588         c = a * b;
589         assert(c / a == b);
590         return c;
591     }
592 
593     /**
594     * @dev Integer division of two numbers, truncating the quotient.
595     */
596     function div(uint256 a, uint256 b) internal pure returns (uint256) {
597         // assert(b > 0); // Solidity automatically throws when dividing by 0
598         // uint256 c = a / b;
599         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
600         return a / b;
601     }
602 
603     /**
604     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
605     */
606     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
607         assert(b <= a);
608         return a - b;
609     }
610 
611     /* @dev Subtracts two numbers, else returns zero */
612     function safeSub(uint a, uint b) internal pure returns (uint) {
613         if (b > a) {
614             return 0;
615         } else {
616             return a - b;
617         }
618     }
619 
620     /**
621     * @dev Adds two numbers, throws on overflow.
622     */
623     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
624         c = a + b;
625         assert(c >= a);
626         return c;
627     }
628 
629     function max(uint256 a, uint256 b) internal pure returns (uint256) {
630         return a >= b ? a : b;
631     }
632 
633     function min(uint256 a, uint256 b) internal pure returns (uint256) {
634         return a < b ? a : b;
635     }
636 }