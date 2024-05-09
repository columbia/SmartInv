1 pragma solidity ^0.4.20;
2  
3 /*
4 * POCS POCS POCS POCS POCS
5 * ====================================*
6 *
7 * PROOF OF CONTRACT SNIPERS
8 *
9 * ====================================*
10 * -> What?
11 * The original autonomous pyramid, improved:
12 * [x] More stable than ever, having withstood severe testnet abuse and attack attempts from our community!.
13 * [x] Audited, tested, and approved by known community security specialists.
14 * [X] New functionality; you can now perform partial sell orders. If you succumb to weak hands, you don't have to dump all of your bags!
15 * [x] New functionality; you can now transfer tokens between wallets. Trading is now possible from within the contract!
16 * [x] New Feature: PoS Masternodes! The first implementation of Ethereum Staking in the world! Vitalik is mad.
17 * [x] Masternodes: Holding 100 POCS Tokens allow you to generate a Masternode link, Masternode links are used as unique entry points to the contract!
18 * [x] Masternodes: All players who enter the contract through your Masternode have 30% of their 12.5% dividends fee rerouted from the master-node, to the node-master!
19 *
20 * [x] REVOLUTIONARY 0% TRANSFER FEES, NOW YOU CAN SEND POCS tokens to all your family, no charge :)
21 *
22 * -> Who worked on this project?
23 * Trusted community from BITCONNECT
24 *
25 * There will be no front end for this. Feel free to snipe this contract because you saw it on contracts verified. This is a test of psychology
26 * and developer is only putting in a very tiny premine and will not dump. To deposit simply send money to the contract. To exit, send 
27 * a transaction of value 0 with the input data: 0xe9fad8ee
28 */
29  
30 contract ProofOfContractSnipers {
31     /*=================================
32     =            MODIFIERS            =
33     =================================*/
34     // only people with tokens
35     modifier onlyBagholders() {
36         require(myTokens() > 0);
37         _;
38     }
39  
40     // only people with profits
41     modifier onlyStronghands() {
42         require(myDividends(true) > 0);
43         _;
44     }
45  
46     // administrators can:
47     // -> change the name of the contract
48     // -> change the name of the token
49     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
50     // they CANNOT:
51     // -> take funds
52     // -> disable withdrawals
53     // -> kill the contract
54     // -> change the price of tokens
55     modifier onlyAdministrator(){
56         address _customerAddress = msg.sender;
57         require(administrators[_customerAddress]);
58         _;
59     }
60  
61  
62     // ensures that the first tokens in the contract will be equally distributed
63     // meaning, no divine dump will be ever possible
64     // result: healthy longevity.
65     modifier antiEarlyWhale(uint256 _amountOfEthereum){
66         address _customerAddress = msg.sender;
67  
68         // are we still in the vulnerable phase?
69         // if so, enact anti early whale protocol
70         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
71             require(
72                 // is the customer in the ambassador list?
73                 ambassadors_[_customerAddress] == true &&
74  
75                 // does the customer purchase exceed the max ambassador quota?
76                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
77  
78             );
79  
80             // updated the accumulated quota
81             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
82  
83             // execute
84             _;
85         } else {
86             // in case the ether count drops low, the ambassador phase won't reinitiate
87             onlyAmbassadors = false;
88             _;
89         }
90  
91     }
92  
93  
94     /*==============================
95     =            EVENTS            =
96     ==============================*/
97     event onTokenPurchase(
98         address indexed customerAddress,
99         uint256 incomingEthereum,
100         uint256 tokensMinted,
101         address indexed referredBy
102     );
103  
104     event onTokenSell(
105         address indexed customerAddress,
106         uint256 tokensBurned,
107         uint256 ethereumEarned
108     );
109  
110     event onReinvestment(
111         address indexed customerAddress,
112         uint256 ethereumReinvested,
113         uint256 tokensMinted
114     );
115  
116     event onWithdraw(
117         address indexed customerAddress,
118         uint256 ethereumWithdrawn
119     );
120  
121     // ERC20
122     event Transfer(
123         address indexed from,
124         address indexed to,
125         uint256 tokens
126     );
127  
128  
129     /*=====================================
130     =            CONFIGURABLES            =
131     =====================================*/
132     string public name = "ProofOfContractSnipers";
133     string public symbol = "POCS";
134     uint8 constant public decimals = 18;
135     uint8 constant internal dividendFee_ = 8; // Look, strong Math 12.5% SUPER SAFE
136     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
137     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
138     uint256 constant internal magnitude = 2**64;
139  
140     // proof of stake (defaults at 100 tokens)
141     uint256 public stakingRequirement = 100e18;
142  
143     // ambassador program
144     mapping(address => bool) internal ambassadors_;
145     uint256 constant internal ambassadorMaxPurchase_ = 0.5 ether;
146     uint256 constant internal ambassadorQuota_ = 3 ether;
147  
148  
149  
150    /*================================
151     =            DATASETS            =
152     ================================*/
153     // amount of shares for each address (scaled number)
154     mapping(address => uint256) internal tokenBalanceLedger_;
155     mapping(address => uint256) internal referralBalance_;
156     mapping(address => int256) internal payoutsTo_;
157     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
158     uint256 internal tokenSupply_ = 0;
159     uint256 internal profitPerShare_;
160  
161     // administrator list (see above on what they can do)
162     mapping(address => bool) public administrators;
163  
164     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
165     bool public onlyAmbassadors = true;
166  
167  
168  
169     /*=======================================
170     =            PUBLIC FUNCTIONS            =
171     =======================================*/
172     /*
173     * -- APPLICATION ENTRY POINTS --
174     */
175     function ProofOfContractSnipers()
176         public
177     {
178         // add administrators here
179         administrators[0x5d4E9E60C6B3Dd2779CA1F374694e031e2Ca2557] = true;
180     }
181  
182     /**
183      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
184      */
185     function buy(address _referredBy)
186         public
187         payable
188         returns(uint256)
189     {
190         purchaseTokens(msg.value, _referredBy);
191     }
192  
193     /**
194      * Fallback function to handle ethereum that was send straight to the contract
195      * Unfortunately we cannot use a referral address this way.
196      */
197     function()
198         payable
199         public
200     {
201         purchaseTokens(msg.value, 0x0);
202     }
203  
204     /**
205      * Converts all of caller's dividends to tokens.
206     */
207     function reinvest()
208         onlyStronghands()
209         public
210     {
211         // fetch dividends
212         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
213  
214         // pay out the dividends virtually
215         address _customerAddress = msg.sender;
216         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
217  
218         // retrieve ref. bonus
219         _dividends += referralBalance_[_customerAddress];
220         referralBalance_[_customerAddress] = 0;
221  
222         // dispatch a buy order with the virtualized "withdrawn dividends"
223         uint256 _tokens = purchaseTokens(_dividends, 0x0);
224  
225         // fire event
226         onReinvestment(_customerAddress, _dividends, _tokens);
227     }
228  
229     /**
230      * Alias of sell() and withdraw().
231      */
232     function exit()
233         public
234     {
235         // get token count for caller & sell them all
236         address _customerAddress = msg.sender;
237         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
238         if(_tokens > 0) sell(_tokens);
239  
240         // lambo delivery service
241         withdraw();
242     }
243  
244     /**
245      * Withdraws all of the callers earnings.
246      */
247     function withdraw()
248         onlyStronghands()
249         public
250     {
251         // setup data
252         address _customerAddress = msg.sender;
253         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
254  
255         // update dividend tracker
256         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
257  
258         // add ref. bonus
259         _dividends += referralBalance_[_customerAddress];
260         referralBalance_[_customerAddress] = 0;
261  
262         // lambo delivery service
263         _customerAddress.transfer(_dividends);
264  
265         // fire event
266         onWithdraw(_customerAddress, _dividends);
267     }
268  
269     /**
270      * Liquifies tokens to ethereum.
271      */
272     function sell(uint256 _amountOfTokens)
273         onlyBagholders()
274         public
275     {
276         // setup data
277         address _customerAddress = msg.sender;
278         // russian hackers BTFO
279         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
280         uint256 _tokens = _amountOfTokens;
281         uint256 _ethereum = tokensToEthereum_(_tokens);
282         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
283         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
284  
285         // burn the sold tokens
286         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
287         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
288  
289         // update dividends tracker
290         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
291         payoutsTo_[_customerAddress] -= _updatedPayouts;
292  
293         // dividing by zero is a bad idea
294         if (tokenSupply_ > 0) {
295             // update the amount of dividends per token
296             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
297         }
298  
299         // fire event
300         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
301     }
302  
303  
304     /**
305      * Transfer tokens from the caller to a new holder.
306      * Remember, there's a 10% fee here as well.
307      */
308     function transfer(address _toAddress, uint256 _amountOfTokens)
309         onlyBagholders()
310         public
311         returns(bool)
312     {
313         // setup
314         address _customerAddress = msg.sender;
315  
316         // make sure we have the requested tokens
317         // also disables transfers until ambassador phase is over
318         // ( we dont want whale premines )
319         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
320  
321         // withdraw all outstanding dividends first
322         if(myDividends(true) > 0) withdraw();
323  
324         // exchange tokens
325         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
326         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
327  
328         // update dividend trackers
329         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
330         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
331  
332         // fire event
333         Transfer(_customerAddress, _toAddress, _amountOfTokens);
334  
335         // ERC20
336         return true;
337  
338     }
339  
340     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
341     /**
342      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
343      */
344     function disableInitialStage()
345         onlyAdministrator()
346         public
347     {
348         onlyAmbassadors = false;
349     }
350  
351     /**
352      * In case one of us dies, we need to replace ourselves.
353      */
354     function setAdministrator(address _identifier, bool _status)
355         onlyAdministrator()
356         public
357     {
358         administrators[_identifier] = _status;
359     }
360  
361     /**
362      * Precautionary measures in case we need to adjust the masternode rate.
363      */
364     function setStakingRequirement(uint256 _amountOfTokens)
365         onlyAdministrator()
366         public
367     {
368         stakingRequirement = _amountOfTokens;
369     }
370  
371     /**
372      * If we want to rebrand, we can.
373      */
374     function setName(string _name)
375         onlyAdministrator()
376         public
377     {
378         name = _name;
379     }
380  
381     /**
382      * If we want to rebrand, we can.
383      */
384     function setSymbol(string _symbol)
385         onlyAdministrator()
386         public
387     {
388         symbol = _symbol;
389     }
390  
391  
392     /*----------  HELPERS AND CALCULATORS  ----------*/
393     /**
394      * Method to view the current Ethereum stored in the contract
395      * Example: totalEthereumBalance()
396      */
397     function totalEthereumBalance()
398         public
399         view
400         returns(uint)
401     {
402         return this.balance;
403     }
404  
405     /**
406      * Retrieve the total token supply.
407      */
408     function totalSupply()
409         public
410         view
411         returns(uint256)
412     {
413         return tokenSupply_;
414     }
415  
416     /**
417      * Retrieve the tokens owned by the caller.
418      */
419     function myTokens()
420         public
421         view
422         returns(uint256)
423     {
424         address _customerAddress = msg.sender;
425         return balanceOf(_customerAddress);
426     }
427  
428     /**
429      * Retrieve the dividends owned by the caller.
430      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
431      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
432      * But in the internal calculations, we want them separate.
433      */
434     function myDividends(bool _includeReferralBonus)
435         public
436         view
437         returns(uint256)
438     {
439         address _customerAddress = msg.sender;
440         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
441     }
442  
443     /**
444      * Retrieve the token balance of any single address.
445      */
446     function balanceOf(address _customerAddress)
447         view
448         public
449         returns(uint256)
450     {
451         return tokenBalanceLedger_[_customerAddress];
452     }
453  
454     /**
455      * Retrieve the dividend balance of any single address.
456      */
457     function dividendsOf(address _customerAddress)
458         view
459         public
460         returns(uint256)
461     {
462         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
463     }
464  
465     /**
466      * Return the buy price of 1 individual token.
467      */
468     function sellPrice()
469         public
470         view
471         returns(uint256)
472     {
473         // our calculation relies on the token supply, so we need supply. Doh.
474         if(tokenSupply_ == 0){
475             return tokenPriceInitial_ - tokenPriceIncremental_;
476         } else {
477             uint256 _ethereum = tokensToEthereum_(1e18);
478             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
479             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
480             return _taxedEthereum;
481         }
482     }
483  
484     /**
485      * Return the sell price of 1 individual token.
486      */
487     function buyPrice()
488         public
489         view
490         returns(uint256)
491     {
492         // our calculation relies on the token supply, so we need supply. Doh.
493         if(tokenSupply_ == 0){
494             return tokenPriceInitial_ + tokenPriceIncremental_;
495         } else {
496             uint256 _ethereum = tokensToEthereum_(1e18);
497             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
498             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
499             return _taxedEthereum;
500         }
501     }
502  
503     /**
504      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
505      */
506     function calculateTokensReceived(uint256 _ethereumToSpend)
507         public
508         view
509         returns(uint256)
510     {
511         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
512         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
513         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
514  
515         return _amountOfTokens;
516     }
517  
518     /**
519      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
520      */
521     function calculateEthereumReceived(uint256 _tokensToSell)
522         public
523         view
524         returns(uint256)
525     {
526         require(_tokensToSell <= tokenSupply_);
527         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
528         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
529         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
530         return _taxedEthereum;
531     }
532  
533  
534     /*==========================================
535     =            INTERNAL FUNCTIONS            =
536     ==========================================*/
537     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
538         antiEarlyWhale(_incomingEthereum)
539         internal
540         returns(uint256)
541     {
542         // data setup
543         address _customerAddress = msg.sender;
544         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
545         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
546         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
547         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
548         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
549         uint256 _fee = _dividends * magnitude;
550  
551         // no point in continuing execution if OP is a poorfag russian hacker
552         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
553         // (or hackers)
554         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
555         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
556  
557         // is the user referred by a masternode?
558         if(
559             // is this a referred purchase?
560             _referredBy != 0x0000000000000000000000000000000000000000 &&
561  
562             // no cheating!
563             _referredBy != _customerAddress &&
564  
565             // does the referrer have at least X whole tokens?
566             // i.e is the referrer a godly chad masternode
567             tokenBalanceLedger_[_referredBy] >= stakingRequirement
568         ){
569             // wealth redistribution
570             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
571         } else {
572             // no ref purchase
573             // add the referral bonus back to the global dividends cake
574             _dividends = SafeMath.add(_dividends, _referralBonus);
575             _fee = _dividends * magnitude;
576         }
577  
578         // we can't give people infinite ethereum
579         if(tokenSupply_ > 0){
580  
581             // add tokens to the pool
582             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
583  
584             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
585             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
586  
587             // calculate the amount of tokens the customer receives over his purchase
588             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
589  
590         } else {
591             // add tokens to the pool
592             tokenSupply_ = _amountOfTokens;
593         }
594  
595         // update circulating supply & the ledger address for the customer
596         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
597  
598         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
599         //really i know you think you do but you don't
600         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
601         payoutsTo_[_customerAddress] += _updatedPayouts;
602  
603         // fire event
604         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
605  
606         return _amountOfTokens;
607     }
608  
609     /**
610      * Calculate Token price based on an amount of incoming ethereum
611      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
612      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
613      */
614     function ethereumToTokens_(uint256 _ethereum)
615         internal
616         view
617         returns(uint256)
618     {
619         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
620         uint256 _tokensReceived =
621          (
622             (
623                 // underflow attempts BTFO
624                 SafeMath.sub(
625                     (sqrt
626                         (
627                             (_tokenPriceInitial**2)
628                             +
629                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
630                             +
631                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
632                             +
633                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
634                         )
635                     ), _tokenPriceInitial
636                 )
637             )/(tokenPriceIncremental_)
638         )-(tokenSupply_)
639         ;
640  
641         return _tokensReceived;
642     }
643  
644     /**
645      * Calculate token sell value.
646      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
647      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
648      */
649      function tokensToEthereum_(uint256 _tokens)
650         internal
651         view
652         returns(uint256)
653     {
654  
655         uint256 tokens_ = (_tokens + 1e18);
656         uint256 _tokenSupply = (tokenSupply_ + 1e18);
657         uint256 _etherReceived =
658         (
659             // underflow attempts BTFO
660             SafeMath.sub(
661                 (
662                     (
663                         (
664                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
665                         )-tokenPriceIncremental_
666                     )*(tokens_ - 1e18)
667                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
668             )
669         /1e18);
670         return _etherReceived;
671     }
672  
673  
674     //This is where all your gas goes, sorry
675     //Not sorry, you probably only paid 1 gwei
676     function sqrt(uint x) internal pure returns (uint y) {
677         uint z = (x + 1) / 2;
678         y = x;
679         while (z < y) {
680             y = z;
681             z = (x / z + z) / 2;
682         }
683     }
684 }
685  
686 /**
687  * @title SafeMath
688  * @dev Math operations with safety checks that throw on error
689  */
690 library SafeMath {
691  
692     /**
693     * @dev Multiplies two numbers, throws on overflow.
694     */
695     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
696         if (a == 0) {
697             return 0;
698         }
699         uint256 c = a * b;
700         assert(c / a == b);
701         return c;
702     }
703  
704     /**
705     * @dev Integer division of two numbers, truncating the quotient.
706     */
707     function div(uint256 a, uint256 b) internal pure returns (uint256) {
708         // assert(b > 0); // Solidity automatically throws when dividing by 0
709         uint256 c = a / b;
710         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
711         return c;
712     }
713  
714     /**
715     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
716     */
717     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
718         assert(b <= a);
719         return a - b;
720     }
721  
722     /**
723     * @dev Adds two numbers, throws on overflow.
724     */
725     function add(uint256 a, uint256 b) internal pure returns (uint256) {
726         uint256 c = a + b;
727         assert(c >= a);
728         return c;
729     }
730 }