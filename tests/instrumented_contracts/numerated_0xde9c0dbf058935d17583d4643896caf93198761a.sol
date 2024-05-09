1 pragma solidity ^0.4.24;
2 
3 /*
4 * Poexer.com is a real-time decentralized cryptocurrency exchange which allows you to trade Ethereum with POX tokens.
5 * Buy, Sell, or Transfer POX tokens, fees of your transaction is used to pay earnings to other users holding POX tokens.
6 * - The fee for Buying: 10%
7 * - The fee for Selling: 20%
8 * - The fee for Transfer: 10%
9 * Reinvest or Withdraw your Ethereum earnings back from the exchange contract. 
10 * Poexer Referral Program: Log in to get your invitation link and share it with your friends!
11 * Invite your friends to trade on Poexer.com, and you will receive up to 40% of the buy-in-fees they would otherwise pay to the contract, in ETH, in real-time!
12 * References: POWH3D contract.
13 */
14 
15 contract POXToken {
16     /*=================================
17     =            MODIFIERS            =
18     =================================*/
19     // only people with tokens
20     modifier onlyBagholders() {
21         require(myTokens() > 0);
22         _;
23     }
24     
25     // only people with profits
26     modifier onlyStronghands() {
27         require(myDividends(true) > 0);
28         _;
29     }
30     
31     // administrators can:
32     // -> change the name of the contract
33     // -> change the name of the token
34     // -> set new administrator
35     // -> change the PoS difficulty (How many tokens it costs to hold a referral, in case it gets crazy high later)
36     // they CANNOT:
37     // -> take funds
38     // -> disable withdrawals
39     // -> kill the contract
40     // -> change the price of tokens
41     modifier onlyAdministrator(){
42         address _customerAddress = msg.sender;
43         require(administrators[(_customerAddress)]);
44         _;
45     }
46     
47     
48     // ensures that the first tokens in the contract will be equally distributed
49     // meaning, no divine dump will be ever possible
50     // result: healthy longevity.
51     modifier antiEarlyWhale(uint256 _amountOfEthereum){
52         address _customerAddress = msg.sender;
53         
54         // are we still in the vulnerable phase?
55         // if so, enact anti early whale protocol 
56         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
57             require(
58                 // is the customer in the ambassador list?
59                 ambassadors_[_customerAddress] == true &&
60                 
61                 // does the customer purchase exceed the max ambassador quota?
62                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
63                 
64             );
65             
66             // updated the accumulated quota    
67             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
68         
69             // execute
70             _;
71         } else {
72             // in case the ether count drops low, the ambassador phase won't reinitiate
73             onlyAmbassadors = false;
74             _;    
75         }
76         
77     }
78     
79     
80     /*==============================
81     =            EVENTS            =
82     ==============================*/
83     event onTokenPurchase(
84         address indexed customerAddress,
85         uint256 incomingEthereum,
86         uint256 tokensMinted,
87         address indexed referredBy
88     );
89     
90     event onTokenSell(
91         address indexed customerAddress,
92         uint256 tokensBurned,
93         uint256 ethereumEarned
94     );
95     
96     event onReinvestment(
97         address indexed customerAddress,
98         uint256 ethereumReinvested,
99         uint256 tokensMinted
100     );
101     
102     event onWithdraw(
103         address indexed customerAddress,
104         uint256 ethereumWithdrawn
105     );
106     
107     // ERC20
108     event Transfer(
109         address indexed from,
110         address indexed to,
111         uint256 tokens
112     );
113     
114     
115     /*=====================================
116     =            CONFIGURABLES            =
117     =====================================*/
118     string public name = "POXToken";
119     string public symbol = "POX";
120     uint8 constant public decimals = 18;
121     uint8 constant internal buyFee_ = 10;
122     uint8 constant internal sellFee_ = 5;
123     uint8 constant internal exchangebuyFee_ = 100;
124     uint8 constant internal exchangesellFee_ = 50;
125     uint8 constant internal referralFeenormal_ = 50;
126     uint8 constant internal referralFeedouble_ = 25;
127     uint8 constant internal transferFee_ = 10;
128     uint32 constant internal presaletransferFee_ = 1000000;
129     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
130     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
131     uint256 constant internal magnitude = 2**64;
132     
133     // proof of stake Doubles Referral Rewards (defaults at 500 tokens)
134     uint256 public stakingRequirement = 500e18;
135     
136     // presale
137     mapping(address => bool) internal ambassadors_;
138     uint256 constant internal ambassadorMaxPurchase_ = 1000 ether;
139     uint256 constant internal ambassadorQuota_ = 1010 ether;
140     
141     
142     
143    /*================================
144     =            DATASETS            =
145     ================================*/
146     // amount of shares for each address (scaled number)
147     mapping(address => uint256) internal tokenBalanceLedger_;
148     mapping(address => uint256) internal referralBalance_;
149     mapping(address => int256) internal payoutsTo_;
150     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
151     uint256 internal tokenSupply_ = 0;
152     uint256 internal profitPerShare_;
153     
154     // administrator list (see above on what they can do)
155     mapping(address => bool) public administrators;
156     
157     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
158     bool public onlyAmbassadors = true;
159     
160     // fees and measurement error address
161     address private exchangefees;
162     address private measurement;
163 
164 
165 
166     /*=======================================
167     =            PUBLIC FUNCTIONS            =
168     =======================================*/
169     /*
170     * -- APPLICATION ENTRY POINTS --  
171     */
172     function POXToken(address _exchangefees, address _measurement)
173         public
174     {
175         require(_exchangefees != address(0));
176         exchangefees = _exchangefees;
177         
178         require(_measurement != address(0));
179         measurement = _measurement;
180         
181         // administrators
182         administrators[0x8889885f4a4800abC7F32aC661765cd1FAaC7D49] = true;
183         
184         // pre-sale wallet. 
185         ambassadors_[0xA7A1d05b15de7d5C0a8A27dDD3B011Ec366D6bB9] = true;
186         
187     }
188     
189      
190     /**
191      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
192      */
193     function buy(address _referredBy)
194         public
195         payable
196         returns(uint256)
197     {
198         purchaseTokens(msg.value, _referredBy);
199     }
200     
201     /**
202      * Fallback function to handle ethereum that was send straight to the contract
203      * Unfortunately we cannot use a referral address this way.
204      */
205     function()
206         payable
207         public
208     {
209         purchaseTokens(msg.value, 0x0);
210     }
211     
212     /**
213      * Converts all of caller's dividends to tokens.
214      */
215     function reinvest()
216         onlyStronghands()
217         public
218     {
219         // fetch dividends
220         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
221         
222         // pay out the dividends virtually
223         address _customerAddress = msg.sender;
224         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
225         
226         // retrieve ref. bonus
227         _dividends += referralBalance_[_customerAddress];
228         referralBalance_[_customerAddress] = 0;
229         
230         // dispatch a buy order with the virtualized "withdrawn dividends"
231         uint256 _tokens = purchaseTokens(_dividends, 0x0);
232         
233         // fire event
234         onReinvestment(_customerAddress, _dividends, _tokens);
235     }
236     
237     /**
238      * Alias of sell() and withdraw().
239      */
240     function exit()
241         public
242     {
243         // get token count for caller & sell them all
244         address _customerAddress = msg.sender;
245         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
246         if(_tokens > 0) sell(_tokens);
247         
248         // lambo delivery service
249         withdraw();
250     }
251 
252     /**
253      * Withdraws all of the callers earnings.
254      */
255     function withdraw()
256         onlyStronghands()
257         public
258     {
259         // setup data
260         address _customerAddress = msg.sender;
261         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
262         
263         // update dividend tracker
264         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
265         
266         // add ref. bonus
267         _dividends += referralBalance_[_customerAddress];
268         referralBalance_[_customerAddress] = 0;
269         
270         // lambo delivery service
271         _customerAddress.transfer(_dividends);
272         
273         // fire event
274         onWithdraw(_customerAddress, _dividends);
275     }
276     
277     /**
278      * Liquifies tokens to ethereum.
279      */
280     function sell(uint256 _amountOfTokens)
281         onlyBagholders()
282         public
283     {
284         // setup data
285         // low fees for presale
286         address _customerAddress = msg.sender;
287         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
288         uint256 _tokens = _amountOfTokens;
289         uint256 _ethereum = tokensToEthereum_(_tokens);
290         uint256 _feesEthereum = SafeMath.div(_ethereum, exchangesellFee_);
291         uint256 _sellfeeEthereum = SafeMath.div(_ethereum, sellFee_);
292         if (ambassadors_[_customerAddress] == true) {
293             _sellfeeEthereum = SafeMath.div(_ethereum, exchangesellFee_);
294         }
295         uint256 _dividends = SafeMath.sub(_sellfeeEthereum, _feesEthereum);
296         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _sellfeeEthereum);
297         
298         // fees and burn the sold tokens
299         exchangefees.transfer(_feesEthereum);
300         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
301         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
302         
303         // update dividends tracker
304         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
305         payoutsTo_[_customerAddress] -= _updatedPayouts;       
306         
307         // dividing by zero is a bad idea
308         if (tokenSupply_ > 0) {
309             // update the amount of dividends per token and measurement error
310             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
311             payoutsTo_[measurement] -= (int256) (SafeMath.sub((_dividends * magnitude), SafeMath.div((_dividends * magnitude), tokenSupply_) * tokenSupply_));
312         }
313         
314         // fire event
315         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
316     }
317     
318     
319     /**
320      * Transfer tokens from the caller to a new holder.
321      * Remember, there's a 10% fee here as well.
322      */
323     function transfer(address _toAddress, uint256 _amountOfTokens)
324         onlyBagholders()
325         public
326         returns(bool)
327     {
328         // setup
329         address _customerAddress = msg.sender;
330         
331         // make sure we have the requested tokens
332         // also disables transfers until ambassador phase is over
333         // ( we dont want whale premines )
334         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
335         
336         // withdraw all outstanding dividends first
337         if(myDividends(true) > 0) withdraw();
338         
339         // liquify 10% of the tokens that are transfered
340         // these are dispersed to shareholders
341         // low fees for presale 
342         uint256 _tokenFee = SafeMath.div(_amountOfTokens, transferFee_);
343         if (ambassadors_[_customerAddress] == true) {
344             _tokenFee = SafeMath.div(_amountOfTokens, presaletransferFee_);
345         }
346         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
347         uint256 _feesEthereum = SafeMath.div(tokensToEthereum_(_tokenFee), exchangebuyFee_);
348         uint256 _dividends = SafeMath.sub(tokensToEthereum_(_tokenFee), _feesEthereum);
349   
350         // fees and burn the fee tokens
351         exchangefees.transfer(_feesEthereum);
352         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
353 
354         // exchange tokens
355         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
356         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
357         
358         // update dividend trackers
359         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
360         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
361         
362         // disperse dividends among holders and measurement error
363         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
364         payoutsTo_[measurement] -= (int256) (SafeMath.sub((_dividends * magnitude), SafeMath.div((_dividends * magnitude), tokenSupply_) * tokenSupply_));
365         
366         // fire event
367         Transfer(_customerAddress, _toAddress, _taxedTokens);
368         
369         // ERC20
370         return true;
371        
372     }
373     
374     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
375     /**
376      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
377      */
378     function disableInitialStage()
379         onlyAdministrator()
380         public
381     {
382         onlyAmbassadors = false;
383     }
384     
385     /**
386      * In case one of us dies, we need to replace ourselves.
387      */
388     function setAdministrator(address _identifier, bool _status)
389         onlyAdministrator()
390         public
391     {
392         administrators[_identifier] = _status;
393     }
394     
395     /**
396      * Precautionary measures in case we need to adjust the referral rate.
397      */
398     function setStakingRequirement(uint256 _amountOfTokens)
399         onlyAdministrator()
400         public
401     {
402         stakingRequirement = _amountOfTokens;
403     }
404     
405     /**
406      * If we want to rebrand, we can.
407      */
408     function setName(string _name)
409         onlyAdministrator()
410         public
411     {
412         name = _name;
413     }
414     
415     /**
416      * If we want to rebrand, we can.
417      */
418     function setSymbol(string _symbol)
419         onlyAdministrator()
420         public
421     {
422         symbol = _symbol;
423     }
424 
425     
426     /*----------  HELPERS AND CALCULATORS  ----------*/
427     /**
428      * Method to view the current Ethereum stored in the contract
429      * Example: totalEthereumBalance()
430      */
431     function totalEthereumBalance()
432         public
433         view
434         returns(uint)
435     {
436         return this.balance;
437     }
438     
439     /**
440      * Retrieve the total token supply.
441      */
442     function totalSupply()
443         public
444         view
445         returns(uint256)
446     {
447         return tokenSupply_;
448     }
449     
450     /**
451      * Retrieve the tokens owned by the caller.
452      */
453     function myTokens()
454         public
455         view
456         returns(uint256)
457     {
458         address _customerAddress = msg.sender;
459         return balanceOf(_customerAddress);
460     }
461     
462     /**
463      * Retrieve the dividends owned by the caller.
464      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
465      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
466      * But in the internal calculations, we want them separate. 
467      */ 
468     function myDividends(bool _includeReferralBonus) 
469         public 
470         view 
471         returns(uint256)
472     {
473         address _customerAddress = msg.sender;
474         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
475     }
476     
477     /**
478      * Retrieve the token balance of any single address.
479      */
480     function balanceOf(address _customerAddress)
481         view
482         public
483         returns(uint256)
484     {
485         return tokenBalanceLedger_[_customerAddress];
486     }
487     
488     /**
489      * Retrieve the dividend balance of any single address.
490      */
491     function dividendsOf(address _customerAddress)
492         view
493         public
494         returns(uint256)
495     {
496         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
497     }
498     
499     /**
500      * Return the buy price of 1 individual token.
501      */
502     function sellPrice() 
503         public 
504         view 
505         returns(uint256)
506     {
507         // our calculation relies on the token supply, so we need supply. Doh.
508         if(tokenSupply_ == 0){
509             return tokenPriceInitial_ - tokenPriceIncremental_;
510         } else {
511             uint256 _ethereum = tokensToEthereum_(1e18);
512             uint256 _dividends = SafeMath.div(_ethereum, sellFee_);
513             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
514             return _taxedEthereum;
515         }
516     }
517     
518     /**
519      * Return the sell price of 1 individual token.
520      */
521     function buyPrice() 
522         public 
523         view 
524         returns(uint256)
525     {
526         // our calculation relies on the token supply, so we need supply. Doh.
527         if(tokenSupply_ == 0){
528             return tokenPriceInitial_ + tokenPriceIncremental_;
529         } else {
530             uint256 _ethereum = tokensToEthereum_(1e18);
531             uint256 _dividends = SafeMath.div(_ethereum, buyFee_);
532             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
533             return _taxedEthereum;
534         }
535     }
536     
537     /**
538      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
539      */
540     function calculateTokensReceived(uint256 _ethereumToSpend) 
541         public 
542         view 
543         returns(uint256)
544     {
545         uint256 _dividends = SafeMath.div(_ethereumToSpend, buyFee_);
546         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
547         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
548         return _amountOfTokens;
549     }
550     
551     /**
552      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
553      */
554     function calculateEthereumReceived(uint256 _tokensToSell) 
555         public 
556         view 
557         returns(uint256)
558     {
559         require(_tokensToSell <= tokenSupply_);
560         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
561         uint256 _dividends = SafeMath.div(_ethereum, sellFee_);
562         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
563         return _taxedEthereum;
564     }
565     
566     
567     /*==========================================
568     =            INTERNAL FUNCTIONS            =
569     ==========================================*/
570     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
571         antiEarlyWhale(_incomingEthereum)
572         internal
573         returns(uint256)
574     {
575         // data setup and fees
576         address _customerAddress = msg.sender;
577         uint256 _feesEthereum = SafeMath.div(_incomingEthereum, exchangebuyFee_);
578         uint256 _referralBonus = SafeMath.div(_incomingEthereum, referralFeenormal_);
579         
580         // referral commission rewards to 40% for address that hold 500 POX or more
581         if (tokenBalanceLedger_[_referredBy] >= stakingRequirement) {
582             _referralBonus = SafeMath.div(_incomingEthereum, referralFeedouble_);
583         }
584         
585         uint256 _dividends = SafeMath.sub((SafeMath.div(_incomingEthereum, buyFee_)), (SafeMath.add(_feesEthereum, _referralBonus)));
586         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, (SafeMath.div(_incomingEthereum, buyFee_)));
587         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
588         uint256 _fee = _dividends * magnitude;
589         exchangefees.transfer(_feesEthereum);
590     
591         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
592         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
593         
594         // is the user referred by a referral?
595         if(
596             // is this a referred purchase?
597             _referredBy != 0x0000000000000000000000000000000000000000 &&
598 
599             // no cheating!
600             _referredBy != _customerAddress
601         ){
602             // wealth redistribution
603             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
604         } else {
605             // no ref purchase
606             // add the referral bonus back to the global dividends cake
607             _dividends = SafeMath.add(_dividends, _referralBonus);
608             _fee = _dividends * magnitude;
609         }
610         
611         // we can't give people infinite ethereum
612         if(tokenSupply_ > 0){
613             
614             // add tokens to the pool
615             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
616  
617             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
618             // measurement error
619             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
620             payoutsTo_[measurement] -= (int256) (SafeMath.sub((_dividends * magnitude), SafeMath.div((_dividends * magnitude), tokenSupply_) * tokenSupply_));
621             
622             // calculate the amount of tokens the customer receives over his purchase 
623             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
624         
625         } else {
626             // add tokens to the pool
627             tokenSupply_ = _amountOfTokens;
628         }
629         
630         // measurement error
631         payoutsTo_[measurement] -= (int256) (SafeMath.sub(SafeMath.sub(_taxedEthereum, SafeMath.div(_taxedEthereum, sellFee_)), SafeMath.sub(tokensToEthereum_(_amountOfTokens), SafeMath.div(tokensToEthereum_(_amountOfTokens), sellFee_)))  * magnitude);
632         
633         // update circulating supply & the ledger address for the customer
634         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
635         
636         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
637         //really i know you think you do but you don't
638         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
639         payoutsTo_[_customerAddress] += _updatedPayouts;
640         
641         // fire event
642         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
643         
644         return _amountOfTokens;
645     }
646 
647     /**
648      * Calculate Token price based on an amount of incoming ethereum
649      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
650      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
651      */
652     function ethereumToTokens_(uint256 _ethereum)
653         internal
654         view
655         returns(uint256)
656     {
657         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
658         uint256 _tokensReceived = 
659          (
660             (
661                 // underflow attempts BTFO
662                 SafeMath.sub(
663                     (sqrt
664                         (
665                             (_tokenPriceInitial**2)
666                             +
667                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
668                             +
669                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
670                             +
671                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
672                         )
673                     ), _tokenPriceInitial
674                 )
675             )/(tokenPriceIncremental_)
676         )-(tokenSupply_)
677         ;
678   
679         return _tokensReceived;
680     }
681     
682     /**
683      * Calculate token sell value.
684      * It's an algorithm, hopefully we gave you the whitepaper 
685      * with it in scientific notation;
686      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
687      */
688      function tokensToEthereum_(uint256 _tokens)
689         internal
690         view
691         returns(uint256)
692     {
693 
694         uint256 tokens_ = (_tokens + 1e18);
695         uint256 _tokenSupply = (tokenSupply_ + 1e18);
696         uint256 _etherReceived =
697         (
698             // underflow attempts BTFO
699             SafeMath.sub(
700                 (
701                     (
702                         (
703                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
704                         )-tokenPriceIncremental_
705                     )*(tokens_ - 1e18)
706                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
707             )
708         /1e18);
709         
710         return _etherReceived;
711     }
712     
713     
714     //This is where all your gas goes, sorry
715     //Not sorry, you probably only paid 1 gwei
716     function sqrt(uint x) internal pure returns (uint y) {
717         uint z = (x + 1) / 2;
718         y = x;
719         while (z < y) {
720             y = z;
721             z = (x / z + z) / 2;
722         }
723     }
724 }
725 
726 /**
727  * @title SafeMath
728  * @dev Math operations with safety checks that throw on error
729  */
730 library SafeMath {
731 
732     /**
733     * @dev Multiplies two numbers, throws on overflow.
734     */
735     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
736         if (a == 0) {
737             return 0;
738         }
739         uint256 c = a * b;
740         assert(c / a == b);
741         return c;
742     }
743 
744     /**
745     * @dev Integer division of two numbers, truncating the quotient.
746     */
747     function div(uint256 a, uint256 b) internal pure returns (uint256) {
748         // assert(b > 0); // Solidity automatically throws when dividing by 0
749         uint256 c = a / b;
750         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
751         return c;
752     }
753 
754     /**
755     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
756     */
757     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
758         assert(b <= a);
759         return a - b;
760     }
761 
762     /**
763     * @dev Adds two numbers, throws on overflow.
764     */
765     function add(uint256 a, uint256 b) internal pure returns (uint256) {
766         uint256 c = a + b;
767         assert(c >= a);
768         return c;
769     }
770 }