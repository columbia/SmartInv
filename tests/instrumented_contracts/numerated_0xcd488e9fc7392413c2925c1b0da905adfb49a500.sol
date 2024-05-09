1 pragma solidity ^0.4.20;
2 
3 /*
4 
5  ____    _____   ____    __  __     
6 /\  _`\ /\  __`\/\  _`\ /\ \/\ \    
7 \ \ \L\ \ \ \/\ \ \ \L\_\ \ \/'/'   
8  \ \ ,__/\ \ \ \ \ \  _\/\ \ , <    
9   \ \ \/  \ \ \_\ \ \ \/  \ \ \\`\  
10    \ \_\   \ \_____\ \_\   \ \_\ \_\
11     \/_/    \/_____/\/_/    \/_/\/_/
12                                     
13 Proof of Fuck Kenny
14 
15 Fuck you Kenny
16 
17 */
18 
19 contract FuckYouKenny {
20     /*=================================
21     =            MODIFIERS            =
22     =================================*/
23     // only people with tokens
24     modifier onlyBagholders() {
25         require(myTokens() > 0);
26         _;
27     }
28     
29     // only people with profits
30     modifier onlyStronghands() {
31         require(myDividends(true) > 0);
32         _;
33     }
34     
35     // administrators can:
36     // -> change the name of the contract
37     // -> change the name of the token
38     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
39     // they CANNOT:
40     // -> take funds
41     // -> disable withdrawals
42     // -> kill the contract
43     // -> change the price of tokens
44     modifier onlyAdministrator(){
45         address _customerAddress = msg.sender;
46         require(administrators[keccak256(_customerAddress)]);
47         _;
48     }
49     
50     
51     // ensures that the first tokens in the contract will be equally distributed
52     // meaning, no divine dump will be ever possible
53     // result: healthy longevity.
54     modifier antiEarlyWhale(uint256 _amountOfEthereum){
55         address _customerAddress = msg.sender;
56         
57         // are we still in the vulnerable phase?
58         // if so, enact anti early whale protocol 
59         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
60             require(
61                 // is the customer in the ambassador list?
62                 ambassadors_[_customerAddress] == true &&
63                 
64                 // does the customer purchase exceed the max ambassador quota?
65                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
66                 
67             );
68             
69             // updated the accumulated quota    
70             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
71         
72             // execute
73             _;
74         } else {
75             // in case the ether count drops low, the ambassador phase won't reinitiate
76             onlyAmbassadors = false;
77             _;    
78         }
79         
80     }
81     
82     
83     /*==============================
84     =            EVENTS            =
85     ==============================*/
86     event onTokenPurchase(
87         address indexed customerAddress,
88         uint256 incomingEthereum,
89         uint256 tokensMinted,
90         address indexed referredBy
91     );
92     
93     event onTokenSell(
94         address indexed customerAddress,
95         uint256 tokensBurned,
96         uint256 ethereumEarned
97     );
98     
99     event onReinvestment(
100         address indexed customerAddress,
101         uint256 ethereumReinvested,
102         uint256 tokensMinted
103     );
104     
105     event onWithdraw(
106         address indexed customerAddress,
107         uint256 ethereumWithdrawn
108     );
109     
110     // ERC20
111     event Transfer(
112         address indexed from,
113         address indexed to,
114         uint256 tokens
115     );
116     
117     
118     /*=====================================
119     =            CONFIGURABLES            =
120     =====================================*/
121     string public name = "FuckKenny";
122     string public symbol = "FKKN";
123     uint8 constant public decimals = 18;
124     uint8 constant internal dividendFee_ = 4;
125     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
126     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
127     uint256 constant internal magnitude = 2**64;
128     
129     // proof of stake (defaults at 100 tokens)
130     uint256 public stakingRequirement = 5e18;
131     
132     // ambassador program
133     mapping(address => bool) internal ambassadors_;
134     uint256 constant internal ambassadorMaxPurchase_ = 10 ether;
135     uint256 constant internal ambassadorQuota_ = 10 ether;
136     
137     
138     
139    /*================================
140     =            DATASETS            =
141     ================================*/
142     // amount of shares for each address (scaled number)
143     mapping(address => uint256) internal tokenBalanceLedger_;
144     mapping(address => uint256) internal referralBalance_;
145     mapping(address => int256) internal payoutsTo_;
146     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
147     uint256 internal tokenSupply_ = 0;
148     uint256 internal profitPerShare_;
149     
150     // administrator list (see above on what they can do)
151     mapping(bytes32 => bool) public administrators;
152     
153     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
154     bool public onlyAmbassadors = false;
155     
156 
157 
158     /*=======================================
159     =            PUBLIC FUNCTIONS            =
160     =======================================*/
161     /*
162     * -- APPLICATION ENTRY POINTS --  
163     */
164     function CarlosMatos()
165         public
166     {
167         // add administrators here
168         administrators[0x235910f4682cfe7250004430a4ffb5ac78f5217e1f6a4bf99c937edf757c3330] = true;
169         
170         // add the ambassadors here.
171         // One lonely developer 
172         ambassadors_[0x6405C296d5728de46517609B78DA3713097163dB] = true;
173         
174         // Backup Eth address
175        
176         ambassadors_[0x15Fda64fCdbcA27a60Aa8c6ca882Aa3e1DE4Ea41] = true;
177          
178         ambassadors_[0x448D9Ae89DF160392Dd0DD5dda66952999390D50] = true;
179         
180     
181          
182          
183         
184         
185      
186 
187     }
188     
189      
190     /**
191      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
192      */
193     function buy(address _referredBy)
194         public
195         payable
196         returns(uint256)
197     {
198         purchaseTokens(msg.value, _referredBy);
199     }
200     
201     /**
202      * Fallback function to handle ethereum that was send straight to the contract
203      * Unfortunately we cannot use a referral address this way.
204      */
205     function()
206         payable
207         public
208     {
209         purchaseTokens(msg.value, 0x0);
210     }
211     
212     /**
213      * Converts all of caller's dividends to tokens.
214      */
215     function reinvest()
216         onlyStronghands()
217         public
218     {
219         // fetch dividends
220         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
221         
222         // pay out the dividends virtually
223         address _customerAddress = msg.sender;
224         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
225         
226         // retrieve ref. bonus
227         _dividends += referralBalance_[_customerAddress];
228         referralBalance_[_customerAddress] = 0;
229         
230         // dispatch a buy order with the virtualized "withdrawn dividends"
231         uint256 _tokens = purchaseTokens(_dividends, 0x0);
232         
233         // fire event
234         onReinvestment(_customerAddress, _dividends, _tokens);
235     }
236     
237     /**
238      * Alias of sell() and withdraw().
239      */
240     function exit()
241         public
242     {
243         // get token count for caller & sell them all
244         address _customerAddress = msg.sender;
245         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
246         if(_tokens > 0) sell(_tokens);
247         
248         // lambo delivery service
249         withdraw();
250     }
251 
252     /**
253      * Withdraws all of the callers earnings.
254      */
255     function withdraw()
256         onlyStronghands()
257         public
258     {
259         // setup data
260         address _customerAddress = msg.sender;
261         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
262         
263         // update dividend tracker
264         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
265         
266         // add ref. bonus
267         _dividends += referralBalance_[_customerAddress];
268         referralBalance_[_customerAddress] = 0;
269         
270         // lambo delivery service
271         _customerAddress.transfer(_dividends);
272         
273         // fire event
274         onWithdraw(_customerAddress, _dividends);
275     }
276     
277     /**
278      * Liquifies tokens to ethereum.
279      */
280     function sell(uint256 _amountOfTokens)
281         onlyBagholders()
282         public
283     {
284         // setup data
285         address _customerAddress = msg.sender;
286         // russian hackers BTFO
287         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
288         uint256 _tokens = _amountOfTokens;
289         uint256 _ethereum = tokensToEthereum_(_tokens);
290         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
291         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
292         
293         // burn the sold tokens
294         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
295         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
296         
297         // update dividends tracker
298         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
299         payoutsTo_[_customerAddress] -= _updatedPayouts;       
300         
301         // dividing by zero is a bad idea
302         if (tokenSupply_ > 0) {
303             // update the amount of dividends per token
304             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
305         }
306         
307         // fire event
308         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
309     }
310     
311     
312     /**
313      * Transfer tokens from the caller to a new holder.
314      * Remember, there's a 10% fee here as well.
315      */
316     function transfer(address _toAddress, uint256 _amountOfTokens)
317         onlyBagholders()
318         public
319         returns(bool)
320     {
321         // setup
322         address _customerAddress = msg.sender;
323         
324         // make sure we have the requested tokens
325         // also disables transfers until ambassador phase is over
326         // ( we dont want whale premines )
327         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
328         
329         // withdraw all outstanding dividends first
330         if(myDividends(true) > 0) withdraw();
331         
332         // liquify 10% of the tokens that are transfered
333         // these are dispersed to shareholders
334         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
335         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
336         uint256 _dividends = tokensToEthereum_(_tokenFee);
337   
338         // burn the fee tokens
339         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
340 
341         // exchange tokens
342         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
343         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
344         
345         // update dividend trackers
346         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
347         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
348         
349         // disperse dividends among holders
350         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
351         
352         // fire event
353         Transfer(_customerAddress, _toAddress, _taxedTokens);
354         
355         // ERC20
356         return true;
357        
358     }
359     
360     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
361     /**
362      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
363      */
364     function disableInitialStage()
365         onlyAdministrator()
366         public
367     {
368         onlyAmbassadors = false;
369     }
370     
371     /**
372      * In case one of us dies, we need to replace ourselves.
373      */
374     function setAdministrator(bytes32 _identifier, bool _status)
375         onlyAdministrator()
376         public
377     {
378         administrators[_identifier] = _status;
379     }
380     
381     /**
382      * Precautionary measures in case we need to adjust the masternode rate.
383      */
384     function setStakingRequirement(uint256 _amountOfTokens)
385         onlyAdministrator()
386         public
387     {
388         stakingRequirement = _amountOfTokens;
389     }
390     
391     /**
392      * If we want to rebrand, we can.
393      */
394     function setName(string _name)
395         onlyAdministrator()
396         public
397     {
398         name = _name;
399     }
400     
401     /**
402      * If we want to rebrand, we can.
403      */
404     function setSymbol(string _symbol)
405         onlyAdministrator()
406         public
407     {
408         symbol = _symbol;
409     }
410 
411     
412     /*----------  HELPERS AND CALCULATORS  ----------*/
413     /**
414      * Method to view the current Ethereum stored in the contract
415      * Example: totalEthereumBalance()
416      */
417     function totalEthereumBalance()
418         public
419         view
420         returns(uint)
421     {
422         return this.balance;
423     }
424     
425     /**
426      * Retrieve the total token supply.
427      */
428     function totalSupply()
429         public
430         view
431         returns(uint256)
432     {
433         return tokenSupply_;
434     }
435     
436     /**
437      * Retrieve the tokens owned by the caller.
438      */
439     function myTokens()
440         public
441         view
442         returns(uint256)
443     {
444         address _customerAddress = msg.sender;
445         return balanceOf(_customerAddress);
446     }
447     
448     /**
449      * Retrieve the dividends owned by the caller.
450      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
451      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
452      * But in the internal calculations, we want them separate. 
453      */ 
454     function myDividends(bool _includeReferralBonus) 
455         public 
456         view 
457         returns(uint256)
458     {
459         address _customerAddress = msg.sender;
460         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
461     }
462     
463     /**
464      * Retrieve the token balance of any single address.
465      */
466     function balanceOf(address _customerAddress)
467         view
468         public
469         returns(uint256)
470     {
471         return tokenBalanceLedger_[_customerAddress];
472     }
473     
474     /**
475      * Retrieve the dividend balance of any single address.
476      */
477     function dividendsOf(address _customerAddress)
478         view
479         public
480         returns(uint256)
481     {
482         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
483     }
484     
485     /**
486      * Return the buy price of 1 individual token.
487      */
488     function sellPrice() 
489         public 
490         view 
491         returns(uint256)
492     {
493         // our calculation relies on the token supply, so we need supply. Doh.
494         if(tokenSupply_ == 0){
495             return tokenPriceInitial_ - tokenPriceIncremental_;
496         } else {
497             uint256 _ethereum = tokensToEthereum_(1e18);
498             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
499             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
500             return _taxedEthereum;
501         }
502     }
503     
504     /**
505      * Return the sell price of 1 individual token.
506      */
507     function buyPrice() 
508         public 
509         view 
510         returns(uint256)
511     {
512         // our calculation relies on the token supply, so we need supply. Doh.
513         if(tokenSupply_ == 0){
514             return tokenPriceInitial_ + tokenPriceIncremental_;
515         } else {
516             uint256 _ethereum = tokensToEthereum_(1e18);
517             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
518             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
519             return _taxedEthereum;
520         }
521     }
522     
523     /**
524      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
525      */
526     function calculateTokensReceived(uint256 _ethereumToSpend) 
527         public 
528         view 
529         returns(uint256)
530     {
531         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
532         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
533         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
534         
535         return _amountOfTokens;
536     }
537     
538     /**
539      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
540      */
541     function calculateEthereumReceived(uint256 _tokensToSell) 
542         public 
543         view 
544         returns(uint256)
545     {
546         require(_tokensToSell <= tokenSupply_);
547         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
548         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
549         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
550         return _taxedEthereum;
551     }
552     
553     
554     /*==========================================
555     =            INTERNAL FUNCTIONS            =
556     ==========================================*/
557     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
558         antiEarlyWhale(_incomingEthereum)
559         internal
560         returns(uint256)
561     {
562         // data setup
563         address _customerAddress = msg.sender;
564         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
565         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
566         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
567         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
568         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
569         uint256 _fee = _dividends * magnitude;
570  
571         // no point in continuing execution if OP is a poorfag russian hacker
572         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
573         // (or hackers)
574         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
575         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
576         
577         // is the user referred by a masternode?
578         if(
579             // is this a referred purchase?
580             _referredBy != 0x0000000000000000000000000000000000000000 &&
581 
582             // no cheating!
583             _referredBy != _customerAddress &&
584             
585             // does the referrer have at least X whole tokens?
586             // i.e is the referrer a godly chad masternode
587             tokenBalanceLedger_[_referredBy] >= stakingRequirement
588         ){
589             // wealth redistribution
590             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
591         } else {
592             // no ref purchase
593             // add the referral bonus back to the global dividends cake
594             _dividends = SafeMath.add(_dividends, _referralBonus);
595             _fee = _dividends * magnitude;
596         }
597         
598         // we can't give people infinite ethereum
599         if(tokenSupply_ > 0){
600             
601             // add tokens to the pool
602             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
603  
604             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
605             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
606             
607             // calculate the amount of tokens the customer receives over his purchase 
608             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
609         
610         } else {
611             // add tokens to the pool
612             tokenSupply_ = _amountOfTokens;
613         }
614         
615         // update circulating supply & the ledger address for the customer
616         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
617         
618         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
619         //really i know you think you do but you don't
620         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
621         payoutsTo_[_customerAddress] += _updatedPayouts;
622         
623         // fire event
624         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
625         
626         return _amountOfTokens;
627     }
628 
629     /**
630      * Calculate Token price based on an amount of incoming ethereum
631      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
632      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
633      */
634     function ethereumToTokens_(uint256 _ethereum)
635         internal
636         view
637         returns(uint256)
638     {
639         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
640         uint256 _tokensReceived = 
641          (
642             (
643                 // underflow attempts BTFO
644                 SafeMath.sub(
645                     (sqrt
646                         (
647                             (_tokenPriceInitial**2)
648                             +
649                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
650                             +
651                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
652                             +
653                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
654                         )
655                     ), _tokenPriceInitial
656                 )
657             )/(tokenPriceIncremental_)
658         )-(tokenSupply_)
659         ;
660   
661         return _tokensReceived;
662     }
663     
664     /**
665      * Calculate token sell value.
666      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
667      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
668      */
669      function tokensToEthereum_(uint256 _tokens)
670         internal
671         view
672         returns(uint256)
673     {
674 
675         uint256 tokens_ = (_tokens + 1e18);
676         uint256 _tokenSupply = (tokenSupply_ + 1e18);
677         uint256 _etherReceived =
678         (
679             // underflow attempts BTFO
680             SafeMath.sub(
681                 (
682                     (
683                         (
684                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
685                         )-tokenPriceIncremental_
686                     )*(tokens_ - 1e18)
687                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
688             )
689         /1e18);
690         return _etherReceived;
691     }
692     
693     
694     //This is where all your gas goes, sorry
695     //Not sorry, you probably only paid 1 gwei
696     function sqrt(uint x) internal pure returns (uint y) {
697         uint z = (x + 1) / 2;
698         y = x;
699         while (z < y) {
700             y = z;
701             z = (x / z + z) / 2;
702         }
703     }
704 }
705 
706 /**
707  * @title SafeMath
708  * @dev Math operations with safety checks that throw on error
709  */
710 library SafeMath {
711 
712     /**
713     * @dev Multiplies two numbers, throws on overflow.
714     */
715     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
716         if (a == 0) {
717             return 0;
718         }
719         uint256 c = a * b;
720         assert(c / a == b);
721         return c;
722     }
723 
724     /**
725     * @dev Integer division of two numbers, truncating the quotient.
726     */
727     function div(uint256 a, uint256 b) internal pure returns (uint256) {
728         // assert(b > 0); // Solidity automatically throws when dividing by 0
729         uint256 c = a / b;
730         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
731         return c;
732     }
733 
734     /**
735     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
736     */
737     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
738         assert(b <= a);
739         return a - b;
740     }
741 
742     /**
743     * @dev Adds two numbers, throws on overflow.
744     */
745     function add(uint256 a, uint256 b) internal pure returns (uint256) {
746         uint256 c = a + b;
747         assert(c >= a);
748         return c;
749     }
750 }