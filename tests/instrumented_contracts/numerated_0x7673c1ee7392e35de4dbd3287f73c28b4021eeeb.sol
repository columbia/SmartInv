1 pragma solidity ^0.4.20;
2 
3 contract DiamondClub {
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
35     modifier antiEarlyWhale(uint256 _amountOfEthereum){
36         address _customerAddress = msg.sender;
37         
38       
39         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
40             require(
41                 // is the customer in the ambassador list?
42                 ambassadors_[_customerAddress] == true &&
43                 
44                 // does the customer purchase exceed the max ambassador quota?
45                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
46                 
47             );
48             
49             // updated the accumulated quota    
50             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
51         
52             // execute
53             _;
54         } else {
55             // in case the ether count drops low, the ambassador phase won't reinitiate
56             onlyAmbassadors = false;
57             _;    
58         }
59         
60     }
61     
62     
63     /*==============================
64     =            EVENTS            =
65     ==============================*/
66     event onTokenPurchase(
67         address indexed customerAddress,
68         uint256 incomingEthereum,
69         uint256 tokensMinted,
70         address indexed referredBy
71     );
72     
73     event onTokenSell(
74         address indexed customerAddress,
75         uint256 tokensBurned,
76         uint256 ethereumEarned
77     );
78     
79     event onReinvestment(
80         address indexed customerAddress,
81         uint256 ethereumReinvested,
82         uint256 tokensMinted
83     );
84     
85     event onWithdraw(
86         address indexed customerAddress,
87         uint256 ethereumWithdrawn
88     );
89     
90     // ERC20
91     event Transfer(
92         address indexed from,
93         address indexed to,
94         uint256 tokens
95     );
96     
97     
98     /*=====================================
99     =            CONFIGURABLES            =
100     =====================================*/
101     string public name = "Diamond Club";
102     string public symbol = "DND";
103     uint8 constant public decimals = 18;
104     uint8 constant internal dividendFee_ = 10;
105     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
106     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
107     uint256 constant internal magnitude = 2**64;
108     
109     // proof of stake (defaults at 1 token)
110     uint256 public stakingRequirement = 1e18;
111     
112     // ambassador program
113     mapping(address => bool) internal ambassadors_;
114     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
115     uint256 constant internal ambassadorQuota_ = 1 ether;
116     
117     
118     
119    /*================================
120     =            DATASETS            =
121     ================================*/
122     // amount of shares for each address (scaled number)
123     mapping(address => uint256) internal tokenBalanceLedger_;
124     mapping(address => uint256) internal referralBalance_;
125     mapping(address => int256) internal payoutsTo_;
126     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
127     uint256 internal tokenSupply_ = 0;
128     uint256 internal profitPerShare_;
129     
130     // administrator list (see above on what they can do)
131     mapping(bytes32 => bool) public administrators;
132     
133     
134     bool public onlyAmbassadors = false;
135     
136     
137     /*=======================================
138     =            PUBLIC FUNCTIONS            =
139     =======================================*/
140     /*
141     * -- APPLICATION ENTRY POINTS --  
142     */
143     function DiamondClub()
144         public
145     {
146         // add administrators here
147         administrators[0x6228417259e5a2d6f640ea4ae0db8911bd8a80dd5443f58e52b6d10b790032f6] = true;
148 						 
149    
150         ambassadors_[0xf310F29E4f4A4ACD1A074B6f25C0Deef21324DF6] = true;
151                        
152     }
153     
154      
155     /**
156      * Converts all incoming Ethereum to tokens for the caller, and passes down the referral address (if any)
157      */
158     function buy(address _referredBy)
159         public
160         payable
161         returns(uint256)
162     {
163         purchaseTokens(msg.value, _referredBy);
164     }
165     
166     
167     function()
168         payable
169         public
170     {
171         purchaseTokens(msg.value, 0x0);
172     }
173     
174     /**
175      * Converts all of caller's dividends to tokens.
176      */
177     function reinvest()
178         onlyhodler()
179         public
180     {
181         // fetch dividends
182         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
183         
184         // pay out the dividends virtually
185         address _customerAddress = msg.sender;
186         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
187         
188         // retrieve ref. bonus
189         _dividends += referralBalance_[_customerAddress];
190         referralBalance_[_customerAddress] = 0;
191         
192         // dispatch a buy order with the virtualized "withdrawn dividends"
193         uint256 _tokens = purchaseTokens(_dividends, 0x0);
194         
195         // fire event
196         onReinvestment(_customerAddress, _dividends, _tokens);
197     }
198     
199     /**
200      * Alias of sell() and withdraw().
201      */
202     function exit()
203         public
204     {
205         // get token count for caller & sell them all
206         address _customerAddress = msg.sender;
207         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
208         if(_tokens > 0) sell(_tokens);
209         
210         
211         withdraw();
212     }
213 
214     /**
215      * Withdraws all of the callers earnings.
216      */
217     function withdraw()
218         onlyhodler()
219         public
220     {
221         // setup data
222         address _customerAddress = msg.sender;
223         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
224         
225         // update dividend tracker
226         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
227         
228         // add ref. bonus
229         _dividends += referralBalance_[_customerAddress];
230         referralBalance_[_customerAddress] = 0;
231         
232         // delivery service
233         _customerAddress.transfer(_dividends);
234         
235         // fire event
236         onWithdraw(_customerAddress, _dividends);
237     }
238     
239     /**
240      * Liquifies tokens to ethereum.
241      */
242     function sell(uint256 _amountOfTokens)
243         onlybelievers ()
244         public
245     {
246       
247         address _customerAddress = msg.sender;
248        
249         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
250         uint256 _tokens = _amountOfTokens;
251         uint256 _ethereum = tokensToEthereum_(_tokens);
252         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
253         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
254         
255         // burn the sold tokens
256         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
257         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
258         
259         // update dividends tracker
260         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
261         payoutsTo_[_customerAddress] -= _updatedPayouts;       
262         
263         // dividing by zero is a bad idea
264         if (tokenSupply_ > 0) {
265             // update the amount of dividends per token
266             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
267         }
268         
269         // fire event
270         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
271     }
272     
273     
274     /**
275      * Transfer tokens from the caller to a new holder.
276      * Remember, there's a 10% fee here as well.
277      */
278     function transfer(address _toAddress, uint256 _amountOfTokens)
279         onlybelievers ()
280         public
281         returns(bool)
282     {
283         // setup
284         address _customerAddress = msg.sender;
285         
286         // make sure we have the requested tokens
287      
288         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
289         
290         // withdraw all outstanding dividends first
291         if(myDividends(true) > 0) withdraw();
292         
293         // liquify 10% of the tokens that are transfered
294         // these are dispersed to shareholders
295         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
296         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
297         uint256 _dividends = tokensToEthereum_(_tokenFee);
298   
299         // burn the fee tokens
300         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
301 
302         // exchange tokens
303         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
304         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
305         
306         // update dividend trackers
307         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
308         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
309         
310         // disperse dividends among holders
311         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
312         
313         // fire event
314         Transfer(_customerAddress, _toAddress, _taxedTokens);
315         
316         // ERC20
317         return true;
318        
319     }
320     
321     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
322     /**
323      * administrator can manually disable the ambassador phase.
324      */
325     function disableInitialStage()
326         onlyAdministrator()
327         public
328     {
329         onlyAmbassadors = false;
330     }
331     
332    
333     function setAdministrator(bytes32 _identifier, bool _status)
334         onlyAdministrator()
335         public
336     {
337         administrators[_identifier] = _status;
338     }
339     
340    
341     function setStakingRequirement(uint256 _amountOfTokens)
342         onlyAdministrator()
343         public
344     {
345         stakingRequirement = _amountOfTokens;
346     }
347     
348     
349     function setName(string _name)
350         onlyAdministrator()
351         public
352     {
353         name = _name;
354     }
355     
356    
357     function setSymbol(string _symbol)
358         onlyAdministrator()
359         public
360     {
361         symbol = _symbol;
362     }
363 
364     
365     /*----------  HELPERS AND CALCULATORS  ----------*/
366     /**
367      * Method to view the current Ethereum stored in the contract
368      * Example: totalEthereumBalance()
369      */
370     function totalEthereumBalance()
371         public
372         view
373         returns(uint)
374     {
375         return this.balance;
376     }
377     
378     /**
379      * Retrieve the total token supply.
380      */
381     function totalSupply()
382         public
383         view
384         returns(uint256)
385     {
386         return tokenSupply_;
387     }
388     
389     /**
390      * Retrieve the tokens owned by the caller.
391      */
392     function myTokens()
393         public
394         view
395         returns(uint256)
396     {
397         address _customerAddress = msg.sender;
398         return balanceOf(_customerAddress);
399     }
400     
401     /**
402      * Retrieve the dividends owned by the caller.
403        */ 
404     function myDividends(bool _includeReferralBonus) 
405         public 
406         view 
407         returns(uint256)
408     {
409         address _customerAddress = msg.sender;
410         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
411     }
412     
413     /**
414      * Retrieve the token balance of any single address.
415      */
416     function balanceOf(address _customerAddress)
417         view
418         public
419         returns(uint256)
420     {
421         return tokenBalanceLedger_[_customerAddress];
422     }
423     
424     /**
425      * Retrieve the dividend balance of any single address.
426      */
427     function dividendsOf(address _customerAddress)
428         view
429         public
430         returns(uint256)
431     {
432         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
433     }
434     
435     /**
436      * Return the buy price of 1 individual token.
437      */
438     function sellPrice() 
439         public 
440         view 
441         returns(uint256)
442     {
443        
444         if(tokenSupply_ == 0){
445             return tokenPriceInitial_ - tokenPriceIncremental_;
446         } else {
447             uint256 _ethereum = tokensToEthereum_(1e18);
448             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
449             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
450             return _taxedEthereum;
451         }
452     }
453     
454     /**
455      * Return the sell price of 1 individual token.
456      */
457     function buyPrice() 
458         public 
459         view 
460         returns(uint256)
461     {
462         
463         if(tokenSupply_ == 0){
464             return tokenPriceInitial_ + tokenPriceIncremental_;
465         } else {
466             uint256 _ethereum = tokensToEthereum_(1e18);
467             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
468             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
469             return _taxedEthereum;
470         }
471     }
472     
473    
474     function calculateTokensReceived(uint256 _ethereumToSpend) 
475         public 
476         view 
477         returns(uint256)
478     {
479         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
480         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
481         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
482         
483         return _amountOfTokens;
484     }
485     
486    
487     function calculateEthereumReceived(uint256 _tokensToSell) 
488         public 
489         view 
490         returns(uint256)
491     {
492         require(_tokensToSell <= tokenSupply_);
493         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
494         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
495         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
496         return _taxedEthereum;
497     }
498     
499     
500     /*==========================================
501     =            INTERNAL FUNCTIONS            =
502     ==========================================*/
503     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
504         antiEarlyWhale(_incomingEthereum)
505         internal
506         returns(uint256)
507     {
508         // data setup
509         address _customerAddress = msg.sender;
510         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
511         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
512         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
513         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
514         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
515         uint256 _fee = _dividends * magnitude;
516  
517       
518         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
519         
520         // is the user referred by a karmalink?
521         if(
522             // is this a referred purchase?
523             _referredBy != 0x0000000000000000000000000000000000000000 &&
524 
525             // no cheating!
526             _referredBy != _customerAddress &&
527             
528         
529             tokenBalanceLedger_[_referredBy] >= stakingRequirement
530         ){
531             // wealth redistribution
532             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
533         } else {
534             // no ref purchase
535             // add the referral bonus back to the global dividends cake
536             _dividends = SafeMath.add(_dividends, _referralBonus);
537             _fee = _dividends * magnitude;
538         }
539         
540         // we can't give people infinite ethereum
541         if(tokenSupply_ > 0){
542             
543             // add tokens to the pool
544             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
545  
546             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
547             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
548             
549             // calculate the amount of tokens the customer receives over his purchase 
550             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
551         
552         } else {
553             // add tokens to the pool
554             tokenSupply_ = _amountOfTokens;
555         }
556         
557         // update circulating supply & the ledger address for the customer
558         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
559         
560         
561         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
562         payoutsTo_[_customerAddress] += _updatedPayouts;
563         
564         // fire event
565         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
566         
567         return _amountOfTokens;
568     }
569 
570     /**
571      * Calculate Token price based on an amount of incoming ethereum
572      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
573      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
574      */
575     function ethereumToTokens_(uint256 _ethereum)
576         internal
577         view
578         returns(uint256)
579     {
580         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
581         uint256 _tokensReceived = 
582          (
583             (
584                 // underflow attempts BTFO
585                 SafeMath.sub(
586                     (sqrt
587                         (
588                             (_tokenPriceInitial**2)
589                             +
590                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
591                             +
592                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
593                             +
594                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
595                         )
596                     ), _tokenPriceInitial
597                 )
598             )/(tokenPriceIncremental_)
599         )-(tokenSupply_)
600         ;
601   
602         return _tokensReceived;
603     }
604     
605     /**
606      * Calculate token sell value.
607           */
608      function tokensToEthereum_(uint256 _tokens)
609         internal
610         view
611         returns(uint256)
612     {
613 
614         uint256 tokens_ = (_tokens + 1e18);
615         uint256 _tokenSupply = (tokenSupply_ + 1e18);
616         uint256 _etherReceived =
617         (
618             // underflow attempts BTFO
619             SafeMath.sub(
620                 (
621                     (
622                         (
623                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
624                         )-tokenPriceIncremental_
625                     )*(tokens_ - 1e18)
626                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
627             )
628         /1e18);
629         return _etherReceived;
630     }
631     
632     
633     
634     function sqrt(uint x) internal pure returns (uint y) {
635         uint z = (x + 1) / 2;
636         y = x;
637         while (z < y) {
638             y = z;
639             z = (x / z + z) / 2;
640         }
641     }
642 }
643 
644 /**
645  * @title SafeMath
646  * @dev Math operations with safety checks that throw on error
647  */
648 library SafeMath {
649 
650    
651     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
652         if (a == 0) {
653             return 0;
654         }
655         uint256 c = a * b;
656         assert(c / a == b);
657         return c;
658     }
659 
660    
661     function div(uint256 a, uint256 b) internal pure returns (uint256) {
662         // assert(b > 0); // Solidity automatically throws when dividing by 0
663         uint256 c = a / b;
664         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
665         return c;
666     }
667 
668     
669     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
670         assert(b <= a);
671         return a - b;
672     }
673 
674    
675     function add(uint256 a, uint256 b) internal pure returns (uint256) {
676         uint256 c = a + b;
677         assert(c >= a);
678         return c;
679     }
680 
681     
682 }