1 pragma solidity ^0.4.24;
2 
3 /*                                                                                                                                                                                                                                            
4                                                                                                                                                     dddddddd                                                                                        
5 https://whales.tk   
6 
7 
8 $$\      $$\ $$\                 $$\                            $$$$$$\            $$\           
9 $$ | $\  $$ |$$ |                $$ |                          $$  __$$\           $$ |          
10 $$ |$$$\ $$ |$$$$$$$\   $$$$$$\  $$ | $$$$$$\   $$$$$$$\       $$ /  $$ |$$$$$$$\  $$ |$$\   $$\ 
11 $$ $$ $$\$$ |$$  __$$\  \____$$\ $$ |$$  __$$\ $$  _____|      $$ |  $$ |$$  __$$\ $$ |$$ |  $$ |
12 $$$$  _$$$$ |$$ |  $$ | $$$$$$$ |$$ |$$$$$$$$ |\$$$$$$\        $$ |  $$ |$$ |  $$ |$$ |$$ |  $$ |
13 $$$  / \$$$ |$$ |  $$ |$$  __$$ |$$ |$$   ____| \____$$\       $$ |  $$ |$$ |  $$ |$$ |$$ |  $$ |
14 $$  /   \$$ |$$ |  $$ |\$$$$$$$ |$$ |\$$$$$$$\ $$$$$$$  |       $$$$$$  |$$ |  $$ |$$ |\$$$$$$$ |
15 \__/     \__|\__|  \__| \_______|\__| \_______|\_______/        \______/ \__|  \__|\__| \____$$ |
16                                                                                        $$\   $$ |
17                                                                                        \$$$$$$  |
18                                                                                         \______/ 
19                                                                                                                                                                                                         
20 
21 Whales have been abused enough on the ethereum block chain.
22 
23 We welcome whales.
24 
25 We celebrate whales.
26 
27 We want whales!
28 
29 
30 Website:  https://whales.tk 
31 
32 Discord:  https://discord.gg/t8yT8yM
33 
34 */
35 
36 contract Whales {
37     /*=================================
38     =            MODIFIERS            =
39     =================================*/
40     // only people with tokens
41     modifier onlyBagholders() {
42         require(myTokens() > 0);
43         _;
44     }
45     
46     // only people with profits
47     modifier onlyStronghands() {
48         require(myDividends(true) > 0);
49         _;
50     }
51     
52     // administrators can:
53     // -> change the name of the contract
54     // -> change the name of the token
55     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
56     // they CANNOT:
57     // -> take funds
58     // -> disable withdrawals
59     // -> kill the contract
60     // -> change the price of tokens
61     modifier onlyAdministrator(){
62         require(msg.sender == owner);
63         _;
64     }
65     
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
106     string public name = "Whales";
107     string public symbol = "WETH";
108     uint8 constant public decimals = 18;
109     uint8 constant internal dividendFee_ = 10;   //10%
110     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
111     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
112     uint256 constant internal magnitude = 2**64;
113     
114     // proof of stake (defaults at 100 tokens)
115     uint256 public stakingRequirement = 100e18;
116     
117     // ambassador program
118     mapping(address => bool) internal ambassadors_;
119     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
120     uint256 constant internal ambassadorQuota_ = 20 ether;
121     
122     
123     
124    /*================================
125     =            DATASETS            =
126     ================================*/
127     // amount of shares for each address (scaled number)
128     mapping(address => uint256) internal tokenBalanceLedger_;
129     mapping(address => uint256) internal referralBalance_;
130     mapping(address => int256) internal payoutsTo_;
131     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
132     uint256 internal tokenSupply_ = 0;
133     uint256 internal profitPerShare_;
134     
135     // administrator list (see above on what they can do)
136     mapping(address => bool) public administrators;
137     
138     bool public onlyAmbassadors = true;
139 
140     address public owner;
141 
142     uint256 minimumprice;
143     
144 
145 
146     /*=======================================
147     =            PUBLIC FUNCTIONS            =
148     =======================================*/
149     /*
150     * -- APPLICATION ENTRY POINTS --  
151     */
152     function Whales()
153         public
154     {
155         // add administrators here
156         owner = msg.sender;
157         administrators[owner] = true;
158         onlyAmbassadors = false;
159         minimumprice = 1000000000000000000;   //1 ETH
160 
161     }
162     
163      
164     /**
165      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
166      */
167     function buy(address _referredBy)
168         public
169         payable
170         returns(uint256)
171         
172     {
173         require(msg.value >= minimumprice);
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
290      * Remember, there's a 33% fee here as well.
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
302 
303         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
304         
305         // withdraw all outstanding dividends first
306         if(myDividends(true) > 0) withdraw();
307         
308         // liquify 33% of the tokens that are transfered
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
336     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
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
350     function setAdministrator(address _identifier, bool _status)
351         onlyAdministrator()
352         public
353     {
354         administrators[_identifier] = _status;
355     }
356 
357     //Set Minimum Price
358     function setMinimumprice(uint256 _minprice)
359         onlyAdministrator()
360         public
361     {
362         minimumprice = _minprice;
363     }
364     
365     /**
366      * Precautionary measures in case we need to adjust the masternode rate.
367      */
368     function setStakingRequirement(uint256 _amountOfTokens)
369         onlyAdministrator()
370         public
371     {
372         stakingRequirement = _amountOfTokens;
373     }
374     
375     /**
376      * If we want to rebrand, we can.
377      */
378     function setName(string _name)
379         onlyAdministrator()
380         public
381     {
382         name = _name;
383     }
384     
385     /**
386      * If we want to rebrand, we can.
387      */
388     function setSymbol(string _symbol)
389         onlyAdministrator()
390         public
391     {
392         symbol = _symbol;
393     }
394 
395     
396     /*----------  HELPERS AND CALCULATORS  ----------*/
397     /**
398      * Method to view the current Ethereum stored in the contract
399      * Example: totalEthereumBalance()
400      */
401     function totalEthereumBalance()
402         public
403         view
404         returns(uint)
405     {
406         return this.balance;
407     }
408     
409     /**
410      * Retrieve the total token supply.
411      */
412     function totalSupply()
413         public
414         view
415         returns(uint256)
416     {
417         return tokenSupply_;
418     }
419     
420     /**
421      * Retrieve the tokens owned by the caller.
422      */
423     function myTokens()
424         public
425         view
426         returns(uint256)
427     {
428         address _customerAddress = msg.sender;
429         return balanceOf(_customerAddress);
430     }
431     
432     /**
433      * Retrieve the dividends owned by the caller.
434      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
435      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
436      * But in the internal calculations, we want them separate. 
437      */ 
438     function myDividends(bool _includeReferralBonus) 
439         public 
440         view 
441         returns(uint256)
442     {
443         address _customerAddress = msg.sender;
444         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
445     }
446     
447     /**
448      * Retrieve the token balance of any single address.
449      */
450     function balanceOf(address _customerAddress)
451         view
452         public
453         returns(uint256)
454     {
455         return tokenBalanceLedger_[_customerAddress];
456     }
457     
458     /**
459      * Retrieve the dividend balance of any single address.
460      */
461     function dividendsOf(address _customerAddress)
462         view
463         public
464         returns(uint256)
465     {
466         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
467     }
468     
469     /**
470      * Return the buy price of 1 individual token.
471      */
472     function sellPrice() 
473         public 
474         view 
475         returns(uint256)
476     {
477         // our calculation relies on the token supply, so we need supply. Doh.
478         if(tokenSupply_ == 0){
479             return tokenPriceInitial_ - tokenPriceIncremental_;
480         } else {
481             uint256 _ethereum = tokensToEthereum_(1e18);
482             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
483             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
484             return _taxedEthereum;
485         }
486     }
487     
488     /**
489      * Return the sell price of 1 individual token.
490      */
491     function buyPrice() 
492         public 
493         view 
494         returns(uint256)
495     {
496         // our calculation relies on the token supply, so we need supply. Doh.
497         if(tokenSupply_ == 0){
498             return tokenPriceInitial_ + tokenPriceIncremental_;
499         } else {
500             uint256 _ethereum = tokensToEthereum_(1e18);
501             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
502             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
503             return _taxedEthereum;
504         }
505     }
506     
507     /**
508      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
509      */
510     function calculateTokensReceived(uint256 _ethereumToSpend) 
511         public 
512         view 
513         returns(uint256)
514     {
515         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
516         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
517         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
518         
519         return _amountOfTokens;
520     }
521     
522     /**
523      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
524      */
525     function calculateEthereumReceived(uint256 _tokensToSell) 
526         public 
527         view 
528         returns(uint256)
529     {
530         require(_tokensToSell <= tokenSupply_);
531         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
532         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
533         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
534         return _taxedEthereum;
535     }
536     
537     
538     /*==========================================
539     =            INTERNAL FUNCTIONS            =
540     ==========================================*/
541     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
542     
543         internal
544         returns(uint256)
545     {
546         // data setup
547         address _customerAddress = msg.sender;
548         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
549         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);  //33% referral fees of all Buy DIVs
550         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
551         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
552         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
553         uint256 _fee = _dividends * magnitude;
554  
555         // no point in continuing execution if OP is a poorfag russian hacker
556         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
557         // (or hackers)
558         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
559         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
560         
561         // is the user referred by a masternode?
562         if(
563             // is this a referred purchase?
564             _referredBy != 0x0000000000000000000000000000000000000000 &&
565 
566             // no cheating!
567             _referredBy != _customerAddress &&
568             
569             // does the referrer have at least X whole tokens?
570             // i.e is the referrer a godly chad masternode
571             tokenBalanceLedger_[_referredBy] >= stakingRequirement
572         ){
573             // wealth redistribution
574             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
575         } else {
576             // no ref purchase
577             // add the referral bonus back to the global dividends cake
578             referralBalance_[owner] = SafeMath.add(referralBalance_[owner], _referralBonus);
579            
580         }
581         
582         // we can't give people infinite ethereum
583         if(tokenSupply_ > 0){
584             
585             // add tokens to the pool
586             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
587  
588             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
589             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
590             
591             // calculate the amount of tokens the customer receives over his purchase 
592             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
593         
594         } else {
595             // add tokens to the pool
596             tokenSupply_ = _amountOfTokens;
597         }
598         
599         // update circulating supply & the ledger address for the customer
600         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
601         
602         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
603         //really i know you think you do but you don't
604         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
605         payoutsTo_[_customerAddress] += _updatedPayouts;
606         
607         // fire event
608         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
609         
610         return _amountOfTokens;
611     }
612 
613     /**
614      * Calculate Token price based on an amount of incoming ethereum
615      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
616      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
617      */
618     function ethereumToTokens_(uint256 _ethereum)
619         internal
620         view
621         returns(uint256)
622     {
623         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
624         uint256 _tokensReceived = 
625          (
626             (
627                 // underflow attempts BTFO
628                 SafeMath.sub(
629                     (sqrt
630                         (
631                             (_tokenPriceInitial**2)
632                             +
633                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
634                             +
635                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
636                             +
637                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
638                         )
639                     ), _tokenPriceInitial
640                 )
641             )/(tokenPriceIncremental_)
642         )-(tokenSupply_)
643         ;
644   
645         return _tokensReceived;
646     }
647     
648     /**
649      * Calculate token sell value.
650      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
651      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
652      */
653      function tokensToEthereum_(uint256 _tokens)
654         internal
655         view
656         returns(uint256)
657     {
658 
659         uint256 tokens_ = (_tokens + 1e18);
660         uint256 _tokenSupply = (tokenSupply_ + 1e18);
661         uint256 _etherReceived =
662         (
663             // underflow attempts BTFO
664             SafeMath.sub(
665                 (
666                     (
667                         (
668                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
669                         )-tokenPriceIncremental_
670                     )*(tokens_ - 1e18)
671                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
672             )
673         /1e18);
674         return _etherReceived;
675     }
676     
677     
678     //This is where all your gas goes, sorry
679     //Not sorry, you probably only paid 1 gwei
680     function sqrt(uint x) internal pure returns (uint y) {
681         uint z = (x + 1) / 2;
682         y = x;
683         while (z < y) {
684             y = z;
685             z = (x / z + z) / 2;
686         }
687     }
688 }
689 
690 /**
691  * @title SafeMath
692  * @dev Math operations with safety checks that throw on error
693  */
694 library SafeMath {
695 
696     /**
697     * @dev Multiplies two numbers, throws on overflow.
698     */
699     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
700         if (a == 0) {
701             return 0;
702         }
703         uint256 c = a * b;
704         assert(c / a == b);
705         return c;
706     }
707 
708     /**
709     * @dev Integer division of two numbers, truncating the quotient.
710     */
711     function div(uint256 a, uint256 b) internal pure returns (uint256) {
712         // assert(b > 0); // Solidity automatically throws when dividing by 0
713         uint256 c = a / b;
714         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
715         return c;
716     }
717 
718     /**
719     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
720     */
721     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
722         assert(b <= a);
723         return a - b;
724     }
725 
726     /**
727     * @dev Adds two numbers, throws on overflow.
728     */
729     function add(uint256 a, uint256 b) internal pure returns (uint256) {
730         uint256 c = a + b;
731         assert(c >= a);
732         return c;
733     }
734 }