1 pragma solidity ^0.4.20;
2 
3 /*
4 
5 
6   _    _  ____  _____  _        __  __         ____                 
7  | |  | |/ __ \|  __ \| |      |  \/  |       |  _ \                
8  | |__| | |  | | |  | | |      | \  / |_   _  | |_) | ___  ___ _ __ 
9  |  __  | |  | | |  | | |      | |\/| | | | | |  _ < / _ \/ _ \ '__|
10  | |  | | |__| | |__| | |____  | |  | | |_| | | |_) |  __/  __/ |   
11  |_|  |_|\____/|_____/|______| |_|  |_|\__, | |____/ \___|\___|_|   
12                                         __/ |                       
13                                        |___/                        
14 
15 
16 * HODL MY BEER
17 * 
18 * The Coin backed by 100% Beer
19 *
20 * Each token is backed by 1 gram of 100.000% pure Anheuser-Busch Natural Light Beer   ;-)
21 *
22 * Buy and Sell Fees are  33.3333..%(repeating, of course)
23 *
24 * Use your referral link to gain 33% of the Buy-In Fees when someone uses your Masternode
25 *
26 * You can send ETH directly to the contract or play here:  https://hodlmybeer.net/
27 *
28 */
29 
30 contract BEERS {
31     /*=================================
32     =            MODIFIERS            =
33     =================================*/
34     // only people with tokens
35     modifier onlyBagholders() {
36         require(myTokens() > 0);
37         _;
38     }
39     
40     // only people with profits
41     modifier onlyStronghands() {
42         require(myDividends(true) > 0);
43         _;
44     }
45     
46     // administrators can:
47     // -> change the name of the contract
48     // -> change the name of the token
49     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
50     // they CANNOT:
51     // -> take funds
52     // -> disable withdrawals
53     // -> kill the contract
54     // -> change the price of tokens
55     modifier onlyAdministrator(){
56         address _customerAddress = msg.sender;
57 
58         require(administrators[_customerAddress]);
59         _;
60     }
61     
62     
63     // ensures that the first tokens in the contract will be equally distributed
64     // meaning, no divine dump will be ever possible
65     // result: healthy longevity.
66     modifier antiEarlyWhale(uint256 _amountOfEthereum){
67         address _customerAddress = msg.sender;
68         
69         // are we still in the vulnerable phase?
70         // if so, enact anti early whale protocol 
71         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
72             require(
73                 // is the customer in the ambassador list?
74                 ambassadors_[_customerAddress] == true &&
75                 
76                 // does the customer purchase exceed the max ambassador quota?
77                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
78                 
79             );
80             
81             // updated the accumulated quota    
82             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
83         
84             // execute
85             _;
86         } else {
87             // in case the ether count drops low, the ambassador phase won't reinitiate
88             onlyAmbassadors = false;
89             _;    
90         }
91         
92     }
93     
94     
95     /*==============================
96     =            EVENTS            =
97     ==============================*/
98     event onTokenPurchase(
99         address indexed customerAddress,
100         uint256 incomingEthereum,
101         uint256 tokensMinted,
102         address indexed referredBy
103     );
104     
105     event onTokenSell(
106         address indexed customerAddress,
107         uint256 tokensBurned,
108         uint256 ethereumEarned
109     );
110     
111     event onReinvestment(
112         address indexed customerAddress,
113         uint256 ethereumReinvested,
114         uint256 tokensMinted
115     );
116     
117     event onWithdraw(
118         address indexed customerAddress,
119         uint256 ethereumWithdrawn
120     );
121     
122     // ERC20
123     event Transfer(
124         address indexed from,
125         address indexed to,
126         uint256 tokens
127     );
128 
129     
130     /*=====================================
131     =            CONFIGURABLES            =
132     =====================================*/
133     string public name = "HODLMYBEER";
134     string public symbol = "BEERS";
135     uint8 constant public decimals = 18;
136     uint8 constant internal dividendFee_ = 3;
137     uint256 constant internal tokenPriceInitial_ = 0.000000001 ether;
138     uint256 constant internal tokenPriceIncremental_ = 0.0000000001 ether;
139     uint256 constant internal magnitude = 2**64;
140     
141     uint256 public stakingRequirement = 100e18;
142     
143     // ambassador program
144     mapping(address => bool) internal ambassadors_;
145     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
146     uint256 constant internal ambassadorQuota_ = 20 ether;
147     
148     
149     
150    /*================================
151     =            DATASETS            =
152     ================================*/
153     // amount of shares for each address (scaled number)
154     mapping(address => uint256) internal tokenBalanceLedger_;
155     mapping(address => uint256) internal referralBalance_;
156     mapping(address => int256) internal payoutsTo_;
157     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
158     uint256 internal tokenSupply_ = 0;
159     uint256 internal profitPerShare_;
160     
161     // administrator list (see above on what they can do)
162     //mapping(bytes32 => bool) public administrators;
163     mapping(address => bool) public administrators;
164     
165     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
166     bool public onlyAmbassadors = true;
167 
168     address Brewmeister;
169     
170 
171 
172     /*=======================================
173     =            PUBLIC FUNCTIONS            =
174     =======================================*/
175     /*
176     * -- APPLICATION ENTRY POINTS --  
177     */
178     function BEERS()
179         public
180     {
181         // add administrators here
182 
183 
184         administrators[msg.sender] = true;
185 
186         Brewmeister = msg.sender;
187 
188         onlyAmbassadors = false;
189 
190     }
191     
192      
193     /**
194      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
195      */
196     function buy(address _referredBy)
197         public
198         payable
199         returns(uint256)
200     {
201         purchaseTokens(msg.value, _referredBy);
202     }
203     
204     /**
205      * Fallback function to handle ethereum that was send straight to the contract
206      * Unfortunately we cannot use a referral address this way.
207      */
208     function()
209         payable
210         public
211     {
212         purchaseTokens(msg.value, 0x0);
213     }
214     
215     /**
216      * Converts all of caller's dividends to tokens.
217      */
218     function reinvest()
219         onlyStronghands()
220         public
221     {
222         // fetch dividends
223         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
224         
225         // pay out the dividends virtually
226         address _customerAddress = msg.sender;
227         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
228         
229         // retrieve ref. bonus
230         _dividends += referralBalance_[_customerAddress];
231         referralBalance_[_customerAddress] = 0;
232         
233         // dispatch a buy order with the virtualized "withdrawn dividends"
234         uint256 _tokens = purchaseTokens(_dividends, 0x0);
235         
236         // fire event
237         onReinvestment(_customerAddress, _dividends, _tokens);
238     }
239     
240     /**
241      * Alias of sell() and withdraw().
242      */
243     function exit()
244         public
245     {
246         // get token count for caller & sell them all
247         address _customerAddress = msg.sender;
248         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
249         if(_tokens > 0) sell(_tokens);
250         
251         // lambo delivery service
252         withdraw();
253     }
254 
255     /**
256      * Withdraws all of the callers earnings.
257      */
258     function withdraw()
259         onlyStronghands()
260         public
261     {
262         // setup data
263         address _customerAddress = msg.sender;
264         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
265         
266         // update dividend tracker
267         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
268         
269         // add ref. bonus
270         _dividends += referralBalance_[_customerAddress];
271         referralBalance_[_customerAddress] = 0;
272         
273         // lambo delivery service
274         _customerAddress.transfer(_dividends);
275         
276         // fire event
277         onWithdraw(_customerAddress, _dividends);
278     }
279     
280     /**
281      * Liquifies tokens to ethereum.
282      */
283     function sell(uint256 _amountOfTokens)
284         onlyBagholders()
285         public
286     {
287         // setup data
288         address _customerAddress = msg.sender;
289         // russian hackers BTFO
290         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
291         uint256 _tokens = _amountOfTokens;
292         uint256 _ethereum = tokensToEthereum_(_tokens);
293         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
294         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
295         
296         // burn the sold tokens
297         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
298         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
299         
300         // update dividends tracker
301         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
302         payoutsTo_[_customerAddress] -= _updatedPayouts;       
303         
304         // dividing by zero is a bad idea
305         if (tokenSupply_ > 0) {
306             // update the amount of dividends per token
307             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
308         }
309         
310         // fire event
311         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
312     }
313     
314     
315     /**
316      * Transfer tokens from the caller to a new holder.
317      * Remember, there's a 10% fee here as well.
318      */
319     function transfer(address _toAddress, uint256 _amountOfTokens)
320         onlyBagholders()
321         public
322         returns(bool)
323     {
324         // setup
325         address _customerAddress = msg.sender;
326         
327         // make sure we have the requested tokens
328         // also disables transfers until ambassador phase is over
329         // ( we dont want whale premines )
330         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
331         
332         // withdraw all outstanding dividends first
333         if(myDividends(true) > 0) withdraw();
334         
335         // liquify 10% of the tokens that are transfered
336         // these are dispersed to shareholders
337         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
338         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
339         uint256 _dividends = tokensToEthereum_(_tokenFee);
340   
341         // burn the fee tokens
342         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
343 
344         // exchange tokens
345         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
346         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
347         
348         // update dividend trackers
349         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
350         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
351         
352         // disperse dividends among holders
353         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
354         
355         // fire event
356         Transfer(_customerAddress, _toAddress, _taxedTokens);
357         
358         // ERC20
359         return true;
360        
361     }
362     
363     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
364     /**
365      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
366      */
367     function disableInitialStage()
368         onlyAdministrator()
369         public
370     {
371         onlyAmbassadors = false;
372     }
373     
374     /**
375      * In case one of us dies, we need to replace ourselves.
376      */
377     function setAdministrator(address _identifier, bool _status)
378         onlyAdministrator()
379         public
380     {
381         administrators[_identifier] = _status;
382     }
383     
384     /**
385      * Precautionary measures in case we need to adjust the masternode rate.
386      */
387     function setStakingRequirement(uint256 _amountOfTokens)
388         onlyAdministrator()
389         public
390     {
391         stakingRequirement = _amountOfTokens;
392     }
393     
394     /**
395      * If we want to rebrand, we can.
396      */
397     function setName(string _name)
398         onlyAdministrator()
399         public
400     {
401         name = _name;
402     }
403     
404     /**
405      * If we want to rebrand, we can.
406      */
407     function setSymbol(string _symbol)
408         onlyAdministrator()
409         public
410     {
411         symbol = _symbol;
412     }
413 
414     
415     /*----------  HELPERS AND CALCULATORS  ----------*/
416     /**
417      * Method to view the current Ethereum stored in the contract
418      * Example: totalEthereumBalance()
419      */
420     function totalEthereumBalance()
421         public
422         view
423         returns(uint)
424     {
425         return address (this).balance;
426     }
427     
428     /**
429      * Retrieve the total token supply.
430      */
431     function totalSupply()
432         public
433         view
434         returns(uint256)
435     {
436         return tokenSupply_;
437     }
438     
439     /**
440      * Retrieve the tokens owned by the caller.
441      */
442     function myTokens()
443         public
444         view
445         returns(uint256)
446     {
447         address _customerAddress = msg.sender;
448         return balanceOf(_customerAddress);
449     }
450     
451     /**
452      * Retrieve the dividends owned by the caller.
453      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
454      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
455      * But in the internal calculations, we want them separate. 
456      */ 
457     function myDividends(bool _includeReferralBonus) 
458         public 
459         view 
460         returns(uint256)
461     {
462         address _customerAddress = msg.sender;
463         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
464     }
465     
466     /**
467      * Retrieve the token balance of any single address.
468      */
469     function balanceOf(address _customerAddress)
470         view
471         public
472         returns(uint256)
473     {
474         return tokenBalanceLedger_[_customerAddress];
475     }
476     
477     /**
478      * Retrieve the dividend balance of any single address.
479      */
480     function dividendsOf(address _customerAddress)
481         view
482         public
483         returns(uint256)
484     {
485         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
486     }
487     
488     /**
489      * Return the buy price of 1 individual token.
490      */
491     function sellPrice() 
492         public 
493         view 
494         returns(uint256)
495     {
496         // our calculation relies on the token supply, so we need supply. Doh.
497         if(tokenSupply_ == 0){
498             return tokenPriceInitial_ - tokenPriceIncremental_;
499         } else {
500             uint256 _ethereum = tokensToEthereum_(1e18);
501             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
502             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
503             return _taxedEthereum;
504         }
505     }
506     
507     /**
508      * Return the sell price of 1 individual token.
509      */
510     function buyPrice() 
511         public 
512         view 
513         returns(uint256)
514     {
515         // our calculation relies on the token supply, so we need supply. Doh.
516         if(tokenSupply_ == 0){
517             return tokenPriceInitial_ + tokenPriceIncremental_;
518         } else {
519             uint256 _ethereum = tokensToEthereum_(1e18);
520             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
521             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
522             return _taxedEthereum;
523         }
524     }
525     
526     /**
527      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
528      */
529     function calculateTokensReceived(uint256 _ethereumToSpend) 
530         public 
531         view 
532         returns(uint256)
533     {
534         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
535         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
536         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
537         
538         return _amountOfTokens;
539     }
540     
541     /**
542      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
543      */
544     function calculateEthereumReceived(uint256 _tokensToSell) 
545         public 
546         view 
547         returns(uint256)
548     {
549         require(_tokensToSell <= tokenSupply_);
550         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
551         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
552         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
553         return _taxedEthereum;
554     }
555     
556     
557     /*==========================================
558     =            INTERNAL FUNCTIONS            =
559     ==========================================*/
560     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
561         antiEarlyWhale(_incomingEthereum)
562         internal
563         returns(uint256)
564     {
565         // data setup
566         address _customerAddress = msg.sender;
567         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
568         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
569         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
570         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
571         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
572         uint256 _fee = _dividends * magnitude;
573  
574         // no point in continuing execution if OP is a poorfag russian hacker
575         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
576         // (or hackers)
577         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
578         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
579         
580         // is the user referred by a masternode?
581         if(
582           
583             // is this a referred purchase?
584             _referredBy != 0x0000000000000000000000000000000000000000 &&
585 
586             // no cheating!
587             _referredBy != _customerAddress &&
588             
589             // does the referrer have at least X whole tokens?
590             // i.e is the referrer a godly chad masternode
591             tokenBalanceLedger_[_referredBy] >= stakingRequirement
592         ){
593             // wealth redistribution
594             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
595             
596         } else {
597             // no ref purchase
598             // add the referral bonus back to the global dividends cake
599             _dividends = SafeMath.add(_dividends, _referralBonus);
600             _fee = _dividends * magnitude;
601         }
602         
603         // we can't give people infinite ethereum
604         if(tokenSupply_ > 0){
605             
606             // add tokens to the pool
607             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
608  
609             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
610             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
611             
612             // calculate the amount of tokens the customer receives over his purchase 
613             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
614         
615         } else {
616             // add tokens to the pool
617             tokenSupply_ = _amountOfTokens;
618         }
619         
620         // update circulating supply & the ledger address for the customer
621         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
622         
623         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
624         //really i know you think you do but you don't
625         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
626         payoutsTo_[_customerAddress] += _updatedPayouts;
627         
628         // fire event
629         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
630         
631         return _amountOfTokens;
632     }
633 
634     /**
635      * Calculate Token price based on an amount of incoming ethereum
636      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
637      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
638      */
639     function ethereumToTokens_(uint256 _ethereum)
640         internal
641         view
642         returns(uint256)
643     {
644         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
645         uint256 _tokensReceived = 
646          (
647             (
648                 // underflow attempts BTFO
649                 SafeMath.sub(
650                     (sqrt
651                         (
652                             (_tokenPriceInitial**2)
653                             +
654                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
655                             +
656                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
657                             +
658                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
659                         )
660                     ), _tokenPriceInitial
661                 )
662             )/(tokenPriceIncremental_)
663         )-(tokenSupply_)
664         ;
665   
666         return _tokensReceived;
667     }
668     
669     /**
670      * Calculate token sell value.
671      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
672      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
673      */
674      function tokensToEthereum_(uint256 _tokens)
675         internal
676         view
677         returns(uint256)
678     {
679 
680         uint256 tokens_ = (_tokens + 1e18);
681         uint256 _tokenSupply = (tokenSupply_ + 1e18);
682         uint256 _etherReceived =
683         (
684             // underflow attempts BTFO
685             SafeMath.sub(
686                 (
687                     (
688                         (
689                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
690                         )-tokenPriceIncremental_
691                     )*(tokens_ - 1e18)
692                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
693             )
694         /1e18);
695         return _etherReceived;
696     }
697     
698     
699     //This is where all your gas goes, sorry
700     //Not sorry, you probably only paid 1 gwei
701     function sqrt(uint x) internal pure returns (uint y) {
702         uint z = (x + 1) / 2;
703         y = x;
704         while (z < y) {
705             y = z;
706             z = (x / z + z) / 2;
707         }
708     }
709 }
710 
711 /**
712  * @title SafeMath
713  * @dev Math operations with safety checks that throw on error
714  */
715 library SafeMath {
716 
717     /**
718     * @dev Multiplies two numbers, throws on overflow.
719     */
720     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
721         if (a == 0) {
722             return 0;
723         }
724         uint256 c = a * b;
725         assert(c / a == b);
726         return c;
727     }
728 
729     /**
730     * @dev Integer division of two numbers, truncating the quotient.
731     */
732     function div(uint256 a, uint256 b) internal pure returns (uint256) {
733         // assert(b > 0); // Solidity automatically throws when dividing by 0
734         uint256 c = a / b;
735         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
736         return c;
737     }
738 
739     /**
740     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
741     */
742     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
743         assert(b <= a);
744         return a - b;
745     }
746 
747     /**
748     * @dev Adds two numbers, throws on overflow.
749     */
750     function add(uint256 a, uint256 b) internal pure returns (uint256) {
751         uint256 c = a + b;
752         assert(c >= a);
753         return c;
754     }
755 }