1 pragma solidity ^0.4.21;
2 
3 /*
4 * JIGSAW IS BACK
5 *
6 * YOU TOUGHT THE GAME WAS OVER? THINK AGAIN 
7 * ARE YOU READY TO PARTICIPATE? OR ARE YOU AFRAID? MAKE JIGSAW LAUGH!
8 * https://discord.gg/ZxEja6a
9 * Jiggs.io is the only official website!
10 * Only 1 token to activate your masterkey
11 * 20% IN / 20% OUT / 33% MASTERNODE - DONT LIKE IT? STAY AWAY! DIVIDENDS LOVERS ONLY!
12 * NO FUNNY ADMINISTRATOR/AMBASSADOR FUNCTIONS, FREEDOM TO EVERYONE!
13 * NO DEV FEES, WHO NEED DEV FEES IF THE SITE KEEPS RUNNING FOR $10 A MONTH? WHAT A BULLSHIT
14 * WE STAY REAL, 5% CHARITY FEE TO SEND JIGSAW ON VACATION, STRAIGHT TO THE POINT
15 */
16 
17 
18 contract JiggsRezurrection {
19     /*=================================
20     =            MODIFIERS            =
21     =================================*/
22     // only people with tokens
23     modifier onlyBagholders() {
24         require(myTokens() > 0);
25         _;
26     }
27 
28     // only people with profits
29     modifier onlyStronghands() {
30         require(myDividends(true) > 0);
31         _;
32     }
33 
34     modifier notContract() {
35       require (msg.sender == tx.origin);
36       _;
37     }
38 
39     /*==============================
40     =            EVENTS            =
41     ==============================*/
42     event onTokenPurchase(
43         address indexed customerAddress,
44         uint256 incomingEthereum,
45         uint256 tokensMinted,
46         address indexed referredBy
47     );
48 
49     event onTokenSell(
50         address indexed customerAddress,
51         uint256 tokensBurned,
52         uint256 ethereumEarned
53     );
54 
55     event onReinvestment(
56         address indexed customerAddress,
57         uint256 ethereumReinvested,
58         uint256 tokensMinted
59     );
60 
61     event onWithdraw(
62         address indexed customerAddress,
63         uint256 ethereumWithdrawn
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
77     string public name = "Jiggs Rezurrection";
78     string public symbol = "Jiggs";
79     uint8 constant public decimals = 18;
80     uint8 constant internal dividendFee_ = 20; // FOR DIV LOVERS ONLY, THE AIR IS FOR FREE
81     uint8 constant internal charityFee_ = 5; // 5% CHARITY TO SEND JIGSAW ON VACATION
82     uint256 constant internal tokenPriceInitial_ = 0.000000000001 ether;
83     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
84     uint256 constant internal magnitude = 2**64;
85 
86     address constant public giveEthCharityAddress = 0xE40FFEA88309174321ef230e10bfcCC7c2687f76;
87     uint256 public totalEthCharityRecieved; // WHAT IS SEND TO JIGSAW..?
88     uint256 public totalEthCharityCollected; // HOW MANY FLIGHT TICKETS CAN WE PURCHASE FOR JIGSAW?
89 
90     // NO BULLSHIT, ONLY 1 TOKEN NEEDED, WE TAKE ALREADY 20% OF YOUR ETH
91     uint256 public stakingRequirement = 1e18;
92 
93 
94    /*================================
95     =            DATASETS            =
96     ================================*/
97     // amount of shares for each address (scaled number)
98     mapping(address => uint256) internal tokenBalanceLedger_;
99     mapping(address => uint256) internal referralBalance_;
100     mapping(address => int256) internal payoutsTo_;
101     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
102     uint256 internal tokenSupply_ = 0;
103     uint256 internal profitPerShare_;
104 
105 
106 
107     /*=======================================
108     =            PUBLIC FUNCTIONS            =
109     =======================================*/
110     /*
111     * -- APPLICATION ENTRY POINTS --
112     */
113     function JiggsR()
114         public
115     {
116    
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
128         purchaseInternal(msg.value, _referredBy);
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
139         purchaseInternal(msg.value, 0x0);
140     }
141 
142     function payCharity() payable public {
143       uint256 ethToPay = SafeMath.sub(totalEthCharityCollected, totalEthCharityRecieved);
144       require(ethToPay > 1);
145       totalEthCharityRecieved = SafeMath.add(totalEthCharityRecieved, ethToPay);
146       if(!giveEthCharityAddress.call.value(ethToPay).gas(400000)()) {
147          totalEthCharityRecieved = SafeMath.sub(totalEthCharityRecieved, ethToPay);
148       }
149     }
150 
151     /**
152      * Converts all of caller's dividends to tokens.
153      */
154     function reinvest()
155         onlyStronghands()
156         public
157     {
158         // fetch dividends
159         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
160 
161         // pay out the dividends virtually
162         address _customerAddress = msg.sender;
163         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
164 
165         // retrieve ref. bonus
166         _dividends += referralBalance_[_customerAddress];
167         referralBalance_[_customerAddress] = 0;
168 
169         // dispatch a buy order with the virtualized "withdrawn dividends"
170         uint256 _tokens = purchaseTokens(_dividends, 0x0);
171 
172         // fire event
173         onReinvestment(_customerAddress, _dividends, _tokens);
174     }
175 
176     /**
177      * Alias of sell() and withdraw().
178      */
179     function exit()
180         public
181     {
182         // get token count for caller & sell them all
183         address _customerAddress = msg.sender;
184         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
185         if(_tokens > 0) sell(_tokens);
186 
187         // lambo delivery service
188         withdraw();
189     }
190 
191     /**
192      * Withdraws all of the callers earnings.
193      */
194     function withdraw()
195         onlyStronghands()
196         public
197     {
198         // setup data
199         address _customerAddress = msg.sender;
200         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
201 
202         // update dividend tracker
203         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
204 
205         // add ref. bonus
206         _dividends += referralBalance_[_customerAddress];
207         referralBalance_[_customerAddress] = 0;
208 
209         // lambo delivery service
210         _customerAddress.transfer(_dividends);
211 
212         // fire event
213         onWithdraw(_customerAddress, _dividends);
214     }
215 
216     /**
217      * Liquifies tokens to ethereum.
218      */
219     function sell(uint256 _amountOfTokens)
220         onlyBagholders()
221         public
222     {
223         // setup data
224         address _customerAddress = msg.sender;
225         // russian hackers BTFO
226         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
227         uint256 _tokens = _amountOfTokens;
228         uint256 _ethereum = tokensToEthereum_(_tokens);
229 
230         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
231         uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereum, charityFee_), 100);
232 
233         // Take out dividends and then _charityPayout
234         uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _charityPayout);
235 
236         // Add ethereum to send to charity
237         totalEthCharityCollected = SafeMath.add(totalEthCharityCollected, _charityPayout);
238 
239         // burn the sold tokens
240         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
241         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
242 
243         // update dividends tracker
244         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
245         payoutsTo_[_customerAddress] -= _updatedPayouts;
246 
247         // dividing by zero is a bad idea
248         if (tokenSupply_ > 0) {
249             // update the amount of dividends per token
250             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
251         }
252 
253         // fire event
254         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
255     }
256 
257 
258     /**
259      * Transfer tokens from the caller to a new holder.
260      * REMEMBER THIS IS 0% TRANSFER FEE
261      */
262     function transfer(address _toAddress, uint256 _amountOfTokens)
263         onlyBagholders()
264         public
265         returns(bool)
266     {
267         // setup
268         address _customerAddress = msg.sender;
269 
270         // make sure we have the requested tokens
271         // also disables transfers until ambassador phase is over
272         // ( we dont want whale premines )
273         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
274 
275         // withdraw all outstanding dividends first
276         if(myDividends(true) > 0) withdraw();
277 
278         // exchange tokens
279         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
280         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
281 
282         // update dividend trackers
283         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
284         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
285 
286 
287         // fire event
288         Transfer(_customerAddress, _toAddress, _amountOfTokens);
289 
290         // ERC20
291         return true;
292     }
293 
294  
295     /*----------  HELPERS AND CALCULATORS  ----------*/
296     /**
297      * Method to view the current Ethereum stored in the contract
298      * Example: totalEthereumBalance()
299      */
300     function totalEthereumBalance()
301         public
302         view
303         returns(uint)
304     {
305         return this.balance;
306     }
307 
308     /**
309      * Retrieve the total token supply.
310      */
311     function totalSupply()
312         public
313         view
314         returns(uint256)
315     {
316         return tokenSupply_;
317     }
318 
319     /**
320      * Retrieve the tokens owned by the caller.
321      */
322     function myTokens()
323         public
324         view
325         returns(uint256)
326     {
327         address _customerAddress = msg.sender;
328         return balanceOf(_customerAddress);
329     }
330 
331     /**
332      * Retrieve the dividends owned by the caller.
333      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
334      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
335      * But in the internal calculations, we want them separate.
336      */
337     function myDividends(bool _includeReferralBonus)
338         public
339         view
340         returns(uint256)
341     {
342         address _customerAddress = msg.sender;
343         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
344     }
345 
346     /**
347      * Retrieve the token balance of any single address.
348      */
349     function balanceOf(address _customerAddress)
350         view
351         public
352         returns(uint256)
353     {
354         return tokenBalanceLedger_[_customerAddress];
355     }
356 
357     /**
358      * Retrieve the dividend balance of any single address.
359      */
360     function dividendsOf(address _customerAddress)
361         view
362         public
363         returns(uint256)
364     {
365         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
366     }
367 
368     /**
369      * Return the buy price of 1 individual token.
370      */
371     function sellPrice()
372         public
373         view
374         returns(uint256)
375     {
376         // our calculation relies on the token supply, so we need supply. Doh.
377         if(tokenSupply_ == 0){
378             return tokenPriceInitial_ - tokenPriceIncremental_;
379         } else {
380             uint256 _ethereum = tokensToEthereum_(1e18);
381             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
382             uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereum, charityFee_), 100);
383             uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _charityPayout);
384             return _taxedEthereum;
385         }
386     }
387 
388     /**
389      * Return the sell price of 1 individual token.
390      */
391     function buyPrice()
392         public
393         view
394         returns(uint256)
395     {
396         // our calculation relies on the token supply, so we need supply. Doh.
397         if(tokenSupply_ == 0){
398             return tokenPriceInitial_ + tokenPriceIncremental_;
399         } else {
400             uint256 _ethereum = tokensToEthereum_(1e18);
401             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
402             uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereum, charityFee_), 100);
403             uint256 _taxedEthereum =  SafeMath.add(SafeMath.add(_ethereum, _dividends), _charityPayout);
404             return _taxedEthereum;
405         }
406     }
407 
408     /**
409      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
410      */
411     function calculateTokensReceived(uint256 _ethereumToSpend)
412         public
413         view
414         returns(uint256)
415     {
416         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, dividendFee_), 100);
417         uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereumToSpend, charityFee_), 100);
418         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereumToSpend, _dividends), _charityPayout);
419         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
420         return _amountOfTokens;
421     }
422 
423     /**
424      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
425      */
426     function calculateEthereumReceived(uint256 _tokensToSell)
427         public
428         view
429         returns(uint256)
430     {
431         require(_tokensToSell <= tokenSupply_);
432         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
433         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
434         uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereum, charityFee_), 100);
435         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _charityPayout);
436         return _taxedEthereum;
437     }
438 
439     /**
440      * Function for the frontend to show ether waiting to be send to charity in contract
441      */
442     function etherToSendCharity()
443         public
444         view
445         returns(uint256) {
446         return SafeMath.sub(totalEthCharityCollected, totalEthCharityRecieved);
447     }
448 
449 
450     /*==========================================
451     =            INTERNAL FUNCTIONS            =
452     ==========================================*/
453 
454     // Make sure we will send back excess if user sends more then 5 ether before 100 ETH in contract
455     function purchaseInternal(uint256 _incomingEthereum, address _referredBy)
456       notContract()// no contracts allowed
457       internal
458       returns(uint256) {
459 
460       uint256 purchaseEthereum = _incomingEthereum;
461       uint256 excess;
462       if(purchaseEthereum > 5 ether) { // check if the transaction is over 5 ether
463           if (SafeMath.sub(address(this).balance, purchaseEthereum) <= 100 ether) { // if so check the contract is less then 100 ether
464               purchaseEthereum = 5 ether;
465               excess = SafeMath.sub(_incomingEthereum, purchaseEthereum);
466           }
467       }
468 
469       purchaseTokens(purchaseEthereum, _referredBy);
470 
471       if (excess > 0) {
472         msg.sender.transfer(excess);
473       }
474     }
475 
476 
477     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
478         internal
479         returns(uint256)
480     {
481         // data setup
482         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);
483         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
484         uint256 _charityPayout = SafeMath.div(SafeMath.mul(_incomingEthereum, charityFee_), 100);
485         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
486         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_incomingEthereum, _undividedDividends), _charityPayout);
487 
488         totalEthCharityCollected = SafeMath.add(totalEthCharityCollected, _charityPayout);
489 
490         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
491         uint256 _fee = _dividends * magnitude;
492 
493         // no point in continuing execution if OP is a poorfag russian hacker
494         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
495         // (or hackers)
496         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
497         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
498 
499         // is the user referred by a masternode?
500         if(
501             // is this a referred purchase?
502             _referredBy != 0x0000000000000000000000000000000000000000 &&
503 
504             // no cheating!
505             _referredBy != msg.sender &&
506 
507             // does the referrer have at least X whole tokens?
508             // i.e is the referrer a godly chad masternode
509             tokenBalanceLedger_[_referredBy] >= stakingRequirement
510         ){
511             // wealth redistribution
512             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
513         } else {
514             // no ref purchase
515             // add the referral bonus back to the global dividends cake
516             _dividends = SafeMath.add(_dividends, _referralBonus);
517             _fee = _dividends * magnitude;
518         }
519 
520         // we can't give people infinite ethereum
521         if(tokenSupply_ > 0){
522 
523             // add tokens to the pool
524             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
525 
526             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
527             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
528 
529             // calculate the amount of tokens the customer receives over his purchase
530             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
531 
532         } else {
533             // add tokens to the pool
534             tokenSupply_ = _amountOfTokens;
535         }
536 
537         // update circulating supply & the ledger address for the customer
538         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
539 
540         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
541         //really i know you think you do but you don't
542         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
543         payoutsTo_[msg.sender] += _updatedPayouts;
544 
545         // fire event
546         onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
547 
548         return _amountOfTokens;
549     }
550 
551     /**
552      * Calculate Token price based on an amount of incoming ethereum
553      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
554      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
555      */
556     function ethereumToTokens_(uint256 _ethereum)
557         internal
558         view
559         returns(uint256)
560     {
561         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
562         uint256 _tokensReceived =
563          (
564             (
565                 // underflow attempts BTFO
566                 SafeMath.sub(
567                     (sqrt
568                         (
569                             (_tokenPriceInitial**2)
570                             +
571                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
572                             +
573                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
574                             +
575                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
576                         )
577                     ), _tokenPriceInitial
578                 )
579             )/(tokenPriceIncremental_)
580         )-(tokenSupply_)
581         ;
582 
583         return _tokensReceived;
584     }
585 
586     /**
587      * Calculate token sell value.
588      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
589      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
590      */
591      function tokensToEthereum_(uint256 _tokens)
592         internal
593         view
594         returns(uint256)
595     {
596 
597         uint256 tokens_ = (_tokens + 1e18);
598         uint256 _tokenSupply = (tokenSupply_ + 1e18);
599         uint256 _etherReceived =
600         (
601             // underflow attempts BTFO
602             SafeMath.sub(
603                 (
604                     (
605                         (
606                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
607                         )-tokenPriceIncremental_
608                     )*(tokens_ - 1e18)
609                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
610             )
611         /1e18);
612         return _etherReceived;
613     }
614 
615 
616     //This is where all your gas goes, sorry
617     //Not sorry, you probably only paid 1 gwei
618     function sqrt(uint x) internal pure returns (uint y) {
619         uint z = (x + 1) / 2;
620         y = x;
621         while (z < y) {
622             y = z;
623             z = (x / z + z) / 2;
624         }
625     }
626 }
627 
628 /**
629  * @title SafeMath
630  * @dev Math operations with safety checks that throw on error
631  */
632 library SafeMath {
633 
634     /**
635     * @dev Multiplies two numbers, throws on overflow.
636     */
637     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
638         if (a == 0) {
639             return 0;
640         }
641         uint256 c = a * b;
642         assert(c / a == b);
643         return c;
644     }
645 
646     /**
647     * @dev Integer division of two numbers, truncating the quotient.
648     */
649     function div(uint256 a, uint256 b) internal pure returns (uint256) {
650         // assert(b > 0); // Solidity automatically throws when dividing by 0
651         uint256 c = a / b;
652         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
653         return c;
654     }
655 
656     /**
657     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
658     */
659     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
660         assert(b <= a);
661         return a - b;
662     }
663 
664     /**
665     * @dev Adds two numbers, throws on overflow.
666     */
667     function add(uint256 a, uint256 b) internal pure returns (uint256) {
668         uint256 c = a + b;
669         assert(c >= a);
670         return c;
671     }
672 }