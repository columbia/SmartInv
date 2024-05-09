1 pragma solidity ^0.4.20;
2 
3 /*
4 BitMEX Fund
5 
6 https://bitmex.fund
7 
8 What is BitMEX Fund?
9 
10 BitMEX Fund is an investment vehicle which allows you to invest ETH into the XB10 smart contract and take
11 advantage of experienced futures traders using our proprietary algo trading system on the BitMEX Cryptocurrency
12 Futures Exchange.  Our first fund trades 10X leverage on the XBTUSD Perpetual Inverse Swap Contract.  Nearly all 
13 of our trades are made on market making orders and receive 0.075% payments on each order. 
14 
15 How do I invest?
16 
17 You will invest using Ethereum to buy XB10 shares.  You will need an Ethereum wallet such as metamask or trustwallet.
18 Just enter the amount of Ethereum you want to invest and the page will tell you the number of XB10 shares you will receive.   
19 Then complete the transaction with you wallet provider.
20 
21 
22 When can I invest?
23 
24 Our token exchange will launch at 2200 UTC on March 19, 2019.
25 
26 When will the first Bitmex trades begin?
27 
28 We will make our first deposit from the fund on March 22, 2019 or later.   Addional deposits from the fund will happen daily at 
29 2200 UTC.   Profits from the Bitmex accounts will sent to the XB10 Ethereum contract and automatically distributed to 
30 XB10 token holders.  Distibututions are made in relation to the amount of XB10 tokens you own.  You will be able to check the 
31 status of your account at bitmex.fund.
32 
33 What happens when I invest in XB10 shares?
34 
35 When you send your ETH to the XB10 contract you will purchase a calculated number of XB10 shares.   The price of XB10 
36 increases with the number of shares in the contract.   The XB10 contract will allocate 80% of your invested ETH to the Bitmex Trading fund.
37 10% will be distributed to other XB10 token holders.   10% will be kept in the contract for liquidity.  If you ever sell your XB10 shares, 10%
38 will be deducted as an exit fee and distributed to all remaining XB10 shareholders.  But if you sell you will lose your ongoing BitMEX trading 
39 profit distributions.
40 
41 What happens with Bitmex trading account?
42 
43 Deposits from the XB10 are converted to BTC and deposited to our Bitmex trading account.   When profits are made in the accounts, 14% are 
44 retained for the developers, 80% are deposited into the XB10 contract and distributed to XB10 shareholders, and 6% are retained as additional 
45 reinvested capital for the Bitmex trading account.
46 */
47 
48 contract BitMEXFund {
49     /*=================================
50     =            MODIFIERS            =
51     =================================*/
52     // only people with tokens
53     modifier onlyShareholders() {
54         require(myTokens() > 0);
55         _;
56     }
57     
58     // only shareholders with profits
59     modifier onlyStronghands() {
60         require(myDividends(true) > 0);
61         _;
62     }
63     
64 
65     modifier onlyAdministrator(){
66         address _customerAddress = msg.sender;
67         require(administrators[_customerAddress]);
68         _;
69     }
70     
71     
72     // ensures that the first tokens in the contract will be equally distributed
73     // meaning, no divine dump will be ever possible
74     // result: healthy longevity.
75     modifier antiEarlyWhale(uint256 _amountOfEthereum){
76         address _customerAddress = msg.sender;
77         
78         // are we still in the vulnerable phase?
79         // if so, enact anti early whale protocol 
80         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
81             require(
82                 // is the customer in the ambassador list?
83                 ambassadors_[_customerAddress] == true &&
84                 
85                 // does the customer purchase exceed the max ambassador quota?
86                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
87                 
88             );
89             
90             // updated the accumulated quota    
91             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
92         
93             // execute
94             _;
95         } else {
96             // in case the ether count drops low, the ambassador phase won't reinitiate
97             onlyAmbassadors = false;
98             _;    
99         }
100         
101     }
102     
103     
104     /*==============================
105     =            EVENTS            =
106     ==============================*/
107     event onTokenPurchase(
108         address indexed customerAddress,
109         uint256 incomingEthereum,
110         uint256 tokensMinted
111     );
112     
113     event onTokenSell(
114         address indexed customerAddress,
115         uint256 tokensBurned,
116         uint256 ethereumEarned
117     );
118     
119     event onReinvestment(
120         address indexed customerAddress,
121         uint256 ethereumReinvested,
122         uint256 tokensMinted
123     );
124     
125     event onWithdraw(
126         address indexed customerAddress,
127         uint256 ethereumWithdrawn
128     );
129     
130     // ERC20
131     event Transfer(
132         address indexed from,
133         address indexed to,
134         uint256 tokens
135     );
136     
137     
138     /*=====================================
139     =            CONFIGURABLES            =
140     =====================================*/
141     string public name = "BitMEXFund";
142     string public symbol = "XB10";
143     uint8 constant public decimals = 18;
144     uint8 constant internal purchaseFee_ = 10; //10%
145     uint8 constant internal sellFee_ = 10; //10%
146     uint8 constant internal BitMEXFee = 80; //80% reserved for BitMEX Trading Account
147     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
148     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
149     uint256 constant internal magnitude = 2**64;
150     
151     // proof of stake (defaults at 100 tokens)
152     uint256 public stakingRequirement = 100e18;
153     
154     // ambassador program
155     mapping(address => bool) internal ambassadors_;
156     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
157     uint256 constant internal ambassadorQuota_ = 20 ether;
158 
159     uint public totalBitMEXDeposits;
160     uint public BitMEXAccount;
161     
162     
163     
164    /*================================
165     =            DATASETS            =
166     ================================*/
167     // amount of shares for each address (scaled number)
168     mapping(address => uint256) internal tokenBalanceLedger_;
169     mapping(address => uint256) internal referralBalance_;
170     mapping(address => int256) internal payoutsTo_;
171     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
172     uint256 internal tokenSupply_ = 0;
173     uint256 internal profitPerShare_;
174     
175     // administrator list (see above on what they can do)
176     mapping(address => bool) public administrators;
177     
178     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
179     bool public onlyAmbassadors = true;
180     
181 
182 
183     /*=======================================
184     =            PUBLIC FUNCTIONS            =
185     =======================================*/
186     /*
187     * -- APPLICATION ENTRY POINTS --  
188     */
189     function BitMEXFund()
190         public
191     {
192         // add administrators here
193         administrators[msg.sender] = true;
194         
195 
196     }
197 
198     function addAmbassador(address _ambassador)
199         public
200         onlyAdministrator()
201     {
202         ambassadors_[_ambassador] = true;
203     }
204     
205     function BitMEXDeposit()
206         public
207         payable
208     {
209         //profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
210         profitPerShare_ += (msg.value * magnitude / (tokenSupply_));
211         totalBitMEXDeposits = SafeMath.add(totalBitMEXDeposits, msg.value);
212     }
213      
214     /**
215      * Converts all incoming ethereum to shares for the caller, and passes down the referral addy (if any)
216      */
217     function buy(address _referredBy)
218         public
219         payable
220         returns(uint256)
221     {
222         purchaseTokens(msg.value, _referredBy);
223     }
224     
225     /**
226      * Fallback function to handle ethereum that was send straight to the contract
227      * Unfortunately we cannot use a referral address this way.
228      */
229     function()
230         payable
231         public
232     {
233         purchaseTokens(msg.value, 0x0);
234     }
235     
236     /**
237      * Converts all of caller's dividends to tokens.
238      */
239     function reinvest()
240         onlyStronghands()
241         public
242     {
243         // fetch dividends
244         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
245         
246         // pay out the dividends virtually
247         address _customerAddress = msg.sender;
248         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
249         
250         // retrieve ref. bonus
251         _dividends += referralBalance_[_customerAddress];
252         referralBalance_[_customerAddress] = 0;
253         
254         // dispatch a buy order with the virtualized "withdrawn dividends"
255         uint256 _tokens = purchaseTokens(_dividends, 0x0);
256         
257         // fire event
258         onReinvestment(_customerAddress, _dividends, _tokens);
259     }
260     
261     /**
262      * Alias of sell() and withdraw().
263      */
264     function exit()
265         public
266     {
267         // get token count for caller & sell them all
268         address _customerAddress = msg.sender;
269         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
270         if(_tokens > 0) sell(_tokens);
271         withdraw();
272     }
273 
274     /**
275      * Withdraws all of the callers earnings.
276      */
277     function withdraw()
278         onlyStronghands()
279         public
280     {
281         // setup data
282         address _customerAddress = msg.sender;
283         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
284         
285         // update dividend tracker
286         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
287         
288         // add ref. bonus
289         _dividends += referralBalance_[_customerAddress];
290         referralBalance_[_customerAddress] = 0;
291         
292         _customerAddress.transfer(_dividends);
293         
294         // fire event
295         onWithdraw(_customerAddress, _dividends);
296     }
297 
298 
299     function withdrawBITMEXAccount(uint amt)
300         public
301         onlyAdministrator()
302     {
303         require(amt <= BitMEXAccount);
304         BitMEXAccount = SafeMath.sub(BitMEXAccount,amt);
305         msg.sender.transfer(amt);
306 
307     }
308     
309     /**
310      * Liquifies tokens to ethereum.
311      */
312     function sell(uint256 _amountOfTokens)
313         onlyShareholders()
314         public
315     {
316         // setup data
317         address _customerAddress = msg.sender;
318        
319         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
320         uint256 _tokens = _amountOfTokens;
321         uint256 _ethereum = tokensToEthereum_(_tokens);
322         uint256 _dividends = SafeMath.div(_ethereum, sellFee_);
323         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
324         
325         // burn the sold tokens
326         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
327         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
328         
329         // update dividends tracker
330         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
331         payoutsTo_[_customerAddress] -= _updatedPayouts;       
332         
333         // dividing by zero is a bad idea
334         if (tokenSupply_ > 0) {
335             // update the amount of dividends per token
336             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
337         }
338         
339         // fire event
340         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
341     }
342     
343     
344     /**
345      * Transfer tokens from the caller to a new holder.
346      * Remember, there's a 10% fee here as well.
347      */
348     function transfer(address _toAddress, uint256 _amountOfTokens)
349         onlyShareholders()
350         public
351         returns(bool)
352     {
353         // setup
354         address _customerAddress = msg.sender;
355         
356         // make sure we have the requested tokens
357         // also disables transfers until ambassador phase is over
358         // ( we dont want whale premines )
359         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
360         
361         // withdraw all outstanding dividends first
362         if(myDividends(true) > 0) withdraw();
363         
364         // liquify 10% of the tokens that are transfered
365         // these are dispersed to shareholders
366         uint256 _tokenFee = SafeMath.div(_amountOfTokens, sellFee_);
367         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
368         uint256 _dividends = tokensToEthereum_(_tokenFee);
369   
370         // burn the fee tokens
371         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
372 
373         // exchange tokens
374         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
375         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
376         
377         // update dividend trackers
378         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
379         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
380         
381         // disperse dividends among holders
382         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
383         
384         // fire event
385         Transfer(_customerAddress, _toAddress, _taxedTokens);
386         
387         // ERC20
388         return true;
389        
390     }
391     
392     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
393     /**
394      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
395      */
396     function disableInitialStage()
397         onlyAdministrator()
398         public
399     {
400         onlyAmbassadors = false;
401     }
402     
403     /**
404      * In case one of us dies, we need to replace ourselves.
405      */
406     function setAdministrator(address _identifier, bool _status)
407         onlyAdministrator()
408         public
409     {
410         administrators[_identifier] = _status;
411     }
412     
413     /**
414      * Precautionary measures in case we need to adjust the masternode rate.
415      */
416     function setStakingRequirement(uint256 _amountOfTokens)
417         onlyAdministrator()
418         public
419     {
420         stakingRequirement = _amountOfTokens;
421     }
422     
423     /**
424      * If we want to rebrand, we can.
425      */
426     function setName(string _name)
427         onlyAdministrator()
428         public
429     {
430         name = _name;
431     }
432     
433     /**
434      * If we want to rebrand, we can.
435      */
436     function setSymbol(string _symbol)
437         onlyAdministrator()
438         public
439     {
440         symbol = _symbol;
441     }
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
457 
458     function getData() 
459         //Ethereum Balance, MyTokens, TotalTokens, myDividends, myRefDividends
460         public 
461         view 
462         returns(uint256, uint256, uint256, uint256, uint256, uint256)
463     {
464         return(address(this).balance, balanceOf(msg.sender), tokenSupply_, dividendsOf(msg.sender), referralBalance_[msg.sender], totalBitMEXDeposits);
465     }
466     
467     /**
468      * Retrieve the total token supply.
469      */
470     function totalSupply()
471         public
472         view
473         returns(uint256)
474     {
475         return tokenSupply_;
476     }
477     
478     /**
479      * Retrieve the tokens owned by the caller.
480      */
481     function myTokens()
482         public
483         view
484         returns(uint256)
485     {
486         address _customerAddress = msg.sender;
487         return balanceOf(_customerAddress);
488     }
489     
490     /**
491      * Retrieve the dividends owned by the caller.
492      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
493      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
494      * But in the internal calculations, we want them separate. 
495      */ 
496     function myDividends(bool _includeReferralBonus) 
497         public 
498         view 
499         returns(uint256)
500     {
501         address _customerAddress = msg.sender;
502         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
503     }
504 
505     // function getBitMEXAccount() 
506     //     public 
507     //     view 
508     //     returns(uint256)
509     // {
510         
511     //     return BitMEXAccount;
512     // }
513 
514     
515     /**
516      * Retrieve the token balance of any single address.
517      */
518     function balanceOf(address _customerAddress)
519         view
520         public
521         returns(uint256)
522     {
523         return tokenBalanceLedger_[_customerAddress];
524     }
525     
526     /**
527      * Retrieve the dividend balance of any single address.
528      */
529     function dividendsOf(address _customerAddress)
530         view
531         public
532         returns(uint256)
533     {
534         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
535     }
536     
537     /**
538      * Return the buy price of 1 individual token.
539      */
540     function sellPrice() 
541         public 
542         view 
543         returns(uint256)
544     {
545         // our calculation relies on the token supply, so we need supply. Doh.
546         if(tokenSupply_ == 0){
547             return tokenPriceInitial_ - tokenPriceIncremental_;
548         } else {
549             uint256 _ethereum = tokensToEthereum_(1e18);
550             uint256 _dividends = SafeMath.div(_ethereum, sellFee_);
551             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
552             return _taxedEthereum;
553         }
554     }
555     
556     /**
557      * Return the sell price of 1 individual token.
558      */
559     function buyPrice() 
560         public 
561         view 
562         returns(uint256)
563     {
564         // our calculation relies on the token supply, so we need supply. Doh.
565         if(tokenSupply_ == 0){
566             return tokenPriceInitial_ + tokenPriceIncremental_;
567         } else {
568             uint256 _ethereum = tokensToEthereum_(1e18);
569             uint256 _dividends = SafeMath.div(_ethereum, purchaseFee_  );
570             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
571             return _taxedEthereum;
572         }
573     }
574     
575     /**
576      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
577      */
578     function calculateTokensReceived(uint256 _ethereumToSpend) 
579         public 
580         view 
581         returns(uint256)
582     {
583         uint256 _dividends = SafeMath.div(_ethereumToSpend, purchaseFee_);
584         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
585         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
586         
587         return _amountOfTokens;
588     }
589     
590     /**
591      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
592      */
593     function calculateEthereumReceived(uint256 _tokensToSell) 
594         public 
595         view 
596         returns(uint256)
597     {
598         require(_tokensToSell <= tokenSupply_);
599         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
600         uint256 _dividends = SafeMath.div(_ethereum, sellFee_);
601         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
602         return _taxedEthereum;
603     }
604     
605     
606     /*==========================================
607     =            INTERNAL FUNCTIONS            =
608     ==========================================*/
609     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
610         antiEarlyWhale(_incomingEthereum)
611         internal
612         returns(uint256)
613     {
614         // data setup
615         address _customerAddress = msg.sender;
616         uint256 _BitMEXTradeFee = SafeMath.div(SafeMath.mul(_incomingEthereum, BitMEXFee),100);
617         _incomingEthereum = SafeMath.sub(_incomingEthereum, _BitMEXTradeFee);
618         BitMEXAccount = BitMEXAccount + _BitMEXTradeFee;
619         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, purchaseFee_);
620         uint256 _referralBonus = SafeMath.div(_undividedDividends, 2);
621         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
622         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
623         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
624         uint256 _fee = _dividends * magnitude;
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
646         } else {
647             // no ref purchase
648             // add the referral bonus back to the global dividends cake
649             _dividends = SafeMath.add(_dividends, _referralBonus);
650             _fee = _dividends * magnitude;
651         }
652         
653         // we can't give people infinite ethereum
654         if(tokenSupply_ > 0){
655             
656             // add tokens to the pool
657             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
658  
659             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
660             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
661             
662             // calculate the amount of tokens the customer receives over his purchase 
663             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
664         
665         } else {
666             // add tokens to the pool
667             tokenSupply_ = _amountOfTokens;
668         }
669         
670         // update circulating supply & the ledger address for the customer
671         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
672         
673         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
674         //really i know you think you do but you don't
675         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
676         payoutsTo_[_customerAddress] += _updatedPayouts;
677         
678         // fire event
679        onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens);
680         
681         return _amountOfTokens;
682     }
683 
684     /**
685      * Calculate Token price based on an amount of incoming ethereum
686      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
687      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
688      */
689     function ethereumToTokens_(uint256 _ethereum)
690         internal
691         view
692         returns(uint256)
693     {
694         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
695         uint256 _tokensReceived = 
696          (
697             (
698                 // underflow attempts BTFO
699                 SafeMath.sub(
700                     (sqrt
701                         (
702                             (_tokenPriceInitial**2)
703                             +
704                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
705                             +
706                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
707                             +
708                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
709                         )
710                     ), _tokenPriceInitial
711                 )
712             )/(tokenPriceIncremental_)
713         )-(tokenSupply_)
714         ;
715   
716         return _tokensReceived;
717     }
718     
719     /**
720      * Calculate token sell value.
721      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
722      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
723      */
724      function tokensToEthereum_(uint256 _tokens)
725         internal
726         view
727         returns(uint256)
728     {
729 
730         uint256 tokens_ = (_tokens + 1e18);
731         uint256 _tokenSupply = (tokenSupply_ + 1e18);
732         uint256 _etherReceived =
733         (
734             // underflow attempts BTFO
735             SafeMath.sub(
736                 (
737                     (
738                         (
739                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
740                         )-tokenPriceIncremental_
741                     )*(tokens_ - 1e18)
742                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
743             )
744         /1e18);
745         return _etherReceived;
746     }
747     
748     
749     //This is where all your gas goes, sorry
750     //Not sorry, you probably only paid 1 gwei
751     function sqrt(uint x) internal pure returns (uint y) {
752         uint z = (x + 1) / 2;
753         y = x;
754         while (z < y) {
755             y = z;
756             z = (x / z + z) / 2;
757         }
758     }
759 }
760 
761 /**
762  * @title SafeMath
763  * @dev Math operations with safety checks that throw on error
764  */
765 library SafeMath {
766 
767     /**
768     * @dev Multiplies two numbers, throws on overflow.
769     */
770     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
771         if (a == 0) {
772             return 0;
773         }
774         uint256 c = a * b;
775         assert(c / a == b);
776         return c;
777     }
778 
779     /**
780     * @dev Integer division of two numbers, truncating the quotient.
781     */
782     function div(uint256 a, uint256 b) internal pure returns (uint256) {
783         // assert(b > 0); // Solidity automatically throws when dividing by 0
784         uint256 c = a / b;
785         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
786         return c;
787     }
788 
789     /**
790     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
791     */
792     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
793         assert(b <= a);
794         return a - b;
795     }
796 
797     /**
798     * @dev Adds two numbers, throws on overflow.
799     */
800     function add(uint256 a, uint256 b) internal pure returns (uint256) {
801         uint256 c = a + b;
802         assert(c >= a);
803         return c;
804     }
805 }