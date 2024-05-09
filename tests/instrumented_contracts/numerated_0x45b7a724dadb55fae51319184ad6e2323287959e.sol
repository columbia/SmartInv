1 /*
2     SPDX-License-Identifier: MIT
3     A Bankteller Production
4     Bankroll Network
5     Copyright 2020
6 */
7 pragma solidity ^0.4.25;
8 
9 /**
10  * @title Ownable
11  * @dev The Ownable contract has an owner address, and provides basic authorization control
12  * functions, this simplifies the implementation of "user permissions".
13  */
14 contract Ownable {
15     address public owner;
16 
17     event OwnershipTransferred(
18         address indexed previousOwner,
19         address indexed newOwner
20     );
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
34         require(msg.sender == owner, "Not current owner");
35         _;
36     }
37 
38     /**
39      * @dev Allows the current owner to transfer control of the contract to a newOwner.
40      * @param newOwner The address to transfer ownership to.
41      */
42     function transferOwnership(address newOwner) public onlyOwner {
43         require(newOwner != address(0), "Non-zero address required");
44         emit OwnershipTransferred(owner, newOwner);
45         owner = newOwner;
46     }
47 }
48 
49 contract Token {
50     function approve(address spender, uint256 value) public returns (bool);
51 
52     function transferFrom(
53         address from,
54         address to,
55         uint256 value
56     ) public returns (bool);
57 
58     function transfer(address to, uint256 value) public returns (bool);
59 
60     function balanceOf(address who) public view returns (uint256);
61 }
62 
63 contract UniSwapV2LiteRouter {
64     //function ethToTokenSwapInput(uint256 min_tokens) public payable returns (uint256);
65     function WETH() external pure returns (address);
66 
67     function swapExactTokensForTokens(
68         uint256 amountIn,
69         uint256 amountOutMin,
70         address[] path,
71         address to,
72         uint256 deadline
73     ) external returns (uint256[] amounts);
74 
75     function swapExactETHForTokens(
76         uint256 amountOutMin,
77         address[] path,
78         address to,
79         uint256 deadline
80     ) external payable returns (uint256[] amounts);
81 
82     function getAmountsOut(uint256 amountIn, address[] path)
83         external
84         view
85         returns (uint256[] amounts);
86 }
87 
88 /*
89  * @dev Moon is a perpetual rewards contract
90  */
91 
92 contract BankrollNetworkMoon is Ownable {
93     using SafeMath for uint256;
94 
95     /*=================================
96     =            MODIFIERS            =
97     =================================*/
98 
99     /// @dev Only people with tokens
100     modifier onlyBagholders {
101         require(myTokens() > 0, "Insufficient tokens");
102         _;
103     }
104 
105     /// @dev Only people with profits
106     modifier onlyStronghands {
107         require(myDividends() > 0, "Insufficient dividends");
108         _;
109     }
110 
111     /*==============================
112     =            EVENTS            =
113     ==============================*/
114 
115     event onLeaderBoard(
116         address indexed customerAddress,
117         uint256 invested,
118         uint256 tokens,
119         uint256 soldTokens,
120         uint256 timestamp
121     );
122 
123     event onTokenPurchase(
124         address indexed customerAddress,
125         uint256 incomingeth,
126         uint256 tokensMinted,
127         uint256 timestamp
128     );
129 
130     event onTokenSell(
131         address indexed customerAddress,
132         uint256 tokensBurned,
133         uint256 ethEarned,
134         uint256 timestamp
135     );
136 
137     event onReinvestment(
138         address indexed customerAddress,
139         uint256 ethReinvested,
140         uint256 tokensMinted,
141         uint256 timestamp
142     );
143 
144     event onWithdraw(
145         address indexed customerAddress,
146         uint256 ethWithdrawn,
147         uint256 timestamp
148     );
149 
150     event onClaim(
151         address indexed customerAddress,
152         uint256 tokens,
153         uint256 timestamp
154     );
155 
156     event onTransfer(
157         address indexed from,
158         address indexed to,
159         uint256 tokens,
160         uint256 timestamp
161     );
162 
163     event onUpdateIntervals(uint256 payout, uint256 fund);
164 
165     event onCollateraltoReward(
166         uint256 collateralAmount,
167         uint256 rewardAmount,
168         uint256 timestamp
169     );
170 
171     event onEthtoCollateral(
172         uint256 ethAmount,
173         uint256 tokenAmount,
174         uint256 timestamp
175     );
176 
177     event onRewardtoCollateral(
178         uint256 ethAmount,
179         uint256 tokenAmount,
180         uint256 timestamp
181     );
182 
183     event onBalance(uint256 balance, uint256 rewardBalance, uint256 timestamp);
184 
185     event onDonation(address indexed from, uint256 amount, uint256 timestamp);
186 
187     event onRouterUpdate(address oldAddress, address newAddress);
188 
189     event onFlushUpdate(uint256 oldFlushSize, uint256 newFlushSize);
190 
191     // Onchain Stats!!!
192     struct Stats {
193         uint256 invested;
194         uint256 reinvested;
195         uint256 withdrawn;
196         uint256 rewarded;
197         uint256 contributed;
198         uint256 transferredTokens;
199         uint256 receivedTokens;
200         uint256 xInvested;
201         uint256 xReinvested;
202         uint256 xRewarded;
203         uint256 xContributed;
204         uint256 xWithdrawn;
205         uint256 xTransferredTokens;
206         uint256 xReceivedTokens;
207     }
208 
209     /*=====================================
210     =            CONFIGURABLES            =
211     =====================================*/
212 
213     /// @dev 15% dividends for token purchase
214     uint8 internal constant entryFee_ = 10;
215 
216     /// @dev 5% dividends for token selling
217     uint8 internal constant exitFee_ = 10;
218 
219     uint8 internal constant instantFee = 20;
220 
221     uint8 constant payoutRate_ = 2;
222 
223     uint256 internal constant magnitude = 2**64;
224 
225     /*=================================
226      =            DATASETS            =
227      ================================*/
228 
229     // amount of shares for each address (scaled number)
230     mapping(address => uint256) private tokenBalanceLedger_;
231     mapping(address => int256) private payoutsTo_;
232     mapping(address => Stats) private stats;
233     //on chain referral tracking
234     uint256 private tokenSupply_;
235     uint256 private profitPerShare_;
236     uint256 public totalDeposits;
237     uint256 internal lastBalance_;
238 
239     uint256 public players;
240     uint256 public totalTxs;
241     uint256 public collateralBuffer_;
242     uint256 public lastPayout;
243     uint256 public lastFunding;
244     uint256 public totalClaims;
245 
246     uint256 public balanceInterval = 6 hours;
247     uint256 public payoutInterval = 2 seconds;
248     uint256 public fundingInterval = 2 seconds;
249     uint256 public flushSize = 0.00000000001 ether;
250 
251     address public swapAddress;
252     address public rewardAddress;
253     address public collateralAddress;
254 
255     Token private rewardToken;
256     Token private collateralToken;
257     UniSwapV2LiteRouter private swap;
258 
259     /*=======================================
260     =            PUBLIC FUNCTIONS           =
261     =======================================*/
262 
263     constructor(
264         address _collateralAddress,
265         address _rewardAddress,
266         address _swapAddress
267     ) public Ownable() {
268         rewardAddress = _rewardAddress;
269         rewardToken = Token(_rewardAddress);
270 
271         collateralAddress = _collateralAddress;
272         collateralToken = Token(_collateralAddress);
273 
274         swapAddress = _swapAddress;
275         swap = UniSwapV2LiteRouter(_swapAddress);
276 
277         lastPayout = now;
278         lastFunding = now;
279     }
280 
281     /// @dev Converts all incoming eth to tokens for the caller, and passes down the referral addy (if any)
282     function buy() public payable returns (uint256) {
283         return buyFor(msg.sender);
284     }
285 
286     /// @dev Converts all incoming eth to tokens for the caller, and passes down the referral addy (if any)
287     function buyFor(address _customerAddress) public payable returns (uint256) {
288         require(msg.value > 0, "Non-zero amount required");
289 
290         //Convert ETH to collateral
291         uint256 _buy_amount = ethToCollateral(msg.value);
292 
293         totalDeposits += _buy_amount;
294         uint256 amount = purchaseTokens(_customerAddress, _buy_amount);
295 
296         emit onLeaderBoard(
297             _customerAddress,
298             stats[_customerAddress].invested,
299             tokenBalanceLedger_[_customerAddress],
300             stats[_customerAddress].withdrawn,
301             now
302         );
303 
304         //distribute
305         distribute();
306 
307         return amount;
308     }
309 
310     /**
311      * @dev Fallback function to handle eth that was send straight to the contract
312      *  Unfortunately we cannot use a referral address this way.
313      */
314     function() public payable {
315         //Just bounce
316         require(false, "This contract does not except ETH");
317     }
318 
319     /// @dev Converts all of caller's dividends to tokens.
320     function reinvest() public onlyStronghands {
321         // fetch dividends
322         uint256 _dividends = myDividends();
323         // retrieve ref. bonus later in the code
324 
325         // pay out the dividends virtually
326         address _customerAddress = msg.sender;
327         payoutsTo_[_customerAddress] += (int256)(_dividends * magnitude);
328 
329         // dispatch a buy order with the virtualized "withdrawn dividends"
330         uint256 _tokens = purchaseTokens(msg.sender, _dividends);
331 
332         // fire event
333         emit onReinvestment(_customerAddress, _dividends, _tokens, now);
334 
335         //Stats
336         stats[_customerAddress].reinvested = SafeMath.add(
337             stats[_customerAddress].reinvested,
338             _dividends
339         );
340         stats[_customerAddress].xReinvested += 1;
341 
342         emit onLeaderBoard(
343             _customerAddress,
344             stats[_customerAddress].invested,
345             tokenBalanceLedger_[_customerAddress],
346             stats[_customerAddress].withdrawn,
347             now
348         );
349 
350         //distribute
351         distribute();
352     }
353 
354     /// @dev Withdraws all of the callers earnings.
355     function withdraw() public onlyStronghands {
356         // setup data
357         address _customerAddress = msg.sender;
358         uint256 _dividends = myDividends();
359 
360         // update dividend tracker
361         payoutsTo_[_customerAddress] += (int256)(_dividends * magnitude);
362 
363         // lambo delivery service
364         collateralToken.transfer(_customerAddress, _dividends);
365 
366         //stats
367         stats[_customerAddress].withdrawn = SafeMath.add(
368             stats[_customerAddress].withdrawn,
369             _dividends
370         );
371         stats[_customerAddress].xWithdrawn += 1;
372         totalTxs += 1;
373 
374         // fire event
375         emit onWithdraw(_customerAddress, _dividends, now);
376 
377         //distribute
378         distribute();
379     }
380 
381     /// @dev Liquifies STCK to collateral tokens.
382     function sell(uint256 _amountOfTokens) public onlyBagholders {
383         // setup data
384         address _customerAddress = msg.sender;
385 
386         require(
387             _amountOfTokens <= tokenBalanceLedger_[_customerAddress],
388             "Amount of tokens is greater than balance"
389         );
390 
391         // data setup
392         uint256 _undividedDividends = SafeMath.mul(_amountOfTokens, exitFee_) /
393             100;
394         uint256 _taxedeth = SafeMath.sub(_amountOfTokens, _undividedDividends);
395 
396         // burn the sold tokens
397         tokenSupply_ = SafeMath.sub(tokenSupply_, _amountOfTokens);
398         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(
399             tokenBalanceLedger_[_customerAddress],
400             _amountOfTokens
401         );
402 
403         // update dividends tracker
404         int256 _updatedPayouts = (int256)(
405             profitPerShare_ * _amountOfTokens + (_taxedeth * magnitude)
406         );
407         payoutsTo_[_customerAddress] -= _updatedPayouts;
408 
409         //drip and buybacks applied after supply is updated
410         allocateFees(_undividedDividends);
411 
412         // fire event
413         emit onTokenSell(_customerAddress, _amountOfTokens, _taxedeth, now);
414 
415         emit onLeaderBoard(
416             _customerAddress,
417             stats[_customerAddress].invested,
418             tokenBalanceLedger_[_customerAddress],
419             stats[_customerAddress].withdrawn,
420             now
421         );
422 
423         //distribute
424         distribute();
425     }
426 
427     /**
428      * @dev Transfer tokens from the caller to a new holder.
429      *  Zero fees
430      */
431     function transfer(address _toAddress, uint256 _amountOfTokens)
432         external
433         onlyBagholders
434         returns (bool)
435     {
436         // setup
437         address _customerAddress = msg.sender;
438 
439         // make sure we have the requested tokens
440         require(
441             _amountOfTokens <= tokenBalanceLedger_[_customerAddress],
442             "Amount of tokens is greater than balance"
443         );
444 
445         // withdraw all outstanding dividends first
446         if (myDividends() > 0) {
447             withdraw();
448         }
449 
450         // exchange tokens
451         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(
452             tokenBalanceLedger_[_customerAddress],
453             _amountOfTokens
454         );
455         tokenBalanceLedger_[_toAddress] = SafeMath.add(
456             tokenBalanceLedger_[_toAddress],
457             _amountOfTokens
458         );
459 
460         // update dividend trackers
461         payoutsTo_[_customerAddress] -= (int256)(
462             profitPerShare_ * _amountOfTokens
463         );
464         payoutsTo_[_toAddress] += (int256)(profitPerShare_ * _amountOfTokens);
465 
466         /* Members
467             A player can be initialized by buying or receiving and we want to add the user ASAP
468          */
469         if (
470             stats[_toAddress].invested == 0 &&
471             stats[_toAddress].receivedTokens == 0
472         ) {
473             players += 1;
474         }
475 
476         //Stats
477         stats[_customerAddress].xTransferredTokens += 1;
478         stats[_customerAddress].transferredTokens += _amountOfTokens;
479         stats[_toAddress].receivedTokens += _amountOfTokens;
480         stats[_toAddress].xReceivedTokens += 1;
481         totalTxs += 1;
482 
483         // fire event
484         emit onTransfer(_customerAddress, _toAddress, _amountOfTokens, now);
485 
486         emit onLeaderBoard(
487             _customerAddress,
488             stats[_customerAddress].invested,
489             tokenBalanceLedger_[_customerAddress],
490             stats[_customerAddress].withdrawn,
491             now
492         );
493 
494         emit onLeaderBoard(
495             _toAddress,
496             stats[_toAddress].invested,
497             tokenBalanceLedger_[_toAddress],
498             stats[_toAddress].withdrawn,
499             now
500         );
501 
502         // ERC20
503         return true;
504     }
505 
506     /*=====================================
507     =      HELPERS AND CALCULATORS        =
508     =====================================*/
509 
510     /**
511      * @dev Method to view the current collateral stored in the contract
512      */
513     function totalTokenBalance() public view returns (uint256) {
514         return collateralToken.balanceOf(address(this));
515     }
516 
517     /**
518      * @dev Method to view the current collateral stored in the contract
519      */
520     function totalRewardTokenBalance() public view returns (uint256) {
521         return rewardToken.balanceOf(address(this));
522     }
523 
524     /// @dev Retrieve the total token supply.
525     function totalSupply() public view returns (uint256) {
526         return tokenSupply_;
527     }
528 
529     /// @dev Retrieve the tokens owned by the caller.
530     function myTokens() public view returns (uint256) {
531         address _customerAddress = msg.sender;
532         return balanceOf(_customerAddress);
533     }
534 
535     /**
536      * @dev Retrieve the dividends owned by the caller.
537      */
538     function myDividends() public view returns (uint256) {
539         address _customerAddress = msg.sender;
540         return dividendsOf(_customerAddress);
541     }
542 
543     /// @dev Retrieve the token balance of any single address.
544     function balanceOf(address _customerAddress) public view returns (uint256) {
545         return tokenBalanceLedger_[_customerAddress];
546     }
547 
548     /// @dev Retrieve the token balance of any single address.
549     function tokenBalance(address _customerAddress)
550         public
551         view
552         returns (uint256)
553     {
554         return _customerAddress.balance;
555     }
556 
557     /// @dev Retrieve the dividend balance of any single address.
558     function dividendsOf(address _customerAddress)
559         public
560         view
561         returns (uint256)
562     {
563         return
564             (uint256)(
565                 (int256)(
566                     profitPerShare_ * tokenBalanceLedger_[_customerAddress]
567                 ) - payoutsTo_[_customerAddress]
568             ) / magnitude;
569     }
570 
571     /// @dev Return the sell price of 1 individual token.
572     function sellPrice() public pure returns (uint256) {
573         uint256 _eth = 1e18;
574         uint256 _dividends = SafeMath.div(SafeMath.mul(_eth, exitFee_), 100);
575         uint256 _taxedeth = SafeMath.sub(_eth, _dividends);
576 
577         return _taxedeth;
578     }
579 
580     /// @dev Return the buy price of 1 individual token.
581     function buyPrice() public pure returns (uint256) {
582         uint256 _eth = 1e18;
583         uint256 _dividends = SafeMath.div(SafeMath.mul(_eth, entryFee_), 100);
584         uint256 _taxedeth = SafeMath.add(_eth, _dividends);
585 
586         return _taxedeth;
587     }
588 
589     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
590     function calculateTokensReceived(uint256 _ethToSpend)
591         public
592         view
593         returns (uint256)
594     {
595         //Get the amount of the token in ETH and compare to the swapSize
596         address[] memory path = new address[](2);
597         path[0] = swap.WETH();
598         path[1] = collateralAddress;
599 
600         uint256[] memory amounts = swap.getAmountsOut(_ethToSpend, path);
601 
602         uint256 _dividends = SafeMath.div(
603             SafeMath.mul(amounts[1], entryFee_),
604             100
605         );
606         uint256 _taxedeth = SafeMath.sub(amounts[1], _dividends);
607         uint256 _amountOfTokens = _taxedeth;
608 
609         return _amountOfTokens;
610     }
611 
612     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
613     function calculateethReceived(uint256 _tokensToSell)
614         public
615         view
616         returns (uint256)
617     {
618         require(
619             _tokensToSell <= tokenSupply_,
620             "Tokens to sell greater than supply"
621         );
622         uint256 _eth = _tokensToSell;
623         uint256 _dividends = SafeMath.div(SafeMath.mul(_eth, exitFee_), 100);
624         uint256 _taxedeth = SafeMath.sub(_eth, _dividends);
625         return _taxedeth;
626     }
627 
628     /// @dev Stats of any single address
629     function statsOf(address _customerAddress)
630         public
631         view
632         returns (uint256[14] memory)
633     {
634         Stats memory s = stats[_customerAddress];
635         uint256[14] memory statArray = [
636             s.invested,
637             s.withdrawn,
638             s.rewarded,
639             s.contributed,
640             s.transferredTokens,
641             s.receivedTokens,
642             s.xInvested,
643             s.xRewarded,
644             s.xContributed,
645             s.xWithdrawn,
646             s.xTransferredTokens,
647             s.xReceivedTokens,
648             s.reinvested,
649             s.xReinvested
650         ];
651         return statArray;
652     }
653 
654     /// @dev Calculate daily estimate of collateral tokens awarded
655     function dailyEstimate(address _customerAddress)
656         public
657         view
658         returns (uint256)
659     {
660         uint256 share = totalRewardTokenBalance().mul(payoutRate_).div(100);
661 
662         
663         uint256 amount = (tokenSupply_ > 0)
664                 ? share.mul(tokenBalanceLedger_[_customerAddress]).div(
665                     tokenSupply_
666                 )
667                 : 0;
668 
669         if (amount > 0){
670             address[] memory path = new address[](3);
671             path[0] = rewardAddress;
672             path[1] = swap.WETH();
673             path[2] = collateralAddress;
674 
675             
676             uint256[] memory amounts = swap.getAmountsOut(amount, path);
677             return amounts[2];
678         }
679         
680         return  0;      
681     }
682 
683     /*==========================================
684     =            INTERNAL FUNCTIONS            =
685     ==========================================*/
686 
687     /// @dev Distribute undividend in and out fees across drip pools and instant divs
688     function allocateFees(uint256 fee) private {
689         uint256 _share = fee.div(100);
690         uint256 _instant = _share.mul(instantFee);
691         uint256 _collateral = fee.safeSub(_instant);
692 
693         //Apply divs
694         profitPerShare_ = SafeMath.add(
695             profitPerShare_,
696             (_instant * magnitude) / tokenSupply_
697         );
698 
699         //Add to dividend drip pools
700         collateralBuffer_ += _collateral;
701     }
702 
703     // @dev Distribute drip pools
704     function distribute() private {
705         if (now.safeSub(lastBalance_) > balanceInterval) {
706             emit onBalance(totalTokenBalance(), totalRewardTokenBalance(), now);
707             lastBalance_ = now;
708         }
709 
710         if (now.safeSub(lastPayout) > payoutInterval && totalRewardTokenBalance() > 0) {
711             //Don't distribute if we don't have  sufficient profit
712             //A portion of the dividend is paid out according to the rate
713             uint256 share = totalRewardTokenBalance()
714                 .mul(payoutRate_)
715                 .div(100)
716                 .div(24 hours);
717             //divide the profit by seconds in the day
718             uint256 profit = share * now.safeSub(lastPayout);
719 
720             //Get the amount of the token in ETH and compare to the swapSize
721             address[] memory path = new address[](2);
722             path[0] = rewardAddress;
723             path[1] = swap.WETH();
724 
725             if (profit > 0){
726                 uint256[] memory amounts = swap.getAmountsOut(profit, path);
727 
728                 if (amounts[1] > flushSize) {
729                     profit = rewardToCollateral(profit);
730 
731                     totalClaims += profit;
732 
733                     //Apply reward bonus as collateral bonus divs
734                     profitPerShare_ = SafeMath.add(
735                         profitPerShare_,
736                         (profit * magnitude) / tokenSupply_
737                     );
738 
739                     lastPayout = now;
740                 } else {
741                     fundRewardPool();
742                 }
743             } else {
744                 fundRewardPool();
745             }
746         } else {
747             fundRewardPool();
748         }
749     }
750 
751     /// @dev Fund reward pool using the router; initial time and size logic gates and orchestration
752     function fundRewardPool() private {
753         //Only buy once
754         if (SafeMath.safeSub(now, lastFunding) >= fundingInterval) {
755             //Get the amount of the token in ETH and compare to the swapSize
756             address[] memory path = new address[](2);
757             path[0] = collateralAddress;
758             path[1] = swap.WETH();
759 
760             if (collateralBuffer_ > 0){
761                 uint256[] memory amounts = swap.getAmountsOut(
762                     collateralBuffer_,
763                     path
764                 );
765 
766                 if (amounts[1] >= flushSize) {
767                     uint256 amount = collateralBuffer_;
768 
769                     //reset Collector
770                     collateralBuffer_ = 0;
771 
772                     //reward token buyback; tokens come to address(this) in the rewardsToken
773                     collateralToReward(amount);
774 
775                     lastFunding = now;
776                 }
777             }
778         }
779     }
780 
781     //Execute the buyback against the router using WETH as a bridge
782     function collateralToReward(uint256 amount) private returns (uint256) {
783         address[] memory path = new address[](3);
784         path[0] = collateralAddress;
785         path[1] = swap.WETH();
786         path[2] = rewardAddress;
787 
788         //Need to be able to approve the collateral token for transfer
789         require(
790             collateralToken.approve(swapAddress, amount),
791             "Amount approved not available"
792         );
793 
794         uint256[] memory amounts = swap.swapExactTokensForTokens(
795             amount,
796             1,
797             path,
798             address(this),
799             now + 24 hours
800         );
801 
802         //2nd index is token amount
803         emit onCollateraltoReward(amount, amounts[2], now);
804 
805         return amounts[2];
806     }
807 
808     function rewardToCollateral(uint256 amount) private returns (uint256) {
809         address[] memory path = new address[](3);
810         path[0] = rewardAddress;
811         path[1] = swap.WETH();
812         path[2] = collateralAddress;
813 
814         //Need to be able to approve the collateral token for transfer
815         require(
816             rewardToken.approve(swapAddress, amount),
817             "Amount approved not available"
818         );
819 
820         uint256[] memory amounts = swap.swapExactTokensForTokens(
821             amount,
822             1,
823             path,
824             address(this),
825             now + 24 hours
826         );
827 
828         //2nd index is token amount
829         emit onRewardtoCollateral(amount, amounts[2], now);
830 
831         return amounts[2];
832     }
833 
834     /// @dev ETH to tokens
835     function ethToCollateral(uint256 amount) private returns (uint256) {
836         address[] memory path = new address[](2);
837         path[0] = swap.WETH();
838         path[1] = collateralAddress;
839 
840         uint256[] memory amounts = swap.swapExactETHForTokens.value(amount)(
841             1,
842             path,
843             address(this),
844             now + 24 hours
845         );
846 
847         //2nd index is token amount
848         emit onEthtoCollateral(amount, amounts[1], now);
849 
850         return amounts[1];
851     }
852 
853     /// @dev Internal function to actually purchase the tokens.
854     function purchaseTokens(address _customerAddress, uint256 _incomingtokens)
855         internal
856         returns (uint256)
857     {
858         /* Members */
859         if (
860             stats[_customerAddress].invested == 0 &&
861             stats[_customerAddress].receivedTokens == 0
862         ) {
863             players += 1;
864         }
865 
866         totalTxs += 1;
867 
868         // data setup
869         uint256 _undividedDividends = SafeMath.mul(_incomingtokens, entryFee_) /
870             100;
871         uint256 _amountOfTokens = SafeMath.sub(
872             _incomingtokens,
873             _undividedDividends
874         );
875 
876         // fire event
877         emit onTokenPurchase(
878             _customerAddress,
879             _incomingtokens,
880             _amountOfTokens,
881             now
882         );
883 
884         // yes we know that the safemath function automatically rules out the "greater then" equation.
885         require(
886             _amountOfTokens > 0 &&
887                 SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_,
888             "Tokens need to be positive"
889         );
890 
891         // we can't give people infinite eth
892         if (tokenSupply_ > 0) {
893             // add tokens to the pool
894             tokenSupply_ += _amountOfTokens;
895         } else {
896             // add tokens to the pool
897             tokenSupply_ = _amountOfTokens;
898         }
899 
900         // update circulating supply & the ledger address for the customer
901         tokenBalanceLedger_[_customerAddress] = SafeMath.add(
902             tokenBalanceLedger_[_customerAddress],
903             _amountOfTokens
904         );
905 
906         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
907         // really i know you think you do but you don't
908         int256 _updatedPayouts = (int256)(profitPerShare_ * _amountOfTokens);
909         payoutsTo_[_customerAddress] += _updatedPayouts;
910 
911         //drip and buybacks; instant requires being called after supply is updated
912         allocateFees(_undividedDividends);
913 
914         //Stats
915         stats[_customerAddress].invested += _incomingtokens;
916         stats[_customerAddress].xInvested += 1;
917 
918         return _amountOfTokens;
919     }
920 
921     /*==========================================
922     =            ADMIN FUNCTIONS               =
923     ==========================================*/
924 
925     /**
926      * @dev Update the router address to account for movement in liquidity long term
927      */
928     function updateSwapRouter(address _swapAddress) public onlyOwner() {
929         emit onRouterUpdate(swapAddress, _swapAddress);
930         swapAddress = _swapAddress;
931         swap = UniSwapV2LiteRouter(_swapAddress);
932     }
933 
934     /**
935      * @dev Update the flushSize (how often buy backs happen in terms of amount of ETH accumulated)
936      */
937     function updateFlushSize(uint256 _flushSize) public onlyOwner() {
938         require(
939             _flushSize >= 0.01 ether && _flushSize <= 5 ether,
940             "Flush size is out of range"
941         );
942 
943         emit onFlushUpdate(flushSize, _flushSize);
944         flushSize = _flushSize;
945     }
946 
947     /**
948      * @dev Update Intervals
949      */
950     function updateIntervals(uint256 _payout, uint256 _fund)
951         public
952         onlyOwner()
953     {
954         require(
955             _payout >= 2 seconds && _payout <= 24 hours,
956             "Interval out of range"
957         );
958         require(
959             _fund >= 2 seconds && _fund <= 24 hours,
960             "Interval out of range"
961         );
962 
963         payoutInterval = _payout;
964         fundingInterval = _fund;
965 
966         emit onUpdateIntervals(_payout, _fund);
967     }
968 }
969 
970 /**
971  * @title SafeMath
972  * @dev Math operations with safety checks that throw on error
973  */
974 library SafeMath {
975     /**
976      * @dev Multiplies two numbers, throws on overflow.
977      */
978     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
979         if (a == 0) {
980             return 0;
981         }
982         c = a * b;
983         assert(c / a == b);
984         return c;
985     }
986 
987     /**
988      * @dev Integer division of two numbers, truncating the quotient.
989      */
990     function div(uint256 a, uint256 b) internal pure returns (uint256) {
991         // assert(b > 0); // Solidity automatically throws when dividing by 0
992         // uint256 c = a / b;
993         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
994         return a / b;
995     }
996 
997     /**
998      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
999      */
1000     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1001         assert(b <= a);
1002         return a - b;
1003     }
1004 
1005     /* @dev Subtracts two numbers, else returns zero */
1006     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
1007         if (b > a) {
1008             return 0;
1009         } else {
1010             return a - b;
1011         }
1012     }
1013 
1014     /**
1015      * @dev Adds two numbers, throws on overflow.
1016      */
1017     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
1018         c = a + b;
1019         assert(c >= a);
1020         return c;
1021     }
1022 
1023     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1024         return a >= b ? a : b;
1025     }
1026 
1027     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1028         return a < b ? a : b;
1029     }
1030 }