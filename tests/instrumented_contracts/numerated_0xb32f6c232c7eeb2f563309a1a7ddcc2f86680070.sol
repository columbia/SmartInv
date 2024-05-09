1 pragma solidity ^0.4.20;
2 
3 /*
4 * ==================================== *
5 *                                      *
6 * ========== https://powx.co ========= *
7 *                                      *
8 * ==================================== *
9 * -> What?
10 * The original autonomous pyramid, improved:
11 * [x] More stable than ever, having withstood severe testnet abuse and attack attempts from our community!.
12 * [x] Audited, tested, and approved by known community security specialists such as tocsick and Arc.
13 * [X] New functionality; you can now perform partial sell orders. If you succumb to weak hands, you don't have to dump all of your bags!
14 * [x] New functionality; you can now transfer tokens between wallets. Trading is now possible from within the contract!
15 * [x] New Feature: PoS Masternodes! The first implementation of Ethereum Staking in the world! Vitalik is mad.
16 * [x] Masternodes: Holding 100 PoWX Tokens allow you to generate a Masternode link, Masternode links are used as unique entry points to the contract!
17 * [x] Masternodes: All players who enter the contract through your Masternode have 30% of their 15% dividends fee rerouted from the master-node, to the node-master!
18 *
19 * The dev team consists of seasoned, professional developers and has been audited by veteran solidity experts.
20 * Additionally, two independent testnet iterations have been used by hundreds of people; not a single point of failure was found.
21 *
22 */
23 
24 contract PowX {
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
51         require(administrators[keccak256(_customerAddress)]);
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
84     }
85     
86     
87     /*==============================
88     =            EVENTS            =
89     ==============================*/
90     event onTokenPurchase(
91         address indexed customerAddress,
92         uint256 incomingEthereum,
93         uint256 tokensMinted,
94         address indexed referredBy
95     );
96     
97     event onTokenSell(
98         address indexed customerAddress,
99         uint256 tokensBurned,
100         uint256 ethereumEarned
101     );
102     
103     event onReinvestment(
104         address indexed customerAddress,
105         uint256 ethereumReinvested,
106         uint256 tokensMinted
107     );
108     
109     event onWithdraw(
110         address indexed customerAddress,
111         uint256 ethereumWithdrawn
112     );
113     
114     // ERC20
115     event Transfer(
116         address indexed from,
117         address indexed to,
118         uint256 tokens
119     );
120     
121     
122     /*=====================================
123     =            CONFIGURABLES            =
124     =====================================*/
125     string public name = "PowX";
126     string public symbol = "PWX";
127     uint8 constant public decimals = 18;
128     uint8 constant internal dividendFee_ = 15;
129     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
130     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
131     uint256 constant internal magnitude = 2**64;
132     
133     // proof of stake (defaults at 100 tokens)
134     uint256 public stakingRequirement = 100e18;
135     
136     // ambassador program
137     mapping(address => bool) internal ambassadors_;
138     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
139     uint256 constant internal ambassadorQuota_ = 20 ether;
140     
141     
142     
143    /*================================
144     =            DATASETS            =
145     ================================*/
146     // amount of shares for each address (scaled number)
147     mapping(address => uint256) internal tokenBalanceLedger_;
148     mapping(address => uint256) internal referralBalance_;
149     mapping(address => int256) internal payoutsTo_;
150     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
151     uint256 internal tokenSupply_ = 0;
152     uint256 internal profitPerShare_;
153     
154     // administrator list (see above on what they can do)
155     mapping(bytes32 => bool) public administrators;
156     
157     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
158     bool public onlyAmbassadors = true;
159     
160 
161 
162     /*=======================================
163     =            PUBLIC FUNCTIONS            =
164     =======================================*/
165     /*
166     * -- APPLICATION ENTRY POINTS --  
167     */
168     function PowX()
169         public
170     {
171         // add administrators here
172         administrators[keccak256(msg.sender)] = true;
173         
174         // add the ambassadors here.
175         ambassadors_[msg.sender] = true;
176     }
177     
178     /**
179      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
180      */
181     function buy(address _referredBy)
182         public
183         payable
184         returns(uint256)
185     {
186         purchaseTokens(msg.value, _referredBy);
187     }
188     
189     /**
190      * Fallback function to handle ethereum that was send straight to the contract
191      * Unfortunately we cannot use a referral address this way.
192      */
193     function()
194         payable
195         public
196     {
197         purchaseTokens(msg.value, 0x0);
198     }
199     
200     /**
201      * Converts all of caller's dividends to tokens.
202      */
203     function reinvest()
204         onlyStronghands()
205         public
206     {
207         // fetch dividends
208         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
209         
210         // pay out the dividends virtually
211         address _customerAddress = msg.sender;
212         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
213         
214         // retrieve ref. bonus
215         _dividends += referralBalance_[_customerAddress];
216         referralBalance_[_customerAddress] = 0;
217         
218         // dispatch a buy order with the virtualized "withdrawn dividends"
219         uint256 _tokens = purchaseTokens(_dividends, 0x0);
220         
221         // fire event
222         onReinvestment(_customerAddress, _dividends, _tokens);
223     }
224     
225     /**
226      * Alias of sell() and withdraw().
227      */
228     function exit()
229         public
230     {
231         // get token count for caller & sell them all
232         address _customerAddress = msg.sender;
233         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
234         if(_tokens > 0) sell(_tokens);
235         
236         // lambo delivery service
237         withdraw();
238     }
239 
240     /**
241      * Withdraws all of the callers earnings.
242      */
243     function withdraw()
244         onlyStronghands()
245         public
246     {
247         // setup data
248         address _customerAddress = msg.sender;
249         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
250         
251         // update dividend tracker
252         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
253         
254         // add ref. bonus
255         _dividends += referralBalance_[_customerAddress];
256         referralBalance_[_customerAddress] = 0;
257         
258         // lambo delivery service
259         _customerAddress.transfer(_dividends);
260         
261         // fire event
262         onWithdraw(_customerAddress, _dividends);
263     }
264     
265     /**
266      * Liquifies tokens to ethereum.
267      */
268     function sell(uint256 _amountOfTokens)
269         onlyBagholders()
270         public
271     {
272         // setup data
273         address _customerAddress = msg.sender;
274         // russian hackers BTFO
275         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
276         uint256 _tokens = _amountOfTokens;
277         uint256 _ethereum = tokensToEthereum_(_tokens);
278         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
279         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
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
296         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
297     }
298     
299     /**
300      * Transfer tokens from the caller to a new holder.
301      * Remember, there's a 15% fee here as well.
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
312         // also disables transfers until ambassador phase is over
313         // ( we dont want whale premines )
314         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
315         
316         // withdraw all outstanding dividends first
317         if(myDividends(true) > 0) withdraw();
318         
319         // liquify 15% of the tokens that are transfered
320         // these are dispersed to shareholders
321         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
322         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
323         uint256 _dividends = tokensToEthereum_(_tokenFee);
324   
325         // burn the fee tokens
326         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
327 
328         // exchange tokens
329         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
330         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
331         
332         // update dividend trackers
333         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
334         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
335         
336         // disperse dividends among holders
337         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
338         
339         // fire event
340         Transfer(_customerAddress, _toAddress, _taxedTokens);
341         
342         // ERC20
343         return true;
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
360     function setAdministrator(bytes32 _identifier, bool _status)
361         onlyAdministrator()
362         public
363     {
364         administrators[_identifier] = _status;
365     }
366     
367     /**
368      * Set Ambassadors
369      */
370     function setAmbassadors(address ambassador, bool _status)
371         onlyAdministrator()
372         public
373     {
374         ambassadors_[ambassador] = _status;
375     }
376     
377     /**
378      * Precautionary measures in case we need to adjust the masternode rate.
379      */
380     function setStakingRequirement(uint256 _amountOfTokens)
381         onlyAdministrator()
382         public
383     {
384         stakingRequirement = _amountOfTokens;
385     }
386     
387     /**
388      * If we want to rebrand, we can.
389      */
390     function setName(string _name)
391         onlyAdministrator()
392         public
393     {
394         name = _name;
395     }
396     
397     /**
398      * If we want to rebrand, we can.
399      */
400     function setSymbol(string _symbol)
401         onlyAdministrator()
402         public
403     {
404         symbol = _symbol;
405     }
406 
407     /*----------  HELPERS AND CALCULATORS  ----------*/
408     /**
409      * Method to view the current Ethereum stored in the contract
410      * Example: totalEthereumBalance()
411      */
412     function totalEthereumBalance()
413         public
414         view
415         returns(uint)
416     {
417         return this.balance;
418     }
419     
420     /**
421      * Retrieve the total token supply.
422      */
423     function totalSupply()
424         public
425         view
426         returns(uint256)
427     {
428         return tokenSupply_;
429     }
430     
431     /**
432      * Retrieve the tokens owned by the caller.
433      */
434     function myTokens()
435         public
436         view
437         returns(uint256)
438     {
439         address _customerAddress = msg.sender;
440         return balanceOf(_customerAddress);
441     }
442     
443     /**
444      * Retrieve the dividends owned by the caller.
445      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
446      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
447      * But in the internal calculations, we want them separate. 
448      */ 
449     function myDividends(bool _includeReferralBonus) 
450         public 
451         view 
452         returns(uint256)
453     {
454         address _customerAddress = msg.sender;
455         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
456     }
457     
458     /**
459      * Retrieve the token balance of any single address.
460      */
461     function balanceOf(address _customerAddress)
462         view
463         public
464         returns(uint256)
465     {
466         return tokenBalanceLedger_[_customerAddress];
467     }
468     
469     /**
470      * Retrieve the dividend balance of any single address.
471      */
472     function dividendsOf(address _customerAddress)
473         view
474         public
475         returns(uint256)
476     {
477         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
478     }
479     
480     /**
481      * Return the buy price of 1 individual token.
482      */
483     function sellPrice() 
484         public 
485         view 
486         returns(uint256)
487     {
488         // our calculation relies on the token supply, so we need supply. Doh.
489         if(tokenSupply_ == 0){
490             return tokenPriceInitial_ - tokenPriceIncremental_;
491         } else {
492             uint256 _ethereum = tokensToEthereum_(1e18);
493             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
494             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
495             return _taxedEthereum;
496         }
497     }
498     
499     /**
500      * Return the sell price of 1 individual token.
501      */
502     function buyPrice() 
503         public 
504         view 
505         returns(uint256)
506     {
507         // our calculation relies on the token supply, so we need supply. Doh.
508         if(tokenSupply_ == 0){
509             return tokenPriceInitial_ + tokenPriceIncremental_;
510         } else {
511             uint256 _ethereum = tokensToEthereum_(1e18);
512             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
513             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
514             return _taxedEthereum;
515         }
516     }
517     
518     /**
519      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
520      */
521     function calculateTokensReceived(uint256 _ethereumToSpend) 
522         public 
523         view 
524         returns(uint256)
525     {
526         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
527         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
528         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
529         
530         return _amountOfTokens;
531     }
532     
533     /**
534      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
535      */
536     function calculateEthereumReceived(uint256 _tokensToSell) 
537         public 
538         view 
539         returns(uint256)
540     {
541         require(_tokensToSell <= tokenSupply_);
542         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
543         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
544         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
545         return _taxedEthereum;
546     }
547     
548     
549     /*==========================================
550     =            INTERNAL FUNCTIONS            =
551     ==========================================*/
552     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
553         antiEarlyWhale(_incomingEthereum)
554         internal
555         returns(uint256)
556     {
557         // data setup
558         address _customerAddress = msg.sender;
559         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
560         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
561         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
562         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
563         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
564         uint256 _fee = _dividends * magnitude;
565  
566         // no point in continuing execution if OP is a poorfag russian hacker
567         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
568         // (or hackers)
569         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
570         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
571         
572         // is the user referred by a masternode?
573         if(
574             // is this a referred purchase?
575             _referredBy != 0x0000000000000000000000000000000000000000 &&
576 
577             // no cheating!
578             _referredBy != _customerAddress &&
579             
580             // does the referrer have at least X whole tokens?
581             // i.e is the referrer a godly chad masternode
582             tokenBalanceLedger_[_referredBy] >= stakingRequirement
583         ){
584             // wealth redistribution
585             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
586         } else {
587             // no ref purchase
588             // add the referral bonus back to the global dividends cake
589             _dividends = SafeMath.add(_dividends, _referralBonus);
590             _fee = _dividends * magnitude;
591         }
592         
593         // we can't give people infinite ethereum
594         if(tokenSupply_ > 0){
595             
596             // add tokens to the pool
597             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
598  
599             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
600             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
601             
602             // calculate the amount of tokens the customer receives over his purchase 
603             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
604         
605         } else {
606             // add tokens to the pool
607             tokenSupply_ = _amountOfTokens;
608         }
609         
610         // update circulating supply & the ledger address for the customer
611         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
612         
613         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
614         //really i know you think you do but you don't
615         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
616         payoutsTo_[_customerAddress] += _updatedPayouts;
617         
618         // fire event
619         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
620         
621         return _amountOfTokens;
622     }
623 
624     /**
625      * Calculate Token price based on an amount of incoming ethereum
626      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
627      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
628      */
629     function ethereumToTokens_(uint256 _ethereum)
630         internal
631         view
632         returns(uint256)
633     {
634         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
635         uint256 _tokensReceived = 
636          (
637             (
638                 // underflow attempts BTFO
639                 SafeMath.sub(
640                     (sqrt
641                         (
642                             (_tokenPriceInitial**2)
643                             +
644                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
645                             +
646                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
647                             +
648                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
649                         )
650                     ), _tokenPriceInitial
651                 )
652             )/(tokenPriceIncremental_)
653         )-(tokenSupply_)
654         ;
655   
656         return _tokensReceived;
657     }
658     
659     /**
660      * Calculate token sell value.
661      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
662      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
663      */
664      function tokensToEthereum_(uint256 _tokens)
665         internal
666         view
667         returns(uint256)
668     {
669 
670         uint256 tokens_ = (_tokens + 1e18);
671         uint256 _tokenSupply = (tokenSupply_ + 1e18);
672         uint256 _etherReceived =
673         (
674             // underflow attempts BTFO
675             SafeMath.sub(
676                 (
677                     (
678                         (
679                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
680                         )-tokenPriceIncremental_
681                     )*(tokens_ - 1e18)
682                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
683             )
684         /1e18);
685         return _etherReceived;
686     }
687     
688     
689     //This is where all your gas goes, sorry
690     //Not sorry, you probably only paid 1 gwei
691     function sqrt(uint x) internal pure returns (uint y) {
692         uint z = (x + 1) / 2;
693         y = x;
694         while (z < y) {
695             y = z;
696             z = (x / z + z) / 2;
697         }
698     }
699 }
700 
701 /**
702  * @title SafeMath
703  * @dev Math operations with safety checks that throw on error
704  */
705 library SafeMath {
706 
707     /**
708     * @dev Multiplies two numbers, throws on overflow.
709     */
710     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
711         if (a == 0) {
712             return 0;
713         }
714         uint256 c = a * b;
715         assert(c / a == b);
716         return c;
717     }
718 
719     /**
720     * @dev Integer division of two numbers, truncating the quotient.
721     */
722     function div(uint256 a, uint256 b) internal pure returns (uint256) {
723         // assert(b > 0); // Solidity automatically throws when dividing by 0
724         uint256 c = a / b;
725         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
726         return c;
727     }
728 
729     /**
730     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
731     */
732     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
733         assert(b <= a);
734         return a - b;
735     }
736 
737     /**
738     * @dev Adds two numbers, throws on overflow.
739     */
740     function add(uint256 a, uint256 b) internal pure returns (uint256) {
741         uint256 c = a + b;
742         assert(c >= a);
743         return c;
744     }
745 }