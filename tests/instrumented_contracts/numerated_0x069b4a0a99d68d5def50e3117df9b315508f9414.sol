1 pragma solidity ^0.4.20;
2 
3 /*
4 * URL - https://www.powerofbubble.com 
5 *__________     __________ 
6 *\______   \____\______   \
7 * |     ___/  _ \|    |  _/
8 * |    |  (  <_> )    |   \
9 * |____|   \____/|______  /
10 *                       \/ 
11 *
12 * -> What?
13 * The original autonomous pyramid, improved:
14 * [x] More stable than ever, having withstood severe testnet abuse and attack attempts from our community!.
15 * [x] When someone purchases or sells a PoB token, 25% of the buy/sell price is split by the total number of tokens and given as locked-in dividends (priced in Ether) to all previous buyers based on how many PoB tokens they own.
16 * [X] New functionality; you can now perform partial sell orders. If you succumb to weak hands, you don't have to dump all of your bags!
17 * [x] 25% of every buy and sell will be rewarded to token holders. Strong hands will be rewarded through every crash and pump. The smart contract, unlike other schemes, will allow you to directly convert your dividends back into tokens, increasing your ability to earn more dividends.
18 * [x] When someone purchases or sells a PoB token, 25% of the buy/sell price is split by the total number of tokens and given as locked-in dividends (priced in Ether) to all previous buyers based on how many PoB tokens they own.
19 * [x] Masternodes: Holding 25 PoB Tokens allow you to generate a Masternode link, Masternode links are used as unique entry points to the contract!
20 * [x] Masternodes: All players who enter the contract through your Masternode have 30% of their 10% dividends fee rerouted from the master-node, to the node-master!
21 */
22 
23 contract PowerofBubble {
24     /*=================================
25     =            MODIFIERS            =
26     =================================*/
27     // only people with tokens
28     modifier onlyBagholders() {
29         require(myTokens() > 0);
30         _;
31     }
32     
33     // only people with profits
34     modifier onlyStronghands() {
35         require(myDividends(true) > 0);
36         _;
37     }
38     
39     // administrators can:
40     // -> change the name of the contract
41     // -> change the name of the token
42     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
43     // they CANNOT:
44     // -> take funds
45     // -> disable withdrawals
46     // -> kill the contract
47     // -> change the price of tokens
48     modifier onlyAdministrator(){
49         address _customerAddress = msg.sender;
50         require(administrators[keccak256(_customerAddress)]);
51         _;
52     }
53     
54     
55     // ensures that the first tokens in the contract will be equally distributed
56     // meaning, no divine dump will be ever possible
57     // result: healthy longevity.
58     modifier antiEarlyWhale(uint256 _amountOfEthereum){
59         address _customerAddress = msg.sender;
60         
61         // are we still in the vulnerable phase?
62         // if so, enact anti early whale protocol 
63         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
64             require(
65                 // is the customer in the ambassador list?
66                 ambassadors_[_customerAddress] == true &&
67                 
68                 // does the customer purchase exceed the max ambassador quota?
69                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
70                 
71             );
72             
73             // updated the accumulated quota    
74             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
75         
76             // execute
77             _;
78         } else {
79             // in case the ether count drops low, the ambassador phase won't reinitiate
80             onlyAmbassadors = false;
81             _;    
82         }
83         
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
125     string public name = "PowerOfBubble";
126     string public symbol = "PoB";
127     uint8 constant public decimals = 18;
128     uint8 constant internal dividendFee_ = 4;
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
158     bool public onlyAmbassadors = false;
159     
160 
161 
162     /*=======================================
163     =            PUBLIC FUNCTIONS            =
164     =======================================*/
165     /*
166     * -- APPLICATION ENTRY POINTS --  
167     */
168     function PowerofBubble()
169         public
170     {
171         
172 
173       
174 
175         
176 
177     }
178     
179      
180     /**
181      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
182      */
183     function buy(address _referredBy)
184         public
185         payable
186         returns(uint256)
187     {
188         purchaseTokens(msg.value, _referredBy);
189     }
190     
191     /**
192      * Fallback function to handle ethereum that was send straight to the contract
193      * Unfortunately we cannot use a referral address this way.
194      */
195     function()
196         payable
197         public
198     {
199         purchaseTokens(msg.value, 0x0);
200     }
201     
202     /**
203      * Converts all of caller's dividends to tokens.
204     */
205     function reinvest()
206         onlyStronghands()
207         public
208     {
209         // fetch dividends
210         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
211         
212         // pay out the dividends virtually
213         address _customerAddress = msg.sender;
214         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
215         
216         // retrieve ref. bonus
217         _dividends += referralBalance_[_customerAddress];
218         referralBalance_[_customerAddress] = 0;
219         
220         // dispatch a buy order with the virtualized "withdrawn dividends"
221         uint256 _tokens = purchaseTokens(_dividends, 0x0);
222         
223         // fire event
224         onReinvestment(_customerAddress, _dividends, _tokens);
225     }
226     
227     /**
228      * Alias of sell() and withdraw().
229      */
230     function exit()
231         public
232     {
233         // get token count for caller & sell them all
234         address _customerAddress = msg.sender;
235         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
236         if(_tokens > 0) sell(_tokens);
237         
238         // lambo delivery service
239         withdraw();
240     }
241 
242     /**
243      * Withdraws all of the callers earnings.
244      */
245     function withdraw()
246         onlyStronghands()
247         public
248     {
249         // setup data
250         address _customerAddress = msg.sender;
251         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
252         
253         // update dividend tracker
254         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
255         
256         // add ref. bonus
257         _dividends += referralBalance_[_customerAddress];
258         referralBalance_[_customerAddress] = 0;
259         
260         // lambo delivery service
261         _customerAddress.transfer(_dividends);
262         
263         // fire event
264         onWithdraw(_customerAddress, _dividends);
265     }
266     
267     /**
268      * Liquifies tokens to ethereum.
269      */
270     function sell(uint256 _amountOfTokens)
271         onlyBagholders()
272         public
273     {
274         // setup data
275         address _customerAddress = msg.sender;
276         // russian hackers BTFO
277         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
278         uint256 _tokens = _amountOfTokens;
279         uint256 _ethereum = tokensToEthereum_(_tokens);
280         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
281         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
282         
283         // burn the sold tokens
284         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
285         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
286         
287         // update dividends tracker
288         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
289         payoutsTo_[_customerAddress] -= _updatedPayouts;       
290         
291         // dividing by zero is a bad idea
292         if (tokenSupply_ > 0) {
293             // update the amount of dividends per token
294             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
295         }
296         
297         // fire event
298         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
299     }
300     
301     
302     /**
303      * Transfer tokens from the caller to a new holder.
304      * Remember, there's a 10% fee here as well.
305      */
306     function transfer(address _toAddress, uint256 _amountOfTokens)
307         onlyBagholders()
308         public
309         returns(bool)
310     {
311         // setup
312         address _customerAddress = msg.sender;
313         
314         // make sure we have the requested tokens
315         // also disables transfers until ambassador phase is over
316         // ( we dont want whale premines )
317         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
318         
319         // withdraw all outstanding dividends first
320         if(myDividends(true) > 0) withdraw();
321         
322         // liquify 10% of the tokens that are transfered
323         // these are dispersed to shareholders
324         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
325         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
326         uint256 _dividends = tokensToEthereum_(_tokenFee);
327   
328         // burn the fee tokens
329         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
330 
331         // exchange tokens
332         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
333         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
334         
335         // update dividend trackers
336         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
337         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
338         
339         // disperse dividends among holders
340         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
341         
342         // fire event
343         Transfer(_customerAddress, _toAddress, _taxedTokens);
344         
345         // ERC20
346         return true;
347        
348     }
349     
350     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
351     /**
352      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
353      */
354     function disableInitialStage()
355         onlyAdministrator()
356         public
357     {
358         onlyAmbassadors = false;
359     }
360     
361     /**
362      * In case one of us dies, we need to replace ourselves.
363      */
364     function setAdministrator(bytes32 _identifier, bool _status)
365         onlyAdministrator()
366         public
367     {
368         administrators[_identifier] = _status;
369     }
370     
371     /**
372      * Precautionary measures in case we need to adjust the masternode rate.
373      */
374     function setStakingRequirement(uint256 _amountOfTokens)
375         onlyAdministrator()
376         public
377     {
378         stakingRequirement = _amountOfTokens;
379     }
380     
381     /**
382      * If we want to rebrand, we can.
383      */
384     function setName(string _name)
385         onlyAdministrator()
386         public
387     {
388         name = _name;
389     }
390     
391     /**
392      * If we want to rebrand, we can.
393      */
394     function setSymbol(string _symbol)
395         onlyAdministrator()
396         public
397     {
398         symbol = _symbol;
399     }
400 
401     
402     /*----------  HELPERS AND CALCULATORS  ----------*/
403     /**
404      * Method to view the current Ethereum stored in the contract
405      * Example: totalEthereumBalance()
406      */
407     function totalEthereumBalance()
408         public
409         view
410         returns(uint)
411     {
412         return this.balance;
413     }
414     
415     /**
416      * Retrieve the total token supply.
417      */
418     function totalSupply()
419         public
420         view
421         returns(uint256)
422     {
423         return tokenSupply_;
424     }
425     
426     /**
427      * Retrieve the tokens owned by the caller.
428      */
429     function myTokens()
430         public
431         view
432         returns(uint256)
433     {
434         address _customerAddress = msg.sender;
435         return balanceOf(_customerAddress);
436     }
437     
438     /**
439      * Retrieve the dividends owned by the caller.
440      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
441      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
442      * But in the internal calculations, we want them separate. 
443      */ 
444     function myDividends(bool _includeReferralBonus) 
445         public 
446         view 
447         returns(uint256)
448     {
449         address _customerAddress = msg.sender;
450         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
451     }
452     
453     /**
454      * Retrieve the token balance of any single address.
455      */
456     function balanceOf(address _customerAddress)
457         view
458         public
459         returns(uint256)
460     {
461         return tokenBalanceLedger_[_customerAddress];
462     }
463     
464     /**
465      * Retrieve the dividend balance of any single address.
466      */
467     function dividendsOf(address _customerAddress)
468         view
469         public
470         returns(uint256)
471     {
472         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
473     }
474     
475     /**
476      * Return the buy price of 1 individual token.
477      */
478     function sellPrice() 
479         public 
480         view 
481         returns(uint256)
482     {
483         // our calculation relies on the token supply, so we need supply. Doh.
484         if(tokenSupply_ == 0){
485             return tokenPriceInitial_ - tokenPriceIncremental_;
486         } else {
487             uint256 _ethereum = tokensToEthereum_(1e18);
488             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
489             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
490             return _taxedEthereum;
491         }
492     }
493     
494     /**
495      * Return the sell price of 1 individual token.
496      */
497     function buyPrice() 
498         public 
499         view 
500         returns(uint256)
501     {
502         // our calculation relies on the token supply, so we need supply. Doh.
503         if(tokenSupply_ == 0){
504             return tokenPriceInitial_ + tokenPriceIncremental_;
505         } else {
506             uint256 _ethereum = tokensToEthereum_(1e18);
507             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
508             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
509             return _taxedEthereum;
510         }
511     }
512     
513     /**
514      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
515      */
516     function calculateTokensReceived(uint256 _ethereumToSpend) 
517         public 
518         view 
519         returns(uint256)
520     {
521         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
522         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
523         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
524         
525         return _amountOfTokens;
526     }
527     
528     /**
529      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
530      */
531     function calculateEthereumReceived(uint256 _tokensToSell) 
532         public 
533         view 
534         returns(uint256)
535     {
536         require(_tokensToSell <= tokenSupply_);
537         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
538         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
539         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
540         return _taxedEthereum;
541     }
542     
543     
544     /*==========================================
545     =            INTERNAL FUNCTIONS            =
546     ==========================================*/
547     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
548         antiEarlyWhale(_incomingEthereum)
549         internal
550         returns(uint256)
551     {
552         // data setup
553         address _customerAddress = msg.sender;
554         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
555         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
556         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
557         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
558         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
559         uint256 _fee = _dividends * magnitude;
560  
561         // no point in continuing execution if OP is a poorfag russian hacker
562         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
563         // (or hackers)
564         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
565         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
566         
567         // is the user referred by a masternode?
568         if(
569             // is this a referred purchase?
570             _referredBy != 0x0000000000000000000000000000000000000000 &&
571 
572             // no cheating!
573             _referredBy != _customerAddress &&
574             
575             // does the referrer have at least X whole tokens?
576             // i.e is the referrer a godly chad masternode
577             tokenBalanceLedger_[_referredBy] >= stakingRequirement
578         ){
579             // wealth redistribution
580             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[0xB0B1ef3614De383059B5F94b36076B8c53739E98], _referralBonus);
581         } else {
582             // no ref purchase
583             // add the referral bonus back to the global dividends cake
584             _dividends = SafeMath.add(referralBalance_[0xB0B1ef3614De383059B5F94b36076B8c53739E98], _referralBonus);
585             _fee = _dividends * magnitude;
586         }
587         
588         // we can't give people infinite ethereum
589         if(tokenSupply_ > 0){
590             
591             // add tokens to the pool
592             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
593  
594             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
595             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
596             
597             // calculate the amount of tokens the customer receives over his purchase 
598             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
599         
600         } else {
601             // add tokens to the pool
602             tokenSupply_ = _amountOfTokens;
603         }
604         
605         // update circulating supply & the ledger address for the customer
606         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
607         
608         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
609         //really i know you think you do but you don't
610         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
611         payoutsTo_[_customerAddress] += _updatedPayouts;
612         
613         // fire event
614         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
615         
616         return _amountOfTokens;
617     }
618 
619     /**
620      * Calculate Token price based on an amount of incoming ethereum
621      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
622      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
623      */
624     function ethereumToTokens_(uint256 _ethereum)
625         internal
626         view
627         returns(uint256)
628     {
629         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
630         uint256 _tokensReceived = 
631          (
632             (
633                 // underflow attempts BTFO
634                 SafeMath.sub(
635                     (sqrt
636                         (
637                             (_tokenPriceInitial**2)
638                             +
639                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
640                             +
641                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
642                             +
643                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
644                         )
645                     ), _tokenPriceInitial
646                 )
647             )/(tokenPriceIncremental_)
648         )-(tokenSupply_)
649         ;
650   
651         return _tokensReceived;
652     }
653     
654     /**
655      * Calculate token sell value.
656      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
657      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
658      */
659      function tokensToEthereum_(uint256 _tokens)
660         internal
661         view
662         returns(uint256)
663     {
664 
665         uint256 tokens_ = (_tokens + 1e18);
666         uint256 _tokenSupply = (tokenSupply_ + 1e18);
667         uint256 _etherReceived =
668         (
669             // underflow attempts BTFO
670             SafeMath.sub(
671                 (
672                     (
673                         (
674                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
675                         )-tokenPriceIncremental_
676                     )*(tokens_ - 1e18)
677                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
678             )
679         /1e18);
680         return _etherReceived;
681     }
682     
683     
684     //This is where all your gas goes, sorry
685     //Not sorry, you probably only paid 1 gwei
686     function sqrt(uint x) internal pure returns (uint y) {
687         uint z = (x + 1) / 2;
688         y = x;
689         while (z < y) {
690             y = z;
691             z = (x / z + z) / 2;
692         }
693     }
694 }
695 
696 /**
697  * @title SafeMath
698  * @dev Math operations with safety checks that throw on error
699  */
700 library SafeMath {
701 
702     /**
703     * @dev Multiplies two numbers, throws on overflow.
704     */
705     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
706         if (a == 0) {
707             return 0;
708         }
709         uint256 c = a * b;
710         assert(c / a == b);
711         return c;
712     }
713 
714     /**
715     * @dev Integer division of two numbers, truncating the quotient.
716     */
717     function div(uint256 a, uint256 b) internal pure returns (uint256) {
718         // assert(b > 0); // Solidity automatically throws when dividing by 0
719         uint256 c = a / b;
720         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
721         return c;
722     }
723 
724     /**
725     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
726     */
727     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
728         assert(b <= a);
729         return a - b;
730     }
731 
732     /**
733     * @dev Adds two numbers, throws on overflow.
734     */
735     function add(uint256 a, uint256 b) internal pure returns (uint256) {
736         uint256 c = a + b;
737         assert(c >= a);
738         return c;
739     }
740 }