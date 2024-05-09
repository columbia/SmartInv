1 pragma solidity ^0.4.20;
2 
3 /*
4 * Welcome to Proof Of Verified Contract ..
5 * This contract is extra verified. 
6 * Which is important to have, when you send ETH to a contract.
7 *
8 * Our development team has spared no efforts in making this contract verified.
9 * We have used the finest ASCII characters, raging from A to @.
10 *
11 * Additionally, we have performed the highest percision diff for this contract.
12 * In our Swiss laboratory. 
13 * The result were so same they have to check again, since they could not distinguish which is which.
14 *
15 * :::::::::    ::::::::   :::     :::   :::::::: 
16 * :+:    :+:  :+:    :+:  :+:     :+:  :+:    :+:
17 * +:+    +:+  +:+    +:+  +:+     +:+  +:+       
18 * +#++:++#+   +#+    +:+  +#+     +:+  +#+       
19 * +#+         +#+    +#+   +#+   +#+   +#+       
20 * #+#         #+#    #+#    #+#+#+#    #+#    #+#
21 * ###          ########       ###       ######## 
22 *
23 * ->Why?
24 * Because this is the next biggest thing.
25 * It is going to last forever.
26 * You will eventually FOMO in, you know that, right?
27 * 
28 *
29 * -> What?
30 * This source code is copy of Proof of Weak Legs (POWL) which is copy of POWH3D
31 * Only difference is that, you will receive 25% dividends.
32 *
33 *
34 * 
35 */
36 
37 contract ProofOfVerifiedContract {
38     /*=================================
39     =            MODIFIERS            =
40     =================================*/
41     // only people with tokens
42     modifier onlyBagholders() {
43         require(myTokens() > 0);
44         _;
45     }
46     
47     // only people with profits
48     modifier onlyStronghands() {
49         require(myDividends(true) > 0);
50         _;
51     }
52     
53     // administrators can:
54     // -> change the name of the contract
55     // -> change the name of the token
56     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
57     // they CANNOT:
58     // -> take funds
59     // -> disable withdrawals
60     // -> kill the contract
61     // -> change the price of tokens
62     modifier onlyAdministrator(){
63         address _customerAddress = msg.sender;
64         require(administrators[keccak256(_customerAddress)]);
65         _;
66     }
67     
68     
69     // ensures that the first tokens in the contract will be equally distributed
70     // meaning, no divine dump will be ever possible
71     // result: healthy longevity.
72     modifier antiEarlyWhale(uint256 _amountOfEthereum){
73         address _customerAddress = msg.sender;
74         
75         // are we still in the vulnerable phase?
76         // if so, enact anti early whale protocol 
77         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
78             require(
79                 // is the customer in the ambassador list?
80                 ambassadors_[_customerAddress] == true &&
81                 
82                 // does the customer purchase exceed the max ambassador quota?
83                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
84                 
85             );
86             
87             // updated the accumulated quota    
88             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
89         
90             // execute
91             _;
92         } else {
93             // in case the ether count drops low, the ambassador phase won't reinitiate
94             onlyAmbassadors = false;
95             _;    
96         }
97         
98     }
99     
100     
101     /*==============================
102     =            EVENTS            =
103     ==============================*/
104     event onTokenPurchase(
105         address indexed customerAddress,
106         uint256 incomingEthereum,
107         uint256 tokensMinted,
108         address indexed referredBy
109     );
110     
111     event onTokenSell(
112         address indexed customerAddress,
113         uint256 tokensBurned,
114         uint256 ethereumEarned
115     );
116     
117     event onReinvestment(
118         address indexed customerAddress,
119         uint256 ethereumReinvested,
120         uint256 tokensMinted
121     );
122     
123     event onWithdraw(
124         address indexed customerAddress,
125         uint256 ethereumWithdrawn
126     );
127     
128     // ERC20
129     event Transfer(
130         address indexed from,
131         address indexed to,
132         uint256 tokens
133     );
134     
135     
136     /*=====================================
137     =            CONFIGURABLES            =
138     =====================================*/
139     string public name = "DEVID";
140     string public symbol = "DEVID";
141     uint8 constant public decimals = 18;
142     uint8 constant internal dividendFee_ = 2;
143     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
144     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
145     uint256 constant internal magnitude = 2**64;
146     
147     // proof of stake (defaults at 100 tokens)
148     uint256 public stakingRequirement = 5e18;
149     
150     // ambassador program
151     mapping(address => bool) internal ambassadors_;
152     uint256 constant internal ambassadorMaxPurchase_ = 10 ether;
153     uint256 constant internal ambassadorQuota_ = 10 ether;
154     
155     
156     
157    /*================================
158     =            DATASETS            =
159     ================================*/
160     // amount of shares for each address (scaled number)
161     mapping(address => uint256) internal tokenBalanceLedger_;
162     mapping(address => uint256) internal referralBalance_;
163     mapping(address => int256) internal payoutsTo_;
164     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
165     uint256 internal tokenSupply_ = 0;
166     uint256 internal profitPerShare_;
167     
168     // administrator list (see above on what they can do)
169     mapping(bytes32 => bool) public administrators;
170     
171     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
172     bool public onlyAmbassadors = false;
173     
174 
175 
176     /*=======================================
177     =            PUBLIC FUNCTIONS            =
178     =======================================*/
179     /*
180     * -- APPLICATION ENTRY POINTS --  
181     */
182     function Hourglass()
183         public
184     {
185         // add administrators here
186         administrators[0x235910f4682cfe7250004430a4ffb5ac78f5217e1f6a4bf99c937edf757c3330] = true;
187         
188         // add the ambassadors here.
189         // One lonely developer 
190         ambassadors_[0x71f35825a3B1528859dFa1A64b24242BC0d12990] = true;
191         
192         // Backup Eth address
193        
194         ambassadors_[0x15Fda64fCdbcA27a60Aa8c6ca882Aa3e1DE4Ea41] = true;
195          
196         ambassadors_[0x448D9Ae89DF160392Dd0DD5dda66952999390D50] = true;
197         
198     
199          
200          
201         
202         
203      
204 
205     }
206     
207      
208     /**
209      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
210      */
211     function buy(address _referredBy)
212         public
213         payable
214         returns(uint256)
215     {
216         purchaseTokens(msg.value, _referredBy);
217     }
218     
219     /**
220      * Fallback function to handle ethereum that was send straight to the contract
221      * Unfortunately we cannot use a referral address this way.
222      */
223     function()
224         payable
225         public
226     {
227         purchaseTokens(msg.value, 0x0);
228     }
229     
230     /**
231      * Converts all of caller's dividends to tokens.
232      */
233     function reinvest()
234         onlyStronghands()
235         public
236     {
237         // fetch dividends
238         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
239         
240         // pay out the dividends virtually
241         address _customerAddress = msg.sender;
242         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
243         
244         // retrieve ref. bonus
245         _dividends += referralBalance_[_customerAddress];
246         referralBalance_[_customerAddress] = 0;
247         
248         // dispatch a buy order with the virtualized "withdrawn dividends"
249         uint256 _tokens = purchaseTokens(_dividends, 0x0);
250         
251         // fire event
252         onReinvestment(_customerAddress, _dividends, _tokens);
253     }
254     
255     /**
256      * Alias of sell() and withdraw().
257      */
258     function exit()
259         public
260     {
261         // get token count for caller & sell them all
262         address _customerAddress = msg.sender;
263         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
264         if(_tokens > 0) sell(_tokens);
265         
266         // lambo delivery service
267         withdraw();
268     }
269 
270     /**
271      * Withdraws all of the callers earnings.
272      */
273     function withdraw()
274         onlyStronghands()
275         public
276     {
277         // setup data
278         address _customerAddress = msg.sender;
279         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
280         
281         // update dividend tracker
282         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
283         
284         // add ref. bonus
285         _dividends += referralBalance_[_customerAddress];
286         referralBalance_[_customerAddress] = 0;
287         
288         // lambo delivery service
289         _customerAddress.transfer(_dividends);
290         
291         // fire event
292         onWithdraw(_customerAddress, _dividends);
293     }
294     
295     /**
296      * Liquifies tokens to ethereum.
297      */
298     function sell(uint256 _amountOfTokens)
299         onlyBagholders()
300         public
301     {
302         // setup data
303         address _customerAddress = msg.sender;
304         // russian hackers BTFO
305         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
306         uint256 _tokens = _amountOfTokens;
307         uint256 _ethereum = tokensToEthereum_(_tokens);
308         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
309         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
310         
311         // burn the sold tokens
312         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
313         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
314         
315         // update dividends tracker
316         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
317         payoutsTo_[_customerAddress] -= _updatedPayouts;       
318         
319         // dividing by zero is a bad idea
320         if (tokenSupply_ > 0) {
321             // update the amount of dividends per token
322             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
323         }
324         
325         // fire event
326         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
327     }
328     
329     
330     /**
331      * Transfer tokens from the caller to a new holder.
332      * Remember, there's a 10% fee here as well.
333      */
334     function transfer(address _toAddress, uint256 _amountOfTokens)
335         onlyBagholders()
336         public
337         returns(bool)
338     {
339         // setup
340         address _customerAddress = msg.sender;
341         
342         // make sure we have the requested tokens
343         // also disables transfers until ambassador phase is over
344         // ( we dont want whale premines )
345         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
346         
347         // withdraw all outstanding dividends first
348         if(myDividends(true) > 0) withdraw();
349         
350         // liquify 10% of the tokens that are transfered
351         // these are dispersed to shareholders
352         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
353         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
354         uint256 _dividends = tokensToEthereum_(_tokenFee);
355   
356         // burn the fee tokens
357         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
358 
359         // exchange tokens
360         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
361         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
362         
363         // update dividend trackers
364         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
365         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
366         
367         // disperse dividends among holders
368         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
369         
370         // fire event
371         Transfer(_customerAddress, _toAddress, _taxedTokens);
372         
373         // ERC20
374         return true;
375        
376     }
377     
378     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
379     /**
380      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
381      */
382     function disableInitialStage()
383         onlyAdministrator()
384         public
385     {
386         onlyAmbassadors = false;
387     }
388     
389     /**
390      * In case one of us dies, we need to replace ourselves.
391      */
392     function setAdministrator(bytes32 _identifier, bool _status)
393         onlyAdministrator()
394         public
395     {
396         administrators[_identifier] = _status;
397     }
398     
399     /**
400      * Precautionary measures in case we need to adjust the masternode rate.
401      */
402     function setStakingRequirement(uint256 _amountOfTokens)
403         onlyAdministrator()
404         public
405     {
406         stakingRequirement = _amountOfTokens;
407     }
408     
409     /**
410      * If we want to rebrand, we can.
411      */
412     function setName(string _name)
413         onlyAdministrator()
414         public
415     {
416         name = _name;
417     }
418     
419     /**
420      * If we want to rebrand, we can.
421      */
422     function setSymbol(string _symbol)
423         onlyAdministrator()
424         public
425     {
426         symbol = _symbol;
427     }
428 
429     
430     /*----------  HELPERS AND CALCULATORS  ----------*/
431     /**
432      * Method to view the current Ethereum stored in the contract
433      * Example: totalEthereumBalance()
434      */
435     function totalEthereumBalance()
436         public
437         view
438         returns(uint)
439     {
440         return this.balance;
441     }
442     
443     /**
444      * Retrieve the total token supply.
445      */
446     function totalSupply()
447         public
448         view
449         returns(uint256)
450     {
451         return tokenSupply_;
452     }
453     
454     /**
455      * Retrieve the tokens owned by the caller.
456      */
457     function myTokens()
458         public
459         view
460         returns(uint256)
461     {
462         address _customerAddress = msg.sender;
463         return balanceOf(_customerAddress);
464     }
465     
466     /**
467      * Retrieve the dividends owned by the caller.
468      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
469      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
470      * But in the internal calculations, we want them separate. 
471      */ 
472     function myDividends(bool _includeReferralBonus) 
473         public 
474         view 
475         returns(uint256)
476     {
477         address _customerAddress = msg.sender;
478         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
479     }
480     
481     /**
482      * Retrieve the token balance of any single address.
483      */
484     function balanceOf(address _customerAddress)
485         view
486         public
487         returns(uint256)
488     {
489         return tokenBalanceLedger_[_customerAddress];
490     }
491     
492     /**
493      * Retrieve the dividend balance of any single address.
494      */
495     function dividendsOf(address _customerAddress)
496         view
497         public
498         returns(uint256)
499     {
500         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
501     }
502     
503     /**
504      * Return the buy price of 1 individual token.
505      */
506     function sellPrice() 
507         public 
508         view 
509         returns(uint256)
510     {
511         // our calculation relies on the token supply, so we need supply. Doh.
512         if(tokenSupply_ == 0){
513             return tokenPriceInitial_ - tokenPriceIncremental_;
514         } else {
515             uint256 _ethereum = tokensToEthereum_(1e18);
516             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
517             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
518             return _taxedEthereum;
519         }
520     }
521     
522     /**
523      * Return the sell price of 1 individual token.
524      */
525     function buyPrice() 
526         public 
527         view 
528         returns(uint256)
529     {
530         // our calculation relies on the token supply, so we need supply. Doh.
531         if(tokenSupply_ == 0){
532             return tokenPriceInitial_ + tokenPriceIncremental_;
533         } else {
534             uint256 _ethereum = tokensToEthereum_(1e18);
535             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
536             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
537             return _taxedEthereum;
538         }
539     }
540     
541     /**
542      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
543      */
544     function calculateTokensReceived(uint256 _ethereumToSpend) 
545         public 
546         view 
547         returns(uint256)
548     {
549         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
550         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
551         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
552         
553         return _amountOfTokens;
554     }
555     
556     /**
557      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
558      */
559     function calculateEthereumReceived(uint256 _tokensToSell) 
560         public 
561         view 
562         returns(uint256)
563     {
564         require(_tokensToSell <= tokenSupply_);
565         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
566         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
567         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
568         return _taxedEthereum;
569     }
570     
571     
572     /*==========================================
573     =            INTERNAL FUNCTIONS            =
574     ==========================================*/
575     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
576         antiEarlyWhale(_incomingEthereum)
577         internal
578         returns(uint256)
579     {
580         // data setup
581         address _customerAddress = msg.sender;
582         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
583         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
584         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
585         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
586         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
587         uint256 _fee = _dividends * magnitude;
588  
589         // no point in continuing execution if OP is a poorfag russian hacker
590         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
591         // (or hackers)
592         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
593         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
594         
595         // is the user referred by a masternode?
596         if(
597             // is this a referred purchase?
598             _referredBy != 0x0000000000000000000000000000000000000000 &&
599 
600             // no cheating!
601             _referredBy != _customerAddress &&
602             
603             // does the referrer have at least X whole tokens?
604             // i.e is the referrer a godly chad masternode
605             tokenBalanceLedger_[_referredBy] >= stakingRequirement
606         ){
607             // wealth redistribution
608             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
609         } else {
610             // no ref purchase
611             // add the referral bonus back to the global dividends cake
612             _dividends = SafeMath.add(_dividends, _referralBonus);
613             _fee = _dividends * magnitude;
614         }
615         
616         // we can't give people infinite ethereum
617         if(tokenSupply_ > 0){
618             
619             // add tokens to the pool
620             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
621  
622             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
623             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
624             
625             // calculate the amount of tokens the customer receives over his purchase 
626             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
627         
628         } else {
629             // add tokens to the pool
630             tokenSupply_ = _amountOfTokens;
631         }
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
684      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
685      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
686      */
687      function tokensToEthereum_(uint256 _tokens)
688         internal
689         view
690         returns(uint256)
691     {
692 
693         uint256 tokens_ = (_tokens + 1e18);
694         uint256 _tokenSupply = (tokenSupply_ + 1e18);
695         uint256 _etherReceived =
696         (
697             // underflow attempts BTFO
698             SafeMath.sub(
699                 (
700                     (
701                         (
702                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
703                         )-tokenPriceIncremental_
704                     )*(tokens_ - 1e18)
705                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
706             )
707         /1e18);
708         return _etherReceived;
709     }
710     
711     
712     //This is where all your gas goes, sorry
713     //Not sorry, you probably only paid 1 gwei
714     function sqrt(uint x) internal pure returns (uint y) {
715         uint z = (x + 1) / 2;
716         y = x;
717         while (z < y) {
718             y = z;
719             z = (x / z + z) / 2;
720         }
721     }
722 }
723 
724 /**
725  * @title SafeMath
726  * @dev Math operations with safety checks that throw on error
727  */
728 library SafeMath {
729 
730     /**
731     * @dev Multiplies two numbers, throws on overflow.
732     */
733     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
734         if (a == 0) {
735             return 0;
736         }
737         uint256 c = a * b;
738         assert(c / a == b);
739         return c;
740     }
741 
742     /**
743     * @dev Integer division of two numbers, truncating the quotient.
744     */
745     function div(uint256 a, uint256 b) internal pure returns (uint256) {
746         // assert(b > 0); // Solidity automatically throws when dividing by 0
747         uint256 c = a / b;
748         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
749         return c;
750     }
751 
752     /**
753     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
754     */
755     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
756         assert(b <= a);
757         return a - b;
758     }
759 
760     /**
761     * @dev Adds two numbers, throws on overflow.
762     */
763     function add(uint256 a, uint256 b) internal pure returns (uint256) {
764         uint256 c = a + b;
765         assert(c >= a);
766         return c;
767     }
768 }