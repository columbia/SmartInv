1 pragma solidity ^0.4.20;
2 
3 /*
4 * -> What?
5 * The original autonomous pyramid, improved:
6 * [x] More stable than ever, having withstood severe testnet abuse and attack attempts from our community!.
7 * [x] Audited, tested, and approved by known community security specialists such as tocsick and Arc.
8 * [X] New functionality; you can now perform partial sell orders. If you succumb to weak hands, you don't have to dump all of your bags!
9 * [x] New functionality; you can now transfer tokens between wallets. Trading is now possible from within the contract!
10 * [x] New Feature: PoS Masternodes! The first implementation of Ethereum Staking in the world! Vitalik is mad.
11 * [x] Masternodes: Holding 100 SmartHODL Tokens allow you to generate a Masternode link, Masternode links are used as unique entry points to the contract!
12 * [x] Masternodes: All players who enter the contract through your Masternode have 30% of their 10% dividends fee rerouted from the master-node, to the node-master!
13 *
14 * 
15 * -> Credits
16 * - powh3d
17 *
18 * -> Who has audited & approved the projected:
19 * - Arc
20 * - tocisck
21 * - sumpunk
22 */
23 
24 contract Hourglass {
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
126     string public name = "SmartHODL";
127     string public symbol = "SHL";
128     uint8 constant public decimals = 18;
129     uint8 constant internal dividendFee_ = 15;
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
156     mapping(bytes32 => bool) public administrators;
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
169     function Hourglass()
170         public
171     {
172         // add administrators here
173         //administrators[0xdd8bb99b13fe33e1c32254dfb8fff3e71193f6b730a89dd33bfe5dedc6d83002] = true;
174         administrators[0x936f87cf7b10883278c7c8359ed359fed103a30c1e2f6dc9c6633ebdb59da74f] = true;
175 
176         
177         // add the ambassadors here.
178         ambassadors_[0x9512b4465BeA1939ec9D5cb1D5F3D7D4D421fd34] = true;
179         
180         
181 
182     }
183     
184      
185     /**
186      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
187      */
188     function buy(address _referredBy)
189         public
190         payable
191         returns(uint256)
192     {
193         purchaseTokens(msg.value, _referredBy);
194     }
195     
196     /**
197      * Fallback function to handle ethereum that was send straight to the contract
198      * Unfortunately we cannot use a referral address this way.
199      */
200     function()
201         payable
202         public
203     {
204         purchaseTokens(msg.value, 0x0);
205     }
206     
207     /**
208      * Converts all of caller's dividends to tokens.
209      */
210     function reinvest()
211         onlyStronghands()
212         public
213     {
214         // fetch dividends
215         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
216         
217         // pay out the dividends virtually
218         address _customerAddress = msg.sender;
219         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
220         
221         // retrieve ref. bonus
222         _dividends += referralBalance_[_customerAddress];
223         referralBalance_[_customerAddress] = 0;
224         
225         // dispatch a buy order with the virtualized "withdrawn dividends"
226         uint256 _tokens = purchaseTokens(_dividends, 0x0);
227         
228         // fire event
229         onReinvestment(_customerAddress, _dividends, _tokens);
230     }
231     
232     /**
233      * Alias of sell() and withdraw().
234      */
235     function exit()
236         public
237     {
238         // get token count for caller & sell them all
239         address _customerAddress = msg.sender;
240         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
241         if(_tokens > 0) sell(_tokens);
242         
243         // lambo delivery service
244         withdraw();
245     }
246 
247     /**
248      * Withdraws all of the callers earnings.
249      */
250     function withdraw()
251         onlyStronghands()
252         public
253     {
254         // setup data
255         address _customerAddress = msg.sender;
256         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
257         
258         // update dividend tracker
259         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
260         
261         // add ref. bonus
262         _dividends += referralBalance_[_customerAddress];
263         referralBalance_[_customerAddress] = 0;
264         
265         // lambo delivery service
266         _customerAddress.transfer(_dividends);
267         
268         // fire event
269         onWithdraw(_customerAddress, _dividends);
270     }
271     
272     /**
273      * Liquifies tokens to ethereum.
274      */
275     function sell(uint256 _amountOfTokens)
276         onlyBagholders()
277         public
278     {
279         // setup data
280         address _customerAddress = msg.sender;
281         // russian hackers BTFO
282         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
283         uint256 _tokens = _amountOfTokens;
284         uint256 _ethereum = tokensToEthereum_(_tokens);
285         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
286         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
287         
288         // burn the sold tokens
289         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
290         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
291         
292         // update dividends tracker
293         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
294         payoutsTo_[_customerAddress] -= _updatedPayouts;       
295         
296         // dividing by zero is a bad idea
297         if (tokenSupply_ > 0) {
298             // update the amount of dividends per token
299             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
300         }
301         
302         // fire event
303         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
304     }
305     
306     
307     /**
308      * Transfer tokens from the caller to a new holder.
309      * Remember, there's a 10% fee here as well.
310      */
311     function transfer(address _toAddress, uint256 _amountOfTokens)
312         onlyBagholders()
313         public
314         returns(bool)
315     {
316         // setup
317         address _customerAddress = msg.sender;
318         
319         // make sure we have the requested tokens
320         // also disables transfers until ambassador phase is over
321         // ( we dont want whale premines )
322         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
323         
324         // withdraw all outstanding dividends first
325         if(myDividends(true) > 0) withdraw();
326         
327         // liquify 10% of the tokens that are transfered
328         // these are dispersed to shareholders
329         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
330         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
331         uint256 _dividends = tokensToEthereum_(_tokenFee);
332   
333         // burn the fee tokens
334         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
335 
336         // exchange tokens
337         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
338         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
339         
340         // update dividend trackers
341         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
342         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
343         
344         // disperse dividends among holders
345         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
346         
347         // fire event
348         Transfer(_customerAddress, _toAddress, _taxedTokens);
349         
350         // ERC20
351         return true;
352        
353     }
354     
355     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
356     /**
357      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
358      */
359     function disableInitialStage()
360         onlyAdministrator()
361         public
362     {
363         onlyAmbassadors = false;
364     }
365     
366     /**
367      * In case one of us dies, we need to replace ourselves.
368      */
369     function setAdministrator(bytes32 _identifier, bool _status)
370         onlyAdministrator()
371         public
372     {
373         administrators[_identifier] = _status;
374     }
375     
376     /**
377      * Precautionary measures in case we need to adjust the masternode rate.
378      */
379     function setStakingRequirement(uint256 _amountOfTokens)
380         onlyAdministrator()
381         public
382     {
383         stakingRequirement = _amountOfTokens;
384     }
385     
386     /**
387      * If we want to rebrand, we can.
388      */
389     function setName(string _name)
390         onlyAdministrator()
391         public
392     {
393         name = _name;
394     }
395     
396     /**
397      * If we want to rebrand, we can.
398      */
399     function setSymbol(string _symbol)
400         onlyAdministrator()
401         public
402     {
403         symbol = _symbol;
404     }
405 
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
493             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
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