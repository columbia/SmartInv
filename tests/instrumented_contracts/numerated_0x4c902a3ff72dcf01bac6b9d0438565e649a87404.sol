1 pragma solidity ^0.4.20;
2 
3 contract EVOLUTION {
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
33     
34     /*==============================
35     =            EVENTS            =
36     ==============================*/
37     event onTokenPurchase(
38         address indexed customerAddress,
39         uint256 incomingEthereum,
40         uint256 tokensMinted,
41         address indexed referredBy
42     );
43     
44     event onTokenSell(
45         address indexed customerAddress,
46         uint256 tokensBurned,
47         uint256 ethereumEarned
48     );
49     
50     event onReinvestment(
51         address indexed customerAddress,
52         uint256 ethereumReinvested,
53         uint256 tokensMinted
54     );
55     
56     event onWithdraw(
57         address indexed customerAddress,
58         uint256 ethereumWithdrawn
59     );
60 
61     event OnRedistribution ( //--4
62         uint256 amount,
63         uint256 timestamp
64     );
65     
66     // ERC20
67     event Transfer(
68         address indexed from,
69         address indexed to,
70         uint256 tokens
71     );
72     
73     
74     /*=====================================
75     =            CONFIGURABLES            =
76     =====================================*/
77     string public name = "EVO";
78     string public symbol = "EVO";
79     uint8 constant public decimals = 18;
80     uint8 constant internal dividendFee_ = 10;
81     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
82     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
83     uint256 constant internal magnitude = 2**64;
84     
85     // proof of stake (defaults at 5 tokens)
86     uint256 public stakingRequirement = 5e18;
87     
88     
89     
90    /*================================
91     =            DATASETS            =
92     ================================*/
93     // amount of shares for each address (scaled number)
94     mapping(address => uint256) internal tokenBalanceLedger_;
95     mapping(address => uint256) internal referralBalance_;
96     mapping(address => int256) internal payoutsTo_;
97     uint256 internal tokenSupply_ = 0;
98     uint256 internal profitPerShare_;
99     mapping(address => bool) internal whitelisted_; // fvrr3
100     bool internal whitelist_ = true; // fvrr3 whitelist is automatically activated
101     
102     address public investor;
103     
104 
105 
106     /*=======================================
107     =            PUBLIC FUNCTIONS            =
108     =======================================*/
109     /*
110     * -- APPLICATION ENTRY POINTS --  
111     */
112     constructor()
113         public
114     {
115         investor = 0x85ADF4cF1e98487c849805D0B28a570F15943E56;
116         whitelisted_[0x85ADF4cF1e98487c849805D0B28a570F15943E56] = true;
117     }
118     
119      
120     /**
121      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
122      */
123     function buy(address _referredBy)
124         public
125         payable
126         returns(uint256)
127     {
128         purchaseTokens(msg.value, _referredBy);
129     }
130     
131     /**
132      * Fallback function to handle ethereum that was send straight to the contract
133      * Unfortunately we cannot use a referral address this way.
134      */
135     function()
136         payable
137         public
138     {
139         purchaseTokens(msg.value, 0x0);
140     }
141     
142     /**
143      * Converts all of caller's dividends to tokens.
144      */
145     function reinvest()
146         onlyStronghands()
147         public
148     {
149         // fetch dividends
150         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
151         
152         // pay out the dividends virtually
153         address _customerAddress = msg.sender;
154         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
155         
156         // retrieve ref. bonus
157         _dividends += referralBalance_[_customerAddress];
158         referralBalance_[_customerAddress] = 0;
159         
160         // dispatch a buy order with the virtualized "withdrawn dividends"
161         uint256 _tokens = purchaseTokens(_dividends, 0x0);
162         
163         // fire event
164         emit onReinvestment(_customerAddress, _dividends, _tokens);
165     }
166     
167     /**
168      * Alias of sell() and withdraw().
169      */
170     function exit()
171         public
172     {
173         // get token count for caller & sell them all
174         address _customerAddress = msg.sender;
175         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
176         if(_tokens > 0) sell(_tokens);
177         
178         // lambo delivery service
179         withdraw();
180     }
181 
182     /**
183      * Withdraws all of the callers earnings.
184      */
185     function withdraw()
186         onlyStronghands()
187         public
188     {
189         // setup data
190         address _customerAddress = msg.sender;
191         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
192         
193         // update dividend tracker
194         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
195         
196         // add ref. bonus
197         _dividends += referralBalance_[_customerAddress];
198         referralBalance_[_customerAddress] = 0;
199         
200         // lambo delivery service
201         _customerAddress.transfer(_dividends);
202         
203         // fire event
204         emit onWithdraw(_customerAddress, _dividends);
205     }
206     
207     /**
208      * Liquifies tokens to ethereum.
209      */
210     function sell(uint256 _amountOfTokens)
211         onlyBagholders()
212         public
213     {
214         // setup data
215         address _customerAddress = msg.sender;
216         // russian hackers BTFO
217         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
218         uint256 _tokens = _amountOfTokens;
219         uint256 _ethereum = tokensToEthereum_(_tokens);
220         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
221         uint256 _investmentEth = SafeMath.div(_ethereum, 20); // 5% investment fee
222         uint256 _taxedEthereum = SafeMath.sub(_ethereum, (_dividends+_investmentEth));
223         
224         investor.transfer(_investmentEth); // send 5% to the investor wallet
225 
226         // burn the sold tokens
227         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
228         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
229         
230         // update dividends tracker
231         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
232         payoutsTo_[_customerAddress] -= _updatedPayouts;       
233         
234         // dividing by zero is a bad idea
235         if (tokenSupply_ > 0) {
236             // update the amount of dividends per token
237             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
238         }
239         
240         // fire event
241         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
242     }
243     
244      /**
245      * Transfer tokens from the caller to a new holder.
246      * 0% fee.
247      */
248     function transfer(address _toAddress, uint256 _amountOfTokens)
249         onlyBagholders()
250         public
251         returns(bool)
252     {
253         // setup
254         address _customerAddress = msg.sender;
255         
256         // make sure we have the requested tokens
257         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
258         
259         // withdraw all outstanding dividends first
260         if(myDividends(true) > 0) withdraw();
261 
262         // exchange tokens
263         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
264         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
265         
266         // update dividend trackers
267         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
268         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
269         
270         // fire event
271         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
272         
273         // ERC20
274         return true;
275        
276     }
277 
278     /**
279     * redistribution of dividends
280      */
281     function redistribution()
282         external
283         payable
284     {
285         // setup
286         uint256 ethereum = msg.value;
287         
288         // disperse ethereum among holders
289         profitPerShare_ = SafeMath.add(profitPerShare_, (ethereum * magnitude) / tokenSupply_);
290         
291         // fire event
292         emit OnRedistribution(ethereum, block.timestamp);
293         //--4
294     }
295     
296     /**
297      * In case one of us dies, we need to replace ourselves.
298      */
299     function setAdministrator(address _newInvestor)
300         onlyAdministrator()
301         external
302     {
303         investor = _newInvestor;
304     }
305     
306     /**
307      * Precautionary measures in case we need to adjust the masternode rate.
308      */
309     function setStakingRequirement(uint256 _amountOfTokens)
310         onlyAdministrator()
311         public
312     {
313         stakingRequirement = _amountOfTokens;
314     }
315     
316     /**
317      * If we want to rebrand, we can.
318      */
319     function setName(string _name)
320         onlyAdministrator()
321         public
322     {
323         name = _name;
324     }
325     
326     /**
327      * If we want to rebrand, we can.
328      */
329     function setSymbol(string _symbol)
330         onlyAdministrator()
331         public
332     {
333         symbol = _symbol;
334     }
335 
336     
337     /*----------  HELPERS AND CALCULATORS  ----------*/
338     /**
339      * Method to view the current Ethereum stored in the contract
340      * Example: totalEthereumBalance()
341      */
342     function totalEthereumBalance()
343         public
344         view
345         returns(uint)
346     {
347         return address(this).balance;
348     }
349     
350     /**
351      * Retrieve the total token supply.
352      */
353     function totalSupply()
354         public
355         view
356         returns(uint256)
357     {
358         return tokenSupply_;
359     }
360     
361     /**
362      * Retrieve the tokens owned by the caller.
363      */
364     function myTokens()
365         public
366         view
367         returns(uint256)
368     {
369         address _customerAddress = msg.sender;
370         return balanceOf(_customerAddress);
371     }
372     
373     /**
374      * Retrieve the dividends owned by the caller.
375      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
376      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
377      * But in the internal calculations, we want them separate. 
378      */ 
379     function myDividends(bool _includeReferralBonus) 
380         public 
381         view 
382         returns(uint256)
383     {
384         address _customerAddress = msg.sender;
385         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
386     }
387     
388     /**
389      * Retrieve the token balance of any single address.
390      */
391     function balanceOf(address _customerAddress)
392         view
393         public
394         returns(uint256)
395     {
396         return tokenBalanceLedger_[_customerAddress];
397     }
398     
399     /**
400      * Retrieve the dividend balance of any single address.
401      */
402     function dividendsOf(address _customerAddress)
403         view
404         public
405         returns(uint256)
406     {
407         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
408     }
409     
410     /**
411      * Return the buy price of 1 individual token.
412      */
413     function sellPrice() 
414         public 
415         view 
416         returns(uint256)
417     {
418         // our calculation relies on the token supply, so we need supply. Doh.
419         if(tokenSupply_ == 0){
420             return tokenPriceInitial_ - tokenPriceIncremental_;
421         } else {
422             uint256 _ethereum = tokensToEthereum_(1e18);
423             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
424             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
425             return _taxedEthereum;
426         }
427     }
428     
429     /**
430      * Return the sell price of 1 individual token.
431      */
432     function buyPrice() 
433         public 
434         view 
435         returns(uint256)
436     {
437         // our calculation relies on the token supply, so we need supply. Doh.
438         if(tokenSupply_ == 0){
439             return tokenPriceInitial_ + tokenPriceIncremental_;
440         } else {
441             uint256 _ethereum = tokensToEthereum_(1e18);
442             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
443             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
444             return _taxedEthereum;
445         }
446     }
447     
448     /**
449      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
450      */
451     function calculateTokensReceived(uint256 _ethereumToSpend) 
452         public 
453         view 
454         returns(uint256)
455     {
456         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
457         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
458         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
459         
460         return _amountOfTokens;
461     }
462     
463     /**
464      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
465      */
466     function calculateEthereumReceived(uint256 _tokensToSell) 
467         public 
468         view 
469         returns(uint256)
470     {
471         require(_tokensToSell <= tokenSupply_);
472         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
473         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
474         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
475         return _taxedEthereum;
476     }
477     
478     function disableWhitelist() external {
479         require(whitelisted_[msg.sender] == true);
480         whitelist_ = false;
481     }
482 
483     function activateWhitelist() external {
484         require(whitelisted_[msg.sender] == true);
485         whitelist_ = true;
486     }
487     /*==========================================
488     =            INTERNAL FUNCTIONS            =
489     ==========================================*/
490     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
491         internal
492         returns(uint256)
493     {   
494         
495         //As long as the whitelist is true, only whitelisted people are allowed to buy.
496 
497         // if the person is not whitelisted but whitelist is true/active, revert the transaction
498         if (whitelisted_[msg.sender] == false && whitelist_ == true) { 
499             revert();
500         }
501         // data setup
502         address _customerAddress = msg.sender;
503         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
504         uint256 _investmentEth = SafeMath.div(_incomingEthereum, 20); // 5% investment fee
505         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
506         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
507         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, (_undividedDividends+_investmentEth));
508         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
509         uint256 _fee = _dividends * magnitude;
510 
511         investor.transfer(_investmentEth); // send 5% to the investor wallet
512 
513         // no point in continuing execution if OP is a poorfag russian hacker
514         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
515         // (or hackers)
516         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
517         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
518         
519         // is the user referred by a masternode?
520         if(
521             // is this a referred purchase?
522             _referredBy != 0x0000000000000000000000000000000000000000 &&
523 
524             // no cheating!
525             _referredBy != _customerAddress &&
526             
527             // does the referrer have at least X whole tokens?
528             // i.e is the referrer a godly chad masternode
529             tokenBalanceLedger_[_referredBy] >= stakingRequirement
530         ){
531             // wealth redistribution
532             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
533         } else {
534             // no ref purchase
535             // add the referral bonus back to the global dividends cake
536             _dividends = SafeMath.add(_dividends, _referralBonus);
537             _fee = _dividends * magnitude;
538         }
539         
540         // we can't give people infinite ethereum
541         if(tokenSupply_ > 0){
542             
543             // add tokens to the pool
544             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
545  
546             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
547             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
548             
549             // calculate the amount of tokens the customer receives over his purchase 
550             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
551         
552         } else {
553             // add tokens to the pool
554             tokenSupply_ = _amountOfTokens;
555         }
556         
557         // update circulating supply & the ledger address for the customer
558         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
559         
560         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
561         //really i know you think you do but you don't
562         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
563         payoutsTo_[_customerAddress] += _updatedPayouts;
564         
565         // fire event
566         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
567         
568         return _amountOfTokens;
569     }
570 
571     /**
572      * Calculate Token price based on an amount of incoming ethereum
573      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
574      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
575      */
576     function ethereumToTokens_(uint256 _ethereum)
577         internal
578         view
579         returns(uint256)
580     {
581         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
582         uint256 _tokensReceived = 
583          (
584             (
585                 // underflow attempts BTFO
586                 SafeMath.sub(
587                     (sqrt
588                         (
589                             (_tokenPriceInitial**2)
590                             +
591                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
592                             +
593                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
594                             +
595                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
596                         )
597                     ), _tokenPriceInitial
598                 )
599             )/(tokenPriceIncremental_)
600         )-(tokenSupply_)
601         ;
602   
603         return _tokensReceived;
604     }
605     
606     /**
607      * Calculate token sell value.
608      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
609      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
610      */
611      function tokensToEthereum_(uint256 _tokens)
612         internal
613         view
614         returns(uint256)
615     {
616 
617         uint256 tokens_ = (_tokens + 1e18);
618         uint256 _tokenSupply = (tokenSupply_ + 1e18);
619         uint256 _etherReceived =
620         (
621             // underflow attempts BTFO
622             SafeMath.sub(
623                 (
624                     (
625                         (
626                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
627                         )-tokenPriceIncremental_
628                     )*(tokens_ - 1e18)
629                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
630             )
631         /1e18);
632         return _etherReceived;
633     }
634     
635     
636     //This is where all your gas goes, sorry
637     //Not sorry, you probably only paid 1 gwei
638     function sqrt(uint x) internal pure returns (uint y) {
639         uint z = (x + 1) / 2;
640         y = x;
641         while (z < y) {
642             y = z;
643             z = (x / z + z) / 2;
644         }
645     }
646 }
647 
648 /**
649  * @title SafeMath
650  * @dev Math operations with safety checks that throw on error
651  */
652 library SafeMath {
653 
654     /**
655     * @dev Multiplies two numbers, throws on overflow.
656     */
657     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
658         if (a == 0) {
659             return 0;
660         }
661         uint256 c = a * b;
662         assert(c / a == b);
663         return c;
664     }
665 
666     /**
667     * @dev Integer division of two numbers, truncating the quotient.
668     */
669     function div(uint256 a, uint256 b) internal pure returns (uint256) {
670         // assert(b > 0); // Solidity automatically throws when dividing by 0
671         uint256 c = a / b;
672         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
673         return c;
674     }
675 
676     /**
677     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
678     */
679     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
680         assert(b <= a);
681         return a - b;
682     }
683 
684     /**
685     * @dev Adds two numbers, throws on overflow.
686     */
687     function add(uint256 a, uint256 b) internal pure returns (uint256) {
688         uint256 c = a + b;
689         assert(c >= a);
690         return c;
691     }
692 }