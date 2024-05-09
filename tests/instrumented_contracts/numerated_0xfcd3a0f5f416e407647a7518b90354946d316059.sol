1 pragma solidity ^0.4.20;
2 
3 /*
4 *Team Bitconnect presents 
5 *                                                                                                               
6 *   /$$$$$$$  /$$   /$$      /$$$$$$                                                      /$$            /$$$$$$ 
7 *  | $$__  $$|__/  | $$     /$$__  $$                                                    | $$           /$$__  $$
8 *  | $$  \ $$ /$$ /$$$$$$  | $$  \__/  /$$$$$$  /$$$$$$$  /$$$$$$$   /$$$$$$   /$$$$$$$ /$$$$$$        |__/  \ $$
9 *  | $$$$$$$ | $$|_  $$_/  | $$       /$$__  $$| $$__  $$| $$__  $$ /$$__  $$ /$$_____/|_  $$_/          /$$$$$$/
10 *  | $$__  $$| $$  | $$    | $$      | $$  \ $$| $$  \ $$| $$  \ $$| $$$$$$$$| $$        | $$           /$$____/ 
11 *  | $$  \ $$| $$  | $$ /$$| $$    $$| $$  | $$| $$  | $$| $$  | $$| $$_____/| $$        | $$ /$$      | $$      
12 *  | $$$$$$$/| $$  |  $$$$/|  $$$$$$/|  $$$$$$/| $$  | $$| $$  | $$|  $$$$$$$|  $$$$$$$  |  $$$$/      | $$$$$$$$
13 *  |_______/ |__/   \___/   \______/  \______/ |__/  |__/|__/  |__/ \_______/ \_______/   \___/        |________/
14 *                                                                                                               
15 * 
16 * Official Website: https://bitconnect.io
17 * Official Exchange: https://bitconnect.io
18 
19 *Bitconnect2.0  a fully decentralized earning platform
20 *no guarantees are given
21 *
22 * If you buy BC2 token you will receive dividends as long as you hold those token.
23 *
24 *
25 *
26 * ====================================*
27 * -> What?
28 * The original autonomous pyramid, improved:
29 * [x] More stable than ever, having withstood severe testnet abuse and attack attempts from our community!.
30 * [x] Audited, tested, and approved by known community security specialists.
31 * [X] New functionality; you can now perform partial sell orders. 
32 * [x] New functionality; you can now transfer tokens between wallets. Trading is now possible from within the contract!
33 * [x] New Feature: PoS Masternodes! The first implementation of Ethereum Staking in the world! Vitalik is mad.
34 * [x] Masternodes: Holding 1 BC2 Token allows you to generate a Masternode link, Masternode links are used as unique entry points to the contract!
35 * [x] Masternodes: All players who enter the contract through your Masternode have 30% of their 10% dividends fee rerouted from the master-node, to the node-master!
36 *
37 
38 *
39 * The new dev team consists of seasoned, professional developers and has been audited by veteran solidity experts.
40 * Additionally, two independent testnet iterations have been used by hundreds of people; not a single point of failure was found.
41 * 
42 * - 
43 */
44 
45 contract BitConnect {
46     /*=================================
47     =            MODIFIERS            =
48     =================================*/
49     // only people with tokens
50     modifier onlyBagholders() {
51         require(myTokens() > 0);
52         _;
53     }
54     
55     // only people with profits
56     modifier onlyStronghands() {
57         require(myDividends(true) > 0);
58         _;
59     }
60     
61     // administrators can:
62     // -> change the name of the contract
63     // -> change the name of the token
64     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
65     // they CANNOT:
66     // -> take funds
67     // -> disable withdrawals
68     // -> kill the contract
69     // -> change the price of tokens
70     modifier onlyAdministrator(){
71         address _customerAddress = msg.sender;
72         require(administrators[keccak256(_customerAddress)]);
73         _;
74     }
75     
76     
77     // ensures that the first tokens in the contract will be equally distributed
78     // meaning, no divine dump will be ever possible
79     // result: healthy longevity.
80     modifier antiEarlyWhale(uint256 _amountOfEthereum){
81         address _customerAddress = msg.sender;
82         
83         // are we still in the vulnerable phase?
84         // if so, enact anti early whale protocol 
85         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
86             require(
87                 // is the customer in the ambassador list?
88                 ambassadors_[_customerAddress] == true &&
89                 
90                 // does the customer purchase exceed the max ambassador quota?
91                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
92                 
93             );
94             
95             // updated the accumulated quota    
96             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
97         
98             // execute
99             _;
100         } else {
101             // in case the ether count drops low, the ambassador phase won't reinitiate
102             onlyAmbassadors = false;
103             _;    
104         }
105         
106     }
107     
108     
109     /*==============================
110     =            EVENTS            =
111     ==============================*/
112     event onTokenPurchase(
113         address indexed customerAddress,
114         uint256 incomingEthereum,
115         uint256 tokensMinted,
116         address indexed referredBy
117     );
118     
119     event onTokenSell(
120         address indexed customerAddress,
121         uint256 tokensBurned,
122         uint256 ethereumEarned
123     );
124     
125     event onReinvestment(
126         address indexed customerAddress,
127         uint256 ethereumReinvested,
128         uint256 tokensMinted
129     );
130     
131     event onWithdraw(
132         address indexed customerAddress,
133         uint256 ethereumWithdrawn
134     );
135     
136     // ERC20
137     event Transfer(
138         address indexed from,
139         address indexed to,
140         uint256 tokens
141     );
142     
143     
144     /*=====================================
145     =            CONFIGURABLES            =
146     =====================================*/
147     string public name = "BitConnect2";
148     string public symbol = "BC2";
149     uint8 constant public decimals = 18;
150     uint8 constant internal dividendFee_ = 10;
151     uint256 constant internal tokenPriceInitial_ = 0.0000000001 ether;
152     uint256 constant internal tokenPriceIncremental_ = 0.00000002 ether;
153     uint256 constant internal magnitude = 2**64;
154     
155     // proof of stake (defaults at 100 tokens)
156     uint256 public stakingRequirement = 10e18;
157     
158     // ambassador program
159     mapping(address => bool) internal ambassadors_;
160     uint256 constant internal ambassadorMaxPurchase_ = 10 ether;
161     uint256 constant internal ambassadorQuota_ = 20 ether;
162     
163     
164     
165    /*================================
166     =            DATASETS            =
167     ================================*/
168     // amount of shares for each address (scaled number)
169     mapping(address => uint256) internal tokenBalanceLedger_;
170     mapping(address => uint256) internal referralBalance_;
171     mapping(address => int256) internal payoutsTo_;
172     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
173     uint256 internal tokenSupply_ = 0;
174     uint256 internal profitPerShare_;
175     
176     // administrator list (see above on what they can do)
177     mapping(bytes32 => bool) public administrators;
178     
179     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
180     bool public onlyAmbassadors = true;
181     
182 
183 
184     /*=======================================
185     =            PUBLIC FUNCTIONS            =
186     =======================================*/
187     /*
188     * -- APPLICATION ENTRY POINTS --  
189     */
190     function BitConnect()
191         public
192     {
193         // add administrators here
194         administrators[keccak256(0xe56570858990aA5810220f7fd54dCaAf25AeA8fA)] = true;
195         
196         // add the ambassadors here.
197         // Gilgamesh 
198         ambassadors_[0xe56570858990aA5810220f7fd54dCaAf25AeA8fA] = true;
199         
200         
201         ambassadors_[0x2EdE99ee0F6BE3314ac89dFFC1769301ac3ADfb7] = true;
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
589         // no point in continuing execution if OP is a  hacker
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