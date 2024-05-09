1 pragma solidity ^0.4.20;
2 
3 
4 /*
5 * 
6 * REVOLUTION1
7 *
8 * A new concept in profit sharing and giving back to the community
9 *
10 */
11 
12 contract REV1 {
13     /*=================================
14     =            MODIFIERS            =
15     =================================*/
16     // only people with tokens
17     modifier onlyBagholders() {
18         require(myTokens() > 0);
19         _;
20     }
21     
22     // only people with profits
23     modifier onlyStronghands() {
24         require(myDividends(true) > 0);
25         _;
26     }
27     
28     // administrators can:
29     // -> change the name of the contract
30     // -> change the name of the token
31     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
32     // they CANNOT:
33     // -> take funds
34     // -> disable withdrawals
35     // -> kill the contract
36     // -> change the price of tokens
37     modifier onlyAdministrator(){
38         address _customerAddress = msg.sender;
39         require(administrators[keccak256(_customerAddress)]);
40         _;
41     }
42     
43     //fvrr2 ensure that every buy transaction has a maximum of 1 ETH when the contract reaches 10 ETH
44     modifier limitBuy() { 
45         if(msg.value > 1 ether) { // check if the transaction is over 1ether
46             if (address(this).balance >= 10 ether) { // if so check if the contract has over 10 ether
47                 revert(); // if so : revert the transaction
48             }
49         }
50         _;
51     }
52 
53     /*==============================
54     =            EVENTS            =
55     ==============================*/
56     event onTokenPurchase(
57         address indexed customerAddress,
58         uint256 incomingEthereum,
59         uint256 tokensMinted,
60         address indexed referredBy
61     );
62     
63     event onTokenSell(
64         address indexed customerAddress,
65         uint256 tokensBurned,
66         uint256 ethereumEarned
67     );
68     
69     event onReinvestment(
70         address indexed customerAddress,
71         uint256 ethereumReinvested,
72         uint256 tokensMinted
73     );
74     
75     event onWithdraw(
76         address indexed customerAddress,
77         uint256 ethereumWithdrawn
78     );
79     
80     // ERC20
81     event Transfer(
82         address indexed from,
83         address indexed to,
84         uint256 tokens
85     );
86     
87     
88     /*=====================================
89     =            CONFIGURABLES            =
90     =====================================*/
91     string public name = "REV1";
92     string public symbol = "REV1";
93     uint8 constant public decimals = 18;
94     uint8 constant internal dividendFee_ = 10;
95     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
96     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
97     uint256 constant internal magnitude = 2**64;
98     
99     // proof of stake (defaults at 100 tokens)
100     uint256 public stakingRequirement = 5e18;
101     
102     // ambassador program
103     mapping(address => bool) internal ambassadors_;
104     
105     
106     
107    /*================================
108     =            DATASETS            =
109     ================================*/
110     // amount of shares for each address (scaled number)
111     mapping(address => uint256) internal tokenBalanceLedger_;
112     mapping(address => uint256) public   ambassadorLedger;
113     mapping(address => uint256) internal referralBalance_;
114     mapping(address => int256) internal payoutsTo_;
115     uint256 internal tokenSupply_ = 0;
116     uint256 internal ambassadorSupply = 0; // fvrr is important to be able to view the REAL supply with ambassador tokens but still receiving his dividends.
117     uint256 internal profitPerShare_;
118     mapping(address => bool) internal whitelisted_; // fvrr3
119     bool internal whitelist_ = true; // fvrr3 whitelist is automatically activated
120     
121     // administrator list (see above on what they can do)
122     mapping(bytes32 => bool) public administrators;
123     
124 
125 
126     /*=======================================
127     =            PUBLIC FUNCTIONS            =
128     =======================================*/
129     /*
130     * -- APPLICATION ENTRY POINTS --  
131     */
132     constructor()
133         public
134     {
135         // add administrators here
136         //No ambassadors aside from the WHALE
137         
138 
139         // add the ambassadors here. 
140         ambassadors_[0x7301494d217C50557f4b2A515F0c65FA9b302641] = true; //D
141 
142         whitelisted_[0x7301494d217C50557f4b2A515F0c65FA9b302641] = true;
143         whitelisted_[0xB093E319f94c02604FdDD57701Cd5C34F71d6f3d] = true;
144         whitelisted_[0xc42559F88481e1Df90f64e5E9f7d7C6A34da5691] = true;
145         whitelisted_[0xd72998ab5681d8EA37D16Ad9bf3aE50b4C693289] = true;
146         whitelisted_[0x3B37F823108A1BF7cdb0c6626b473e3bC9D21621] = true;
147 
148 
149     }
150     
151      
152     /**
153      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
154      */
155     function buy(address _referredBy)
156         public
157         payable
158         returns(uint256)
159     {
160         excludeAmbassadors(msg.value, _referredBy); // fvrr : just a tag so I can easily search for parts that I changed
161     }
162     
163     /**
164      * Fallback function to handle ethereum that was send straight to the contract
165      * Unfortunately we cannot use a referral address this way.
166      */
167     function()
168         payable
169         public
170     {
171         excludeAmbassadors(msg.value, 0x0); // fvrr : just a tag so I can easily search for parts that I changed
172     }
173     
174     /**
175      * Converts all of caller's dividends to tokens.
176      */
177     function reinvest()
178         onlyStronghands()
179         public
180     {   
181         // fetch dividends
182         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
183         
184         // pay out the dividends virtually
185         address _customerAddress = msg.sender;
186         require(ambassadors_[_customerAddress] == false); //fvrr ambassador can't reinvest tokens
187         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
188         
189         // retrieve ref. bonus
190         _dividends += referralBalance_[_customerAddress];
191         referralBalance_[_customerAddress] = 0;
192         
193         // dispatch a buy order with the virtualized "withdrawn dividends"
194         uint256 _tokens = purchaseTokens(_dividends, 0x0);
195         
196         // fire event
197         emit onReinvestment(_customerAddress, _dividends, _tokens);
198     }
199     
200     /**
201      * Alias of sell() and withdraw().
202      */
203     function exit()
204         public
205     {
206         // get token count for caller & sell them all
207         address _customerAddress = msg.sender;
208         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
209         if(_tokens > 0) sell(_tokens);
210         
211         // lambo delivery service
212         withdraw();
213     }
214 
215     /**
216      * Withdraws all of the callers earnings.
217      */
218     function withdraw()
219         onlyStronghands()
220         public
221     {
222         // setup data
223         address _customerAddress = msg.sender;
224         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
225         
226         // update dividend tracker
227         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
228         
229         // add ref. bonus
230         _dividends += referralBalance_[_customerAddress];
231         referralBalance_[_customerAddress] = 0;
232         
233         // lambo delivery service
234         _customerAddress.transfer(_dividends);
235         
236         // fire event
237         emit onWithdraw(_customerAddress, _dividends);
238     }
239     
240     /**
241      * Liquifies tokens to ethereum.
242      */
243     function sell(uint256 _amountOfTokens)
244         onlyBagholders()
245         public
246     {
247         // setup data
248         address _customerAddress = msg.sender;
249         require(ambassadors_[_customerAddress] == false); //fvrr ambassador can't sell tokens
250         // russian hackers BTFO
251         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
252         uint256 _tokens = _amountOfTokens;
253         uint256 _ethereum = tokensToEthereum_(_tokens);
254         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
255         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
256         
257         // burn the sold tokens
258         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
259         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
260         
261         // update dividends tracker
262         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
263         payoutsTo_[_customerAddress] -= _updatedPayouts;       
264         
265         // dividing by zero is a bad idea
266         if (tokenSupply_ > 0) {
267             // update the amount of dividends per token
268             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
269         }
270         
271         // fire event
272         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
273     }
274     
275     
276     /**
277      * Transfer tokens from the caller to a new holder.
278      * Remember, there's a 10% fee here as well.
279      */
280     function transfer(address _toAddress, uint256 _amountOfTokens)
281         onlyBagholders()
282         public
283         returns(bool)
284     {
285         // setup
286         address _customerAddress = msg.sender;
287         require(ambassadors_[_customerAddress] == false && ambassadors_[_toAddress] == false); //fvrr ambassador can't transfer tokens or receive tokens
288         
289         // make sure we have the requested tokens
290         // also disables transfers until ambassador phase is over
291         // ( we dont want whale premines )
292         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
293         
294         // withdraw all outstanding dividends first
295         if(myDividends(true) > 0) withdraw();
296         
297         // liquify 10% of the tokens that are transfered
298         // these are dispersed to shareholders
299         //uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_); // fvrr2 disable dividends
300         //uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee); // fvrr2 disable dividends
301         //uint256 _dividends = tokensToEthereum_(_tokenFee); // fvrr2 disable dividends
302   
303         // burn the fee tokens
304         //tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee); // fvrr2 disable dividends
305 
306         // exchange tokens
307         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
308         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens); // fvrr2 _taxedTokens = _amountOfTokens
309         
310         // update dividend trackers
311         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
312         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens); // fvrr2 _taxedTokens = _amountOfTokens
313         
314         // disperse dividends among holders
315         //profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_); // fvrr2 disable dividends
316         
317         // fire event
318         emit Transfer(_customerAddress, _toAddress, _amountOfTokens); // fvrr2 _taxedTokens = _amountOfTokens
319         
320         // ERC20
321         return true;
322        
323     }
324     
325     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
326 
327     /**
328      * In case one of us dies, we need to replace ourselves.
329      */
330     function setAdministrator(bytes32 _identifier, bool _status)
331         onlyAdministrator()
332         public
333     {
334         administrators[_identifier] = _status;
335     }
336     
337     /**
338      * Precautionary measures in case we need to adjust the masternode rate.
339      */
340     function setStakingRequirement(uint256 _amountOfTokens)
341         onlyAdministrator()
342         public
343     {
344         stakingRequirement = _amountOfTokens;
345     }
346     
347     /**
348      * If we want to rebrand, we can.
349      */
350     function setName(string _name)
351         onlyAdministrator()
352         public
353     {
354         name = _name;
355     }
356     
357     /**
358      * If we want to rebrand, we can.
359      */
360     function setSymbol(string _symbol)
361         onlyAdministrator()
362         public
363     {
364         symbol = _symbol;
365     }
366 
367     
368     /*----------  HELPERS AND CALCULATORS  ----------*/
369     /**
370      * Method to view the current Ethereum stored in the contract
371      * Example: totalEthereumBalance()
372      */
373     function totalEthereumBalance()
374         public
375         view
376         returns(uint)
377     {
378         return address (this).balance;
379     }
380     
381     /**
382      * Retrieve the total token supply.
383      */
384     function totalSupply()
385         public
386         view
387         returns(uint256)
388     {
389         return tokenSupply_ + ambassadorSupply; // fvrr adds the tokens from ambassadors to the supply (but not to the dividends calculation which is based on the supply)
390     }
391     
392     /**
393      * Retrieve the tokens owned by the caller.
394      */
395     function myTokens()
396         public
397         view
398         returns(uint256)
399     {
400         address _customerAddress = msg.sender;
401         return balanceOf(_customerAddress);
402     }
403     
404     /**
405      * Retrieve the dividends owned by the caller.
406      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
407      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
408      * But in the internal calculations, we want them separate. 
409      */ 
410     function myDividends(bool _includeReferralBonus) 
411         public 
412         view 
413         returns(uint256)
414     {
415         address _customerAddress = msg.sender;
416         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
417     }
418     
419     /**
420      * Retrieve the token balance of any single address.
421      */
422     function balanceOf(address _customerAddress)
423         view
424         public
425         returns(uint256)
426     {
427         uint256 balance;
428         if (ambassadors_[msg.sender] == true) { // changement here so the ambassador still sees his special amount of tokens
429             balance = ambassadorLedger[_customerAddress]; // fvrr : just a tag so I can easily search for parts that I changed
430         }
431         else {
432             balance = tokenBalanceLedger_[_customerAddress];
433         }
434         return balance;
435     }
436     
437     /**
438      * Retrieve the dividend balance of any single address.
439      */
440     function dividendsOf(address _customerAddress)
441         view
442         public
443         returns(uint256)
444     {
445         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
446     }
447     
448     /**
449      * Return the buy price of 1 individual token.
450      */
451     function sellPrice() 
452         public 
453         view 
454         returns(uint256)
455     {
456         // our calculation relies on the token supply, so we need supply. Doh.
457         if(tokenSupply_+ambassadorSupply == 0){ // fvrr changed so they see the correct price with ambassadorSupply
458             return tokenPriceInitial_ - tokenPriceIncremental_;
459         } else {
460             uint256 _ethereum = tokensToEthereum_(1e18);
461             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
462             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
463             return _taxedEthereum;
464         }
465     }
466     
467     /**
468      * Return the sell price of 1 individual token.
469      */
470     function buyPrice() 
471         public 
472         view 
473         returns(uint256)
474     {
475         // our calculation relies on the token supply, so we need supply. Doh.
476         if(tokenSupply_+ambassadorSupply == 0){ // fvrr changed so they see the correct price with ambassadorSupply
477             return tokenPriceInitial_ + tokenPriceIncremental_;
478         } else {
479             uint256 _ethereum = tokensToEthereum_(1e18);
480             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
481             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
482             return _taxedEthereum;
483         }
484     }
485     
486     /**
487      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
488      */
489     function calculateTokensReceived(uint256 _ethereumToSpend) 
490         public 
491         view 
492         returns(uint256)
493     {
494         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
495         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
496         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
497         
498         return _amountOfTokens;
499     }
500     
501     /**
502      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
503      */
504     function calculateEthereumReceived(uint256 _tokensToSell) 
505         public 
506         view 
507         returns(uint256)
508     {
509         require(_tokensToSell <= tokenSupply_);
510         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
511         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
512         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
513         return _taxedEthereum;
514     }
515     
516     function disableWhitelist() public returns(bool){
517         require(ambassadors_[msg.sender] == true);
518         whitelist_ = false;
519 
520         return whitelist_;
521     }
522     /*==========================================
523     =            INTERNAL FUNCTIONS            =
524     ==========================================*/
525     function excludeAmbassadors(uint256 _incomingEthereum, address _referredBy) internal returns(uint256) { // fvrr : just a tag so I can easily search for parts that I changed
526         address _customerAddress = msg.sender;
527         uint256 StokenAmount;
528 
529         //fvrr3 if the whitelist is true only whitelisted people are allowed to buy.
530         //whitelist
531         if((msg.value) < address(this).balance && (address(this).balance-(msg.value)) >= 7 ether) { 
532             whitelist_ = false; 
533             }
534 
535         if (whitelisted_[msg.sender] == false && whitelist_ == true) { // if the person is not whitelisted but whitelist is true/active, revert the transaction
536             revert();
537         }
538 
539         StokenAmount = purchaseTokens(msg.value, _referredBy); //redirects to purchaseTokens so same functionality
540 
541         if (ambassadors_[_customerAddress] == true) { // special treatment of ambassador addresses (only for them)
542 
543             tokenSupply_ = SafeMath.sub(tokenSupply_, StokenAmount); // takes out ambassadors token from the tokenSupply_ (important for redistribution)
544             tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], StokenAmount); // takes out ambassadors tokens from his ledger so he is "officially" holding 0 tokens. (=> doesn't receive dividends anymore)
545             ambassadorLedger[_customerAddress] = SafeMath.add(ambassadorLedger[_customerAddress], StokenAmount);    // Because you have officially zero, you'll get a special ledger to be able to sell your special treatment tokens later 
546             ambassadorSupply = SafeMath.add(ambassadorSupply, StokenAmount); // we need this for a correct totalSupply() number later
547         }
548 
549         return StokenAmount;
550     }
551 
552 
553     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
554         limitBuy() // fvrr2 add the limitBuy restriction
555         internal
556         returns(uint256)
557     {
558         // data setup
559         address _customerAddress = msg.sender;
560         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
561         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
562         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
563         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
564         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
565         uint256 _fee = _dividends * magnitude;
566  
567         // no point in continuing execution if OP is a poorfag russian hacker
568         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
569         // (or hackers)
570         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
571         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
572         
573         // is the user referred by a masternode?
574         if(
575             // is this a referred purchase?
576             _referredBy != 0x0000000000000000000000000000000000000000 &&
577 
578             // no cheating!
579             _referredBy != _customerAddress &&
580             
581             // does the referrer have at least X whole tokens?
582             // i.e is the referrer a godly chad masternode
583             tokenBalanceLedger_[_referredBy] >= stakingRequirement
584         ){
585             // wealth redistribution
586             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
587         } else {
588             // no ref purchase
589             // add the referral bonus back to the global dividends cake
590             _dividends = SafeMath.add(_dividends, _referralBonus);
591             _fee = _dividends * magnitude;
592         }
593         
594         // we can't give people infinite ethereum
595         if(tokenSupply_ > 0){
596             
597             // add tokens to the pool
598             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
599  
600             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
601             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
602             
603             // calculate the amount of tokens the customer receives over his purchase 
604             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
605         
606         } else {
607             // add tokens to the pool
608             tokenSupply_ = _amountOfTokens;
609         }
610         
611         // update circulating supply & the ledger address for the customer
612         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
613         
614         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
615         //really i know you think you do but you don't
616         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
617         payoutsTo_[_customerAddress] += _updatedPayouts;
618         
619         // fire event
620         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
621         
622         return _amountOfTokens;
623     }
624 
625     /**
626      * Calculate Token price based on an amount of incoming ethereum
627      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
628      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
629      */
630     function ethereumToTokens_(uint256 _ethereum)
631         internal
632         view
633         returns(uint256)
634     {
635         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
636         uint256 _tknsupply = tokenSupply_ + ambassadorSupply; // fvrr ambassadorSupply needs to get added otherwise the tokenprice wouldn't change if ambassador buys
637         uint256 _tokensReceived = 
638          (
639             (
640                 // underflow attempts BTFO
641                 SafeMath.sub(
642                     (sqrt
643                         (
644                             (_tokenPriceInitial**2)
645                             +
646                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
647                             +
648                             (((tokenPriceIncremental_)**2)*(_tknsupply**2))
649                             +
650                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*_tknsupply)
651                         )
652                     ), _tokenPriceInitial
653                 )
654             )/(tokenPriceIncremental_)
655         )-(_tknsupply)
656         ;
657   
658         return _tokensReceived;
659     }
660     
661     /**
662      * Calculate token sell value.
663      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
664      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
665      */
666      function tokensToEthereum_(uint256 _tokens)
667         internal
668         view
669         returns(uint256)
670     {
671 
672         uint256 tokens_ = (_tokens + 1e18);
673         uint256 _tokenSupply = (tokenSupply_ + ambassadorSupply + 1e18); // fvrr ambassadorSupply needs to get added otherwise the tokenprice wouldn't change if ambassador buys
674         uint256 _etherReceived =
675         (
676             // underflow attempts BTFO
677             SafeMath.sub(
678                 (
679                     (
680                         (
681                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
682                         )-tokenPriceIncremental_
683                     )*(tokens_ - 1e18)
684                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
685             )
686         /1e18);
687         return _etherReceived;
688     }
689     
690     
691     //This is where all your gas goes, sorry
692     //Not sorry, you probably only paid 1 gwei
693     function sqrt(uint x) internal pure returns (uint y) {
694         uint z = (x + 1) / 2;
695         y = x;
696         while (z < y) {
697             y = z;
698             z = (x / z + z) / 2;
699         }
700     }
701 }
702 
703 /**
704  * @title SafeMath
705  * @dev Math operations with safety checks that throw on error
706  */
707 library SafeMath {
708 
709     /**
710     * @dev Multiplies two numbers, throws on overflow.
711     */
712     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
713         if (a == 0) {
714             return 0;
715         }
716         uint256 c = a * b;
717         assert(c / a == b);
718         return c;
719     }
720 
721     /**
722     * @dev Integer division of two numbers, truncating the quotient.
723     */
724     function div(uint256 a, uint256 b) internal pure returns (uint256) {
725         // assert(b > 0); // Solidity automatically throws when dividing by 0
726         uint256 c = a / b;
727         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
728         return c;
729     }
730 
731     /**
732     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
733     */
734     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
735         assert(b <= a);
736         return a - b;
737     }
738 
739     /**
740     * @dev Adds two numbers, throws on overflow.
741     */
742     function add(uint256 a, uint256 b) internal pure returns (uint256) {
743         uint256 c = a + b;
744         assert(c >= a);
745         return c;
746     }
747 }