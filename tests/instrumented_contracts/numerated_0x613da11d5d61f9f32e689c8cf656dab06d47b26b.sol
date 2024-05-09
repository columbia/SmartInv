1 pragma solidity ^0.4.20;
2 
3 /*
4 
5 So much wow! get moniez
6 */
7 
8 
9 contract DOGE {
10     /*=================================
11     =            MODIFIERS            =
12     =================================*/
13     // only people with tokens
14     modifier onlyBagholders() {
15         require(myTokens() > 0);
16         _;
17     }
18     
19     // only people with profits
20     modifier onlyStronghands() {
21         require(myDividends(true) > 0);
22         _;
23     }
24     
25     // administrators can:
26     // -> change the name of the contract
27     // -> change the name of the token
28     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
29     // they CANNOT:
30     // -> take funds
31     // -> disable withdrawals
32     // -> kill the contract
33     // -> change the price of tokens
34     modifier onlyAdministrator(){
35         address _customerAddress = msg.sender;
36         require(administrators[_customerAddress]);
37         _;
38     }
39     
40     modifier OnlyOpen(){
41         require(IsOpen || administrators[msg.sender]);
42         _;
43     }
44 
45     
46     
47     /*==============================
48     =            EVENTS            =
49     ==============================*/
50     event onTokenPurchase(
51         address indexed customerAddress,
52         uint256 incomingEthereum,
53         uint256 tokensMinted,
54         address indexed referredBy
55     );
56     
57     event onTokenSell(
58         address indexed customerAddress,
59         uint256 tokensBurned,
60         uint256 ethereumEarned
61     );
62     
63     event onReinvestment(
64         address indexed customerAddress,
65         uint256 ethereumReinvested,
66         uint256 tokensMinted
67     );
68     
69     event onWithdraw(
70         address indexed customerAddress,
71         uint256 ethereumWithdrawn
72     );
73     
74     // ERC20
75     event Transfer(
76         address indexed from,
77         address indexed to,
78         uint256 tokens
79     );
80     
81     
82     /*=====================================
83     =            CONFIGURABLES            =
84     =====================================*/
85     string public name = "SCE";
86     string public symbol = "SCE";
87     uint8 constant public decimals = 18;
88     uint8 constant internal dividendFee_ = 3; 
89     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
90     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
91     uint256 constant internal magnitude = 2**64;
92     
93     // proof of stake (defaults at 100 tokens)
94     uint256 public stakingRequirement = 100e18;
95     
96     // ambassador program
97     mapping(address => bool) internal ambassadors_;
98     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
99     uint256 constant internal ambassadorQuota_ = 20 ether;
100     
101     
102     
103    /*================================
104     =            DATASETS            =
105     ================================*/
106     // amount of shares for each address (scaled number)
107     mapping(address => uint256) internal tokenBalanceLedger_;
108     mapping(address => uint256) internal referralBalance_;
109     mapping(address => int256) internal payoutsTo_;
110     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
111     uint256 internal tokenSupply_ = 0;
112     uint256 internal profitPerShare_;
113     
114     // administrator list (see above on what they can do)
115     mapping(address => bool) public administrators;
116 
117     bool IsOpen = false;
118     
119     
120     
121 
122 
123     /*=======================================
124     =            PUBLIC FUNCTIONS            =
125     =======================================*/
126     /*
127     * -- APPLICATION ENTRY POINTS --  
128     */
129     function DOGE()
130         public
131     {
132         // add administrators here
133 
134         administrators[0x0AD1B252917b6Ecc7bDD7B35CcdE3C774B4C1B68] = true;
135         //administrators[msg.sender]=true;
136     }
137     
138      
139     /**
140      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
141      */
142     function buy(address _referredBy)
143         public
144         payable
145         OnlyOpen()
146         returns(uint256)
147     {
148         purchaseTokens(msg.value, _referredBy);
149     }
150     
151     /**
152      * Fallback function to handle ethereum that was send straight to the contract
153      * Unfortunately we cannot use a referral address this way.
154      */
155     function()
156         payable
157         public
158         OnlyOpen()
159     {
160         purchaseTokens(msg.value, 0x0);
161     }
162     
163     /**
164      * Converts all of caller's dividends to tokens.
165     */
166     function reinvest()
167         onlyStronghands()
168         public
169     {
170         // fetch dividends
171         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
172         
173         // pay out the dividends virtually
174         address _customerAddress = msg.sender;
175         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
176         
177         // retrieve ref. bonus
178         _dividends += referralBalance_[_customerAddress];
179         referralBalance_[_customerAddress] = 0;
180         
181         // dispatch a buy order with the virtualized "withdrawn dividends"
182         uint256 _tokens = purchaseTokens(_dividends, 0x0);
183         
184         // fire event
185         onReinvestment(_customerAddress, _dividends, _tokens);
186     }
187     
188     /**
189      * Alias of sell() and withdraw().
190      */
191     function exit()
192         public
193     {
194         // get token count for caller & sell them all
195         address _customerAddress = msg.sender;
196         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
197         if(_tokens > 0) sell(_tokens);
198         
199         // lambo delivery service
200         withdraw();
201     }
202 
203     /**
204      * Withdraws all of the callers earnings.
205      */
206     function withdraw()
207         onlyStronghands()
208         public
209     {
210         // setup data
211         address _customerAddress = msg.sender;
212         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
213         
214         // update dividend tracker
215         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
216         
217         // add ref. bonus
218         _dividends += referralBalance_[_customerAddress];
219         referralBalance_[_customerAddress] = 0;
220         
221         // lambo delivery service
222         _customerAddress.transfer(_dividends);
223         
224         // fire event
225         onWithdraw(_customerAddress, _dividends);
226     }
227     
228     /**
229      * Liquifies tokens to ethereum.
230      */
231     function sell(uint256 _amountOfTokens)
232         onlyBagholders()
233         public
234     {
235         // setup data
236         address _customerAddress = msg.sender;
237         // russian hackers BTFO
238         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
239         uint256 _tokens = _amountOfTokens;
240         uint256 _ethereum = tokensToEthereum_(_tokens);
241         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
242         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
243         
244         // burn the sold tokens
245         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
246         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
247         
248         // update dividends tracker
249         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
250         payoutsTo_[_customerAddress] -= _updatedPayouts;       
251         
252         // dividing by zero is a bad idea
253         if (tokenSupply_ > 0) {
254             // update the amount of dividends per token
255             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
256         }
257         
258         // fire event
259         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
260     }
261     
262     
263     /**
264      * Transfer tokens from the caller to a new holder.
265      * Remember, there's a 10% fee here as well.
266      */
267     function transfer(address _toAddress, uint256 _amountOfTokens)
268         onlyBagholders()
269         public
270         returns(bool)
271     {
272         // setup
273         address _customerAddress = msg.sender;
274         
275         // make sure we have the requested tokens
276         // also disables transfers until ambassador phase is over
277         // ( we dont want whale premines )
278         require( _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
279         
280         // withdraw all outstanding dividends first
281         if(myDividends(true) > 0) withdraw();
282         
283         // liquify 10% of the tokens that are transfered
284         // these are dispersed to shareholders
285         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
286         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
287         uint256 _dividends = tokensToEthereum_(_tokenFee);
288   
289         // burn the fee tokens
290         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
291 
292         // exchange tokens
293         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
294         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
295         
296         // update dividend trackers
297         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
298         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
299         
300         // disperse dividends among holders
301         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
302         
303         // fire event
304         Transfer(_customerAddress, _toAddress, _taxedTokens);
305         
306         // ERC20
307         return true;
308        
309     }
310     
311     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
312 
313     /**
314      * In case one of us dies, we need to replace ourselves.
315      */
316 
317     // no you memers OnlyOpen also checks if admin calls it
318     function OpenContract() public OnlyOpen() {
319         IsOpen=true;
320     }
321     
322     /**
323      * Precautionary measures in case we need to adjust the masternode rate.
324      */
325     function setStakingRequirement(uint256 _amountOfTokens)
326         onlyAdministrator()
327         public
328     {
329         stakingRequirement = _amountOfTokens;
330     }
331     
332     /**
333      * If we want to rebrand, we can.
334      */
335     function setName(string _name)
336         onlyAdministrator()
337         public
338     {
339         name = _name;
340     }
341     
342     /**
343      * If we want to rebrand, we can.
344      */
345     function setSymbol(string _symbol)
346         onlyAdministrator()
347         public
348     {
349         symbol = _symbol;
350     }
351 
352     
353     /*----------  HELPERS AND CALCULATORS  ----------*/
354     /**
355      * Method to view the current Ethereum stored in the contract
356      * Example: totalEthereumBalance()
357      */
358     function totalEthereumBalance()
359         public
360         view
361         returns(uint)
362     {
363         return this.balance;
364     }
365     
366     /**
367      * Retrieve the total token supply.
368      */
369     function totalSupply()
370         public
371         view
372         returns(uint256)
373     {
374         return tokenSupply_;
375     }
376     
377     /**
378      * Retrieve the tokens owned by the caller.
379      */
380     function myTokens()
381         public
382         view
383         returns(uint256)
384     {
385         address _customerAddress = msg.sender;
386         return balanceOf(_customerAddress);
387     }
388     
389     /**
390      * Retrieve the dividends owned by the caller.
391      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
392      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
393      * But in the internal calculations, we want them separate. 
394      */ 
395     function myDividends(bool _includeReferralBonus) 
396         public 
397         view 
398         returns(uint256)
399     {
400         address _customerAddress = msg.sender;
401         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
402     }
403     
404     /**
405      * Retrieve the token balance of any single address.
406      */
407     function balanceOf(address _customerAddress)
408         view
409         public
410         returns(uint256)
411     {
412         return tokenBalanceLedger_[_customerAddress];
413     }
414     
415     /**
416      * Retrieve the dividend balance of any single address.
417      */
418     function dividendsOf(address _customerAddress)
419         view
420         public
421         returns(uint256)
422     {
423         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
424     }
425     
426     /**
427      * Return the buy price of 1 individual token.
428      */
429     function sellPrice() 
430         public 
431         view 
432         returns(uint256)
433     {
434         // our calculation relies on the token supply, so we need supply. Doh.
435         if(tokenSupply_ == 0){
436             return tokenPriceInitial_ - tokenPriceIncremental_;
437         } else {
438             uint256 _ethereum = tokensToEthereum_(1e18);
439             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
440             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
441             return _taxedEthereum;
442         }
443     }
444     
445     /**
446      * Return the sell price of 1 individual token.
447      */
448     function buyPrice() 
449         public 
450         view 
451         returns(uint256)
452     {
453         // our calculation relies on the token supply, so we need supply. Doh.
454         if(tokenSupply_ == 0){
455             return tokenPriceInitial_ + tokenPriceIncremental_;
456         } else {
457             uint256 _ethereum = tokensToEthereum_(1e18);
458             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
459             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
460             return _taxedEthereum;
461         }
462     }
463     
464     /**
465      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
466      */
467     function calculateTokensReceived(uint256 _ethereumToSpend) 
468         public 
469         view 
470         returns(uint256)
471     {
472         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
473         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
474         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
475         
476         return _amountOfTokens;
477     }
478     
479     /**
480      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
481      */
482     function calculateEthereumReceived(uint256 _tokensToSell) 
483         public 
484         view 
485         returns(uint256)
486     {
487         require(_tokensToSell <= tokenSupply_);
488         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
489         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
490         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
491         return _taxedEthereum;
492     }
493     
494     
495     /*==========================================
496     =            INTERNAL FUNCTIONS            =
497     ==========================================*/
498     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
499         internal
500         OnlyOpen()
501         returns(uint256)
502     {
503         // data setup
504         address _customerAddress = msg.sender;
505         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
506         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
507         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
508         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
509         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
510         uint256 _fee = _dividends * magnitude;
511  
512         // no point in continuing execution if OP is a poorfag russian hacker
513         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
514         // (or hackers)
515         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
516         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
517         
518         // is the user referred by a masternode?
519         if(
520             // is this a referred purchase?
521             _referredBy != 0x0000000000000000000000000000000000000000 &&
522 
523             // no cheating!
524             _referredBy != _customerAddress &&
525             
526             // does the referrer have at least X whole tokens?
527             // i.e is the referrer a godly chad masternode
528             tokenBalanceLedger_[_referredBy] >= stakingRequirement
529         ){
530             // wealth redistribution
531             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
532         } else {
533             // no ref purchase
534             // add the referral bonus back to the global dividends cake
535             _dividends = SafeMath.add(_dividends, _referralBonus);
536             _fee = _dividends * magnitude;
537         }
538         
539         // we can't give people infinite ethereum
540         if(tokenSupply_ > 0){
541             
542             // add tokens to the pool
543             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
544  
545             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
546             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
547             
548             // calculate the amount of tokens the customer receives over his purchase 
549             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
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
560         //really i know you think you do but you don't
561         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
562         payoutsTo_[_customerAddress] += _updatedPayouts;
563         
564         // fire event
565         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
566         
567         return _amountOfTokens;
568     }
569 
570     /**
571      * Calculate Token price based on an amount of incoming ethereum
572      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
573      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
574      */
575     function ethereumToTokens_(uint256 _ethereum)
576         internal
577         view
578         returns(uint256)
579     {
580         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
581         uint256 _tokensReceived = 
582          (
583             (
584                 // underflow attempts BTFO
585                 SafeMath.sub(
586                     (sqrt
587                         (
588                             (_tokenPriceInitial**2)
589                             +
590                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
591                             +
592                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
593                             +
594                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
595                         )
596                     ), _tokenPriceInitial
597                 )
598             )/(tokenPriceIncremental_)
599         )-(tokenSupply_)
600         ;
601   
602         return _tokensReceived;
603     }
604     
605     /**
606      * Calculate token sell value.
607      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
608      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
609      */
610      function tokensToEthereum_(uint256 _tokens)
611         internal
612         view
613         returns(uint256)
614     {
615 
616         uint256 tokens_ = (_tokens + 1e18);
617         uint256 _tokenSupply = (tokenSupply_ + 1e18);
618         uint256 _etherReceived =
619         (
620             // underflow attempts BTFO
621             SafeMath.sub(
622                 (
623                     (
624                         (
625                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
626                         )-tokenPriceIncremental_
627                     )*(tokens_ - 1e18)
628                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
629             )
630         /1e18);
631         return _etherReceived;
632     }
633     
634     
635     //This is where all your gas goes, sorry
636     //Not sorry, you probably only paid 1 gwei
637     function sqrt(uint x) internal pure returns (uint y) {
638         uint z = (x + 1) / 2;
639         y = x;
640         while (z < y) {
641             y = z;
642             z = (x / z + z) / 2;
643         }
644     }
645 }
646 
647 /**
648  * @title SafeMath
649  * @dev Math operations with safety checks that throw on error
650  */
651 library SafeMath {
652 
653     /**
654     * @dev Multiplies two numbers, throws on overflow.
655     */
656     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
657         if (a == 0) {
658             return 0;
659         }
660         uint256 c = a * b;
661         assert(c / a == b);
662         return c;
663     }
664 
665     /**
666     * @dev Integer division of two numbers, truncating the quotient.
667     */
668     function div(uint256 a, uint256 b) internal pure returns (uint256) {
669         // assert(b > 0); // Solidity automatically throws when dividing by 0
670         uint256 c = a / b;
671         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
672         return c;
673     }
674 
675     /**
676     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
677     */
678     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
679         assert(b <= a);
680         return a - b;
681     }
682 
683     /**
684     * @dev Adds two numbers, throws on overflow.
685     */
686     function add(uint256 a, uint256 b) internal pure returns (uint256) {
687         uint256 c = a + b;
688         assert(c >= a);
689         return c;
690     }
691 }