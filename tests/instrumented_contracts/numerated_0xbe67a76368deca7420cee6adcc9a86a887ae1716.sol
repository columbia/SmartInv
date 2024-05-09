1 contract BossWage {
2     /*=================================
3     =            MODIFIERS            =
4     =================================*/
5     // only people with tokens
6     modifier onlyBagholders() {
7         require(myTokens() > 0);
8         _;
9     }
10 
11     // only people with profits
12     modifier onlyStronghands() {
13         require(getDividends(msg.sender, true) > 0);
14         _;
15     }
16 
17     // administrators can:
18     // -> change the name of the contract
19     // -> change the name of the token
20     // they CANNOT:
21     // -> take funds
22     // -> disable withdrawals
23     // -> kill the contract
24     // -> change the price of tokens
25     modifier onlyAdministrator(){
26         address _customerAddress = msg.sender;
27         require(administrators[keccak256(_customerAddress)]);
28         _;
29     }
30 
31 
32     /*==============================
33     =            EVENTS            =
34     ==============================*/
35     event onTokenPurchase(
36         address indexed customerAddress,
37         uint256 incomingEthereum,
38         uint256 tokensMinted,
39         address indexed referredBy
40     );
41 
42     event onTokenSell(
43         address indexed customerAddress,
44         uint256 tokensBurned,
45         uint256 ethereumEarned
46     );
47 
48     event onReinvestment(
49         address indexed customerAddress,
50         uint256 ethereumReinvested,
51         uint256 tokensMinted
52     );
53 
54     event onWithdraw(
55         address indexed customerAddress,
56         uint256 ethereumWithdrawn
57     );
58 
59     // ERC20
60     event Transfer(
61         address indexed from,
62         address indexed to,
63         uint256 tokens
64     );
65 
66 
67     /*=====================================
68     =            CONFIGURABLES            =
69     =====================================*/
70     string public name = "Boss Wage";
71     string public symbol = "BSW";
72     uint8 constant public decimals = 18;
73     uint8 constant internal dividendFee_ = 10;
74     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
75     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
76     uint256 constant internal magnitude = 2**64;
77     P3D constant public p3d = P3D(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);
78 
79    /*================================
80     =            DATASETS            =
81     ================================*/
82     // amount of shares for each address (scaled number)
83     mapping(address => uint256) internal tokenBalanceLedger_;
84     mapping(address => uint256) internal referralBalance_;
85     mapping(address => int256) internal payoutsTo_;
86     mapping(address => bool) public disabled;
87     uint256 internal tokenSupply_ = 0;
88     uint256 internal profitPerShare_;
89 
90     // administrator list (see above on what they can do)
91     mapping(bytes32 => bool) public administrators;
92     address public vault;
93 
94 
95 
96     /*=======================================
97     =            PUBLIC FUNCTIONS            =
98     =======================================*/
99     /*
100     * -- APPLICATION ENTRY POINTS --
101     */
102     constructor() public {
103       vault = msg.sender;
104       administrators[keccak256(msg.sender)] = true;
105     }
106 
107     /**
108      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
109      */
110     function buy(address _referredBy)
111         public
112         payable
113         returns(uint256)
114     {
115         purchaseTokens(msg.sender, msg.value, _referredBy);
116     }
117 
118     /**
119      * Fallback function to handle ethereum that was send straight to the contract
120      * Unfortunately we cannot use a referral address this way.
121      */
122     function()
123         payable
124         public
125     {
126         if (msg.sender != address(p3d)) {
127           purchaseTokens(msg.sender, msg.value, 0x0);
128         }
129     }
130 
131     /**
132      * Converts all of caller's dividends to tokens.
133      */
134     function reinvest()
135         onlyStronghands()
136         public
137     {
138         // pay out the dividends virtually
139         address _customerAddress = msg.sender;
140 
141         // fetch dividends
142         uint256 _dividends = getDividends(_customerAddress, false); // retrieve ref. bonus later in the code
143 
144         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
145 
146         // retrieve ref. bonus
147         _dividends += referralBalance_[_customerAddress];
148         referralBalance_[_customerAddress] = 0;
149 
150         // dispatch a buy order with the virtualized "withdrawn dividends"
151         uint256 _tokens = purchaseTokens(msg.sender, _dividends, 0x0);
152 
153         // fire event
154         onReinvestment(_customerAddress, _dividends, _tokens);
155     }
156 
157     function reinvestFor(address _for)
158         public
159     {
160         // automatic reinvest is on by default
161         require(disabled[_for] == false);
162 
163         // fetch dividends
164         uint256 _dividends = dividendsOf(_for); // retrieve ref. bonus later in the code
165         uint256 _referrals = referralBalance_[_for];
166 
167         // must have divs to reinvest
168         require((_dividends + _referrals) > 0);
169 
170         // pay out the dividends virtually
171         payoutsTo_[_for] += (int256) (_dividends * magnitude);
172 
173         // retrieve ref. bonus
174         _dividends += _referrals;
175         referralBalance_[_for] = 0;
176 
177         // dispatch a buy order with the virtualized "withdrawn dividends"
178         uint256 _tokens = purchaseTokens(_for, _dividends, msg.sender);
179 
180         // fire event
181         onReinvestment(_for, _dividends, _tokens);
182     }
183 
184     /**
185      * Alias of sell() and withdraw().
186      */
187     function exit()
188         public
189     {
190         // get token count for caller & sell them all
191         address _customerAddress = msg.sender;
192         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
193         if(_tokens > 0) sell(_tokens);
194 
195         // lambo delivery service
196         withdraw();
197     }
198 
199     /**
200      * Withdraws all of the callers earnings.
201      */
202     function withdraw()
203         onlyStronghands()
204         public
205     {
206         // setup data
207         address _customerAddress = msg.sender;
208         uint256 _dividends = getDividends(_customerAddress, false); // get ref. bonus later in the code
209 
210         // update dividend tracker
211         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
212 
213         // add ref. bonus
214         _dividends += referralBalance_[_customerAddress];
215         referralBalance_[_customerAddress] = 0;
216 
217         // lambo delivery service
218         _customerAddress.transfer(_dividends);
219 
220         // fire event
221         onWithdraw(_customerAddress, _dividends);
222     }
223 
224     /**
225      * Liquifies tokens to ethereum.
226      */
227     function sell(uint256 _amountOfTokens)
228         onlyBagholders()
229         public
230     {
231         // setup data
232         address _customerAddress = msg.sender;
233         // russian hackers BTFO
234         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
235         uint256 _tokens = _amountOfTokens;
236         uint256 _ethereum = tokensToEthereum_(_tokens);
237 
238         // tax ethereum
239         uint256 _undividedDividends = SafeMath.div(_ethereum, dividendFee_);
240         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _undividedDividends);
241 
242         // divide dividends
243         uint256 _bonus = SafeMath.div(_undividedDividends, dividendFee_);
244         uint256 _dividends = SafeMath.sub(_undividedDividends, SafeMath.mul(_bonus, 2));
245 
246         // 1% vault, 1% p3d
247         referralBalance_[vault] = SafeMath.add(referralBalance_[vault], _bonus);
248         p3d.buy.value(_bonus)(_customerAddress);
249 
250         // burn the sold tokens
251         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
252         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
253 
254         // update dividends tracker
255         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
256         payoutsTo_[_customerAddress] -= _updatedPayouts;
257 
258         // dividing by zero is a bad idea
259         if (tokenSupply_ > 0) {
260             // update the amount of dividends per token
261             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
262         }
263 
264         // fire event
265         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
266     }
267 
268 
269     /**
270      * Transfer tokens from the caller to a new holder.
271      * Remember, there's a 10% fee here as well.
272      */
273     function transfer(address _toAddress, uint256 _amountOfTokens)
274         onlyBagholders()
275         public
276         returns(bool)
277     {
278         // setup
279         address _customerAddress = msg.sender;
280 
281         // make sure we have the requested tokens
282         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
283 
284         // withdraw all outstanding dividends first
285         if(getDividends(_customerAddress, true) > 0) withdraw();
286 
287         // liquify 10% of the tokens that are transfered
288         // these are dispersed to shareholders
289         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
290         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
291         uint256 _undividedDividends = tokensToEthereum_(_tokenFee);
292 
293         // divide dividends
294         uint256 _bonus = SafeMath.div(_undividedDividends, dividendFee_);
295         uint256 _dividends = SafeMath.sub(_undividedDividends, SafeMath.mul(_bonus, 2));
296 
297         // 1% to vault, 1% to p3d
298         referralBalance_[vault] = SafeMath.add(referralBalance_[vault], _bonus);
299         p3d.buy.value(_bonus)(_customerAddress);
300 
301         // burn the fee tokens
302         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
303 
304         // exchange tokens
305         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
306         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
307 
308         // update dividend trackers
309         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
310         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
311 
312         // disperse dividends among holders
313         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
314 
315         // fire event
316         Transfer(_customerAddress, _toAddress, _taxedTokens);
317 
318         // ERC20
319         return true;
320     }
321 
322     function cannibalize() public {
323       address _customerAddress = address(this);
324 
325       // get divs
326       uint256 _dividends = getDividends(_customerAddress, false);
327       uint256 _referrals = referralBalance_[_customerAddress];
328         
329       if (_dividends > 0) {
330         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
331       }
332       
333       // get p3d divs
334       uint256 p3dDivs = p3d.myDividends(true);
335       if (p3dDivs > 0) {
336         p3d.withdraw();
337         _dividends = SafeMath.add(_dividends, p3dDivs);
338       }
339 
340       // get referrals
341       _dividends += _referrals;
342       referralBalance_[_customerAddress] = 0;
343       
344       require(_dividends > 0);
345 
346       // buy tokens
347       uint256 _tokens = purchaseTokens(_customerAddress, _dividends, msg.sender);
348 
349       onReinvestment(_customerAddress, _dividends, _tokens);
350     }
351 
352     function toggle(bool _auto) public {
353       disabled[msg.sender] = _auto;
354     }
355 
356     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
357 
358     /**
359      * In case one of us dies, we need to replace ourselves.
360      */
361     function setAdministrator(bytes32 _identifier, bool _status)
362         onlyAdministrator()
363         public
364     {
365         administrators[_identifier] = _status;
366     }
367 
368     /**
369      * If we want to rebrand, we can.
370      */
371     function setName(string _name)
372         onlyAdministrator()
373         public
374     {
375         name = _name;
376     }
377 
378     /**
379      * If we want to rebrand, we can.
380      */
381     function setSymbol(string _symbol)
382         onlyAdministrator()
383         public
384     {
385         symbol = _symbol;
386     }
387 
388     function setVault(address _vault)
389         onlyAdministrator()
390         public
391     {
392         vault = _vault;
393     }
394 
395 
396     /*----------  HELPERS AND CALCULATORS  ----------*/
397     /**
398      * Method to view the current Ethereum stored in the contract
399      * Example: totalEthereumBalance()
400      */
401     function totalEthereumBalance()
402         public
403         view
404         returns(uint)
405     {
406         return this.balance;
407     }
408 
409     /**
410      * Retrieve the total token supply.
411      */
412     function totalSupply()
413         public
414         view
415         returns(uint256)
416     {
417         return tokenSupply_;
418     }
419 
420     /**
421      * Retrieve the tokens owned by the caller.
422      */
423     function myTokens()
424         public
425         view
426         returns(uint256)
427     {
428         address _customerAddress = msg.sender;
429         return balanceOf(_customerAddress);
430     }
431 
432     /**
433      * Retrieve the dividends owned by the caller.
434      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
435      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
436      * But in the internal calculations, we want them separate.
437      */
438     function getDividends(address _customerAddress, bool _includeReferralBonus)
439         public
440         view
441         returns(uint256)
442     {
443         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
444     }
445 
446     function contractDivs()
447         public
448         view
449         returns(uint256)
450     {
451         return SafeMath.add(getDividends(address(this), true), p3d.myDividends(true));
452     }
453 
454     /**
455      * Retrieve the token balance of any single address.
456      */
457     function balanceOf(address _customerAddress)
458         view
459         public
460         returns(uint256)
461     {
462         return tokenBalanceLedger_[_customerAddress];
463     }
464 
465     /**
466      * Retrieve the dividend balance of any single address.
467      */
468     function dividendsOf(address _customerAddress)
469         view
470         public
471         returns(uint256)
472     {
473         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
474     }
475 
476     /**
477      * Return the buy price of 1 individual token.
478      */
479     function sellPrice()
480         public
481         view
482         returns(uint256)
483     {
484         // our calculation relies on the token supply, so we need supply. Doh.
485         if(tokenSupply_ == 0){
486             return tokenPriceInitial_ - tokenPriceIncremental_;
487         } else {
488             uint256 _ethereum = tokensToEthereum_(1e18);
489             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
490             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
491             return _taxedEthereum;
492         }
493     }
494 
495     /**
496      * Return the sell price of 1 individual token.
497      */
498     function buyPrice()
499         public
500         view
501         returns(uint256)
502     {
503         // our calculation relies on the token supply, so we need supply. Doh.
504         if(tokenSupply_ == 0){
505             return tokenPriceInitial_ + tokenPriceIncremental_;
506         } else {
507             uint256 _ethereum = tokensToEthereum_(1e18);
508             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
509             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
510             return _taxedEthereum;
511         }
512     }
513 
514     /**
515      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
516      */
517     function calculateTokensReceived(uint256 _ethereumToSpend)
518         public
519         view
520         returns(uint256)
521     {
522         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
523         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
524         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
525 
526         return _amountOfTokens;
527     }
528 
529     /**
530      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
531      */
532     function calculateEthereumReceived(uint256 _tokensToSell)
533         public
534         view
535         returns(uint256)
536     {
537         require(_tokensToSell <= tokenSupply_);
538         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
539         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
540         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
541         return _taxedEthereum;
542     }
543 
544 
545     /*==========================================
546     =            INTERNAL FUNCTIONS            =
547     ==========================================*/
548     function purchaseTokens(address _customerAddress, uint256 _incomingEthereum, address _referredBy)
549         internal
550         returns(uint256)
551     {
552         // data setup
553         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
554         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
555 
556         uint256 [] memory bonus = new uint256[](2);
557         bonus[0] = SafeMath.div(_undividedDividends, 3);
558         bonus[1] = SafeMath.div(_undividedDividends, dividendFee_);
559         uint256 _dividends = SafeMath.sub(SafeMath.sub(_undividedDividends, bonus[0]), SafeMath.mul(bonus[1], 2));
560         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
561         uint256 _fee = _dividends * magnitude;
562 
563         // 1% to vault, 1% to p3d
564         referralBalance_[vault] = SafeMath.add(referralBalance_[vault], bonus[1]);
565         p3d.buy.value(bonus[1])(_customerAddress);
566 
567         // no point in continuing execution if OP is a poorfag russian hacker
568         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
569         // (or hackers)
570         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
571         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
572 
573         // is the user referred by a masternode?
574         if(
575             // is this a referred purchase?
576             _referredBy != 0x0000000000000000000000000000000000000000 &&
577 
578             // no cheating!
579             _referredBy != _customerAddress
580         ){
581             // wealth redistribution
582             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], bonus[0]);
583         } else {
584             // no ref purchase
585             // add the referral bonus back to the global dividends cake
586             _dividends = SafeMath.add(_dividends, bonus[0]);
587             _fee = _dividends * magnitude;
588         }
589 
590         // we can't give people infinite ethereum
591         if(tokenSupply_ > 0){
592 
593             // add tokens to the pool
594             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
595 
596             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
597             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
598 
599             // calculate the amount of tokens the customer receives over his purchase
600             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
601 
602         } else {
603             // add tokens to the pool
604             tokenSupply_ = _amountOfTokens;
605         }
606 
607         // update circulating supply & the ledger address for the customer
608         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
609 
610         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
611         //really i know you think you do but you don't
612         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
613         payoutsTo_[_customerAddress] += _updatedPayouts;
614 
615         // fire event
616         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
617 
618         return _amountOfTokens;
619     }
620 
621     function check() external {}
622 
623     /**
624      * Calculate Token price based on an amount of incoming ethereum
625      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
626      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
627      */
628     function ethereumToTokens_(uint256 _ethereum)
629         internal
630         view
631         returns(uint256)
632     {
633         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
634         uint256 _tokensReceived =
635          (
636             (
637                 // underflow attempts BTFO
638                 SafeMath.sub(
639                     (sqrt
640                         (
641                             (_tokenPriceInitial**2)
642                             +
643                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
644                             +
645                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
646                             +
647                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
648                         )
649                     ), _tokenPriceInitial
650                 )
651             )/(tokenPriceIncremental_)
652         )-(tokenSupply_)
653         ;
654 
655         return _tokensReceived;
656     }
657 
658     /**
659      * Calculate token sell value.
660      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
661      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
662      */
663      function tokensToEthereum_(uint256 _tokens)
664         internal
665         view
666         returns(uint256)
667     {
668 
669         uint256 tokens_ = (_tokens + 1e18);
670         uint256 _tokenSupply = (tokenSupply_ + 1e18);
671         uint256 _etherReceived =
672         (
673             // underflow attempts BTFO
674             SafeMath.sub(
675                 (
676                     (
677                         (
678                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
679                         )-tokenPriceIncremental_
680                     )*(tokens_ - 1e18)
681                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
682             )
683         /1e18);
684         return _etherReceived;
685     }
686 
687 
688     //This is where all your gas goes, sorry
689     //Not sorry, you probably only paid 1 gwei
690     function sqrt(uint x) internal pure returns (uint y) {
691         uint z = (x + 1) / 2;
692         y = x;
693         while (z < y) {
694             y = z;
695             z = (x / z + z) / 2;
696         }
697     }
698 }
699 
700 /**
701  * @title SafeMath
702  * @dev Math operations with safety checks that throw on error
703  */
704 library SafeMath {
705 
706     /**
707     * @dev Multiplies two numbers, throws on overflow.
708     */
709     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
710         if (a == 0) {
711             return 0;
712         }
713         uint256 c = a * b;
714         assert(c / a == b);
715         return c;
716     }
717 
718     /**
719     * @dev Integer division of two numbers, truncating the quotient.
720     */
721     function div(uint256 a, uint256 b) internal pure returns (uint256) {
722         // assert(b > 0); // Solidity automatically throws when dividing by 0
723         uint256 c = a / b;
724         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
725         return c;
726     }
727 
728     /**
729     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
730     */
731     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
732         assert(b <= a);
733         return a - b;
734     }
735 
736     /**
737     * @dev Adds two numbers, throws on overflow.
738     */
739     function add(uint256 a, uint256 b) internal pure returns (uint256) {
740         uint256 c = a + b;
741         assert(c >= a);
742         return c;
743     }
744 }
745 
746 contract P3D {
747   uint256 public stakingRequirement;
748   function buy(address _referredBy) public payable returns(uint256) {}
749   function balanceOf(address _customerAddress) view public returns(uint256) {}
750   function exit() public {}
751   function calculateTokensReceived(uint256 _ethereumToSpend) public view returns(uint256) {}
752   function calculateEthereumReceived(uint256 _tokensToSell) public view returns(uint256) { }
753   function myDividends(bool _includeReferralBonus) public view returns(uint256) {}
754   function withdraw() public {}
755 }