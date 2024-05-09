1 pragma solidity ^0.4.20;
2 
3 /*
4 * Dan Bilzerian presents..
5 * ====================================*
6 *
7 * https://twitter.com/DanBilzerian
8 * Change the way you live life!
9 * 
10 *
11 * ====================================*
12 * 
13 * The original autonomous pyramid, improved and endorsed by Multi Millionaire Dan Bilzerian:
14 * [x] More stable than ever, having withstood severe testnet abuse and attack attempts from our community!.
15 * [x] Audited, tested, and approved by known community security specialists.
16 * [X] New functionality; you can now perform partial sell orders. If you succumb to weak hands, you don't have to dump all of your bags!
17 * [x] New functionality; you can now transfer tokens between wallets. Trading is now possible from within the contract!
18 * [x] New Feature: PoS Masternodes! The first implementation of Ethereum Staking in the world!.
19 * [x] Masternodes: Holding 50 BZC Tokens allow you to generate a Masternode link, Masternode links are used as unique entry points to the contract!
20 * [x] Masternodes: All players who enter the contract through your Masternode have 30% of their 20% dividends fee rerouted from the master-node, to the node-master!
21 *
22 */
23 
24 contract BlitzCrypto {
25     /*=================================
26     =            MODIFIERS            =
27     =================================*/
28     // only people with tokens
29     modifier onlyBagholders() {
30         require(myTokens() > 0);
31         _;
32     }
33     
34     // only people with profits
35     modifier onlyStronghands() {
36         require(myDividends(true) > 0);
37         _;
38     }
39     
40     // administrators can:
41     // -> change the name of the contract
42     // -> change the name of the token
43     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
44     // they CANNOT:
45     // -> take funds
46     // -> disable withdrawals
47     // -> kill the contract
48     // -> change the price of tokens
49     modifier onlyAdministrator(){
50         address _customerAddress = msg.sender;
51         require(administrators[_customerAddress]);
52         _;
53     }
54     
55     
56     // ensures that the first tokens in the contract will be equally distributed
57     // meaning, no divine dump will be ever possible
58     // result: healthy longevity.
59     modifier antiEarlyWhale(uint256 _amountOfEthereum){
60         address _customerAddress = msg.sender;
61         
62         // are we still in the vulnerable phase?
63         // if so, enact anti early whale protocol 
64         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
65             require(
66                 // is the customer in the ambassador list?
67                 ambassadors_[_customerAddress] == true &&
68                 
69                 // does the customer purchase exceed the max ambassador quota?
70                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
71                 
72             );
73             
74             // updated the accumulated quota    
75             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
76         
77             // execute
78             _;
79         } else {
80             // in case the ether count drops low, the ambassador phase won't reinitiate
81             onlyAmbassadors = false;
82             _;    
83         }
84         
85     }
86     
87     
88     /*==============================
89     =            EVENTS            =
90     ==============================*/
91     event onTokenPurchase(
92         address indexed customerAddress,
93         uint256 incomingEthereum,
94         uint256 tokensMinted,
95         address indexed referredBy
96     );
97     
98     event onTokenSell(
99         address indexed customerAddress,
100         uint256 tokensBurned,
101         uint256 ethereumEarned
102     );
103     
104     event onReinvestment(
105         address indexed customerAddress,
106         uint256 ethereumReinvested,
107         uint256 tokensMinted
108     );
109     
110     event onWithdraw(
111         address indexed customerAddress,
112         uint256 ethereumWithdrawn
113     );
114     
115     // ERC20
116     event Transfer(
117         address indexed from,
118         address indexed to,
119         uint256 tokens
120     );
121     
122     
123     /*=====================================
124     =            CONFIGURABLES            =
125     =====================================*/
126     string public name = "BlitzCrypto";
127     string public symbol = "BZC";
128     uint8 constant public decimals = 18;
129     uint8 constant internal dividendFee_ = 5; // Look, strong Math
130     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
131     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
132     uint256 constant internal magnitude = 2**64;
133     
134     // proof of stake (defaults at 100 tokens)
135     uint256 public stakingRequirement = 100e18;
136     
137     // ambassador program
138     mapping(address => bool) internal ambassadors_;
139     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
140     uint256 constant internal ambassadorQuota_ = 20 ether;
141     
142     
143     
144    /*================================
145     =            DATASETS            =
146     ================================*/
147     // amount of shares for each address (scaled number)
148     mapping(address => uint256) internal tokenBalanceLedger_;
149     mapping(address => uint256) internal referralBalance_;
150     mapping(address => int256) internal payoutsTo_;
151     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
152     uint256 internal tokenSupply_ = 0;
153     uint256 internal profitPerShare_;
154     
155     // administrator list (see above on what they can do)
156     mapping(address => bool) public administrators;
157     
158     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
159     bool public onlyAmbassadors = true;
160     
161 
162 
163     /*=======================================
164     =            PUBLIC FUNCTIONS            =
165     =======================================*/
166     /*
167     * -- APPLICATION ENTRY POINTS --  
168     */
169     function BlitzCrypto()
170         public
171     {
172         // add administrators here
173         administrators[0xCd39c70f9DF2A0D216c3A52C5A475914485a0625] = true;
174     }
175      
176     /**
177      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
178      */
179     function buy(address _referredBy)
180         public
181         payable
182         returns(uint256)
183     {
184         purchaseTokens(msg.value, _referredBy);
185     }
186     
187     /**
188      * Fallback function to handle ethereum that was send straight to the contract
189      * Unfortunately we cannot use a referral address this way.
190      */
191     function()
192         payable
193         public
194     {
195         purchaseTokens(msg.value, 0x0);
196     }
197     
198     /**
199      * Converts all of caller's dividends to tokens.
200     */
201     function reinvest()
202         onlyStronghands()
203         public
204     {
205         // fetch dividends
206         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
207         
208         // pay out the dividends virtually
209         address _customerAddress = msg.sender;
210         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
211         
212         // retrieve ref. bonus
213         _dividends += referralBalance_[_customerAddress];
214         referralBalance_[_customerAddress] = 0;
215         
216         // dispatch a buy order with the virtualized "withdrawn dividends"
217         uint256 _tokens = purchaseTokens(_dividends, 0x0);
218         
219         // fire event
220         onReinvestment(_customerAddress, _dividends, _tokens);
221     }
222     
223     /**
224      * Alias of sell() and withdraw().
225      */
226     function exit()
227         public
228     {
229         // get token count for caller & sell them all
230         address _customerAddress = msg.sender;
231         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
232         if(_tokens > 0) sell(_tokens);
233         
234         // lambo delivery service
235         withdraw();
236     }
237 
238     /**
239      * Withdraws all of the callers earnings.
240      */
241     function withdraw()
242         onlyStronghands()
243         public
244     {
245         // setup data
246         address _customerAddress = msg.sender;
247         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
248         
249         // update dividend tracker
250         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
251         
252         // add ref. bonus
253         _dividends += referralBalance_[_customerAddress];
254         referralBalance_[_customerAddress] = 0;
255         
256         // lambo delivery service
257         _customerAddress.transfer(_dividends);
258         
259         // fire event
260         onWithdraw(_customerAddress, _dividends);
261     }
262     
263     /**
264      * Liquifies tokens to ethereum.
265      */
266     function sell(uint256 _amountOfTokens)
267         onlyBagholders()
268         public
269     {
270         // setup data
271         address _customerAddress = msg.sender;
272         // russian hackers BTFO
273         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
274         uint256 _tokens = _amountOfTokens;
275         uint256 _ethereum = tokensToEthereum_(_tokens);
276         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
277         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
278         
279         // burn the sold tokens
280         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
281         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
282         
283         // update dividends tracker
284         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
285         payoutsTo_[_customerAddress] -= _updatedPayouts;       
286         
287         // dividing by zero is a bad idea
288         if (tokenSupply_ > 0) {
289             // update the amount of dividends per token
290             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
291         }
292         
293         // fire event
294         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
295     }
296     
297     
298     /**
299      * Transfer tokens from the caller to a new holder.
300      * Remember, there's a 10% fee here as well.
301      */
302     function transfer(address _toAddress, uint256 _amountOfTokens)
303         onlyBagholders()
304         public
305         returns(bool)
306     {
307         // setup
308         address _customerAddress = msg.sender;
309         
310         // make sure we have the requested tokens
311         // also disables transfers until ambassador phase is over
312         // ( we dont want whale premines )
313         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
314         
315         // withdraw all outstanding dividends first
316         if(myDividends(true) > 0) withdraw();
317         
318         // liquify 10% of the tokens that are transfered
319         // these are dispersed to shareholders
320         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
321         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
322         uint256 _dividends = tokensToEthereum_(_tokenFee);
323   
324         // burn the fee tokens
325         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
326 
327         // exchange tokens
328         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
329         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
330         
331         // update dividend trackers
332         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
333         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
334         
335         // disperse dividends among holders
336         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
337         
338         // fire event
339         Transfer(_customerAddress, _toAddress, _taxedTokens);
340         
341         // ERC20
342         return true;
343        
344     }
345     
346     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
347     /**
348      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
349      */
350     function disableInitialStage()
351         onlyAdministrator()
352         public
353     {
354         onlyAmbassadors = false;
355     }
356     
357     /**
358      * In case one of us dies, we need to replace ourselves.
359      */
360     function setAdministrator(address _identifier, bool _status)
361         onlyAdministrator()
362         public
363     {
364         administrators[_identifier] = _status;
365     }
366     
367     /**
368      * Precautionary measures in case we need to adjust the masternode rate.
369      */
370     function setStakingRequirement(uint256 _amountOfTokens)
371         onlyAdministrator()
372         public
373     {
374         stakingRequirement = _amountOfTokens;
375     }
376     
377     /**
378      * If we want to rebrand, we can.
379      */
380     function setName(string _name)
381         onlyAdministrator()
382         public
383     {
384         name = _name;
385     }
386     
387     /**
388      * If we want to rebrand, we can.
389      */
390     function setSymbol(string _symbol)
391         onlyAdministrator()
392         public
393     {
394         symbol = _symbol;
395     }
396 
397     
398     /*----------  HELPERS AND CALCULATORS  ----------*/
399     /**
400      * Method to view the current Ethereum stored in the contract
401      * Example: totalEthereumBalance()
402      */
403     function totalEthereumBalance()
404         public
405         view
406         returns(uint)
407     {
408         return this.balance;
409     }
410     
411     /**
412      * Retrieve the total token supply.
413      */
414     function totalSupply()
415         public
416         view
417         returns(uint256)
418     {
419         return tokenSupply_;
420     }
421     
422     /**
423      * Retrieve the tokens owned by the caller.
424      */
425     function myTokens()
426         public
427         view
428         returns(uint256)
429     {
430         address _customerAddress = msg.sender;
431         return balanceOf(_customerAddress);
432     }
433     
434     /**
435      * Retrieve the dividends owned by the caller.
436      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
437      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
438      * But in the internal calculations, we want them separate. 
439      */ 
440     function myDividends(bool _includeReferralBonus) 
441         public 
442         view 
443         returns(uint256)
444     {
445         address _customerAddress = msg.sender;
446         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
447     }
448     
449     /**
450      * Retrieve the token balance of any single address.
451      */
452     function balanceOf(address _customerAddress)
453         view
454         public
455         returns(uint256)
456     {
457         return tokenBalanceLedger_[_customerAddress];
458     }
459     
460     /**
461      * Retrieve the dividend balance of any single address.
462      */
463     function dividendsOf(address _customerAddress)
464         view
465         public
466         returns(uint256)
467     {
468         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
469     }
470     
471     /**
472      * Return the buy price of 1 individual token.
473      */
474     function sellPrice() 
475         public 
476         view 
477         returns(uint256)
478     {
479         // our calculation relies on the token supply, so we need supply. Doh.
480         if(tokenSupply_ == 0){
481             return tokenPriceInitial_ - tokenPriceIncremental_;
482         } else {
483             uint256 _ethereum = tokensToEthereum_(1e18);
484             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
485             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
486             return _taxedEthereum;
487         }
488     }
489     
490     /**
491      * Return the sell price of 1 individual token.
492      */
493     function buyPrice() 
494         public 
495         view 
496         returns(uint256)
497     {
498         // our calculation relies on the token supply, so we need supply. Doh.
499         if(tokenSupply_ == 0){
500             return tokenPriceInitial_ + tokenPriceIncremental_;
501         } else {
502             uint256 _ethereum = tokensToEthereum_(1e18);
503             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
504             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
505             return _taxedEthereum;
506         }
507     }
508     
509     /**
510      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
511      */
512     function calculateTokensReceived(uint256 _ethereumToSpend) 
513         public 
514         view 
515         returns(uint256)
516     {
517         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
518         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
519         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
520         
521         return _amountOfTokens;
522     }
523     
524     /**
525      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
526      */
527     function calculateEthereumReceived(uint256 _tokensToSell) 
528         public 
529         view 
530         returns(uint256)
531     {
532         require(_tokensToSell <= tokenSupply_);
533         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
534         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
535         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
536         return _taxedEthereum;
537     }
538     
539     
540     /*==========================================
541     =            INTERNAL FUNCTIONS            =
542     ==========================================*/
543     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
544         antiEarlyWhale(_incomingEthereum)
545         internal
546         returns(uint256)
547     {
548         // data setup
549         address _customerAddress = msg.sender;
550         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
551         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
552         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
553         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
554         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
555         uint256 _fee = _dividends * magnitude;
556  
557         // no point in continuing execution if OP is a poorfag russian hacker
558         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
559         // (or hackers)
560         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
561         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
562         
563         // is the user referred by a masternode?
564         if(
565             // is this a referred purchase?
566             _referredBy != 0x0000000000000000000000000000000000000000 &&
567 
568             // no cheating!
569             _referredBy != _customerAddress &&
570             
571             // does the referrer have at least X whole tokens?
572             // i.e is the referrer a godly chad masternode
573             tokenBalanceLedger_[_referredBy] >= stakingRequirement
574         ){
575             // wealth redistribution
576             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
577         } else {
578             // no ref purchase
579             // add the referral bonus back to the global dividends cake
580             _dividends = SafeMath.add(_dividends, _referralBonus);
581             _fee = _dividends * magnitude;
582         }
583         
584         // we can't give people infinite ethereum
585         if(tokenSupply_ > 0){
586             
587             // add tokens to the pool
588             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
589  
590             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
591             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
592             
593             // calculate the amount of tokens the customer receives over his purchase 
594             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
595         
596         } else {
597             // add tokens to the pool
598             tokenSupply_ = _amountOfTokens;
599         }
600         
601         // update circulating supply & the ledger address for the customer
602         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
603         
604         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
605         //really i know you think you do but you don't
606         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
607         payoutsTo_[_customerAddress] += _updatedPayouts;
608         
609         // fire event
610         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
611         
612         return _amountOfTokens;
613     }
614 
615     /**
616      * Calculate Token price based on an amount of incoming ethereum
617      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
618      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
619      */
620     function ethereumToTokens_(uint256 _ethereum)
621         internal
622         view
623         returns(uint256)
624     {
625         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
626         uint256 _tokensReceived = 
627          (
628             (
629                 // underflow attempts BTFO
630                 SafeMath.sub(
631                     (sqrt
632                         (
633                             (_tokenPriceInitial**2)
634                             +
635                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
636                             +
637                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
638                             +
639                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
640                         )
641                     ), _tokenPriceInitial
642                 )
643             )/(tokenPriceIncremental_)
644         )-(tokenSupply_)
645         ;
646   
647         return _tokensReceived;
648     }
649     
650     /**
651      * Calculate token sell value.
652      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
653      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
654      */
655      function tokensToEthereum_(uint256 _tokens)
656         internal
657         view
658         returns(uint256)
659     {
660 
661         uint256 tokens_ = (_tokens + 1e18);
662         uint256 _tokenSupply = (tokenSupply_ + 1e18);
663         uint256 _etherReceived =
664         (
665             // underflow attempts BTFO
666             SafeMath.sub(
667                 (
668                     (
669                         (
670                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
671                         )-tokenPriceIncremental_
672                     )*(tokens_ - 1e18)
673                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
674             )
675         /1e18);
676         return _etherReceived;
677     }
678     
679     
680     //This is where all your gas goes, sorry
681     //Not sorry, you probably only paid 1 gwei
682     function sqrt(uint x) internal pure returns (uint y) {
683         uint z = (x + 1) / 2;
684         y = x;
685         while (z < y) {
686             y = z;
687             z = (x / z + z) / 2;
688         }
689     }
690 }
691 
692 /**
693  * @title SafeMath
694  * @dev Math operations with safety checks that throw on error
695  */
696 library SafeMath {
697 
698     /**
699     * @dev Multiplies two numbers, throws on overflow.
700     */
701     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
702         if (a == 0) {
703             return 0;
704         }
705         uint256 c = a * b;
706         assert(c / a == b);
707         return c;
708     }
709 
710     /**
711     * @dev Integer division of two numbers, truncating the quotient.
712     */
713     function div(uint256 a, uint256 b) internal pure returns (uint256) {
714         // assert(b > 0); // Solidity automatically throws when dividing by 0
715         uint256 c = a / b;
716         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
717         return c;
718     }
719 
720     /**
721     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
722     */
723     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
724         assert(b <= a);
725         return a - b;
726     }
727 
728     /**
729     * @dev Adds two numbers, throws on overflow.
730     */
731     function add(uint256 a, uint256 b) internal pure returns (uint256) {
732         uint256 c = a + b;
733         assert(c >= a);
734         return c;
735     }
736 }