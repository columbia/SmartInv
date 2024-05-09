1 /**
2 * 
3 * 
4 *                                                                                                               
5 *   /$$$$$$$  /$$   /$$      /$$$$$$                                                      /$$            /$$$$$$ 
6 *  | $$__  $$|__/  | $$     /$$__  $$                                                    | $$           /$$__  $$
7 *  | $$  \ $$ /$$ /$$$$$$  | $$  \__/  /$$$$$$  /$$$$$$$  /$$$$$$$   /$$$$$$   /$$$$$$$ /$$$$$$        |__/  \ $$
8 *  | $$$$$$$ | $$|_  $$_/  | $$       /$$__  $$| $$__  $$| $$__  $$ /$$__  $$ /$$_____/|_  $$_/          /$$$$$$/
9 *  | $$__  $$| $$  | $$    | $$      | $$  \ $$| $$  \ $$| $$  \ $$| $$$$$$$$| $$        | $$           /$$____/ 
10 *  | $$  \ $$| $$  | $$ /$$| $$    $$| $$  | $$| $$  | $$| $$  | $$| $$_____/| $$        | $$ /$$      | $$      
11 *  | $$$$$$$/| $$  |  $$$$/|  $$$$$$/|  $$$$$$/| $$  | $$| $$  | $$|  $$$$$$$|  $$$$$$$  |  $$$$/      | $$$$$$$$
12 *  |_______/ |__/   \___/   \______/  \______/ |__/  |__/|__/  |__/ \_______/ \_______/   \___/        |________/
13 *                                                                                                               
14 * 
15 * Official Website: https://bitconnect-2.com/
16 * Official Exchange: https://bitconnect-2.com/exchange
17 * 
18 * Official Discord: https://discord.gg/EthH6EZ
19 * Official Telegram: https://t.me/bconnect2          
20 *                                                                                                                                                                                                              
21 */
22 
23 pragma solidity ^0.4.20;
24 
25 /*
26 * Team BitConnect 2 presents:
27 * A fully decentralized earning platform
28 * If you buy BCC2 token you will receive dividends as long as you hold those tokens.
29 * no guarantees are given
30 * ====================================*
31 *  
32 * The original autonomous pyramid, improved:
33 * [x] More stable than ever, having withstood severe testnet abuse and attack attempts from our community!
34 * [x] Audited, tested, and approved by known community security specialists.
35 * [x] You can now transfer tokens between wallets. Trading is now possible from within the contract!
36 * [x] PoS Masternodes!
37 * [x] Masternodes: Holding 1 BCC2 Token allows you to generate a Masternode link, Masternode links are used as unique entry points to the contract!
38 * [x] Masternodes: All players who enter the contract through your Masternode have 30% of their 20% dividends fee rerouted from the master-node, to the node-master!
39 *
40 * BitConnect 2 is a new Project, not connected to the old BitConnect ponzi
41 * The new dev team consists of seasoned, professional developers and has been audited by veteran solidity experts
42 * Additionally, two independent testnet iterations have been used by hundreds of people; not a single point of failure was found.
43 * 
44 * -> Who worked on this project?
45 * - carlos
46 * - 
47 * - 
48 * - 
49 */
50 
51 contract BitConnect {
52     /*=================================
53     =            MODIFIERS            =
54     =================================*/
55     // only people with tokens
56     modifier onlyBagholders() {
57         require(myTokens() > 0);
58         _;
59     }
60     
61     // only people with profits
62     modifier onlyStronghands() {
63         require(myDividends(true) > 0);
64         _;
65     }
66     
67     // administrators can:
68     // -> change the name of the contract
69     // -> change the name of the token
70     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
71     // they CANNOT:
72     // -> take funds
73     // -> disable withdrawals
74     // -> kill the contract
75     // -> change the price of tokens
76     modifier onlyAdministrator(){
77         address _customerAddress = msg.sender;
78         require(administrators[keccak256(_customerAddress)]);
79         _;
80     }
81     
82     
83     // ensures that the first tokens in the contract will be equally distributed
84     // meaning, no divine dump will be ever possible
85     // result: healthy longevity.
86     modifier antiEarlyWhale(uint256 _amountOfEthereum){
87         address _customerAddress = msg.sender;
88         
89         // are we still in the vulnerable phase?
90         // if so, enact anti early whale protocol 
91         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
92             require(
93                 // is the customer in the ambassador list?
94                 ambassadors_[_customerAddress] == true &&
95                 
96                 // does the customer purchase exceed the max ambassador quota?
97                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
98                 
99             );
100             
101             // updated the accumulated quota    
102             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
103         
104             // execute
105             _;
106         } else {
107             // in case the ether count drops low, the ambassador phase won't reinitiate
108             onlyAmbassadors = false;
109             _;    
110         }
111         
112     }
113     
114     
115     /*==============================
116     =            EVENTS            =
117     ==============================*/
118     event onTokenPurchase(
119         address indexed customerAddress,
120         uint256 incomingEthereum,
121         uint256 tokensMinted,
122         address indexed referredBy
123     );
124     
125     event onTokenSell(
126         address indexed customerAddress,
127         uint256 tokensBurned,
128         uint256 ethereumEarned
129     );
130     
131     event onReinvestment(
132         address indexed customerAddress,
133         uint256 ethereumReinvested,
134         uint256 tokensMinted
135     );
136     
137     event onWithdraw(
138         address indexed customerAddress,
139         uint256 ethereumWithdrawn
140     );
141     
142     // ERC20
143     event Transfer(
144         address indexed from,
145         address indexed to,
146         uint256 tokens
147     );
148     
149     
150     /*=====================================
151     =            CONFIGURABLES            =
152     =====================================*/
153     string public name = "BitConnect2";
154     string public symbol = "BCC2";
155     uint8 constant public decimals = 18;
156     uint8 constant internal dividendFee_ = 20;
157     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
158     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
159     uint256 constant internal magnitude = 2**64;
160     
161     // proof of stake (defaults at 100 tokens)
162     uint256 public stakingRequirement = 1e18;
163     
164     // ambassador program
165     mapping(address => bool) internal ambassadors_;
166     uint256 constant internal ambassadorMaxPurchase_ = 3 ether;
167     uint256 constant internal ambassadorQuota_ = 3 ether;
168     
169     
170     
171    /*================================
172     =            DATASETS            =
173     ================================*/
174     // amount of shares for each address (scaled number)
175     mapping(address => uint256) internal tokenBalanceLedger_;
176     mapping(address => uint256) internal referralBalance_;
177     mapping(address => int256) internal payoutsTo_;
178     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
179     uint256 internal tokenSupply_ = 0;
180     uint256 internal profitPerShare_;
181     
182     // administrator list (see above on what they can do)
183     mapping(bytes32 => bool) public administrators;
184     
185     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
186     bool public onlyAmbassadors = true;
187     
188 
189 
190     /*=======================================
191     =            PUBLIC FUNCTIONS            =
192     =======================================*/
193     /*
194     * -- APPLICATION ENTRY POINTS --  
195     */
196     function BitConnect()
197         public
198     {
199         // add administrators here
200         administrators[keccak256(0x6BeF5C40723BaB057a5972f843454232EEE1Db50)] = true;
201         
202         // add the ambassadors here.
203         // carlos n friends
204         ambassadors_[0xD4Ef27FF2B8Fac1085fd3F76876fd8256311E3ce] = true;
205         
206         
207         ambassadors_[0x6BeF5C40723BaB057a5972f843454232EEE1Db50] = true;
208    
209         
210 
211     }
212     
213      
214     /**
215      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
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
271         
272         // lambo delivery service
273         withdraw();
274     }
275 
276     /**
277      * Withdraws all of the callers earnings.
278      */
279     function withdraw()
280         onlyStronghands()
281         public
282     {
283         // setup data
284         address _customerAddress = msg.sender;
285         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
286         
287         // update dividend tracker
288         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
289         
290         // add ref. bonus
291         _dividends += referralBalance_[_customerAddress];
292         referralBalance_[_customerAddress] = 0;
293         
294         // lambo delivery service
295         _customerAddress.transfer(_dividends);
296         
297         // fire event
298         onWithdraw(_customerAddress, _dividends);
299     }
300     
301     /**
302      * Liquifies tokens to ethereum.
303      */
304     function sell(uint256 _amountOfTokens)
305         onlyBagholders()
306         public
307     {
308         // setup data
309         address _customerAddress = msg.sender;
310         // russian hackers BTFO
311         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
312         uint256 _tokens = _amountOfTokens;
313         uint256 _ethereum = tokensToEthereum_(_tokens);
314         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
315         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
316         
317         // burn the sold tokens
318         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
319         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
320         
321         // update dividends tracker
322         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
323         payoutsTo_[_customerAddress] -= _updatedPayouts;       
324         
325         // dividing by zero is a bad idea
326         if (tokenSupply_ > 0) {
327             // update the amount of dividends per token
328             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
329         }
330         
331         // fire event
332         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
333     }
334     
335     
336     /**
337      * Transfer tokens from the caller to a new holder.
338      * Remember, there's a 10% fee here as well.
339      */
340     function transfer(address _toAddress, uint256 _amountOfTokens)
341         onlyBagholders()
342         public
343         returns(bool)
344     {
345         // setup
346         address _customerAddress = msg.sender;
347         
348         // make sure we have the requested tokens
349         // also disables transfers until ambassador phase is over
350         // ( we dont want whale premines )
351         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
352         
353         // withdraw all outstanding dividends first
354         if(myDividends(true) > 0) withdraw();
355         
356         // liquify 10% of the tokens that are transfered
357         // these are dispersed to shareholders
358         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
359         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
360         uint256 _dividends = tokensToEthereum_(_tokenFee);
361   
362         // burn the fee tokens
363         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
364 
365         // exchange tokens
366         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
367         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
368         
369         // update dividend trackers
370         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
371         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
372         
373         // disperse dividends among holders
374         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
375         
376         // fire event
377         Transfer(_customerAddress, _toAddress, _taxedTokens);
378         
379         // ERC20
380         return true;
381        
382     }
383     
384     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
385     /**
386      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
387      */
388     function disableInitialStage()
389         onlyAdministrator()
390         public
391     {
392         onlyAmbassadors = false;
393     }
394     
395     /**
396      * In case one of us dies, we need to replace ourselves.
397      */
398     function setAdministrator(bytes32 _identifier, bool _status)
399         onlyAdministrator()
400         public
401     {
402         administrators[_identifier] = _status;
403     }
404     
405     /**
406      * Precautionary measures in case we need to adjust the masternode rate.
407      */
408     function setStakingRequirement(uint256 _amountOfTokens)
409         onlyAdministrator()
410         public
411     {
412         stakingRequirement = _amountOfTokens;
413     }
414     
415     /**
416      * If we want to rebrand, we can.
417      */
418     function setName(string _name)
419         onlyAdministrator()
420         public
421     {
422         name = _name;
423     }
424     
425     /**
426      * If we want to rebrand, we can.
427      */
428     function setSymbol(string _symbol)
429         onlyAdministrator()
430         public
431     {
432         symbol = _symbol;
433     }
434 
435     
436     /*----------  HELPERS AND CALCULATORS  ----------*/
437     /**
438      * Method to view the current Ethereum stored in the contract
439      * Example: totalEthereumBalance()
440      */
441     function totalEthereumBalance()
442         public
443         view
444         returns(uint)
445     {
446         return this.balance;
447     }
448     
449     /**
450      * Retrieve the total token supply.
451      */
452     function totalSupply()
453         public
454         view
455         returns(uint256)
456     {
457         return tokenSupply_;
458     }
459     
460     /**
461      * Retrieve the tokens owned by the caller.
462      */
463     function myTokens()
464         public
465         view
466         returns(uint256)
467     {
468         address _customerAddress = msg.sender;
469         return balanceOf(_customerAddress);
470     }
471     
472     /**
473      * Retrieve the dividends owned by the caller.
474      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
475      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
476      * But in the internal calculations, we want them separate. 
477      */ 
478     function myDividends(bool _includeReferralBonus) 
479         public 
480         view 
481         returns(uint256)
482     {
483         address _customerAddress = msg.sender;
484         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
485     }
486     
487     /**
488      * Retrieve the token balance of any single address.
489      */
490     function balanceOf(address _customerAddress)
491         view
492         public
493         returns(uint256)
494     {
495         return tokenBalanceLedger_[_customerAddress];
496     }
497     
498     /**
499      * Retrieve the dividend balance of any single address.
500      */
501     function dividendsOf(address _customerAddress)
502         view
503         public
504         returns(uint256)
505     {
506         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
507     }
508     
509     /**
510      * Return the buy price of 1 individual token.
511      */
512     function sellPrice() 
513         public 
514         view 
515         returns(uint256)
516     {
517         // our calculation relies on the token supply, so we need supply. Doh.
518         if(tokenSupply_ == 0){
519             return tokenPriceInitial_ - tokenPriceIncremental_;
520         } else {
521             uint256 _ethereum = tokensToEthereum_(1e18);
522             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
523             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
524             return _taxedEthereum;
525         }
526     }
527     
528     /**
529      * Return the sell price of 1 individual token.
530      */
531     function buyPrice() 
532         public 
533         view 
534         returns(uint256)
535     {
536         // our calculation relies on the token supply, so we need supply. Doh.
537         if(tokenSupply_ == 0){
538             return tokenPriceInitial_ + tokenPriceIncremental_;
539         } else {
540             uint256 _ethereum = tokensToEthereum_(1e18);
541             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
542             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
543             return _taxedEthereum;
544         }
545     }
546     
547     /**
548      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
549      */
550     function calculateTokensReceived(uint256 _ethereumToSpend) 
551         public 
552         view 
553         returns(uint256)
554     {
555         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
556         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
557         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
558         
559         return _amountOfTokens;
560     }
561     
562     /**
563      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
564      */
565     function calculateEthereumReceived(uint256 _tokensToSell) 
566         public 
567         view 
568         returns(uint256)
569     {
570         require(_tokensToSell <= tokenSupply_);
571         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
572         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
573         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
574         return _taxedEthereum;
575     }
576     
577     
578     /*==========================================
579     =            INTERNAL FUNCTIONS            =
580     ==========================================*/
581     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
582         antiEarlyWhale(_incomingEthereum)
583         internal
584         returns(uint256)
585     {
586         // data setup
587         address _customerAddress = msg.sender;
588         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
589         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
590         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
591         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
592         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
593         uint256 _fee = _dividends * magnitude;
594  
595         // no point in continuing execution if OP is a poorfag russian hacker
596         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
597         // (or hackers)
598         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
599         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
600         
601         // is the user referred by a masternode?
602         if(
603             // is this a referred purchase?
604             _referredBy != 0x0000000000000000000000000000000000000000 &&
605 
606             // no cheating!
607             _referredBy != _customerAddress &&
608             
609             // does the referrer have at least X whole tokens?
610             // i.e is the referrer a godly chad masternode
611             tokenBalanceLedger_[_referredBy] >= stakingRequirement
612         ){
613             // wealth redistribution
614             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
615         } else {
616             // no ref purchase
617             // add the referral bonus back to the global dividends cake
618             _dividends = SafeMath.add(_dividends, _referralBonus);
619             _fee = _dividends * magnitude;
620         }
621         
622         // we can't give people infinite ethereum
623         if(tokenSupply_ > 0){
624             
625             // add tokens to the pool
626             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
627  
628             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
629             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
630             
631             // calculate the amount of tokens the customer receives over his purchase 
632             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
633         
634         } else {
635             // add tokens to the pool
636             tokenSupply_ = _amountOfTokens;
637         }
638         
639         // update circulating supply & the ledger address for the customer
640         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
641         
642         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
643         //really i know you think you do but you don't
644         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
645         payoutsTo_[_customerAddress] += _updatedPayouts;
646         
647         // fire event
648         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
649         
650         return _amountOfTokens;
651     }
652 
653     /**
654      * Calculate Token price based on an amount of incoming ethereum
655      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
656      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
657      */
658     function ethereumToTokens_(uint256 _ethereum)
659         internal
660         view
661         returns(uint256)
662     {
663         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
664         uint256 _tokensReceived = 
665          (
666             (
667                 // underflow attempts BTFO
668                 SafeMath.sub(
669                     (sqrt
670                         (
671                             (_tokenPriceInitial**2)
672                             +
673                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
674                             +
675                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
676                             +
677                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
678                         )
679                     ), _tokenPriceInitial
680                 )
681             )/(tokenPriceIncremental_)
682         )-(tokenSupply_)
683         ;
684   
685         return _tokensReceived;
686     }
687     
688     /**
689      * Calculate token sell value.
690      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
691      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
692      */
693      function tokensToEthereum_(uint256 _tokens)
694         internal
695         view
696         returns(uint256)
697     {
698 
699         uint256 tokens_ = (_tokens + 1e18);
700         uint256 _tokenSupply = (tokenSupply_ + 1e18);
701         uint256 _etherReceived =
702         (
703             // underflow attempts BTFO
704             SafeMath.sub(
705                 (
706                     (
707                         (
708                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
709                         )-tokenPriceIncremental_
710                     )*(tokens_ - 1e18)
711                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
712             )
713         /1e18);
714         return _etherReceived;
715     }
716     
717     
718     //This is where all your gas goes, sorry
719     //Not sorry, you probably only paid 1 gwei
720     function sqrt(uint x) internal pure returns (uint y) {
721         uint z = (x + 1) / 2;
722         y = x;
723         while (z < y) {
724             y = z;
725             z = (x / z + z) / 2;
726         }
727     }
728 }
729 
730 /**
731  * @title SafeMath
732  * @dev Math operations with safety checks that throw on error
733  */
734 library SafeMath {
735 
736     /**
737     * @dev Multiplies two numbers, throws on overflow.
738     */
739     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
740         if (a == 0) {
741             return 0;
742         }
743         uint256 c = a * b;
744         assert(c / a == b);
745         return c;
746     }
747 
748     /**
749     * @dev Integer division of two numbers, truncating the quotient.
750     */
751     function div(uint256 a, uint256 b) internal pure returns (uint256) {
752         // assert(b > 0); // Solidity automatically throws when dividing by 0
753         uint256 c = a / b;
754         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
755         return c;
756     }
757 
758     /**
759     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
760     */
761     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
762         assert(b <= a);
763         return a - b;
764     }
765 
766     /**
767     * @dev Adds two numbers, throws on overflow.
768     */
769     function add(uint256 a, uint256 b) internal pure returns (uint256) {
770         uint256 c = a + b;
771         assert(c >= a);
772         return c;
773     }
774 }