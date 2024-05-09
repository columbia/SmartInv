1 /*
2     SPDX-License-Identifier: MIT
3     A Bankteller Production
4     Bankroll Network
5     Copyright 2020
6 */
7 pragma solidity ^0.4.25;
8 
9 
10 
11 contract Token {
12     function transferFrom(address from, address to, uint256 value) public returns (bool);
13     function transfer(address to, uint256 value) public returns (bool);
14     function balanceOf(address who) public view returns (uint256);
15 }
16 
17 contract UniSwapV2LiteRouter {
18 
19     //function ethToTokenSwapInput(uint256 min_tokens) public payable returns (uint256);
20     function WETH() external pure returns (address);
21     function swapExactETHForTokens(uint amountOutMin, address[] path, address to, uint deadline) external payable returns (uint[] amounts);
22 }
23 
24 /*
25  * @dev Life is a perpetual rewards contract the collects 9% fee for a dividend pool that drips 2% daily.
26  * A 1% fee is used to buy back a specified ERC20/TRC20 token and distribute to LYF holders via a 2% drip
27 */
28 
29 
30 contract BankrollNetworkLife {
31 
32     using SafeMath for uint;
33 
34     /*=================================
35     =            MODIFIERS            =
36     =================================*/
37 
38     /// @dev Only people with tokens
39     modifier onlyBagholders {
40         require(myTokens() > 0);
41         _;
42     }
43 
44     /// @dev Only people with profits
45     modifier onlyStronghands {
46         require(myDividends() > 0);
47         _;
48     }
49 
50 
51 
52     /*==============================
53     =            EVENTS            =
54     ==============================*/
55 
56 
57     event onLeaderBoard(
58         address indexed customerAddress,
59         uint256 invested,
60         uint256 tokens,
61         uint256 soldTokens,
62         uint256 claims,
63         uint256 timestamp
64     );
65 
66     event onTokenPurchase(
67         address indexed customerAddress,
68         uint256 incomingeth,
69         uint256 tokensMinted,
70         uint timestamp
71     );
72 
73     event onTokenSell(
74         address indexed customerAddress,
75         uint256 tokensBurned,
76         uint256 ethEarned,
77         uint timestamp
78     );
79 
80     event onReinvestment(
81         address indexed customerAddress,
82         uint256 ethReinvested,
83         uint256 tokensMinted,
84         uint256 timestamp
85     );
86 
87     event onWithdraw(
88         address indexed customerAddress,
89         uint256 ethWithdrawn,
90         uint256 timestamp
91     );
92 
93     event onClaim(
94         address indexed customerAddress,
95         uint256 tokens,
96         uint256 timestamp
97     );
98 
99     event onTransfer(
100         address indexed from,
101         address indexed to,
102         uint256 tokens,
103         uint256 timestamp
104     );
105 
106     event onBuyBack(
107         uint ethAmount,
108         uint tokenAmount,
109         uint256 timestamp
110     );
111 
112 
113     event onBalance(
114         uint256 balance,
115         uint256 timestamp
116     );
117 
118     event onDonation(
119         address indexed from,
120         uint256 amount,
121         uint256 timestamp
122     );
123 
124     // Onchain Stats!!!
125     struct Stats {
126         uint invested;
127         uint reinvested;
128         uint withdrawn;
129         uint claims;
130         uint rewarded;
131         uint contributed;
132         uint transferredTokens;
133         uint receivedTokens;
134         int256 tokenPayoutsTo;
135         uint xInvested;
136         uint xReinvested;
137         uint xRewarded;
138         uint xContributed;
139         uint xWithdrawn;
140         uint xTransferredTokens;
141         uint xReceivedTokens;
142         uint xClaimed;
143     }
144 
145 
146     /*=====================================
147     =            CONFIGURABLES            =
148     =====================================*/
149 
150     /// @dev 15% dividends for token purchase
151     uint8 constant internal entryFee_ = 10;
152 
153 
154     /// @dev 5% dividends for token selling
155     uint8 constant internal exitFee_ = 10;
156 
157     uint8 constant internal dripFee = 80;  //80% of fees go to drip, the rest to the Swap buyback
158 
159     uint8 constant payoutRate_ = 2;
160 
161     uint256 constant internal magnitude = 2 ** 64;
162 
163     /*=================================
164      =            DATASETS            =
165      ================================*/
166 
167     // amount of shares for each address (scaled number)
168     mapping(address => uint256) private tokenBalanceLedger_;
169     mapping(address => int256) private payoutsTo_;
170     mapping(address => Stats) private stats;
171     //on chain referral tracking
172     uint256 private tokenSupply_;
173     uint256 private profitPerShare_;
174     uint256 private rewardsProfitPerShare_;
175     uint256 public totalDeposits;
176     uint256 internal lastBalance_;
177 
178     uint public players;
179     uint public totalTxs;
180     uint public dividendBalance_;
181     uint public swapCollector_;
182     uint public swapBalance_;
183     uint public lastPayout;
184     uint public totalClaims;
185 
186     uint256 public balanceInterval = 6 hours;
187     uint256 public distributionInterval = 2 seconds;
188     uint256 public depotFlushSize = 0.5 ether;
189 
190 
191     address public swapAddress;
192     address public tokenAddress;
193 
194     Token private token;
195     UniSwapV2LiteRouter private swap;
196 
197 
198     /*=======================================
199     =            PUBLIC FUNCTIONS           =
200     =======================================*/
201 
202     constructor(address _tokenAddress, address _swapAddress) public {
203 
204         tokenAddress = _tokenAddress;
205         token = Token(_tokenAddress);
206 
207         swapAddress = _swapAddress;
208         swap = UniSwapV2LiteRouter(_swapAddress);
209 
210         lastPayout = now;
211 
212     }
213 
214 
215     /// @dev This is how you pump pure "drip" dividends into the system
216     function donatePool() public payable returns (uint256) {
217         require(msg.value > 0);
218 
219         dividendBalance_ += msg.value;
220 
221         emit onDonation(msg.sender, msg.value,now);
222     }
223 
224     /// @dev Converts all incoming eth to tokens for the caller, and passes down the referral addy (if any)
225     function buy() public payable returns (uint256)  {
226         return buyFor(msg.sender);
227     }
228 
229 
230     /// @dev Converts all incoming eth to tokens for the caller, and passes down the referral addy (if any)
231     function buyFor(address _customerAddress) public payable returns (uint256)  {
232         require(msg.value > 0);
233         totalDeposits += msg.value;
234         uint amount = purchaseTokens(_customerAddress, msg.value);
235 
236         emit onLeaderBoard(_customerAddress,
237             stats[_customerAddress].invested,
238             tokenBalanceLedger_[_customerAddress],
239             stats[_customerAddress].withdrawn,
240             stats[_customerAddress].claims,
241             now
242         );
243 
244         //distribute
245         distribute();
246 
247         return amount;
248     }
249 
250 
251 
252 
253     /**
254      * @dev Fallback function to handle eth that was send straight to the contract
255      *  Unfortunately we cannot use a referral address this way.
256      */
257     function() payable public {
258         donatePool();
259     }
260 
261     /// @dev Converts all of caller's dividends to tokens.
262     function reinvest() onlyStronghands public {
263         // fetch dividends
264         uint256 _dividends = myDividends();
265         // retrieve ref. bonus later in the code
266 
267         // pay out the dividends virtually
268         address _customerAddress = msg.sender;
269         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
270 
271         // dispatch a buy order with the virtualized "withdrawn dividends"
272         uint256 _tokens = purchaseTokens(msg.sender, _dividends);
273 
274         // fire event
275         emit onReinvestment(_customerAddress, _dividends, _tokens, now);
276 
277         //Stats
278         stats[_customerAddress].reinvested = SafeMath.add(stats[_customerAddress].reinvested, _dividends);
279         stats[_customerAddress].xReinvested += 1;
280 
281         emit onLeaderBoard(_customerAddress,
282             stats[_customerAddress].invested,
283             tokenBalanceLedger_[_customerAddress],
284             stats[_customerAddress].withdrawn,
285             stats[_customerAddress].claims,
286             now
287         );
288 
289         //distribute
290         distribute();
291     }
292 
293     /// @dev Withdraws all of the callers earnings.
294     function withdraw() onlyStronghands public {
295         // setup data
296         address _customerAddress = msg.sender;
297         uint256 _dividends = myDividends();
298 
299         // update dividend tracker
300         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
301 
302 
303         // lambo delivery service
304         _customerAddress.transfer(_dividends);
305 
306         //stats
307         stats[_customerAddress].withdrawn = SafeMath.add(stats[_customerAddress].withdrawn, _dividends);
308         stats[_customerAddress].xWithdrawn += 1;
309         totalTxs += 1;
310 
311         // fire event
312         emit onWithdraw(_customerAddress, _dividends,now);
313 
314         //distribute
315         distribute();
316     }
317 
318     /// @dev Withdraws all of the callers rewards.
319     function claim() public {
320         // setup data
321         address _customerAddress = msg.sender;
322         uint256 _dividends = myClaims();
323 
324         //only  to claim
325         require(_dividends > 0);
326 
327         // update dividend tracker
328         stats[_customerAddress].tokenPayoutsTo += (int256) (_dividends * magnitude);
329 
330 
331         // lambo delivery service
332         token.transfer(_customerAddress, _dividends);
333 
334         //stats
335         stats[_customerAddress].claims = SafeMath.add(stats[_customerAddress].claims, _dividends);
336         stats[_customerAddress].xClaimed += 1;
337         totalTxs += 1;
338 
339         // fire event
340         emit onClaim(_customerAddress, _dividends,now);
341 
342         emit onLeaderBoard(_customerAddress,
343             stats[_customerAddress].invested,
344             tokenBalanceLedger_[_customerAddress],
345             stats[_customerAddress].withdrawn,
346             stats[_customerAddress].claims,
347             now
348         );
349 
350         //distribute
351         distribute();
352     }
353 
354     /// @dev Liquifies tokens to eth.
355     function sell(uint256 _amountOfTokens) onlyBagholders public {
356         // setup data
357         address _customerAddress = msg.sender;
358 
359         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
360 
361 
362         // data setup
363         uint256 _undividedDividends = SafeMath.mul(_amountOfTokens, exitFee_) / 100;
364         uint256 _taxedeth = SafeMath.sub(_amountOfTokens, _undividedDividends);
365 
366         //drip and buybacks
367         allocateFees(_undividedDividends);
368 
369         // burn the sold tokens
370         tokenSupply_ = SafeMath.sub(tokenSupply_, _amountOfTokens);
371         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
372 
373         // update dividends tracker
374         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens + (_taxedeth * magnitude));
375         payoutsTo_[_customerAddress] -= _updatedPayouts;
376 
377         //update claims tracker; don't need to redeem extra claims
378         stats[_customerAddress].tokenPayoutsTo -= (int256) (rewardsProfitPerShare_ * _amountOfTokens);
379 
380 
381         // fire event
382         emit onTokenSell(_customerAddress, _amountOfTokens, _taxedeth, now);
383 
384         emit onLeaderBoard(_customerAddress,
385             stats[_customerAddress].invested,
386             tokenBalanceLedger_[_customerAddress],
387             stats[_customerAddress].withdrawn,
388             stats[_customerAddress].claims,
389             now
390         );
391 
392         //distribute
393         distribute();
394     }
395 
396     /**
397     * @dev Transfer tokens from the caller to a new holder.
398     *  Zero fees
399     */
400     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders external returns (bool) {
401         // setup
402         address _customerAddress = msg.sender;
403 
404         // make sure we have the requested tokens
405         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
406 
407         // withdraw all outstanding dividends first
408         if (myDividends() > 0) {
409             withdraw();
410         }
411 
412 
413         // exchange tokens
414         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
415         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
416 
417         // update dividend trackers
418         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
419         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
420 
421         //update claims tracker
422         stats[_customerAddress].tokenPayoutsTo -= (int256) (rewardsProfitPerShare_ * _amountOfTokens);
423         stats[_toAddress].tokenPayoutsTo += (int256) (rewardsProfitPerShare_ * _amountOfTokens);
424 
425 
426 
427 
428         /* Members
429             A player can be initialized by buying or receiving and we want to add the user ASAP
430          */
431         if (stats[_toAddress].invested == 0 && stats[_toAddress].receivedTokens == 0) {
432             players += 1;
433         }
434 
435         //Stats
436         stats[_customerAddress].xTransferredTokens += 1;
437         stats[_customerAddress].transferredTokens += _amountOfTokens;
438         stats[_toAddress].receivedTokens += _amountOfTokens;
439         stats[_toAddress].xReceivedTokens += 1;
440         totalTxs += 1;
441 
442         // fire event
443         emit onTransfer(_customerAddress, _toAddress, _amountOfTokens,now);
444 
445         emit onLeaderBoard(_customerAddress,
446             stats[_customerAddress].invested,
447             tokenBalanceLedger_[_customerAddress],
448             stats[_customerAddress].withdrawn,
449             stats[_customerAddress].claims,
450             now
451         );
452 
453         emit onLeaderBoard(_toAddress,
454             stats[_toAddress].invested,
455             tokenBalanceLedger_[_toAddress],
456             stats[_toAddress].withdrawn,
457             stats[_toAddress].claims,
458             now
459         );
460 
461         // ERC20
462         return true;
463     }
464 
465 
466     /*=====================================
467     =      HELPERS AND CALCULATORS        =
468     =====================================*/
469 
470     /**
471      * @dev Method to view the current eth stored in the contract
472      */
473     function totalEthBalance() public view returns (uint256) {
474         return address(this).balance;
475     }
476 
477     /// @dev Retrieve the total token supply.
478     function totalSupply() public view returns (uint256) {
479         return tokenSupply_;
480     }
481 
482     /// @dev Retrieve the tokens owned by the caller.
483     function myTokens() public view returns (uint256) {
484         address _customerAddress = msg.sender;
485         return balanceOf(_customerAddress);
486     }
487 
488     /**
489      * @dev Retrieve the dividends owned by the caller.
490      */
491     function myDividends() public view returns (uint256) {
492         address _customerAddress = msg.sender;
493         return dividendsOf(_customerAddress);
494     }
495 
496     /**
497      * @dev Retrieve token claims owned by the caller.
498      */
499     function myClaims() public view returns (uint256) {
500         address _customerAddress = msg.sender;
501         return claimsOf(_customerAddress);
502     }
503 
504 
505 
506     /// @dev Retrieve the token balance of any single address.
507     function balanceOf(address _customerAddress) public view returns (uint256) {
508         return tokenBalanceLedger_[_customerAddress];
509     }
510 
511     /// @dev Retrieve the token balance of any single address.
512     function tokenBalance(address _customerAddress) public view returns (uint256) {
513         return _customerAddress.balance;
514     }
515 
516     /// @dev Retrieve the dividend balance of any single address.
517     function dividendsOf(address _customerAddress) public view returns (uint256) {
518         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
519     }
520 
521     /// @dev Retrieve the claims balance of any single address.
522     function claimsOf(address _customerAddress) public view returns (uint256) {
523         return (uint256) ((int256) (rewardsProfitPerShare_ * tokenBalanceLedger_[_customerAddress]) - stats[_customerAddress].tokenPayoutsTo) / magnitude;
524     }
525 
526     /// @dev Return the sell price of 1 individual token.
527     function sellPrice() public pure returns (uint256) {
528         uint256 _eth = 1e18;
529         uint256 _dividends = SafeMath.div(SafeMath.mul(_eth, exitFee_), 100);
530         uint256 _taxedeth = SafeMath.sub(_eth, _dividends);
531 
532         return _taxedeth;
533 
534     }
535 
536     /// @dev Return the buy price of 1 individual token.
537     function buyPrice() public pure returns (uint256) {
538         uint256 _eth = 1e18;
539         uint256 _dividends = SafeMath.div(SafeMath.mul(_eth, entryFee_), 100);
540         uint256 _taxedeth = SafeMath.add(_eth, _dividends);
541 
542         return _taxedeth;
543 
544     }
545 
546     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
547     function calculateTokensReceived(uint256 _ethToSpend) public pure returns (uint256) {
548         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethToSpend, entryFee_), 100);
549         uint256 _taxedeth = SafeMath.sub(_ethToSpend, _dividends);
550         uint256 _amountOfTokens = _taxedeth;
551 
552         return _amountOfTokens;
553     }
554 
555     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
556     function calculateethReceived(uint256 _tokensToSell) public view returns (uint256) {
557         require(_tokensToSell <= tokenSupply_);
558         uint256 _eth = _tokensToSell;
559         uint256 _dividends = SafeMath.div(SafeMath.mul(_eth, exitFee_), 100);
560         uint256 _taxedeth = SafeMath.sub(_eth, _dividends);
561         return _taxedeth;
562     }
563 
564 
565     /// @dev Stats of any single address
566     function statsOf(address _customerAddress) public view returns (uint256[16] memory){
567         Stats memory s = stats[_customerAddress];
568         uint256[16] memory statArray = [s.invested, s.withdrawn, s.rewarded, s.contributed, s.transferredTokens, s.receivedTokens, s.xInvested, s.xRewarded, s.xContributed, s.xWithdrawn, s.xTransferredTokens, s.xReceivedTokens, s.reinvested, s.xReinvested, s.claims, s.xClaimed];
569         return statArray;
570     }
571 
572 
573     function dailyEstimate(address _customerAddress) public view returns (uint256){
574         uint256 share = dividendBalance_.mul(payoutRate_).div(100);
575 
576         return (tokenSupply_ > 0) ? share.mul(tokenBalanceLedger_[_customerAddress]).div(tokenSupply_) : 0;
577     }
578 
579     function dailyClaimEstimate(address _customerAddress) public view returns (uint256){
580         uint256 share = swapBalance_.mul(payoutRate_).div(100);
581 
582         return (tokenSupply_ > 0) ? share.mul(tokenBalanceLedger_[_customerAddress]).div(tokenSupply_) : 0;
583     }
584 
585     function allocateFees(uint fee) private {
586         uint _drip = SafeMath.mul(fee, dripFee) / 100;
587         uint _swap = SafeMath.safeSub(fee, _drip);
588 
589         //Add to dividend drip pools
590         dividendBalance_ += _drip;
591         swapCollector_ += _swap;
592     }
593 
594     function distribute() private {
595 
596         if (now.safeSub(lastBalance_) > balanceInterval) {
597             emit onBalance(totalEthBalance(), now);
598             lastBalance_ = now;
599         }
600 
601 
602         if (SafeMath.safeSub(now, lastPayout) > distributionInterval && tokenSupply_ > 0) {
603 
604             //A portion of the dividend is paid out according to the rate
605             uint256 share = dividendBalance_.mul(payoutRate_).div(100).div(24 hours);
606             //divide the profit by seconds in the day
607             uint256 profit = share * now.safeSub(lastPayout);
608             //share times the amount of time elapsed
609             dividendBalance_ = dividendBalance_.safeSub(profit);
610 
611             //Apply divs
612             profitPerShare_ = SafeMath.add(profitPerShare_, (profit * magnitude) / tokenSupply_);
613 
614 
615             //Don't distribute if we don't have  sufficient profit
616             //A portion of the dividend is paid out according to the rate
617             share = swapBalance_.mul(payoutRate_).div(100).div(24 hours);
618             //divide the profit by seconds in the day
619             profit = share * now.safeSub(lastPayout);
620 
621             //share times the amount of time elapsed
622             swapBalance_ = swapBalance_.safeSub(profit);
623 
624             //Apply claimed token divs
625             rewardsProfitPerShare_ = SafeMath.add(rewardsProfitPerShare_, (profit * magnitude) / tokenSupply_);
626 
627             lastPayout = now;
628 
629 
630             processBuyBacks();
631 
632         }
633 
634 
635     }
636 
637 
638     function processBuyBacks() private {
639 
640 
641         if (swapCollector_ >= depotFlushSize) {
642 
643             uint amount = swapCollector_;
644 
645             //reset Collector
646             swapCollector_ = 0;
647 
648             //VLT for ALL
649             uint _tokens = buyback(amount);
650 
651             totalClaims += _tokens;
652 
653             //Add to the pool
654             swapBalance_ += _tokens;
655 
656         }
657     }
658 
659     function buyback(uint amount) private returns (uint) {
660         address[] memory path = new address[](2);
661         path[0] = swap.WETH();
662         path[1] = tokenAddress;
663 
664 
665         uint[] memory amounts = swap.swapExactETHForTokens.value(amount)(1,path, address(this), now + 24 hours);
666 
667         //2nd index is token amount
668         emit onBuyBack(amount, amounts[1], now);
669 
670         return amounts[1];
671 
672     }
673 
674 
675 
676     /*==========================================
677     =            INTERNAL FUNCTIONS            =
678     ==========================================*/
679 
680     /// @dev Internal function to actually purchase the tokens.
681     function purchaseTokens(address _customerAddress, uint256 _incomingeth) internal returns (uint256) {
682 
683         /* Members */
684         if (stats[_customerAddress].invested == 0 && stats[_customerAddress].receivedTokens == 0) {
685             players += 1;
686         }
687 
688         totalTxs += 1;
689 
690         // data setup
691         uint256 _undividedDividends = SafeMath.mul(_incomingeth, entryFee_) / 100;
692         uint256 _amountOfTokens = SafeMath.sub(_incomingeth, _undividedDividends);
693 
694         //drip and buybacks
695         allocateFees(_undividedDividends);
696 
697         // fire event
698         emit onTokenPurchase(_customerAddress, _incomingeth, _amountOfTokens, now);
699 
700         // yes we know that the safemath function automatically rules out the "greater then" equation.
701         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
702 
703 
704         // we can't give people infinite eth
705         if (tokenSupply_ > 0) {
706             // add tokens to the pool
707             tokenSupply_ += _amountOfTokens;
708 
709         } else {
710             // add tokens to the pool
711             tokenSupply_ = _amountOfTokens;
712         }
713 
714         // update circulating supply & the ledger address for the customer
715         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
716 
717         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
718         // really i know you think you do but you don't
719         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens);
720         payoutsTo_[_customerAddress] += _updatedPayouts;
721 
722         _updatedPayouts = (int256) (rewardsProfitPerShare_ * _amountOfTokens);
723         stats[_customerAddress].tokenPayoutsTo += _updatedPayouts;
724 
725 
726         //Stats
727         stats[_customerAddress].invested += _incomingeth;
728         stats[_customerAddress].xInvested += 1;
729 
730         return _amountOfTokens;
731     }
732 
733 
734 }
735 
736 /**
737  * @title SafeMath
738  * @dev Math operations with safety checks that throw on error
739  */
740 library SafeMath {
741 
742     /**
743     * @dev Multiplies two numbers, throws on overflow.
744     */
745     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
746         if (a == 0) {
747             return 0;
748         }
749         c = a * b;
750         assert(c / a == b);
751         return c;
752     }
753 
754     /**
755     * @dev Integer division of two numbers, truncating the quotient.
756     */
757     function div(uint256 a, uint256 b) internal pure returns (uint256) {
758         // assert(b > 0); // Solidity automatically throws when dividing by 0
759         // uint256 c = a / b;
760         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
761         return a / b;
762     }
763 
764     /**
765     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
766     */
767     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
768         assert(b <= a);
769         return a - b;
770     }
771 
772     /* @dev Subtracts two numbers, else returns zero */
773     function safeSub(uint a, uint b) internal pure returns (uint) {
774         if (b > a) {
775             return 0;
776         } else {
777             return a - b;
778         }
779     }
780 
781     /**
782     * @dev Adds two numbers, throws on overflow.
783     */
784     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
785         c = a + b;
786         assert(c >= a);
787         return c;
788     }
789 
790     function max(uint256 a, uint256 b) internal pure returns (uint256) {
791         return a >= b ? a : b;
792     }
793 
794     function min(uint256 a, uint256 b) internal pure returns (uint256) {
795         return a < b ? a : b;
796     }
797 }