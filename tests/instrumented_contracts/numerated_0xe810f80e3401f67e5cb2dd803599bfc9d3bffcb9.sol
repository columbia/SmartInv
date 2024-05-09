1 pragma solidity ^0.4.23;
2 
3 
4 contract JYToken {
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
31         require(administrators[keccak256(_customerAddress)]);
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
106     string public name = "Jie Yue Token";
107     string public symbol = "JYT";
108     uint8 constant public decimals = 18;
109     uint8 constant internal dividendFee_ = 5;
110     uint8 constant internal funderFee_ = 2;
111     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
112     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
113     uint256 constant internal magnitude = 2**64;
114     
115     // proof of stake (defaults at 5 tokens)
116     uint256 public stakingRequirement = 5e18;
117     
118     // ambassador program
119     mapping(address => bool) internal ambassadors_;
120     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
121     uint256 constant internal ambassadorQuota_ = 20 ether;
122     
123     
124     
125    /*================================
126     =            DATASETS            =
127     ================================*/
128     // amount of shares for each address (scaled number)
129     mapping(address => uint256) internal tokenBalanceLedger_;
130     mapping(address => uint256) internal referralBalance_;
131     
132     uint256 public funderBalance_ = 0;    
133     
134     mapping(address => int256) internal payoutsTo_;
135     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
136     uint256 internal tokenSupply_ = 0;
137     uint256 internal profitPerShare_;
138     
139     // administrator list (see above on what they can do)
140     mapping(bytes32 => bool) public administrators;
141     
142     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
143     bool public onlyAmbassadors = false;
144     
145 
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
162 
163     }
164     
165      
166     /**
167      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
168      */
169     function buy(address _referredBy)
170         public
171         payable
172         returns(uint256)
173     {
174         purchaseTokens(msg.value, _referredBy);
175     }
176     
177     /**
178      * Fallback function to handle ethereum that was send straight to the contract
179      * Unfortunately we cannot use a referral address this way.
180      */
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
192         onlyStronghands()
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
224         // lambo delivery service
225         withdraw();
226     }
227 
228     /**
229      * Withdraws all of the callers earnings.
230      */
231     function withdraw()
232         onlyStronghands()
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
246         // lambo delivery service
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
257         onlyBagholders()
258         public
259     {
260         // setup data
261         address _customerAddress = msg.sender;
262         // russian hackers BTFO
263         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
264         uint256 _tokens = _amountOfTokens;
265         uint256 _ethereum = tokensToEthereum_(_tokens);
266         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
267         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
268  
269         //funder bonus 
270         uint256 _funderBonus = SafeMath.div(_dividends, funderFee_);
271         funderBalance_ = SafeMath.add(funderBalance_, _funderBonus);
272         uint256 _dividends_to_holder = SafeMath.sub(_dividends,_funderBonus);
273          
274         
275         // burn the sold tokens
276         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
277         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
278         
279         // update dividends tracker
280         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
281         payoutsTo_[_customerAddress] -= _updatedPayouts;       
282         
283         // dividing by zero is a bad idea
284         if (tokenSupply_ > 0) {
285             // update the amount of dividends per token
286             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends_to_holder * magnitude) / tokenSupply_);
287         }
288         
289         // fire event
290         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
291     }
292     
293     
294     /**
295      * Transfer tokens from the caller to a new holder.
296      * Remember, there's a 10% fee here as well.
297      */
298     function transfer(address _toAddress, uint256 _amountOfTokens)
299         onlyBagholders()
300         public
301         returns(bool)
302     {
303         // setup
304         address _customerAddress = msg.sender;
305         
306         // make sure we have the requested tokens
307         // also disables transfers until ambassador phase is over
308         // ( we dont want whale premines )
309         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
310         
311         // withdraw all outstanding dividends first
312         if(myDividends(true) > 0) withdraw();
313         
314         // liquify 10% of the tokens that are transfered
315         // these are dispersed to shareholders
316         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
317         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
318         uint256 _dividends = tokensToEthereum_(_tokenFee);
319         
320         //funder bonus
321         uint256 _funderBonus = SafeMath.div(_dividends, funderFee_);
322         funderBalance_ = SafeMath.add(funderBalance_, _funderBonus);
323         uint256 _dividends_to_holder = SafeMath.sub(_dividends,_funderBonus);
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
337         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends_to_holder * magnitude) / tokenSupply_);
338         
339         // fire event
340         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
341         
342         // ERC20
343         return true;
344        
345     }
346 
347 
348     function batchTransfer(address[] _receivers, uint256 _value)
349       onlyBagholders()
350       public
351       returns (bool)
352     {
353         // setup
354         address _fromAddress = msg.sender;        
355         
356         uint cnt = _receivers.length;
357         uint256 amount = SafeMath.mul(uint256(cnt) , _value);
358         require(cnt > 0 && cnt <= 20);
359         require(_value > 0 && tokenBalanceLedger_[_fromAddress] >= amount);
360         
361 
362         // withdraw all outstanding dividends first
363         if(myDividends(true) > 0) withdraw();
364 
365         
366         uint256 _tokenFee;
367         uint256 _taxedTokens;
368         uint256 _dividends;
369         uint256 _funderBonus;
370         uint256 _dividends_to_holder;
371 
372         for (uint i = 0; i < cnt; i++) {
373             
374             // liquify 10% of the tokens that are transfered
375             // these are dispersed to shareholders
376             _tokenFee = SafeMath.div(_value, dividendFee_);
377             _taxedTokens = SafeMath.sub(_value, _tokenFee);
378             _dividends = tokensToEthereum_(_tokenFee);
379         
380             //funder bonus
381             _funderBonus = SafeMath.div(_dividends, funderFee_);
382             funderBalance_ = SafeMath.add(funderBalance_, _funderBonus);
383             _dividends_to_holder = SafeMath.sub(_dividends,_funderBonus);
384   
385             // burn the fee tokens
386             tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
387 
388             // exchange tokens
389             tokenBalanceLedger_[_fromAddress] = SafeMath.sub(tokenBalanceLedger_[_fromAddress], _value);
390             tokenBalanceLedger_[_receivers[i]] = SafeMath.add(tokenBalanceLedger_[_receivers[i]], _taxedTokens);
391         
392             // update dividend trackers
393             payoutsTo_[_fromAddress] -= (int256) (profitPerShare_ * _value);
394             payoutsTo_[_receivers[i]] += (int256) (profitPerShare_ * _taxedTokens);
395         
396             // disperse dividends among holders
397             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends_to_holder * magnitude) / tokenSupply_);
398             
399             emit Transfer(_fromAddress, _receivers[i], _value);
400         }
401         return true;
402     }
403 
404     
405     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
406     
407     function funderWithdraw()
408         onlyAdministrator()
409         public
410     {
411         require(funderBalance_>0);
412     
413         uint256 _dividends = funderBalance_;
414         funderBalance_ = 0;     
415             
416         address _funderAddress=0xC3Ca29B303196F4F94b7928254Eb166E4Ce2FCda;
417         _funderAddress.transfer(_dividends);
418         
419     
420         // fire event
421         emit onWithdraw(_funderAddress, _dividends);
422     }    
423     
424     
425     /**
426      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
427      */
428     function disableInitialStage()
429         onlyAdministrator()
430         public
431     {
432         onlyAmbassadors = false;
433     }
434     
435     /**
436      * In case one of us dies, we need to replace ourselves.
437      */
438     function setAdministrator(bytes32 _identifier, bool _status)
439         onlyAdministrator()
440         public
441     {
442         administrators[_identifier] = _status;
443     }
444     
445     /**
446      * Precautionary measures in case we need to adjust the masternode rate.
447      */
448     function setStakingRequirement(uint256 _amountOfTokens)
449         onlyAdministrator()
450         public
451     {
452         stakingRequirement = _amountOfTokens;
453     }
454     
455     /**
456      * If we want to rebrand, we can.
457      */
458     function setName(string _name)
459         onlyAdministrator()
460         public
461     {
462         name = _name;
463     }
464     
465     /**
466      * If we want to rebrand, we can.
467      */
468     function setSymbol(string _symbol)
469         onlyAdministrator()
470         public
471     {
472         symbol = _symbol;
473     }
474 
475     
476     /*----------  HELPERS AND CALCULATORS  ----------*/
477     /**
478      * Method to view the current Ethereum stored in the contract
479      * Example: totalEthereumBalance()
480      */
481     function totalEthereumBalance()
482         public
483         view
484         returns(uint)
485     {
486         return this.balance;
487     }
488     
489     /**
490      * Retrieve the total token supply.
491      */
492     function totalSupply()
493         public
494         view
495         returns(uint256)
496     {
497         return tokenSupply_;
498     }
499     
500     /**
501      * Retrieve the tokens owned by the caller.
502      */
503     function myTokens()
504         public
505         view
506         returns(uint256)
507     {
508         address _customerAddress = msg.sender;
509         return balanceOf(_customerAddress);
510     }
511     
512     /**
513      * Retrieve the dividends owned by the caller.
514      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
515      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
516      * But in the internal calculations, we want them separate. 
517      */ 
518     function myDividends(bool _includeReferralBonus) 
519         public 
520         view 
521         returns(uint256)
522     {
523         address _customerAddress = msg.sender;
524         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
525     }
526     
527     /**
528      * Retrieve the token balance of any single address.
529      */
530     function balanceOf(address _customerAddress)
531         view
532         public
533         returns(uint256)
534     {
535         return tokenBalanceLedger_[_customerAddress];
536     }
537     
538     /**
539      * Retrieve the dividend balance of any single address.
540      */
541     function dividendsOf(address _customerAddress)
542         view
543         public
544         returns(uint256)
545     {
546         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
547     }
548     
549     /**
550      * Return the buy price of 1 individual token.
551      */
552     function sellPrice() 
553         public 
554         view 
555         returns(uint256)
556     {
557         // our calculation relies on the token supply, so we need supply. Doh.
558         if(tokenSupply_ == 0){
559             return tokenPriceInitial_ - tokenPriceIncremental_;
560         } else {
561             uint256 _ethereum = tokensToEthereum_(1e18);
562             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
563             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
564             return _taxedEthereum;
565         }
566     }
567     
568     /**
569      * Return the sell price of 1 individual token.
570      */
571     function buyPrice() 
572         public 
573         view 
574         returns(uint256)
575     {
576         // our calculation relies on the token supply, so we need supply. Doh.
577         if(tokenSupply_ == 0){
578             return tokenPriceInitial_ + tokenPriceIncremental_;
579         } else {
580             uint256 _ethereum = tokensToEthereum_(1e18);
581             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
582             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
583             return _taxedEthereum;
584         }
585     }
586     
587     /**
588      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
589      */
590     function calculateTokensReceived(uint256 _ethereumToSpend) 
591         public 
592         view 
593         returns(uint256)
594     {
595         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
596         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
597         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
598         
599         return _amountOfTokens;
600     }
601     
602     /**
603      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
604      */
605     function calculateEthereumReceived(uint256 _tokensToSell) 
606         public 
607         view 
608         returns(uint256)
609     {
610         require(_tokensToSell <= tokenSupply_);
611         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
612         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
613         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
614         return _taxedEthereum;
615     }
616     
617     
618     /*==========================================
619     =            INTERNAL FUNCTIONS            =
620     ==========================================*/
621     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
622         antiEarlyWhale(_incomingEthereum)
623         internal
624         returns(uint256)
625     {
626         // data setup
627         uint256 _dividends = SafeMath.div(_incomingEthereum, dividendFee_);
628         uint256 _funderBonus= SafeMath.div(_dividends, funderFee_);        
629         uint256 _dividends_to_holder=SafeMath.sub( _dividends, _funderBonus);
630         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _dividends);
631         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
632         uint256 _fee = _dividends_to_holder * magnitude;        
633         
634  
635         // no point in continuing execution if OP is a poorfag russian hacker
636         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
637         // (or hackers)
638         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
639         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
640  
641         //funder balance get bonus
642         funderBalance_ = SafeMath.add(funderBalance_, _funderBonus);
643         
644         // is the user referred by a masternode?
645         if(
646             // is this a referred purchase?
647             _referredBy != 0x0000000000000000000000000000000000000000 &&
648 
649             // no cheating!
650             _referredBy != msg.sender &&
651             
652             // does the referrer have at least X whole tokens?
653             // i.e is the referrer a godly chad masternode
654             tokenBalanceLedger_[_referredBy] >= stakingRequirement
655         ){
656             uint256 _referralBonus = SafeMath.div(_dividends_to_holder, 3);
657             _dividends_to_holder = SafeMath.sub(_dividends_to_holder, _referralBonus);   
658             _fee = _dividends_to_holder * magnitude;
659             
660             // wealth redistribution
661             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
662         } 
663         
664         // we can't give people infinite ethereum
665         if(tokenSupply_ > 0){
666             
667             // add tokens to the pool
668             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
669  
670             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
671             profitPerShare_ += (_dividends_to_holder * magnitude / (tokenSupply_));
672             
673             // calculate the amount of tokens the customer receives over his purchase 
674             _fee = _fee - (_fee-(_amountOfTokens * (_dividends_to_holder * magnitude / (tokenSupply_))));
675         
676         } else {
677             // add tokens to the pool
678             tokenSupply_ = _amountOfTokens;
679         }
680         
681         // update circulating supply & the ledger address for the customer
682         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
683         
684         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
685         //really i know you think you do but you don't
686         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
687         payoutsTo_[msg.sender] += _updatedPayouts;
688         
689         // fire event
690         emit onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
691         
692         return _amountOfTokens;
693     }
694 
695     /**
696      * Calculate Token price based on an amount of incoming ethereum
697      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
698      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
699      */
700     function ethereumToTokens_(uint256 _ethereum)
701         internal
702         view
703         returns(uint256)
704     {
705         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
706         uint256 _tokensReceived = 
707          (
708             (
709                 // underflow attempts BTFO
710                 SafeMath.sub(
711                     (sqrt
712                         (
713                             (_tokenPriceInitial**2)
714                             +
715                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
716                             +
717                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
718                             +
719                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
720                         )
721                     ), _tokenPriceInitial
722                 )
723             )/(tokenPriceIncremental_)
724         )-(tokenSupply_)
725         ;
726   
727         return _tokensReceived;
728     }
729     
730     /**
731      * Calculate token sell value.
732      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
733      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
734      */
735      function tokensToEthereum_(uint256 _tokens)
736         internal
737         view
738         returns(uint256)
739     {
740 
741         uint256 tokens_ = (_tokens + 1e18);
742         uint256 _tokenSupply = (tokenSupply_ + 1e18);
743         uint256 _etherReceived =
744         (
745             // underflow attempts BTFO
746             SafeMath.sub(
747                 (
748                     (
749                         (
750                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
751                         )-tokenPriceIncremental_
752                     )*(tokens_ - 1e18)
753                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
754             )
755         /1e18);
756         return _etherReceived;
757     }
758     
759     
760     //This is where all your gas goes, sorry
761     //Not sorry, you probably only paid 1 gwei
762     function sqrt(uint x) internal pure returns (uint y) {
763         uint z = (x + 1) / 2;
764         y = x;
765         while (z < y) {
766             y = z;
767             z = (x / z + z) / 2;
768         }
769     }
770 }
771 
772 /**
773  * @title SafeMath
774  * @dev Math operations with safety checks that throw on error
775  */
776 library SafeMath {
777 
778     /**
779     * @dev Multiplies two numbers, throws on overflow.
780     */
781     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
782         if (a == 0) {
783             return 0;
784         }
785         uint256 c = a * b;
786         assert(c / a == b);
787         return c;
788     }
789 
790     /**
791     * @dev Integer division of two numbers, truncating the quotient.
792     */
793     function div(uint256 a, uint256 b) internal pure returns (uint256) {
794         // assert(b > 0); // Solidity automatically throws when dividing by 0
795         uint256 c = a / b;
796         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
797         return c;
798     }
799 
800     /**
801     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
802     */
803     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
804         assert(b <= a);
805         return a - b;
806     }
807 
808     /**
809     * @dev Adds two numbers, throws on overflow.
810     */
811     function add(uint256 a, uint256 b) internal pure returns (uint256) {
812         uint256 c = a + b;
813         assert(c >= a);
814         return c;
815     }
816 }