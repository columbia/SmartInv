1 pragma solidity ^0.4.20;
2 
3 contract BreakTheBank {
4     /*=================================
5     =            MODIFIERS            =
6     =================================*/
7     // only people with tokens
8     modifier onlyBagholders() {
9         require(myTokens() > 0);
10         _;
11     }
12 
13     // only people with profits
14     modifier onlyStronghands() {
15         require(myDividends(true) > 0);
16         _;
17     }
18 
19     // administrator can:
20     // -> change the name of the contract
21     // -> change the name of the token
22     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
23     // they CANNOT:
24     // -> take funds
25     // -> disable withdrawals
26     // -> kill the contract
27     // -> change the price of tokens
28     modifier onlyAdministrator(){
29         require(msg.sender == owner);
30         _;
31     }
32 
33     modifier limitBuy() {
34         _;
35     }
36 
37     /*==============================
38     =            EVENTS            =
39     ==============================*/
40     event onTokenPurchase(
41         address indexed customerAddress,
42         uint256 incomingEthereum,
43         uint256 tokensMinted,
44         address indexed referredBy
45     );
46 
47     event onTokenSell(
48         address indexed customerAddress,
49         uint256 tokensBurned,
50         uint256 ethereumEarned
51     );
52 
53     event onReinvestment(
54         address indexed customerAddress,
55         uint256 ethereumReinvested,
56         uint256 tokensMinted
57     );
58 
59     event onWithdraw(
60         address indexed customerAddress,
61         uint256 ethereumWithdrawn
62     );
63 
64     event OnRedistribution (
65         uint256 amount,
66         uint256 timestamp
67     );
68 
69     // ERC20
70     event Transfer(
71         address indexed from,
72         address indexed to,
73         uint256 tokens
74     );
75 
76 
77     /*=====================================
78     =            CONFIGURABLES            =
79     =====================================*/
80     string public name = "BreakTheBank.me";
81     string public symbol = "BTB";
82     uint8 constant public decimals = 18;
83     uint8 constant internal dividendFee_ = 20; // 20%
84     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
85     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
86     uint256 constant internal magnitude = 2**64;
87 
88     // proof of stake (defaults at 10 tokens)
89     uint256 public stakingRequirement = 0;
90 
91 
92 
93    /*================================
94     =            DATASETS            =
95     ================================*/
96     // amount of shares for each address (scaled number)
97     mapping(address => uint256) internal tokenBalanceLedger_;
98     mapping(address => address) internal referralOf_;
99     mapping(address => uint256) internal referralBalance_;
100     mapping(address => int256) internal payoutsTo_;
101     mapping(address => bool) internal alreadyBought;
102     uint256 internal tokenSupply_ = 0;
103     uint256 internal profitPerShare_;
104     mapping(address => bool) internal whitelisted_;
105     bool internal whitelist_ = true;
106     bool internal limit = true;
107 
108     address public owner;
109 
110 
111 
112     /*=======================================
113     =            PUBLIC FUNCTIONS            =
114     =======================================*/
115     /*
116     * -- APPLICATION ENTRY POINTS --
117     */
118     constructor()
119         public
120     {
121         owner = msg.sender;
122         whitelisted_[msg.sender] = true;
123         // WorldFomo Divs Account
124         //whitelisted_[0xc2B140D3a0Cf1AFcE033Cbd7D058e7fC5729F50f] = true;
125 
126         whitelist_ = true;
127     }
128     
129 
130 
131 
132     /**
133      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
134      */
135     function buy(address _referredBy)
136         public
137         payable
138         returns(uint256)
139     {
140         purchaseTokens(msg.value, _referredBy);
141     }
142 
143     /**
144      * Fallback function to handle ethereum that was send straight to the contract
145      * Unfortunately we cannot use a referral address this way.
146      */
147     function()
148         payable
149         public
150     {
151         purchaseTokens(msg.value, 0x0);
152     }
153 
154     /**
155      * Converts all of caller's dividends to tokens.
156      */
157     function reinvest()
158         onlyStronghands()
159         public
160     {
161         // fetch dividends
162         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
163 
164         // pay out the dividends virtually
165         address _customerAddress = msg.sender;
166         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
167 
168         // retrieve ref. bonus
169         _dividends += referralBalance_[_customerAddress];
170         referralBalance_[_customerAddress] = 0;
171 
172         // dispatch a buy order with the virtualized "withdrawn dividends"
173         uint256 _tokens = purchaseTokens(_dividends, 0x0);
174 
175         // fire event
176         emit onReinvestment(_customerAddress, _dividends, _tokens);
177     }
178 
179     /**
180      * Alias of sell() and withdraw().
181      */
182     function exit()
183         public
184     {
185         // get token count for caller & sell them all
186         address _customerAddress = msg.sender;
187         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
188         if(_tokens > 0) sell(_tokens);
189 
190         // lambo delivery service
191         withdraw();
192     }
193 
194     /**
195      * Withdraws all of the callers earnings.
196      */
197     function withdraw()
198         onlyStronghands()
199         public
200     {
201         // setup data
202         address _customerAddress = msg.sender;
203         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
204 
205         // update dividend tracker
206         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
207 
208         // add ref. bonus
209         _dividends += referralBalance_[_customerAddress];
210         referralBalance_[_customerAddress] = 0;
211 
212         // lambo delivery service
213         _customerAddress.transfer(_dividends);
214 
215         // fire event
216         emit onWithdraw(_customerAddress, _dividends);
217     }
218 
219     /**
220      * Liquifies tokens to ethereum.
221      */
222     function sell(uint256 _amountOfTokens)
223         onlyBagholders()
224         public
225     {
226         // setup data
227         address _customerAddress = msg.sender;
228         // russian hackers BTFO
229         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
230         uint256 _tokens = _amountOfTokens;
231         uint256 _ethereum = tokensToEthereum_(_tokens);
232 
233         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100); // 20% dividendFee_
234         uint256 _referralBonus = SafeMath.div(_undividedDividends, 2); // 50% of dividends: 10%
235         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
236 
237 
238 
239         uint256 _taxedEthereum = SafeMath.sub(_ethereum, (_dividends));
240 
241         address _referredBy = referralOf_[_customerAddress];
242 
243         if(
244             // is this a referred purchase?
245             _referredBy != 0x0000000000000000000000000000000000000000 &&
246 
247             // no cheating!
248             _referredBy != _customerAddress &&
249 
250             // does the referrer have at least X whole tokens?
251             // i.e is the referrer a godly chad masternode
252             tokenBalanceLedger_[_referredBy] >= stakingRequirement
253         ){
254 
255             // wealth redistribution
256             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], (_referralBonus / 2)); // Tier 1 gets 50% of referrals (5%)
257 
258             address tier2 = referralOf_[_referredBy];
259 
260             if (tier2 != 0x0000000000000000000000000000000000000000 && tokenBalanceLedger_[tier2] >= stakingRequirement) {
261                 referralBalance_[tier2] = SafeMath.add(referralBalance_[tier2], (_referralBonus*30 / 100)); // Tier 2 gets 30% of referrals (3%)
262 
263                 //address tier3 = referralOf_[tier2];
264                 if (referralOf_[tier2] != 0x0000000000000000000000000000000000000000 && tokenBalanceLedger_[referralOf_[tier2]] >= stakingRequirement) {
265                     referralBalance_[referralOf_[tier2]] = SafeMath.add(referralBalance_[referralOf_[tier2]], (_referralBonus*20 / 100)); // Tier 3 get 20% of referrals (2%)
266                     }
267                 else {
268                     _dividends = SafeMath.add(_dividends, (_referralBonus*20 / 100));
269                 }
270             }
271             else {
272                 _dividends = SafeMath.add(_dividends, (_referralBonus*50 / 100));
273             }
274 
275         } else {
276             // no ref purchase
277             // add the referral bonus back to the global dividends cake
278             _dividends = SafeMath.add(_dividends, _referralBonus);
279         }
280 
281         // burn the sold tokens
282         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
283         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
284 
285         // update dividends tracker
286         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
287         payoutsTo_[_customerAddress] -= _updatedPayouts;
288 
289         // dividing by zero is a bad idea
290         if (tokenSupply_ > 0) {
291             // update the amount of dividends per token
292             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
293         }
294 
295         // fire event
296         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
297     }
298 
299      /**
300      * Transfer tokens from the caller to a new holder.
301      * 0% fee.
302      */
303     function transfer(address _toAddress, uint256 _amountOfTokens)
304         onlyBagholders()
305         public
306         returns(bool)
307     {
308         // setup
309         address _customerAddress = msg.sender;
310 
311         // make sure we have the requested tokens
312         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
313 
314         // withdraw all outstanding dividends first
315         if(myDividends(true) > 0) withdraw();
316 
317         // exchange tokens
318         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
319         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
320 
321         // update dividend trackers
322         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
323         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
324 
325         // fire event
326         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
327 
328         // ERC20
329         return true;
330 
331     }
332 
333     /**
334     * redistribution of dividends
335      */
336     function redistribution()
337         external
338         payable
339     {
340         // setup
341         uint256 ethereum = msg.value;
342 
343         // disperse ethereum among holders
344         profitPerShare_ = SafeMath.add(profitPerShare_, (ethereum * magnitude) / tokenSupply_);
345 
346         // fire event
347         emit OnRedistribution(ethereum, block.timestamp);
348     }
349 
350     /**
351      * In case one of us dies, we need to replace ourselves.
352      */
353     function setAdministrator(address _newAdmin)
354         onlyAdministrator()
355         external
356     {
357         owner = _newAdmin;
358     }
359 
360     /**
361      * Precautionary measures in case we need to adjust the masternode rate.
362      */
363     function setStakingRequirement(uint256 _amountOfTokens)
364         onlyAdministrator()
365         public
366     {
367         stakingRequirement = _amountOfTokens;
368     }
369 
370     /**
371      * If we want to rebrand, we can.
372      */
373     function setName(string _name)
374         onlyAdministrator()
375         public
376     {
377         name = _name;
378     }
379 
380     /**
381      * If we want to rebrand, we can.
382      */
383     function setSymbol(string _symbol)
384         onlyAdministrator()
385         public
386     {
387         symbol = _symbol;
388     }
389 
390 
391     /*----------  HELPERS AND CALCULATORS  ----------*/
392     /**
393      * Method to view the current Ethereum stored in the contract
394      * Example: totalEthereumBalance()
395      */
396     function totalEthereumBalance()
397         public
398         view
399         returns(uint)
400     {
401         return address(this).balance;
402     }
403 
404     /**
405      * Retrieve the total token supply.
406      */
407     function totalSupply()
408         public
409         view
410         returns(uint256)
411     {
412         return tokenSupply_;
413     }
414 
415     /**
416      * Retrieve the tokens owned by the caller.
417      */
418     function myTokens()
419         public
420         view
421         returns(uint256)
422     {
423         address _customerAddress = msg.sender;
424         return balanceOf(_customerAddress);
425     }
426 
427     /**
428      * Retrieve the dividends owned by the caller.
429      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
430      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
431      * But in the internal calculations, we want them separate.
432      */
433     function myDividends(bool _includeReferralBonus)
434         public
435         view
436         returns(uint256)
437     {
438         address _customerAddress = msg.sender;
439         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
440     }
441 
442     /**
443      * Retrieve the token balance of any single address.
444      */
445     function balanceOf(address _customerAddress)
446         view
447         public
448         returns(uint256)
449     {
450         return tokenBalanceLedger_[_customerAddress];
451     }
452 
453     /**
454      * Retrieve the dividend balance of any single address.
455      */
456     function dividendsOf(address _customerAddress)
457         view
458         public
459         returns(uint256)
460     {
461         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
462     }
463 
464     /**
465      * Return the buy price of 1 individual token.
466      */
467     function sellPrice()
468         public
469         view
470         returns(uint256)
471     {
472         // our calculation relies on the token supply, so we need supply. Doh.
473         if(tokenSupply_ == 0){
474             return tokenPriceInitial_ - tokenPriceIncremental_;
475         } else {
476             uint256 _ethereum = tokensToEthereum_(1e18);
477             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_),100);
478             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
479             return _taxedEthereum;
480         }
481     }
482 
483     /**
484      * Return the sell price of 1 individual token.
485      */
486     function buyPrice()
487         public
488         view
489         returns(uint256)
490     {
491         // our calculation relies on the token supply, so we need supply. Doh.
492         if(tokenSupply_ == 0){
493             return tokenPriceInitial_ + tokenPriceIncremental_;
494         } else {
495             uint256 _ethereum = tokensToEthereum_(1e18);
496             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_),100);
497             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
498             return _taxedEthereum;
499         }
500     }
501 
502     /**
503      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
504      */
505     function calculateTokensReceived(uint256 _ethereumToSpend)
506         public
507         view
508         returns(uint256)
509     {
510         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, dividendFee_),100);
511         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
512         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
513 
514         return _amountOfTokens;
515     }
516 
517     /**
518      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
519      */
520     function calculateEthereumReceived(uint256 _tokensToSell)
521         public
522         view
523         returns(uint256)
524     {
525         require(_tokensToSell <= tokenSupply_);
526         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
527         uint256 _dividends =  SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
528         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
529         return _taxedEthereum;
530     }
531 
532     function disableWhitelist() onlyAdministrator() external {
533         whitelist_ = false;
534     }
535 
536     /*==========================================
537     =            INTERNAL FUNCTIONS            =
538     ==========================================*/
539     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
540         limitBuy()
541         internal
542         returns(uint256)
543     {
544 
545         //As long as the whitelist is true, only whitelisted people are allowed to buy.
546 
547         // if the person is not whitelisted but whitelist is true/active, revert the transaction
548         if (whitelisted_[msg.sender] == false && whitelist_ == true) {
549             revert();
550         }
551         // data setup
552         address _customerAddress = msg.sender;
553         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100); // 20% dividendFee_
554 
555 
556         uint256 _referralBonus = SafeMath.div(_undividedDividends, 2); // 50% of dividends: 10%
557 
558         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
559 
560         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, (_undividedDividends));
561         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
562         uint256 _fee = _dividends * magnitude;
563 
564 
565         // no point in continuing execution if OP is a poorfag russian hacker
566         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
567         // (or hackers)
568         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
569         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
570 
571         // is the user referred by a masternode?
572         if(
573             // is this a referred purchase?
574             _referredBy != 0x0000000000000000000000000000000000000000 &&
575 
576             // no cheating!
577             _referredBy != _customerAddress &&
578 
579             // does the referrer have at least X whole tokens?
580             // i.e is the referrer a godly chad masternode
581             tokenBalanceLedger_[_referredBy] >= stakingRequirement &&
582 
583             referralOf_[_customerAddress] == 0x0000000000000000000000000000000000000000 &&
584 
585             alreadyBought[_customerAddress] == false
586         ){
587             referralOf_[_customerAddress] = _referredBy;
588 
589             // wealth redistribution
590             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], (_referralBonus / 2)); // Tier 1 gets 50% of referrals (5%)
591 
592             address tier2 = referralOf_[_referredBy];
593 
594             if (tier2 != 0x0000000000000000000000000000000000000000 && tokenBalanceLedger_[tier2] >= stakingRequirement) {
595                 referralBalance_[tier2] = SafeMath.add(referralBalance_[tier2], (_referralBonus*30 / 100)); // Tier 2 gets 30% of referrals (3%)
596 
597                 //address tier3 = referralOf_[tier2];
598 
599                 if (referralOf_[tier2] != 0x0000000000000000000000000000000000000000 && tokenBalanceLedger_[referralOf_[tier2]] >= stakingRequirement) {
600                     referralBalance_[referralOf_[tier2]] = SafeMath.add(referralBalance_[referralOf_[tier2]], (_referralBonus*20 / 100)); // Tier 3 get 20% of referrals (2%)
601                     }
602                 else {
603                     _dividends = SafeMath.add(_dividends, (_referralBonus*20 / 100));
604                     _fee = _dividends * magnitude;
605                 }
606             }
607             else {
608                 _dividends = SafeMath.add(_dividends, (_referralBonus*50 / 100));
609                 _fee = _dividends * magnitude;
610             }
611 
612         } else {
613             // no ref purchase
614             // add the referral bonus back to the global dividends cake
615             _dividends = SafeMath.add(_dividends, _referralBonus);
616             _fee = _dividends * magnitude;
617         }
618 
619         // we can't give people infinite ethereum
620         if(tokenSupply_ > 0){
621 
622             // add tokens to the pool
623             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
624 
625             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
626             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
627 
628             // calculate the amount of tokens the customer receives over his purchase
629             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
630 
631         } else {
632             // add tokens to the pool
633             tokenSupply_ = _amountOfTokens;
634         }
635 
636         // update circulating supply & the ledger address for the customer
637         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
638 
639         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
640         //really i know you think you do but you don't
641         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
642         payoutsTo_[_customerAddress] += _updatedPayouts;
643         alreadyBought[_customerAddress] = true;
644         // fire event
645         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
646 
647         return _amountOfTokens;
648     }
649 
650     /**
651      * Calculate Token price based on an amount of incoming ethereum
652      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
653      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
654      */
655     function ethereumToTokens_(uint256 _ethereum)
656         internal
657         view
658         returns(uint256)
659     {
660         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
661         uint256 _tokensReceived =
662          (
663             (
664                 // underflow attempts BTFO
665                 SafeMath.sub(
666                     (sqrt
667                         (
668                             (_tokenPriceInitial**2)
669                             +
670                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
671                             +
672                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
673                             +
674                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
675                         )
676                     ), _tokenPriceInitial
677                 )
678             )/(tokenPriceIncremental_)
679         )-(tokenSupply_)
680         ;
681 
682         return _tokensReceived;
683     }
684 
685     /**
686      * Calculate token sell value.
687      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
688      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
689      */
690     function tokensToEthereum_(uint256 _tokens)
691         internal
692         view
693         returns(uint256)
694     {
695 
696         uint256 tokens_ = (_tokens + 1e18);
697         uint256 _tokenSupply = (tokenSupply_ + 1e18);
698         uint256 _etherReceived =
699         (
700             // underflow attempts BTFO
701             SafeMath.sub(
702                 (
703                     (
704                         (
705                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
706                         )-tokenPriceIncremental_
707                     )*(tokens_ - 1e18)
708                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
709             )
710         /1e18);
711         return _etherReceived;
712     }
713 
714 
715     //This is where all your gas goes, sorry
716     //Not sorry, you probably only paid 1 gwei
717     function sqrt(uint x) internal pure returns (uint y) {
718         uint z = (x + 1) / 2;
719         y = x;
720         while (z < y) {
721             y = z;
722             z = (x / z + z) / 2;
723         }
724     }
725 }
726 
727 /**
728  * @title SafeMath
729  * @dev Math operations with safety checks that throw on error
730  */
731 library SafeMath {
732 
733     /**
734     * @dev Multiplies two numbers, throws on overflow.
735     */
736     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
737         if (a == 0) {
738             return 0;
739         }
740         uint256 c = a * b;
741         assert(c / a == b);
742         return c;
743     }
744 
745     /**
746     * @dev Integer division of two numbers, truncating the quotient.
747     */
748     function div(uint256 a, uint256 b) internal pure returns (uint256) {
749         // assert(b > 0); // Solidity automatically throws when dividing by 0
750         uint256 c = a / b;
751         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
752         return c;
753     }
754 
755     /**
756     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
757     */
758     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
759         assert(b <= a);
760         return a - b;
761     }
762 
763     /**
764     * @dev Adds two numbers, throws on overflow.
765     */
766     function add(uint256 a, uint256 b) internal pure returns (uint256) {
767         uint256 c = a + b;
768         assert(c >= a);
769         return c;
770     }
771 }