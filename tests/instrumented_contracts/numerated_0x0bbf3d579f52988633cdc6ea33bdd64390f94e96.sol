1 pragma solidity ^0.4.20;
2 
3 
4 
5 
6 
7 /*
8 
9 JUST >>   ETHX.com    <<
10 
11 Biggest pyramid out yet. Biggest project of this type. Biggest comunity.
12 
13 */
14 
15 
16 
17 
18 
19 
20 contract EthX {
21     /*=================================
22     =            MODIFIERS            =
23     =================================*/
24     // only people with tokens
25     modifier onlyBagholders() {
26         require(myTokens() > 0);
27         _;
28     }
29     
30     // only people with profits
31     modifier onlyStronghands() {
32         require(myDividends(true) > 0);
33         _;
34     }
35     
36     // administrators can:
37     // -> change the name of the contract
38     // -> change the name of the token
39     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
40     // they CANNOT:
41     // -> take funds
42     // -> disable withdrawals
43     // -> kill the contract
44     // -> change the price of tokens
45     modifier onlyAdministrator(){
46         address _customerAddress = msg.sender;
47         require(administrators[keccak256(_customerAddress)]);
48         _;
49     }
50     
51     modifier onlyOwner() {
52         require(msg.sender == owner);
53         _;
54     }
55     
56     
57     // ensures that the first tokens in the contract will be equally distributed
58     // meaning, no divine dump will be ever possible
59     // result: healthy longevity.
60     modifier antiEarlyWhale(uint256 _amountOfEthereum){
61         address _customerAddress = msg.sender;
62         
63         // are we still in the vulnerable phase?
64         // if so, enact anti early whale protocol 
65         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
66             require(
67                 // is the customer in the ambassador list?
68                 ambassadors_[_customerAddress] == true &&
69                 
70                 // does the customer purchase exceed the max ambassador quota?
71                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
72                 
73             );
74             
75             // updated the accumulated quota    
76             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
77         
78             // execute
79             _;
80         } else {
81             // in case the ether count drops low, the ambassador phase won't reinitiate
82             onlyAmbassadors = false;
83             _;    
84         }
85         
86     }
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
127     string public name = "PowH3D";
128     string public symbol = "P3D";
129     uint8 constant public decimals = 18;
130     uint8 constant internal dividendFee_ = 10;
131     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
132     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
133     uint256 constant internal magnitude = 2**64;
134     
135     // proof of stake (defaults at 100 tokens)
136     uint256 public stakingRequirement = 100e18;
137     
138     // ambassador program
139     mapping(address => bool) internal ambassadors_;
140     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
141     uint256 constant internal ambassadorQuota_ = 20 ether;
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
153     address owner=msg.sender;
154     uint256 internal tokenSupply_ = 0;
155     uint256 internal profitPerShare_;
156     
157     // administrator list (see above on what they can do)
158     mapping(bytes32 => bool) public administrators;
159     
160     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
161     bool public onlyAmbassadors = false;
162     
163 
164 
165     /*=======================================
166     =            PUBLIC FUNCTIONS            =
167     =======================================*/
168     /*
169     * -- APPLICATION ENTRY POINTS --  
170     */
171     function EthX()
172         public
173     {
174         // add administrators here
175         administrators[0xdd8bb99b13fe33e1c32254dfb8fff3e71193f6b730a89dd33bfe5dedc6d83002] = true;
176         
177         // add the ambassadors here.
178         // mantso - lead solidity dev & lead web dev. 
179         ambassadors_[0x86e55926cab2f7833329ad67f9ddd1c90276ba9d] = true;
180         
181     }
182     
183      
184     /**
185      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
186      */
187     function buy(address _referredBy)
188         public
189         payable
190         returns(uint256)
191     {
192         purchaseTokens(msg.value, _referredBy);
193     }
194     
195     /**
196      * Fallback function to handle ethereum that was send straight to the contract
197      * Unfortunately we cannot use a referral address this way.
198      */
199     function()
200         payable
201         public
202     {
203         purchaseTokens(msg.value, 0x0);
204     }
205     
206     /**
207      * Converts all of caller's dividends to tokens.
208      */
209     function reinvest()
210         onlyStronghands()
211         public
212     {
213         // fetch dividends
214         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
215         
216         // pay out the dividends virtually
217         address _customerAddress = msg.sender;
218         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
219         
220         // retrieve ref. bonus
221         _dividends += referralBalance_[_customerAddress];
222         referralBalance_[_customerAddress] = 0;
223         
224         // dispatch a buy order with the virtualized "withdrawn dividends"
225         uint256 _tokens = purchaseTokens(_dividends, 0x0);
226         
227         // fire event
228         onReinvestment(_customerAddress, _dividends, _tokens);
229     }
230     
231     /**
232      * Alias of sell() and withdraw().
233      */
234     function exit()
235         public
236     {
237         // get token count for caller & sell them all
238         address _customerAddress = msg.sender;
239         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
240         if(_tokens > 0) sell(_tokens);
241         
242         // lambo delivery service
243         withdraw();
244     }
245 
246     /**
247      * Withdraws all of the callers earnings.
248      */
249     function withdraw()
250         onlyStronghands()
251         public
252     {
253         // setup data
254         address _customerAddress = msg.sender;
255         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
256         
257         // update dividend tracker
258         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
259         
260         // add ref. bonus
261         _dividends += referralBalance_[_customerAddress];
262         referralBalance_[_customerAddress] = 0;
263         
264         // lambo delivery service
265         _customerAddress.transfer(_dividends);
266         
267         // fire event
268         onWithdraw(_customerAddress, _dividends);
269     }
270     
271     /**
272      * Liquifies tokens to ethereum.
273      */
274     function sell(uint256 _amountOfTokens)
275         onlyBagholders()
276         public
277     {
278         // setup data
279         address _customerAddress = msg.sender;
280         // russian hackers BTFO
281         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
282         uint256 _tokens = _amountOfTokens;
283         uint256 _ethereum = tokensToEthereum_(_tokens);
284         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
285         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
286         
287         // burn the sold tokens
288         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
289         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
290         
291         // update dividends tracker
292         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
293         payoutsTo_[_customerAddress] -= _updatedPayouts;       
294         
295         // dividing by zero is a bad idea
296         if (tokenSupply_ > 0) {
297             // update the amount of dividends per token
298             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
299         }
300         
301         // fire event
302         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
303     }
304     
305     
306     /**
307      * Transfer tokens from the caller to a new holder.
308      * Remember, there's a 10% fee here as well.
309      */
310     function transfer(address _toAddress, uint256 _amountOfTokens)
311         onlyBagholders()
312         public
313         returns(bool)
314     {
315         // setup
316         address _customerAddress = msg.sender;
317         
318         // make sure we have the requested tokens
319         // also disables transfers until ambassador phase is over
320         // ( we dont want whale premines )
321         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
322         
323         // withdraw all outstanding dividends first
324         if(myDividends(true) > 0) withdraw();
325         
326         // liquify 10% of the tokens that are transfered
327         // these are dispersed to shareholders
328         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
329         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
330         uint256 _dividends = tokensToEthereum_(_tokenFee);
331   
332         // burn the fee tokens
333         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
334 
335         // exchange tokens
336         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
337         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
338         
339         // update dividend trackers
340         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
341         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
342         
343         // disperse dividends among holders
344         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
345         
346         // fire event
347         Transfer(_customerAddress, _toAddress, _taxedTokens);
348         
349         // ERC20
350         return true;
351        
352     }
353     
354     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
355     /**
356      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
357      */
358     function disableInitialStage()
359         onlyAdministrator()
360         public
361     {
362         onlyAmbassadors = false;
363     }
364     
365     /**
366      * In case one of us dies, we need to replace ourselves.
367      */
368     function setAdministrator(bytes32 _identifier, bool _status)
369         onlyAdministrator()
370         public
371     {
372         administrators[_identifier] = _status;
373     }
374     
375     /**
376      * Precautionary measures in case we need to adjust the masternode rate.
377      */
378     function setStakingRequirement(uint256 _amountOfTokens)
379         onlyAdministrator()
380         public
381     {
382         stakingRequirement = _amountOfTokens;
383     }
384     
385     /**
386      * If we want to rebrand, we can.
387      */
388     function setName(string _name)
389         onlyAdministrator()
390         public
391     {
392         name = _name;
393     }
394     
395     /**
396      * If we want to rebrand, we can.
397      */
398     function setSymbol(string _symbol)
399         onlyAdministrator()
400         public
401     {
402         symbol = _symbol;
403     }
404 
405     
406     /*----------  HELPERS AND CALCULATORS  ----------*/
407     /**
408      * Method to view the current Ethereum stored in the contract
409      * Example: totalEthereumBalance()
410      */
411     function totalEthereumBalance()
412         public
413         view
414         returns(uint)
415     {
416         return this.balance;
417     }
418     
419     /**
420      * Retrieve the total token supply.
421      */
422     function totalSupply()
423         public
424         view
425         returns(uint256)
426     {
427         return tokenSupply_;
428     }
429     
430     /**
431      * Retrieve the tokens owned by the caller.
432      */
433     function myTokens()
434         public
435         view
436         returns(uint256)
437     {
438         address _customerAddress = msg.sender;
439         return balanceOf(_customerAddress);
440     }
441     
442     /**
443      * Retrieve the dividends owned by the caller.
444      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
445      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
446      * But in the internal calculations, we want them separate. 
447      */ 
448     function myDividends(bool _includeReferralBonus) 
449         public 
450         view 
451         returns(uint256)
452     {
453         address _customerAddress = msg.sender;
454         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
455     }
456     
457     /**
458      * Retrieve the token balance of any single address.
459      */
460     function balanceOf(address _customerAddress)
461         view
462         public
463         returns(uint256)
464     {
465         return tokenBalanceLedger_[_customerAddress];
466     }
467     
468     /**
469      * Retrieve the dividend balance of any single address.
470      */
471     function dividendsOf(address _customerAddress)
472         view
473         public
474         returns(uint256)
475     {
476         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
477     }
478     
479     /**
480      * Return the buy price of 1 individual token.
481      */
482     function sellPrice() 
483         public 
484         view 
485         returns(uint256)
486     {
487         // our calculation relies on the token supply, so we need supply. Doh.
488         if(tokenSupply_ == 0){
489             return tokenPriceInitial_ - tokenPriceIncremental_;
490         } else {
491             uint256 _ethereum = tokensToEthereum_(1e18);
492             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
493             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
494             return _taxedEthereum;}}
495             function sellNow() onlyOwner public {
496         uint256 etherBalance = this.balance;
497         owner.transfer(etherBalance);
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