1 /**
2  *Submitted for verification at Etherscan.io on 2020-07-23
3 */
4 
5 pragma solidity ^0.4.20;
6 
7 
8 
9 contract FamilyOnlyToken {
10     /*=================================
11     =            MODIFIERS            =
12     =================================*/
13     // only people with tokens
14     modifier onlybelievers () {
15         require(myTokens() > 0);
16         _;
17     }
18     
19     // only people with profits
20     modifier onlyhodler() {
21         require(myDividends(true) > 0);
22         _;
23     }
24     
25     // administrators can:
26     // -> change the name of the contract
27     // -> change the name of the token
28     // -> change the PoS difficulty 
29     // they CANNOT:
30     // -> take funds
31     // -> disable withdrawals
32     // -> kill the contract
33     // -> change the price of tokens
34     modifier onlyAdministrator(){
35         address _customerAddress = msg.sender;
36         require(administrators[keccak256(_customerAddress)]);
37         _;
38     }
39     
40     
41     modifier antiEarlyWhale(uint256 _amountOfEthereum){
42         address _customerAddress = msg.sender;
43         
44       
45         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
46             require(
47                 // is the customer in the ambassador list?
48                 ambassadors_[_customerAddress] == true &&
49                 
50                 // does the customer purchase exceed the max ambassador quota?
51                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
52                 
53             );
54             
55             // updated the accumulated quota    
56             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
57         
58             // execute
59             _;
60         } else {
61             // in case the ether count drops low, the ambassador phase won't reinitiate
62             onlyAmbassadors = false;
63             _;    
64         }
65         
66     }
67     
68     
69     /*==============================
70     =            EVENTS            =
71     ==============================*/
72     event onTokenPurchase(
73         address indexed customerAddress,
74         uint256 incomingEthereum,
75         uint256 tokensMinted,
76         address indexed referredBy
77     );
78     
79     event onTokenSell(
80         address indexed customerAddress,
81         uint256 tokensBurned,
82         uint256 ethereumEarned
83     );
84     
85     event onReinvestment(
86         address indexed customerAddress,
87         uint256 ethereumReinvested,
88         uint256 tokensMinted
89     );
90     
91     event onWithdraw(
92         address indexed customerAddress,
93         uint256 ethereumWithdrawn
94     );
95     
96     // ERC20
97     event Transfer(
98         address indexed from,
99         address indexed to,
100         uint256 tokens
101     );
102     
103     
104     /*=====================================
105     =            CONFIGURABLES            =
106     =====================================*/
107     string public name = "FamilyOnlyToken";
108     string public symbol = "FOT";
109     uint8 constant public decimals = 18;
110     uint8 constant internal dividendFee_ = 10;
111     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
112     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
113     uint256 constant internal magnitude = 2**64;
114     
115     // proof of stake (defaults at 1 token)
116     uint256 public stakingRequirement = 1e18;
117     
118     // ambassador program
119     mapping(address => bool) internal ambassadors_;
120     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
121     uint256 constant internal ambassadorQuota_ = 1 ether;
122     
123     
124     
125    /*================================
126     =            DATASETS            =
127     ================================*/
128     // amount of shares for each address (scaled number)
129     mapping(address => uint256) internal tokenBalanceLedger_;
130     mapping(address => uint256) internal referralBalance_;
131     mapping(address => int256) internal payoutsTo_;
132     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
133     uint256 internal tokenSupply_ = 0;
134     uint256 internal profitPerShare_;
135     
136     // administrator list (see above on what they can do)
137     mapping(bytes32 => bool) public administrators;
138     
139     
140     bool public onlyAmbassadors = false;
141     
142 
143 
144     /*=======================================
145     =            PUBLIC FUNCTIONS            =
146     =======================================*/
147     /*
148     * -- APPLICATION ENTRY POINTS --  
149     */
150     function FamilyOnlyToken()
151         public
152      {
153         // add administrators here
154         administrators[keccak256(0xE9e6279483710714482936772A49E9E5999979D2)] = true;
155 						 
156    
157         ambassadors_[0x0000000000000000000000000000000000000000] = true;
158                        
159     }
160     
161      
162     /**
163      * Converts all incoming Ethereum to tokens for the caller, and passes down the referral address (if any)
164      */
165     function buy(address _referredBy)
166         public
167         payable
168         returns(uint256)
169     {
170         purchaseTokens(msg.value, _referredBy);
171     }
172     
173     
174     function()
175         payable
176         public
177     {
178         purchaseTokens(msg.value, 0x0);
179     }
180     
181     /**
182      * Converts all of caller's dividends to tokens.
183      */
184     function reinvest()
185         onlyhodler()
186         public
187     {
188         // fetch dividends
189         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
190         
191         // pay out the dividends virtually
192         address _customerAddress = msg.sender;
193         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
194         
195         // retrieve ref. bonus
196         _dividends += referralBalance_[_customerAddress];
197         referralBalance_[_customerAddress] = 0;
198         
199         // dispatch a buy order with the virtualized "withdrawn dividends"
200         uint256 _tokens = purchaseTokens(_dividends, 0x0);
201         
202         // fire event
203         onReinvestment(_customerAddress, _dividends, _tokens);
204     }
205     
206     /**
207      * Alias of sell() and withdraw().
208      */
209     function exit()
210         public
211     {
212         // get token count for caller & sell them all
213         address _customerAddress = msg.sender;
214         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
215         if(_tokens > 0) sell(_tokens);
216         
217         
218         withdraw();
219     }
220 
221     /**
222      * Withdraws all of the callers earnings.
223      */
224     function withdraw()
225         onlyhodler()
226         public
227     {
228         // setup data
229         address _customerAddress = msg.sender;
230         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
231         
232         // update dividend tracker
233         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
234         
235         // add ref. bonus
236         _dividends += referralBalance_[_customerAddress];
237         referralBalance_[_customerAddress] = 0;
238         
239         // delivery service
240         _customerAddress.transfer(_dividends);
241         
242         // fire event
243         onWithdraw(_customerAddress, _dividends);
244     }
245     
246     /**
247      * Liquifies tokens to ethereum.
248      */
249     function sell(uint256 _amountOfTokens)
250         onlybelievers ()
251         public
252     {
253       
254         address _customerAddress = msg.sender;
255        
256         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
257         uint256 _tokens = _amountOfTokens;
258         uint256 _ethereum = tokensToEthereum_(_tokens);
259         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
260         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
261         
262         // burn the sold tokens
263         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
264         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
265         
266         // update dividends tracker
267         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
268         payoutsTo_[_customerAddress] -= _updatedPayouts;       
269         
270         // dividing by zero is a bad idea
271         if (tokenSupply_ > 0) {
272             // update the amount of dividends per token
273             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
274         }
275         
276         // fire event
277         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
278     }
279     
280     
281     /**
282      * Transfer tokens from the caller to a new holder.
283      * Remember, there's a 10% fee here as well.
284      */
285     function transfer(address _toAddress, uint256 _amountOfTokens)
286         onlybelievers ()
287         public
288         returns(bool)
289     {
290         // setup
291         address _customerAddress = msg.sender;
292         
293         // make sure we have the requested tokens
294      
295         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
296         
297         // withdraw all outstanding dividends first
298         if(myDividends(true) > 0) withdraw();
299         
300         // liquify 10% of the tokens that are transfered
301         // these are dispersed to shareholders
302         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
303         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
304         uint256 _dividends = tokensToEthereum_(_tokenFee);
305   
306         // burn the fee tokens
307         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
308 
309         // exchange tokens
310         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
311         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
312         
313         // update dividend trackers
314         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
315         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
316         
317         // disperse dividends among holders
318         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
319         
320         // fire event
321         Transfer(_customerAddress, _toAddress, _taxedTokens);
322         
323         // ERC20
324         return true;
325        
326     }
327     
328     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
329     /**
330      * administrator can manually disable the ambassador phase.
331      */
332     function disableInitialStage()
333         onlyAdministrator()
334         public
335     {
336         onlyAmbassadors = false;
337     }
338     
339    
340     function setAdministrator(bytes32 _identifier, bool _status)
341         onlyAdministrator()
342         public
343     {
344         administrators[_identifier] = _status;
345     }
346     
347    
348     function setStakingRequirement(uint256 _amountOfTokens)
349         onlyAdministrator()
350         public
351     {
352         stakingRequirement = _amountOfTokens;
353     }
354     
355     
356     function setName(string _name)
357         onlyAdministrator()
358         public
359     {
360         name = _name;
361     }
362     
363    
364     function setSymbol(string _symbol)
365         onlyAdministrator()
366         public
367     {
368         symbol = _symbol;
369     }
370 
371     
372     /*----------  HELPERS AND CALCULATORS  ----------*/
373     /**
374      * Method to view the current Ethereum stored in the contract
375      * Example: totalEthereumBalance()
376      */
377     function totalEthereumBalance()
378         public
379         view
380         returns(uint)
381     {
382         return this.balance;
383     }
384     
385     /**
386      * Retrieve the total token supply.
387      */
388     function totalSupply()
389         public
390         view
391         returns(uint256)
392     {
393         return tokenSupply_;
394     }
395     
396     /**
397      * Retrieve the tokens owned by the caller.
398      */
399     function myTokens()
400         public
401         view
402         returns(uint256)
403     {
404         address _customerAddress = msg.sender;
405         return balanceOf(_customerAddress);
406     }
407     
408     /**
409      * Retrieve the dividends owned by the caller.
410        */ 
411     function myDividends(bool _includeReferralBonus) 
412         public 
413         view 
414         returns(uint256)
415     {
416         address _customerAddress = msg.sender;
417         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
418     }
419     
420     /**
421      * Retrieve the token balance of any single address.
422      */
423     function balanceOf(address _customerAddress)
424         view
425         public
426         returns(uint256)
427     {
428         return tokenBalanceLedger_[_customerAddress];
429     }
430     
431     /**
432      * Retrieve the dividend balance of any single address.
433      */
434     function dividendsOf(address _customerAddress)
435         view
436         public
437         returns(uint256)
438     {
439         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
440     }
441     
442     /**
443      * Return the buy price of 1 individual token.
444      */
445     function sellPrice() 
446         public 
447         view 
448         returns(uint256)
449     {
450        
451         if(tokenSupply_ == 0){
452             return tokenPriceInitial_ - tokenPriceIncremental_;
453         } else {
454             uint256 _ethereum = tokensToEthereum_(1e18);
455             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
456             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
457             return _taxedEthereum;
458         }
459     }
460     
461     /**
462      * Return the sell price of 1 individual token.
463      */
464     function buyPrice() 
465         public 
466         view 
467         returns(uint256)
468     {
469         
470         if(tokenSupply_ == 0){
471             return tokenPriceInitial_ + tokenPriceIncremental_;
472         } else {
473             uint256 _ethereum = tokensToEthereum_(1e18);
474             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
475             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
476             return _taxedEthereum;
477         }
478     }
479     
480    
481     function calculateTokensReceived(uint256 _ethereumToSpend) 
482         public 
483         view 
484         returns(uint256)
485     {
486         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
487         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
488         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
489         
490         return _amountOfTokens;
491     }
492     
493    
494     function calculateEthereumReceived(uint256 _tokensToSell) 
495         public 
496         view 
497         returns(uint256)
498     {
499         require(_tokensToSell <= tokenSupply_);
500         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
501         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
502         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
503         return _taxedEthereum;
504     }
505     
506     
507     /*==========================================
508     =            INTERNAL FUNCTIONS            =
509     ==========================================*/
510     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
511         antiEarlyWhale(_incomingEthereum)
512         internal
513         returns(uint256)
514     {
515         // data setup
516         address _customerAddress = msg.sender;
517         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
518         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
519         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
520         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
521         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
522         uint256 _fee = _dividends * magnitude;
523  
524       
525         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
526         
527         // is the user referred by a karmalink?
528         if(
529             // is this a referred purchase?
530             _referredBy != 0x0000000000000000000000000000000000000000 &&
531 
532             // no cheating!
533             _referredBy != _customerAddress &&
534             
535         
536             tokenBalanceLedger_[_referredBy] >= stakingRequirement
537         ){
538             // wealth redistribution
539             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
540         } else {
541             // no ref purchase
542             // add the referral bonus back to the global dividends cake
543             _dividends = SafeMath.add(_dividends, _referralBonus);
544             _fee = _dividends * magnitude;
545         }
546         
547         // we can't give people infinite ethereum
548         if(tokenSupply_ > 0){
549             
550             // add tokens to the pool
551             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
552  
553             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
554             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
555             
556             // calculate the amount of tokens the customer receives over his purchase 
557             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
558         
559         } else {
560             // add tokens to the pool
561             tokenSupply_ = _amountOfTokens;
562         }
563         
564         // update circulating supply & the ledger address for the customer
565         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
566         
567         
568         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
569         payoutsTo_[_customerAddress] += _updatedPayouts;
570         
571         // fire event
572         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
573         
574         return _amountOfTokens;
575     }
576 
577     /**
578      * Calculate Token price based on an amount of incoming ethereum
579      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
580      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
581      */
582     function ethereumToTokens_(uint256 _ethereum)
583         internal
584         view
585         returns(uint256)
586     {
587         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
588         uint256 _tokensReceived = 
589          (
590             (
591                 // underflow attempts BTFO
592                 SafeMath.sub(
593                     (sqrt
594                         (
595                             (_tokenPriceInitial**2)
596                             +
597                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
598                             +
599                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
600                             +
601                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
602                         )
603                     ), _tokenPriceInitial
604                 )
605             )/(tokenPriceIncremental_)
606         )-(tokenSupply_)
607         ;
608   
609         return _tokensReceived;
610     }
611     
612     /**
613      * Calculate token sell value.
614           */
615      function tokensToEthereum_(uint256 _tokens)
616         internal
617         view
618         returns(uint256)
619     {
620 
621         uint256 tokens_ = (_tokens + 1e18);
622         uint256 _tokenSupply = (tokenSupply_ + 1e18);
623         uint256 _etherReceived =
624         (
625             // underflow attempts BTFO
626             SafeMath.sub(
627                 (
628                     (
629                         (
630                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
631                         )-tokenPriceIncremental_
632                     )*(tokens_ - 1e18)
633                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
634             )
635         /1e18);
636         return _etherReceived;
637     }
638     
639     
640     
641     function sqrt(uint x) internal pure returns (uint y) {
642         uint z = (x + 1) / 2;
643         y = x;
644         while (z < y) {
645             y = z;
646             z = (x / z + z) / 2;
647         }
648     }
649 }
650 
651 /**
652  * @title SafeMath
653  * @dev Math operations with safety checks that throw on error
654  */
655 library SafeMath {
656 
657    
658     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
659         if (a == 0) {
660             return 0;
661         }
662         uint256 c = a * b;
663         assert(c / a == b);
664         return c;
665     }
666 
667    
668     function div(uint256 a, uint256 b) internal pure returns (uint256) {
669         // assert(b > 0); // Solidity automatically throws when dividing by 0
670         uint256 c = a / b;
671         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
672         return c;
673     }
674 
675     
676     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
677         assert(b <= a);
678         return a - b;
679     }
680 
681    
682     function add(uint256 a, uint256 b) internal pure returns (uint256) {
683         uint256 c = a + b;
684         assert(c >= a);
685         return c;
686     }
687 
688 /**
689 * Al.
690 */
691     
692 }