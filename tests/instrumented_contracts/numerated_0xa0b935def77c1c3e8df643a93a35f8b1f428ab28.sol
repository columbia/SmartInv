1 pragma solidity ^0.4.24;
2 
3 /*
4 YourPyramid is a pyramid made for you.
5 Featuring:
6 NO PREMINE/AMBASSADORS/DEV FEES!!!
7 Starts on a timer.
8 No Contracts.
9 Scaled maxbuy limits (starts at .01 at launch then is 50% of the contract balance)
10 
11 Chat: https://discord.gg/snJt8gb
12 
13 Launches Wednesday, May 30, 2018 8:00:00 PM GMT
14 
15 */
16 
17 contract YourPyramid {
18     /*=================================
19     =            MODIFIERS            =
20     =================================*/
21     // only people with tokens
22     modifier onlyBagholders() {
23         require(myTokens() > 0);
24         _;
25     }
26     
27     // only people with profits
28     modifier onlyStronghands() {
29         require(myDividends(true) > 0);
30         _;
31     }
32     
33     // administrators can:
34     // -> change the name of the contract
35     // -> change the name of the token
36     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
37     // they CANNOT:
38     // -> take funds
39     // -> disable withdrawals
40     // -> kill the contract
41     // -> change the price of tokens
42     modifier onlyAdministrator(){
43         address _customerAddress = msg.sender;
44         require(administrators[_customerAddress]);
45         _;
46     }
47     
48     modifier noContracts() {
49         require (msg.sender == tx.origin);
50         _;
51     }
52     
53     modifier scaledBuys(){
54         if (this.balance <= 0.02 ether) require (msg.value <= 0.01 ether);
55         else require (msg.value <= SafeMath.div(this.balance, 2));
56         _;
57     }
58 
59     modifier started(){
60         require (1527710400 < now);
61         _; 
62         
63         
64     }
65     
66     
67     /*==============================
68     =            EVENTS            =
69     ==============================*/
70     event onTokenPurchase(
71         address indexed customerAddress,
72         uint256 incomingEthereum,
73         uint256 tokensMinted,
74         address indexed referredBy
75     );
76     
77     event onTokenSell(
78         address indexed customerAddress,
79         uint256 tokensBurned,
80         uint256 ethereumEarned
81     );
82     
83     event onReinvestment(
84         address indexed customerAddress,
85         uint256 ethereumReinvested,
86         uint256 tokensMinted
87     );
88     
89     event onWithdraw(
90         address indexed customerAddress,
91         uint256 ethereumWithdrawn
92     );
93     
94     // ERC20
95     event Transfer(
96         address indexed from,
97         address indexed to,
98         uint256 tokens
99     );
100     
101     
102     /*=====================================
103     =            CONFIGURABLES            =
104     =====================================*/
105     string public name = "YourPyramid";
106     string public symbol = "YOUP";
107     uint8 constant public decimals = 18;
108     uint8 constant internal dividendFee_ = 5;
109     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
110     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
111     uint256 constant internal magnitude = 2**64;
112     
113     // proof of stake (defaults at 100 tokens)
114     uint256 public stakingRequirement = 100e18;
115     
116     
117     
118    /*================================
119     =            DATASETS            =
120     ================================*/
121     // amount of shares for each address (scaled number)
122     mapping(address => uint256) internal tokenBalanceLedger_;
123     mapping(address => uint256) internal referralBalance_;
124     mapping(address => int256) internal payoutsTo_;
125     uint256 internal tokenSupply_ = 0;
126     uint256 internal profitPerShare_;
127     
128     // administrator list (see above on what they can do)
129     mapping(address => bool) public administrators;
130     
131 
132 
133     /*=======================================
134     =            PUBLIC FUNCTIONS            =
135     =======================================*/
136     /*
137     * -- APPLICATION ENTRY POINTS --  
138     */
139     function YourPyramid()
140         public
141     {
142         // add administrators here
143         administrators[0x183feBd8828a9ac6c70C0e27FbF441b93004fC05] = true;
144 
145     }
146     
147      
148     /**
149      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
150      */
151     function buy(address _referredBy)
152         public
153         payable
154         returns(uint256)
155     {
156         purchaseTokens(msg.value, _referredBy);
157     }
158     
159     /**
160      * Fallback function to handle ethereum that was send straight to the contract
161      * Unfortunately we cannot use a referral address this way.
162      */
163     function()
164         payable
165         public
166     {
167         purchaseTokens(msg.value, 0x0);
168     }
169     
170     /**
171      * Converts all of caller's dividends to tokens.
172      */
173     function reinvest()
174         onlyStronghands()
175         public
176     {
177         // fetch dividends
178         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
179         
180         // pay out the dividends virtually
181         address _customerAddress = msg.sender;
182         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
183         
184         // retrieve ref. bonus
185         _dividends += referralBalance_[_customerAddress];
186         referralBalance_[_customerAddress] = 0;
187         
188         // dispatch a buy order with the virtualized "withdrawn dividends"
189         uint256 _tokens = purchaseTokens(_dividends, 0x0);
190         
191         // fire event
192         onReinvestment(_customerAddress, _dividends, _tokens);
193     }
194     
195     /**
196      * Alias of sell() and withdraw().
197      */
198     function exit()
199         public
200     {
201         // get token count for caller & sell them all
202         address _customerAddress = msg.sender;
203         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
204         if(_tokens > 0) sell(_tokens);
205         
206         // lambo delivery service
207         withdraw();
208     }
209 
210     /**
211      * Withdraws all of the callers earnings.
212      */
213     function withdraw()
214         onlyStronghands()
215         public
216     {
217         // setup data
218         address _customerAddress = msg.sender;
219         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
220         
221         // update dividend tracker
222         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
223         
224         // add ref. bonus
225         _dividends += referralBalance_[_customerAddress];
226         referralBalance_[_customerAddress] = 0;
227         
228         // lambo delivery service
229         _customerAddress.transfer(_dividends);
230         
231         // fire event
232         onWithdraw(_customerAddress, _dividends);
233     }
234     
235     /**
236      * Liquifies tokens to ethereum.
237      */
238     function sell(uint256 _amountOfTokens)
239         onlyBagholders()
240         public
241     {
242         // setup data
243         address _customerAddress = msg.sender;
244         // russian hackers BTFO
245         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
246         uint256 _tokens = _amountOfTokens;
247         uint256 _ethereum = tokensToEthereum_(_tokens);
248         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
249         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
250         
251         // burn the sold tokens
252         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
253         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
254         
255         // update dividends tracker
256         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
257         payoutsTo_[_customerAddress] -= _updatedPayouts;       
258         
259         // dividing by zero is a bad idea
260         if (tokenSupply_ > 0) {
261             // update the amount of dividends per token
262             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
263         }
264         
265         // fire event
266         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
267     }
268     
269     
270     /**
271      * Transfer tokens from the caller to a new holder.
272      * Remember, there's a 10% fee here as well.
273      */
274     function transfer(address _toAddress, uint256 _amountOfTokens)
275         onlyBagholders()
276         public
277         returns(bool)
278     {
279         // setup
280         address _customerAddress = msg.sender;
281         
282         // make sure we have the requested tokens
283 
284         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
285         
286         // withdraw all outstanding dividends first
287         if(myDividends(true) > 0) withdraw();
288 
289         // exchange tokens
290         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
291         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
292         
293         // update dividend trackers
294         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
295         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
296         
297         // fire event
298         Transfer(_customerAddress, _toAddress, _amountOfTokens);
299         
300         // ERC20
301         return true;
302        
303     }
304     
305     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
306     /**
307     
308     /**
309      * In case one of us dies, we need to replace ourselves.
310      */
311     function setAdministrator(address _identifier, bool _status)
312         onlyAdministrator()
313         public
314     {
315         administrators[_identifier] = _status;
316     }
317     
318     /**
319      * Precautionary measures in case we need to adjust the masternode rate.
320      */
321     function setStakingRequirement(uint256 _amountOfTokens)
322         onlyAdministrator()
323         public
324     {
325         stakingRequirement = _amountOfTokens;
326     }
327     
328     /**
329      * If we want to rebrand, we can.
330      */
331     function setName(string _name)
332         onlyAdministrator()
333         public
334     {
335         name = _name;
336     }
337     
338     /**
339      * If we want to rebrand, we can.
340      */
341     function setSymbol(string _symbol)
342         onlyAdministrator()
343         public
344     {
345         symbol = _symbol;
346     }
347 
348     
349     /*----------  HELPERS AND CALCULATORS  ----------*/
350     /**
351      * Method to view the current Ethereum stored in the contract
352      * Example: totalEthereumBalance()
353      */
354     function totalEthereumBalance()
355         public
356         view
357         returns(uint)
358     {
359         return this.balance;
360     }
361     
362     /**
363      * Retrieve the total token supply.
364      */
365     function totalSupply()
366         public
367         view
368         returns(uint256)
369     {
370         return tokenSupply_;
371     }
372     
373     /**
374      * Retrieve the tokens owned by the caller.
375      */
376     function myTokens()
377         public
378         view
379         returns(uint256)
380     {
381         address _customerAddress = msg.sender;
382         return balanceOf(_customerAddress);
383     }
384     
385     /**
386      * Retrieve the dividends owned by the caller.
387      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
388      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
389      * But in the internal calculations, we want them separate. 
390      */ 
391     function myDividends(bool _includeReferralBonus) 
392         public 
393         view 
394         returns(uint256)
395     {
396         address _customerAddress = msg.sender;
397         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
398     }
399     
400     /**
401      * Retrieve the token balance of any single address.
402      */
403     function balanceOf(address _customerAddress)
404         view
405         public
406         returns(uint256)
407     {
408         return tokenBalanceLedger_[_customerAddress];
409     }
410     
411     /**
412      * Retrieve the dividend balance of any single address.
413      */
414     function dividendsOf(address _customerAddress)
415         view
416         public
417         returns(uint256)
418     {
419         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
420     }
421     
422     /**
423      * Return the buy price of 1 individual token.
424      */
425     function sellPrice() 
426         public 
427         view 
428         returns(uint256)
429     {
430         // our calculation relies on the token supply, so we need supply. Doh.
431         if(tokenSupply_ == 0){
432             return tokenPriceInitial_ - tokenPriceIncremental_;
433         } else {
434             uint256 _ethereum = tokensToEthereum_(1e18);
435             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
436             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
437             return _taxedEthereum;
438         }
439     }
440     
441     /**
442      * Return the sell price of 1 individual token.
443      */
444     function buyPrice() 
445         public 
446         view 
447         returns(uint256)
448     {
449         // our calculation relies on the token supply, so we need supply. Doh.
450         if(tokenSupply_ == 0){
451             return tokenPriceInitial_ + tokenPriceIncremental_;
452         } else {
453             uint256 _ethereum = tokensToEthereum_(1e18);
454             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
455             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
456             return _taxedEthereum;
457         }
458     }
459     
460     /**
461      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
462      */
463     function calculateTokensReceived(uint256 _ethereumToSpend) 
464         public 
465         view 
466         returns(uint256)
467     {
468         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
469         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
470         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
471         
472         return _amountOfTokens;
473     }
474     
475     /**
476      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
477      */
478     function calculateEthereumReceived(uint256 _tokensToSell) 
479         public 
480         view 
481         returns(uint256)
482     {
483         require(_tokensToSell <= tokenSupply_);
484         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
485         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
486         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
487         return _taxedEthereum;
488     }
489     
490     
491     /*==========================================
492     =            INTERNAL FUNCTIONS            =
493     ==========================================*/
494     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
495         noContracts()
496         started()
497         scaledBuys()
498         internal
499         returns(uint256)
500     {
501         // data setup
502         address _customerAddress = msg.sender;
503         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
504         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
505         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
506         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
507         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
508         uint256 _fee = _dividends * magnitude;
509  
510         // no point in continuing execution if OP is a poorfag russian hacker
511         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
512         // (or hackers)
513         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
514         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
515         
516         // is the user referred by a masternode?
517         if(
518             // is this a referred purchase?
519             _referredBy != 0x0000000000000000000000000000000000000000 &&
520 
521             // no cheating!
522             _referredBy != _customerAddress &&
523             
524             // does the referrer have at least X whole tokens?
525             // i.e is the referrer a godly chad masternode
526             tokenBalanceLedger_[_referredBy] >= stakingRequirement
527         ){
528             // wealth redistribution
529             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
530         } else {
531             // no ref purchase
532             // add the referral bonus back to the global dividends cake
533             _dividends = SafeMath.add(_dividends, _referralBonus);
534             _fee = _dividends * magnitude;
535         }
536         
537         // we can't give people infinite ethereum
538         if(tokenSupply_ > 0){
539             
540             // add tokens to the pool
541             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
542  
543             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
544             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
545             
546             // calculate the amount of tokens the customer receives over his purchase 
547             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
548         
549         } else {
550             // add tokens to the pool
551             tokenSupply_ = _amountOfTokens;
552         }
553         
554         // update circulating supply & the ledger address for the customer
555         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
556         
557         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
558         //really i know you think you do but you don't
559         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
560         payoutsTo_[_customerAddress] += _updatedPayouts;
561         
562         // fire event
563         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
564         
565         return _amountOfTokens;
566     }
567 
568     /**
569      * Calculate Token price based on an amount of incoming ethereum
570      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
571      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
572      */
573     function ethereumToTokens_(uint256 _ethereum)
574         internal
575         view
576         returns(uint256)
577     {
578         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
579         uint256 _tokensReceived = 
580          (
581             (
582                 // underflow attempts BTFO
583                 SafeMath.sub(
584                     (sqrt
585                         (
586                             (_tokenPriceInitial**2)
587                             +
588                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
589                             +
590                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
591                             +
592                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
593                         )
594                     ), _tokenPriceInitial
595                 )
596             )/(tokenPriceIncremental_)
597         )-(tokenSupply_)
598         ;
599   
600         return _tokensReceived;
601     }
602     
603     /**
604      * Calculate token sell value.
605      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
606      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
607      */
608      function tokensToEthereum_(uint256 _tokens)
609         internal
610         view
611         returns(uint256)
612     {
613 
614         uint256 tokens_ = (_tokens + 1e18);
615         uint256 _tokenSupply = (tokenSupply_ + 1e18);
616         uint256 _etherReceived =
617         (
618             // underflow attempts BTFO
619             SafeMath.sub(
620                 (
621                     (
622                         (
623                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
624                         )-tokenPriceIncremental_
625                     )*(tokens_ - 1e18)
626                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
627             )
628         /1e18);
629         return _etherReceived;
630     }
631     
632     
633     //This is where all your gas goes, sorry
634     //Not sorry, you probably only paid 1 gwei
635     function sqrt(uint x) internal pure returns (uint y) {
636         uint z = (x + 1) / 2;
637         y = x;
638         while (z < y) {
639             y = z;
640             z = (x / z + z) / 2;
641         }
642     }
643 }
644 
645 /**
646  * @title SafeMath
647  * @dev Math operations with safety checks that throw on error
648  */
649 library SafeMath {
650 
651     /**
652     * @dev Multiplies two numbers, throws on overflow.
653     */
654     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
655         if (a == 0) {
656             return 0;
657         }
658         uint256 c = a * b;
659         assert(c / a == b);
660         return c;
661     }
662 
663     /**
664     * @dev Integer division of two numbers, truncating the quotient.
665     */
666     function div(uint256 a, uint256 b) internal pure returns (uint256) {
667         // assert(b > 0); // Solidity automatically throws when dividing by 0
668         uint256 c = a / b;
669         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
670         return c;
671     }
672 
673     /**
674     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
675     */
676     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
677         assert(b <= a);
678         return a - b;
679     }
680 
681     /**
682     * @dev Adds two numbers, throws on overflow.
683     */
684     function add(uint256 a, uint256 b) internal pure returns (uint256) {
685         uint256 c = a + b;
686         assert(c >= a);
687         return c;
688     }
689 }