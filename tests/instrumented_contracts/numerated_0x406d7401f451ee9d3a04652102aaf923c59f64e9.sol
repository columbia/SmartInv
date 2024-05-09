1 pragma solidity ^0.4.20;
2 
3 /*
4 * Welcome to Proof of Elephant (ELE) elecoin.surge.sh
5 * ==========================*
6 *  *
7 *  *
8 *  *
9 *  *
10 *  *
11 *  *
12           ___.-~"~-._   __....__
13                 .'    `    \ ~"~        ``-.
14                /` _      )  `\              `\
15               /`  a)    /     |               `\
16              :`        /      |                 \
17         <`-._|`  .-.  (      /   .            `;\\
18          `-. `--'_.'-.;\___/'   .      .       | \\
19       _     /:--`     |        /     /        .'  \\
20      ("\   /`/        |       '     '         /    :`;
21      `\'\_/`/         .\     /`~`=-.:        /     ``
22        `._.'          /`\    |      `\      /(
23                      /  /\   |        `Y   /  \
24                jgs  J  /  Y  |         |  /`\  \
25                    /  |   |  |         |  |  |  |
26                   "---"  /___|        /___|  /__|
27                          '"""         '"""  '""" 
28 * ==========================*
29 * -> What?
30 * This source code is a copy of POWH3D
31 * Only difference is that, you will receive 1% dividends.
32 */
33 
34 contract Elephant {
35     /*=================================
36     =            MODIFIERS            =
37     =================================*/
38     // only people with tokens
39     modifier onlyBagholders() {
40         require(myTokens() > 0);
41         _;
42     }
43     
44     // only people with profits
45     modifier onlyStronghands() {
46         require(myDividends(true) > 0);
47         _;
48     }
49     
50     // administrators can:
51     // -> change the name of the contract
52     // -> change the name of the token
53     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
54     // they CANNOT:
55     // -> take funds
56     // -> disable withdrawals
57     // -> kill the contract
58     // -> change the price of tokens
59     modifier onlyAdministrator(){
60         address _customerAddress = msg.sender;
61         require(administrators[keccak256(_customerAddress)]);
62         _;
63     }
64     
65     
66     // ensures that the first tokens in the contract will be equally distributed
67     // meaning, no divine dump will be ever possible
68     // result: healthy longevity.
69     modifier antiEarlyWhale(uint256 _amountOfEthereum){
70         address _customerAddress = msg.sender;
71         
72         // are we still in the vulnerable phase?
73         // if so, enact anti early whale protocol 
74         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
75             require(
76                 // is the customer in the ambassador list?
77                 ambassadors_[_customerAddress] == true &&
78                 
79                 // does the customer purchase exceed the max ambassador quota?
80                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
81                 
82             );
83             
84             // updated the accumulated quota    
85             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
86         
87             // execute
88             _;
89         } else {
90             // in case the ether count drops low, the ambassador phase won't reinitiate
91             onlyAmbassadors = false;
92             _;    
93         }
94         
95     }
96     
97     
98     /*==============================
99     =            EVENTS            =
100     ==============================*/
101     event onTokenPurchase(
102         address indexed customerAddress,
103         uint256 incomingEthereum,
104         uint256 tokensMinted,
105         address indexed referredBy
106     );
107     
108     event onTokenSell(
109         address indexed customerAddress,
110         uint256 tokensBurned,
111         uint256 ethereumEarned
112     );
113     
114     event onReinvestment(
115         address indexed customerAddress,
116         uint256 ethereumReinvested,
117         uint256 tokensMinted
118     );
119     
120     event onWithdraw(
121         address indexed customerAddress,
122         uint256 ethereumWithdrawn
123     );
124     
125     // ERC20
126     event Transfer(
127         address indexed from,
128         address indexed to,
129         uint256 tokens
130     );
131     
132     
133     /*=====================================
134     =            CONFIGURABLES            =
135     =====================================*/
136     string public name = "ELE";
137     string public symbol = "ELE";
138     uint8 constant public decimals = 18;
139     uint8 constant internal dividendFee_ = 100;
140     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
141     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
142     uint256 constant internal magnitude = 2**64;
143     
144     // proof of stake (defaults at 100 tokens)
145     uint256 public stakingRequirement = 5e18;
146     
147     // ambassador program
148     mapping(address => bool) internal ambassadors_;
149     uint256 constant internal ambassadorMaxPurchase_ = 10 ether;
150     uint256 constant internal ambassadorQuota_ = 10 ether;
151     
152     
153     
154    /*================================
155     =            DATASETS            =
156     ================================*/
157     // amount of shares for each address (scaled number)
158     mapping(address => uint256) internal tokenBalanceLedger_;
159     mapping(address => uint256) internal referralBalance_;
160     mapping(address => int256) internal payoutsTo_;
161     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
162     uint256 internal tokenSupply_ = 0;
163     uint256 internal profitPerShare_;
164     
165     // administrator list (see above on what they can do)
166     mapping(bytes32 => bool) public administrators;
167     
168     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
169     bool public onlyAmbassadors = false;
170     
171 
172 
173     /*=======================================
174     =            PUBLIC FUNCTIONS            =
175     =======================================*/
176     /*
177     * -- APPLICATION ENTRY POINTS --  
178     */
179     function Elephant()
180         public
181     {
182         // add administrators here
183         administrators[0x235910f4682cfe7250004430a4ffb5ac78f5217e1f6a4bf99c937edf757c3330] = true;
184         
185         // add the ambassadors here.
186         // One lonely developer 
187         ambassadors_[0x6405C296d5728de46517609B78DA3713097163dB] = true;
188         
189         // Backup Eth address
190        
191         ambassadors_[0x15Fda64fCdbcA27a60Aa8c6ca882Aa3e1DE4Ea41] = true;
192          
193         ambassadors_[0x448D9Ae89DF160392Dd0DD5dda66952999390D50] = true;
194         
195     
196          
197          
198         
199         
200      
201 
202     }
203     
204      
205     /**
206      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
207      */
208     function buy(address _referredBy)
209         public
210         payable
211         returns(uint256)
212     {
213         purchaseTokens(msg.value, _referredBy);
214     }
215     
216     /**
217      * Fallback function to handle ethereum that was send straight to the contract
218      * Unfortunately we cannot use a referral address this way.
219      */
220     function()
221         payable
222         public
223     {
224         purchaseTokens(msg.value, 0x0);
225     }
226     
227     /**
228      * Converts all of caller's dividends to tokens.
229      */
230     function reinvest()
231         onlyStronghands()
232         public
233     {
234         // fetch dividends
235         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
236         
237         // pay out the dividends virtually
238         address _customerAddress = msg.sender;
239         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
240         
241         // retrieve ref. bonus
242         _dividends += referralBalance_[_customerAddress];
243         referralBalance_[_customerAddress] = 0;
244         
245         // dispatch a buy order with the virtualized "withdrawn dividends"
246         uint256 _tokens = purchaseTokens(_dividends, 0x0);
247         
248         // fire event
249         onReinvestment(_customerAddress, _dividends, _tokens);
250     }
251     
252     /**
253      * Alias of sell() and withdraw().
254      */
255     function exit()
256         public
257     {
258         // get token count for caller & sell them all
259         address _customerAddress = msg.sender;
260         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
261         if(_tokens > 0) sell(_tokens);
262         
263         // lambo delivery service
264         withdraw();
265     }
266 
267     /**
268      * Withdraws all of the callers earnings.
269      */
270     function withdraw()
271         onlyStronghands()
272         public
273     {
274         // setup data
275         address _customerAddress = msg.sender;
276         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
277         
278         // update dividend tracker
279         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
280         
281         // add ref. bonus
282         _dividends += referralBalance_[_customerAddress];
283         referralBalance_[_customerAddress] = 0;
284         
285         // lambo delivery service
286         _customerAddress.transfer(_dividends);
287         
288         // fire event
289         onWithdraw(_customerAddress, _dividends);
290     }
291     
292     /**
293      * Liquifies tokens to ethereum.
294      */
295     function sell(uint256 _amountOfTokens)
296         onlyBagholders()
297         public
298     {
299         // setup data
300         address _customerAddress = msg.sender;
301         // russian hackers BTFO
302         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
303         uint256 _tokens = _amountOfTokens;
304         uint256 _ethereum = tokensToEthereum_(_tokens);
305         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
306         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
307         
308         // burn the sold tokens
309         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
310         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
311         
312         // update dividends tracker
313         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
314         payoutsTo_[_customerAddress] -= _updatedPayouts;       
315         
316         // dividing by zero is a bad idea
317         if (tokenSupply_ > 0) {
318             // update the amount of dividends per token
319             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
320         }
321         
322         // fire event
323         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
324     }
325     
326     
327     /**
328      * Transfer tokens from the caller to a new holder.
329      * Remember, there's a 10% fee here as well.
330      */
331     function transfer(address _toAddress, uint256 _amountOfTokens)
332         onlyBagholders()
333         public
334         returns(bool)
335     {
336         // setup
337         address _customerAddress = msg.sender;
338         
339         // make sure we have the requested tokens
340         // also disables transfers until ambassador phase is over
341         // ( we dont want whale premines )
342         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
343         
344         // withdraw all outstanding dividends first
345         if(myDividends(true) > 0) withdraw();
346         
347         // liquify 10% of the tokens that are transfered
348         // these are dispersed to shareholders
349         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
350         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
351         uint256 _dividends = tokensToEthereum_(_tokenFee);
352   
353         // burn the fee tokens
354         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
355 
356         // exchange tokens
357         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
358         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
359         
360         // update dividend trackers
361         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
362         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
363         
364         // disperse dividends among holders
365         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
366         
367         // fire event
368         Transfer(_customerAddress, _toAddress, _taxedTokens);
369         
370         // ERC20
371         return true;
372        
373     }
374     
375     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
376     /**
377      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
378      */
379     function disableInitialStage()
380         onlyAdministrator()
381         public
382     {
383         onlyAmbassadors = false;
384     }
385     
386     /**
387      * In case one of us dies, we need to replace ourselves.
388      */
389     function setAdministrator(bytes32 _identifier, bool _status)
390         onlyAdministrator()
391         public
392     {
393         administrators[_identifier] = _status;
394     }
395     
396     /**
397      * Precautionary measures in case we need to adjust the masternode rate.
398      */
399     function setStakingRequirement(uint256 _amountOfTokens)
400         onlyAdministrator()
401         public
402     {
403         stakingRequirement = _amountOfTokens;
404     }
405     
406     /**
407      * If we want to rebrand, we can.
408      */
409     function setName(string _name)
410         onlyAdministrator()
411         public
412     {
413         name = _name;
414     }
415     
416     /**
417      * If we want to rebrand, we can.
418      */
419     function setSymbol(string _symbol)
420         onlyAdministrator()
421         public
422     {
423         symbol = _symbol;
424     }
425 
426     
427     /*----------  HELPERS AND CALCULATORS  ----------*/
428     /**
429      * Method to view the current Ethereum stored in the contract
430      * Example: totalEthereumBalance()
431      */
432     function totalEthereumBalance()
433         public
434         view
435         returns(uint)
436     {
437         return this.balance;
438     }
439     
440     /**
441      * Retrieve the total token supply.
442      */
443     function totalSupply()
444         public
445         view
446         returns(uint256)
447     {
448         return tokenSupply_;
449     }
450     
451     /**
452      * Retrieve the tokens owned by the caller.
453      */
454     function myTokens()
455         public
456         view
457         returns(uint256)
458     {
459         address _customerAddress = msg.sender;
460         return balanceOf(_customerAddress);
461     }
462     
463     /**
464      * Retrieve the dividends owned by the caller.
465      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
466      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
467      * But in the internal calculations, we want them separate. 
468      */ 
469     function myDividends(bool _includeReferralBonus) 
470         public 
471         view 
472         returns(uint256)
473     {
474         address _customerAddress = msg.sender;
475         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
476     }
477     
478     /**
479      * Retrieve the token balance of any single address.
480      */
481     function balanceOf(address _customerAddress)
482         view
483         public
484         returns(uint256)
485     {
486         return tokenBalanceLedger_[_customerAddress];
487     }
488     
489     /**
490      * Retrieve the dividend balance of any single address.
491      */
492     function dividendsOf(address _customerAddress)
493         view
494         public
495         returns(uint256)
496     {
497         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
498     }
499     
500     /**
501      * Return the buy price of 1 individual token.
502      */
503     function sellPrice() 
504         public 
505         view 
506         returns(uint256)
507     {
508         // our calculation relies on the token supply, so we need supply. Doh.
509         if(tokenSupply_ == 0){
510             return tokenPriceInitial_ - tokenPriceIncremental_;
511         } else {
512             uint256 _ethereum = tokensToEthereum_(1e18);
513             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
514             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
515             return _taxedEthereum;
516         }
517     }
518     
519     /**
520      * Return the sell price of 1 individual token.
521      */
522     function buyPrice() 
523         public 
524         view 
525         returns(uint256)
526     {
527         // our calculation relies on the token supply, so we need supply. Doh.
528         if(tokenSupply_ == 0){
529             return tokenPriceInitial_ + tokenPriceIncremental_;
530         } else {
531             uint256 _ethereum = tokensToEthereum_(1e18);
532             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
533             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
534             return _taxedEthereum;
535         }
536     }
537     
538     /**
539      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
540      */
541     function calculateTokensReceived(uint256 _ethereumToSpend) 
542         public 
543         view 
544         returns(uint256)
545     {
546         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
547         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
548         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
549         
550         return _amountOfTokens;
551     }
552     
553     /**
554      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
555      */
556     function calculateEthereumReceived(uint256 _tokensToSell) 
557         public 
558         view 
559         returns(uint256)
560     {
561         require(_tokensToSell <= tokenSupply_);
562         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
563         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
564         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
565         return _taxedEthereum;
566     }
567     
568     
569     /*==========================================
570     =            INTERNAL FUNCTIONS            =
571     ==========================================*/
572     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
573         antiEarlyWhale(_incomingEthereum)
574         internal
575         returns(uint256)
576     {
577         // data setup
578         address _customerAddress = msg.sender;
579         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
580         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
581         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
582         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
583         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
584         uint256 _fee = _dividends * magnitude;
585  
586         // no point in continuing execution if OP is a poorfag russian hacker
587         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
588         // (or hackers)
589         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
590         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
591         
592         // is the user referred by a masternode?
593         if(
594             // is this a referred purchase?
595             _referredBy != 0x0000000000000000000000000000000000000000 &&
596 
597             // no cheating!
598             _referredBy != _customerAddress &&
599             
600             // does the referrer have at least X whole tokens?
601             // i.e is the referrer a godly chad masternode
602             tokenBalanceLedger_[_referredBy] >= stakingRequirement
603         ){
604             // wealth redistribution
605             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
606         } else {
607             // no ref purchase
608             // add the referral bonus back to the global dividends cake
609             _dividends = SafeMath.add(_dividends, _referralBonus);
610             _fee = _dividends * magnitude;
611         }
612         
613         // we can't give people infinite ethereum
614         if(tokenSupply_ > 0){
615             
616             // add tokens to the pool
617             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
618  
619             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
620             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
621             
622             // calculate the amount of tokens the customer receives over his purchase 
623             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
624         
625         } else {
626             // add tokens to the pool
627             tokenSupply_ = _amountOfTokens;
628         }
629         
630         // update circulating supply & the ledger address for the customer
631         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
632         
633         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
634         //really i know you think you do but you don't
635         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
636         payoutsTo_[_customerAddress] += _updatedPayouts;
637         
638         // fire event
639         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
640         
641         return _amountOfTokens;
642     }
643 
644     /**
645      * Calculate Token price based on an amount of incoming ethereum
646      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
647      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
648      */
649     function ethereumToTokens_(uint256 _ethereum)
650         internal
651         view
652         returns(uint256)
653     {
654         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
655         uint256 _tokensReceived = 
656          (
657             (
658                 // underflow attempts BTFO
659                 SafeMath.sub(
660                     (sqrt
661                         (
662                             (_tokenPriceInitial**2)
663                             +
664                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
665                             +
666                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
667                             +
668                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
669                         )
670                     ), _tokenPriceInitial
671                 )
672             )/(tokenPriceIncremental_)
673         )-(tokenSupply_)
674         ;
675   
676         return _tokensReceived;
677     }
678     
679     /**
680      * Calculate token sell value.
681      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
682      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
683      */
684      function tokensToEthereum_(uint256 _tokens)
685         internal
686         view
687         returns(uint256)
688     {
689 
690         uint256 tokens_ = (_tokens + 1e18);
691         uint256 _tokenSupply = (tokenSupply_ + 1e18);
692         uint256 _etherReceived =
693         (
694             // underflow attempts BTFO
695             SafeMath.sub(
696                 (
697                     (
698                         (
699                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
700                         )-tokenPriceIncremental_
701                     )*(tokens_ - 1e18)
702                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
703             )
704         /1e18);
705         return _etherReceived;
706     }
707     
708     
709     //This is where all your gas goes, sorry
710     //Not sorry, you probably only paid 1 gwei
711     function sqrt(uint x) internal pure returns (uint y) {
712         uint z = (x + 1) / 2;
713         y = x;
714         while (z < y) {
715             y = z;
716             z = (x / z + z) / 2;
717         }
718     }
719 }
720 
721 /**
722  * @title SafeMath
723  * @dev Math operations with safety checks that throw on error
724  */
725 library SafeMath {
726 
727     /**
728     * @dev Multiplies two numbers, throws on overflow.
729     */
730     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
731         if (a == 0) {
732             return 0;
733         }
734         uint256 c = a * b;
735         assert(c / a == b);
736         return c;
737     }
738 
739     /**
740     * @dev Integer division of two numbers, truncating the quotient.
741     */
742     function div(uint256 a, uint256 b) internal pure returns (uint256) {
743         // assert(b > 0); // Solidity automatically throws when dividing by 0
744         uint256 c = a / b;
745         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
746         return c;
747     }
748 
749     /**
750     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
751     */
752     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
753         assert(b <= a);
754         return a - b;
755     }
756 
757     /**
758     * @dev Adds two numbers, throws on overflow.
759     */
760     function add(uint256 a, uint256 b) internal pure returns (uint256) {
761         uint256 c = a + b;
762         assert(c >= a);
763         return c;
764     }
765 }