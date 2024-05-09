1 pragma solidity ^0.4.20;
2 
3 /*
4 	Built for the community. 
5 	Supported by the community. 
6 
7 	“Equality... is when you don't feel the existence of word”
8 	Talees Rizvi
9 
10 	“The world is round so that friendship may encircle it.”
11 	Pierre Teilhard de Chardin
12 
13 	What? 
14 	We are a clone simple as that. 
15 	But we differentiate in the way we pay our divs. 
16 	More for the community. 
17 	- Buys - 35% fee goes to all current token holders. 
18 	- Sells - 15% fee to all current tokens holders. And it’s lower because you shouldn’t have to pay the sane fee exiting. You deserve more. 
19 	- Transfers - 0% fee! We have plans for games and we don't want that to be an obstacle!
20 	- Masternode - you get 7% from deposit of all players who enter using your Masternode . 
21 
22 	Who toiled night and day on this project to make this possible for you? 
23 	Clumsier - solidity developer, website 
24 	Bungalogic - website developer, concept and design, graphics. 
25 */
26 
27 contract ProofOfCommunity {
28     /*=================================
29     =            MODIFIERS            =
30     =================================*/
31     // only people with tokens
32     modifier onlyBagholders() {
33         require(myTokens() > 0);
34         _;
35     }
36 
37     // only people with profits
38     modifier onlyStronghands() {
39         require(myDividends(true) > 0);
40         _;
41     }
42 
43     // administrators can:
44     // -> change the name of the contract
45     // -> change the name of the token
46     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
47     // they CANNOT:
48     // -> take funds
49     // -> disable withdrawals
50     // -> kill the contract
51     // -> change the price of tokens
52     modifier onlyAdministrator(){
53         address _customerAddress = msg.sender;
54         require(administrators[_customerAddress]);
55         _;
56     }
57 
58 
59     // ensures that the first tokens in the contract will be equally distributed
60     // meaning, no divine dump will be ever possible
61     // result: healthy longevity.
62     modifier antiEarlyWhale(uint256 _amountOfEthereum){
63         address _customerAddress = msg.sender;
64 
65         // are we still in the vulnerable phase?
66         // if so, enact anti early whale protocol
67         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
68             require(
69                 // is the customer in the ambassador list?
70                 ambassadors_[_customerAddress] == true &&
71 
72                 // does the customer purchase exceed the max ambassador quota?
73                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
74 
75             );
76 
77             // updated the accumulated quota
78             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
79 
80             // execute
81             _;
82         } else {
83             // in case the ether count drops low, the ambassador phase won't reinitiate
84             onlyAmbassadors = false;
85             _;
86         }
87     }
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
123     /*=====================================
124     =            CONFIGURABLES            =
125     =====================================*/
126     string public name = "ProofOfCommunity";
127     string public symbol = "POC";
128     uint8 constant public decimals = 18;
129     uint8 constant internal entryFee_ = 35; // 35% to enter our community
130     uint8 constant internal refferalFee_ = 20; // 20% from enter fee divs or 7% for each invite, great for inviting new members for our community
131     uint8 constant internal exitFee_ = 15; // 15% for selling
132     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
133     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
134     uint256 constant internal magnitude = 2**64;
135 
136     // proof of stake (defaults at 100 tokens)
137     uint256 public stakingRequirement = 100e18;
138 
139     // ambassador program
140     mapping(address => bool) internal ambassadors_;
141     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
142     uint256 constant internal ambassadorQuota_ = 20 ether;
143 
144     // referral program
145     mapping(address => uint256) internal referrals;
146     mapping(address => bool) internal isUser;
147     address[] public usersAddresses;
148 
149    /*================================
150     =            DATASETS            =
151     ================================*/
152     // amount of shares for each address (scaled number)
153     mapping(address => uint256) internal tokenBalanceLedger_;
154     mapping(address => uint256) internal referralBalance_;
155     mapping(address => int256) internal payoutsTo_;
156     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
157     uint256 internal tokenSupply_ = 0;
158     uint256 internal profitPerShare_;
159 
160     // administrator list (see above on what they can do)
161     mapping(address => bool) public administrators;
162 
163     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
164     bool public onlyAmbassadors = true;
165 
166     /*=======================================
167     =            PUBLIC FUNCTIONS            =
168     =======================================*/
169     /*
170     * -- APPLICATION ENTRY POINTS --
171     */
172     function ProofOfCommunity()
173         public
174     {
175         // add administrators here with their wallets
176 
177   		// bungalogic
178 		// Website developer, concept and design. Community
179 		administrators[0xBa21d01125D6932ce8ABf3625977899Fd2C7fa30] = true;
180 		ambassadors_[0xBa21d01125D6932ce8ABf3625977899Fd2C7fa30] = true;
181 
182 		// clumsier 
183 		// Solidity Developer, website,  PoG 
184 		administrators[msg.sender] = true;
185 		ambassadors_[msg.sender] = true;
186     }
187 
188 
189     /**
190      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
191      */
192     function buy(address _referredBy)
193         public
194         payable
195         returns(uint256)
196     {
197         purchaseTokens(msg.value, _referredBy);
198     }
199 
200     /**
201      * Fallback function to handle ethereum that was send straight to the contract
202      * Unfortunately we cannot use a referral address this way.
203      */
204     function()
205         payable
206         public
207     {
208         purchaseTokens(msg.value, 0x0);
209     }
210 
211     /* Converts all of caller's dividends to tokens. */
212     function reinvest() onlyStronghands() public {
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
231     /* Alias of sell() and withdraw(). */
232     function exit() public {
233         // get token count for caller & sell them all
234         address _customerAddress = msg.sender;
235         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
236         if(_tokens > 0) sell(_tokens);
237 
238         // lambo delivery service
239         withdraw();
240     }
241 
242     /* Withdraws all of the callers earnings. */
243     function withdraw() onlyStronghands() public {
244         // setup data
245         address _customerAddress = msg.sender;
246         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
247 
248         // update dividend tracker
249         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
250 
251         // add ref. bonus
252         _dividends += referralBalance_[_customerAddress];
253         referralBalance_[_customerAddress] = 0;
254 
255         // lambo delivery service
256         _customerAddress.transfer(_dividends);
257 
258         // fire event
259         onWithdraw(_customerAddress, _dividends);
260     }
261 
262     /* Liquifies tokens to ethereum. */
263     function sell(uint256 _amountOfTokens) onlyBagholders() public {
264         // setup data
265         address _customerAddress = msg.sender;
266         // russian hackers BTFO
267         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
268         uint256 _tokens = _amountOfTokens;
269         uint256 _ethereum = tokensToEthereum_(_tokens);
270         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
271         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
272 
273         // burn the sold tokens
274         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
275         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
276 
277         // update dividends tracker
278         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
279         payoutsTo_[_customerAddress] -= _updatedPayouts;
280 
281         // dividing by zero is a bad idea
282         if (tokenSupply_ > 0) {
283             // update the amount of dividends per token
284             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
285         }
286 
287         // fire event
288         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
289     }
290 
291 
292     /* Transfer tokens from the caller to a new holder. * No fee! */
293     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders() public returns(bool) {
294         // setup
295         address _customerAddress = msg.sender;
296 
297         // make sure we have the requested tokens
298         // also disables transfers until ambassador phase is over
299         // ( we dont want whale premines )
300         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
301 
302         // withdraw all outstanding dividends first
303         if(myDividends(true) > 0) withdraw();
304 
305         // exchange tokens
306         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
307         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
308 
309         // update dividend trackers
310         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
311         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
312 
313         // fire event
314         Transfer(_customerAddress, _toAddress, _amountOfTokens);
315 
316         // ERC20
317         return true;
318 
319     }
320 
321     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
322     /**
323      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
324      */
325     function disableInitialStage()
326         onlyAdministrator()
327         public
328     {
329         onlyAmbassadors = false;
330     }
331 
332     /**
333      * In case one of us dies, we need to replace ourselves.
334      */
335     function setAdministrator(address _identifier, bool _status)
336         onlyAdministrator()
337         public
338     {
339         administrators[_identifier] = _status;
340     }
341 
342     /**
343      * Precautionary measures in case we need to adjust the masternode rate.
344      */
345     function setStakingRequirement(uint256 _amountOfTokens)
346         onlyAdministrator()
347         public
348     {
349         stakingRequirement = _amountOfTokens;
350     }
351 
352     /**
353      * If we want to rebrand, we can.
354      */
355     function setName(string _name)
356         onlyAdministrator()
357         public
358     {
359         name = _name;
360     }
361 
362     /**
363      * If we want to rebrand, we can.
364      */
365     function setSymbol(string _symbol)
366         onlyAdministrator()
367         public
368     {
369         symbol = _symbol;
370     }
371 
372 
373     /*----------  HELPERS AND CALCULATORS  ----------*/
374     /**
375      * Method to view the current Ethereum stored in the contract
376      * Example: totalEthereumBalance()
377      */
378     function totalEthereumBalance()
379         public
380         view
381         returns(uint)
382     {
383         return this.balance;
384     }
385 
386     /**
387      * Retrieve the total token supply.
388      */
389     function totalSupply()
390         public
391         view
392         returns(uint256)
393     {
394         return tokenSupply_;
395     }
396 
397     /**
398      * Retrieve the tokens owned by the caller.
399      */
400     function myTokens()
401         public
402         view
403         returns(uint256)
404     {
405         address _customerAddress = msg.sender;
406         return balanceOf(_customerAddress);
407     }
408 
409     function referralsOf(address _customerAddress)
410         public
411         view
412         returns(uint256)
413     {
414         return referrals[_customerAddress];
415     }
416 
417     function totalUsers()
418         public
419         view
420         returns(uint256)
421     {
422         return usersAddresses.length;
423     }
424 
425     /**
426      * Retrieve the dividends owned by the caller.
427      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
428      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
429      * But in the internal calculations, we want them separate.
430      */
431     function myDividends(bool _includeReferralBonus)
432         public
433         view
434         returns(uint256)
435     {
436         address _customerAddress = msg.sender;
437         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
438     }
439 
440     /**
441      * Retrieve the token balance of any single address.
442      */
443     function balanceOf(address _customerAddress)
444         view
445         public
446         returns(uint256)
447     {
448         return tokenBalanceLedger_[_customerAddress];
449     }
450 
451     /**
452      * Retrieve the dividend balance of any single address.
453      */
454     function dividendsOf(address _customerAddress)
455         view
456         public
457         returns(uint256)
458     {
459         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
460     }
461 
462     /**
463      * Return the buy price of 1 individual token.
464      */
465     function sellPrice()
466         public
467         view
468         returns(uint256)
469     {
470         // our calculation relies on the token supply, so we need supply. Doh.
471         if(tokenSupply_ == 0){
472             return tokenPriceInitial_ - tokenPriceIncremental_;
473         } else {
474             uint256 _ethereum = tokensToEthereum_(1e18);
475             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
476             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
477             return _taxedEthereum;
478         }
479     }
480 
481     /**
482      * Return the sell price of 1 individual token.
483      */
484     function buyPrice()
485         public
486         view
487         returns(uint256)
488     {
489         // our calculation relies on the token supply, so we need supply. Doh.
490         if(tokenSupply_ == 0){
491             return tokenPriceInitial_ + tokenPriceIncremental_;
492         } else {
493             uint256 _ethereum = tokensToEthereum_(1e18);
494             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
495             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
496             return _taxedEthereum;
497         }
498     }
499 
500     /**
501      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
502      */
503     function calculateTokensReceived(uint256 _ethereumToSpend)
504         public
505         view
506         returns(uint256)
507     {
508         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
509         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
510         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
511 
512         return _amountOfTokens;
513     }
514 
515     /**
516      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
517      */
518     function calculateEthereumReceived(uint256 _tokensToSell)
519         public
520         view
521         returns(uint256)
522     {
523         require(_tokensToSell <= tokenSupply_);
524         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
525         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
526         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
527         return _taxedEthereum;
528     }
529 
530 
531     /*==========================================
532     =            INTERNAL FUNCTIONS            =
533     ==========================================*/
534     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
535         antiEarlyWhale(_incomingEthereum)
536         internal
537         returns(uint256)
538     {
539         // data setup
540         address _customerAddress = msg.sender;
541         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
542         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
543         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
544         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
545         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
546         uint256 _fee = _dividends * magnitude;
547 
548         // no point in continuing execution if OP is a poorfag russian hacker
549         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
550         // (or hackers)
551         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
552         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
553 
554         // is the user referred by a masternode?
555         if(
556             // is this a referred purchase?
557             _referredBy != 0x0000000000000000000000000000000000000000 &&
558 
559             // no cheating!
560             _referredBy != _customerAddress &&
561 
562             // does the referrer have at least X whole tokens?
563             // i.e is the referrer a Kekly chad masternode
564             tokenBalanceLedger_[_referredBy] >= stakingRequirement
565         ){
566             // wealth redistribution
567             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
568 
569             if (isUser[_customerAddress] == false) {
570             	referrals[_referredBy]++;
571             }     
572 
573         } else {
574             // no ref purchase
575             // add the referral bonus back to the global dividends cake
576             _dividends = SafeMath.add(_dividends, _referralBonus);
577             _fee = _dividends * magnitude;
578         }
579 
580         if (isUser[_customerAddress] == false ) {
581         	isUser[_customerAddress] = true;
582         	usersAddresses.push(_customerAddress);
583         }
584 
585         // we can't give people infinite ethereum
586         if(tokenSupply_ > 0){
587 
588             // add tokens to the pool
589             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
590 
591             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
592             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
593 
594             // calculate the amount of tokens the customer receives over his purchase
595             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
596 
597         } else {
598             // add tokens to the pool
599             tokenSupply_ = _amountOfTokens;
600         }
601 
602         // update circulating supply & the ledger address for the customer
603         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
604 
605         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
606         //really i know you think you do but you don't
607         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
608         payoutsTo_[_customerAddress] += _updatedPayouts;
609 
610         // fire event
611         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
612 
613         return _amountOfTokens;
614     }
615 
616     /**
617      * Calculate Token price based on an amount of incoming ethereum
618      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
619      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
620      */
621     function ethereumToTokens_(uint256 _ethereum)
622         internal
623         view
624         returns(uint256)
625     {
626         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
627         uint256 _tokensReceived =
628          (
629             (
630                 // underflow attempts BTFO
631                 SafeMath.sub(
632                     (sqrt
633                         (
634                             (_tokenPriceInitial**2)
635                             +
636                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
637                             +
638                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
639                             +
640                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
641                         )
642                     ), _tokenPriceInitial
643                 )
644             )/(tokenPriceIncremental_)
645         )-(tokenSupply_)
646         ;
647 
648         return _tokensReceived;
649     }
650 
651     /**
652      * Calculate token sell value.
653      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
654      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
655      */
656      function tokensToEthereum_(uint256 _tokens)
657         internal
658         view
659         returns(uint256)
660     {
661 
662         uint256 tokens_ = (_tokens + 1e18);
663         uint256 _tokenSupply = (tokenSupply_ + 1e18);
664         uint256 _etherReceived =
665         (
666             // underflow attempts BTFO
667             SafeMath.sub(
668                 (
669                     (
670                         (
671                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
672                         )-tokenPriceIncremental_
673                     )*(tokens_ - 1e18)
674                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
675             )
676         /1e18);
677         return _etherReceived;
678     }
679 
680 
681     //This is where all your gas goes, sorry
682     //Not sorry, you probably only paid 1 gwei
683     function sqrt(uint x) internal pure returns (uint y) {
684         uint z = (x + 1) / 2;
685         y = x;
686         while (z < y) {
687             y = z;
688             z = (x / z + z) / 2;
689         }
690     }
691 }
692 
693 /**
694  * @title SafeMath
695  * @dev Math operations with safety checks that throw on error
696  */
697 library SafeMath {
698 
699     /**
700     * @dev Multiplies two numbers, throws on overflow.
701     */
702     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
703         if (a == 0) {
704             return 0;
705         }
706         uint256 c = a * b;
707         assert(c / a == b);
708         return c;
709     }
710 
711     /**
712     * @dev Integer division of two numbers, truncating the quotient.
713     */
714     function div(uint256 a, uint256 b) internal pure returns (uint256) {
715         // assert(b > 0); // Solidity automatically throws when dividing by 0
716         uint256 c = a / b;
717         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
718         return c;
719     }
720 
721     /**
722     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
723     */
724     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
725         assert(b <= a);
726         return a - b;
727     }
728 
729     /**
730     * @dev Adds two numbers, throws on overflow.
731     */
732     function add(uint256 a, uint256 b) internal pure returns (uint256) {
733         uint256 c = a + b;
734         assert(c >= a);
735         return c;
736     }
737 }