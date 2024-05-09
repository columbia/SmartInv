1 pragma solidity ^0.4.19;
2 
3 /**
4 *This is the PoWH3D code but Norsefire but his dick in it.
5 * Defapabitch (me) has unfucked the mistakes Norsefire did, which was to put dumb fucking comments here.
6 * Defapabitch, student.
7 **/
8 
9 contract Defapacoin {
10 
11     /*=================================
12     =            MODIFIERS            =
13     =================================*/
14     // only people with tokens
15     modifier onlyBagholders() {
16         require(myTokens() > 0);
17         _;
18     }
19     
20     // only people with profits
21     modifier onlyStronghands() {
22         require(myDividends(true) > 0);
23         _;
24     }
25     
26     // administrators can:
27     // -> change the name of the contract
28     // -> change the name of the token
29     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
30     // they CANNOT:
31     // -> take funds
32     // -> disable withdrawals
33     // -> kill the contract
34     // -> change the price of tokens
35     modifier onlyAdministrator(){
36         address _customerAddress = msg.sender;
37         require(administrators[keccak256(_customerAddress)]);
38         _;
39     }    
40     
41     /*==============================
42     =            EVENTS            =
43     ==============================*/
44     event onTokenPurchase(
45         address indexed customerAddress,
46         uint256 incomingEthereum,
47         uint256 tokensMinted,
48         address indexed referredBy
49     );
50     
51     event onTokenSell(
52         address indexed customerAddress,
53         uint256 tokensBurned,
54         uint256 ethereumEarned
55     );
56     
57     event onReinvestment(
58         address indexed customerAddress,
59         uint256 ethereumReinvested,
60         uint256 tokensMinted
61     );
62     
63     event onWithdraw(
64         address indexed customerAddress,
65         uint256 ethereumWithdrawn
66     );
67     
68     // ERC20
69     event Transfer(
70         address indexed from,
71         address indexed to,
72         uint256 tokens
73     );
74     
75     event Approval(
76         address indexed owner,
77         address indexed spender,
78         uint256 value
79     );    
80     
81     /*=====================================
82     =            CONFIGURABLES            =
83     =====================================*/
84     string public name = "Defapacoin";
85     string public symbol = "Defap";
86     uint8 constant public decimals = 18;
87     uint8 constant internal dividendFee_ = 10;
88     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
89     uint256 constant internal tokenPriceIncremental_ = 100 ether;
90     uint256 constant internal magnitude = 2**64;
91     
92     // proof of stake (defaults at 100 tokens)
93     uint256 public stakingRequirement = 100e18;
94     
95     // ambassador program
96     mapping(address => bool) internal ambassadors_;
97     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
98     uint256 constant internal ambassadorQuota_ = 1 ether;
99     
100    /*================================
101     =            DATASETS            =
102     ================================*/
103     // amount of shares for each address (scaled number)
104     mapping(address => uint256) internal tokenBalanceLedger_;
105     mapping(address => uint256) internal referralBalance_;
106     mapping(address => int256) internal payoutsTo_;
107     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
108     uint256 internal tokenSupply_ = 0;
109     uint256 internal profitPerShare_;
110     
111     // Owner of account approves the transfer of an amount to another account
112     mapping(address => mapping (address => uint256)) allowed;
113     
114     // administrator list (see above on what they can do)
115     mapping(bytes32 => bool) public administrators;
116     
117     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
118     bool public onlyAmbassadors = false;
119     
120     /*=======================================
121     =            PUBLIC FUNCTIONS            =
122     =======================================*/
123     /*
124     * -- APPLICATION ENTRY POINTS --  
125     */
126     function Defapacoin()
127         public
128     {  
129     
130     }
131          
132     /**
133      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
134      */
135     function buy(address _referredBy)
136         public
137         payable
138         returns(uint256)
139     {
140         purchaseTokens(msg.value, _referredBy);
141     }
142     
143     /**
144      * Fallback function to handle ethereum that was send straight to the contract
145      * Unfortunately we cannot use a referral address this way.
146      */
147     function()
148         payable
149         public
150     {
151         purchaseTokens(msg.value, 0x0);
152     }
153     
154     /**
155      * Converts all of caller's dividends to tokens.
156      */
157     function reinvest()
158         onlyStronghands()
159         public
160     {
161         // fetch dividends
162         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
163         
164         // pay out the dividends virtually
165         address _customerAddress = msg.sender;
166         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
167         
168         // retrieve ref. bonus
169         _dividends += referralBalance_[_customerAddress];
170         referralBalance_[_customerAddress] = 0;
171         
172         // dispatch a buy order with the virtualized "withdrawn dividends"
173         uint256 _tokens = purchaseTokens(_dividends, 0x0);
174         
175         // fire event
176         onReinvestment(_customerAddress, _dividends, _tokens);
177     }
178     
179     /**
180      * Alias of sell() and withdraw().
181      */
182     function exit()
183         public
184     {
185         // get token count for caller & sell them all
186         address _customerAddress = msg.sender;
187         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
188         if(_tokens > 0) sell(_tokens);
189         
190         // lambo delivery service
191         withdraw();
192     }
193 
194     /**
195      * Withdraws all of the callers earnings.
196      */
197     function withdraw()
198         onlyStronghands()
199         public
200     {
201         // setup data
202         address _customerAddress = msg.sender;
203         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
204         
205         // update dividend tracker
206         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
207         
208         // add ref. bonus
209         _dividends += referralBalance_[_customerAddress];
210         referralBalance_[_customerAddress] = 0;
211         
212         // lambo delivery service
213         _customerAddress.transfer(_dividends);
214         
215         // fire event
216         onWithdraw(_customerAddress, _dividends);
217     }
218     
219     /**
220      * Liquifies tokens to ethereum.
221      */
222     function sell(uint256 _amountOfTokens)
223         onlyBagholders()
224         public
225     {
226         // setup data
227         address _customerAddress = msg.sender;
228         // russian hackers BTFO
229         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
230         uint256 _tokens = _amountOfTokens;
231         uint256 _ethereum = tokensToEthereum_(_tokens);
232         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
233         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
234         
235         // burn the sold tokens
236         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
237         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
238         
239         // update dividends tracker
240         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
241         payoutsTo_[_customerAddress] -= _updatedPayouts;       
242         
243         // dividing by zero is a bad idea
244         if (tokenSupply_ > 0) {
245             // update the amount of dividends per token
246             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
247         }
248         
249         // fire event
250         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
251     }
252     
253     
254     /**
255      * Transfer tokens from the caller to a new holder.
256      * NEW AND IMPROVED ZERO FEE ON TRANSFER BECAUSE FUCK EXTORTION
257      */
258     function transfer(address _toAddress, uint256 _amountOfTokens)
259         onlyBagholders()
260         public
261         returns(bool)
262     {
263         // setup
264         address _customerAddress = msg.sender;
265         
266         // make sure we have the requested tokens
267         // also disables transfers until ambassador phase is over
268         // ( we dont want whale premines )
269         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
270         
271         // withdraw all outstanding dividends first
272         if(myDividends(true) > 0) withdraw();
273         
274         // exchange tokens
275         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
276         
277         // fire event
278         transferFrom(_customerAddress, _toAddress, 0);
279         
280         // ERC20
281         return true;
282        
283     }
284     
285     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
286 
287     /**
288      * In case one of us dies, we need to replace ourselves.
289      */
290     function setAdministrator(bytes32 _identifier, bool _status)
291         onlyAdministrator()
292         public
293     {
294         administrators[_identifier] = _status;
295     }
296     
297     /**
298      * Precautionary measures in case we need to adjust the masternode rate.
299      */
300     function setStakingRequirement(uint256 _amountOfTokens)
301         onlyAdministrator()
302         public
303     {
304         stakingRequirement = _amountOfTokens;
305     }
306     
307     /**
308      * If we want to rebrand, we can.
309      */
310     function setName(string _name)
311         onlyAdministrator()
312         public
313     {
314         name = _name;
315     }
316     
317     /**
318      * If we want to rebrand, we can.
319      */
320     function setSymbol(string _symbol)
321         onlyAdministrator()
322         public
323     {
324         symbol = _symbol;
325     }
326 
327     
328     /*----------  HELPERS AND CALCULATORS  ----------*/
329     /**
330      * Method to view the current Ethereum stored in the contract
331      * Example: totalEthereumBalance()
332      */
333     function totalEthereumBalance()
334         public
335         view
336         returns(uint)
337     {
338         return this.balance;
339     }
340     
341     /**
342      * Retrieve the total token supply.
343      */
344     function totalSupply()
345         public
346         view
347         returns(uint256)
348     {
349         return tokenSupply_;
350     }
351     
352     /**
353      * Retrieve the tokens owned by the caller.
354      */
355     function myTokens()
356         public
357         view
358         returns(uint256)
359     {
360         address _customerAddress = msg.sender;
361         return balanceOf(_customerAddress);
362     }
363     
364     /**
365      * Retrieve the dividends owned by the caller.
366      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
367      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
368      * But in the internal calculations, we want them separate. 
369      */ 
370     function myDividends(bool _includeReferralBonus) 
371         public 
372         view 
373         returns(uint256)
374     {
375         address _customerAddress = msg.sender;
376         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
377     }
378     
379     /**
380      * Retrieve the token balance of any single address.
381      */
382     function balanceOf(address _customerAddress)
383         view
384         public
385         returns(uint256)
386     {
387         return tokenBalanceLedger_[_customerAddress];
388     }
389     
390     /**
391      * Retrieve the dividend balance of any single address.
392      */
393     function dividendsOf(address _customerAddress)
394         view
395         public
396         returns(uint256)
397     {
398         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
399     }
400     
401     /**
402      * Return the buy price of 1 individual token.
403      */
404     function sellPrice() 
405         public 
406         view 
407         returns(uint256)
408     {
409         // our calculation relies on the token supply, so we need supply. Doh.
410         if(tokenSupply_ == 0){
411             return tokenPriceInitial_ - tokenPriceIncremental_;
412         } else {
413             uint256 _ethereum = tokensToEthereum_(1e18);
414             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
415             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
416             return _taxedEthereum;
417         }
418     }
419     
420     /**
421      * Return the sell price of 1 individual token.
422      */
423     function buyPrice() 
424         public 
425         view 
426         returns(uint256)
427     {
428         // our calculation relies on the token supply, so we need supply. Doh.
429         if(tokenSupply_ == 0){
430             return tokenPriceInitial_ + tokenPriceIncremental_;
431         } else {
432             uint256 _ethereum = tokensToEthereum_(1e18);
433             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
434             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
435             return _taxedEthereum;
436         }
437     }
438     
439     /**
440      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
441      */
442     function calculateTokensReceived(uint256 _ethereumToSpend) 
443         public 
444         view 
445         returns(uint256)
446     {
447         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
448         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
449         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
450         
451         return _amountOfTokens;
452     }
453     
454     /**
455      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
456      */
457     function calculateEthereumReceived(uint256 _tokensToSell) 
458         public 
459         view 
460         returns(uint256)
461     {
462         require(_tokensToSell <= tokenSupply_);
463         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
464         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
465         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
466         return _taxedEthereum;
467     }
468     
469         
470     /*=================================
471     =            HURR-DURR            =
472     =================================*/
473     
474     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
475         // Check for approved spend
476         if (_from != msg.sender) {
477             require(_value <= allowed[_from][msg.sender]);
478             allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
479         }
480 
481         require(_to != address(0));
482         require(_value <= tokenBalanceLedger_[_from]);
483 
484         // Move the tokens across
485         tokenBalanceLedger_[_from] = tokenBalanceLedger_[_from] - _value;
486         tokenBalanceLedger_[_to] = tokenBalanceLedger_[_to] + _value;
487 
488         // Fire 20 event
489         Transfer(_from, _to, _value);
490 
491         // All's well that ends well
492         return true;
493     }
494 
495     function approve(address _spender, uint256 _value) public returns (bool) {
496         allowed[msg.sender][_spender] = _value;
497         Approval(msg.sender, _spender, _value);
498         return true;
499     }
500     
501     /*==========================================
502     =            INTERNAL FUNCTIONS            =
503     ==========================================*/
504     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
505         internal
506         returns(uint256)
507     {
508         // data setup
509         address _customerAddress = msg.sender;
510         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
511         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
512         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
513         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
514         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
515         uint256 _fee = _dividends * magnitude;
516  
517         // no point in continuing execution if OP is a poorfag russian hacker
518         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
519         // (or hackers)
520         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
521         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
522         
523         // is the user referred by a masternode?
524         if(
525             // is this a referred purchase?
526             _referredBy != 0x0000000000000000000000000000000000000000 &&
527 
528             // no cheating!
529             _referredBy != _customerAddress &&
530             
531             // does the referrer have at least X whole tokens?
532             // i.e is the referrer a godly chad masternode
533             tokenBalanceLedger_[_referredBy] >= stakingRequirement
534         ){
535             // wealth redistribution
536             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
537         } else {
538             // no ref purchase
539             // add the referral bonus back to the global dividends cake
540             _dividends = SafeMath.add(_dividends, _referralBonus);
541             _fee = _dividends * magnitude;
542         }
543         
544         // we can't give people infinite ethereum
545         if(tokenSupply_ > 0){
546             
547             // add tokens to the pool
548             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
549  
550             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
551             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
552             
553             // calculate the amount of tokens the customer receives over his purchase 
554             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
555         
556         } else {
557             // add tokens to the pool
558             tokenSupply_ = _amountOfTokens;
559         }
560         
561         // update circulating supply & the ledger address for the customer
562         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
563         
564         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
565         //really i know you think you do but you don't
566         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
567         payoutsTo_[_customerAddress] += _updatedPayouts;
568         
569         // fire event
570         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
571         
572         return _amountOfTokens;
573     }
574 
575     /**
576      * Calculate Token price based on an amount of incoming ethereum
577      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
578      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
579      */
580     function ethereumToTokens_(uint256 _ethereum)
581         internal
582         view
583         returns(uint256)
584     {
585         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
586         uint256 _tokensReceived = 
587          (
588             (
589                 // underflow attempts BTFO
590                 SafeMath.sub(
591                     (sqrt
592                         (
593                             (_tokenPriceInitial**2)
594                             +
595                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
596                             +
597                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
598                             +
599                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
600                         )
601                     ), _tokenPriceInitial
602                 )
603             )/(tokenPriceIncremental_)
604         )-(tokenSupply_)
605         ;
606   
607         return _tokensReceived;
608     }
609     
610     /**
611      * Calculate token sell value.
612      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
613      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
614      */
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
640     //This is where all your gas goes, sorry
641     //Not sorry, you probably only paid 1 gwei
642     function sqrt(uint x) internal pure returns (uint y) {
643         uint z = (x + 1) / 2;
644         y = x;
645         while (z < y) {
646             y = z;
647             z = (x / z + z) / 2;
648         }
649     }
650 }
651 
652 /**
653  * @title SafeMath
654  * @dev Math operations with safety checks that throw on error
655  */
656 library SafeMath {
657 
658     /**
659     * @dev Multiplies two numbers, throws on overflow.
660     */
661     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
662         if (a == 0) {
663             return 0;
664         }
665         uint256 c = a * b;
666         assert(c / a == b);
667         return c;
668     }
669 
670     /**
671     * @dev Integer division of two numbers, truncating the quotient.
672     */
673     function div(uint256 a, uint256 b) internal pure returns (uint256) {
674         // assert(b > 0); // Solidity automatically throws when dividing by 0
675         uint256 c = a / b;
676         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
677         return c;
678     }
679 
680     /**
681     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
682     */
683     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
684         assert(b <= a);
685         return a - b;
686     }
687 
688     /**
689     * @dev Adds two numbers, throws on overflow.
690     */
691     function add(uint256 a, uint256 b) internal pure returns (uint256) {
692         uint256 c = a + b;
693         assert(c >= a);
694         return c;
695     }
696 }