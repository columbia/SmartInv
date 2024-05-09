1 pragma solidity ^0.4.20;
2 
3 
4 contract Lottery{
5   function lockTokens(address entrant,uint toLock) external;
6   function contestOver() public view returns(bool);
7 }
8 contract TOKEN {
9    function totalSupply() external view returns (uint256);
10    function balanceOf(address account) external view returns (uint256);
11    function transfer(address recipient, uint256 amount) external returns (bool);
12    function allowance(address owner, address spender) external view returns (uint256);
13    function approve(address spender, uint256 amount) external returns (bool);
14    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
15 }
16 contract Spooky {
17     /*=================================
18     =            MODIFIERS            =
19     =================================*/
20     // only people with tokens
21     modifier onlyBagholders() {
22         require(myTokens() > 0);
23         _;
24     }
25 
26     // only people with profits
27     modifier onlyStronghands() {
28         require(myDividends(true) > 0);
29         _;
30     }
31 
32     // administrators can:
33     // -> change the name of the contract
34     // -> change the name of the token
35     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
36     // they CANNOT:
37     // -> take funds
38     // -> disable withdrawals
39     // -> kill the contract
40     // -> change the price of tokens
41     modifier onlyAdministrator(){
42         require(administrators[msg.sender]);
43         _;
44     }
45 
46 
47     // ensures that the first tokens in the contract will be equally distributed
48     // meaning, no divine dump will be ever possible
49     // result: healthy longevity.
50     modifier antiEarlyWhale(uint256 _amountOfGhost){
51         address _customerAddress = msg.sender;
52 
53         // are we still in the vulnerable phase?
54         // if so, enact anti early whale protocol
55         if( onlyAmbassadors && ((totalGhostBalance() - _amountOfGhost) <= ambassadorQuota_ )){
56             require(
57                 // is the customer in the ambassador list?
58                 ambassadors_[_customerAddress] == true &&
59 
60                 // does the customer purchase exceed the max ambassador quota?
61                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfGhost) <= ambassadorMaxPurchase_
62 
63             ,"early phase unsuccessful");
64 
65             // updated the accumulated quota
66             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfGhost);
67 
68             // execute
69             _;
70         } else {
71             // in case the ether count drops low, the ambassador phase won't reinitiate
72             onlyAmbassadors = false;
73             _;
74         }
75 
76     }
77 
78 
79     /*==============================
80     =            EVENTS            =
81     ==============================*/
82     event onTokenPurchase(
83         address indexed customerAddress,
84         uint256 incomingGhost,
85         uint256 tokensMinted,
86         address indexed referredBy
87     );
88 
89     event onTokenSell(
90         address indexed customerAddress,
91         uint256 tokensBurned,
92         uint256 ghostEarned
93     );
94 
95     event onReinvestment(
96         address indexed customerAddress,
97         uint256 ghostReinvested,
98         uint256 tokensMinted
99     );
100 
101     event onWithdraw(
102         address indexed customerAddress,
103         uint256 ghostWithdrawn
104     );
105 
106     // ERC20
107     event Transfer(
108         address indexed from,
109         address indexed to,
110         uint256 tokens
111     );
112 
113 
114     /*=====================================
115     =            CONFIGURABLES            =
116     =====================================*/
117     string public name = "Ghost Town";
118     string public symbol = "GTS";
119     uint8 constant public decimals = 18;
120     //uint8 constant internal dividendFee_ = 10;
121     uint256 internal entryFee_ = 13;
122     uint256 internal exitFee_ = 13;
123     uint256 internal lotteryFee_ = 30; //5%
124     uint256 internal referralFee_ = 15; // 10% of the 10% buy or sell fees makes it 1%
125     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
126     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
127     uint256 constant internal magnitude = 2**64;
128 
129     // proof of stake (defaults at 100 tokens)
130     uint256 public stakingRequirement = 0;//100e18;
131 
132     // ambassador program
133     mapping(address => bool) internal ambassadors_;
134     uint256 constant internal ambassadorMaxPurchase_ = 200 ether;
135     uint256 constant internal ambassadorQuota_ = 2000 ether;
136 
137 
138 
139    /*================================
140     =            DATASETS            =
141     ================================*/
142     // amount of shares for each address (scaled number)
143     mapping(address => uint256) internal tokenBalanceLedger_;
144     mapping(address => uint256) internal referralBalance_;
145     mapping(address => address) public referralLocks_;//mandatory locked in referrals
146     mapping(address => int256) internal payoutsTo_;
147     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
148     uint256 internal tokenSupply_ = 0;
149     uint256 internal profitPerShare_;
150 
151     // administrator list (see above on what they can do)
152     mapping(address => bool) public administrators;
153 
154     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
155     bool public onlyAmbassadors = true;
156 
157     TOKEN erc20;
158 
159     //lottery related
160     Lottery public lotteryContract;
161     mapping(address => bool) public lotteryLocked;
162 
163     //view only referral data
164     mapping(address => uint) public referralCount;
165     mapping(address => uint) public feesFromReferral;
166 
167     /*=======================================
168     =            PUBLIC FUNCTIONS            =
169     =======================================*/
170     /*
171     * -- APPLICATION ENTRY POINTS --
172     */
173     constructor(address tokenaddr)
174         public
175     {
176         // add administrators here
177         administrators[0xaEbbd80Fd7dAe979d965A3a5b09bBCD23eB40e5F] = true;
178         administrators[msg.sender]=true;
179 
180         // add the ambassadors here.
181         ambassadors_[0xaEbbd80Fd7dAe979d965A3a5b09bBCD23eB40e5F] = true;
182         ambassadors_[0x3dF3766E64C2C85Ce1baa858d2A14F96916d5087] = true;
183         ambassadors_[0x8Cc62C4dCF129188ce4b43103eAefc0d6b71af6d] = true;
184         ambassadors_[0xE7F53CE9421670AC2f11C5035E6f6f13d9829aa6] = true;
185         ambassadors_[0x43678bB266e75F50Fbe5927128Ab51930b447eaB] = true;
186         ambassadors_[0xf5C2CbD8207eE1f0C798C59Dcb27ccA46E1093ec] = true;
187         ambassadors_[0xd0Ce592b78Cfc6D0EDa67c3ED6fF9994179e8060] = true;
188 
189         erc20 = TOKEN(tokenaddr);
190     }
191 
192     /*
193       New functions
194     */
195     function setLotteryAddress(address l) public onlyAdministrator{
196       require(lotteryContract==address(0),"lottery contract already set");
197       lotteryContract=Lottery(l);
198     }
199     /*
200       enter the lottery, locking sells until it is concluded
201     */
202     function enterLottery() public {
203       require(!ambassadors_[msg.sender],"ambassadors not eligible for lottery");
204       require(!lotteryLocked[msg.sender],"already entered lottery");
205       require(tokenBalanceLedger_[msg.sender]>0,"token balance is zero");
206       require(!lotteryContract.contestOver(),"lottery over, cannot enter");
207       lotteryLocked[msg.sender]=true;
208       lotteryContract.lockTokens(msg.sender,tokenBalanceLedger_[msg.sender]);
209     }
210     function checkAndTransferGHOST(uint256 _amount) private {
211         require(erc20.transferFrom(msg.sender, address(this), _amount) == true, "transfer must succeed");
212     }
213 
214     /**
215      * Converts all incoming ghost to tokens for the caller, and passes down the referral addy (if any)
216      */
217     function buy(uint _amount,address _referredBy)
218         public
219         returns(uint256)
220     {
221         checkAndTransferGHOST(_amount);
222         purchaseTokens(_amount, _referredBy);
223     }
224 
225     /**
226      * Fallback function to handle ghost that was send straight to the contract
227      */
228     function()
229         payable
230         public
231     {
232         revert();
233     }
234 
235     /**
236      * Converts all of caller's dividends to tokens.
237      */
238     function reinvest()
239         onlyStronghands()
240         public
241     {
242         // fetch dividends
243         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
244 
245         // pay out the dividends virtually
246         address _customerAddress = msg.sender;
247         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
248 
249         // retrieve ref. bonus
250         _dividends += referralBalance_[_customerAddress];
251         referralBalance_[_customerAddress] = 0;
252 
253         // dispatch a buy order with the virtualized "withdrawn dividends"
254         uint256 _tokens = purchaseTokens(_dividends, 0x0);
255 
256         // fire event
257         emit onReinvestment(_customerAddress, _dividends, _tokens);
258     }
259 
260     /**
261      * Alias of sell() and withdraw().
262      */
263     function exit()
264         public
265     {
266         // get token count for caller & sell them all
267         address _customerAddress = msg.sender;
268         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
269         if(_tokens > 0) sell(_tokens);
270 
271         // lambo delivery service
272         withdraw();
273     }
274 
275     /**
276      * Withdraws all of the callers earnings.
277      */
278     function withdraw()
279         onlyStronghands()
280         public
281     {
282         // setup data
283         address _customerAddress = msg.sender;
284         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
285 
286         // update dividend tracker
287         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
288 
289         // add ref. bonus
290         _dividends += referralBalance_[_customerAddress];
291         referralBalance_[_customerAddress] = 0;
292 
293         // send ghost
294         erc20.transfer(_customerAddress, _dividends);
295 
296         // fire event
297         emit onWithdraw(_customerAddress, _dividends);
298     }
299 
300     /**
301      * Liquifies tokens to ghost.
302      */
303     function sell(uint256 _amountOfTokens)
304         onlyBagholders()
305         public
306     {
307         //if user has staked their GT tokens, only allow them to sell after the raffle is concluded
308         if(lotteryLocked[msg.sender]){
309           require(lotteryContract.contestOver(),"locked for lottery but lottery not over");
310         }
311         // setup data
312         address _customerAddress = msg.sender;
313         // russian hackers BTFO
314         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
315         uint256 _ghost = tokensToGhost_(_amountOfTokens);
316         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_ghost, exitFee_), 100);
317         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, referralFee_), 100);
318         uint256 _lotteryFee = SafeMath.div(SafeMath.mul(_undividedDividends,lotteryFee_), 100);
319         uint256 _dividends = SafeMath.sub(_undividedDividends, SafeMath.add(_referralBonus,_lotteryFee));
320         uint256 _taxedGhost = SafeMath.sub(_ghost,_undividedDividends); //_dividends);
321 
322         //transfer lottery fee
323         if(lotteryContract!=address(0))
324         {
325           erc20.transfer(lotteryContract,_lotteryFee);
326         }
327         //referral locking
328         address _referredBy=0x0000000000000000000000000000000000000000;
329         if(referralLocks_[msg.sender]!=0x0000000000000000000000000000000000000000){
330           _referredBy=referralLocks_[msg.sender];
331         }
332         // is the user referred by a masternode?
333         if(
334             // is this a referred purchase?
335             _referredBy != 0x0000000000000000000000000000000000000000 &&
336             _referredBy != _customerAddress &&
337             tokenBalanceLedger_[_referredBy] >= stakingRequirement
338         ){
339             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
340         } else {
341             // no ref purchase
342             // add the referral bonus back to the global dividends cake
343             _dividends = SafeMath.add(_dividends, _referralBonus);
344             //_fee = _dividends * magnitude;
345         }
346 
347         // burn the sold tokens
348         tokenSupply_ = SafeMath.sub(tokenSupply_, _amountOfTokens);
349         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
350 
351         // update dividends tracker
352         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens + (_taxedGhost * magnitude));
353         payoutsTo_[_customerAddress] -= _updatedPayouts;
354 
355         // dividing by zero is a bad idea
356         if (tokenSupply_ > 0) {
357             // update the amount of dividends per token
358             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
359         }
360 
361         // fire event
362         emit onTokenSell(_customerAddress, _amountOfTokens, _taxedGhost);
363     }
364 
365 
366 
367     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
368     /**
369      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
370      */
371     function disableInitialStage()
372         onlyAdministrator()
373         public
374     {
375         onlyAmbassadors = false;
376     }
377 
378     /**
379      * In case one of us dies, we need to replace ourselves.
380      */
381     function setAdministrator(address _identifier, bool _status)
382         onlyAdministrator()
383         public
384     {
385         administrators[_identifier] = _status;
386     }
387 
388     /**
389      * Precautionary measures in case we need to adjust the masternode rate.
390      */
391     function setStakingRequirement(uint256 _amountOfTokens)
392         onlyAdministrator()
393         public
394     {
395         stakingRequirement = _amountOfTokens;
396     }
397 
398     /**
399      * If we want to rebrand, we can.
400      */
401     function setName(string _name)
402         onlyAdministrator()
403         public
404     {
405         name = _name;
406     }
407 
408     /**
409      * If we want to rebrand, we can.
410      */
411     function setSymbol(string _symbol)
412         onlyAdministrator()
413         public
414     {
415         symbol = _symbol;
416     }
417 
418 
419     /*----------  HELPERS AND CALCULATORS  ----------*/
420     /**
421      * Method to view the current Ghost stored in the contract
422      * Example: totalGhostBalance()
423      */
424     function totalGhostBalance()
425         public
426         view
427         returns(uint)
428     {
429         return erc20.balanceOf(address(this));//this.balance;
430     }
431 
432     /**
433      * Retrieve the total token supply.
434      */
435     function totalSupply()
436         public
437         view
438         returns(uint256)
439     {
440         return tokenSupply_;
441     }
442 
443     /**
444      * Retrieve the tokens owned by the caller.
445      */
446     function myTokens()
447         public
448         view
449         returns(uint256)
450     {
451         address _customerAddress = msg.sender;
452         return balanceOf(_customerAddress);
453     }
454 
455     /**
456      * Retrieve the dividends owned by the caller.
457      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
458      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
459      * But in the internal calculations, we want them separate.
460      */
461     function myDividends(bool _includeReferralBonus)
462         public
463         view
464         returns(uint256)
465     {
466         address _customerAddress = msg.sender;
467         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
468     }
469 
470     /**
471      * Retrieve the token balance of any single address.
472      */
473     function balanceOf(address _customerAddress)
474         view
475         public
476         returns(uint256)
477     {
478         return tokenBalanceLedger_[_customerAddress];
479     }
480 
481     /**
482      * Retrieve the dividend balance of any single address.
483      */
484     function dividendsOf(address _customerAddress)
485         view
486         public
487         returns(uint256)
488     {
489         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
490     }
491 
492     /**
493      * Return the buy price of 1 individual token.
494      */
495     function sellPrice()
496         public
497         view
498         returns(uint256)
499     {
500         // our calculation relies on the token supply, so we need supply. Doh.
501         if(tokenSupply_ == 0){
502             return tokenPriceInitial_ - tokenPriceIncremental_;
503         } else {
504             uint256 _ghost = tokensToGhost_(1e18);
505             uint256 _dividends = SafeMath.div(SafeMath.mul(_ghost, exitFee_ ),100 );
506             uint256 _taxedGhost = SafeMath.sub(_ghost, _dividends);
507             return _taxedGhost;
508         }
509     }
510 
511     /**
512      * Return the sell price of 1 individual token.
513      */
514     function buyPrice()
515         public
516         view
517         returns(uint256)
518     {
519         // our calculation relies on the token supply, so we need supply. Doh.
520         if(tokenSupply_ == 0){
521             return tokenPriceInitial_ + tokenPriceIncremental_;
522         } else {
523             uint256 _ghost = tokensToGhost_(1e18);
524             uint256 _dividends = SafeMath.div(SafeMath.mul(_ghost, entryFee_ ),100 );
525             uint256 _taxedGhost = SafeMath.add(_ghost, _dividends);
526             return _taxedGhost;
527         }
528     }
529 
530     /**
531      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
532      */
533     function calculateTokensReceived(uint256 _ghostToSpend)
534         public
535         view
536         returns(uint256)
537     {
538         uint256 _dividends = SafeMath.div(SafeMath.mul(_ghostToSpend, entryFee_),100);
539         uint256 _taxedGhost = SafeMath.sub(_ghostToSpend, _dividends);
540         uint256 _amountOfTokens = ghostToTokens_(_taxedGhost);
541 
542         return _amountOfTokens;
543     }
544 
545     /**
546      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
547      */
548     function calculateGhostReceived(uint256 _tokensToSell)
549         public
550         view
551         returns(uint256)
552     {
553         require(_tokensToSell <= tokenSupply_);
554         uint256 _ghost = tokensToGhost_(_tokensToSell);
555         uint256 _dividends = SafeMath.div(SafeMath.mul(_ghost, exitFee_),100);
556         uint256 _taxedGhost = SafeMath.sub(_ghost, _dividends);
557         return _taxedGhost;
558     }
559 
560 
561     /*==========================================
562     =            INTERNAL FUNCTIONS            =
563     ==========================================*/
564     function purchaseTokens(uint256 _incomingGhost, address _referredBy)
565         antiEarlyWhale(_incomingGhost)
566         internal
567         returns(uint256)
568     {
569         // data setup
570         //address _customerAddress = msg.sender;
571         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingGhost, entryFee_),100);
572         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, referralFee_),100);
573         uint256 _lotteryFee = SafeMath.div(SafeMath.mul(_undividedDividends,lotteryFee_), 100);
574         uint256 _dividends = SafeMath.sub(_undividedDividends, SafeMath.add(_lotteryFee,_referralBonus));
575         uint256 _taxedGhost = SafeMath.sub(_incomingGhost, _undividedDividends);
576         uint256 _amountOfTokens = ghostToTokens_(_taxedGhost);
577         uint256 _fee = _dividends * magnitude;
578 
579         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
580 
581         //transfer lottery fee
582         if(lotteryContract!=address(0))
583         {
584           erc20.transfer(lotteryContract,_lotteryFee);
585         }
586         //referral locking
587         if(referralLocks_[msg.sender]==0x0000000000000000000000000000000000000000){
588           referralLocks_[msg.sender]=_referredBy;
589           referralCount[_referredBy]+=1;//view only, doesnt affect anything
590         }
591         else{
592           _referredBy=referralLocks_[msg.sender];
593         }
594         // is the user referred by a masternode?
595         if(
596             // is this a referred purchase?
597             _referredBy != 0x0000000000000000000000000000000000000000 &&
598             _referredBy != msg.sender &&
599             tokenBalanceLedger_[_referredBy] >= stakingRequirement
600         ){
601             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
602             feesFromReferral[_referredBy]+=_referralBonus;//view only, doesn't affect anything
603         } else {
604             // no ref purchase
605             // add the referral bonus back to the global dividends cake
606             _dividends = SafeMath.add(_dividends, _referralBonus);
607             _fee = _dividends * magnitude;
608         }
609 
610 
611         // we can't give people infinite ghost
612         if(tokenSupply_ > 0){
613 
614             // add tokens to the pool
615             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
616 
617             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
618             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
619 
620             // calculate the amount of tokens the customer receives over his purchase
621             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
622 
623         } else {
624             // add tokens to the pool
625             tokenSupply_ = _amountOfTokens;
626         }
627 
628         // update circulating supply & the ledger address for the customer
629         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
630 
631         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
632         //really i know you think you do but you don't
633         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
634         payoutsTo_[msg.sender] += _updatedPayouts;
635 
636         // fire event
637         emit onTokenPurchase(msg.sender, _incomingGhost, _amountOfTokens, _referredBy);
638 
639         return _amountOfTokens;
640     }
641 
642     /**
643      * Calculate Token price based on an amount of incoming ghost
644      */
645     function ghostToTokens_(uint256 _ghost)
646         internal
647         view
648         returns(uint256)
649     {
650         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
651         uint256 _tokensReceived =
652          (
653             (
654                 // underflow attempts BTFO
655                 SafeMath.sub(
656                     (sqrt
657                         (
658                             (_tokenPriceInitial**2)
659                             +
660                             (2*(tokenPriceIncremental_ * 1e18)*(_ghost * 1e18))
661                             +
662                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
663                             +
664                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
665                         )
666                     ), _tokenPriceInitial
667                 )
668             )/(tokenPriceIncremental_)
669         )-(tokenSupply_)
670         ;
671 
672         return _tokensReceived;
673     }
674 
675     /**
676      * Calculate token sell value.
677      */
678      function tokensToGhost_(uint256 _tokens)
679         internal
680         view
681         returns(uint256)
682     {
683 
684         uint256 tokens_ = (_tokens + 1e18);
685         uint256 _tokenSupply = (tokenSupply_ + 1e18);
686         uint256 _etherReceived =
687         (
688             // underflow attempts BTFO
689             SafeMath.sub(
690                 (
691                     (
692                         (
693                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
694                         )-tokenPriceIncremental_
695                     )*(tokens_ - 1e18)
696                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
697             )
698         /1e18);
699         return _etherReceived;
700     }
701 
702 
703     //This is where all your gas goes, sorry
704     //Not sorry, you probably only paid 1 gwei
705     function sqrt(uint x) internal pure returns (uint y) {
706         uint z = (x + 1) / 2;
707         y = x;
708         while (z < y) {
709             y = z;
710             z = (x / z + z) / 2;
711         }
712     }
713 }
714 
715 /**
716  * @title SafeMath
717  * @dev Math operations with safety checks that throw on error
718  */
719 library SafeMath {
720 
721     /**
722     * @dev Multiplies two numbers, throws on overflow.
723     */
724     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
725         if (a == 0) {
726             return 0;
727         }
728         uint256 c = a * b;
729         assert(c / a == b);
730         return c;
731     }
732 
733     /**
734     * @dev Integer division of two numbers, truncating the quotient.
735     */
736     function div(uint256 a, uint256 b) internal pure returns (uint256) {
737         // assert(b > 0); // Solidity automatically throws when dividing by 0
738         uint256 c = a / b;
739         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
740         return c;
741     }
742 
743     /**
744     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
745     */
746     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
747         assert(b <= a);
748         return a - b;
749     }
750 
751     /**
752     * @dev Adds two numbers, throws on overflow.
753     */
754     function add(uint256 a, uint256 b) internal pure returns (uint256) {
755         uint256 c = a + b;
756         assert(c >= a);
757         return c;
758     }
759 }