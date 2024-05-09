1 pragma solidity ^0.4.20;
2 
3 contract EVOLUTION2 {
4     /*=================================
5     =            MODIFIERS            =
6     =================================*/
7     // only people with tokens
8     modifier onlyBagholders() {
9         require(myTokens() > 0);
10         _;
11     }
12     
13     // only people with profits
14     modifier onlyStronghands() {
15         require(myDividends(true) > 0);
16         _;
17     }
18     
19     // administrator can:
20     // -> change the name of the contract
21     // -> change the name of the token
22     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
23     // they CANNOT:
24     // -> take funds
25     // -> disable withdrawals
26     // -> kill the contract
27     // -> change the price of tokens
28     modifier onlyAdministrator(){
29         require(msg.sender == investor);
30         _;
31     }
32     
33     /*==============================
34     =            EVENTS            =
35     ==============================*/
36     event onTokenPurchase(
37         address indexed customerAddress,
38         uint256 incomingEthereum,
39         uint256 tokensMinted,
40         address indexed referredBy
41     );
42     
43     event onTokenSell(
44         address indexed customerAddress,
45         uint256 tokensBurned,
46         uint256 ethereumEarned
47     );
48     
49     event onReinvestment(
50         address indexed customerAddress,
51         uint256 ethereumReinvested,
52         uint256 tokensMinted
53     );
54     
55     event onWithdraw(
56         address indexed customerAddress,
57         uint256 ethereumWithdrawn
58     );
59 
60     event OnRedistribution ( //--4
61         uint256 amount,
62         uint256 timestamp
63     );
64     
65     // ERC20
66     event Transfer(
67         address indexed from,
68         address indexed to,
69         uint256 tokens
70     );
71     
72     
73     /*=====================================
74     =            CONFIGURABLES            =
75     =====================================*/
76     string public name = "EVO2"; //Silentflame changed the token
77     string public symbol = "EVO2"; //Silentflame changed the token
78     uint8 constant public decimals = 18;
79     uint8 constant internal dividendFee_ = 10;
80     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
81     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
82     uint256 constant internal magnitude = 2**64;
83     
84     // proof of stake (defaults at 5 tokens)
85     uint256 public stakingRequirement = 5e18;
86     
87     
88     
89    /*================================
90     =            DATASETS            =
91     ================================*/
92     // amount of shares for each address (scaled number)
93     mapping(address => uint256) internal tokenBalanceLedger_;
94     mapping(address => uint256) internal referralBalance_;
95     mapping(address => int256) internal payoutsTo_;
96     uint256 internal tokenSupply_ = 0;
97     uint256 internal profitPerShare_;
98     mapping(address => bool) internal whitelisted_; // fvrr3
99     bool internal whitelist_ = true; // fvrr3 whitelist is automatically activated
100     
101     address public investor;
102     
103 
104 
105     /*=======================================
106     =            PUBLIC FUNCTIONS            =
107     =======================================*/
108     /*
109     * -- APPLICATION ENTRY POINTS --  
110     */
111     constructor()
112         public
113     {
114         investor = 0x8e97F9338460B0d33BD6452A558Ae43284805B5C; //Silentflame Goes to the new wallet as requested
115         whitelisted_[0x8e97F9338460B0d33BD6452A558Ae43284805B5C] = true; //Silentflame changed the admin lock to the new wallet as requested
116     }
117     
118     /**
119      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
120      */
121     function buy(address _referredBy)
122         public
123         payable
124         returns(uint256)
125     {
126         purchaseTokens(msg.value, _referredBy);
127     }
128     
129     /**
130      * Fallback function to handle ethereum that was send straight to the contract
131      * Unfortunately we cannot use a referral address this way.
132      */
133     function()
134         payable
135         public
136     {
137         purchaseTokens(msg.value, 0x0);
138     }
139     
140     /**
141      * Converts all of caller's dividends to tokens.
142      */
143     function reinvest()
144         onlyStronghands()
145         public
146     {
147         // fetch dividends
148         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
149         
150         // pay out the dividends virtually
151         address _customerAddress = msg.sender;
152         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
153         
154         // retrieve ref. bonus
155         _dividends += referralBalance_[_customerAddress];
156         referralBalance_[_customerAddress] = 0;
157         
158         // dispatch a buy order with the virtualized "withdrawn dividends"
159         uint256 _tokens = purchaseTokens(_dividends, 0x0);
160         
161         // fire event
162         emit onReinvestment(_customerAddress, _dividends, _tokens);
163     }
164     
165     /**
166      * Alias of sell() and withdraw().
167      */
168     function exit()
169         public
170     {
171         // get token count for caller & sell them all
172         address _customerAddress = msg.sender;
173         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
174         if(_tokens > 0) sell(_tokens);
175         
176         // lambo delivery service
177         withdraw();
178     }
179 
180     /**
181      * Withdraws all of the callers earnings.
182      */
183     function withdraw()
184         onlyStronghands()
185         public
186     {
187         // setup data
188         address _customerAddress = msg.sender;
189         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
190         
191         // update dividend tracker
192         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
193         
194         // add ref. bonus
195         _dividends += referralBalance_[_customerAddress];
196         referralBalance_[_customerAddress] = 0;
197         
198         // lambo delivery service
199         _customerAddress.transfer(_dividends);
200         
201         // fire event
202         emit onWithdraw(_customerAddress, _dividends);
203     }
204     
205     /**
206      * Liquifies tokens to ethereum.
207      */
208     function sell(uint256 _amountOfTokens)
209         onlyBagholders()
210         public
211     {
212         // setup data
213         address _customerAddress = msg.sender;
214         // russian hackers BTFO
215         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
216         uint256 _tokens = _amountOfTokens;
217         uint256 _ethereum = tokensToEthereum_(_tokens);
218         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
219         uint256 _investmentEth = SafeMath.div(_ethereum, 20); // 5% investment fee
220         uint256 _taxedEthereum = SafeMath.sub(_ethereum, (_dividends+_investmentEth));
221         
222         investor.transfer(_investmentEth); // send 5% to the investor wallet
223 
224         // burn the sold tokens
225         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
226         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
227         
228         // update dividends tracker
229         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
230         payoutsTo_[_customerAddress] -= _updatedPayouts;       
231         
232         // dividing by zero is a bad idea
233         if (tokenSupply_ > 0) {
234             // update the amount of dividends per token
235             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
236         }
237         
238         // fire event
239         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
240     }
241     
242      /**
243      * Transfer tokens from the caller to a new holder.
244      * 0% fee.
245      */
246     function transfer(address _toAddress, uint256 _amountOfTokens)
247         onlyBagholders()
248         public
249         returns(bool)
250     {
251         // setup
252         address _customerAddress = msg.sender;
253         
254         // make sure we have the requested tokens
255         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
256         
257         // withdraw all outstanding dividends first
258         if(myDividends(true) > 0) withdraw();
259 
260         // exchange tokens
261         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
262         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
263         
264         // update dividend trackers
265         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
266         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
267         
268         // fire event
269         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
270         
271         // ERC20
272         return true;
273        
274     }
275 
276     /**
277     * redistribution of dividends
278      */
279     function redistribution()
280         external
281         payable
282     {
283         // setup
284         uint256 ethereum = msg.value;
285         
286         // disperse ethereum among holders
287         profitPerShare_ = SafeMath.add(profitPerShare_, (ethereum * magnitude) / tokenSupply_);
288         
289         // fire event
290         emit OnRedistribution(ethereum, block.timestamp);
291         //--4
292     }
293     
294     /**
295      * In case one of us dies, we need to replace ourselves.
296      */
297     function setAdministrator(address _newInvestor)
298         onlyAdministrator()
299         external
300     {
301         investor = _newInvestor;
302     }
303     
304     /**
305      * Precautionary measures in case we need to adjust the masternode rate.
306      */
307     function setStakingRequirement(uint256 _amountOfTokens)
308         onlyAdministrator()
309         public
310     {
311         stakingRequirement = _amountOfTokens;
312     }
313     
314     /**
315      * If we want to rebrand, we can.
316      */
317     function setName(string _name)
318         onlyAdministrator()
319         public
320     {
321         name = _name;
322     }
323     
324     /**
325      * If we want to rebrand, we can.
326      */
327     function setSymbol(string _symbol)
328         onlyAdministrator()
329         public
330     {
331         symbol = _symbol;
332     }
333 
334     
335     /*----------  HELPERS AND CALCULATORS  ----------*/
336     /**
337      * Method to view the current Ethereum stored in the contract
338      * Example: totalEthereumBalance()
339      */
340     function totalEthereumBalance()
341         public
342         view
343         returns(uint)
344     {
345         return address(this).balance;
346     }
347     
348     /**
349      * Retrieve the total token supply.
350      */
351     function totalSupply()
352         public
353         view
354         returns(uint256)
355     {
356         return tokenSupply_;
357     }
358     
359     /**
360      * Retrieve the tokens owned by the caller.
361      */
362     function myTokens()
363         public
364         view
365         returns(uint256)
366     {
367         address _customerAddress = msg.sender;
368         return balanceOf(_customerAddress);
369     }
370     
371     /**
372      * Retrieve the dividends owned by the caller.
373      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
374      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
375      * But in the internal calculations, we want them separate. 
376      */ 
377     function myDividends(bool _includeReferralBonus) 
378         public 
379         view 
380         returns(uint256)
381     {
382         address _customerAddress = msg.sender;
383         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
384     }
385     
386     /**
387      * Retrieve the token balance of any single address.
388      */
389     function balanceOf(address _customerAddress)
390         view
391         public
392         returns(uint256)
393     {
394         return tokenBalanceLedger_[_customerAddress];
395     }
396     
397     /**
398      * Retrieve the dividend balance of any single address.
399      */
400     function dividendsOf(address _customerAddress)
401         view
402         public
403         returns(uint256)
404     {
405         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
406     }
407     
408     /**
409      * Return the buy price of 1 individual token.
410      */
411     function sellPrice() 
412         public 
413         view 
414         returns(uint256)
415     {
416         // our calculation relies on the token supply, so we need supply. Doh.
417         if(tokenSupply_ == 0){
418             return tokenPriceInitial_ - tokenPriceIncremental_;
419         } else {
420             uint256 _ethereum = tokensToEthereum_(1e18);
421             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
422             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
423             return _taxedEthereum;
424         }
425     }
426     
427     /**
428      * Return the sell price of 1 individual token.
429      */
430     function buyPrice() 
431         public 
432         view 
433         returns(uint256)
434     {
435         // our calculation relies on the token supply, so we need supply. Doh.
436         if(tokenSupply_ == 0){
437             return tokenPriceInitial_ + tokenPriceIncremental_;
438         } else {
439             uint256 _ethereum = tokensToEthereum_(1e18);
440             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
441             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
442             return _taxedEthereum;
443         }
444     }
445     
446     /**
447      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
448      */
449     function calculateTokensReceived(uint256 _ethereumToSpend) 
450         public 
451         view 
452         returns(uint256)
453     {
454         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
455         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
456         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
457         
458         return _amountOfTokens;
459     }
460     
461     /**
462      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
463      */
464     function calculateEthereumReceived(uint256 _tokensToSell) 
465         public 
466         view 
467         returns(uint256)
468     {
469         require(_tokensToSell <= tokenSupply_);
470         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
471         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
472         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
473         return _taxedEthereum;
474     }
475     
476     function disableWhitelist() external {
477         require(whitelisted_[msg.sender] == true);
478         whitelist_ = false;
479     }
480 
481     function activateWhitelist() external {
482         require(whitelisted_[msg.sender] == true);
483         whitelist_ = true;
484     }
485     /*==========================================
486     =            INTERNAL FUNCTIONS            =
487     ==========================================*/
488     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
489         internal
490         returns(uint256)
491     {   
492         
493         //As long as the whitelist is true, only whitelisted people are allowed to buy.
494 
495         // if the person is not whitelisted but whitelist is true/active, revert the transaction
496         if (whitelisted_[msg.sender] == false && whitelist_ == true) { 
497             revert();
498         }
499         // data setup
500         address _customerAddress = msg.sender;
501         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
502         uint256 _investmentEth = SafeMath.div(_incomingEthereum, 20); // 5% investment fee
503         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
504         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
505         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, (_undividedDividends+_investmentEth));
506         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
507         uint256 _fee = _dividends * magnitude;
508 
509         investor.transfer(_investmentEth); // send 5% to the investor wallet
510 
511         // no point in continuing execution if OP is a poorfag russian hacker
512         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
513         // (or hackers)
514         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
515         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
516         
517         // is the user referred by a masternode?
518         if(
519             // is this a referred purchase?
520             _referredBy != 0x0000000000000000000000000000000000000000 &&
521 
522             // no cheating!
523             _referredBy != _customerAddress &&
524             
525             // does the referrer have at least X whole tokens?
526             // i.e is the referrer a godly chad masternode
527             tokenBalanceLedger_[_referredBy] >= stakingRequirement
528         ){
529             // wealth redistribution
530             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
531         } else {
532             // no ref purchase
533             // add the referral bonus back to the global dividends cake
534             _dividends = SafeMath.add(_dividends, _referralBonus);
535             _fee = _dividends * magnitude;
536         }
537         
538         // we can't give people infinite ethereum
539         if(tokenSupply_ > 0){
540             
541             // add tokens to the pool
542             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
543  
544             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
545             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
546             
547             // calculate the amount of tokens the customer receives over his purchase 
548             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
549         
550         } else {
551             // add tokens to the pool
552             tokenSupply_ = _amountOfTokens;
553         }
554         
555         // update circulating supply & the ledger address for the customer
556         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
557         
558         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
559         //really i know you think you do but you don't
560         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
561         payoutsTo_[_customerAddress] += _updatedPayouts;
562         
563         // fire event
564         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
565         
566         return _amountOfTokens;
567     }
568 
569     /**
570      * Calculate Token price based on an amount of incoming ethereum
571      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
572      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
573      */
574     function ethereumToTokens_(uint256 _ethereum)
575         internal
576         view
577         returns(uint256)
578     {
579         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
580         uint256 _tokensReceived = 
581          (
582             (
583                 // underflow attempts BTFO
584                 SafeMath.sub(
585                     (sqrt
586                         (
587                             (_tokenPriceInitial**2)
588                             +
589                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
590                             +
591                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
592                             +
593                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
594                         )
595                     ), _tokenPriceInitial
596                 )
597             )/(tokenPriceIncremental_)
598         )-(tokenSupply_)
599         ;
600   
601         return _tokensReceived;
602     }
603     
604     /**
605      * Calculate token sell value.
606      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
607      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
608      */
609      function tokensToEthereum_(uint256 _tokens)
610         internal
611         view
612         returns(uint256)
613     {
614 
615         uint256 tokens_ = (_tokens + 1e18);
616         uint256 _tokenSupply = (tokenSupply_ + 1e18);
617         uint256 _etherReceived =
618         (
619             // underflow attempts BTFO
620             SafeMath.sub(
621                 (
622                     (
623                         (
624                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
625                         )-tokenPriceIncremental_
626                     )*(tokens_ - 1e18)
627                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
628             )
629         /1e18);
630         return _etherReceived;
631     }
632     
633     
634     //This is where all your gas goes, sorry
635     //Not sorry, you probably only paid 1 gwei
636     function sqrt(uint x) internal pure returns (uint y) {
637         uint z = (x + 1) / 2;
638         y = x;
639         while (z < y) {
640             y = z;
641             z = (x / z + z) / 2;
642         }
643     }
644 }
645 
646 /**
647  * @title SafeMath
648  * @dev Math operations with safety checks that throw on error
649  */
650 library SafeMath {
651 
652     /**
653     * @dev Multiplies two numbers, throws on overflow.
654     */
655     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
656         if (a == 0) {
657             return 0;
658         }
659         uint256 c = a * b;
660         assert(c / a == b);
661         return c;
662     }
663 
664     /**
665     * @dev Integer division of two numbers, truncating the quotient.
666     */
667     function div(uint256 a, uint256 b) internal pure returns (uint256) {
668         // assert(b > 0); // Solidity automatically throws when dividing by 0
669         uint256 c = a / b;
670         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
671         return c;
672     }
673 
674     /**
675     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
676     */
677     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
678         assert(b <= a);
679         return a - b;
680     }
681 
682     /**
683     * @dev Adds two numbers, throws on overflow.
684     */
685     function add(uint256 a, uint256 b) internal pure returns (uint256) {
686         uint256 c = a + b;
687         assert(c >= a);
688         return c;
689     }
690 }