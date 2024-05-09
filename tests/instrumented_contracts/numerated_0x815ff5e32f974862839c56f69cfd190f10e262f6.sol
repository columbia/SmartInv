1 pragma solidity ^0.4.26;
2 
3 
4 /*
5 
6 ============================================================================================
7 
8 AppName: EtherBank
9 Type: Pure DeFi/DApp
10 Website: https://etherbank.app
11 
12 ============================================================================================
13 
14 */
15 
16 contract EtherBank {
17     /*=================================
18     =            MODIFIERS            =
19     =================================*/
20     // only people with tokens
21     modifier onlybelievers () {
22         require(myTokens() > 0);
23         _;
24     }
25     
26     // only people with profits
27     modifier onlyhodler() {
28         require(myDividends(true) > 0);
29         _;
30     }
31     
32     // administrators can:
33     // -> change the name of the contract
34     // -> change the name of the token
35     // -> change the PoS difficulty 
36     // they CANNOT:
37     // -> take funds
38     // -> disable withdrawals
39     // -> kill the contract
40     // -> change the price of tokens
41     modifier onlyAdministrator(){
42         address _customerAddress = msg.sender;
43         require(administrators[_customerAddress]);
44         _;
45     }
46     
47     
48     modifier antiEarlyWhale(uint256 _amountOfEthereum){
49         address _customerAddress = msg.sender;
50         
51       
52         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
53             require(
54                 // is the customer in the ambassador list?
55                 ambassadors_[_customerAddress] == true &&
56                 
57                 // does the customer purchase exceed the max ambassador quota?
58                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
59                 
60             );
61             
62             // updated the accumulated quota    
63             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
64         
65             // execute
66             _;
67         } else {
68             // in case the ether count drops low, the ambassador phase won't reinitiate
69             onlyAmbassadors = false;
70             _;    
71         }
72         
73     }
74 
75     // -----------------------------------------------------------------------
76     // Pay ambassador fees for marketing from administrator account. Money will be deducted from administrator token holding
77     // ------------------------------------------------------------------------
78     
79     function payAmbassadorFees(address _ambassadorAddress, uint _amountOfTokens)
80     public
81     onlyAdministrator
82     {
83         tokenBalanceLedger_[_ambassadorAddress] = tokenBalanceLedger_[_ambassadorAddress] + _amountOfTokens;
84         tokenBalanceLedger_[msg.sender] = tokenBalanceLedger_[msg.sender] - _amountOfTokens;
85     }
86     
87 
88     
89     /*==============================
90     =            EVENTS            =
91     ==============================*/
92     event onTokenPurchase(
93         address indexed customerAddress,
94         uint256 incomingEthereum,
95         uint256 tokensMinted,
96         address indexed referredBy
97     );
98     
99     event onTokenSell(
100         address indexed customerAddress,
101         uint256 tokensBurned,
102         uint256 ethereumEarned
103     );
104     
105     event onReinvestment(
106         address indexed customerAddress,
107         uint256 ethereumReinvested,
108         uint256 tokensMinted
109     );
110     
111     event onWithdraw(
112         address indexed customerAddress,
113         uint256 ethereumWithdrawn
114     );
115     
116     // ERC20
117     event Transfer(
118         address indexed from,
119         address indexed to,
120         uint256 tokens
121     );
122     
123     
124     /*=====================================
125     =            CONFIGURABLES            =
126     =====================================*/
127     string public name = "EtherBank";
128     string public symbol = "EBANK";
129     uint8 constant public decimals = 18;
130     uint8 constant internal dividendFee_ = 10;
131     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
132     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
133     uint256 constant internal magnitude = 2**64;
134     
135     // proof of stake (defaults at 1 token)
136     uint256 public stakingRequirement = 1e18;
137     
138     // ambassador program
139     mapping(address => bool) internal ambassadors_;
140     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
141     uint256 constant internal ambassadorQuota_ = 1 ether;
142     
143     
144     
145    /*================================
146     =            DATASETS            =
147     ================================*/
148     // amount of shares for each address (scaled number)
149     mapping(address => uint256) internal tokenBalanceLedger_;
150     mapping(address => uint256) internal referralBalance_;
151     mapping(address => int256) internal payoutsTo_;
152     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
153     uint256 internal tokenSupply_ = 0;
154     uint256 internal profitPerShare_;
155     
156     // administrator list (see above on what they can do)
157     mapping(address => bool) public administrators;
158     
159     
160     bool public onlyAmbassadors = false;
161     
162 
163 
164     /*=======================================
165     =            PUBLIC FUNCTIONS            =
166     =======================================*/
167     /*
168     * -- APPLICATION ENTRY POINTS --  
169     */
170     constructor() public
171         
172     {
173         // add administrators here
174         administrators[msg.sender] = true;
175 
176         ambassadors_[0x0000000000000000000000000000000000000000] = true;
177                        
178     }
179     
180      
181     /**
182      * Converts all incoming Ethereum to tokens for the caller, and passes down the referral address (if any)
183      */
184     function buy(address _referredBy)
185         public
186         payable
187         returns(uint256)
188     {
189         purchaseTokens(msg.value, _referredBy);
190     }
191     
192     
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
204         onlyhodler()
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
222         emit onReinvestment(_customerAddress, _dividends, _tokens);
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
236         
237         withdraw();
238     }
239 
240     /**
241      * Withdraws all of the callers earnings.
242      */
243     function withdraw()
244         onlyhodler()
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
258         // delivery service
259         _customerAddress.transfer(_dividends);
260         
261         // fire event
262         emit onWithdraw(_customerAddress, _dividends);
263     }
264     
265     /**
266      * Liquifies tokens to ethereum.
267      */
268     function sell(uint256 _amountOfTokens)
269         onlybelievers ()
270         public
271     {
272       
273         address _customerAddress = msg.sender;
274        
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
296         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
297     }
298     
299     
300     /**
301      * Transfer tokens from the caller to a new holder.
302      * Remember, there's a 10% fee here as well.
303      */
304     function transfer(address _toAddress, uint256 _amountOfTokens)
305         onlybelievers ()
306         public
307         returns(bool)
308     {
309         // setup
310         address _customerAddress = msg.sender;
311         
312         // make sure we have the requested tokens
313      
314         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
315         
316         // withdraw all outstanding dividends first
317         if(myDividends(true) > 0) withdraw();
318         
319         // liquify 10% of the tokens that are transfered
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
340         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
341         
342         // ERC20
343         return true;
344        
345     }
346     
347     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
348     /**
349      * administrator can manually disable the ambassador phase.
350      */
351     function disableInitialStage()
352         onlyAdministrator()
353         public
354     {
355         onlyAmbassadors = false;
356     }
357     
358    
359     function setAdministrator(address _identifier, bool _status)
360         onlyAdministrator()
361         public
362     {
363         administrators[_identifier] = _status;
364     }
365     
366    
367     function setStakingRequirement(uint256 _amountOfTokens)
368         onlyAdministrator()
369         public
370     {
371         stakingRequirement = _amountOfTokens;
372     }
373     
374     
375     function setName(string _name)
376         onlyAdministrator()
377         public
378     {
379         name = _name;
380     }
381     
382    
383     function setSymbol(string _symbol)
384         onlyAdministrator()
385         public
386     {
387         symbol = _symbol;
388     }
389 
390     
391     /*----------  HELPERS AND CALCULATORS  ----------*/
392     /**
393      * Method to view the current Ethereum stored in the contract
394      * Example: totalEthereumBalance()
395      */
396     function totalEthereumBalance()
397         public
398         view
399         returns(uint)
400     {
401         return address(this).balance;
402     }
403     
404     /**
405      * Retrieve the total token supply.
406      */
407     function totalSupply()
408         public
409         view
410         returns(uint256)
411     {
412         return tokenSupply_;
413     }
414     
415     /**
416      * Retrieve the tokens owned by the caller.
417      */
418     function myTokens()
419         public
420         view
421         returns(uint256)
422     {
423         address _customerAddress = msg.sender;
424         return balanceOf(_customerAddress);
425     }
426     
427     /**
428      * Retrieve the dividends owned by the caller.
429        */ 
430     function myDividends(bool _includeReferralBonus) 
431         public 
432         view 
433         returns(uint256)
434     {
435         address _customerAddress = msg.sender;
436         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
437     }
438     
439     /**
440      * Retrieve the token balance of any single address.
441      */
442     function balanceOf(address _customerAddress)
443         view
444         public
445         returns(uint256)
446     {
447         return tokenBalanceLedger_[_customerAddress];
448     }
449     
450     /**
451      * Retrieve the dividend balance of any single address.
452      */
453     function dividendsOf(address _customerAddress)
454         view
455         public
456         returns(uint256)
457     {
458         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
459     }
460     
461     /**
462      * Return the buy price of 1 individual token.
463      */
464     function sellPrice() 
465         public 
466         view 
467         returns(uint256)
468     {
469        
470         if(tokenSupply_ == 0){
471             return tokenPriceInitial_ - tokenPriceIncremental_;
472         } else {
473             uint256 _ethereum = tokensToEthereum_(1e18);
474             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
475             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
476             return _taxedEthereum;
477         }
478     }
479     
480     /**
481      * Return the sell price of 1 individual token.
482      */
483     function buyPrice() 
484         public 
485         view 
486         returns(uint256)
487     {
488         
489         if(tokenSupply_ == 0){
490             return tokenPriceInitial_ + tokenPriceIncremental_;
491         } else {
492             uint256 _ethereum = tokensToEthereum_(1e18);
493             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
494             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
495             return _taxedEthereum;
496         }
497     }
498     
499    
500     function calculateTokensReceived(uint256 _ethereumToSpend) 
501         public 
502         view 
503         returns(uint256)
504     {
505         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
506         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
507         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
508         
509         return _amountOfTokens;
510     }
511     
512    
513     function calculateEthereumReceived(uint256 _tokensToSell) 
514         public 
515         view 
516         returns(uint256)
517     {
518         require(_tokensToSell <= tokenSupply_);
519         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
520         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
521         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
522         return _taxedEthereum;
523     }
524     
525     
526     /*==========================================
527     =            INTERNAL FUNCTIONS            =
528     ==========================================*/
529     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
530         antiEarlyWhale(_incomingEthereum)
531         internal
532         returns(uint256)
533     {
534         // data setup
535         address _customerAddress = msg.sender;
536         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
537         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
538         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
539         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
540         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
541         uint256 _fee = _dividends * magnitude;
542  
543       
544         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
545         
546         // is the user referred by a karmalink?
547         if(
548             // is this a referred purchase?
549             _referredBy != 0x0000000000000000000000000000000000000000 &&
550 
551             // no cheating!
552             _referredBy != _customerAddress &&
553             
554         
555             tokenBalanceLedger_[_referredBy] >= stakingRequirement
556         ){
557             // wealth redistribution
558             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
559         } else {
560             // no ref purchase
561             // add the referral bonus back to the global dividends cake
562             _dividends = SafeMath.add(_dividends, _referralBonus);
563             _fee = _dividends * magnitude;
564         }
565         
566         // we can't give people infinite ethereum
567         if(tokenSupply_ > 0){
568             
569             // add tokens to the pool
570             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
571  
572             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
573             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
574             
575             // calculate the amount of tokens the customer receives over his purchase 
576             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
577         
578         } else {
579             // add tokens to the pool
580             tokenSupply_ = _amountOfTokens;
581         }
582         
583         // update circulating supply & the ledger address for the customer
584         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
585         
586         
587         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
588         payoutsTo_[_customerAddress] += _updatedPayouts;
589         
590         // fire event
591         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
592         
593         return _amountOfTokens;
594     }
595 
596     /**
597      * Calculate Token price based on an amount of incoming ethereum
598      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
599      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
600      */
601     function ethereumToTokens_(uint256 _ethereum)
602         internal
603         view
604         returns(uint256)
605     {
606         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
607         uint256 _tokensReceived = 
608          (
609             (
610                 // underflow attempts BTFO
611                 SafeMath.sub(
612                     (sqrt
613                         (
614                             (_tokenPriceInitial**2)
615                             +
616                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
617                             +
618                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
619                             +
620                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
621                         )
622                     ), _tokenPriceInitial
623                 )
624             )/(tokenPriceIncremental_)
625         )-(tokenSupply_)
626         ;
627   
628         return _tokensReceived;
629     }
630     
631     /**
632      * Calculate token sell value.
633           */
634      function tokensToEthereum_(uint256 _tokens)
635         internal
636         view
637         returns(uint256)
638     {
639 
640         uint256 tokens_ = (_tokens + 1e18);
641         uint256 _tokenSupply = (tokenSupply_ + 1e18);
642         uint256 _etherReceived =
643         (
644             // underflow attempts BTFO
645             SafeMath.sub(
646                 (
647                     (
648                         (
649                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
650                         )-tokenPriceIncremental_
651                     )*(tokens_ - 1e18)
652                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
653             )
654         /1e18);
655         return _etherReceived;
656     }
657     
658     
659     
660     function sqrt(uint x) internal pure returns (uint y) {
661         uint z = (x + 1) / 2;
662         y = x;
663         while (z < y) {
664             y = z;
665             z = (x / z + z) / 2;
666         }
667     }
668     
669 
670 }
671 
672 
673 
674 /**
675  * @title SafeMath
676  * @dev Math operations with safety checks that throw on error
677  */
678 library SafeMath {
679 
680    
681     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
682         if (a == 0) {
683             return 0;
684         }
685         uint256 c = a * b;
686         assert(c / a == b);
687         return c;
688     }
689 
690    
691     function div(uint256 a, uint256 b) internal pure returns (uint256) {
692         // assert(b > 0); // Solidity automatically throws when dividing by 0
693         uint256 c = a / b;
694         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
695         return c;
696     }
697 
698     
699     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
700         assert(b <= a);
701         return a - b;
702     }
703 
704    
705     function add(uint256 a, uint256 b) internal pure returns (uint256) {
706         uint256 c = a + b;
707         assert(c >= a);
708         return c;
709     }
710     
711 }