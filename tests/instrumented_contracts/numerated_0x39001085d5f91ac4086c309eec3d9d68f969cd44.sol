1 /*
2     
3     	What the F is this all about? 
4     	We are a clone simple as that. 
5     	But we differentiate in the way we pay our divs. 
6     	Safe for everybody. Anti Whale Dump. 
7     	- Buys - 15% fee goes to all current token holders. 
8     	- Sells - 15% fee to all current tokens holders. And it’s lower because you shouldn’t have to pay the sane fee exiting. You deserve more. 
9     	- Transfers - 0% fee! We have plans for games and we don't want that to be an obstacle!
10     	- Masternode - you get 7% from deposit of all players who enter using your Masternode . 
11         - Premine - .15 Eth Only
12         - https://www.proofofexistence.com
13     */
14     
15     contract ProofOfExistence {
16         /*=================================
17         =            MODIFIERS            =
18         =================================*/
19         // only people with tokens
20         modifier onlyBagholders() {
21             require(myTokens() > 0);
22             _;
23         }
24     
25         // only people with profits
26         modifier onlyStronghands() {
27             require(myDividends(true) > 0);
28             _;
29         }
30     
31         // administrators can:
32         // -> change the name of the contract
33         // -> change the name of the token
34         // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
35         // they CANNOT:
36         // -> take funds
37         // -> disable withdrawals
38         // -> kill the contract
39         // -> change the price of tokens
40         modifier onlyAdministrator(){
41             address _customerAddress = msg.sender;
42             require(administrators[_customerAddress]);
43             _;
44         }
45     
46     
47         // ensures that the first tokens in the contract will be equally distributed
48         // meaning, no divine dump will be ever possible
49         // result: healthy longevity.
50         modifier antiEarlyWhale(uint256 _amountOfEthereum){
51             address _customerAddress = msg.sender;
52     
53             // are we still in the vulnerable phase?
54             // if so, enact anti early whale protocol
55             if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
56                 require(
57                     // is the customer in the ambassador list?
58                     ambassadors_[_customerAddress] == true &&
59     
60                     // does the customer purchase exceed the max ambassador quota?
61                     (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
62     
63                 );
64     
65                 // updated the accumulated quota
66                 ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
67     
68                 // execute
69                 _;
70             } else {
71                 // in case the ether count drops low, the ambassador phase won't reinitiate
72                 onlyAmbassadors = false;
73                 _;
74             }
75         }
76     
77         /*==============================
78         =            EVENTS            =
79         ==============================*/
80         event onTokenPurchase(
81             address indexed customerAddress,
82             uint256 incomingEthereum,
83             uint256 tokensMinted,
84             address indexed referredBy
85         );
86     
87         event onTokenSell(
88             address indexed customerAddress,
89             uint256 tokensBurned,
90             uint256 ethereumEarned
91         );
92     
93         event onReinvestment(
94             address indexed customerAddress,
95             uint256 ethereumReinvested,
96             uint256 tokensMinted
97         );
98     
99         event onWithdraw(
100             address indexed customerAddress,
101             uint256 ethereumWithdrawn
102         );
103     
104         // ERC20
105         event Transfer(
106             address indexed from,
107             address indexed to,
108             uint256 tokens
109         );
110     
111         /*=====================================
112         =            CONFIGURABLES            =
113         =====================================*/
114         string public name = "ProofOfExistence";
115         string public symbol = "POE";
116         uint8 constant public decimals = 18;
117         uint8 constant internal entryFee_ = 15; // 15% for Buying
118         uint8 constant internal refferalFee_ = 20; // 20% from enter fee divs or 7% for each invite
119         uint8 constant internal exitFee_ = 15; // 15% for selling
120         uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
121         uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
122         uint256 constant internal magnitude = 2**64;
123     
124         // proof of stake (defaults at 100 tokens)
125         uint256 public stakingRequirement = 100e18;
126     
127         // ambassador program
128         mapping(address => bool) internal ambassadors_;
129         uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
130         uint256 constant internal ambassadorQuota_ = 1 ether;
131     
132         // referral program
133         mapping(address => uint256) internal referrals;
134         mapping(address => bool) internal isUser;
135         address[] public usersAddresses;
136     
137        /*================================
138         =            DATASETS            =
139         ================================*/
140         // amount of shares for each address (scaled number)
141         mapping(address => uint256) internal tokenBalanceLedger_;
142         mapping(address => uint256) internal referralBalance_;
143         mapping(address => int256) internal payoutsTo_;
144         mapping(address => uint256) internal ambassadorAccumulatedQuota_;
145         uint256 internal tokenSupply_ = 0;
146         uint256 internal profitPerShare_;
147     
148         // administrator list (see above on what they can do)
149         mapping(address => bool) public administrators;
150     
151         // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
152         bool public onlyAmbassadors = true;
153     
154         /*=======================================
155         =            PUBLIC FUNCTIONS            =
156         =======================================*/
157         /*
158         * -- APPLICATION ENTRY POINTS --
159         */
160         function ProofOfExistence()
161             public
162         {
163             // add administrators here with their wallets
164     
165     		administrators[0xb327D112A560f832765a12c72451DE40AF3C2be2] = true;
166     	
167     
168     	
169     		administrators[msg.sender] = true;
170         }
171     
172     
173         /**
174          * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
175          */
176         function buy(address _referredBy)
177             public
178             payable
179             returns(uint256)
180         {
181             purchaseTokens(msg.value, _referredBy);
182         }
183     
184         /**
185          * Fallback function to handle ethereum that was send straight to the contract
186          * Unfortunately we cannot use a referral address this way.
187          */
188         function()
189             payable
190             public
191         {
192             purchaseTokens(msg.value, 0x0);
193         }
194     
195         /* Converts all of caller's dividends to tokens. */
196         function reinvest() onlyStronghands() public {
197             // fetch dividends
198             uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
199     
200             // pay out the dividends virtually
201             address _customerAddress = msg.sender;
202             payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
203     
204             // retrieve ref. bonus
205             _dividends += referralBalance_[_customerAddress];
206             referralBalance_[_customerAddress] = 0;
207     
208             // dispatch a buy order with the virtualized "withdrawn dividends"
209             uint256 _tokens = purchaseTokens(_dividends, 0x0);
210     
211             // fire event
212             onReinvestment(_customerAddress, _dividends, _tokens);
213         }
214     
215         /* Alias of sell() and withdraw(). */
216         function exit() public {
217             // get token count for caller & sell them all
218             address _customerAddress = msg.sender;
219             uint256 _tokens = tokenBalanceLedger_[_customerAddress];
220             if(_tokens > 0) sell(_tokens);
221     
222             // lambo delivery service
223             withdraw();
224         }
225     
226         /* Withdraws all of the callers earnings. */
227         function withdraw() onlyStronghands() public {
228             // setup data
229             address _customerAddress = msg.sender;
230             uint256 _dividends = myDividends(false); // get ref. bonus later in the code
231     
232             // update dividend tracker
233             payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
234     
235             // add ref. bonus
236             _dividends += referralBalance_[_customerAddress];
237             referralBalance_[_customerAddress] = 0;
238     
239             // lambo delivery service
240             _customerAddress.transfer(_dividends);
241     
242             // fire event
243             onWithdraw(_customerAddress, _dividends);
244         }
245     
246         /* Liquifies tokens to ethereum. */
247         function sell(uint256 _amountOfTokens) onlyBagholders() public {
248             // setup data
249             address _customerAddress = msg.sender;
250             // russian hackers BTFO
251             require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
252             uint256 _tokens = _amountOfTokens;
253             uint256 _ethereum = tokensToEthereum_(_tokens);
254             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
255             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
256     
257             // burn the sold tokens
258             tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
259             tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
260     
261             // update dividends tracker
262             int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
263             payoutsTo_[_customerAddress] -= _updatedPayouts;
264     
265             // dividing by zero is a bad idea
266             if (tokenSupply_ > 0) {
267                 // update the amount of dividends per token
268                 profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
269             }
270     
271             // fire event
272             onTokenSell(_customerAddress, _tokens, _taxedEthereum);
273         }
274     
275     
276         /* Transfer tokens from the caller to a new holder. * No fee! */
277         function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders() public returns(bool) {
278             // setup
279             address _customerAddress = msg.sender;
280     
281             // make sure we have the requested tokens
282             // also disables transfers until ambassador phase is over
283             // ( we dont want whale premines )
284             require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
285     
286             // withdraw all outstanding dividends first
287             if(myDividends(true) > 0) withdraw();
288     
289             // exchange tokens
290             tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
291             tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
292     
293             // update dividend trackers
294             payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
295             payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
296     
297             // fire event
298             Transfer(_customerAddress, _toAddress, _amountOfTokens);
299     
300             // ERC20
301             return true;
302     
303         }
304     
305         /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
306         /**
307          * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
308          */
309         function disableInitialStage()
310             onlyAdministrator()
311             public
312         {
313             onlyAmbassadors = false;
314         }
315     
316         /**
317          * In case one of us dies, we need to replace ourselves.
318          */
319         function setAdministrator(address _identifier, bool _status)
320             onlyAdministrator()
321             public
322         {
323             administrators[_identifier] = _status;
324         }
325     
326         /**
327          * Precautionary measures in case we need to adjust the masternode rate.
328          */
329         function setStakingRequirement(uint256 _amountOfTokens)
330             onlyAdministrator()
331             public
332         {
333             stakingRequirement = _amountOfTokens;
334         }
335     
336         /**
337          * If we want to rebrand, we can.
338          */
339         function setName(string _name)
340             onlyAdministrator()
341             public
342         {
343             name = _name;
344         }
345     
346         /**
347          * If we want to rebrand, we can.
348          */
349         function setSymbol(string _symbol)
350             onlyAdministrator()
351             public
352         {
353             symbol = _symbol;
354         }
355     
356     
357         /*----------  HELPERS AND CALCULATORS  ----------*/
358         /**
359          * Method to view the current Ethereum stored in the contract
360          * Example: totalEthereumBalance()
361          */
362         function totalEthereumBalance()
363             public
364             view
365             returns(uint)
366         {
367             return this.balance;
368         }
369     
370         /**
371          * Retrieve the total token supply.
372          */
373         function totalSupply()
374             public
375             view
376             returns(uint256)
377         {
378             return tokenSupply_;
379         }
380     
381         /**
382          * Retrieve the tokens owned by the caller.
383          */
384         function myTokens()
385             public
386             view
387             returns(uint256)
388         {
389             address _customerAddress = msg.sender;
390             return balanceOf(_customerAddress);
391         }
392     
393         function referralsOf(address _customerAddress)
394             public
395             view
396             returns(uint256)
397         {
398             return referrals[_customerAddress];
399         }
400     
401         function totalUsers()
402             public
403             view
404             returns(uint256)
405         {
406             return usersAddresses.length;
407         }
408     
409         /**
410          * Retrieve the dividends owned by the caller.
411          * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
412          * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
413          * But in the internal calculations, we want them separate.
414          */
415         function myDividends(bool _includeReferralBonus)
416             public
417             view
418             returns(uint256)
419         {
420             address _customerAddress = msg.sender;
421             return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
422         }
423     
424         /**
425          * Retrieve the token balance of any single address.
426          */
427         function balanceOf(address _customerAddress)
428             view
429             public
430             returns(uint256)
431         {
432             return tokenBalanceLedger_[_customerAddress];
433         }
434     
435         /**
436          * Retrieve the dividend balance of any single address.
437          */
438         function dividendsOf(address _customerAddress)
439             view
440             public
441             returns(uint256)
442         {
443             return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
444         }
445     
446         /**
447          * Return the buy price of 1 individual token.
448          */
449         function sellPrice()
450             public
451             view
452             returns(uint256)
453         {
454             // our calculation relies on the token supply, so we need supply. Doh.
455             if(tokenSupply_ == 0){
456                 return tokenPriceInitial_ - tokenPriceIncremental_;
457             } else {
458                 uint256 _ethereum = tokensToEthereum_(1e18);
459                 uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
460                 uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
461                 return _taxedEthereum;
462             }
463         }
464     
465         /**
466          * Return the sell price of 1 individual token.
467          */
468         function buyPrice()
469             public
470             view
471             returns(uint256)
472         {
473             // our calculation relies on the token supply, so we need supply. Doh.
474             if(tokenSupply_ == 0){
475                 return tokenPriceInitial_ + tokenPriceIncremental_;
476             } else {
477                 uint256 _ethereum = tokensToEthereum_(1e18);
478                 uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
479                 uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
480                 return _taxedEthereum;
481             }
482         }
483     
484         /**
485          * Function for the frontend to dynamically retrieve the price scaling of buy orders.
486          */
487         function calculateTokensReceived(uint256 _ethereumToSpend)
488             public
489             view
490             returns(uint256)
491         {
492             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
493             uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
494             uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
495     
496             return _amountOfTokens;
497         }
498     
499         /**
500          * Function for the frontend to dynamically retrieve the price scaling of sell orders.
501          */
502         function calculateEthereumReceived(uint256 _tokensToSell)
503             public
504             view
505             returns(uint256)
506         {
507             require(_tokensToSell <= tokenSupply_);
508             uint256 _ethereum = tokensToEthereum_(_tokensToSell);
509             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
510             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
511             return _taxedEthereum;
512         }
513     
514     
515         /*==========================================
516         =            INTERNAL FUNCTIONS            =
517         ==========================================*/
518         function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
519             antiEarlyWhale(_incomingEthereum)
520             internal
521             returns(uint256)
522         {
523             // data setup
524             address _customerAddress = msg.sender;
525             uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
526             uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
527             uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
528             uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
529             uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
530             uint256 _fee = _dividends * magnitude;
531     
532             // no point in continuing execution if OP is a poorfag russian hacker
533             // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
534             // (or hackers)
535             // and yes we know that the safemath function automatically rules out the "greater then" equasion.
536             require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
537     
538             // is the user referred by a masternode?
539             if(
540                 // is this a referred purchase?
541                 _referredBy != 0x0000000000000000000000000000000000000000 &&
542     
543                 // no cheating!
544                 _referredBy != _customerAddress &&
545     
546                 // does the referrer have at least X whole tokens?
547                 // i.e is the referrer a Kekly chad masternode
548                 tokenBalanceLedger_[_referredBy] >= stakingRequirement
549             ){
550                 // wealth redistribution
551                 referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
552     
553                 if (isUser[_customerAddress] == false) {
554                 	referrals[_referredBy]++;
555                 }     
556     
557             } else {
558                 // no ref purchase
559                 // add the referral bonus back to the global dividends cake
560                 _dividends = SafeMath.add(_dividends, _referralBonus);
561                 _fee = _dividends * magnitude;
562             }
563     
564             if (isUser[_customerAddress] == false ) {
565             	isUser[_customerAddress] = true;
566             	usersAddresses.push(_customerAddress);
567             }
568     
569             // we can't give people infinite ethereum
570             if(tokenSupply_ > 0){
571     
572                 // add tokens to the pool
573                 tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
574     
575                 // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
576                 profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
577     
578                 // calculate the amount of tokens the customer receives over his purchase
579                 _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
580     
581             } else {
582                 // add tokens to the pool
583                 tokenSupply_ = _amountOfTokens;
584             }
585     
586             // update circulating supply & the ledger address for the customer
587             tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
588     
589             // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
590             //really i know you think you do but you don't
591             int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
592             payoutsTo_[_customerAddress] += _updatedPayouts;
593     
594             // fire event
595             onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
596     
597             return _amountOfTokens;
598         }
599     
600         /**
601          * Calculate Token price based on an amount of incoming ethereum
602          * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
603          * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
604          */
605         function ethereumToTokens_(uint256 _ethereum)
606             internal
607             view
608             returns(uint256)
609         {
610             uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
611             uint256 _tokensReceived =
612              (
613                 (
614                     // underflow attempts BTFO
615                     SafeMath.sub(
616                         (sqrt
617                             (
618                                 (_tokenPriceInitial**2)
619                                 +
620                                 (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
621                                 +
622                                 (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
623                                 +
624                                 (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
625                             )
626                         ), _tokenPriceInitial
627                     )
628                 )/(tokenPriceIncremental_)
629             )-(tokenSupply_)
630             ;
631     
632             return _tokensReceived;
633         }
634     
635         /**
636          * Calculate token sell value.
637          * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
638          * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
639          */
640          function tokensToEthereum_(uint256 _tokens)
641             internal
642             view
643             returns(uint256)
644         {
645     
646             uint256 tokens_ = (_tokens + 1e18);
647             uint256 _tokenSupply = (tokenSupply_ + 1e18);
648             uint256 _etherReceived =
649             (
650                 // underflow attempts BTFO
651                 SafeMath.sub(
652                     (
653                         (
654                             (
655                                 tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
656                             )-tokenPriceIncremental_
657                         )*(tokens_ - 1e18)
658                     ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
659                 )
660             /1e18);
661             return _etherReceived;
662         }
663     
664     
665         //This is where all your gas goes, sorry
666         //Not sorry, you probably only paid 1 gwei
667         function sqrt(uint x) internal pure returns (uint y) {
668             uint z = (x + 1) / 2;
669             y = x;
670             while (z < y) {
671                 y = z;
672                 z = (x / z + z) / 2;
673             }
674         }
675     }
676     
677     /**
678      * @title SafeMath
679      * @dev Math operations with safety checks that throw on error
680      */
681     library SafeMath {
682     
683         /**
684         * @dev Multiplies two numbers, throws on overflow.
685         */
686         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
687             if (a == 0) {
688                 return 0;
689             }
690             uint256 c = a * b;
691             assert(c / a == b);
692             return c;
693         }
694     
695         /**
696         * @dev Integer division of two numbers, truncating the quotient.
697         */
698         function div(uint256 a, uint256 b) internal pure returns (uint256) {
699             // assert(b > 0); // Solidity automatically throws when dividing by 0
700             uint256 c = a / b;
701             // assert(a == b * c + a % b); // There is no case in which this doesn't hold
702             return c;
703         }
704     
705         /**
706         * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
707         */
708         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
709             assert(b <= a);
710             return a - b;
711         }
712     
713         /**
714         * @dev Adds two numbers, throws on overflow.
715         */
716         function add(uint256 a, uint256 b) internal pure returns (uint256) {
717             uint256 c = a + b;
718             assert(c >= a);
719             return c;
720         }
721     }