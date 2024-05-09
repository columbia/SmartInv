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
119     uint256 constant internal ambassadorMaxPurchase_ = 3 ether;
120     uint256 constant internal ambassadorQuota_ = 20 ether;
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
158         
159         // 
160         ambassadors_[0x2De78Fbc7e1D1c93aa5091aE28dd836CC71e8d4c] = true;
161         
162         // 
163         ambassadors_[0x41e8cee8068eb7344d4c61304db643e68b1b7155] = true;
164         
165         // 
166         ambassadors_[0xcec269b2c42931f43e3e08c0f20faa6e6a9cb2ff] = true;
167         
168         // 
169         ambassadors_[0xee54d208f62368b4effe176cb548a317dcae963f] = true;
170         
171         // 
172         ambassadors_[0x008ca4f1ba79d1a265617c6206d7884ee8108a78] = true;
173         
174         // 
175         ambassadors_[0x2BC9aAe6d3Ac1396740CF4854AD8121940eA98c0] = true;
176         
177         
178 
179     }
180     
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
206      */
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
324         // liquify 10% of the tokens that are transfered
325         // these are dispersed to shareholders
326         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
327         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
328         uint256 _dividends = tokensToEthereum_(_tokenFee);
329   
330         // burn the fee tokens
331         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
332 
333         // exchange tokens
334         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
335         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
336         
337         // update dividend trackers
338         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
339         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
340         
341         // disperse dividends among holders
342         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
343         
344         // fire event
345         Transfer(_customerAddress, _toAddress, _taxedTokens);
346         
347         // ERC20
348         return true;
349        
350     }
351     
352     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
353     /**
354      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
355      */
356     function disableInitialStage()
357         onlyAdministrator()
358         public
359     {
360         onlyAmbassadors = false;
361     }
362     
363     /**
364      * In case one of us dies, we need to replace ourselves.
365      */
366     function setAdministrator(address _identifier, bool _status)
367         onlyAdministrator()
368         public
369     {
370         administrators[_identifier] = _status;
371     }
372     
373     /**
374      * Precautionary measures in case we need to adjust the masternode rate.
375      */
376     function setStakingRequirement(uint256 _amountOfTokens)
377         onlyAdministrator()
378         public
379     {
380         stakingRequirement = _amountOfTokens;
381     }
382     
383     /**
384      * If we want to rebrand, we can.
385      */
386     function setName(string _name)
387         onlyAdministrator()
388         public
389     {
390         name = _name;
391     }
392     
393     /**
394      * If we want to rebrand, we can.
395      */
396     function setSymbol(string _symbol)
397         onlyAdministrator()
398         public
399     {
400         symbol = _symbol;
401     }
402 
403     
404     /*----------  HELPERS AND CALCULATORS  ----------*/
405     /**
406      * Method to view the current Ethereum stored in the contract
407      * Example: totalEthereumBalance()
408      */
409     function totalEthereumBalance()
410         public
411         view
412         returns(uint)
413     {
414         return this.balance;
415     }
416     
417     /**
418      * Retrieve the total token supply.
419      */
420     function totalSupply()
421         public
422         view
423         returns(uint256)
424     {
425         return tokenSupply_;
426     }
427     
428     /**
429      * Retrieve the tokens owned by the caller.
430      */
431     function myTokens()
432         public
433         view
434         returns(uint256)
435     {
436         address _customerAddress = msg.sender;
437         return balanceOf(_customerAddress);
438     }
439     
440     /**
441      * Retrieve the dividends owned by the caller.
442      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
443      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
444      * But in the internal calculations, we want them separate. 
445      */ 
446     function myDividends(bool _includeReferralBonus) 
447         public 
448         view 
449         returns(uint256)
450     {
451         address _customerAddress = msg.sender;
452         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
453     }
454     
455     /**
456      * Retrieve the token balance of any single address.
457      */
458     function balanceOf(address _customerAddress)
459         view
460         public
461         returns(uint256)
462     {
463         return tokenBalanceLedger_[_customerAddress];
464     }
465     
466     /**
467      * Retrieve the dividend balance of any single address.
468      */
469     function dividendsOf(address _customerAddress)
470         view
471         public
472         returns(uint256)
473     {
474         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
475     }
476     
477     /**
478      * Return the buy price of 1 individual token.
479      */
480     function sellPrice() 
481         public 
482         view 
483         returns(uint256)
484     {
485         // our calculation relies on the token supply, so we need supply. Doh.
486         if(tokenSupply_ == 0){
487             return tokenPriceInitial_ - tokenPriceIncremental_;
488         } else {
489             uint256 _ethereum = tokensToEthereum_(1e18);
490             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
491             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
492             return _taxedEthereum;
493         }
494     }
495     
496     /**
497      * Return the sell price of 1 individual token.
498      */
499     function buyPrice() 
500         public 
501         view 
502         returns(uint256)
503     {
504         // our calculation relies on the token supply, so we need supply. Doh.
505         if(tokenSupply_ == 0){
506             return tokenPriceInitial_ + tokenPriceIncremental_;
507         } else {
508             uint256 _ethereum = tokensToEthereum_(1e18);
509             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
510             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
511             return _taxedEthereum;
512         }
513     }
514     
515     /**
516      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
517      */
518     function calculateTokensReceived(uint256 _ethereumToSpend) 
519         public 
520         view 
521         returns(uint256)
522     {
523         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
524         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
525         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
526         
527         return _amountOfTokens;
528     }
529     
530     /**
531      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
532      */
533     function calculateEthereumReceived(uint256 _tokensToSell) 
534         public 
535         view 
536         returns(uint256)
537     {
538         require(_tokensToSell <= tokenSupply_);
539         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
540         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
541         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
542         return _taxedEthereum;
543     }
544     
545     
546     /*==========================================
547     =            INTERNAL FUNCTIONS            =
548     ==========================================*/
549     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
550         antiEarlyWhale(_incomingEthereum)
551         internal
552         returns(uint256)
553     {
554         // data setup
555         address _customerAddress = msg.sender;
556         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
557         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
558         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
559         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
560         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
561         uint256 _fee = _dividends * magnitude;
562  
563         // no point in continuing execution if OP is a poorfag russian hacker
564         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
565         // (or hackers)
566         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
567         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
568         
569         // is the user referred by a masternode?
570         if(
571             // is this a referred purchase?
572             _referredBy != 0x0000000000000000000000000000000000000000 &&
573 
574             // no cheating!
575             _referredBy != _customerAddress &&
576             
577             // does the referrer have at least X whole tokens?
578             // i.e is the referrer a godly chad masternode
579             tokenBalanceLedger_[_referredBy] >= stakingRequirement
580         ){
581             // wealth redistribution
582             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
583         } else {
584             // no ref purchase
585             // add the referral bonus back to the global dividends cake
586             _dividends = SafeMath.add(_dividends, _referralBonus);
587             _fee = _dividends * magnitude;
588         }
589         
590         // we can't give people infinite ethereum
591         if(tokenSupply_ > 0){
592             
593             // add tokens to the pool
594             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
595  
596             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
597             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
598             
599             // calculate the amount of tokens the customer receives over his purchase 
600             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
601         
602         } else {
603             // add tokens to the pool
604             tokenSupply_ = _amountOfTokens;
605         }
606         
607         // update circulating supply & the ledger address for the customer
608         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
609         
610         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
611         //really i know you think you do but you don't
612         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
613         payoutsTo_[_customerAddress] += _updatedPayouts;
614         
615         // fire event
616         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
617         
618         return _amountOfTokens;
619     }
620 
621     /**
622      * Calculate Token price based on an amount of incoming ethereum
623      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
624      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
625      */
626     function ethereumToTokens_(uint256 _ethereum)
627         internal
628         view
629         returns(uint256)
630     {
631         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
632         uint256 _tokensReceived = 
633          (
634             (
635                 // underflow attempts BTFO
636                 SafeMath.sub(
637                     (sqrt
638                         (
639                             (_tokenPriceInitial**2)
640                             +
641                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
642                             +
643                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
644                             +
645                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
646                         )
647                     ), _tokenPriceInitial
648                 )
649             )/(tokenPriceIncremental_)
650         )-(tokenSupply_)
651         ;
652   
653         return _tokensReceived;
654     }
655     
656     /**
657      * Calculate token sell value.
658      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
659      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
660      */
661      function tokensToEthereum_(uint256 _tokens)
662         internal
663         view
664         returns(uint256)
665     {
666 
667         uint256 tokens_ = (_tokens + 1e18);
668         uint256 _tokenSupply = (tokenSupply_ + 1e18);
669         uint256 _etherReceived =
670         (
671             // underflow attempts BTFO
672             SafeMath.sub(
673                 (
674                     (
675                         (
676                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
677                         )-tokenPriceIncremental_
678                     )*(tokens_ - 1e18)
679                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
680             )
681         /1e18);
682         return _etherReceived;
683     }
684     
685     
686     //This is where all your gas goes, sorry
687     //Not sorry, you probably only paid 1 gwei
688     function sqrt(uint x) internal pure returns (uint y) {
689         uint z = (x + 1) / 2;
690         y = x;
691         while (z < y) {
692             y = z;
693             z = (x / z + z) / 2;
694         }
695     }
696 }
697 
698 /**
699  * @title SafeMath
700  * @dev Math operations with safety checks that throw on error
701  */
702 library SafeMath {
703 
704     /**
705     * @dev Multiplies two numbers, throws on overflow.
706     */
707     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
708         if (a == 0) {
709             return 0;
710         }
711         uint256 c = a * b;
712         assert(c / a == b);
713         return c;
714     }
715 
716     /**
717     * @dev Integer division of two numbers, truncating the quotient.
718     */
719     function div(uint256 a, uint256 b) internal pure returns (uint256) {
720         // assert(b > 0); // Solidity automatically throws when dividing by 0
721         uint256 c = a / b;
722         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
723         return c;
724     }
725 
726     /**
727     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
728     */
729     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
730         assert(b <= a);
731         return a - b;
732     }
733 
734     /**
735     * @dev Adds two numbers, throws on overflow.
736     */
737     function add(uint256 a, uint256 b) internal pure returns (uint256) {
738         uint256 c = a + b;
739         assert(c >= a);
740         return c;
741     }
742 }