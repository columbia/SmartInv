1 pragma solidity ^0.4.20;
2 
3 /*
4 * Team Halo presents..
5 * ==================================== *
6 *         Halo 3D                      * 
7 *                                      *
8 *   Created by Trusted Youtubers       * 
9 *   Discord https://discord.gg/Atxsmvw * 
10 *           Site: h3d.pw               *
11 * ==================================== *
12 * -> What?
13 * The original autonomous pyramid, improved:
14 * [x] More stable than ever, having withstood severe testnet abuse and attack attempts from our community!.
15 * [x] Audited, tested, and approved by known community security specialists such as tocsick and Arc.
16 * [X] New functionality; you can now perform partial sell orders. If you succumb to weak hands, you don't have to dump all of your bags!
17 * [x] New functionality; you can now transfer tokens between wallets. Trading is now possible from within the contract!
18 * [x] New Feature: PoS Masternodes! The first implementation of Ethereum Staking in the world! Vitalik is mad.
19 * [x] Masternodes: Holding 100 H3D Tokens allow you to generate a Masternode link, Masternode links are used as unique entry points to the contract!
20 * [x] Masternodes: All players who enter the contract through your Masternode have 30% of their 10% dividends fee rerouted from the master-node, to the node-master!
21 *
22 * -> What about the last projects?
23 * Every programming member of the old dev team has been fired and/or killed by 232.
24 * The new dev team consists of seasoned, professional developers and has been audited by veteran solidity experts.
25 * Additionally, two independent testnet iterations have been used by hundreds of people; not a single point of failure was found.
26 * 
27 * -> Who worked on this project?
28 * - Jared Crypto Jackson (math/memes/main site/master)
29 * - Crypto Alex (lead solidity dev/lead web3 dev)
30 * - Ferguson (concept design/feedback/management)
31 * - Anonymous#1 (big marketer)
32 * - Anonymous#2 (Blog Site Owner)
33 *
34 * -> Who has audited & approved the projected:
35 * - Klob
36 * - Jared Crypto Jackson
37 * - Sensi Kevlar
38 */
39 
40 contract H3D {
41     /*=================================
42     =            MODIFIERS            =
43     =================================*/
44     // only people with tokens
45     modifier onlyBagholders() {
46         require(myTokens() > 0);
47         _;
48     }
49     
50     // only people with profits
51     modifier onlyStronghands() {
52         require(myDividends(true) > 0);
53         _;
54     }
55     
56     // administrators can:
57     // -> change the name of the contract
58     // -> change the name of the token
59     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
60     // they CANNOT:
61     // -> take funds
62     // -> disable withdrawals
63     // -> kill the contract
64     // -> change the price of tokens
65     modifier onlyAdministrator(){
66         address _customerAddress = msg.sender;
67         require(administrators[keccak256(_customerAddress)]);
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
110         uint256 tokensMinted,
111         address indexed referredBy
112     );
113     
114     event onTokenSell(
115         address indexed customerAddress,
116         uint256 tokensBurned,
117         uint256 ethereumEarned
118     );
119     
120     event onReinvestment(
121         address indexed customerAddress,
122         uint256 ethereumReinvested,
123         uint256 tokensMinted
124     );
125     
126     event onWithdraw(
127         address indexed customerAddress,
128         uint256 ethereumWithdrawn
129     );
130     
131     // ERC20
132     event Transfer(
133         address indexed from,
134         address indexed to,
135         uint256 tokens
136     );
137     
138     
139     /*=====================================
140     =            CONFIGURABLES            =
141     =====================================*/
142     string public name = "Halo";
143     string public symbol = "H3D";
144     uint8 constant public decimals = 18;
145     uint8 constant internal dividendFee_ = 5;
146     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
147     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
148     uint256 constant internal magnitude = 2**64;
149     
150     // proof of stake (defaults at 100 tokens)
151     uint256 public stakingRequirement = 100e18;
152     
153     // ambassador program
154     mapping(address => bool) internal ambassadors_;
155     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
156     uint256 constant internal ambassadorQuota_ = 3 ether;
157     
158     
159     
160    /*================================
161     =            DATASETS            =
162     ================================*/
163     // amount of shares for each address (scaled number)
164     mapping(address => uint256) internal tokenBalanceLedger_;
165     mapping(address => uint256) internal referralBalance_;
166     mapping(address => int256) internal payoutsTo_;
167     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
168     uint256 internal tokenSupply_ = 0;
169     uint256 internal profitPerShare_;
170     
171     // administrator list (see above on what they can do)
172     mapping(bytes32 => bool) public administrators;
173     
174     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
175     bool public onlyAmbassadors = true;
176     
177 
178 
179     /*=======================================
180     =            PUBLIC FUNCTIONS            =
181     =======================================*/
182     /*
183     * -- APPLICATION ENTRY POINTS --  
184     */
185     function Halo()
186         public
187     {
188         // add administrators here
189         administrators[0xdd8bb99b13fe33e1c32254dfb8fff3e71193f6b730a89dd33bfe5dedc6d83002] = true;
190         
191         // add the ambassadors here.
192         // Jared Crypto Jackson - lead solidity dev & lead web dev. 
193         ambassadors_[0x3fCee1D97B3c81b81C04B50C58B64D78Dc0F1cfd] = true;
194         
195         // CryptoAlex - mathematics & website, and undisputed meme god.
196         ambassadors_[0x4Ff135b36C5C2c545BEcD3385465D187B1c6dB16] = true;
197         
198         // bungalogic - concept design, feedback, management.
199         ambassadors_[0xA2552b64Bb14ACF36055B74ec846aFE4A4e3A2f8] = true;
200         
201         // Ferguson - shilling machine, meme maestro, bizman.
202         ambassadors_[0x4331955545c4B7440ad9b18b9e0F80B514b95deF] = true;
203         
204         // Brypto - all those pretty .GIFs & memes you see? you can thank this man for that.
205         ambassadors_[0x6B079fc6c60335C358f2fEC227Ca5259aab58db8] = true;
206         
207         // Kail - community moderator.
208         ambassadors_[0xD38A82102951b82ab7884e64552538FbFe701bad] = true;
209         
210         // Swm - pentests & twitter trendsetter.
211         ambassadors_[0xCA0Ed4Ba058feD80a3a67bC191E7B448350f7d67] = true;
212         
213         // Triceratops - the source behind the non-intrusive referral model.
214         ambassadors_[0xF85B9A2e17fF7f43EF0Ab7133Fc1eDa0342bd742] = true;
215         
216         // CryptoGangz - pentesting, contract auditing.
217         ambassadors_[0xBA472E338E0932674D88C001D021D2B22bBf25Ff] = true;
218         
219         // BlockchainForWhatsBest - pentesting, contract auditing.
220         ambassadors_[0x0EAE214Dd7b259f37E52e1190047e0cd45b00CA6] = true;
221         
222         // Blake Truth Warrior - contract auditing.
223         ambassadors_[0xEbA11bD2dA74BF8BA2e02e46FF4df7b9c95De968] = true;
224         
225         // MiggityMiner - charts & sheets, data dissector, advisor.
226         ambassadors_[0x80D3e7ce7c5Ec9236825c88574Bf72cc740D53e9] = true;
227         
228         // Crypto McPump - 3d chart visualization.
229         ambassadors_[0xadE2C7B71268bB62e492F75acC6F9d6EfEE5BF3e] = true;
230        
231         
232 
233     }
234     
235      
236     /**
237      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
238      */
239     function buy(address _referredBy)
240         public
241         payable
242         returns(uint256)
243     {
244         purchaseTokens(msg.value, _referredBy);
245     }
246     
247     /**
248      * Fallback function to handle ethereum that was send straight to the contract
249      * Unfortunately we cannot use a referral address this way.
250      */
251     function()
252         payable
253         public
254     {
255         purchaseTokens(msg.value, 0x0);
256     }
257     
258     /**
259      * Converts all of caller's dividends to tokens.
260      */
261     function reinvest()
262         onlyStronghands()
263         public
264     {
265         // fetch dividends
266         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
267         
268         // pay out the dividends virtually
269         address _customerAddress = msg.sender;
270         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
271         
272         // retrieve ref. bonus
273         _dividends += referralBalance_[_customerAddress];
274         referralBalance_[_customerAddress] = 0;
275         
276         // dispatch a buy order with the virtualized "withdrawn dividends"
277         uint256 _tokens = purchaseTokens(_dividends, 0x0);
278         
279         // fire event
280         onReinvestment(_customerAddress, _dividends, _tokens);
281     }
282     
283     /**
284      * Alias of sell() and withdraw().
285      */
286     function exit()
287         public
288     {
289         // get token count for caller & sell them all
290         address _customerAddress = msg.sender;
291         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
292         if(_tokens > 0) sell(_tokens);
293         
294         // lambo delivery service
295         withdraw();
296     }
297 
298     /**
299      * Withdraws all of the callers earnings.
300      */
301     function withdraw()
302         onlyStronghands()
303         public
304     {
305         // setup data
306         address _customerAddress = msg.sender;
307         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
308         
309         // update dividend tracker
310         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
311         
312         // add ref. bonus
313         _dividends += referralBalance_[_customerAddress];
314         referralBalance_[_customerAddress] = 0;
315         
316         // lambo delivery service
317         _customerAddress.transfer(_dividends);
318         
319         // fire event
320         onWithdraw(_customerAddress, _dividends);
321     }
322     
323     /**
324      * Liquifies tokens to ethereum.
325      */
326     function sell(uint256 _amountOfTokens)
327         onlyBagholders()
328         public
329     {
330         // setup data
331         address _customerAddress = msg.sender;
332         // russian hackers BTFO
333         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
334         uint256 _tokens = _amountOfTokens;
335         uint256 _ethereum = tokensToEthereum_(_tokens);
336         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
337         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
338         
339         // burn the sold tokens
340         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
341         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
342         
343         // update dividends tracker
344         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
345         payoutsTo_[_customerAddress] -= _updatedPayouts;       
346         
347         // dividing by zero is a bad idea
348         if (tokenSupply_ > 0) {
349             // update the amount of dividends per token
350             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
351         }
352         
353         // fire event
354         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
355     }
356     
357     
358     /**
359      * Transfer tokens from the caller to a new holder.
360      * Remember, there's a 10% fee here as well.
361      */
362     function transfer(address _toAddress, uint256 _amountOfTokens)
363         onlyBagholders()
364         public
365         returns(bool)
366     {
367         // setup
368         address _customerAddress = msg.sender;
369         
370         // make sure we have the requested tokens
371         // also disables transfers until ambassador phase is over
372         // ( we dont want whale premines )
373         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
374         
375         // withdraw all outstanding dividends first
376         if(myDividends(true) > 0) withdraw();
377         
378         // liquify 10% of the tokens that are transfered
379         // these are dispersed to shareholders
380         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
381         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
382         uint256 _dividends = tokensToEthereum_(_tokenFee);
383   
384         // burn the fee tokens
385         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
386 
387         // exchange tokens
388         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
389         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
390         
391         // update dividend trackers
392         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
393         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
394         
395         // disperse dividends among holders
396         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
397         
398         // fire event
399         Transfer(_customerAddress, _toAddress, _taxedTokens);
400         
401         // ERC20
402         return true;
403        
404     }
405     
406     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
407     /**
408      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
409      */
410     function disableInitialStage()
411         onlyAdministrator()
412         public
413     {
414         onlyAmbassadors = false;
415     }
416     
417     /**
418      * In case one of us dies, we need to replace ourselves.
419      */
420     function setAdministrator(bytes32 _identifier, bool _status)
421         onlyAdministrator()
422         public
423     {
424         administrators[_identifier] = _status;
425     }
426     
427     /**
428      * Precautionary measures in case we need to adjust the masternode rate.
429      */
430     function setStakingRequirement(uint256 _amountOfTokens)
431         onlyAdministrator()
432         public
433     {
434         stakingRequirement = _amountOfTokens;
435     }
436     
437     /**
438      * If we want to rebrand, we can.
439      */
440     function setName(string _name)
441         onlyAdministrator()
442         public
443     {
444         name = _name;
445     }
446     
447     /**
448      * If we want to rebrand, we can.
449      */
450     function setSymbol(string _symbol)
451         onlyAdministrator()
452         public
453     {
454         symbol = _symbol;
455     }
456 
457     
458     /*----------  HELPERS AND CALCULATORS  ----------*/
459     /**
460      * Method to view the current Ethereum stored in the contract
461      * Example: totalEthereumBalance()
462      */
463     function totalEthereumBalance()
464         public
465         view
466         returns(uint)
467     {
468         return this.balance;
469     }
470     
471     /**
472      * Retrieve the total token supply.
473      */
474     function totalSupply()
475         public
476         view
477         returns(uint256)
478     {
479         return tokenSupply_;
480     }
481     
482     /**
483      * Retrieve the tokens owned by the caller.
484      */
485     function myTokens()
486         public
487         view
488         returns(uint256)
489     {
490         address _customerAddress = msg.sender;
491         return balanceOf(_customerAddress);
492     }
493     
494     /**
495      * Retrieve the dividends owned by the caller.
496      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
497      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
498      * But in the internal calculations, we want them separate. 
499      */ 
500     function myDividends(bool _includeReferralBonus) 
501         public 
502         view 
503         returns(uint256)
504     {
505         address _customerAddress = msg.sender;
506         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
507     }
508     
509     /**
510      * Retrieve the token balance of any single address.
511      */
512     function balanceOf(address _customerAddress)
513         view
514         public
515         returns(uint256)
516     {
517         return tokenBalanceLedger_[_customerAddress];
518     }
519     
520     /**
521      * Retrieve the dividend balance of any single address.
522      */
523     function dividendsOf(address _customerAddress)
524         view
525         public
526         returns(uint256)
527     {
528         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
529     }
530     
531     /**
532      * Return the buy price of 1 individual token.
533      */
534     function sellPrice() 
535         public 
536         view 
537         returns(uint256)
538     {
539         // our calculation relies on the token supply, so we need supply. Doh.
540         if(tokenSupply_ == 0){
541             return tokenPriceInitial_ - tokenPriceIncremental_;
542         } else {
543             uint256 _ethereum = tokensToEthereum_(1e18);
544             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
545             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
546             return _taxedEthereum;
547         }
548     }
549     
550     /**
551      * Return the sell price of 1 individual token.
552      */
553     function buyPrice() 
554         public 
555         view 
556         returns(uint256)
557     {
558         // our calculation relies on the token supply, so we need supply. Doh.
559         if(tokenSupply_ == 0){
560             return tokenPriceInitial_ + tokenPriceIncremental_;
561         } else {
562             uint256 _ethereum = tokensToEthereum_(1e18);
563             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
564             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
565             return _taxedEthereum;
566         }
567     }
568     
569     /**
570      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
571      */
572     function calculateTokensReceived(uint256 _ethereumToSpend) 
573         public 
574         view 
575         returns(uint256)
576     {
577         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
578         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
579         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
580         
581         return _amountOfTokens;
582     }
583     
584     /**
585      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
586      */
587     function calculateEthereumReceived(uint256 _tokensToSell) 
588         public 
589         view 
590         returns(uint256)
591     {
592         require(_tokensToSell <= tokenSupply_);
593         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
594         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
595         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
596         return _taxedEthereum;
597     }
598     
599     
600     /*==========================================
601     =            INTERNAL FUNCTIONS            =
602     ==========================================*/
603     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
604         antiEarlyWhale(_incomingEthereum)
605         internal
606         returns(uint256)
607     {
608         // data setup
609         address _customerAddress = msg.sender;
610         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
611         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
612         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
613         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
614         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
615         uint256 _fee = _dividends * magnitude;
616  
617         // no point in continuing execution if OP is a poorfag russian hacker
618         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
619         // (or hackers)
620         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
621         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
622         
623         // is the user referred by a masternode?
624         if(
625             // is this a referred purchase?
626             _referredBy != 0x0000000000000000000000000000000000000000 &&
627 
628             // no cheating!
629             _referredBy != _customerAddress &&
630             
631             // does the referrer have at least X whole tokens?
632             // i.e is the referrer a godly chad masternode
633             tokenBalanceLedger_[_referredBy] >= stakingRequirement
634         ){
635             // wealth redistribution
636             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
637         } else {
638             // no ref purchase
639             // add the referral bonus back to the global dividends cake
640             _dividends = SafeMath.add(_dividends, _referralBonus);
641             _fee = _dividends * magnitude;
642         }
643         
644         // we can't give people infinite ethereum
645         if(tokenSupply_ > 0){
646             
647             // add tokens to the pool
648             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
649  
650             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
651             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
652             
653             // calculate the amount of tokens the customer receives over his purchase 
654             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
655         
656         } else {
657             // add tokens to the pool
658             tokenSupply_ = _amountOfTokens;
659         }
660         
661         // update circulating supply & the ledger address for the customer
662         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
663         
664         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
665         //really i know you think you do but you don't
666         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
667         payoutsTo_[_customerAddress] += _updatedPayouts;
668         
669         // fire event
670         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
671         
672         return _amountOfTokens;
673     }
674 
675     /**
676      * Calculate Token price based on an amount of incoming ethereum
677      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
678      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
679      */
680     function ethereumToTokens_(uint256 _ethereum)
681         internal
682         view
683         returns(uint256)
684     {
685         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
686         uint256 _tokensReceived = 
687          (
688             (
689                 // underflow attempts BTFO
690                 SafeMath.sub(
691                     (sqrt
692                         (
693                             (_tokenPriceInitial**2)
694                             +
695                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
696                             +
697                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
698                             +
699                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
700                         )
701                     ), _tokenPriceInitial
702                 )
703             )/(tokenPriceIncremental_)
704         )-(tokenSupply_)
705         ;
706   
707         return _tokensReceived;
708     }
709     
710     /**
711      * Calculate token sell value.
712      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
713      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
714      */
715      function tokensToEthereum_(uint256 _tokens)
716         internal
717         view
718         returns(uint256)
719     {
720 
721         uint256 tokens_ = (_tokens + 1e18);
722         uint256 _tokenSupply = (tokenSupply_ + 1e18);
723         uint256 _etherReceived =
724         (
725             // underflow attempts BTFO
726             SafeMath.sub(
727                 (
728                     (
729                         (
730                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
731                         )-tokenPriceIncremental_
732                     )*(tokens_ - 1e18)
733                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
734             )
735         /1e18);
736         return _etherReceived;
737     }
738     
739     
740     //This is where all your gas goes, sorry
741     //Not sorry, you probably only paid 1 gwei
742     function sqrt(uint x) internal pure returns (uint y) {
743         uint z = (x + 1) / 2;
744         y = x;
745         while (z < y) {
746             y = z;
747             z = (x / z + z) / 2;
748         }
749     }
750 }
751 
752 /**
753  * @title SafeMath
754  * @dev Math operations with safety checks that throw on error
755  */
756 library SafeMath {
757 
758     /**
759     * @dev Multiplies two numbers, throws on overflow.
760     */
761     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
762         if (a == 0) {
763             return 0;
764         }
765         uint256 c = a * b;
766         assert(c / a == b);
767         return c;
768     }
769 
770     /**
771     * @dev Integer division of two numbers, truncating the quotient.
772     */
773     function div(uint256 a, uint256 b) internal pure returns (uint256) {
774         // assert(b > 0); // Solidity automatically throws when dividing by 0
775         uint256 c = a / b;
776         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
777         return c;
778     }
779 
780     /**
781     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
782     */
783     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
784         assert(b <= a);
785         return a - b;
786     }
787 
788     /**
789     * @dev Adds two numbers, throws on overflow.
790     */
791     function add(uint256 a, uint256 b) internal pure returns (uint256) {
792         uint256 c = a + b;
793         assert(c >= a);
794         return c;
795     }
796 }