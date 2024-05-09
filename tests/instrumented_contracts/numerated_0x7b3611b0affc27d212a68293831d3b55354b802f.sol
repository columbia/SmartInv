1 /*
2     SPDX-License-Identifier: MIT
3     A Bankteller Production
4     Bankroll Network
5     Copyright 2020
6 */
7 pragma solidity ^0.4.25;
8 
9 
10 /**
11  * @title Ownable
12  * @dev The Ownable contract has an owner address, and provides basic authorization control
13  * functions, this simplifies the implementation of "user permissions".
14  */
15 contract Ownable {
16     address public owner;
17 
18 
19     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21 
22     /**
23      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24      * account.
25      */
26     constructor() public {
27         owner = msg.sender;
28     }
29 
30     /**
31      * @dev Throws if called by any account other than the owner.
32      */
33     modifier onlyOwner() {
34         require(msg.sender == owner);
35         _;
36     }
37 
38     /**
39      * @dev Allows the current owner to transfer control of the contract to a newOwner.
40      * @param newOwner The address to transfer ownership to.
41      */
42     function transferOwnership(address newOwner) public onlyOwner {
43         require(newOwner != address(0));
44         emit OwnershipTransferred(owner, newOwner);
45         owner = newOwner;
46     }
47 
48 }
49 
50 contract Token {
51     function approve(address spender, uint256 value) public returns (bool);
52 
53     function transferFrom(address from, address to, uint256 value) public returns (bool);
54 
55     function transfer(address to, uint256 value) public returns (bool);
56 
57     function balanceOf(address who) public view returns (uint256);
58 }
59 
60 contract UniSwapV2LiteRouter {
61 
62     //function ethToTokenSwapInput(uint256 min_tokens) public payable returns (uint256);
63     function WETH() external pure returns (address);
64 
65     function swapExactTokensForTokens(uint amountIn, uint amountOutMin, address[] path, address to, uint deadline) external returns (uint[] amounts);
66 
67     function getAmountsOut(uint amountIn, address[] path) external returns (uint[] amounts);
68 }
69 
70 /*
71  * @dev Life is a perpetual rewards contract the collects 9% fee for a dividend pool that drips 2% daily.
72  * A 1% fee is used to buy back a specified ERC20/TRC20 token and distribute to LYF holders via a 2% drip
73 */
74 
75 
76 contract BankrollNetworkStackPlus is Ownable {
77 
78     using SafeMath for uint;
79 
80     /*=================================
81     =            MODIFIERS            =
82     =================================*/
83 
84     /// @dev Only people with tokens
85     modifier onlyBagholders {
86         require(myTokens() > 0);
87         _;
88     }
89 
90     /// @dev Only people with profits
91     modifier onlyStronghands {
92         require(myDividends() > 0);
93         _;
94     }
95 
96 
97 
98     /*==============================
99     =            EVENTS            =
100     ==============================*/
101 
102 
103     event onLeaderBoard(
104         address indexed customerAddress,
105         uint256 invested,
106         uint256 tokens,
107         uint256 soldTokens,
108         uint256 claims,
109         uint256 timestamp
110     );
111 
112     event onTokenPurchase(
113         address indexed customerAddress,
114         uint256 incomingeth,
115         uint256 tokensMinted,
116         uint timestamp
117     );
118 
119     event onTokenSell(
120         address indexed customerAddress,
121         uint256 tokensBurned,
122         uint256 ethEarned,
123         uint timestamp
124     );
125 
126     event onReinvestment(
127         address indexed customerAddress,
128         uint256 ethReinvested,
129         uint256 tokensMinted,
130         uint256 timestamp
131     );
132 
133     event onWithdraw(
134         address indexed customerAddress,
135         uint256 ethWithdrawn,
136         uint256 timestamp
137     );
138 
139     event onClaim(
140         address indexed customerAddress,
141         uint256 tokens,
142         uint256 timestamp
143     );
144 
145     event onTransfer(
146         address indexed from,
147         address indexed to,
148         uint256 tokens,
149         uint256 timestamp
150     );
151 
152     event onBuyBack(
153         uint ethAmount,
154         uint tokenAmount,
155         uint256 timestamp
156     );
157 
158 
159     event onBalance(
160         uint256 balance,
161         uint256 timestamp
162     );
163 
164     event onDonation(
165         address indexed from,
166         uint256 amount,
167         uint256 timestamp
168     );
169 
170     event onRouterUpdate(
171         address oldAddress,
172         address newAddress
173     );
174 
175     event onFlushUpdate(
176         uint oldFlushSize,
177         uint newFlushSize
178     );
179 
180     // Onchain Stats!!!
181     struct Stats {
182         uint invested;
183         uint reinvested;
184         uint withdrawn;
185         uint claims;
186         uint rewarded;
187         uint contributed;
188         uint transferredTokens;
189         uint receivedTokens;
190         int256 tokenPayoutsTo;
191         uint xInvested;
192         uint xReinvested;
193         uint xRewarded;
194         uint xContributed;
195         uint xWithdrawn;
196         uint xTransferredTokens;
197         uint xReceivedTokens;
198         uint xClaimed;
199     }
200 
201 
202     /*=====================================
203     =            CONFIGURABLES            =
204     =====================================*/
205 
206     /// @dev 15% dividends for token purchase
207     uint8 constant internal entryFee_ = 10;
208 
209 
210     /// @dev 5% dividends for token selling
211     uint8 constant internal exitFee_ = 10;
212 
213     uint8 constant internal dripFee = 60;  //80% of fees go to drip/instant, the rest, 20%,  to the Swap buyback
214 
215     uint8 constant internal instantFee = 20;
216 
217     uint8 constant payoutRate_ = 2;
218 
219     uint256 constant internal magnitude = 2 ** 64;
220 
221     /*=================================
222      =            DATASETS            =
223      ================================*/
224 
225     // amount of shares for each address (scaled number)
226     mapping(address => uint256) private tokenBalanceLedger_;
227     mapping(address => int256) private payoutsTo_;
228     mapping(address => Stats) private stats;
229     //on chain referral tracking
230     uint256 private tokenSupply_;
231     uint256 private profitPerShare_;
232     uint256 private rewardsProfitPerShare_;
233     uint256 public totalDeposits;
234     uint256 internal lastBalance_;
235 
236     uint public players;
237     uint public totalTxs;
238     uint public dividendBalance_;
239     uint public swapCollector_;
240     uint public swapBalance_;
241     uint public lastPayout;
242     uint public lastBuyback;
243     uint public totalClaims;
244 
245     uint256 public balanceInterval = 6 hours;
246     uint256 public distributionInterval = 2 seconds;
247     uint256 public depotFlushSize = 0.01 ether;
248 
249 
250     address public swapAddress;
251     address public vltAddress;
252     address public collateralAddress;
253 
254     Token private vltToken;
255     Token private cToken;
256     UniSwapV2LiteRouter private swap;
257 
258 
259     /*=======================================
260     =            PUBLIC FUNCTIONS           =
261     =======================================*/
262 
263     constructor(address _collateralAddress, address _vltAddress, address _swapAddress) Ownable() public {
264 
265         vltAddress = _vltAddress;
266         vltToken = Token(_vltAddress);
267 
268         collateralAddress = _collateralAddress;
269         cToken = Token(_collateralAddress);
270 
271         swapAddress = _swapAddress;
272         swap = UniSwapV2LiteRouter(_swapAddress);
273 
274         lastPayout = now;
275 
276     }
277 
278 
279     /// @dev This is how you pump pure "drip" dividends into the system
280     function donatePool(uint _amount) public returns (uint256) {
281         require(cToken.transferFrom(msg.sender, address(this), _amount), "Transferred failed");
282 
283         dividendBalance_ += _amount;
284 
285         emit onDonation(msg.sender, _amount, now);
286     }
287 
288     /// @dev Converts all incoming eth to tokens for the caller, and passes down the referral addy (if any)
289     function buy(uint _buy_amount) public returns (uint256)  {
290         return buyFor(msg.sender, _buy_amount);
291     }
292 
293 
294     /// @dev Converts all incoming eth to tokens for the caller, and passes down the referral addy (if any)
295     function buyFor(address _customerAddress, uint _buy_amount) public returns (uint256)  {
296         require(cToken.transferFrom(_customerAddress, address(this), _buy_amount), "Transferred failed");
297         totalDeposits += _buy_amount;
298         uint amount = purchaseTokens(_customerAddress, _buy_amount);
299 
300         emit onLeaderBoard(_customerAddress,
301             stats[_customerAddress].invested,
302             tokenBalanceLedger_[_customerAddress],
303             stats[_customerAddress].withdrawn,
304             stats[_customerAddress].claims,
305             now
306         );
307 
308         //distribute
309         distribute();
310 
311         return amount;
312     }
313 
314 
315 
316 
317     /**
318      * @dev Fallback function to handle eth that was send straight to the contract
319      *  Unfortunately we cannot use a referral address this way.
320      */
321     function() public payable  {
322         //Just bounce
323         require(false, "This contract does not except ETH");
324     }
325 
326     /// @dev Converts all of caller's dividends to tokens.
327     function reinvest() public onlyStronghands  {
328         // fetch dividends
329         uint256 _dividends = myDividends();
330         // retrieve ref. bonus later in the code
331 
332         // pay out the dividends virtually
333         address _customerAddress = msg.sender;
334         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
335 
336         // dispatch a buy order with the virtualized "withdrawn dividends"
337         uint256 _tokens = purchaseTokens(msg.sender, _dividends);
338 
339         // fire event
340         emit onReinvestment(_customerAddress, _dividends, _tokens, now);
341 
342         //Stats
343         stats[_customerAddress].reinvested = SafeMath.add(stats[_customerAddress].reinvested, _dividends);
344         stats[_customerAddress].xReinvested += 1;
345 
346         emit onLeaderBoard(_customerAddress,
347             stats[_customerAddress].invested,
348             tokenBalanceLedger_[_customerAddress],
349             stats[_customerAddress].withdrawn,
350             stats[_customerAddress].claims,
351             now
352         );
353 
354         //distribute
355         distribute();
356     }
357 
358     /// @dev Withdraws all of the callers earnings.
359     function withdraw() public onlyStronghands  {
360         // setup data
361         address _customerAddress = msg.sender;
362         uint256 _dividends = myDividends();
363 
364         // update dividend tracker
365         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
366 
367 
368         // lambo delivery service
369         cToken.transfer(_customerAddress, _dividends);
370 
371         //stats
372         stats[_customerAddress].withdrawn = SafeMath.add(stats[_customerAddress].withdrawn, _dividends);
373         stats[_customerAddress].xWithdrawn += 1;
374         totalTxs += 1;
375 
376         // fire event
377         emit onWithdraw(_customerAddress, _dividends, now);
378 
379         //distribute
380         distribute();
381     }
382 
383     /// @dev Withdraws all of the callers rewards.
384     function claim() public {
385         // setup data
386         address _customerAddress = msg.sender;
387         uint256 _dividends = myClaims();
388 
389         //only  to claim
390         require(_dividends > 0, "No dividends to claim");
391 
392         // update dividend tracker
393         stats[_customerAddress].tokenPayoutsTo += (int256) (_dividends * magnitude);
394 
395 
396         // lambo delivery service
397         vltToken.transfer(_customerAddress, _dividends);
398 
399         //stats
400         stats[_customerAddress].claims = SafeMath.add(stats[_customerAddress].claims, _dividends);
401         stats[_customerAddress].xClaimed += 1;
402         totalTxs += 1;
403 
404         // fire event
405         emit onClaim(_customerAddress, _dividends, now);
406 
407         emit onLeaderBoard(_customerAddress,
408             stats[_customerAddress].invested,
409             tokenBalanceLedger_[_customerAddress],
410             stats[_customerAddress].withdrawn,
411             stats[_customerAddress].claims,
412             now
413         );
414 
415         //distribute
416         distribute();
417     }
418 
419     /// @dev Liquifies STCK to collateral tokens.
420     function sell(uint256 _amountOfTokens) onlyBagholders public {
421         // setup data
422         address _customerAddress = msg.sender;
423 
424         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress], "Amount of tokens is greater than balance");
425 
426 
427         // data setup
428         uint256 _undividedDividends = SafeMath.mul(_amountOfTokens, exitFee_) / 100;
429         uint256 _taxedeth = SafeMath.sub(_amountOfTokens, _undividedDividends);
430 
431         // burn the sold tokens
432         tokenSupply_ = SafeMath.sub(tokenSupply_, _amountOfTokens);
433         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
434 
435         // update dividends tracker
436         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens + (_taxedeth * magnitude));
437         payoutsTo_[_customerAddress] -= _updatedPayouts;
438 
439         //update claims tracker; don't need to redeem extra claims
440         stats[_customerAddress].tokenPayoutsTo -= (int256) (rewardsProfitPerShare_ * _amountOfTokens);
441 
442 
443         //drip and buybacks applied after supply is updated
444         allocateFees(_undividedDividends);
445 
446         // fire event
447         emit onTokenSell(_customerAddress, _amountOfTokens, _taxedeth, now);
448 
449         emit onLeaderBoard(_customerAddress,
450             stats[_customerAddress].invested,
451             tokenBalanceLedger_[_customerAddress],
452             stats[_customerAddress].withdrawn,
453             stats[_customerAddress].claims,
454             now
455         );
456 
457         //distribute
458         distribute();
459     }
460 
461     /**
462     * @dev Transfer tokens from the caller to a new holder.
463     *  Zero fees
464     */
465     function transfer(address _toAddress, uint256 _amountOfTokens) external onlyBagholders  returns (bool) {
466         // setup
467         address _customerAddress = msg.sender;
468 
469         // make sure we have the requested tokens
470         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress], "Amount of tokens is greater than balance");
471 
472         // withdraw all outstanding dividends first
473         if (myDividends() > 0) {
474             withdraw();
475         }
476 
477 
478         // exchange tokens
479         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
480         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
481 
482         // update dividend trackers
483         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
484         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
485 
486         //update claims tracker
487         stats[_customerAddress].tokenPayoutsTo -= (int256) (rewardsProfitPerShare_ * _amountOfTokens);
488         stats[_toAddress].tokenPayoutsTo += (int256) (rewardsProfitPerShare_ * _amountOfTokens);
489 
490 
491         /* Members
492             A player can be initialized by buying or receiving and we want to add the user ASAP
493          */
494         if (stats[_toAddress].invested == 0 && stats[_toAddress].receivedTokens == 0) {
495             players += 1;
496         }
497 
498         //Stats
499         stats[_customerAddress].xTransferredTokens += 1;
500         stats[_customerAddress].transferredTokens += _amountOfTokens;
501         stats[_toAddress].receivedTokens += _amountOfTokens;
502         stats[_toAddress].xReceivedTokens += 1;
503         totalTxs += 1;
504 
505         // fire event
506         emit onTransfer(_customerAddress, _toAddress, _amountOfTokens, now);
507 
508         emit onLeaderBoard(_customerAddress,
509             stats[_customerAddress].invested,
510             tokenBalanceLedger_[_customerAddress],
511             stats[_customerAddress].withdrawn,
512             stats[_customerAddress].claims,
513             now
514         );
515 
516         emit onLeaderBoard(_toAddress,
517             stats[_toAddress].invested,
518             tokenBalanceLedger_[_toAddress],
519             stats[_toAddress].withdrawn,
520             stats[_toAddress].claims,
521             now
522         );
523 
524         // ERC20
525         return true;
526     }
527 
528 
529     /*=====================================
530     =      HELPERS AND CALCULATORS        =
531     =====================================*/
532 
533     /**
534      * @dev Method to view the current eth stored in the contract
535      */
536     function totalTokenBalance() public view returns (uint256) {
537         return cToken.balanceOf(address(this));
538     }
539 
540     /// @dev Retrieve the total token supply.
541     function totalSupply() public view returns (uint256) {
542         return tokenSupply_;
543     }
544 
545     /// @dev Retrieve the tokens owned by the caller.
546     function myTokens() public view returns (uint256) {
547         address _customerAddress = msg.sender;
548         return balanceOf(_customerAddress);
549     }
550 
551     /**
552      * @dev Retrieve the dividends owned by the caller.
553      */
554     function myDividends() public view returns (uint256) {
555         address _customerAddress = msg.sender;
556         return dividendsOf(_customerAddress);
557     }
558 
559     /**
560      * @dev Retrieve token claims owned by the caller.
561      */
562     function myClaims() public view returns (uint256) {
563         address _customerAddress = msg.sender;
564         return claimsOf(_customerAddress);
565     }
566 
567 
568 
569     /// @dev Retrieve the token balance of any single address.
570     function balanceOf(address _customerAddress) public view returns (uint256) {
571         return tokenBalanceLedger_[_customerAddress];
572     }
573 
574     /// @dev Retrieve the token balance of any single address.
575     function tokenBalance(address _customerAddress) public view returns (uint256) {
576         return _customerAddress.balance;
577     }
578 
579     /// @dev Retrieve the dividend balance of any single address.
580     function dividendsOf(address _customerAddress) public view returns (uint256) {
581         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
582     }
583 
584     /// @dev Retrieve the claims balance of any single address.
585     function claimsOf(address _customerAddress) public view returns (uint256) {
586         return (uint256) ((int256) (rewardsProfitPerShare_ * tokenBalanceLedger_[_customerAddress]) - stats[_customerAddress].tokenPayoutsTo) / magnitude;
587     }
588 
589     /// @dev Return the sell price of 1 individual token.
590     function sellPrice() public pure returns (uint256) {
591         uint256 _eth = 1e18;
592         uint256 _dividends = SafeMath.div(SafeMath.mul(_eth, exitFee_), 100);
593         uint256 _taxedeth = SafeMath.sub(_eth, _dividends);
594 
595         return _taxedeth;
596 
597     }
598 
599     /// @dev Return the buy price of 1 individual token.
600     function buyPrice() public pure returns (uint256) {
601         uint256 _eth = 1e18;
602         uint256 _dividends = SafeMath.div(SafeMath.mul(_eth, entryFee_), 100);
603         uint256 _taxedeth = SafeMath.add(_eth, _dividends);
604 
605         return _taxedeth;
606 
607     }
608 
609     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
610     function calculateTokensReceived(uint256 _ethToSpend) public pure returns (uint256) {
611         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethToSpend, entryFee_), 100);
612         uint256 _taxedeth = SafeMath.sub(_ethToSpend, _dividends);
613         uint256 _amountOfTokens = _taxedeth;
614 
615         return _amountOfTokens;
616     }
617 
618     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
619     function calculateethReceived(uint256 _tokensToSell) public view returns (uint256) {
620         require(_tokensToSell <= tokenSupply_, "Tokens to sell greater than supply");
621         uint256 _eth = _tokensToSell;
622         uint256 _dividends = SafeMath.div(SafeMath.mul(_eth, exitFee_), 100);
623         uint256 _taxedeth = SafeMath.sub(_eth, _dividends);
624         return _taxedeth;
625     }
626 
627 
628     /// @dev Stats of any single address
629     function statsOf(address _customerAddress) public view returns (uint256[16] memory){
630         Stats memory s = stats[_customerAddress];
631         uint256[16] memory statArray = [s.invested, s.withdrawn, s.rewarded, s.contributed, s.transferredTokens, s.receivedTokens, s.xInvested, s.xRewarded, s.xContributed, s.xWithdrawn, s.xTransferredTokens, s.xReceivedTokens, s.reinvested, s.xReinvested, s.claims, s.xClaimed];
632         return statArray;
633     }
634 
635     /// @dev Calculate daily estimate of collateral tokens awarded
636     function dailyEstimate(address _customerAddress) public view returns (uint256){
637         uint256 share = dividendBalance_.mul(payoutRate_).div(100);
638 
639         return (tokenSupply_ > 0) ? share.mul(tokenBalanceLedger_[_customerAddress]).div(tokenSupply_) : 0;
640     }
641 
642     /// @dev Calculate estimate of daily reward tokens
643     function dailyClaimEstimate(address _customerAddress) public view returns (uint256){
644         uint256 share = swapBalance_.mul(payoutRate_).div(100);
645 
646         return (tokenSupply_ > 0) ? share.mul(tokenBalanceLedger_[_customerAddress]).div(tokenSupply_) : 0;
647     }
648 
649 
650     /*==========================================
651     =            INTERNAL FUNCTIONS            =
652     ==========================================*/
653 
654     /// @dev Distribute undividend in and out fees across drip pools and instant divs
655     function allocateFees(uint fee) private {
656         uint _share = fee.div(100);
657         uint _drip = _share.mul(dripFee);
658         uint _instant = _share.mul(instantFee);
659         uint _swap = fee.safeSub(_drip + _instant);
660 
661         //Apply divs
662         profitPerShare_ = SafeMath.add(profitPerShare_, (_instant * magnitude) / tokenSupply_);
663 
664         //Add to dividend drip pools
665         dividendBalance_ += _drip;
666         swapCollector_ += _swap;
667     }
668 
669     // @dev Distribute drip pools
670     function distribute() private {
671 
672         if (now.safeSub(lastBalance_) > balanceInterval) {
673             emit onBalance(totalTokenBalance(), now);
674             lastBalance_ = now;
675         }
676 
677 
678         if (SafeMath.safeSub(now, lastPayout) > distributionInterval && tokenSupply_ > 0) {
679 
680             //A portion of the dividend is paid out according to the rate
681             uint256 share = dividendBalance_.mul(payoutRate_).div(100).div(24 hours);
682             //divide the profit by seconds in the day
683             uint256 profit = share * now.safeSub(lastPayout);
684             //share times the amount of time elapsed
685             dividendBalance_ = dividendBalance_.safeSub(profit);
686 
687             //Apply divs
688             profitPerShare_ = SafeMath.add(profitPerShare_, (profit * magnitude) / tokenSupply_);
689 
690 
691             //Don't distribute if we don't have  sufficient profit
692             //A portion of the dividend is paid out according to the rate
693             share = swapBalance_.mul(payoutRate_).div(100).div(24 hours);
694             //divide the profit by seconds in the day
695             profit = share * now.safeSub(lastPayout);
696 
697             //share times the amount of time elapsed
698             swapBalance_ = swapBalance_.safeSub(profit);
699 
700             //Apply claimed token divs
701             rewardsProfitPerShare_ = SafeMath.add(rewardsProfitPerShare_, (profit * magnitude) / tokenSupply_);
702 
703             processBuyBacks();
704 
705             lastPayout = now;
706 
707         }
708 
709 
710     }
711 
712 
713     /// @dev Process buybacks using the router; initial time and size logic gates and orchestration
714     function processBuyBacks() private {
715 
716         //Only buy once
717         if (SafeMath.safeSub(now, lastBuyback) > 1 hours) {
718 
719             //Get the amount of the token in ETH and compare to the swapSize
720             address[] memory path = new address[](2);
721             path[0] = collateralAddress;
722             path[1] = swap.WETH();
723 
724             uint[] memory amounts = swap.getAmountsOut(swapCollector_, path);
725 
726             if (amounts[1] >= depotFlushSize) {
727 
728                 uint amount = swapCollector_;
729 
730                 //reset Collector
731                 swapCollector_ = 0;
732 
733                 //VLT for ALL
734                 uint _tokens = buyback(amount);
735 
736                 totalClaims += _tokens;
737 
738                 //Add to the pool
739                 swapBalance_ += _tokens;
740 
741                 lastBuyback = now;
742 
743             }
744         }
745     }
746 
747     //Execute the buyback against the router using WETH as a bridge
748     function buyback(uint amount) private returns (uint) {
749         address[] memory path = new address[](3);
750         path[0] = collateralAddress;
751         path[1] = swap.WETH();
752         path[2] = vltAddress;
753 
754         //Need to be able to approve the collateral token for transfer
755         require(cToken.approve(swapAddress, amount), "Amount approved not available");
756 
757         uint[] memory amounts = swap.swapExactTokensForTokens(amount, 1, path, address(this), now + 24 hours);
758 
759         //2nd index is token amount
760         emit onBuyBack(amount, amounts[2], now);
761 
762         return amounts[2];
763 
764     }
765 
766     /// @dev Internal function to actually purchase the tokens.
767     function purchaseTokens(address _customerAddress, uint256 _incomingtokens) internal returns (uint256) {
768 
769         /* Members */
770         if (stats[_customerAddress].invested == 0 && stats[_customerAddress].receivedTokens == 0) {
771             players += 1;
772         }
773 
774         totalTxs += 1;
775 
776         // data setup
777         uint256 _undividedDividends = SafeMath.mul(_incomingtokens, entryFee_) / 100;
778         uint256 _amountOfTokens = SafeMath.sub(_incomingtokens, _undividedDividends);
779 
780         // fire event
781         emit onTokenPurchase(_customerAddress, _incomingtokens, _amountOfTokens, now);
782 
783         // yes we know that the safemath function automatically rules out the "greater then" equation.
784         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_, "Tokens need to be positive");
785 
786 
787         // we can't give people infinite eth
788         if (tokenSupply_ > 0) {
789             // add tokens to the pool
790             tokenSupply_ += _amountOfTokens;
791 
792         } else {
793             // add tokens to the pool
794             tokenSupply_ = _amountOfTokens;
795         }
796 
797         // update circulating supply & the ledger address for the customer
798         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
799 
800         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
801         // really i know you think you do but you don't
802         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens);
803         payoutsTo_[_customerAddress] += _updatedPayouts;
804 
805         _updatedPayouts = (int256) (rewardsProfitPerShare_ * _amountOfTokens);
806         stats[_customerAddress].tokenPayoutsTo += _updatedPayouts;
807 
808         //drip and buybacks; instant requires being called after supply is updated
809         allocateFees(_undividedDividends);
810 
811         //Stats
812         stats[_customerAddress].invested += _incomingtokens;
813         stats[_customerAddress].xInvested += 1;
814 
815         return _amountOfTokens;
816     }
817 
818     /*==========================================
819     =            ADMIN FUNCTIONS               =
820     ==========================================*/
821 
822 
823     /**
824     * @dev Update the router address to account for movement in liquidity long term
825     */
826     function updateSwapRouter(address _swapAddress) onlyOwner() public {
827 
828         emit onRouterUpdate(swapAddress, _swapAddress);
829         swapAddress = _swapAddress;
830         swap = UniSwapV2LiteRouter(_swapAddress);
831     }
832 
833     /**
834     * @dev Update the flushSize (how often buy backs happen in terms of amount of ETH accumulated)
835     */
836     function updateFlushSize(uint _flushSize) onlyOwner() public {
837         require(_flushSize >= 0.01 ether && _flushSize <= 5 ether, "Flush size is out of range");
838 
839         emit onFlushUpdate(depotFlushSize, _flushSize);
840         depotFlushSize = _flushSize;
841     }
842 
843 }
844 
845 /**
846  * @title SafeMath
847  * @dev Math operations with safety checks that throw on error
848  */
849 library SafeMath {
850 
851     /**
852     * @dev Multiplies two numbers, throws on overflow.
853     */
854     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
855         if (a == 0) {
856             return 0;
857         }
858         c = a * b;
859         assert(c / a == b);
860         return c;
861     }
862 
863     /**
864     * @dev Integer division of two numbers, truncating the quotient.
865     */
866     function div(uint256 a, uint256 b) internal pure returns (uint256) {
867         // assert(b > 0); // Solidity automatically throws when dividing by 0
868         // uint256 c = a / b;
869         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
870         return a / b;
871     }
872 
873     /**
874     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
875     */
876     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
877         assert(b <= a);
878         return a - b;
879     }
880 
881     /* @dev Subtracts two numbers, else returns zero */
882     function safeSub(uint a, uint b) internal pure returns (uint) {
883         if (b > a) {
884             return 0;
885         } else {
886             return a - b;
887         }
888     }
889 
890     /**
891     * @dev Adds two numbers, throws on overflow.
892     */
893     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
894         c = a + b;
895         assert(c >= a);
896         return c;
897     }
898 
899     function max(uint256 a, uint256 b) internal pure returns (uint256) {
900         return a >= b ? a : b;
901     }
902 
903     function min(uint256 a, uint256 b) internal pure returns (uint256) {
904         return a < b ? a : b;
905     }
906 }