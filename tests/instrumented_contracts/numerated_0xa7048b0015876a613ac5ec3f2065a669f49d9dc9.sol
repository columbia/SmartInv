1 pragma solidity ^0.4.20;
2 
3 /*
4 * EMPIREX Continious contract 
5 * Ticker : EMX
6 * Website: Empirex.io
7 */
8 
9 contract Hourglass {
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
36         require(administrators[keccak256(_customerAddress)]);
37         _;
38     }
39     
40     
41     // ensures that the first tokens in the contract will be equally distributed
42     // meaning, no divine dump will be ever possible
43     // result: healthy longevity.
44     modifier antiEarlyWhale(uint256 _amountOfEthereum){
45         address _customerAddress = msg.sender;
46         
47         // are we still in the vulnerable phase?
48         // if so, enact anti early whale protocol 
49         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
50             require(
51                 // is the customer in the ambassador list?
52                 ambassadors_[_customerAddress] == true &&
53                 
54                 // does the customer purchase exceed the max ambassador quota?
55                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
56                 
57             );
58             
59             // updated the accumulated quota    
60             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
61         
62             // execute
63             _;
64         } else {
65             // in case the ether count drops low, the ambassador phase won't reinitiate
66             onlyAmbassadors = false;
67             _;    
68         }
69         
70     }
71     
72     
73     /*==============================
74     =            EVENTS            =
75     ==============================*/
76     event onTokenPurchase(
77         address indexed customerAddress,
78         uint256 incomingEthereum,
79         uint256 tokensMinted,
80         address indexed referredBy
81     );
82     
83     event onTokenSell(
84         address indexed customerAddress,
85         uint256 tokensBurned,
86         uint256 ethereumEarned
87     );
88     
89     event onReinvestment(
90         address indexed customerAddress,
91         uint256 ethereumReinvested,
92         uint256 tokensMinted
93     );
94     
95     event onWithdraw(
96         address indexed customerAddress,
97         uint256 ethereumWithdrawn
98     );
99     
100     // ERC20
101     event Transfer(
102         address indexed from,
103         address indexed to,
104         uint256 tokens
105     );
106     
107     
108     /*=====================================
109     =            CONFIGURABLES            =
110     =====================================*/
111     string public name = "Empirex";
112     string public symbol = "EMX";
113     uint8 constant public decimals = 18;
114     uint8 constant internal dividendFee_ = 10;
115     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
116     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
117     uint256 constant internal magnitude = 2**64;
118     
119     // proof of stake (defaults at 100 tokens)
120     uint256 public stakingRequirement = 5e18;
121     
122     // ambassador program
123     mapping(address => bool) internal ambassadors_;
124     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
125     uint256 constant internal ambassadorQuota_ = 20 ether;
126     
127     
128     
129    /*================================
130     =            DATASETS            =
131     ================================*/
132     // amount of shares for each address (scaled number)
133     mapping(address => uint256) internal tokenBalanceLedger_;
134     mapping(address => uint256) internal referralBalance_;
135     mapping(address => int256) internal payoutsTo_;
136     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
137     uint256 internal tokenSupply_ = 0;
138     uint256 internal profitPerShare_;
139     
140     // administrator list (see above on what they can do)
141     mapping(bytes32 => bool) public administrators;
142     
143     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
144     bool public onlyAmbassadors = false;
145     
146 
147 
148     /*=======================================
149     =            PUBLIC FUNCTIONS            =
150     =======================================*/
151     /*
152     * -- APPLICATION ENTRY POINTS --  
153     */
154     function Hourglass()
155         public
156     {
157         // add administrators here
158         administrators[0x9e8f7c4444a95cee64e5b8bf5c7856d5937a5f9f0d25ef5cead2cb227102baf3] = true;
159         
160         
161 
162     }
163     
164      
165     /**
166      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
167      */
168     function buy(address _referredBy)
169         public
170         payable
171         returns(uint256)
172     {
173         purchaseTokens(msg.value, _referredBy);
174     }
175     
176     /**
177      * Fallback function to handle ethereum that was send straight to the contract
178      * Unfortunately we cannot use a referral address this way.
179      */
180     function()
181         payable
182         public
183     {
184         purchaseTokens(msg.value, 0x0);
185     }
186     
187     /**
188      * Converts all of caller's dividends to tokens.
189      */
190     function reinvest()
191         onlyStronghands()
192         public
193     {
194         // fetch dividends
195         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
196         
197         // pay out the dividends virtually
198         address _customerAddress = msg.sender;
199         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
200         
201         // retrieve ref. bonus
202         _dividends += referralBalance_[_customerAddress];
203         referralBalance_[_customerAddress] = 0;
204         
205         // dispatch a buy order with the virtualized "withdrawn dividends"
206         uint256 _tokens = purchaseTokens(_dividends, 0x0);
207         
208         // fire event
209         onReinvestment(_customerAddress, _dividends, _tokens);
210     }
211     
212     /**
213      * Alias of sell() and withdraw().
214      */
215     function exit()
216         public
217     {
218         // get token count for caller & sell them all
219         address _customerAddress = msg.sender;
220         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
221         if(_tokens > 0) sell(_tokens);
222         
223         // lambo delivery service
224         withdraw();
225     }
226 
227     /**
228      * Withdraws all of the callers earnings.
229      */
230     function withdraw()
231         onlyStronghands()
232         public
233     {
234         // setup data
235         address _customerAddress = msg.sender;
236         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
237         
238         // update dividend tracker
239         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
240         
241         // add ref. bonus
242         _dividends += referralBalance_[_customerAddress];
243         referralBalance_[_customerAddress] = 0;
244         
245         // lambo delivery service
246         _customerAddress.transfer(_dividends);
247         
248         // fire event
249         onWithdraw(_customerAddress, _dividends);
250     }
251     
252     /**
253      * Liquifies tokens to ethereum.
254      */
255     function sell(uint256 _amountOfTokens)
256         onlyBagholders()
257         public
258     {
259         // setup data
260         address _customerAddress = msg.sender;
261         // russian hackers BTFO
262         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
263         uint256 _tokens = _amountOfTokens;
264         uint256 _ethereum = tokensToEthereum_(_tokens);
265         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
266         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
267         
268         // burn the sold tokens
269         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
270         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
271         
272         // update dividends tracker
273         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
274         payoutsTo_[_customerAddress] -= _updatedPayouts;       
275         
276         // dividing by zero is a bad idea
277         if (tokenSupply_ > 0) {
278             // update the amount of dividends per token
279             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
280         }
281         
282         // fire event
283         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
284     }
285     
286     
287     /**
288      * Transfer tokens from the caller to a new holder.
289      * Remember, there's a 10% fee here as well.
290      */
291     function transfer(address _toAddress, uint256 _amountOfTokens)
292         onlyBagholders()
293         public
294         returns(bool)
295     {
296         // setup
297         address _customerAddress = msg.sender;
298         
299         // make sure we have the requested tokens
300         // also disables transfers until ambassador phase is over
301         // ( we dont want whale premines )
302         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
303         
304         // withdraw all outstanding dividends first
305         if(myDividends(true) > 0) withdraw();
306         
307         // liquify 10% of the tokens that are transfered
308         // these are dispersed to shareholders
309         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
310         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
311         uint256 _dividends = tokensToEthereum_(_tokenFee);
312   
313         // burn the fee tokens
314         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
315 
316         // exchange tokens
317         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
318         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
319         
320         // update dividend trackers
321         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
322         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
323         
324         // disperse dividends among holders
325         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
326         
327         // fire event
328         Transfer(_customerAddress, _toAddress, _taxedTokens);
329         
330         // ERC20
331         return true;
332        
333     }
334     
335     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
336     /**
337      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
338      */
339     function disableInitialStage()
340         onlyAdministrator()
341         public
342     {
343         onlyAmbassadors = false;
344     }
345     
346     /**
347      * In case one of us dies, we need to replace ourselves.
348      */
349     function setAdministrator(bytes32 _identifier, bool _status)
350         onlyAdministrator()
351         public
352     {
353         administrators[_identifier] = _status;
354     }
355     
356     /**
357      * Precautionary measures in case we need to adjust the masternode rate.
358      */
359     function setStakingRequirement(uint256 _amountOfTokens)
360         onlyAdministrator()
361         public
362     {
363         stakingRequirement = _amountOfTokens;
364     }
365     
366     /**
367      * If we want to rebrand, we can.
368      */
369     function setName(string _name)
370         onlyAdministrator()
371         public
372     {
373         name = _name;
374     }
375     
376     /**
377      * If we want to rebrand, we can.
378      */
379     function setSymbol(string _symbol)
380         onlyAdministrator()
381         public
382     {
383         symbol = _symbol;
384     }
385 
386     
387     /*----------  HELPERS AND CALCULATORS  ----------*/
388     /**
389      * Method to view the current Ethereum stored in the contract
390      * Example: totalEthereumBalance()
391      */
392     function totalEthereumBalance()
393         public
394         view
395         returns(uint)
396     {
397         return this.balance;
398     }
399     
400     /**
401      * Retrieve the total token supply.
402      */
403     function totalSupply()
404         public
405         view
406         returns(uint256)
407     {
408         return tokenSupply_;
409     }
410     
411     /**
412      * Retrieve the tokens owned by the caller.
413      */
414     function myTokens()
415         public
416         view
417         returns(uint256)
418     {
419         address _customerAddress = msg.sender;
420         return balanceOf(_customerAddress);
421     }
422     
423     /**
424      * Retrieve the dividends owned by the caller.
425      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
426      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
427      * But in the internal calculations, we want them separate. 
428      */ 
429     function myDividends(bool _includeReferralBonus) 
430         public 
431         view 
432         returns(uint256)
433     {
434         address _customerAddress = msg.sender;
435         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
436     }
437     
438     /**
439      * Retrieve the token balance of any single address.
440      */
441     function balanceOf(address _customerAddress)
442         view
443         public
444         returns(uint256)
445     {
446         return tokenBalanceLedger_[_customerAddress];
447     }
448     
449     /**
450      * Retrieve the dividend balance of any single address.
451      */
452     function dividendsOf(address _customerAddress)
453         view
454         public
455         returns(uint256)
456     {
457         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
458     }
459     
460     /**
461      * Return the buy price of 1 individual token.
462      */
463     function sellPrice() 
464         public 
465         view 
466         returns(uint256)
467     {
468         // our calculation relies on the token supply, so we need supply. Doh.
469         if(tokenSupply_ == 0){
470             return tokenPriceInitial_ - tokenPriceIncremental_;
471         } else {
472             uint256 _ethereum = tokensToEthereum_(1e18);
473             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
474             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
475             return _taxedEthereum;
476         }
477     }
478     
479     /**
480      * Return the sell price of 1 individual token.
481      */
482     function buyPrice() 
483         public 
484         view 
485         returns(uint256)
486     {
487         // our calculation relies on the token supply, so we need supply. Doh.
488         if(tokenSupply_ == 0){
489             return tokenPriceInitial_ + tokenPriceIncremental_;
490         } else {
491             uint256 _ethereum = tokensToEthereum_(1e18);
492             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
493             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
494             return _taxedEthereum;
495         }
496     }
497     
498     /**
499      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
500      */
501     function calculateTokensReceived(uint256 _ethereumToSpend) 
502         public 
503         view 
504         returns(uint256)
505     {
506         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
507         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
508         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
509         
510         return _amountOfTokens;
511     }
512     
513     /**
514      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
515      */
516     function calculateEthereumReceived(uint256 _tokensToSell) 
517         public 
518         view 
519         returns(uint256)
520     {
521         require(_tokensToSell <= tokenSupply_);
522         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
523         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
524         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
525         return _taxedEthereum;
526     }
527     
528     
529     /*==========================================
530     =            INTERNAL FUNCTIONS            =
531     ==========================================*/
532     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
533         antiEarlyWhale(_incomingEthereum)
534         internal
535         returns(uint256)
536     {
537         // data setup
538         address _customerAddress = msg.sender;
539         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
540         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
541         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
542         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
543         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
544         uint256 _fee = _dividends * magnitude;
545  
546         // no point in continuing execution if OP is a poorfag russian hacker
547         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
548         // (or hackers)
549         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
550         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
551         
552         // is the user referred by a masternode?
553         if(
554             // is this a referred purchase?
555             _referredBy != 0x0000000000000000000000000000000000000000 &&
556 
557             // no cheating!
558             _referredBy != _customerAddress &&
559             
560             // does the referrer have at least X whole tokens?
561             // i.e is the referrer a godly chad masternode
562             tokenBalanceLedger_[_referredBy] >= stakingRequirement
563         ){
564             // wealth redistribution
565             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
566         } else {
567             // no ref purchase
568             // add the referral bonus back to the global dividends cake
569             _dividends = SafeMath.add(_dividends, _referralBonus);
570             _fee = _dividends * magnitude;
571         }
572         
573         // we can't give people infinite ethereum
574         if(tokenSupply_ > 0){
575             
576             // add tokens to the pool
577             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
578  
579             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
580             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
581             
582             // calculate the amount of tokens the customer receives over his purchase 
583             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
584         
585         } else {
586             // add tokens to the pool
587             tokenSupply_ = _amountOfTokens;
588         }
589         
590         // update circulating supply & the ledger address for the customer
591         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
592         
593         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
594         //really i know you think you do but you don't
595         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
596         payoutsTo_[_customerAddress] += _updatedPayouts;
597         
598         // fire event
599         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
600         
601         return _amountOfTokens;
602     }
603 
604     /**
605      * Calculate Token price based on an amount of incoming ethereum
606      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
607      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
608      */
609     function ethereumToTokens_(uint256 _ethereum)
610         internal
611         view
612         returns(uint256)
613     {
614         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
615         uint256 _tokensReceived = 
616          (
617             (
618                 // underflow attempts BTFO
619                 SafeMath.sub(
620                     (sqrt
621                         (
622                             (_tokenPriceInitial**2)
623                             +
624                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
625                             +
626                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
627                             +
628                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
629                         )
630                     ), _tokenPriceInitial
631                 )
632             )/(tokenPriceIncremental_)
633         )-(tokenSupply_)
634         ;
635   
636         return _tokensReceived;
637     }
638     
639     /**
640      * Calculate token sell value.
641      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
642      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
643      */
644      function tokensToEthereum_(uint256 _tokens)
645         internal
646         view
647         returns(uint256)
648     {
649 
650         uint256 tokens_ = (_tokens + 1e18);
651         uint256 _tokenSupply = (tokenSupply_ + 1e18);
652         uint256 _etherReceived =
653         (
654             // underflow attempts BTFO
655             SafeMath.sub(
656                 (
657                     (
658                         (
659                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
660                         )-tokenPriceIncremental_
661                     )*(tokens_ - 1e18)
662                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
663             )
664         /1e18);
665         return _etherReceived;
666     }
667     
668     
669     //This is where all your gas goes, sorry
670     //Not sorry, you probably only paid 1 gwei
671     function sqrt(uint x) internal pure returns (uint y) {
672         uint z = (x + 1) / 2;
673         y = x;
674         while (z < y) {
675             y = z;
676             z = (x / z + z) / 2;
677         }
678     }
679 }
680 
681 /**
682  * @title SafeMath
683  * @dev Math operations with safety checks that throw on error
684  */
685 library SafeMath {
686 
687     /**
688     * @dev Multiplies two numbers, throws on overflow.
689     */
690     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
691         if (a == 0) {
692             return 0;
693         }
694         uint256 c = a * b;
695         assert(c / a == b);
696         return c;
697     }
698 
699     /**
700     * @dev Integer division of two numbers, truncating the quotient.
701     */
702     function div(uint256 a, uint256 b) internal pure returns (uint256) {
703         // assert(b > 0); // Solidity automatically throws when dividing by 0
704         uint256 c = a / b;
705         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
706         return c;
707     }
708 
709     /**
710     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
711     */
712     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
713         assert(b <= a);
714         return a - b;
715     }
716 
717     /**
718     * @dev Adds two numbers, throws on overflow.
719     */
720     function add(uint256 a, uint256 b) internal pure returns (uint256) {
721         uint256 c = a + b;
722         assert(c >= a);
723         return c;
724     }
725 }