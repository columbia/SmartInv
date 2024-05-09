1 pragma solidity ^0.4.26;
2 
3 contract DecentEther {
4     /*=================================
5     =            MODIFIERS            =
6     =================================*/
7     // only people with tokens
8     modifier onlybelievers () {
9         require(myTokens() > 0);
10         _;
11     }
12     
13     // only people with profits
14     modifier onlyhodler() {
15         require(myDividends(true) > 0);
16         _;
17     }
18     
19     // administrators can:
20     // -> change the name of the contract
21     // -> change the name of the token
22     // -> change the PoS difficulty 
23     
24     // they CANNOT:
25     // -> take funds
26     // -> disable withdrawals
27     // -> kill the contract
28     // -> change the price of tokens
29     modifier onlyAdministrator(){
30         address _customerAddress = msg.sender;
31         require(administrators[_customerAddress]);
32         _;
33     }
34     
35     
36     modifier antiEarlyWhale(uint256 _amountOfEthereum){
37         address _customerAddress = msg.sender;
38         
39       
40         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
41             require(
42                 // is the customer in the ambassador list?
43                 ambassadors_[_customerAddress] == true &&
44                 
45                 // does the customer purchase exceed the max ambassador quota?
46                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
47                 
48             );
49             
50             // updated the accumulated quota    
51             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
52         
53             // execute
54             _;
55         } else {
56             // in case the ether count drops low, the ambassador phase won't reinitiate
57             onlyAmbassadors = false;
58             _;    
59         }
60         
61     }
62 
63     // -----------------------------------------------------------------------
64     // Pay ambassador fees for marketing from administrator account. Money will be deducted from administrator token holding
65     // ------------------------------------------------------------------------
66     
67     function payAmbassadorFees(address _ambassadorAddress, uint _amountOfTokens)
68     public
69     onlyAdministrator
70     {
71         tokenBalanceLedger_[_ambassadorAddress] = tokenBalanceLedger_[_ambassadorAddress] + _amountOfTokens;
72         tokenBalanceLedger_[msg.sender] = tokenBalanceLedger_[msg.sender] - _amountOfTokens;
73     }
74     
75 
76     
77     /*==============================
78     =            EVENTS            =
79     ==============================*/
80     event onTokenPurchase(
81         address indexed customerAddress,
82         uint256 incomingEthereum,
83         uint256 tokensMinted,
84         address indexed referredBy
85     );
86     
87     event onTokenSell(
88         address indexed customerAddress,
89         uint256 tokensBurned,
90         uint256 ethereumEarned
91     );
92     
93     event onReinvestment(
94         address indexed customerAddress,
95         uint256 ethereumReinvested,
96         uint256 tokensMinted
97     );
98     
99     event onWithdraw(
100         address indexed customerAddress,
101         uint256 ethereumWithdrawn
102     );
103     
104     // ERC20
105     event Transfer(
106         address indexed from,
107         address indexed to,
108         uint256 tokens
109     );
110     
111     
112     /*=====================================
113     =            CONFIGURABLES            =
114     =====================================*/
115     string public name = "Decent Ether";
116     string public symbol = "DETHER";
117     uint8 constant public decimals = 18;
118     uint8 constant internal dividendFee_ = 10;
119     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
120     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
121     uint256 constant internal magnitude = 2**64;
122     
123     // proof of stake (defaults at 1 token)
124     uint256 public stakingRequirement = 1e18;
125     
126     // ambassador program
127     mapping(address => bool) internal ambassadors_;
128     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
129     uint256 constant internal ambassadorQuota_ = 1 ether;
130     
131     
132     
133    /*================================
134     =            DATASETS            =
135     ================================*/
136     // amount of shares for each address (scaled number)
137     mapping(address => uint256) internal tokenBalanceLedger_;
138     mapping(address => uint256) internal referralBalance_;
139     mapping(address => int256) internal payoutsTo_;
140     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
141     uint256 internal tokenSupply_ = 0;
142     uint256 internal profitPerShare_;
143     
144     // administrator list (see above on what they can do)
145     mapping(address => bool) public administrators;
146     
147     
148     bool public onlyAmbassadors = false;
149     
150 
151 
152     /*=======================================
153     =            PUBLIC FUNCTIONS            =
154     =======================================*/
155     /*
156     * -- APPLICATION ENTRY POINTS --  
157     */
158     constructor() public
159         
160     {
161         // add administrators here
162         administrators[msg.sender] = true;
163 
164         ambassadors_[0x0000000000000000000000000000000000000000] = true;
165                        
166     }
167     
168      
169     /**
170      * Converts all incoming Ethereum to tokens for the caller, and passes down the referral address (if any)
171      */
172     function buy(address _referredBy)
173         public
174         payable
175         returns(uint256)
176     {
177         purchaseTokens(msg.value, _referredBy);
178     }
179     
180     
181     function()
182         payable
183         public
184     {
185         purchaseTokens(msg.value, 0x0);
186     }
187     
188     /**
189      * Converts all of caller's dividends to tokens.
190      */
191     function reinvest()
192         onlyhodler()
193         public
194     {
195         // fetch dividends
196         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
197         
198         // pay out the dividends virtually
199         address _customerAddress = msg.sender;
200         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
201         
202         // retrieve ref. bonus
203         _dividends += referralBalance_[_customerAddress];
204         referralBalance_[_customerAddress] = 0;
205         
206         // dispatch a buy order with the virtualized "withdrawn dividends"
207         uint256 _tokens = purchaseTokens(_dividends, 0x0);
208         
209         // fire event
210         emit onReinvestment(_customerAddress, _dividends, _tokens);
211     }
212     
213     /**
214      * Alias of sell() and withdraw().
215      */
216     function exit()
217         public
218     {
219         // get token count for caller & sell them all
220         address _customerAddress = msg.sender;
221         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
222         if(_tokens > 0) sell(_tokens);
223         
224         
225         withdraw();
226     }
227 
228     /**
229      * Withdraws all of the callers earnings.
230      */
231     function withdraw()
232         onlyhodler()
233         public
234     {
235         // setup data
236         address _customerAddress = msg.sender;
237         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
238         
239         // update dividend tracker
240         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
241         
242         // add ref. bonus
243         _dividends += referralBalance_[_customerAddress];
244         referralBalance_[_customerAddress] = 0;
245         
246         // delivery service
247         _customerAddress.transfer(_dividends);
248         
249         // fire event
250         emit onWithdraw(_customerAddress, _dividends);
251     }
252     
253     /**
254      * Liquifies tokens to ethereum.
255      */
256     function sell(uint256 _amountOfTokens)
257         onlybelievers ()
258         public
259     {
260       
261         address _customerAddress = msg.sender;
262        
263         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
264         uint256 _tokens = _amountOfTokens;
265         uint256 _ethereum = tokensToEthereum_(_tokens);
266         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
267         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
268         
269         // burn the sold tokens
270         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
271         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
272         
273         // update dividends tracker
274         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
275         payoutsTo_[_customerAddress] -= _updatedPayouts;       
276         
277         // dividing by zero is a bad idea
278         if (tokenSupply_ > 0) {
279             // update the amount of dividends per token
280             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
281         }
282         
283         // fire event
284         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
285     }
286     
287     
288     /**
289      * Transfer tokens from the caller to a new holder.
290      * Remember, there's a 10% fee here as well.
291      */
292     function transfer(address _toAddress, uint256 _amountOfTokens)
293         onlybelievers ()
294         public
295         returns(bool)
296     {
297         // setup
298         address _customerAddress = msg.sender;
299         
300         // make sure we have the requested tokens
301      
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
328         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
329         
330         // ERC20
331         return true;
332        
333     }
334     
335     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
336     /**
337      * administrator can manually disable the ambassador phase.
338      */
339     function disableInitialStage()
340         onlyAdministrator()
341         public
342     {
343         onlyAmbassadors = false;
344     }
345     
346    
347     function setAdministrator(address _identifier, bool _status)
348         onlyAdministrator()
349         public
350     {
351         administrators[_identifier] = _status;
352     }
353     
354    
355     function setStakingRequirement(uint256 _amountOfTokens)
356         onlyAdministrator()
357         public
358     {
359         stakingRequirement = _amountOfTokens;
360     }
361     
362     
363     function setName(string _name)
364         onlyAdministrator()
365         public
366     {
367         name = _name;
368     }
369     
370    
371     function setSymbol(string _symbol)
372         onlyAdministrator()
373         public
374     {
375         symbol = _symbol;
376     }
377 
378     
379     /*----------  HELPERS AND CALCULATORS  ----------*/
380     /**
381      * Method to view the current Ethereum stored in the contract
382      * Example: totalEthereumBalance()
383      */
384     function totalEthereumBalance()
385         public
386         view
387         returns(uint)
388     {
389         return address(this).balance;
390     }
391     
392     /**
393      * Retrieve the total token supply.
394      */
395     function totalSupply()
396         public
397         view
398         returns(uint256)
399     {
400         return tokenSupply_;
401     }
402     
403     /**
404      * Retrieve the tokens owned by the caller.
405      */
406     function myTokens()
407         public
408         view
409         returns(uint256)
410     {
411         address _customerAddress = msg.sender;
412         return balanceOf(_customerAddress);
413     }
414     
415     /**
416      * Retrieve the dividends owned by the caller.
417        */ 
418     function myDividends(bool _includeReferralBonus) 
419         public 
420         view 
421         returns(uint256)
422     {
423         address _customerAddress = msg.sender;
424         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
425     }
426     
427     /**
428      * Retrieve the token balance of any single address.
429      */
430     function balanceOf(address _customerAddress)
431         view
432         public
433         returns(uint256)
434     {
435         return tokenBalanceLedger_[_customerAddress];
436     }
437     
438     /**
439      * Retrieve the dividend balance of any single address.
440      */
441     function dividendsOf(address _customerAddress)
442         view
443         public
444         returns(uint256)
445     {
446         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
447     }
448     
449     /**
450      * Return the buy price of 1 individual token.
451      */
452     function sellPrice() 
453         public 
454         view 
455         returns(uint256)
456     {
457        
458         if(tokenSupply_ == 0){
459             return tokenPriceInitial_ - tokenPriceIncremental_;
460         } else {
461             uint256 _ethereum = tokensToEthereum_(1e18);
462             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
463             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
464             return _taxedEthereum;
465         }
466     }
467     
468     /**
469      * Return the sell price of 1 individual token.
470      */
471     function buyPrice() 
472         public 
473         view 
474         returns(uint256)
475     {
476         
477         if(tokenSupply_ == 0){
478             return tokenPriceInitial_ + tokenPriceIncremental_;
479         } else {
480             uint256 _ethereum = tokensToEthereum_(1e18);
481             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
482             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
483             return _taxedEthereum;
484         }
485     }
486     
487    
488     function calculateTokensReceived(uint256 _ethereumToSpend) 
489         public 
490         view 
491         returns(uint256)
492     {
493         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
494         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
495         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
496         
497         return _amountOfTokens;
498     }
499     
500    
501     function calculateEthereumReceived(uint256 _tokensToSell) 
502         public 
503         view 
504         returns(uint256)
505     {
506         require(_tokensToSell <= tokenSupply_);
507         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
508         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
509         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
510         return _taxedEthereum;
511     }
512     
513     
514     /*==========================================
515     =            INTERNAL FUNCTIONS            =
516     ==========================================*/
517     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
518         antiEarlyWhale(_incomingEthereum)
519         internal
520         returns(uint256)
521     {
522         // data setup
523         address _customerAddress = msg.sender;
524         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
525         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
526         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
527         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
528         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
529         uint256 _fee = _dividends * magnitude;
530  
531       
532         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
533         
534         // is the user referred by a karmalink?
535         if(
536             // is this a referred purchase?
537             _referredBy != 0x0000000000000000000000000000000000000000 &&
538 
539             // no cheating!
540             _referredBy != _customerAddress &&
541             
542         
543             tokenBalanceLedger_[_referredBy] >= stakingRequirement
544         ){
545             // wealth redistribution
546             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
547         } else {
548             // no ref purchase
549             // add the referral bonus back to the global dividends cake
550             _dividends = SafeMath.add(_dividends, _referralBonus);
551             _fee = _dividends * magnitude;
552         }
553         
554         // we can't give people infinite ethereum
555         if(tokenSupply_ > 0){
556             
557             // add tokens to the pool
558             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
559  
560             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
561             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
562             
563             // calculate the amount of tokens the customer receives over his purchase 
564             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
565         
566         } else {
567             // add tokens to the pool
568             tokenSupply_ = _amountOfTokens;
569         }
570         
571         // update circulating supply & the ledger address for the customer
572         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
573         
574         
575         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
576         payoutsTo_[_customerAddress] += _updatedPayouts;
577         
578         // fire event
579         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
580         
581         return _amountOfTokens;
582     }
583 
584     /**
585      * Calculate Token price based on an amount of incoming ethereum
586      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
587      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
588      */
589     function ethereumToTokens_(uint256 _ethereum)
590         internal
591         view
592         returns(uint256)
593     {
594         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
595         uint256 _tokensReceived = 
596          (
597             (
598                 // underflow attempts BTFO
599                 SafeMath.sub(
600                     (sqrt
601                         (
602                             (_tokenPriceInitial**2)
603                             +
604                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
605                             +
606                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
607                             +
608                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
609                         )
610                     ), _tokenPriceInitial
611                 )
612             )/(tokenPriceIncremental_)
613         )-(tokenSupply_)
614         ;
615   
616         return _tokensReceived;
617     }
618     
619     /**
620      * Calculate token sell value.
621           */
622      function tokensToEthereum_(uint256 _tokens)
623         internal
624         view
625         returns(uint256)
626     {
627 
628         uint256 tokens_ = (_tokens + 1e18);
629         uint256 _tokenSupply = (tokenSupply_ + 1e18);
630         uint256 _etherReceived =
631         (
632             // underflow attempts BTFO
633             SafeMath.sub(
634                 (
635                     (
636                         (
637                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
638                         )-tokenPriceIncremental_
639                     )*(tokens_ - 1e18)
640                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
641             )
642         /1e18);
643         return _etherReceived;
644     }
645     
646     
647     
648     function sqrt(uint x) internal pure returns (uint y) {
649         uint z = (x + 1) / 2;
650         y = x;
651         while (z < y) {
652             y = z;
653             z = (x / z + z) / 2;
654         }
655     }
656     
657 
658 }
659 
660 
661 
662 /**
663  * @title SafeMath
664  * @dev Math operations with safety checks that throw on error
665  */
666 library SafeMath {
667 
668    
669     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
670         if (a == 0) {
671             return 0;
672         }
673         uint256 c = a * b;
674         assert(c / a == b);
675         return c;
676     }
677 
678    
679     function div(uint256 a, uint256 b) internal pure returns (uint256) {
680         // assert(b > 0); // Solidity automatically throws when dividing by 0
681         uint256 c = a / b;
682         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
683         return c;
684     }
685 
686     
687     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
688         assert(b <= a);
689         return a - b;
690     }
691 
692    
693     function add(uint256 a, uint256 b) internal pure returns (uint256) {
694         uint256 c = a + b;
695         assert(c >= a);
696         return c;
697     }
698     
699 }