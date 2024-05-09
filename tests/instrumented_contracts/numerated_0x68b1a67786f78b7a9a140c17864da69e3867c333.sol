1 pragma solidity ^0.4.20;
2 
3 /*
4 * 
5 * PyrGressive
6 *
7 * -> What?
8 * Based on the POWH3D contract but with these improvements:
9 * [x] Now with a Progressive Jackpot which increases with every Buy and Reinvest!
10 * [x] Jackpot is won randomly by Buyers and Reinvestors!
11 * [X] Jackpot is built up with 25% of every Buy-in and Reinvest DIV Fee.
12 * [x] 25% DIVs
13 * [x] Master Nodes get 25% of each DIV fee.
14 *
15 *
16 */
17 
18 contract Pyrgressive {
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
34     // administrators can:
35     // -> change the name of the contract
36     // -> change the name of the token
37     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
38     // they CANNOT:
39     // -> take funds
40     // -> disable withdrawals
41     // -> kill the contract
42     // -> change the price of tokens
43     modifier onlyAdministrator(){
44         address _customerAddress = msg.sender;
45         require(administrators[_customerAddress]);
46         _;
47     }
48     
49     
50     // ensures that the first tokens in the contract will be equally distributed
51     // meaning, no divine dump will be ever possible
52     // result: healthy longevity.
53     modifier antiEarlyWhale(uint256 _amountOfEthereum){
54         address _customerAddress = msg.sender;
55         
56         // are we still in the vulnerable phase?
57         // if so, enact anti early whale protocol 
58         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
59             require(
60                 // is the customer in the ambassador list?
61                 ambassadors_[_customerAddress] == true &&
62                 
63                 // does the customer purchase exceed the max ambassador quota?
64                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
65                 
66             );
67             
68             // updated the accumulated quota    
69             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
70         
71             // execute
72             _;
73         } else {
74             // in case the ether count drops low, the ambassador phase won't reinitiate
75             onlyAmbassadors = false;
76             _;    
77         }
78         
79     }
80     
81     
82     /*==============================
83     =            EVENTS            =
84     ==============================*/
85     event onTokenPurchase(
86         address indexed customerAddress,
87         uint256 incomingEthereum,
88         uint256 tokensMinted,
89         address indexed referredBy
90     );
91     
92     event onTokenSell(
93         address indexed customerAddress,
94         uint256 tokensBurned,
95         uint256 ethereumEarned
96     );
97     
98     event onReinvestment(
99         address indexed customerAddress,
100         uint256 ethereumReinvested,
101         uint256 tokensMinted
102     );
103     
104     event onWithdraw(                               //Announce a Jackpot Win
105         address indexed customerAddress,
106         uint256 ethereumWithdrawn
107     );
108 
109      event onWin(
110         address indexed customerAddress,
111         uint256 ethereumWon
112     );
113     
114     // ERC20
115     event Transfer(
116         address indexed from,
117         address indexed to,
118         uint256 tokens
119     );
120     
121     
122     /*=====================================
123     =            CONFIGURABLES            =
124     =====================================*/
125     string public name = "PyrGressive";
126     string public symbol = "PYRS";
127     uint8 constant public decimals = 18;
128     uint8 constant internal dividendFee_ = 4;              //FEE DIVISOR set to 4 for 25% DIV
129     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
130     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
131     uint256 constant internal magnitude = 2**64;
132     
133     // proof of stake (defaults at 100 tokens)
134     uint256 public stakingRequirement = 100e18;
135     
136     // ambassador program
137     mapping(address => bool) internal ambassadors_;
138     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
139     uint256 constant internal ambassadorQuota_ = 20 ether;
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
154     uint256 internal jackpot_ = 0;
155     
156     // administrator list (see above on what they can do)
157     mapping(address => bool) public administrators;
158     
159     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
160     bool public onlyAmbassadors = true;
161     
162     address Master;
163 
164     uint256 jackpotThreshold;
165 
166     uint jackpotFactor = 250;
167 
168     uint256 jackpotCounter = 0;
169 
170     address lastWinner = 0x0000000000000000000000000000000000000000;
171 
172 
173     /*=======================================
174     =            PUBLIC FUNCTIONS            =
175     =======================================*/
176     /*
177     * -- APPLICATION ENTRY POINTS --  
178     */
179     function Pyrgressive()
180         public
181     {
182         // add administrators here
183         administrators[msg.sender] = true;
184 
185         Master = msg.sender;
186 
187         onlyAmbassadors = false;
188    
189         jackpotThreshold = random() * 1e15 * jackpotFactor;       
190         
191 
192     }
193     
194      
195     /**
196      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
197      */
198     function buy(address _referredBy)
199         public
200         payable
201         returns(uint256)
202     {
203         purchaseTokens(msg.value, _referredBy);
204         
205     }
206     
207     /**
208      * Fallback function to handle ethereum that was send straight to the contract
209      * Unfortunately we cannot use a referral address this way.
210      */
211     function()
212         payable
213         public
214     {
215         purchaseTokens(msg.value, 0x0);
216     }
217     
218     /**
219      * Converts all of caller's dividends to tokens.
220      */
221     function reinvest()
222         onlyStronghands()
223         public
224     {
225         // fetch dividends
226         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
227         
228         // pay out the dividends virtually
229         address _customerAddress = msg.sender;
230         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
231         
232         // retrieve ref. bonus
233         _dividends += referralBalance_[_customerAddress];
234         referralBalance_[_customerAddress] = 0;
235         
236         // dispatch a buy order with the virtualized "withdrawn dividends"
237         uint256 _tokens = purchaseTokens(_dividends, 0x0);
238         
239         // fire event
240         onReinvestment(_customerAddress, _dividends, _tokens);
241     }
242     
243     /**
244      * Alias of sell() and withdraw().
245      */
246     function exit()
247         public
248     {
249         // get token count for caller & sell them all
250         address _customerAddress = msg.sender;
251         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
252         if(_tokens > 0) sell(_tokens);
253         
254         // lambo delivery service
255         withdraw();
256     }
257 
258     /**
259      * Withdraws all of the callers earnings.
260      */
261     function withdraw()
262         onlyStronghands()
263         public
264     {
265         // setup data
266         address _customerAddress = msg.sender;
267         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
268         
269         // update dividend tracker
270         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
271         
272         // add ref. bonus
273         _dividends += referralBalance_[_customerAddress];
274         referralBalance_[_customerAddress] = 0;
275         
276         // lambo delivery service
277         _customerAddress.transfer(_dividends);
278         
279         // fire event
280         onWithdraw(_customerAddress, _dividends);
281     }
282     
283     /**
284      * Liquifies tokens to ethereum.
285      */
286     function sell(uint256 _amountOfTokens)
287         onlyBagholders()
288         public
289     {
290         // setup data
291         address _customerAddress = msg.sender;
292         // russian hackers BTFO
293         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
294         uint256 _tokens = _amountOfTokens;
295         uint256 _ethereum = tokensToEthereum_(_tokens);
296         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
297         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
298         
299         // burn the sold tokens
300         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
301         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
302         
303         // update dividends tracker
304         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
305         payoutsTo_[_customerAddress] -= _updatedPayouts;       
306         
307         // dividing by zero is a bad idea
308         if (tokenSupply_ > 0) {
309             // update the amount of dividends per token
310             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
311         }
312         
313         // fire event
314         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
315     }
316     
317     
318     /**
319      * Transfer tokens from the caller to a new holder.
320      * Remember, there's a 10% fee here as well.
321      */
322     function transfer(address _toAddress, uint256 _amountOfTokens)
323         onlyBagholders()
324         public
325         returns(bool)
326     {
327         // setup
328         address _customerAddress = msg.sender;
329         
330         // make sure we have the requested tokens
331         // also disables transfers until ambassador phase is over
332         // ( we dont want whale premines )
333         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
334         
335         // withdraw all outstanding dividends first
336         if(myDividends(true) > 0) withdraw();
337         
338         // liquify 10% of the tokens that are transfered
339         // these are dispersed to shareholders
340         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
341         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
342         uint256 _dividends = tokensToEthereum_(_tokenFee);
343   
344         // burn the fee tokens
345         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
346 
347         // exchange tokens
348         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
349         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
350         
351         // update dividend trackers
352         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
353         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
354         
355         // disperse dividends among holders
356         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
357         
358         // fire event
359         Transfer(_customerAddress, _toAddress, _taxedTokens);
360         
361         // ERC20
362         return true;
363        
364     }
365     
366     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
367     /**
368      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
369      */
370     function disableInitialStage()
371         onlyAdministrator()
372         public
373     {
374         onlyAmbassadors = false;
375     }
376     
377     /**
378      * In case one of us dies, we need to replace ourselves.
379      */
380     function setAdministrator(address _identifier, bool _status)
381         onlyAdministrator()
382         public
383     {
384         administrators[_identifier] = _status;
385     }
386     
387     /**
388      * Precautionary measures in case we need to adjust the masternode rate.
389      */
390     function setStakingRequirement(uint256 _amountOfTokens)
391         onlyAdministrator()
392         public
393     {
394         stakingRequirement = _amountOfTokens;
395     }
396     
397     /**
398      * If we want to rebrand, we can.
399      */
400     function setName(string _name)
401         onlyAdministrator()
402         public
403     {
404         name = _name;
405     }
406 
407     /**
408      * Set the JackpotFactpr
409      */
410     function setJackpotFactor(uint _factor)
411         onlyAdministrator()
412         public
413     {
414         jackpotFactor = _factor;
415     }
416     
417     /**
418      * If we want to rebrand, we can.
419      */
420     function setSymbol(string _symbol)
421         onlyAdministrator()
422         public
423     {
424         symbol = _symbol;
425     }
426 
427     
428     /*----------  HELPERS AND CALCULATORS  ----------*/
429     /**
430      * Method to view the current Ethereum stored in the contract
431      * Example: totalEthereumBalance()
432      */
433     function totalEthereumBalance()
434         public
435         view
436         returns(uint)
437     {
438         return this.balance;
439     }
440     
441     /**
442      * Retrieve the total token supply.
443      */
444     function totalSupply()
445         public
446         view
447         returns(uint256)
448     {
449         return tokenSupply_;
450     }
451     
452     /**
453      * Retrieve the tokens owned by the caller.
454      */
455     function myTokens()
456         public
457         view
458         returns(uint256)
459     {
460         address _customerAddress = msg.sender;
461         return balanceOf(_customerAddress);
462     }
463     
464     /**
465      * Retrieve the dividends owned by the caller.
466      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
467      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
468      * But in the internal calculations, we want them separate. 
469      */ 
470     function myDividends(bool _includeReferralBonus) 
471         public 
472         view 
473         returns(uint256)
474     {
475         address _customerAddress = msg.sender;
476         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
477     }
478     
479     /**
480      * Retrieve the token balance of any single address.
481      */
482     function balanceOf(address _customerAddress)
483         view
484         public
485         returns(uint256)
486     {
487         return tokenBalanceLedger_[_customerAddress];
488     }
489 
490    /**
491      * Retrieve the jackpot amount.
492      */
493     function jackpot()
494         public
495         view
496         returns(uint256)
497     {
498         return jackpot_;
499     }
500 
501      /**
502      * Retrieve last winner address.
503      */
504     function getLastWinner()
505         public
506         view
507         returns(address)
508     {
509         return lastWinner;
510     }
511 
512     
513     /**
514      * Retrieve the dividend balance of any single address.
515      */
516     function dividendsOf(address _customerAddress)
517         view
518         public
519         returns(uint256)
520     {
521         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
522     }
523     
524     /**
525      * Return the buy price of 1 individual token.
526      */
527     function sellPrice() 
528         public 
529         view 
530         returns(uint256)
531     {
532         // our calculation relies on the token supply, so we need supply. Doh.
533         if(tokenSupply_ == 0){
534             return tokenPriceInitial_ - tokenPriceIncremental_;
535         } else {
536             uint256 _ethereum = tokensToEthereum_(1e18);
537             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
538             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
539             return _taxedEthereum;
540         }
541     }
542     
543     /**
544      * Return the sell price of 1 individual token.
545      */
546     function buyPrice() 
547         public 
548         view 
549         returns(uint256)
550     {
551         // our calculation relies on the token supply, so we need supply. Doh.
552         if(tokenSupply_ == 0){
553             return tokenPriceInitial_ + tokenPriceIncremental_;
554         } else {
555             uint256 _ethereum = tokensToEthereum_(1e18);
556             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
557             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
558             return _taxedEthereum;
559         }
560     }
561     
562     /**
563      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
564      */
565     function calculateTokensReceived(uint256 _ethereumToSpend) 
566         public 
567         view 
568         returns(uint256)
569     {
570         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
571         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
572         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
573         
574         return _amountOfTokens;
575     }
576     
577     /**
578      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
579      */
580     function calculateEthereumReceived(uint256 _tokensToSell) 
581         public 
582         view 
583         returns(uint256)
584     {
585         require(_tokensToSell <= tokenSupply_);
586         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
587         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
588         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
589         return _taxedEthereum;
590     }
591     
592     
593     /*==========================================
594     =            INTERNAL FUNCTIONS            =
595     ==========================================*/
596 
597     
598     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
599         antiEarlyWhale(_incomingEthereum)
600         internal
601         returns(uint256)
602     {
603         // data setup
604         address _customerAddress = msg.sender;
605         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
606         uint256 _referralBonus = SafeMath.div(_undividedDividends, 4);   //set divisor to 4 for 25% for referrals
607 
608         //uint256 _removeFromDiv =  SafeMath.div(_undividedDividends, 2);  //This is to remove Referral Bonus and Jackpot          
609        
610         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);        //Subtract Referral Bonus
611         _dividends = SafeMath.sub(_dividends, _referralBonus);        //Subtract Jackpot
612         
613         
614         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
615 
616         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
617 
618         //_dividends = SafeMath.sub(_dividends, _referralBonus);                          //Subtract Jackpot
619 
620         uint256 _fee = _dividends * magnitude;     
621 
622         jackpotCounter += _incomingEthereum;                
623 
624               //Remove the jackpot bonus
625  
626         // no point in continuing execution if OP is a poorfag russian hacker
627         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
628         // (or hackers)
629         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
630         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
631         
632         // is the user referred by a masternode?
633         if(
634             // is this a referred purchase?
635             _referredBy != 0x0000000000000000000000000000000000000000 &&
636 
637             // no cheating!
638             _referredBy != _customerAddress &&
639             
640             // does the referrer have at least X whole tokens?
641             // i.e is the referrer a godly chad masternode
642             tokenBalanceLedger_[_referredBy] >= stakingRequirement
643         ){
644             // wealth redistribution
645             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
646 
647             jackpot_ = SafeMath.add(jackpot_, _referralBonus);
648 
649         } else {
650             // no ref purchase
651             // 
652 
653             jackpot_ = SafeMath.add(jackpot_, _referralBonus);
654 
655             referralBalance_[Master] = SafeMath.add(referralBalance_[Master], _referralBonus);
656 
657         }
658         
659         // we can't give people infinite ethereum
660         if(tokenSupply_ > 0){
661             
662             // add tokens to the pool
663             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
664  
665             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
666             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
667             
668             // calculate the amount of tokens the customer receives over his purchase 
669             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
670         
671         } else {
672             // add tokens to the pool
673             tokenSupply_ = _amountOfTokens;
674         }
675         
676         // update circulating supply & the ledger address for the customer
677         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
678         
679         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
680         //really i know you think you do but you don't
681         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
682         payoutsTo_[_customerAddress] += _updatedPayouts;
683         
684         //uint check = checkJackpot(_customerAddress);
685         // fire event
686         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
687 
688         checkJackpot(msg.sender);
689         
690         
691         return _amountOfTokens;
692     }
693 
694 
695     function random() private view returns (uint8) {
696         return uint8(uint256(keccak256(block.timestamp, block.difficulty))%251);
697     }
698 
699 
700     function checkJackpot(address _jackpotAddress)
701         private
702         returns(uint256)
703         {
704         
705         if (jackpotCounter >= jackpotThreshold) {     
706             //WINNER
707             //Add to winner dividends
708             //Reset Jackpot
709             uint256 winnings = jackpot_;
710             //address _customerAddress = msg.sender;
711             referralBalance_[_jackpotAddress] = SafeMath.add(referralBalance_[_jackpotAddress], jackpot_);
712             jackpot_ = 0;
713             jackpotCounter = 0;
714             jackpotThreshold = random() * 1e15 * jackpotFactor;
715             lastWinner = _jackpotAddress;
716 
717             onWin(msg.sender, winnings);
718             
719             return winnings;
720         }
721         
722     }
723 
724 
725     /**
726      * Calculate Token price based on an amount of incoming ethereum
727      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
728      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
729      */
730     function ethereumToTokens_(uint256 _ethereum)
731         internal
732         view
733         returns(uint256)
734     {
735         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
736         uint256 _tokensReceived = 
737          (
738             (
739                 // underflow attempts BTFO
740                 SafeMath.sub(
741                     (sqrt
742                         (
743                             (_tokenPriceInitial**2)
744                             +
745                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
746                             +
747                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
748                             +
749                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
750                         )
751                     ), _tokenPriceInitial
752                 )
753             )/(tokenPriceIncremental_)
754         )-(tokenSupply_)
755         ;
756   
757         return _tokensReceived;
758     }
759     
760     /**
761      * Calculate token sell value.
762      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
763      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
764      */
765      function tokensToEthereum_(uint256 _tokens)
766         internal
767         view
768         returns(uint256)
769     {
770 
771         uint256 tokens_ = (_tokens + 1e18);
772         uint256 _tokenSupply = (tokenSupply_ + 1e18);
773         uint256 _etherReceived =
774         (
775             // underflow attempts BTFO
776             SafeMath.sub(
777                 (
778                     (
779                         (
780                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
781                         )-tokenPriceIncremental_
782                     )*(tokens_ - 1e18)
783                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
784             )
785         /1e18);
786         return _etherReceived;
787     }
788     
789     
790     //This is where all your gas goes, sorry
791     //Not sorry, you probably only paid 1 gwei
792     function sqrt(uint x) internal pure returns (uint y) {
793         uint z = (x + 1) / 2;
794         y = x;
795         while (z < y) {
796             y = z;
797             z = (x / z + z) / 2;
798         }
799     }
800 }
801 
802 /**
803  * @title SafeMath
804  * @dev Math operations with safety checks that throw on error
805  */
806 library SafeMath {
807 
808     /**
809     * @dev Multiplies two numbers, throws on overflow.
810     */
811     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
812         if (a == 0) {
813             return 0;
814         }
815         uint256 c = a * b;
816         assert(c / a == b);
817         return c;
818     }
819 
820     /**
821     * @dev Integer division of two numbers, truncating the quotient.
822     */
823     function div(uint256 a, uint256 b) internal pure returns (uint256) {
824         // assert(b > 0); // Solidity automatically throws when dividing by 0
825         uint256 c = a / b;
826         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
827         return c;
828     }
829 
830     /**
831     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
832     */
833     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
834         assert(b <= a);
835         return a - b;
836     }
837 
838     /**
839     * @dev Adds two numbers, throws on overflow.
840     */
841     function add(uint256 a, uint256 b) internal pure returns (uint256) {
842         uint256 c = a + b;
843         assert(c >= a);
844         return c;
845     }
846 }