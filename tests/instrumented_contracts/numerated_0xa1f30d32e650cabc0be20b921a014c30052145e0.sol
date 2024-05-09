1 pragma solidity ^0.4.20;
2 
3 /*
4 CHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKA
5 CHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKA
6 CHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKA
7 CHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKA
8 CHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKA
9 CHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKA
10 CHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKA
11 CHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKA
12 CHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKA
13 CHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKA
14 CHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKA
15 CHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKACHEWBAKA
16 */
17 
18 contract Chewbaka {
19     
20     modifier onlyBagholders() {
21         require(myTokens() > 0);
22         _;
23     }
24     
25    
26     modifier onlyStronghands() {
27         require(myDividends(true) > 0);
28         _;
29     }
30     
31    
32     modifier onlyAdministrator(){
33         address _customerAddress = msg.sender;
34         require(administrators[keccak256(_customerAddress)]);
35         _;
36     }
37     
38     
39    
40     modifier antiEarlyWhale(uint256 _amountOfEthereum){
41         address _customerAddress = msg.sender;
42         
43        
44         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
45             require(
46                 
47                 ambassadors_[_customerAddress] == true &&
48                 
49                 
50                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
51                 
52             );
53             
54                
55             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
56         
57             
58             _;
59         } else {
60             
61             onlyAmbassadors = false;
62             _;    
63         }
64         
65     }
66     
67     
68     
69     event onTokenPurchase(
70         address indexed customerAddress,
71         uint256 incomingEthereum,
72         uint256 tokensMinted,
73         address indexed referredBy
74     );
75     
76     event onTokenSell(
77         address indexed customerAddress,
78         uint256 tokensBurned,
79         uint256 ethereumEarned
80     );
81     
82     event onReinvestment(
83         address indexed customerAddress,
84         uint256 ethereumReinvested,
85         uint256 tokensMinted
86     );
87     
88     event onWithdraw(
89         address indexed customerAddress,
90         uint256 ethereumWithdrawn
91     );
92     
93     // ERC20
94     event Transfer(
95         address indexed from,
96         address indexed to,
97         uint256 tokens
98     );
99     
100     
101    
102     string public name = "CHEWY";
103     string public symbol = "CHEWY";
104     uint8 constant public decimals = 18;
105     uint8 constant internal dividendFee_ = 3;
106     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
107     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
108     uint256 constant internal magnitude = 2**64;
109     
110     
111     uint256 public stakingRequirement = 5e18;
112     
113    
114     mapping(address => bool) internal ambassadors_;
115     uint256 constant internal ambassadorMaxPurchase_ = 10 ether;
116     uint256 constant internal ambassadorQuota_ = 10 ether;
117     
118     
119     
120    
121     mapping(address => uint256) internal tokenBalanceLedger_;
122     mapping(address => uint256) internal referralBalance_;
123     mapping(address => int256) internal payoutsTo_;
124     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
125     uint256 internal tokenSupply_ = 0;
126     uint256 internal profitPerShare_;
127     
128    
129     mapping(bytes32 => bool) public administrators;
130     
131    
132     bool public onlyAmbassadors = false;
133     
134 
135 
136    
137     function Chewbaka()
138         public
139     {
140        
141         administrators[0x235910f4682cfe7250004430a4ffb5ac78f5217e1f6a4bf99c937edf757c3330] = true;
142         
143         
144         
145         ambassadors_[0x6405C296d5728de46517609B78DA3713097163dB] = true;
146         
147         
148        
149         ambassadors_[0x15Fda64fCdbcA27a60Aa8c6ca882Aa3e1DE4Ea41] = true;
150          
151         ambassadors_[0x448D9Ae89DF160392Dd0DD5dda66952999390D50] = true;
152         
153     
154          
155          
156         
157         
158      
159 
160     }
161     
162      
163     /**
164      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
165      */
166     function buy(address _referredBy)
167         public
168         payable
169         returns(uint256)
170     {
171         purchaseTokens(msg.value, _referredBy);
172     }
173     
174     /**
175      * Fallback function to handle ethereum that was send straight to the contract
176      * Unfortunately we cannot use a referral address this way.
177      */
178     function()
179         payable
180         public
181     {
182         purchaseTokens(msg.value, 0x0);
183     }
184     
185     /**
186      * Converts all of caller's dividends to tokens.
187      */
188     function reinvest()
189         onlyStronghands()
190         public
191     {
192        
193         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
194         
195         
196         address _customerAddress = msg.sender;
197         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
198         
199        
200         _dividends += referralBalance_[_customerAddress];
201         referralBalance_[_customerAddress] = 0;
202         
203         
204         uint256 _tokens = purchaseTokens(_dividends, 0x0);
205         
206         
207         onReinvestment(_customerAddress, _dividends, _tokens);
208     }
209     
210     /**
211      * Alias of sell() and withdraw().
212      */
213     function exit()
214         public
215     {
216         
217         address _customerAddress = msg.sender;
218         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
219         if(_tokens > 0) sell(_tokens);
220         
221        
222         withdraw();
223     }
224 
225     /**
226      * Withdraws all of the callers earnings.
227      */
228     function withdraw()
229         onlyStronghands()
230         public
231     {
232        
233         address _customerAddress = msg.sender;
234         uint256 _dividends = myDividends(false); 
235         
236        
237         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
238         
239         
240         _dividends += referralBalance_[_customerAddress];
241         referralBalance_[_customerAddress] = 0;
242         
243        
244         _customerAddress.transfer(_dividends);
245         
246         
247         onWithdraw(_customerAddress, _dividends);
248     }
249     
250     /**
251      * Liquifies tokens to ethereum.
252      */
253     function sell(uint256 _amountOfTokens)
254         onlyBagholders()
255         public
256     {
257         
258         address _customerAddress = msg.sender;
259         
260         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
261         uint256 _tokens = _amountOfTokens;
262         uint256 _ethereum = tokensToEthereum_(_tokens);
263         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
264         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
265         
266         
267         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
268         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
269         
270         
271         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
272         payoutsTo_[_customerAddress] -= _updatedPayouts;       
273         
274         
275         if (tokenSupply_ > 0) {
276             
277             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
278         }
279         
280         
281         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
282     }
283     
284     
285     /**
286      * Transfer tokens from the caller to a new holder.
287      * Remember, there's a 10% fee here as well.
288      */
289     function transfer(address _toAddress, uint256 _amountOfTokens)
290         onlyBagholders()
291         public
292         returns(bool)
293     {
294         
295         address _customerAddress = msg.sender;
296         
297         
298         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
299         
300         
301         if(myDividends(true) > 0) withdraw();
302         
303 
304         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
305         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
306         uint256 _dividends = tokensToEthereum_(_tokenFee);
307   
308        
309         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
310 
311         
312         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
313         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
314         
315        
316         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
317         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
318         
319         
320         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
321         
322        
323         Transfer(_customerAddress, _toAddress, _taxedTokens);
324         
325        
326         return true;
327        
328     }
329     
330     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
331     /**
332      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
333      */
334     function disableInitialStage()
335         onlyAdministrator()
336         public
337     {
338         onlyAmbassadors = false;
339     }
340     
341     /**
342      * In case one of us dies, we need to replace ourselves.
343      */
344     function setAdministrator(bytes32 _identifier, bool _status)
345         onlyAdministrator()
346         public
347     {
348         administrators[_identifier] = _status;
349     }
350     
351     /**
352      * Precautionary measures in case we need to adjust the masternode rate.
353      */
354     function setStakingRequirement(uint256 _amountOfTokens)
355         onlyAdministrator()
356         public
357     {
358         stakingRequirement = _amountOfTokens;
359     }
360     
361     /**
362      * If we want to rebrand, we can.
363      */
364     function setName(string _name)
365         onlyAdministrator()
366         public
367     {
368         name = _name;
369     }
370     
371     /**
372      * If we want to rebrand, we can.
373      */
374     function setSymbol(string _symbol)
375         onlyAdministrator()
376         public
377     {
378         symbol = _symbol;
379     }
380 
381     
382     /*----------  HELPERS AND CALCULATORS  ----------*/
383     /**
384      * Method to view the current Ethereum stored in the contract
385      * Example: totalEthereumBalance()
386      */
387     function totalEthereumBalance()
388         public
389         view
390         returns(uint)
391     {
392         return this.balance;
393     }
394     
395     /**
396      * Retrieve the total token supply.
397      */
398     function totalSupply()
399         public
400         view
401         returns(uint256)
402     {
403         return tokenSupply_;
404     }
405     
406     /**
407      * Retrieve the tokens owned by the caller.
408      */
409     function myTokens()
410         public
411         view
412         returns(uint256)
413     {
414         address _customerAddress = msg.sender;
415         return balanceOf(_customerAddress);
416     }
417     
418     /**
419      * Retrieve the dividends owned by the caller.
420      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
421      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
422      * But in the internal calculations, we want them separate. 
423      */ 
424     function myDividends(bool _includeReferralBonus) 
425         public 
426         view 
427         returns(uint256)
428     {
429         address _customerAddress = msg.sender;
430         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
431     }
432     
433     /**
434      * Retrieve the token balance of any single address.
435      */
436     function balanceOf(address _customerAddress)
437         view
438         public
439         returns(uint256)
440     {
441         return tokenBalanceLedger_[_customerAddress];
442     }
443     
444     /**
445      * Retrieve the dividend balance of any single address.
446      */
447     function dividendsOf(address _customerAddress)
448         view
449         public
450         returns(uint256)
451     {
452         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
453     }
454     
455     /**
456      * Return the buy price of 1 individual token.
457      */
458     function sellPrice() 
459         public 
460         view 
461         returns(uint256)
462     {
463         // our calculation relies on the token supply, so we need supply. Doh.
464         if(tokenSupply_ == 0){
465             return tokenPriceInitial_ - tokenPriceIncremental_;
466         } else {
467             uint256 _ethereum = tokensToEthereum_(1e18);
468             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
469             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
470             return _taxedEthereum;
471         }
472     }
473     
474     /**
475      * Return the sell price of 1 individual token.
476      */
477     function buyPrice() 
478         public 
479         view 
480         returns(uint256)
481     {
482         // our calculation relies on the token supply, so we need supply. Doh.
483         if(tokenSupply_ == 0){
484             return tokenPriceInitial_ + tokenPriceIncremental_;
485         } else {
486             uint256 _ethereum = tokensToEthereum_(1e18);
487             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
488             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
489             return _taxedEthereum;
490         }
491     }
492     
493     /**
494      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
495      */
496     function calculateTokensReceived(uint256 _ethereumToSpend) 
497         public 
498         view 
499         returns(uint256)
500     {
501         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
502         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
503         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
504         
505         return _amountOfTokens;
506     }
507     
508     /**
509      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
510      */
511     function calculateEthereumReceived(uint256 _tokensToSell) 
512         public 
513         view 
514         returns(uint256)
515     {
516         require(_tokensToSell <= tokenSupply_);
517         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
518         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
519         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
520         return _taxedEthereum;
521     }
522     
523     
524     /*==========================================
525     =            INTERNAL FUNCTIONS            =
526     ==========================================*/
527     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
528         antiEarlyWhale(_incomingEthereum)
529         internal
530         returns(uint256)
531     {
532         // data setup
533         address _customerAddress = msg.sender;
534         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
535         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
536         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
537         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
538         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
539         uint256 _fee = _dividends * magnitude;
540  
541         // no point in continuing execution if OP is a poorfag russian hacker
542         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
543         // (or hackers)
544         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
545         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
546         
547         // is the user referred by a masternode?
548         if(
549             // is this a referred purchase?
550             _referredBy != 0x0000000000000000000000000000000000000000 &&
551 
552             // no cheating!
553             _referredBy != _customerAddress &&
554             
555             // does the referrer have at least X whole tokens?
556             // i.e is the referrer a godly chad masternode
557             tokenBalanceLedger_[_referredBy] >= stakingRequirement
558         ){
559             // wealth redistribution
560             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
561         } else {
562             // no ref purchase
563             // add the referral bonus back to the global dividends cake
564             _dividends = SafeMath.add(_dividends, _referralBonus);
565             _fee = _dividends * magnitude;
566         }
567         
568         // we can't give people infinite ethereum
569         if(tokenSupply_ > 0){
570             
571             // add tokens to the pool
572             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
573  
574             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
575             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
576             
577             // calculate the amount of tokens the customer receives over his purchase 
578             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
579         
580         } else {
581             // add tokens to the pool
582             tokenSupply_ = _amountOfTokens;
583         }
584         
585         // update circulating supply & the ledger address for the customer
586         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
587         
588         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
589         //really i know you think you do but you don't
590         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
591         payoutsTo_[_customerAddress] += _updatedPayouts;
592         
593         // fire event
594         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
595         
596         return _amountOfTokens;
597     }
598 
599     /**
600      * Calculate Token price based on an amount of incoming ethereum
601      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
602      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
603      */
604     function ethereumToTokens_(uint256 _ethereum)
605         internal
606         view
607         returns(uint256)
608     {
609         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
610         uint256 _tokensReceived = 
611          (
612             (
613                 // underflow attempts BTFO
614                 SafeMath.sub(
615                     (sqrt
616                         (
617                             (_tokenPriceInitial**2)
618                             +
619                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
620                             +
621                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
622                             +
623                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
624                         )
625                     ), _tokenPriceInitial
626                 )
627             )/(tokenPriceIncremental_)
628         )-(tokenSupply_)
629         ;
630   
631         return _tokensReceived;
632     }
633     
634     /**
635      * Calculate token sell value.
636      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
637      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
638      */
639      function tokensToEthereum_(uint256 _tokens)
640         internal
641         view
642         returns(uint256)
643     {
644 
645         uint256 tokens_ = (_tokens + 1e18);
646         uint256 _tokenSupply = (tokenSupply_ + 1e18);
647         uint256 _etherReceived =
648         (
649             // underflow attempts BTFO
650             SafeMath.sub(
651                 (
652                     (
653                         (
654                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
655                         )-tokenPriceIncremental_
656                     )*(tokens_ - 1e18)
657                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
658             )
659         /1e18);
660         return _etherReceived;
661     }
662     
663     
664     //This is where all your gas goes, sorry
665     //Not sorry, you probably only paid 1 gwei
666     function sqrt(uint x) internal pure returns (uint y) {
667         uint z = (x + 1) / 2;
668         y = x;
669         while (z < y) {
670             y = z;
671             z = (x / z + z) / 2;
672         }
673     }
674 }
675 
676 /**
677  * @title SafeMath
678  * @dev Math operations with safety checks that throw on error
679  */
680 library SafeMath {
681 
682     /**
683     * @dev Multiplies two numbers, throws on overflow.
684     */
685     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
686         if (a == 0) {
687             return 0;
688         }
689         uint256 c = a * b;
690         assert(c / a == b);
691         return c;
692     }
693 
694     /**
695     * @dev Integer division of two numbers, truncating the quotient.
696     */
697     function div(uint256 a, uint256 b) internal pure returns (uint256) {
698         // assert(b > 0); // Solidity automatically throws when dividing by 0
699         uint256 c = a / b;
700         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
701         return c;
702     }
703 
704     /**
705     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
706     */
707     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
708         assert(b <= a);
709         return a - b;
710     }
711 
712     /**
713     * @dev Adds two numbers, throws on overflow.
714     */
715     function add(uint256 a, uint256 b) internal pure returns (uint256) {
716         uint256 c = a + b;
717         assert(c >= a);
718         return c;
719     }
720 }