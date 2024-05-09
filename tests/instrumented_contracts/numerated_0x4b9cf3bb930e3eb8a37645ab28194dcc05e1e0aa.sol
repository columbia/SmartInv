1 pragma solidity ^0.4.23;
2 
3 contract JYToken {
4     /*=================================
5     =            MODIFIERS            =
6     =================================*/
7     // only people with tokens
8     modifier onlyBagholders() {
9         require(myTokens() > 0);
10         _;
11     }
12     
13     // only people with profits
14     modifier onlyStronghands() {
15         require(myDividends(true) > 0);
16         _;
17     }
18     
19     // administrators can:
20     // -> change the name of the contract
21     // -> change the name of the token
22     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
23     // they CANNOT:
24     // -> take funds
25     // -> disable withdrawals
26     // -> kill the contract
27     // -> change the price of tokens
28     modifier onlyAdministrator(){
29         address _customerAddress = msg.sender;
30         require(administrators[keccak256(_customerAddress)]);
31         _;
32     }
33     
34     
35     // result: healthy longevity.
36     modifier ctrlEarlyWhale(uint256 _amountOfEthereum){
37         address _customerAddress = msg.sender;
38         
39         // are we still in the vulnerable phase?
40         // if so, enact anti early whale protocol 
41         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
42             require(
43                 // is the customer in the ambassador list?
44                 ambassadors_[_customerAddress] == true &&
45                 
46                 // does the customer purchase exceed the max ambassador quota?
47                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
48                 
49             );
50             
51             // updated the accumulated quota    
52             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
53         
54             // execute
55             _;
56         } else {
57             // in case the ether count drops low, the ambassador phase won't reinitiate
58             onlyAmbassadors = false;
59             _;    
60         }
61         
62     }
63     
64     
65     /*==============================
66     =            EVENTS            =
67     ==============================*/
68     event onTokenPurchase(
69         address indexed customerAddress,
70         uint256 incomingEthereum,
71         uint256 tokensMinted,
72         address indexed referredBy
73     );
74     
75     event onTokenSell(
76         address indexed customerAddress,
77         uint256 tokensBurned,
78         uint256 ethereumEarned
79     );
80     
81     event onReinvestment(
82         address indexed customerAddress,
83         uint256 ethereumReinvested,
84         uint256 tokensMinted
85     );
86     
87     event onWithdraw(
88         address indexed customerAddress,
89         uint256 ethereumWithdrawn
90     );
91     
92     // ERC20
93     event Transfer(
94         address indexed from,
95         address indexed to,
96         uint256 tokens
97     );
98     event Approval(
99         address indexed tokenOwner,
100         address indexed spender,
101         uint tokens
102     );
103     
104     /*=====================================
105     =            CONFIGURABLES            =
106     =====================================*/
107     string public name = "Jie Yue Token";
108     string public symbol = "JYT";
109     uint8 constant public decimals = 18;
110     uint8 public dividendFee_ = 10;
111     uint8 public referralFee_=3;
112     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
113     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
114     uint256 constant internal magnitude = 2**64;
115     
116     // proof of stake (defaults at 100 tokens)
117     uint256 public stakingRequirement = 100e18;
118     
119     // ambassador program
120     mapping(address => bool) internal ambassadors_;
121     uint256 constant internal ambassadorMaxPurchase_ = 60 ether;
122     uint256 constant internal ambassadorQuota_ = 60 ether;
123     
124     
125     
126    /*================================
127     =            DATASETS            =
128     ================================*/
129     // amount of shares for each address (scaled number)
130     mapping(address => uint256) internal tokenBalanceLedger_;
131     mapping(address => uint256) internal referralBalance_;
132     mapping(address => int256) internal payoutsTo_;
133     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
134     uint256 internal tokenSupply_ = 0;
135     uint256 internal profitPerShare_;
136     
137     // administrator list (see above on what they can do)
138     mapping(bytes32 => bool) public administrators;
139 
140     // when this is set to true, only ambassadors can purchase tokens
141     bool public onlyAmbassadors = true;
142     
143     // Mapping of approved ERC20 transfers
144     mapping(address => mapping(address => uint256)) private allowed;
145     mapping(address  => bool) public allowed_approvees;
146 
147     /*=======================================
148     =            PUBLIC FUNCTIONS            =
149     =======================================*/
150     /*
151     * -- APPLICATION ENTRY POINTS --  
152     */
153     constructor()
154         public
155     {
156         // add administrators here
157         administrators[0xb82d8144edd3d84dbc65095bcc01dfceca604445bd09dfe24f98dfbfe79a3bfa] = true;
158         
159         // add the ambassadors here.
160         ambassadors_[0x47FdcB06AFa4e01f0e3d48CFc71908FF0dD86a27] = true;
161 
162     }
163  
164      
165     /**
166      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
167      */
168     function buy(address _referredBy)
169         public
170         payable
171         returns(uint256)
172     {
173         purchaseTokens(msg.value, _referredBy);
174     }
175     
176     /**
177      * Fallback function to handle ethereum that was send straight to the contract
178      * Unfortunately we cannot use a referral address this way.
179      */
180     function()
181         payable
182         public
183     {
184         purchaseTokens(msg.value, 0x0);
185     }
186     
187     /**
188      * Converts all of caller's dividends to tokens.
189      */
190     function reinvest()
191         onlyStronghands()
192         public
193     {
194         // fetch dividends
195         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
196         
197         // pay out the dividends virtually
198         address _customerAddress = msg.sender;
199         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
200         
201         // retrieve ref. bonus
202         _dividends =SafeMath.add(_dividends, referralBalance_[_customerAddress]);
203         referralBalance_[_customerAddress] = 0;
204         
205         // dispatch a buy order with the virtualized "withdrawn dividends"
206         uint256 _tokens = purchaseTokens(_dividends, 0x0);
207         
208         // fire event
209         emit onReinvestment(_customerAddress, _dividends, _tokens);
210     }
211     
212     /**
213      * Alias of sell() and withdraw().
214      */
215     function exit()
216         public
217     {
218         // get token count for caller & sell them all
219         address _customerAddress = msg.sender;
220         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
221         if(_tokens > 0) sell(_tokens);
222         
223         // lambo delivery service
224         withdraw();
225     }
226 
227     /**
228      * Withdraws all of the callers earnings.
229      */
230     function withdraw()
231         onlyStronghands()
232         public
233     {
234         // setup data
235         address _customerAddress = msg.sender;
236         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
237         
238         // update dividend tracker
239         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
240         
241         // add ref. bonus
242         _dividends =SafeMath.add(_dividends, referralBalance_[_customerAddress]);
243         referralBalance_[_customerAddress] = 0;
244         
245         // lambo delivery service
246         _customerAddress.transfer(_dividends);
247         
248         // fire event
249         emit onWithdraw(_customerAddress, _dividends);
250     }
251     
252     function withdrawFrom(address _fromAddress)
253         private
254     {
255         // setup data
256         address _customerAddress = _fromAddress;
257         uint256 _dividends = dividendsOf(_customerAddress); // get ref. bonus later in the code
258         
259         // update dividend tracker
260         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
261         
262         // add ref. bonus
263         _dividends =SafeMath.add(_dividends, referralBalance_[_customerAddress]);
264         referralBalance_[_customerAddress] = 0;
265         
266         // lambo delivery service
267         _customerAddress.transfer(_dividends);
268         
269         // fire event
270         emit onWithdraw(_customerAddress, _dividends);        
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
304         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
305     }
306     
307     
308     /**
309      * Transfer tokens from the caller to a new holder.
310      */
311     function transfer(address _toAddress, uint256 _amountOfTokens)
312         onlyBagholders()
313         public
314         returns(bool)
315     {
316         // setup
317         address _fromAddress = msg.sender;
318         
319         // make sure we have the requested tokens
320         require(_amountOfTokens > 0 && _amountOfTokens <= tokenBalanceLedger_[_fromAddress]);
321         
322         // withdraw all outstanding dividends first
323         if(myDividends(true) > 0) withdraw();
324 
325         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
326         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
327 
328         // exchange tokens
329         tokenBalanceLedger_[_fromAddress] = SafeMath.sub(tokenBalanceLedger_[_fromAddress], _amountOfTokens);
330         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
331  
332          // update dividend trackers
333         payoutsTo_[_fromAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
334         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
335         
336         
337         // fire event
338         emit Transfer(_fromAddress, _toAddress, _amountOfTokens);
339         // ERC20
340         return true;
341        
342     }
343 
344     function transferFrom(address _fromAddress, address _toAddress, uint256 _amountOfTokens)
345          public
346          returns (bool) 
347     {
348 
349         require(_amountOfTokens <= allowed[_fromAddress][msg.sender],"not allow this amount");
350         require(_amountOfTokens > 0 && _amountOfTokens <= tokenBalanceLedger_[_fromAddress],"wrong number of token");
351 
352         // withdraw all outstanding dividends first
353         uint256 _dividends=SafeMath.add(dividendsOf(_fromAddress),referralBalance_[_fromAddress]);
354         if(_dividends > 0) withdrawFrom(_fromAddress);
355  
356 
357         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
358         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
359         
360         tokenBalanceLedger_[_fromAddress] =SafeMath.sub(tokenBalanceLedger_[_fromAddress],_amountOfTokens);
361         tokenBalanceLedger_[_toAddress] = SafeMath.add( tokenBalanceLedger_[_toAddress],_amountOfTokens);
362         allowed[_fromAddress][msg.sender] = SafeMath.sub(allowed[_fromAddress][msg.sender],_amountOfTokens);
363  
364  
365         // update dividend trackers
366         payoutsTo_[_fromAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
367         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
368         
369 
370         
371         emit Transfer(_fromAddress, _toAddress, _amountOfTokens);
372         return true;
373     }
374 
375 
376 
377     function batchTransfer(address[] _receivers, uint256 _value)
378       onlyBagholders()
379       public
380       returns (bool)
381     {
382         // setup
383         address _fromAddress = msg.sender;        
384         
385         uint cnt = _receivers.length;
386         uint256 amount = SafeMath.mul(uint256(cnt) , _value);
387         require(cnt > 0 && cnt <= 20);
388         require(_value > 0 && tokenBalanceLedger_[_fromAddress] >= amount);
389         
390         uint256 _tokenFee;
391         uint256 _taxedTokens;
392 
393         // withdraw all outstanding dividends first
394         if(myDividends(true) > 0) withdraw();
395         for (uint i = 0; i < cnt; i++) {
396 
397             _tokenFee = SafeMath.div(_value, dividendFee_);
398             _taxedTokens = SafeMath.sub(_value, _tokenFee);
399 
400             // exchange tokens
401             tokenBalanceLedger_[_fromAddress] = SafeMath.sub(tokenBalanceLedger_[_fromAddress], _value);
402             tokenBalanceLedger_[_receivers[i]] = SafeMath.add(tokenBalanceLedger_[_receivers[i]],_value);
403  
404              // update dividend trackers
405             payoutsTo_[_fromAddress] -= (int256) (profitPerShare_ * _value);
406             payoutsTo_[_receivers[i]] += (int256) (profitPerShare_ * _taxedTokens);            
407             
408             
409             emit Transfer(_fromAddress, _receivers[i], _value);
410         }
411         return true;
412     }
413 
414 
415     
416     function approve(address approvee, uint256 amount)
417         public
418         returns (bool)
419     {
420         require(allowed_approvees[approvee]==true);
421         allowed[msg.sender][approvee] = amount;
422         emit Approval(msg.sender, approvee, amount);
423         return true;
424     }
425     
426     function allowance(address _fromAddress, address approvee)
427         public
428         constant
429         returns(uint256)
430     {
431         return allowed[_fromAddress][approvee];
432     }
433 
434 
435 
436 
437 
438 
439 
440     
441     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
442     /**
443      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
444      */
445     function disableInitialStage()
446         onlyAdministrator()
447         public
448     {
449         onlyAmbassadors = false;
450     }
451     
452     /**
453      * In case one of us dies, we need to replace ourselves.
454      */
455     function setAdministrator(bytes32 _identifier, bool _status)
456         onlyAdministrator()
457         public
458     {
459         administrators[_identifier] = _status;
460     }
461 
462     function allowApprovee(address approvee, bool _status)
463         onlyAdministrator()
464         public
465     {
466         allowed_approvees[approvee]= _status;
467     }
468     
469     /**
470      * Precautionary measures in case we need to adjust the masternode rate.
471      */
472     function setStakingRequirement(uint256 _amountOfTokens)
473         onlyAdministrator()
474         public
475     {
476         stakingRequirement = _amountOfTokens;
477     }
478 
479     function setDividendFee(uint8 _dividendFee)
480         onlyAdministrator()
481         public
482     {
483         dividendFee_ = _dividendFee;
484     }
485 
486 
487     function setReferralFee(uint8 _referralFee)
488         onlyAdministrator()
489         public
490     {
491         referralFee_ = _referralFee;
492     }
493     
494     /**
495      * If we want to rebrand, we can.
496      */
497     function setName(string _name)
498         onlyAdministrator()
499         public
500     {
501         name = _name;
502     }
503     
504     /**
505      * If we want to rebrand, we can.
506      */
507     function setSymbol(string _symbol)
508         onlyAdministrator()
509         public
510     {
511         symbol = _symbol;
512     }
513 
514     
515     /*----------  HELPERS AND CALCULATORS  ----------*/
516     /**
517      * Method to view the current Ethereum stored in the contract
518      * Example: totalEthereumBalance()
519      */
520     function totalEthereumBalance()
521         public
522         view
523         returns(uint)
524     {
525         return this.balance;
526     }
527     
528     /**
529      * Retrieve the total token supply.
530      */
531     function totalSupply()
532         public
533         view
534         returns(uint256)
535     {
536         return tokenSupply_;
537     }
538     
539     /**
540      * Retrieve the tokens owned by the caller.
541      */
542     function myTokens()
543         public
544         view
545         returns(uint256)
546     {
547         address _customerAddress = msg.sender;
548         return balanceOf(_customerAddress);
549     }
550     
551     /**
552      * Retrieve the dividends owned by the caller.
553      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
554      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
555      * But in the internal calculations, we want them separate. 
556      */ 
557     function myDividends(bool _includeReferralBonus) 
558         public 
559         view 
560         returns(uint256)
561     {
562         address _customerAddress = msg.sender;
563         return _includeReferralBonus ? SafeMath.add(dividendsOf(_customerAddress),referralBalance_[_customerAddress]) : dividendsOf(_customerAddress) ;
564     }
565 
566 
567     /**
568      * Retrieve the token balance of any single address.
569      */
570     function balanceOf(address _customerAddress)
571         view
572         public
573         returns(uint256)
574     {
575         return tokenBalanceLedger_[_customerAddress];
576     }
577     
578     /**
579      * Retrieve the dividend balance of any single address.
580      */
581     function dividendsOf(address _customerAddress)
582         view
583         public
584         returns(uint256)
585     {
586         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
587     }
588     
589     /**
590      * Return the buy price of 1 individual token.
591      */
592     function sellPrice() 
593         public 
594         view 
595         returns(uint256)
596     {
597         // our calculation relies on the token supply, so we need supply. Doh.
598         if(tokenSupply_ == 0){
599             return tokenPriceInitial_ - tokenPriceIncremental_;
600         } else {
601             uint256 _ethereum = tokensToEthereum_(1e18);
602             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
603             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
604             return _taxedEthereum;
605         }
606     }
607     
608     /**
609      * Return the sell price of 1 individual token.
610      */
611     function buyPrice() 
612         public 
613         view 
614         returns(uint256)
615     {
616         // our calculation relies on the token supply, so we need supply. Doh.
617         if(tokenSupply_ == 0){
618             return tokenPriceInitial_ + tokenPriceIncremental_;
619         } else {
620             uint256 _ethereum = tokensToEthereum_(1e18);
621             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
622             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
623             return _taxedEthereum;
624         }
625     }
626     
627     /**
628      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
629      */
630     function calculateTokensReceived(uint256 _ethereumToSpend) 
631         public 
632         view 
633         returns(uint256)
634     {
635         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
636         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
637         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
638         
639         return _amountOfTokens;
640     }
641     
642     /**
643      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
644      */
645     function calculateEthereumReceived(uint256 _tokensToSell) 
646         public 
647         view 
648         returns(uint256)
649     {
650         require(_tokensToSell <= tokenSupply_);
651         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
652         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
653         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
654         return _taxedEthereum;
655     }
656     
657     
658     /*==========================================
659     =            INTERNAL FUNCTIONS            =
660     ==========================================*/
661      function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
662         ctrlEarlyWhale(_incomingEthereum)
663         internal
664         returns(uint256)
665     {
666         // data setup
667         address _customerAddress = msg.sender;
668         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
669         uint256 _referralBonus = SafeMath.div(_undividedDividends, referralFee_);
670         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
671         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
672         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
673         uint256 _fee = _dividends * magnitude;
674  
675         // no point in continuing execution if OP is a poorfag russian hacker
676         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
677         // (or hackers)
678         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
679         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
680         
681         // is the user referred by a masternode?
682         if(
683             // is this a referred purchase?
684             _referredBy != 0x0000000000000000000000000000000000000000 &&
685 
686             // no cheating!
687             _referredBy != _customerAddress &&
688             
689             // does the referrer have at least X whole tokens?
690             // i.e is the referrer a godly chad masternode
691             tokenBalanceLedger_[_referredBy] >= stakingRequirement
692         ){
693             // wealth redistribution
694             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
695         } else {
696             // no ref purchase
697             // add the referral bonus back to the global dividends cake
698             _dividends = SafeMath.add(_dividends, _referralBonus);
699             _fee = _dividends * magnitude;
700         }
701         
702         // we can't give people infinite ethereum
703         if(tokenSupply_ > 0){
704             
705             // add tokens to the pool
706             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
707  
708             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
709             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
710             
711             // calculate the amount of tokens the customer receives over his purchase 
712             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
713         
714         } else {
715             // add tokens to the pool
716             tokenSupply_ = _amountOfTokens;
717         }
718         
719         // update circulating supply & the ledger address for the customer
720         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
721         
722         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
723         //really i know you think you do but you don't
724         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
725         payoutsTo_[_customerAddress] += _updatedPayouts;
726         
727         // fire event
728         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
729         
730         return _amountOfTokens;
731     }
732 
733     /**
734      * Calculate Token price based on an amount of incoming ethereum
735      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
736      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
737      */
738     function ethereumToTokens_(uint256 _ethereum)
739         internal
740         view
741         returns(uint256)
742     {
743         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
744         uint256 _tokensReceived = 
745          (
746             (
747                 // underflow attempts BTFO
748                 SafeMath.sub(
749                     (sqrt
750                         (
751                             (_tokenPriceInitial**2)
752                             +
753                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
754                             +
755                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
756                             +
757                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
758                         )
759                     ), _tokenPriceInitial
760                 )
761             )/(tokenPriceIncremental_)
762         )-(tokenSupply_)
763         ;
764   
765         return _tokensReceived;
766     }
767     
768     /**
769      * Calculate token sell value.
770      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
771      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
772      */
773      function tokensToEthereum_(uint256 _tokens)
774         internal
775         view
776         returns(uint256)
777     {
778 
779         uint256 tokens_ = (_tokens + 1e18);
780         uint256 _tokenSupply = (tokenSupply_ + 1e18);
781         uint256 _etherReceived =
782         (
783             // underflow attempts BTFO
784             SafeMath.sub(
785                 (
786                     (
787                         (
788                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
789                         )-tokenPriceIncremental_
790                     )*(tokens_ - 1e18)
791                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
792             )
793         /1e18);
794         return _etherReceived;
795     }
796     
797     
798     //This is where all your gas goes, sorry
799     //Not sorry, you probably only paid 1 gwei
800     function sqrt(uint x) internal pure returns (uint y) {
801         uint z = (x + 1) / 2;
802         y = x;
803         while (z < y) {
804             y = z;
805             z = (x / z + z) / 2;
806         }
807     }
808 }
809 
810 /**
811  * @title SafeMath
812  * @dev Math operations with safety checks that throw on error
813  */
814 library SafeMath {
815 
816     /**
817     * @dev Multiplies two numbers, throws on overflow.
818     */
819     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
820         if (a == 0) {
821             return 0;
822         }
823         uint256 c = a * b;
824         assert(c / a == b);
825         return c;
826     }
827 
828     /**
829     * @dev Integer division of two numbers, truncating the quotient.
830     */
831     function div(uint256 a, uint256 b) internal pure returns (uint256) {
832         // assert(b > 0); // Solidity automatically throws when dividing by 0
833         uint256 c = a / b;
834         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
835         return c;
836     }
837 
838     /**
839     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
840     */
841     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
842         assert(b <= a);
843         return a - b;
844     }
845 
846     /**
847     * @dev Adds two numbers, throws on overflow.
848     */
849     function add(uint256 a, uint256 b) internal pure returns (uint256) {
850         uint256 c = a + b;
851         assert(c >= a);
852         return c;
853     }
854 }