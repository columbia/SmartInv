1 pragma solidity ^0.4.20;
2 
3 /*
4 * 
5 NekoToken.xyz
6 
7 * Based on the POWH3D contract but with these improvements:
8 
9 * [x] Now with a Progressive Jackpot which increases with every Buy and Reinvest!
10 
11 * [x] Jackpot is won randomly by Buyers and Reinvestors!
12 
13 * [X] Jackpot is built up with % of every Buy-in and Reinvest DIV Fee.
14 
15 * [x] 25% Divs On Buy & Sell
16 
17 * [x] Master Nodes get 25% Ref fees. You need 100 NEKO Tokens for MM. (its hidden until you have 100 Tokens)
18 
19 * [x] The First 0.5 ETH in the premine is a (KittyFund) Any eth earnt, including ref links and divs goes directly to KittyJackpot.xyz
20 
21 TEAM KITTY > JUST
22 *
23 */
24 
25 contract NekoToken {
26     /*=================================
27     =            MODIFIERS            =
28     =================================*/
29     // only people with tokens
30     modifier onlyBagholders() {
31         require(myTokens() > 0);
32         _;
33     }
34     
35     // only people with profits
36     modifier onlyStronghands() {
37         require(myDividends(true) > 0);
38         _;
39     }
40     
41     // administrators can:
42     // -> change the name of the contract
43     // -> change the name of the token
44     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
45     // they CANNOT:
46     // -> take funds
47     // -> disable withdrawals
48     // -> kill the contract
49     // -> change the price of tokens
50     modifier onlyAdministrator(){
51         address _customerAddress = msg.sender;
52         require(administrators[_customerAddress]);
53         _;
54     }
55     
56     
57     // ensures that the first tokens in the contract will be equally distributed
58     // meaning, no divine dump will be ever possible
59     // result: healthy longevity.
60     modifier antiEarlyWhale(uint256 _amountOfEthereum){
61         address _customerAddress = msg.sender;
62         
63         // are we still in the vulnerable phase?
64         // if so, enact anti early whale protocol 
65         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
66             require(
67                 // is the customer in the ambassador list?
68                 ambassadors_[_customerAddress] == true &&
69                 
70                 // does the customer purchase exceed the max ambassador quota?
71                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
72                 
73             );
74             
75             // updated the accumulated quota    
76             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
77         
78             // execute
79             _;
80         } else {
81             // in case the ether count drops low, the ambassador phase won't reinitiate
82             onlyAmbassadors = false;
83             _;    
84         }
85         
86     }
87     
88     
89     /*==============================
90     =            EVENTS            =
91     ==============================*/
92     event onTokenPurchase(
93         address indexed customerAddress,
94         uint256 incomingEthereum,
95         uint256 tokensMinted,
96         address indexed referredBy
97     );
98     
99     event onTokenSell(
100         address indexed customerAddress,
101         uint256 tokensBurned,
102         uint256 ethereumEarned
103     );
104     
105     event onReinvestment(
106         address indexed customerAddress,
107         uint256 ethereumReinvested,
108         uint256 tokensMinted
109     );
110     
111     event onWithdraw(                               //Announce a Jackpot Win
112         address indexed customerAddress,
113         uint256 ethereumWithdrawn
114     );
115 
116      event onWin(
117         address indexed customerAddress,
118         uint256 ethereumWon
119     );
120     
121     // ERC20
122     event Transfer(
123         address indexed from,
124         address indexed to,
125         uint256 tokens
126     );
127     
128     
129     /*=====================================
130     =            CONFIGURABLES            =
131     =====================================*/
132     string public name = "NEKO TOKEN";
133     string public symbol = "NEKO";
134     uint8 constant public decimals = 18;
135     uint8 constant internal dividendFee_ = 4;              //FEE DIVISOR set to 4 for 25% DIV
136     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
137     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
138     uint256 constant internal magnitude = 2**64;
139     
140     // proof of stake (defaults at 100 tokens)
141     uint256 public stakingRequirement = 100e18;
142     
143     // ambassador program
144     mapping(address => bool) internal ambassadors_;
145     uint256 constant internal ambassadorMaxPurchase_ = 5 ether;
146     uint256 constant internal ambassadorQuota_ = 10 ether;
147     
148     
149     
150    /*================================
151     =            DATASETS            =
152     ================================*/
153     // amount of shares for each address (scaled number)
154     mapping(address => uint256) internal tokenBalanceLedger_;
155     mapping(address => uint256) internal referralBalance_;
156     mapping(address => int256) internal payoutsTo_;
157     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
158     uint256 internal tokenSupply_ = 0;
159     uint256 internal profitPerShare_;
160 
161     uint256 internal jackpot_ = 0;
162     
163     // administrator list (see above on what they can do)
164     mapping(address => bool) public administrators;
165     
166     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
167     bool public onlyAmbassadors = true;
168     
169     address Master;
170 
171     uint256 jackpotThreshold;
172 
173     uint jackpotFactor = 250;
174 
175     uint256 jackpotCounter = 0;
176 
177     address lastWinner = 0x0000000000000000000000000000000000000000;
178 
179 
180     /*=======================================
181     =            PUBLIC FUNCTIONS            =
182     =======================================*/
183     /*
184     * -- APPLICATION ENTRY POINTS --  
185     */
186     function NekoToken()
187         public
188     {
189         // add administrators here
190         administrators[msg.sender] = true;
191         
192         ambassadors_[0xa9eB31931417d89b233681dfb319783b1703C998] = true;
193         ambassadors_[0x3662496Bd906054f535D534c46d130A4ee36624C] = true;
194         ambassadors_[0x83c0Efc6d8B16D87BFe1335AB6BcAb3Ed3960285] = true;
195         ambassadors_[0xAD6D6c25FCDAb2e737e8de31795df4c6bB6D9Bae] = true;
196         // because Norsefire is literally everywhere
197         ambassadors_[0x4F4eBF556CFDc21c3424F85ff6572C77c514Fcae] = true;
198 
199         Master = msg.sender;
200 
201         onlyAmbassadors = true;
202    
203         jackpotThreshold = random() * 1e15 * jackpotFactor;       
204         
205 
206     }
207     
208      
209     /**
210      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
211      */
212     function buy(address _referredBy)
213         public
214         payable
215         returns(uint256)
216     {
217         purchaseTokens(msg.value, _referredBy);
218         
219     }
220     
221     /**
222      * Fallback function to handle ethereum that was send straight to the contract
223      * Unfortunately we cannot use a referral address this way.
224      */
225     function()
226         payable
227         public
228     {
229         purchaseTokens(msg.value, 0x0);
230     }
231     
232     /**
233      * Converts all of caller's dividends to tokens.
234      */
235     function reinvest()
236         onlyStronghands()
237         public
238     {
239         // fetch dividends
240         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
241         
242         // pay out the dividends virtually
243         address _customerAddress = msg.sender;
244         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
245         
246         // retrieve ref. bonus
247         _dividends += referralBalance_[_customerAddress];
248         referralBalance_[_customerAddress] = 0;
249         
250         // dispatch a buy order with the virtualized "withdrawn dividends"
251         uint256 _tokens = purchaseTokens(_dividends, 0x0);
252         
253         // fire event
254         onReinvestment(_customerAddress, _dividends, _tokens);
255     }
256     
257     /**
258      * Alias of sell() and withdraw().
259      */
260     function exit()
261         public
262     {
263         // get token count for caller & sell them all
264         address _customerAddress = msg.sender;
265         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
266         if(_tokens > 0) sell(_tokens);
267         
268         // lambo delivery service
269         withdraw();
270     }
271 
272     /**
273      * Withdraws all of the callers earnings.
274      */
275     function withdraw()
276         onlyStronghands()
277         public
278     {
279         // setup data
280         address _customerAddress = msg.sender;
281         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
282         
283         // update dividend tracker
284         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
285         
286         // add ref. bonus
287         _dividends += referralBalance_[_customerAddress];
288         referralBalance_[_customerAddress] = 0;
289         
290         // lambo delivery service
291         _customerAddress.transfer(_dividends);
292         
293         // fire event
294         onWithdraw(_customerAddress, _dividends);
295     }
296     
297     /**
298      * Liquifies tokens to ethereum.
299      */
300     function sell(uint256 _amountOfTokens)
301         onlyBagholders()
302         public
303     {
304         // setup data
305         address _customerAddress = msg.sender;
306         // russian hackers BTFO
307         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
308         uint256 _tokens = _amountOfTokens;
309         uint256 _ethereum = tokensToEthereum_(_tokens);
310         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
311         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
312         
313         // burn the sold tokens
314         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
315         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
316         
317         // update dividends tracker
318         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
319         payoutsTo_[_customerAddress] -= _updatedPayouts;       
320         
321         // dividing by zero is a bad idea
322         if (tokenSupply_ > 0) {
323             // update the amount of dividends per token
324             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
325         }
326         
327         // fire event
328         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
329     }
330     
331     
332     /**
333      * Transfer tokens from the caller to a new holder.
334      * Remember, there's a 10% fee here as well.
335      */
336     function transfer(address _toAddress, uint256 _amountOfTokens)
337         onlyBagholders()
338         public
339         returns(bool)
340     {
341         // setup
342         address _customerAddress = msg.sender;
343         
344         // make sure we have the requested tokens
345         // also disables transfers until ambassador phase is over
346         // ( we dont want whale premines )
347         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
348         
349         // withdraw all outstanding dividends first
350         if(myDividends(true) > 0) withdraw();
351         
352         // liquify 10% of the tokens that are transfered
353         // these are dispersed to shareholders
354         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
355         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
356         uint256 _dividends = tokensToEthereum_(_tokenFee);
357   
358         // burn the fee tokens
359         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
360 
361         // exchange tokens
362         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
363         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
364         
365         // update dividend trackers
366         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
367         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
368         
369         // disperse dividends among holders
370         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
371         
372         // fire event
373         Transfer(_customerAddress, _toAddress, _taxedTokens);
374         
375         // ERC20
376         return true;
377        
378     }
379     
380     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
381     /**
382      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
383     */
384   
385     function disableInitialStage()
386         onlyAdministrator
387         public
388     {
389         onlyAmbassadors = true;
390     }
391     
392     /**
393      * In case one of us dies, we need to replace ourselves.
394      */
395     function setAdministrator(address _identifier, bool _status)
396         onlyAdministrator()
397         public
398     {
399         administrators[_identifier] = _status;
400     }
401     
402     /**
403      * Precautionary measures in case we need to adjust the masternode rate.
404      */
405     function setStakingRequirement(uint256 _amountOfTokens)
406         onlyAdministrator()
407         public
408     {
409         stakingRequirement = _amountOfTokens;
410     }
411     
412     /**
413      * If we want to rebrand, we can.
414      */
415     function setName(string _name)
416         onlyAdministrator()
417         public
418     {
419         name = _name;
420     }
421 
422     /**
423      * Set the JackpotFactpr
424      */
425     function setJackpotFactor(uint _factor)
426         onlyAdministrator()
427         public
428     {
429         jackpotFactor = _factor;
430     }
431     
432     /**
433      * If we want to rebrand, we can.
434      */
435     function setSymbol(string _symbol)
436         onlyAdministrator()
437         public
438     {
439         symbol = _symbol;
440     }
441 
442   
443     
444     /*----------  HELPERS AND CALCULATORS  ----------*/
445     /**
446      * Method to view the current Ethereum stored in the contract
447      * Example: totalEthereumBalance()
448      */
449     function totalEthereumBalance()
450         public
451         view
452         returns(uint)
453     {
454         return this.balance;
455     }
456     
457     /**
458      * Retrieve the total token supply.
459      */
460     function totalSupply()
461         public
462         view
463         returns(uint256)
464     {
465         return tokenSupply_;
466     }
467     
468     /**
469      * Retrieve the tokens owned by the caller.
470      */
471     function myTokens()
472         public
473         view
474         returns(uint256)
475     {
476         address _customerAddress = msg.sender;
477         return balanceOf(_customerAddress);
478     }
479     
480     /**
481      * Retrieve the dividends owned by the caller.
482      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
483      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
484      * But in the internal calculations, we want them separate. 
485      */ 
486     function myDividends(bool _includeReferralBonus) 
487         public 
488         view 
489         returns(uint256)
490     {
491         address _customerAddress = msg.sender;
492         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
493     }
494     
495     /**
496      * Retrieve the token balance of any single address.
497      */
498     function balanceOf(address _customerAddress)
499         view
500         public
501         returns(uint256)
502     {
503         return tokenBalanceLedger_[_customerAddress];
504     }
505 
506    /**
507      * Retrieve the jackpot amount.
508      */
509     function jackpot()
510         public
511         view
512         returns(uint256)
513     {
514         return jackpot_;
515     }
516 
517      /**
518      * Retrieve last winner address.
519      */
520     function getLastWinner()
521         public
522         view
523         returns(address)
524     {
525         return lastWinner;
526     }
527 
528     
529     /**
530      * Retrieve the dividend balance of any single address.
531      */
532     function dividendsOf(address _customerAddress)
533         view
534         public
535         returns(uint256)
536     {
537         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
538     }
539     
540     /**
541      * Return the buy price of 1 individual token.
542      */
543     function sellPrice() 
544         public 
545         view 
546         returns(uint256)
547     {
548         // our calculation relies on the token supply, so we need supply. Doh.
549         if(tokenSupply_ == 0){
550             return tokenPriceInitial_ - tokenPriceIncremental_;
551         } else {
552             uint256 _ethereum = tokensToEthereum_(1e18);
553             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
554             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
555             return _taxedEthereum;
556         }
557     }
558     
559     /**
560      * Return the sell price of 1 individual token.
561      */
562     function buyPrice() 
563         public 
564         view 
565         returns(uint256)
566     {
567         // our calculation relies on the token supply, so we need supply. Doh.
568         if(tokenSupply_ == 0){
569             return tokenPriceInitial_ + tokenPriceIncremental_;
570         } else {
571             uint256 _ethereum = tokensToEthereum_(1e18);
572             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
573             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
574             return _taxedEthereum;
575         }
576     }
577     
578     /**
579      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
580      */
581     function calculateTokensReceived(uint256 _ethereumToSpend) 
582         public 
583         view 
584         returns(uint256)
585     {
586         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
587         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
588         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
589         
590         return _amountOfTokens;
591     }
592     
593     /**
594      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
595      */
596     function calculateEthereumReceived(uint256 _tokensToSell) 
597         public 
598         view 
599         returns(uint256)
600     {
601         require(_tokensToSell <= tokenSupply_);
602         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
603         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
604         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
605         return _taxedEthereum;
606     }
607     
608     
609     /*==========================================
610     =            INTERNAL FUNCTIONS            =
611     ==========================================*/
612 
613     
614     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
615         antiEarlyWhale(_incomingEthereum)
616         internal
617         returns(uint256)
618     {
619         // data setup
620         address _customerAddress = msg.sender;
621         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
622         uint256 _referralBonus = SafeMath.div(_undividedDividends, 4);   //set divisor to 4 for 25% for referrals
623 
624         //uint256 _removeFromDiv =  SafeMath.div(_undividedDividends, 2);  //This is to remove Referral Bonus and Jackpot          
625        
626         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);        //Subtract Referral Bonus
627         _dividends = SafeMath.sub(_dividends, _referralBonus);        //Subtract Jackpot
628         
629         
630         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
631 
632         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
633 
634         //_dividends = SafeMath.sub(_dividends, _referralBonus);                          //Subtract Jackpot
635 
636         uint256 _fee = _dividends * magnitude;     
637 
638         jackpotCounter += _incomingEthereum;                
639 
640               //Remove the jackpot bonus
641  
642         // no point in continuing execution if OP is a poorfag russian hacker
643         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
644         // (or hackers)
645         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
646         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
647         
648         // is the user referred by a masternode?
649         if(
650             // is this a referred purchase?
651             _referredBy != 0x0000000000000000000000000000000000000000 &&
652 
653             // no cheating!
654             _referredBy != _customerAddress &&
655             
656             // does the referrer have at least X whole tokens?
657             // i.e is the referrer a godly chad masternode
658             tokenBalanceLedger_[_referredBy] >= stakingRequirement
659         ){
660             // wealth redistribution
661             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
662 
663             jackpot_ = SafeMath.add(jackpot_, _referralBonus);
664 
665         } else {
666             // no ref purchase
667             // 
668 
669             jackpot_ = SafeMath.add(jackpot_, _referralBonus);
670 
671             referralBalance_[Master] = SafeMath.add(referralBalance_[Master], _referralBonus);
672 
673         }
674         
675         // we can't give people infinite ethereum
676         if(tokenSupply_ > 0){
677             
678             // add tokens to the pool
679             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
680  
681             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
682             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
683             
684             // calculate the amount of tokens the customer receives over his purchase 
685             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
686         
687         } else {
688             // add tokens to the pool
689             tokenSupply_ = _amountOfTokens;
690         }
691         
692         // update circulating supply & the ledger address for the customer
693         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
694         
695         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
696         //really i know you think you do but you don't
697         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
698         payoutsTo_[_customerAddress] += _updatedPayouts;
699         
700         //uint check = checkJackpot(_customerAddress);
701         // fire event
702         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
703 
704         checkJackpot(msg.sender);
705         
706         
707         return _amountOfTokens;
708     }
709 
710 
711     function random() private view returns (uint8) {
712         return uint8(uint256(keccak256(block.timestamp, block.difficulty))%251);
713     }
714 
715 
716     function checkJackpot(address _jackpotAddress)
717         private
718         returns(uint256)
719         {
720         
721         if (jackpotCounter >= jackpotThreshold) {     
722             //WINNER
723             //Add to winner dividends
724             //Reset Jackpot
725             uint256 winnings = jackpot_;
726             //address _customerAddress = msg.sender;
727             referralBalance_[_jackpotAddress] = SafeMath.add(referralBalance_[_jackpotAddress], jackpot_);
728             jackpot_ = 0;
729             jackpotCounter = 0;
730             jackpotThreshold = random() * 1e15 * jackpotFactor;
731             lastWinner = _jackpotAddress;
732 
733             onWin(msg.sender, winnings);
734             
735             return winnings;
736         }
737         
738     }
739 
740 
741     /**
742      * Calculate Token price based on an amount of incoming ethereum
743      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
744      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
745      */
746     function ethereumToTokens_(uint256 _ethereum)
747         internal
748         view
749         returns(uint256)
750     {
751         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
752         uint256 _tokensReceived = 
753          (
754             (
755                 // underflow attempts BTFO
756                 SafeMath.sub(
757                     (sqrt
758                         (
759                             (_tokenPriceInitial**2)
760                             +
761                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
762                             +
763                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
764                             +
765                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
766                         )
767                     ), _tokenPriceInitial
768                 )
769             )/(tokenPriceIncremental_)
770         )-(tokenSupply_)
771         ;
772   
773         return _tokensReceived;
774     }
775     
776     /**
777      * Calculate token sell value.
778      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
779      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
780      */
781      function tokensToEthereum_(uint256 _tokens)
782         internal
783         view
784         returns(uint256)
785     {
786 
787         uint256 tokens_ = (_tokens + 1e18);
788         uint256 _tokenSupply = (tokenSupply_ + 1e18);
789         uint256 _etherReceived =
790         (
791             // underflow attempts BTFO
792             SafeMath.sub(
793                 (
794                     (
795                         (
796                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
797                         )-tokenPriceIncremental_
798                     )*(tokens_ - 1e18)
799                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
800             )
801         /1e18);
802         return _etherReceived;
803     }
804     
805     
806     //This is where all your gas goes, sorry
807     //Not sorry, you probably only paid 1 gwei
808     function sqrt(uint x) internal pure returns (uint y) {
809         uint z = (x + 1) / 2;
810         y = x;
811         while (z < y) {
812             y = z;
813             z = (x / z + z) / 2;
814         }
815     }
816 }
817 
818 /**
819  * @title SafeMath
820  * @dev Math operations with safety checks that throw on error
821  */
822 library SafeMath {
823 
824     /**
825     * @dev Multiplies two numbers, throws on overflow.
826     */
827     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
828         if (a == 0) {
829             return 0;
830         }
831         uint256 c = a * b;
832         assert(c / a == b);
833         return c;
834     }
835 
836     /**
837     * @dev Integer division of two numbers, truncating the quotient.
838     */
839     function div(uint256 a, uint256 b) internal pure returns (uint256) {
840         // assert(b > 0); // Solidity automatically throws when dividing by 0
841         uint256 c = a / b;
842         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
843         return c;
844     }
845 
846     /**
847     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
848     */
849     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
850         assert(b <= a);
851         return a - b;
852     }
853 
854     /**
855     * @dev Adds two numbers, throws on overflow.
856     */
857     function add(uint256 a, uint256 b) internal pure returns (uint256) {
858         uint256 c = a + b;
859         assert(c >= a);
860         return c;
861     }
862 }