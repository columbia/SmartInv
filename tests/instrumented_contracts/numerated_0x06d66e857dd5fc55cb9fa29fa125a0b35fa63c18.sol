1 pragma solidity ^0.4.20;
2 
3 /*
4 /* El equipo BOLAS GRANDES presenta :
5 /*
6     /$$$$$  /$$$$$$  /$$       /$$$$$$$  /$$$$$$$$  /$$$$$$  /$$      /$$ /$$$$$$$$
7    |__  $$ /$$__  $$| $$      | $$__  $$| $$_____/ /$$__  $$| $$$    /$$$| $$_____/
8       | $$| $$  \ $$| $$      | $$  \ $$| $$      | $$  \ $$| $$$$  /$$$$| $$      
9       | $$| $$  | $$| $$      | $$  | $$| $$$$$   | $$$$$$$$| $$ $$/$$ $$| $$$$$   
10  /$$  | $$| $$  | $$| $$      | $$  | $$| $$__/   | $$__  $$| $$  $$$| $$| $$__/   
11 | $$  | $$| $$  | $$| $$      | $$  | $$| $$      | $$  | $$| $$\  $ | $$| $$      
12 |  $$$$$$/|  $$$$$$/| $$$$$$$$| $$$$$$$/| $$$$$$$$| $$  | $$| $$ \/  | $$| $$$$$$$$
13  \______/  \______/ |________/|_______/ |________/|__/  |__/|__/     |__/|________/ 
14  
15  */
16                                                                                    
17                                                                                  
18 /* ESTA ES UNA PIRAMIDE BASADA EN SMART CONTRACTS DE CODIGO INDETENIBLE
19 /* LOS CREADORES NO PUEDEN HUIR CON EL ETHER
20 /* EL PRECIO SE CALCULA DE MANERA AUTOMATICA
21 /* NADIE PUEDE DETENER LA EJECUCION DE ESTE CODIGO 
22 /* SI ERES UN VERDADERO HOMBRE DE BOLAS GRANDES JOLDEA Y CONSIGUE DIVIDENDOS
23 /* SI ERES UNA PERRA DEBIL VENDE Y OBTEN TU ETHER
24 */
25 
26 contract JOLDEAME {
27     /*=================================
28     =            MODIFIERS            =
29     =================================*/
30     // only people with tokens
31     modifier onlyBagholders() {
32         require(myTokens() > 0);
33         _;
34     }
35 
36     // only people with profits
37     modifier onlyStronghands() {
38         require(myDividends(true) > 0);
39         _;
40     }
41 
42     // administrators can:
43     // -> change the name of the contract
44     // -> change the name of the token
45     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
46     // they CANNOT:
47     // -> take funds
48     // -> disable withdrawals
49     // -> kill the contract
50     // -> change the price of tokens
51     modifier onlyAdministrator(){
52         address _customerAddress = msg.sender;
53         require(administrators[_customerAddress]);
54         _;
55     }
56 
57 
58     // ensures that the first tokens in the contract will be equally distributed
59     // meaning, no divine dump will be ever possible
60     // result: healthy longevity.
61     modifier antiEarlyWhale(uint256 _amountOfEthereum){
62         address _customerAddress = msg.sender;
63 
64         // are we still in the vulnerable phase?
65         // if so, enact anti early whale protocol
66         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
67             require(
68                 // is the customer in the ambassador list?
69                 ambassadors_[_customerAddress] == true &&
70 
71                 // does the customer purchase exceed the max ambassador quota?
72                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
73 
74             );
75 
76             // updated the accumulated quota
77             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
78 
79             // execute
80             _;
81         } else {
82             // in case the ether count drops low, the ambassador phase won't reinitiate
83             onlyAmbassadors = false;
84             _;
85         }
86 
87     }
88 
89 
90     /*==============================
91     =            EVENTS            =
92     ==============================*/
93     event onTokenPurchase(
94         address indexed customerAddress,
95         uint256 incomingEthereum,
96         uint256 tokensMinted,
97         address indexed referredBy
98     );
99 
100     event onTokenSell(
101         address indexed customerAddress,
102         uint256 tokensBurned,
103         uint256 ethereumEarned
104     );
105 
106     event onReinvestment(
107         address indexed customerAddress,
108         uint256 ethereumReinvested,
109         uint256 tokensMinted
110     );
111 
112     event onWithdraw(
113         address indexed customerAddress,
114         uint256 ethereumWithdrawn
115     );
116 
117     // ERC20
118     event Transfer(
119         address indexed from,
120         address indexed to,
121         uint256 tokens
122     );
123     
124     
125     /*=====================================
126     =            CONFIGURABLES            =
127     =====================================*/
128     string public name = "JOLDEAME";
129     string public symbol = "JLD";
130     uint8 constant public decimals = 18;
131     uint8 constant internal entryFee_ = 20; // 20% to enter the strong body coins
132     uint8 constant internal transferFee_ = 10; // 10% transfer fee
133     uint8 constant internal refferalFee_ = 35; // 35% from enter fee divs or 7% for each invite, great for inviting strong bodies
134     uint8 constant internal exitFee_ = 35; // 25% for selling, weak bodies out
135     uint256 constant internal tokenPriceInitial_     = 0.00000001 ether;
136     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
137     uint256 constant internal magnitude = 2**64;
138 
139     // proof of stake (defaults at 100 tokens)
140     uint256 public stakingRequirement = 100e18;
141 
142     // ambassador program
143     mapping(address => bool) internal ambassadors_;
144     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
145     uint256 constant internal ambassadorQuota_ = 20 ether;
146     
147 	//premine address
148 	mapping(address => bool) internal premineAddressses_;
149 	
150 	// EV
151 	address constant pmAddress = 0xB3733bd576Ca263BDefc627F70eE0EDB3CFb0C8D;
152 	
153 	// UT
154 	address constant pmAddress2 = 0x2be6a7E480cF2E1bFb04846DEb8Efe017F51c9dE;
155 	
156 	//EM
157 	address constant pmAddress3 = 0x8d22dC9B35e46a820c756020Decb9e4EE8BF4AC7;
158     
159     
160 	/*================================
161 	 =            DATASETS            =
162 	 ================================*/
163     // amount of shares for each address (scaled number)
164     mapping(address => uint256) internal tokenBalanceLedger_;
165     mapping(address => uint256) internal referralBalance_;
166     mapping(address => int256) internal payoutsTo_;
167     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
168     uint256 internal tokenSupply_ = 0;
169     uint256 internal profitPerShare_;
170 
171     // administrator list (see above on what they can do)
172     mapping(address => bool) public administrators;
173 
174     //anyone can buy tokens right at the start
175     bool public onlyAmbassadors = false;
176 
177 
178 
179     /*=======================================
180     =            PUBLIC FUNCTIONS            =
181     =======================================*/
182     /*
183     * -- APPLICATION ENTRY POINTS --
184     */
185     function JOLDEAME()
186 	public
187     {
188 		uint256  _virtualETH  = 1 ether;
189 		uint256 _amountOfTokens = ethereumToTokens_(_virtualETH);
190 		
191         // add administrators here
192         administrators[0xB3733bd576Ca263BDefc627F70eE0EDB3CFb0C8D] = true;
193         
194 		
195 		//add the premine addresses here
196 		premineAddressses_[pmAddress] = true;
197 		premineAddressses_[pmAddress2] = true;
198 		premineAddressses_[pmAddress3] = true;
199         
200 		// add tokens to the pool
201 		tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
202 		
203         // update circulating supply & the ledger address for the pmAddress
204 		tokenBalanceLedger_[pmAddress] = SafeMath.add(tokenBalanceLedger_[pmAddress], _amountOfTokens);
205         
206         // the same for premine address 2
207 		//recalculate amount of tokens
208 		_amountOfTokens = ethereumToTokens_(_virtualETH);
209 		
210 			// add tokens to the pool
211 		tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
212 		
213 		// update circulating supply & the ledger address for the pmAddress
214 		tokenBalanceLedger_[pmAddress2] = SafeMath.add(tokenBalanceLedger_[pmAddress2], _amountOfTokens);
215 		
216 		// the same for premine address 3
217 		//recalculate amount of tokens
218 		_amountOfTokens = ethereumToTokens_(_virtualETH);
219 		
220 			// add tokens to the pool
221 		tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
222 		
223 		// update circulating supply & the ledger address for the pmAddress
224 		tokenBalanceLedger_[pmAddress3] = SafeMath.add(tokenBalanceLedger_[pmAddress3], _amountOfTokens);
225     }
226 
227 
228     /**
229      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
230      */
231     function buy(address _referredBy)
232 	public
233 	payable
234 	returns(uint256)
235     {
236         purchaseTokens(msg.value, _referredBy);
237     }
238 
239     /**
240      * Fallback function to handle ethereum that was send straight to the contract
241      * Unfortunately we cannot use a referral address this way.
242      */
243     function()
244 	payable
245 	public
246     {
247         purchaseTokens(msg.value, 0x0);
248     }
249 
250     /**
251      * Converts all of caller's dividends to tokens.
252     */
253     function reinvest()
254 	onlyStronghands()
255 	public
256     {
257         // fetch dividends
258         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
259 
260         // pay out the dividends virtually
261         address _customerAddress = msg.sender;
262         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
263 
264         // retrieve ref. bonus
265         _dividends += referralBalance_[_customerAddress];
266         referralBalance_[_customerAddress] = 0;
267 
268         // dispatch a buy order with the virtualized "withdrawn dividends"
269         uint256 _tokens = purchaseTokens(_dividends, 0x0);
270 
271         // fire event
272         onReinvestment(_customerAddress, _dividends, _tokens);
273     }
274 
275     /**
276      * Alias of sell() and withdraw().
277      */
278     function exit()
279 	public
280     {
281         // get token count for caller & sell them all
282         address _customerAddress = msg.sender;
283         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
284         if(_tokens > 0) sell(_tokens);
285 
286         // lambo delivery service
287         withdraw();
288     }
289 
290     /**
291      * Withdraws all of the callers earnings.
292      */
293     function withdraw()
294 	onlyStronghands()
295 	public
296     {
297         // setup data
298         address _customerAddress = msg.sender;
299         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
300 
301         // update dividend tracker
302         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
303 
304         // add ref. bonus
305         _dividends += referralBalance_[_customerAddress];
306         referralBalance_[_customerAddress] = 0;
307 
308         // lambo delivery service
309         _customerAddress.transfer(_dividends);
310 
311         // fire event
312         onWithdraw(_customerAddress, _dividends);
313     }
314 
315     /**
316      * Liquifies tokens to ethereum.
317      */
318     function sell(uint256 _amountOfTokens)
319 	onlyBagholders()
320 	public
321     {
322         // setup data
323         address _customerAddress = msg.sender;
324 		
325 		//pmAccount cannot sell
326 		require(!premineAddressses_[_customerAddress]);
327 		
328         // russian hackers BTFO
329         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
330         uint256 _tokens = _amountOfTokens;
331         uint256 _ethereum = tokensToEthereum_(_tokens);
332         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
333         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
334 
335         // burn the sold tokens
336         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
337         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
338 
339         // update dividends tracker
340         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
341         payoutsTo_[_customerAddress] -= _updatedPayouts;
342 
343         // dividing by zero is a bad idea
344         if (tokenSupply_ > 0) {
345             // update the amount of dividends per token
346             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
347         }
348 
349         // fire event
350         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
351     }
352 
353 
354     /**
355      * Transfer tokens from the caller to a new holder.
356      * Remember, there's a 10% fee here as well.
357      */
358     function transfer(address _toAddress, uint256 _amountOfTokens)
359 	onlyBagholders()
360 	public
361 	returns(bool)
362     {
363         // setup
364         address _customerAddress = msg.sender;
365 		
366 		//pmAccount cannot transfer
367 		require(!premineAddressses_[_customerAddress]);
368 
369         // make sure we have the requested tokens
370         // also disables transfers until ambassador phase is over
371         // ( we dont want whale premines )
372         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
373 
374         // withdraw all outstanding dividends first
375         if(myDividends(true) > 0) withdraw();
376 
377         // liquify 10% of the tokens that are transfered
378         // these are dispersed to shareholders
379         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
380         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
381         uint256 _dividends = tokensToEthereum_(_tokenFee);
382 
383         // burn the fee tokens
384         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
385 
386         // exchange tokens
387         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
388         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
389 
390         // update dividend trackers
391         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
392         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
393 
394         // disperse dividends among holders
395         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
396 
397         // fire event
398         Transfer(_customerAddress, _toAddress, _taxedTokens);
399 
400         // ERC20
401         return true;
402 
403     }
404 
405     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
406     /**
407      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
408      */
409     function disableInitialStage()
410         onlyAdministrator()
411         public
412     {
413         onlyAmbassadors = false;
414     }
415 
416     /**
417      * In case one of us dies, we need to replace ourselves.
418      */
419     function setAdministrator(address _identifier, bool _status)
420 	onlyAdministrator()
421 	public
422     {
423         administrators[_identifier] = _status;
424     }
425 
426     /**
427      * Precautionary measures in case we need to adjust the masternode rate.
428      */
429     function setStakingRequirement(uint256 _amountOfTokens)
430         onlyAdministrator()
431         public
432     {
433         stakingRequirement = _amountOfTokens;
434     }
435 
436     /**
437      * If we want to rebrand, we can.
438      */
439     function setName(string _name)
440         onlyAdministrator()
441         public
442     {
443         name = _name;
444     }
445 
446     /**
447      * If we want to rebrand, we can.
448      */
449     function setSymbol(string _symbol)
450         onlyAdministrator()
451         public
452     {
453         symbol = _symbol;
454     }
455 
456 
457     /*----------  HELPERS AND CALCULATORS  ----------*/
458     /**
459      * Method to view the current Ethereum stored in the contract
460      * Example: totalEthereumBalance()
461      */
462     function totalEthereumBalance()
463         public
464         view
465         returns(uint)
466     {
467         return this.balance;
468     }
469 
470     /**
471      * Retrieve the total token supply.
472      */
473     function totalSupply()
474         public
475         view
476         returns(uint256)
477     {
478         return tokenSupply_;
479     }
480 
481     /**
482      * Retrieve the tokens owned by the caller.
483      */
484     function myTokens()
485         public
486         view
487         returns(uint256)
488     {
489         address _customerAddress = msg.sender;
490         return balanceOf(_customerAddress);
491     }
492 
493     /**
494      * Retrieve the dividends owned by the caller.
495      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
496      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
497      * But in the internal calculations, we want them separate.
498      */
499     function myDividends(bool _includeReferralBonus)
500         public
501         view
502         returns(uint256)
503     {
504         address _customerAddress = msg.sender;
505         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
506     }
507 
508     /**
509      * Retrieve the token balance of any single address.
510      */
511     function balanceOf(address _customerAddress)
512         view
513         public
514         returns(uint256)
515     {
516         return tokenBalanceLedger_[_customerAddress];
517     }
518 
519     /**
520      * Retrieve the dividend balance of any single address.
521      */
522     function dividendsOf(address _customerAddress)
523         view
524         public
525         returns(uint256)
526     {
527         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
528     }
529 
530     /**
531      * Return the buy price of 1 individual token.
532      */
533     function sellPrice()
534         public
535         view
536         returns(uint256)
537     {
538         // our calculation relies on the token supply, so we need supply. Doh.
539         if(tokenSupply_ == 0){
540             return tokenPriceInitial_ - tokenPriceIncremental_;
541         } else {
542             uint256 _ethereum = tokensToEthereum_(1e18);
543             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
544             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
545             return _taxedEthereum;
546         }
547     }
548 
549     /**
550      * Return the sell price of 1 individual token.
551      */
552     function buyPrice()
553         public
554         view
555         returns(uint256)
556     {
557         // our calculation relies on the token supply, so we need supply. Doh.
558         if(tokenSupply_ == 0){
559             return tokenPriceInitial_ + tokenPriceIncremental_;
560         } else {
561             uint256 _ethereum = tokensToEthereum_(1e18);
562             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
563             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
564             return _taxedEthereum;
565         }
566     }
567 
568     /**
569      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
570      */
571     function calculateTokensReceived(uint256 _ethereumToSpend)
572         public
573         view
574         returns(uint256)
575     {
576         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
577         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
578         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
579 
580         return _amountOfTokens;
581     }
582 
583     /**
584      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
585      */
586     function calculateEthereumReceived(uint256 _tokensToSell)
587         public
588         view
589         returns(uint256)
590     {
591         require(_tokensToSell <= tokenSupply_);
592         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
593         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
594         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
595         return _taxedEthereum;
596     }
597 
598 
599     /*==========================================
600     =            INTERNAL FUNCTIONS            =
601     ==========================================*/
602     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
603         antiEarlyWhale(_incomingEthereum)
604         internal
605         returns(uint256)
606     {
607         // data setup
608         address _customerAddress = msg.sender;
609         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
610         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
611         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
612         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
613         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
614         uint256 _fee = _dividends * magnitude;
615 
616         // no point in continuing execution if OP is a poorfag russian hacker
617         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
618         // (or hackers)
619         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
620         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
621 
622         // is the user referred by a masternode?
623         if(
624             // is this a referred purchase?
625             _referredBy != 0x0000000000000000000000000000000000000000 &&
626 
627             // no cheating!
628             _referredBy != _customerAddress &&
629 
630             // does the referrer have at least X whole tokens?
631             // i.e is the referrer a godly chad masternode
632             tokenBalanceLedger_[_referredBy] >= stakingRequirement
633         ){
634             // wealth redistribution
635             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
636         } else {
637             // no ref purchase
638             // add the referral bonus back to the global dividends cake
639             _dividends = SafeMath.add(_dividends, _referralBonus);
640             _fee = _dividends * magnitude;
641         }
642 
643         // we can't give people infinite ethereum
644         if(tokenSupply_ > 0){
645 
646             // add tokens to the pool
647             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
648 
649             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
650             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
651 
652             // calculate the amount of tokens the customer receives over his purchase
653             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
654 
655         } else {
656             // add tokens to the pool
657             tokenSupply_ = _amountOfTokens;
658         }
659 
660         // update circulating supply & the ledger address for the customer
661         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
662 
663         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
664         //really i know you think you do but you don't
665         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
666         payoutsTo_[_customerAddress] += _updatedPayouts;
667 
668         // fire event
669         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
670 
671         return _amountOfTokens;
672     }
673 
674     /**
675      * Calculate Token price based on an amount of incoming ethereum
676      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
677      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
678      */
679     function ethereumToTokens_(uint256 _ethereum)
680         internal
681         view
682         returns(uint256)
683     {
684         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
685         uint256 _tokensReceived =
686          (
687             (
688                 // underflow attempts BTFO
689                 SafeMath.sub(
690                     (sqrt
691                         (
692                             (_tokenPriceInitial**2)
693                             +
694                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
695                             +
696                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
697                             +
698                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
699                         )
700                     ), _tokenPriceInitial
701                 )
702             )/(tokenPriceIncremental_)
703         )-(tokenSupply_)
704         ;
705 
706         return _tokensReceived;
707     }
708 
709     /**
710      * Calculate token sell value.
711      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
712      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
713      */
714      function tokensToEthereum_(uint256 _tokens)
715         internal
716         view
717         returns(uint256)
718     {
719 
720         uint256 tokens_ = (_tokens + 1e18);
721         uint256 _tokenSupply = (tokenSupply_ + 1e18);
722         uint256 _etherReceived =
723         (
724             // underflow attempts BTFO
725             SafeMath.sub(
726                 (
727                     (
728                         (
729                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
730                         )-tokenPriceIncremental_
731                     )*(tokens_ - 1e18)
732                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
733             )
734         /1e18);
735         return _etherReceived;
736     }
737 
738 
739     //This is where all your gas goes, sorry
740     //Not sorry, you probably only paid 1 gwei
741     function sqrt(uint x) internal pure returns (uint y) {
742         uint z = (x + 1) / 2;
743         y = x;
744         while (z < y) {
745             y = z;
746             z = (x / z + z) / 2;
747         }
748     }
749 }
750 
751 /**
752  * @title SafeMath
753  * @dev Math operations with safety checks that throw on error
754  */
755 library SafeMath {
756 
757     /**
758     * @dev Multiplies two numbers, throws on overflow.
759     */
760     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
761         if (a == 0) {
762             return 0;
763         }
764         uint256 c = a * b;
765         assert(c / a == b);
766         return c;
767     }
768 
769     /**
770     * @dev Integer division of two numbers, truncating the quotient.
771     */
772     function div(uint256 a, uint256 b) internal pure returns (uint256) {
773         // assert(b > 0); // Solidity automatically throws when dividing by 0
774         uint256 c = a / b;
775         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
776         return c;
777     }
778 
779     /**
780     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
781     */
782     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
783         assert(b <= a);
784         return a - b;
785     }
786 
787     /**
788     * @dev Adds two numbers, throws on overflow.
789     */
790     function add(uint256 a, uint256 b) internal pure returns (uint256) {
791         uint256 c = a + b;
792         assert(c >= a);
793         return c;
794     }
795 }