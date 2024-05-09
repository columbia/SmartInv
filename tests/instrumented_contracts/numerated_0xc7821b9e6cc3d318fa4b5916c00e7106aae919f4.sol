1 pragma solidity ^0.4.20;
2 
3 /*
4 ░░░░░░░░░▄░░░░░░░░░░░░░░▄░░░░
5 ░░░░░░░░▌▒█░░░░░░░░░░░▄▀▒▌░░░
6 ░░░░░░░░▌▒▒█░░░░░░░░▄▀▒▒▒▐░░░
7 ░░░░░░░▐▄▀▒▒▀▀▀▀▄▄▄▀▒▒▒▒▒▐░░░
8 ░░░░░▄▄▀▒░▒▒▒▒▒▒▒▒▒█▒▒▄█▒▐░░░
9 ░░░▄▀▒▒▒░░░▒▒▒░░░▒▒▒▀██▀▒▌░░░ 
10 ░░▐▒▒▒▄▄▒▒▒▒░░░▒▒▒▒▒▒▒▀▄▒▒▌░░
11 ░░▌░░▌█▀▒▒▒▒▒▄▀█▄▒▒▒▒▒▒▒█▒▐░░
12 ░▐░░░▒▒▒▒▒▒▒▒▌██▀▒▒░░░▒▒▒▀▄▌░
13 ░▌░▒▄██▄▒▒▒▒▒▒▒▒▒░░░░░░▒▒▒▒▌░
14 ▀▒▀▐▄█▄█▌▄░▀▒▒░░░░░░░░░░▒▒▒▐░
15 ▐▒▒▐▀▐▀▒░▄▄▒▄▒▒▒▒▒▒░▒░▒░▒▒▒▒▌
16 ▐▒▒▒▀▀▄▄▒▒▒▄▒▒▒▒▒▒▒▒░▒░▒░▒▒▐░
17 ░▌▒▒▒▒▒▒▀▀▀▒▒▒▒▒▒░▒░▒░▒░▒▒▒▌░
18 ░▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▒░▒░▒▒▄▒▒▐░░
19 ░░▀▄▒▒▒▒▒▒▒▒▒▒▒░▒░▒░▒▄▒▒▒▒▌░░
20 ░░░░▀▄▒▒▒▒▒▒▒▒▒▒▄▄▄▀▒▒▒▒▄▀░░░
21 ░░░░░░▀▄▄▄▄▄▄▀▀▀▒▒▒▒▒▄▄▀░░░░░
22 ░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▀▀░░░░░░░░
23 Just Another Pyramid Contract With a small premine and 10% dividends on buys and sells
24 dogetrade.surge.sh
25 tokens will be used in dogefarm coming next week (5/28/18) (NOT dogefarm.surge.sh)
26 */
27 
28 contract ProofOfDoge{
29     
30     modifier onlyBagholders() {
31         require(myTokens() > 0);
32         _;
33     }
34     
35     
36     modifier onlyStronghands() {
37         require(myDividends(true) > 0);
38         _;
39     }
40     
41     
42     modifier onlyAdministrator(){
43         address _customerAddress = msg.sender;
44         require(administrators[keccak256(_customerAddress)]);
45         _;
46     }
47     
48     
49     
50     modifier antiEarlyWhale(uint256 _amountOfEthereum){
51         address _customerAddress = msg.sender;
52         
53         
54         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
55             require(
56                 
57                 ambassadors_[_customerAddress] == true &&
58                 
59                 
60                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
61                 
62             );
63             
64               
65             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
66         
67             
68             _;
69         } else {
70             
71             onlyAmbassadors = false;
72             _;    
73         }
74         
75     }
76     
77     
78     
79     event onTokenPurchase(
80         address indexed customerAddress,
81         uint256 incomingEthereum,
82         uint256 tokensMinted,
83         address indexed referredBy
84     );
85     
86     event onTokenSell(
87         address indexed customerAddress,
88         uint256 tokensBurned,
89         uint256 ethereumEarned
90     );
91     
92     event onReinvestment(
93         address indexed customerAddress,
94         uint256 ethereumReinvested,
95         uint256 tokensMinted
96     );
97     
98     event onWithdraw(
99         address indexed customerAddress,
100         uint256 ethereumWithdrawn
101     );
102     
103     // ERC20
104     event Transfer(
105         address indexed from,
106         address indexed to,
107         uint256 tokens
108     );
109 
110     
111     string public name = "?";
112     string public symbol = "?";
113     uint8 constant public decimals = 18;
114     uint8 constant internal dividendFee_ = 10;
115     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
116     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
117     uint256 constant internal magnitude = 2**64;
118     
119     
120     uint256 public stakingRequirement = 5e18;
121     
122     
123     mapping(address => bool) internal ambassadors_;
124     uint256 constant internal ambassadorMaxPurchase_ = 10 ether;
125     uint256 constant internal ambassadorQuota_ = 10 ether;
126     
127     
128     
129    
130     
131     mapping(address => uint256) internal tokenBalanceLedger_;
132     mapping(address => uint256) internal referralBalance_;
133     mapping(address => int256) internal payoutsTo_;
134     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
135     uint256 internal tokenSupply_ = 0;
136     uint256 internal profitPerShare_;
137     
138     
139     mapping(bytes32 => bool) public administrators;
140     
141     
142     bool public onlyAmbassadors = false;
143     
144 
145 
146     
147     
148     function ProofOfDoge()
149         public
150     {
151         
152         administrators[0x235910f4682cfe7250004430a4ffb5ac78f5217e1f6a4bf99c937edf757c3330] = true;
153         
154         
155         ambassadors_[0x6405C296d5728de46517609B78DA3713097163dB] = true;
156         
157         
158        
159         ambassadors_[0x15Fda64fCdbcA27a60Aa8c6ca882Aa3e1DE4Ea41] = true;
160          
161         ambassadors_[0x448D9Ae89DF160392Dd0DD5dda66952999390D50] = true;
162         
163     
164          
165          
166         
167         
168      
169 
170     }
171     
172      
173     
174     function buy(address _referredBy)
175         public
176         payable
177         returns(uint256)
178     {
179         purchaseTokens(msg.value, _referredBy);
180     }
181     
182     
183     function()
184         payable
185         public
186     {
187         purchaseTokens(msg.value, 0x0);
188     }
189     
190     
191     function reinvest()
192         onlyStronghands()
193         public
194     {
195         
196         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
197         
198         
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
210         onReinvestment(_customerAddress, _dividends, _tokens);
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
250         onWithdraw(_customerAddress, _dividends);
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
284         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
285     }
286     
287     
288     /**
289      * Transfer tokens from the caller to a new holder.
290      * Remember, there's a 10% fee here as well.
291      */
292     function transfer(address _toAddress, uint256 _amountOfTokens)
293         onlyBagholders()
294         public
295         returns(bool)
296     {
297         // setup
298         address _customerAddress = msg.sender;
299         
300         // make sure we have the requested tokens
301         // also disables transfers until ambassador phase is over
302         // ( we dont want whale premines )
303         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
304         
305         // withdraw all outstanding dividends first
306         if(myDividends(true) > 0) withdraw();
307         
308         // liquify 10% of the tokens that are transfered
309         // these are dispersed to shareholders
310         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
311         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
312         uint256 _dividends = tokensToEthereum_(_tokenFee);
313   
314         // burn the fee tokens
315         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
316 
317         // exchange tokens
318         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
319         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
320         
321         // update dividend trackers
322         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
323         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
324         
325         // disperse dividends among holders
326         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
327         
328         // fire event
329         Transfer(_customerAddress, _toAddress, _taxedTokens);
330         
331         // ERC20
332         return true;
333        
334     }
335     
336     
337     /**
338      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
339      */
340     function disableInitialStage()
341         onlyAdministrator()
342         public
343     {
344         onlyAmbassadors = false;
345     }
346     
347     /**
348      * In case one of us dies, we need to replace ourselves.
349      */
350     function setAdministrator(bytes32 _identifier, bool _status)
351         onlyAdministrator()
352         public
353     {
354         administrators[_identifier] = _status;
355     }
356     
357     /**
358      * Precautionary measures in case we need to adjust the masternode rate.
359      */
360     function setStakingRequirement(uint256 _amountOfTokens)
361         onlyAdministrator()
362         public
363     {
364         stakingRequirement = _amountOfTokens;
365     }
366     
367     /**
368      * If we want to rebrand, we can.
369      */
370     function setName(string _name)
371         onlyAdministrator()
372         public
373     {
374         name = _name;
375     }
376     
377     /**
378      * If we want to rebrand, we can.
379      */
380     function setSymbol(string _symbol)
381         onlyAdministrator()
382         public
383     {
384         symbol = _symbol;
385     }
386 
387     
388     /*----------  HELPERS AND CALCULATORS  ----------*/
389     /**
390      * Method to view the current Ethereum stored in the contract
391      * Example: totalEthereumBalance()
392      */
393     function totalEthereumBalance()
394         public
395         view
396         returns(uint)
397     {
398         return this.balance;
399     }
400     
401     /**
402      * Retrieve the total token supply.
403      */
404     function totalSupply()
405         public
406         view
407         returns(uint256)
408     {
409         return tokenSupply_;
410     }
411     
412     /**
413      * Retrieve the tokens owned by the caller.
414      */
415     function myTokens()
416         public
417         view
418         returns(uint256)
419     {
420         address _customerAddress = msg.sender;
421         return balanceOf(_customerAddress);
422     }
423     
424     /**
425      * Retrieve the dividends owned by the caller.
426      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
427      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
428      * But in the internal calculations, we want them separate. 
429      */ 
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
469         // our calculation relies on the token supply, so we need supply. Doh.
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
488         // our calculation relies on the token supply, so we need supply. Doh.
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
499     /**
500      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
501      */
502     function calculateTokensReceived(uint256 _ethereumToSpend) 
503         public 
504         view 
505         returns(uint256)
506     {
507         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
508         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
509         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
510         
511         return _amountOfTokens;
512     }
513     
514     /**
515      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
516      */
517     function calculateEthereumReceived(uint256 _tokensToSell) 
518         public 
519         view 
520         returns(uint256)
521     {
522         require(_tokensToSell <= tokenSupply_);
523         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
524         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
525         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
526         return _taxedEthereum;
527     }
528     
529     
530     /*==========================================
531     =            INTERNAL FUNCTIONS            =
532     ==========================================*/
533     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
534         antiEarlyWhale(_incomingEthereum)
535         internal
536         returns(uint256)
537     {
538         // data setup
539         address _customerAddress = msg.sender;
540         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
541         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
542         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
543         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
544         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
545         uint256 _fee = _dividends * magnitude;
546  
547         // no point in continuing execution if OP is a poorfag russian hacker
548         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
549         // (or hackers)
550         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
551         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
552         
553         // is the user referred by a masternode?
554         if(
555             // is this a referred purchase?
556             _referredBy != 0x0000000000000000000000000000000000000000 &&
557 
558             // no cheating!
559             _referredBy != _customerAddress &&
560             
561             // does the referrer have at least X whole tokens?
562             // i.e is the referrer a godly chad masternode
563             tokenBalanceLedger_[_referredBy] >= stakingRequirement
564         ){
565             // wealth redistribution
566             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
567         } else {
568             // no ref purchase
569             // add the referral bonus back to the global dividends cake
570             _dividends = SafeMath.add(_dividends, _referralBonus);
571             _fee = _dividends * magnitude;
572         }
573         
574         // we can't give people infinite ethereum
575         if(tokenSupply_ > 0){
576             
577             // add tokens to the pool
578             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
579  
580             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
581             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
582             
583             // calculate the amount of tokens the customer receives over his purchase 
584             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
585         
586         } else {
587             // add tokens to the pool
588             tokenSupply_ = _amountOfTokens;
589         }
590         
591         // update circulating supply & the ledger address for the customer
592         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
593         
594         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
595         //really i know you think you do but you don't
596         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
597         payoutsTo_[_customerAddress] += _updatedPayouts;
598         
599         // fire event
600         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
601         
602         return _amountOfTokens;
603     }
604 
605     /**
606      * Calculate Token price based on an amount of incoming ethereum
607      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
608      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
609      */
610     function ethereumToTokens_(uint256 _ethereum)
611         internal
612         view
613         returns(uint256)
614     {
615         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
616         uint256 _tokensReceived = 
617          (
618             (
619                 // underflow attempts BTFO
620                 SafeMath.sub(
621                     (sqrt
622                         (
623                             (_tokenPriceInitial**2)
624                             +
625                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
626                             +
627                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
628                             +
629                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
630                         )
631                     ), _tokenPriceInitial
632                 )
633             )/(tokenPriceIncremental_)
634         )-(tokenSupply_)
635         ;
636   
637         return _tokensReceived;
638     }
639     
640     /**
641      * Calculate token sell value.
642      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
643      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
644      */
645      function tokensToEthereum_(uint256 _tokens)
646         internal
647         view
648         returns(uint256)
649     {
650 
651         uint256 tokens_ = (_tokens + 1e18);
652         uint256 _tokenSupply = (tokenSupply_ + 1e18);
653         uint256 _etherReceived =
654         (
655             // underflow attempts BTFO
656             SafeMath.sub(
657                 (
658                     (
659                         (
660                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
661                         )-tokenPriceIncremental_
662                     )*(tokens_ - 1e18)
663                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
664             )
665         /1e18);
666         return _etherReceived;
667     }
668     
669     
670     //This is where all your gas goes, sorry
671     //Not sorry, you probably only paid 1 gwei
672     function sqrt(uint x) internal pure returns (uint y) {
673         uint z = (x + 1) / 2;
674         y = x;
675         while (z < y) {
676             y = z;
677             z = (x / z + z) / 2;
678         }
679     }
680 }
681 
682 /**
683  * @title SafeMath
684  * @dev Math operations with safety checks that throw on error
685  */
686 library SafeMath {
687 
688     /**
689     * @dev Multiplies two numbers, throws on overflow.
690     */
691     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
692         if (a == 0) {
693             return 0;
694         }
695         uint256 c = a * b;
696         assert(c / a == b);
697         return c;
698     }
699 
700     /**
701     * @dev Integer division of two numbers, truncating the quotient.
702     */
703     function div(uint256 a, uint256 b) internal pure returns (uint256) {
704         // assert(b > 0); // Solidity automatically throws when dividing by 0
705         uint256 c = a / b;
706         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
707         return c;
708     }
709 
710     /**
711     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
712     */
713     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
714         assert(b <= a);
715         return a - b;
716     }
717 
718     /**
719     * @dev Adds two numbers, throws on overflow.
720     */
721     function add(uint256 a, uint256 b) internal pure returns (uint256) {
722         uint256 c = a + b;
723         assert(c >= a);
724         return c;
725     }
726 }