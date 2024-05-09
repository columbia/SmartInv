1 pragma solidity ^0.4.20;
2 
3 
4 contract XToken {
5     /*=================================
6     =            MODIFIERS            =
7     =================================*/
8     // only people with tokens
9     modifier onlyBagholders() {
10         require(myTokens() > 0);
11         _;
12     }
13     
14     // only people with profits
15     modifier onlyStronghands() {
16         require(myDividends(true) > 0);
17         _;
18     }
19     
20     // administrators can:
21     // -> change the name of the contract
22     // -> change the name of the token
23     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
24     // they CANNOT:
25     // -> take funds
26     // -> disable withdrawals
27     // -> kill the contract
28     // -> change the price of tokens
29     modifier onlyAdministrator(){
30         address _customerAddress = msg.sender;
31          require(administrators[(_customerAddress)]);	
32         _;
33     }
34     
35     
36     // ensures that the first tokens in the contract will be equally distributed
37     // meaning, no divine dump will be ever possible
38     // result: healthy longevity.
39     modifier antiEarlyWhale(uint256 _amountOfEthereum){
40         address _customerAddress = msg.sender;
41         
42         // are we still in the vulnerable phase?
43         // if so, enact anti early whale protocol 
44         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
45             require(
46                 // is the customer in the ambassador list?
47                 ambassadors_[_customerAddress] == true &&
48                 
49                 // does the customer purchase exceed the max ambassador quota?
50                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
51                 
52             );
53             
54             // updated the accumulated quota    
55             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
56         
57             // execute
58             _;
59         } else {
60             // in case the ether count drops low, the ambassador phase won't reinitiate
61             onlyAmbassadors = false;
62             _;    
63         }
64         
65     }
66     
67     
68     /*==============================
69     =            EVENTS            =
70     ==============================*/
71     event onTokenPurchase(
72         address indexed customerAddress,
73         uint256 incomingEthereum,
74         uint256 tokensMinted,
75         address indexed referredBy
76     );
77     
78     event onTokenSell(
79         address indexed customerAddress,
80         uint256 tokensBurned,
81         uint256 ethereumEarned
82     );
83     
84     event onReinvestment(
85         address indexed customerAddress,
86         uint256 ethereumReinvested,
87         uint256 tokensMinted
88     );
89     
90     event onWithdraw(
91         address indexed customerAddress,
92         uint256 ethereumWithdrawn
93     );
94     
95     // ERC20
96     event Transfer(
97         address indexed from,
98         address indexed to,
99         uint256 tokens
100     );
101     
102     
103     /*=====================================
104     =            CONFIGURABLES            =
105     =====================================*/
106     string public name = "X Token";
107     string public symbol = "XTK";
108     uint8 constant public decimals = 18;
109     uint8 constant internal dividendFee_ = 20;
110     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
111     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
112     uint256 constant internal magnitude = 2**64;
113     
114     // proof of stake (defaults at 100 tokens)
115     uint256 public stakingRequirement = 100e18;
116     
117     // ambassador program
118     mapping(address => bool) internal ambassadors_;
119     uint256 constant internal ambassadorMaxPurchase_ = 0.3 ether;
120     uint256 constant internal ambassadorQuota_ = 3 ether;
121     
122     
123     
124    /*================================
125     =            DATASETS            =
126     ================================*/
127     // amount of shares for each address (scaled number)
128     mapping(address => uint256) internal tokenBalanceLedger_;
129     mapping(address => uint256) internal referralBalance_;
130     mapping(address => int256) internal payoutsTo_;
131     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
132     uint256 internal tokenSupply_ = 0;
133     uint256 internal profitPerShare_;
134     
135     // administrator list (see above on what they can do)
136     mapping(address => bool) public administrators;
137     
138     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
139     bool public onlyAmbassadors = true;
140     
141 
142 
143     /*=======================================
144     =            PUBLIC FUNCTIONS            =
145     =======================================*/
146     /*
147     * -- APPLICATION ENTRY POINTS --  
148     */
149     function XToken()
150         public
151     {
152         // add administrators here
153          administrators[msg.sender] = true;
154         
155         // add the ambassadors here.
156         // 
157        ambassadors_[0xEc31176d4df0509115abC8065A8a3F8275aafF2b] = true;
158        // 
159        ambassadors_[0xd5fa3017a6af76b31eb093dfa527ee1d939f05ea] = true;
160        // 
161        ambassadors_[0x6629c7199ecc6764383dfb98b229ac8c540fc76f] = true;
162         
163         // 
164         ambassadors_[0x2De78Fbc7e1D1c93aa5091aE28dd836CC71e8d4c] = true;
165         
166         // 
167         ambassadors_[0x41e8cee8068eb7344d4c61304db643e68b1b7155] = true;
168         
169         // 
170         ambassadors_[0xcec269b2c42931f43e3e08c0f20faa6e6a9cb2ff] = true;
171         
172         // 
173         ambassadors_[0xee54d208f62368b4effe176cb548a317dcae963f] = true;
174         
175         // 
176         ambassadors_[0x008ca4f1ba79d1a265617c6206d7884ee8108a78] = true;
177         
178         // 
179         ambassadors_[0x2BC9aAe6d3Ac1396740CF4854AD8121940eA98c0] = true;
180         
181         
182 
183     }
184     
185      
186     /**
187      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
188      */
189     function buy(address _referredBy)
190         public
191         payable
192         returns(uint256)
193     {
194         purchaseTokens(msg.value, _referredBy);
195     }
196     
197     /**
198      * Fallback function to handle ethereum that was send straight to the contract
199      * Unfortunately we cannot use a referral address this way.
200      */
201     function()
202         payable
203         public
204     {
205         purchaseTokens(msg.value, 0x0);
206     }
207     
208     /**
209      * Converts all of caller's dividends to tokens.
210      */
211     function reinvest()
212         onlyStronghands()
213         public
214     {
215         // fetch dividends
216         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
217         
218         // pay out the dividends virtually
219         address _customerAddress = msg.sender;
220         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
221         
222         // retrieve ref. bonus
223         _dividends += referralBalance_[_customerAddress];
224         referralBalance_[_customerAddress] = 0;
225         
226         // dispatch a buy order with the virtualized "withdrawn dividends"
227         uint256 _tokens = purchaseTokens(_dividends, 0x0);
228         
229         // fire event
230         onReinvestment(_customerAddress, _dividends, _tokens);
231     }
232     
233     /**
234      * Alias of sell() and withdraw().
235      */
236     function exit()
237         public
238     {
239         // get token count for caller & sell them all
240         address _customerAddress = msg.sender;
241         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
242         if(_tokens > 0) sell(_tokens);
243         
244         // lambo delivery service
245         withdraw();
246     }
247 
248     /**
249      * Withdraws all of the callers earnings.
250      */
251     function withdraw()
252         onlyStronghands()
253         public
254     {
255         // setup data
256         address _customerAddress = msg.sender;
257         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
258         
259         // update dividend tracker
260         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
261         
262         // add ref. bonus
263         _dividends += referralBalance_[_customerAddress];
264         referralBalance_[_customerAddress] = 0;
265         
266         // lambo delivery service
267         _customerAddress.transfer(_dividends);
268         
269         // fire event
270         onWithdraw(_customerAddress, _dividends);
271     }
272     
273     /**
274      * Liquifies tokens to ethereum.
275      */
276     function sell(uint256 _amountOfTokens)
277         onlyBagholders()
278         public
279     {
280         // setup data
281         address _customerAddress = msg.sender;
282         // russian hackers BTFO
283         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
284         uint256 _tokens = _amountOfTokens;
285         uint256 _ethereum = tokensToEthereum_(_tokens);
286         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
287         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
288         
289         // burn the sold tokens
290         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
291         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
292         
293         // update dividends tracker
294         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
295         payoutsTo_[_customerAddress] -= _updatedPayouts;       
296         
297         // dividing by zero is a bad idea
298         if (tokenSupply_ > 0) {
299             // update the amount of dividends per token
300             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
301         }
302         
303         // fire event
304         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
305     }
306     
307     
308     /**
309      * Transfer tokens from the caller to a new holder.
310      * Remember, there's a 10% fee here as well.
311      */
312     function transfer(address _toAddress, uint256 _amountOfTokens)
313         onlyBagholders()
314         public
315         returns(bool)
316     {
317         // setup
318         address _customerAddress = msg.sender;
319         
320         // make sure we have the requested tokens
321         // also disables transfers until ambassador phase is over
322         // ( we dont want whale premines )
323         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
324         
325         // withdraw all outstanding dividends first
326         if(myDividends(true) > 0) withdraw();
327         
328         // liquify 10% of the tokens that are transfered
329         // these are dispersed to shareholders
330         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
331         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
332         uint256 _dividends = tokensToEthereum_(_tokenFee);
333   
334         // burn the fee tokens
335         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
336 
337         // exchange tokens
338         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
339         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
340         
341         // update dividend trackers
342         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
343         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
344         
345         // disperse dividends among holders
346         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
347         
348         // fire event
349         Transfer(_customerAddress, _toAddress, _taxedTokens);
350         
351         // ERC20
352         return true;
353        
354     }
355     
356     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
357     /**
358      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
359      */
360     function disableInitialStage()
361         onlyAdministrator()
362         public
363     {
364         onlyAmbassadors = false;
365     }
366     
367     /**
368      * In case one of us dies, we need to replace ourselves.
369      */
370     function setAdministrator(address _identifier, bool _status)
371         onlyAdministrator()
372         public
373     {
374         administrators[_identifier] = _status;
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
407     
408     /*----------  HELPERS AND CALCULATORS  ----------*/
409     /**
410      * Method to view the current Ethereum stored in the contract
411      * Example: totalEthereumBalance()
412      */
413     function totalEthereumBalance()
414         public
415         view
416         returns(uint)
417     {
418         return this.balance;
419     }
420     
421     /**
422      * Retrieve the total token supply.
423      */
424     function totalSupply()
425         public
426         view
427         returns(uint256)
428     {
429         return tokenSupply_;
430     }
431     
432     /**
433      * Retrieve the tokens owned by the caller.
434      */
435     function myTokens()
436         public
437         view
438         returns(uint256)
439     {
440         address _customerAddress = msg.sender;
441         return balanceOf(_customerAddress);
442     }
443     
444     /**
445      * Retrieve the dividends owned by the caller.
446      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
447      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
448      * But in the internal calculations, we want them separate. 
449      */ 
450     function myDividends(bool _includeReferralBonus) 
451         public 
452         view 
453         returns(uint256)
454     {
455         address _customerAddress = msg.sender;
456         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
457     }
458     
459     /**
460      * Retrieve the token balance of any single address.
461      */
462     function balanceOf(address _customerAddress)
463         view
464         public
465         returns(uint256)
466     {
467         return tokenBalanceLedger_[_customerAddress];
468     }
469     
470     /**
471      * Retrieve the dividend balance of any single address.
472      */
473     function dividendsOf(address _customerAddress)
474         view
475         public
476         returns(uint256)
477     {
478         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
479     }
480     
481     /**
482      * Return the buy price of 1 individual token.
483      */
484     function sellPrice() 
485         public 
486         view 
487         returns(uint256)
488     {
489         // our calculation relies on the token supply, so we need supply. Doh.
490         if(tokenSupply_ == 0){
491             return tokenPriceInitial_ - tokenPriceIncremental_;
492         } else {
493             uint256 _ethereum = tokensToEthereum_(1e18);
494             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
495             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
496             return _taxedEthereum;
497         }
498     }
499     
500     /**
501      * Return the sell price of 1 individual token.
502      */
503     function buyPrice() 
504         public 
505         view 
506         returns(uint256)
507     {
508         // our calculation relies on the token supply, so we need supply. Doh.
509         if(tokenSupply_ == 0){
510             return tokenPriceInitial_ + tokenPriceIncremental_;
511         } else {
512             uint256 _ethereum = tokensToEthereum_(1e18);
513             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
514             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
515             return _taxedEthereum;
516         }
517     }
518     
519     /**
520      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
521      */
522     function calculateTokensReceived(uint256 _ethereumToSpend) 
523         public 
524         view 
525         returns(uint256)
526     {
527         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
528         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
529         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
530         
531         return _amountOfTokens;
532     }
533     
534     /**
535      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
536      */
537     function calculateEthereumReceived(uint256 _tokensToSell) 
538         public 
539         view 
540         returns(uint256)
541     {
542         require(_tokensToSell <= tokenSupply_);
543         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
544         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
545         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
546         return _taxedEthereum;
547     }
548     
549     
550     /*==========================================
551     =            INTERNAL FUNCTIONS            =
552     ==========================================*/
553     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
554         antiEarlyWhale(_incomingEthereum)
555         internal
556         returns(uint256)
557     {
558         // data setup
559         address _customerAddress = msg.sender;
560         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
561         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
562         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
563         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
564         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
565         uint256 _fee = _dividends * magnitude;
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
579             _referredBy != _customerAddress &&
580             
581             // does the referrer have at least X whole tokens?
582             // i.e is the referrer a godly chad masternode
583             tokenBalanceLedger_[_referredBy] >= stakingRequirement
584         ){
585             // wealth redistribution
586             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
587         } else {
588             // no ref purchase
589             // add the referral bonus back to the global dividends cake
590             _dividends = SafeMath.add(_dividends, _referralBonus);
591             _fee = _dividends * magnitude;
592         }
593         
594         // we can't give people infinite ethereum
595         if(tokenSupply_ > 0){
596             
597             // add tokens to the pool
598             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
599  
600             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
601             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
602             
603             // calculate the amount of tokens the customer receives over his purchase 
604             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
605         
606         } else {
607             // add tokens to the pool
608             tokenSupply_ = _amountOfTokens;
609         }
610         
611         // update circulating supply & the ledger address for the customer
612         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
613         
614         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
615         //really i know you think you do but you don't
616         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
617         payoutsTo_[_customerAddress] += _updatedPayouts;
618         
619         // fire event
620         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
621         
622         return _amountOfTokens;
623     }
624 
625     /**
626      * Calculate Token price based on an amount of incoming ethereum
627      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
628      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
629      */
630     function ethereumToTokens_(uint256 _ethereum)
631         internal
632         view
633         returns(uint256)
634     {
635         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
636         uint256 _tokensReceived = 
637          (
638             (
639                 // underflow attempts BTFO
640                 SafeMath.sub(
641                     (sqrt
642                         (
643                             (_tokenPriceInitial**2)
644                             +
645                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
646                             +
647                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
648                             +
649                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
650                         )
651                     ), _tokenPriceInitial
652                 )
653             )/(tokenPriceIncremental_)
654         )-(tokenSupply_)
655         ;
656   
657         return _tokensReceived;
658     }
659     
660     /**
661      * Calculate token sell value.
662      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
663      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
664      */
665      function tokensToEthereum_(uint256 _tokens)
666         internal
667         view
668         returns(uint256)
669     {
670 
671         uint256 tokens_ = (_tokens + 1e18);
672         uint256 _tokenSupply = (tokenSupply_ + 1e18);
673         uint256 _etherReceived =
674         (
675             // underflow attempts BTFO
676             SafeMath.sub(
677                 (
678                     (
679                         (
680                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
681                         )-tokenPriceIncremental_
682                     )*(tokens_ - 1e18)
683                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
684             )
685         /1e18);
686         return _etherReceived;
687     }
688     
689     
690     //This is where all your gas goes, sorry
691     //Not sorry, you probably only paid 1 gwei
692     function sqrt(uint x) internal pure returns (uint y) {
693         uint z = (x + 1) / 2;
694         y = x;
695         while (z < y) {
696             y = z;
697             z = (x / z + z) / 2;
698         }
699     }
700 }
701 
702 /**
703  * @title SafeMath
704  * @dev Math operations with safety checks that throw on error
705  */
706 library SafeMath {
707 
708     /**
709     * @dev Multiplies two numbers, throws on overflow.
710     */
711     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
712         if (a == 0) {
713             return 0;
714         }
715         uint256 c = a * b;
716         assert(c / a == b);
717         return c;
718     }
719 
720     /**
721     * @dev Integer division of two numbers, truncating the quotient.
722     */
723     function div(uint256 a, uint256 b) internal pure returns (uint256) {
724         // assert(b > 0); // Solidity automatically throws when dividing by 0
725         uint256 c = a / b;
726         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
727         return c;
728     }
729 
730     /**
731     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
732     */
733     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
734         assert(b <= a);
735         return a - b;
736     }
737 
738     /**
739     * @dev Adds two numbers, throws on overflow.
740     */
741     function add(uint256 a, uint256 b) internal pure returns (uint256) {
742         uint256 c = a + b;
743         assert(c >= a);
744         return c;
745     }
746 }