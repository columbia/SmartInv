1 pragma solidity ^0.4.20;
2 
3 /*
4 * Team JUST presents..
5 * GasWars
6 * -> What?
7 * The original autonomous pyramid, improved:
8 * [x] More stable than ever, having withstood severe testnet abuse and attack attempts from our community!.
9 * [x] Audited, tested, and approved by known community security specialists such as tocsick and Arc.
10 * [X] New functionality; you can now perform partial sell orders. If you succumb to weak hands, you don't have to dump all of your bags!
11 * [x] New functionality; you can now transfer tokens between wallets. Trading is now possible from within the contract!
12 * [x] New Feature: PoS Masternodes! The first implementation of Ethereum Staking in the world! Vitalik is mad.
13 * [x] Masternodes: Holding 100 PoWH3D Tokens allow you to generate a Masternode link, Masternode links are used as unique entry points to the contract!
14 * [x] Masternodes: All players who enter the contract through your Masternode have 30% of their 10% dividends fee rerouted from the master-node, to the node-master!
15 *
16 * -> What about the last projects?
17 * Every programming member of the old dev team has been fired and/or killed by 232.
18 * The new dev team consists of seasoned, professional developers and has been audited by veteran solidity experts.
19 * Additionally, two independent testnet iterations have been used by hundreds of people; not a single point of failure was found.
20 * 
21 * -> Who worked on this project?
22 * - PonziBot (math/memes/main site/master)
23 * - Mantso (lead solidity dev/lead web3 dev)
24 * - swagg (concept design/feedback/management)
25 * - Anonymous#1 (main site/web3/test cases)
26 * - Anonymous#2 (math formulae/whitepaper)
27 *
28 * -> Who has audited & approved the projected:
29 * - Arc
30 * - tocisck
31 * - sumpunk
32 */
33 
34 contract Hourglass {
35     /*=================================
36     =            MODIFIERS            =
37     =================================*/
38     // only people with tokens
39     modifier onlyBagholders() {
40         require(myTokens() > 0);
41         _;
42     }
43     
44     // only people with profits
45     modifier onlyStronghands() {
46         require(myDividends(true) > 0);
47         _;
48     }
49     
50     // administrators can:
51     // -> change the name of the contract
52     // -> change the name of the token
53     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
54     // they CANNOT:
55     // -> take funds
56     // -> disable withdrawals
57     // -> kill the contract
58     // -> change the price of tokens
59     modifier onlyAdministrator(){
60         address _customerAddress = msg.sender;
61         require(administrators[keccak256(_customerAddress)]);
62         _;
63     }
64     
65     
66     // ensures that the first tokens in the contract will be equally distributed
67     // meaning, no divine dump will be ever possible
68     // result: healthy longevity.
69     modifier antiEarlyWhale(uint256 _amountOfEthereum){
70         address _customerAddress = msg.sender;
71         
72         // are we still in the vulnerable phase?
73         // if so, enact anti early whale protocol 
74         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
75             require(
76                 // is the customer in the ambassador list?
77                 ambassadors_[_customerAddress] == true &&
78                 
79                 // does the customer purchase exceed the max ambassador quota?
80                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
81             
82                 
83             );
84             
85             // updated the accumulated quota    
86             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
87         
88             // execute
89             _;
90         } else {
91             require(1527359400 < now);
92             // in case the ether count drops low, the ambassador phase won't reinitiate
93             onlyAmbassadors = false;
94             _;    
95         }
96         
97     }
98     
99     
100     /*==============================
101     =            EVENTS            =
102     ==============================*/
103     event onTokenPurchase(
104         address indexed customerAddress,
105         uint256 incomingEthereum,
106         uint256 tokensMinted,
107         address indexed referredBy
108     );
109     
110     event onTokenSell(
111         address indexed customerAddress,
112         uint256 tokensBurned,
113         uint256 ethereumEarned
114     );
115     
116     event onReinvestment(
117         address indexed customerAddress,
118         uint256 ethereumReinvested,
119         uint256 tokensMinted
120     );
121     
122     event onWithdraw(
123         address indexed customerAddress,
124         uint256 ethereumWithdrawn
125     );
126     
127     // ERC20
128     event Transfer(
129         address indexed from,
130         address indexed to,
131         uint256 tokens
132     );
133     
134     
135     /*=====================================
136     =            CONFIGURABLES            =
137     =====================================*/
138     string public name = "GasWars";
139     string public symbol = "GAST";
140     uint8 constant public decimals = 18;
141     uint8 constant internal dividendFee_ = 10;
142     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
143     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
144     uint256 constant internal magnitude = 2**64;
145     
146     // proof of stake (defaults at 5 tokens)
147     uint256 public stakingRequirement = 5e18;
148     
149     // ambassador program
150     mapping(address => bool) internal ambassadors_;
151     uint256 constant internal ambassadorMaxPurchase_ = 1.1 ether;
152     uint256 constant internal ambassadorQuota_ = 2 ether;
153     
154     
155     
156    /*================================
157     =            DATASETS            =
158     ================================*/
159     // amount of shares for each address (scaled number)
160     mapping(address => uint256) internal tokenBalanceLedger_;
161     mapping(address => uint256) internal referralBalance_;
162     mapping(address => int256) internal payoutsTo_;
163     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
164     uint256 internal tokenSupply_ = 0;
165     uint256 internal profitPerShare_;
166     
167     // administrator list (see above on what they can do)
168     mapping(bytes32 => bool) public administrators;
169     
170     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
171     bool public onlyAmbassadors = true;
172     
173 
174 
175     /*=======================================
176     =            PUBLIC FUNCTIONS            =
177     =======================================*/
178     /*
179     * -- APPLICATION ENTRY POINTS --  
180     */
181     function Hourglass()
182         public
183     {
184         ambassadors_[0xfe188a117a8759d2b61a4ed2620ba60361b99361] = true;
185         ambassadors_[0x4ffE17a2A72bC7422CB176bC71c04EE6D87cE329] = true;
186     }
187     
188      
189     /**
190      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
191      */
192     function buy(address _referredBy)
193         public
194         payable
195         returns(uint256)
196     {
197         purchaseTokens(msg.value, _referredBy);
198     }
199     
200     /**
201      * Fallback function to handle ethereum that was send straight to the contract
202      * Unfortunately we cannot use a referral address this way.
203      */
204     function()
205         payable
206         public
207     {
208         purchaseTokens(msg.value, 0x0);
209     }
210     
211     /**
212      * Converts all of caller's dividends to tokens.
213      */
214     function reinvest()
215         onlyStronghands()
216         public
217     {
218         // fetch dividends
219         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
220         
221         // pay out the dividends virtually
222         address _customerAddress = msg.sender;
223         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
224         
225         // retrieve ref. bonus
226         _dividends += referralBalance_[_customerAddress];
227         referralBalance_[_customerAddress] = 0;
228         
229         // dispatch a buy order with the virtualized "withdrawn dividends"
230         uint256 _tokens = purchaseTokens(_dividends, 0x0);
231         
232         // fire event
233         onReinvestment(_customerAddress, _dividends, _tokens);
234     }
235     
236     /**
237      * Alias of sell() and withdraw().
238      */
239     function exit()
240         public
241     {
242         // get token count for caller & sell them all
243         address _customerAddress = msg.sender;
244         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
245         if(_tokens > 0) sell(_tokens);
246         
247         // lambo delivery service
248         withdraw();
249     }
250 
251     /**
252      * Withdraws all of the callers earnings.
253      */
254     function withdraw()
255         onlyStronghands()
256         public
257     {
258         // setup data
259         address _customerAddress = msg.sender;
260         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
261         
262         // update dividend tracker
263         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
264         
265         // add ref. bonus
266         _dividends += referralBalance_[_customerAddress];
267         referralBalance_[_customerAddress] = 0;
268         
269         // lambo delivery service
270         _customerAddress.transfer(_dividends);
271         
272         // fire event
273         onWithdraw(_customerAddress, _dividends);
274     }
275     
276     /**
277      * Liquifies tokens to ethereum.
278      */
279     function sell(uint256 _amountOfTokens)
280         onlyBagholders()
281         public
282     {
283         // setup data
284         address _customerAddress = msg.sender;
285         // russian hackers BTFO
286         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
287         uint256 _tokens = _amountOfTokens;
288         uint256 _ethereum = tokensToEthereum_(_tokens);
289         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
290         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
291         
292         // burn the sold tokens
293         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
294         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
295         
296         // update dividends tracker
297         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
298         payoutsTo_[_customerAddress] -= _updatedPayouts;       
299         
300         // dividing by zero is a bad idea
301         if (tokenSupply_ > 0) {
302             // update the amount of dividends per token
303             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
304         }
305         
306         // fire event
307         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
308     }
309     
310     
311     /**
312      * Transfer tokens from the caller to a new holder.
313      * Remember, there's a 10% fee here as well.
314      */
315     function transfer(address _toAddress, uint256 _amountOfTokens)
316         onlyBagholders()
317         public
318         returns(bool)
319     {
320         // setup
321         address _customerAddress = msg.sender;
322         
323         // make sure we have the requested tokens
324         // also disables transfers until ambassador phase is over
325         // ( we dont want whale premines )
326         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
327         
328         // withdraw all outstanding dividends first
329         if(myDividends(true) > 0) withdraw();
330         
331         // liquify 10% of the tokens that are transfered
332         // these are dispersed to shareholders
333         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
334         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
335         uint256 _dividends = tokensToEthereum_(_tokenFee);
336   
337         // burn the fee tokens
338         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
339 
340         // exchange tokens
341         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
342         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
343         
344         // update dividend trackers
345         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
346         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
347         
348         // disperse dividends among holders
349         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
350         
351         // fire event
352         Transfer(_customerAddress, _toAddress, _taxedTokens);
353         
354         // ERC20
355         return true;
356        
357     }
358     
359     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
360     /**
361      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
362      */
363     function disableInitialStage()
364         onlyAdministrator()
365         public
366     {
367         onlyAmbassadors = false;
368     }
369     
370     /**
371      * In case one of us dies, we need to replace ourselves.
372      */
373     function setAdministrator(bytes32 _identifier, bool _status)
374         onlyAdministrator()
375         public
376     {
377         administrators[_identifier] = _status;
378     }
379     
380     /**
381      * Precautionary measures in case we need to adjust the masternode rate.
382      */
383     function setStakingRequirement(uint256 _amountOfTokens)
384         onlyAdministrator()
385         public
386     {
387         stakingRequirement = _amountOfTokens;
388     }
389     
390     /**
391      * If we want to rebrand, we can.
392      */
393     function setName(string _name)
394         onlyAdministrator()
395         public
396     {
397         name = _name;
398     }
399     
400     /**
401      * If we want to rebrand, we can.
402      */
403     function setSymbol(string _symbol)
404         onlyAdministrator()
405         public
406     {
407         symbol = _symbol;
408     }
409 
410     
411     /*----------  HELPERS AND CALCULATORS  ----------*/
412     /**
413      * Method to view the current Ethereum stored in the contract
414      * Example: totalEthereumBalance()
415      */
416     function totalEthereumBalance()
417         public
418         view
419         returns(uint)
420     {
421         return this.balance;
422     }
423     
424     /**
425      * Retrieve the total token supply.
426      */
427     function totalSupply()
428         public
429         view
430         returns(uint256)
431     {
432         return tokenSupply_;
433     }
434     
435     /**
436      * Retrieve the tokens owned by the caller.
437      */
438     function myTokens()
439         public
440         view
441         returns(uint256)
442     {
443         address _customerAddress = msg.sender;
444         return balanceOf(_customerAddress);
445     }
446     
447     /**
448      * Retrieve the dividends owned by the caller.
449      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
450      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
451      * But in the internal calculations, we want them separate. 
452      */ 
453     function myDividends(bool _includeReferralBonus) 
454         public 
455         view 
456         returns(uint256)
457     {
458         address _customerAddress = msg.sender;
459         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
460     }
461     
462     /**
463      * Retrieve the token balance of any single address.
464      */
465     function balanceOf(address _customerAddress)
466         view
467         public
468         returns(uint256)
469     {
470         return tokenBalanceLedger_[_customerAddress];
471     }
472     
473     /**
474      * Retrieve the dividend balance of any single address.
475      */
476     function dividendsOf(address _customerAddress)
477         view
478         public
479         returns(uint256)
480     {
481         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
482     }
483     
484     /**
485      * Return the buy price of 1 individual token.
486      */
487     function sellPrice() 
488         public 
489         view 
490         returns(uint256)
491     {
492         // our calculation relies on the token supply, so we need supply. Doh.
493         if(tokenSupply_ == 0){
494             return tokenPriceInitial_ - tokenPriceIncremental_;
495         } else {
496             uint256 _ethereum = tokensToEthereum_(1e18);
497             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
498             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
499             return _taxedEthereum;
500         }
501     }
502     
503     /**
504      * Return the sell price of 1 individual token.
505      */
506     function buyPrice() 
507         public 
508         view 
509         returns(uint256)
510     {
511         // our calculation relies on the token supply, so we need supply. Doh.
512         if(tokenSupply_ == 0){
513             return tokenPriceInitial_ + tokenPriceIncremental_;
514         } else {
515             uint256 _ethereum = tokensToEthereum_(1e18);
516             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
517             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
518             return _taxedEthereum;
519         }
520     }
521     
522     /**
523      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
524      */
525     function calculateTokensReceived(uint256 _ethereumToSpend) 
526         public 
527         view 
528         returns(uint256)
529     {
530         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
531         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
532         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
533         
534         return _amountOfTokens;
535     }
536     
537     /**
538      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
539      */
540     function calculateEthereumReceived(uint256 _tokensToSell) 
541         public 
542         view 
543         returns(uint256)
544     {
545         require(_tokensToSell <= tokenSupply_);
546         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
547         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
548         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
549         return _taxedEthereum;
550     }
551     
552     
553     /*==========================================
554     =            INTERNAL FUNCTIONS            =
555     ==========================================*/
556     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
557         antiEarlyWhale(_incomingEthereum)
558         internal
559         returns(uint256)
560     {
561         // data setup
562         address _customerAddress = msg.sender;
563         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
564         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
565         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
566         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
567         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
568         uint256 _fee = _dividends * magnitude;
569  
570         // no point in continuing execution if OP is a poorfag russian hacker
571         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
572         // (or hackers)
573         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
574         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
575         
576         // is the user referred by a masternode?
577         if(
578             // is this a referred purchase?
579             _referredBy != 0x0000000000000000000000000000000000000000 &&
580 
581             // no cheating!
582             _referredBy != _customerAddress &&
583             
584             // does the referrer have at least X whole tokens?
585             // i.e is the referrer a godly chad masternode
586             tokenBalanceLedger_[_referredBy] >= stakingRequirement
587         ){
588             // wealth redistribution
589             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
590         } else {
591             // no ref purchase
592             // add the referral bonus back to the global dividends cake
593             _dividends = SafeMath.add(_dividends, _referralBonus);
594             _fee = _dividends * magnitude;
595         }
596         
597         // we can't give people infinite ethereum
598         if(tokenSupply_ > 0){
599             
600             // add tokens to the pool
601             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
602  
603             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
604             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
605             
606             // calculate the amount of tokens the customer receives over his purchase 
607             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
608         
609         } else {
610             // add tokens to the pool
611             tokenSupply_ = _amountOfTokens;
612         }
613         
614         // update circulating supply & the ledger address for the customer
615         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
616         
617         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
618         //really i know you think you do but you don't
619         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
620         payoutsTo_[_customerAddress] += _updatedPayouts;
621         
622         // fire event
623         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
624         
625         return _amountOfTokens;
626     }
627 
628     /**
629      * Calculate Token price based on an amount of incoming ethereum
630      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
631      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
632      */
633     function ethereumToTokens_(uint256 _ethereum)
634         internal
635         view
636         returns(uint256)
637     {
638         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
639         uint256 _tokensReceived = 
640          (
641             (
642                 // underflow attempts BTFO
643                 SafeMath.sub(
644                     (sqrt
645                         (
646                             (_tokenPriceInitial**2)
647                             +
648                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
649                             +
650                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
651                             +
652                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
653                         )
654                     ), _tokenPriceInitial
655                 )
656             )/(tokenPriceIncremental_)
657         )-(tokenSupply_)
658         ;
659   
660         return _tokensReceived;
661     }
662     
663     /**
664      * Calculate token sell value.
665      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
666      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
667      */
668      function tokensToEthereum_(uint256 _tokens)
669         internal
670         view
671         returns(uint256)
672     {
673 
674         uint256 tokens_ = (_tokens + 1e18);
675         uint256 _tokenSupply = (tokenSupply_ + 1e18);
676         uint256 _etherReceived =
677         (
678             // underflow attempts BTFO
679             SafeMath.sub(
680                 (
681                     (
682                         (
683                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
684                         )-tokenPriceIncremental_
685                     )*(tokens_ - 1e18)
686                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
687             )
688         /1e18);
689         return _etherReceived;
690     }
691     
692     
693     //This is where all your gas goes, sorry
694     //Not sorry, you probably only paid 1 gwei
695     function sqrt(uint x) internal pure returns (uint y) {
696         uint z = (x + 1) / 2;
697         y = x;
698         while (z < y) {
699             y = z;
700             z = (x / z + z) / 2;
701         }
702     }
703 }
704 
705 /**
706  * @title SafeMath
707  * @dev Math operations with safety checks that throw on error
708  */
709 library SafeMath {
710 
711     /**
712     * @dev Multiplies two numbers, throws on overflow.
713     */
714     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
715         if (a == 0) {
716             return 0;
717         }
718         uint256 c = a * b;
719         assert(c / a == b);
720         return c;
721     }
722 
723     /**
724     * @dev Integer division of two numbers, truncating the quotient.
725     */
726     function div(uint256 a, uint256 b) internal pure returns (uint256) {
727         // assert(b > 0); // Solidity automatically throws when dividing by 0
728         uint256 c = a / b;
729         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
730         return c;
731     }
732 
733     /**
734     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
735     */
736     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
737         assert(b <= a);
738         return a - b;
739     }
740 
741     /**
742     * @dev Adds two numbers, throws on overflow.
743     */
744     function add(uint256 a, uint256 b) internal pure returns (uint256) {
745         uint256 c = a + b;
746         assert(c >= a);
747         return c;
748     }
749 }