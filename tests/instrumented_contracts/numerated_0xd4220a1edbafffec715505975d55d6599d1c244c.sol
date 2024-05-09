1 pragma solidity ^0.4.20;
2 
3 /*
4 * Team JUST presents..
5 * ====================================*
6 * _____     _ _ _ _____    ___ ____   * 
7 *|  _  |___| | | |  |  |  |_  |    \  *
8 *|   __| . | | | |     |  |_  |  |  | * 
9 *|__|  |___|_____|__|__|  |___|____/  *
10 *                                     *
11 * ====================================*
12 * -> What?
13 * The original autonomous pyramid, improved:
14 * [x] More stable than ever, having withstood severe testnet abuse and attack attempts from our community!.
15 * [x] Audited, tested, and approved by known community security specialists such as tocsick and Arc.
16 * [X] New functionality; you can now perform partial sell orders. If you succumb to weak hands, you don't have to dump all of your bags!
17 * [x] New functionality; you can now transfer tokens between wallets. Trading is now possible from within the contract!
18 * [x] New Feature: PoS Masternodes! The first implementation of Ethereum Staking in the world! Vitalik is mad.
19 * [x] Masternodes: Holding 100 PoWH3D Tokens allow you to generate a Masternode link, Masternode links are used as unique entry points to the contract!
20 * [x] Masternodes: All players who enter the contract through your Masternode have 30% of their 10% dividends fee rerouted from the master-node, to the node-master!
21 *
22 * -> What about the last projects?
23 * Every programming member of the old dev team has been fired and/or killed by 232.
24 * The new dev team consists of seasoned, professional developers and has been audited by veteran solidity experts.
25 * Additionally, two independent testnet iterations have been used by hundreds of people; not a single point of failure was found.
26 * 
27 * -> Who worked on this project?
28 * - PonziBot (math/memes/main site/master)
29 * - Mantso (lead solidity dev/lead web3 dev)
30 * - swagg (concept design/feedback/management)
31 * - Anonymous#1 (main site/web3/test cases)
32 * - Anonymous#2 (math formulae/whitepaper)
33 *
34 * -> Who has audited & approved the projected:
35 * - Arc
36 * - tocisck
37 * - sumpunk
38 */
39 
40 contract Mystical {
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
142     string public name = "Mystical";
143     string public symbol = "MYS";
144     uint8 constant public decimals = 18;
145     uint8 constant internal dividendFee_ = 10;
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
156     uint256 constant internal ambassadorQuota_ = 20 ether;
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
185     function Mystical()
186         public
187     {
188         // add administrators here
189         administrators[0xD005b561afBef3b68A534B2c1e872EEb5833105F730] = true;
190         
191         // add the ambassadors here.
192         // mantso - lead solidity dev & lead web dev. 
193         ambassadors_[0x8b4DA1827932D71759687f925D17F81Fc94e3A9D] = true;
194         
195         // ponzibot - mathematics & website, and undisputed meme god.
196         ambassadors_[0x8e0d985f3Ec1857BEc39B76aAabDEa6B31B67d53] = true;
197         
198         // swagg - concept design, feedback, management.
199         ambassadors_[0x7563A35d5610eE7c9CD330E255Da0e779a644C19] = true;
200         
201         // k-dawgz - shilling machine, meme maestro, bizman.
202         ambassadors_[0x215e3C713BADb158A457e61f99325bBB5d278E57] = true;
203         
204         // elmojo - all those pretty .GIFs & memes you see? you can thank this man for that.
205         ambassadors_[0xaFF8B5CDCB339eEf5e1100597740a394C7B9c6cA] = true;
206         
207         // capex - community moderator.
208         ambassadors_[0x8dc6569c28521560EAF1890bC41b2F3FC2010E1b] = true;
209         
210         // jörmungandr - pentests & twitter trendsetter.
211         ambassadors_[0xf14BE3662FE4c9215c27698166759Db6967De94f] = true;
212         
213         // inventor - the source behind the non-intrusive referral model.
214         ambassadors_[0x18E90Fc6F70344f53EBd4f6070bf6Aa23e2D748C] = true;
215         
216         // tocsick - pentesting, contract auditing.
217         ambassadors_[0x49Aae4D923207e80Fc91E626BCb6532502264dfC] = true;
218         
219         // arc - pentesting, contract auditing.
220         ambassadors_[0x3a0cca1A832644B60730E5D4c27947C5De609d62] = true;
221         
222         // sumpunk - contract auditing.
223         ambassadors_[0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C] = true;
224         
225         // randall - charts & sheets, data dissector, advisor.
226         ambassadors_[0x2b219C2178f099dE4E9A3667d5cCc2cc64da0763] = true;
227         
228         // ambius - 3d chart visualization.
229         ambassadors_[0x2A04C7335f90a6bd4e9c4F713DD792200e27F2E6] = true;
230         
231         // contributors that need to remain private out of security concerns.
232         ambassadors_[0x35668818ba8F768D4C21787a6f45C86C69394dfD] = true; //dp
233         ambassadors_[0xa3120da52e604aC3Fc80A63813Ef15476e0B6AbD] = true; //tc
234         ambassadors_[0x924E71bA600372e2410285423F1Fe66799b717EC] = true; //ja
235         ambassadors_[0x6Ed450e062C20F929CB7Ee72fCc53e9697980a18] = true; //sf
236         ambassadors_[0x18864A6682c8EB79EEA5B899F11bC94ef9a85ADb] = true; //tb
237         ambassadors_[0x9cC1BdC994b7a847705D19106287C0BF94EF04B5] = true; //sm
238         ambassadors_[0x6926572813ec1438088963f208C61847df435a74] = true; //mc
239         ambassadors_[0xE16Ab764a02Ae03681E351Ac58FE79717c0eE8C6] = true; //et
240         ambassadors_[0x276F4a79F22D1BfC51Bd8dc5b27Bfd934C823932] = true; //sn
241         ambassadors_[0xA2b4ed3E2f4beF09FB35101B76Ef4cB9D3eeCaCf] = true; //bt
242         ambassadors_[0x147fc6b04c95BCE47D013c8d7a200ee434323669] = true; //al
243         
244 
245     }
246     
247      
248     /**
249      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
250      */
251     function buy(address _referredBy)
252         public
253         payable
254         returns(uint256)
255     {
256         purchaseTokens(msg.value, _referredBy);
257     }
258     
259     /**
260      * Fallback function to handle ethereum that was send straight to the contract
261      * Unfortunately we cannot use a referral address this way.
262      */
263     function()
264         payable
265         public
266     {
267         purchaseTokens(msg.value, 0x0);
268     }
269     
270     /**
271      * Converts all of caller's dividends to tokens.
272      */
273     function reinvest()
274         onlyStronghands()
275         public
276     {
277         // fetch dividends
278         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
279         
280         // pay out the dividends virtually
281         address _customerAddress = msg.sender;
282         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
283         
284         // retrieve ref. bonus
285         _dividends += referralBalance_[_customerAddress];
286         referralBalance_[_customerAddress] = 0;
287         
288         // dispatch a buy order with the virtualized "withdrawn dividends"
289         uint256 _tokens = purchaseTokens(_dividends, 0x0);
290         
291         // fire event
292         onReinvestment(_customerAddress, _dividends, _tokens);
293     }
294     
295     /**
296      * Alias of sell() and withdraw().
297      */
298     function exit()
299         public
300     {
301         // get token count for caller & sell them all
302         address _customerAddress = msg.sender;
303         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
304         if(_tokens > 0) sell(_tokens);
305         
306         // lambo delivery service
307         withdraw();
308     }
309 
310     /**
311      * Withdraws all of the callers earnings.
312      */
313     function withdraw()
314         onlyStronghands()
315         public
316     {
317         // setup data
318         address _customerAddress = msg.sender;
319         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
320         
321         // update dividend tracker
322         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
323         
324         // add ref. bonus
325         _dividends += referralBalance_[_customerAddress];
326         referralBalance_[_customerAddress] = 0;
327         
328         // lambo delivery service
329         _customerAddress.transfer(_dividends);
330         
331         // fire event
332         onWithdraw(_customerAddress, _dividends);
333     }
334     
335     /**
336      * Liquifies tokens to ethereum.
337      */
338     function sell(uint256 _amountOfTokens)
339         onlyBagholders()
340         public
341     {
342         // setup data
343         address _customerAddress = msg.sender;
344         // russian hackers BTFO
345         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
346         uint256 _tokens = _amountOfTokens;
347         uint256 _ethereum = tokensToEthereum_(_tokens);
348         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
349         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
350         
351         // burn the sold tokens
352         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
353         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
354         
355         // update dividends tracker
356         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
357         payoutsTo_[_customerAddress] -= _updatedPayouts;       
358         
359         // dividing by zero is a bad idea
360         if (tokenSupply_ > 0) {
361             // update the amount of dividends per token
362             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
363         }
364         
365         // fire event
366         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
367     }
368     
369     
370     /**
371      * Transfer tokens from the caller to a new holder.
372      * Remember, there's a 10% fee here as well.
373      */
374     function transfer(address _toAddress, uint256 _amountOfTokens)
375         onlyBagholders()
376         public
377         returns(bool)
378     {
379         // setup
380         address _customerAddress = msg.sender;
381         
382         // make sure we have the requested tokens
383         // also disables transfers until ambassador phase is over
384         // ( we dont want whale premines )
385         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
386         
387         // withdraw all outstanding dividends first
388         if(myDividends(true) > 0) withdraw();
389         
390         // liquify 10% of the tokens that are transfered
391         // these are dispersed to shareholders
392         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
393         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
394         uint256 _dividends = tokensToEthereum_(_tokenFee);
395   
396         // burn the fee tokens
397         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
398 
399         // exchange tokens
400         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
401         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
402         
403         // update dividend trackers
404         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
405         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
406         
407         // disperse dividends among holders
408         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
409         
410         // fire event
411         Transfer(_customerAddress, _toAddress, _taxedTokens);
412         
413         // ERC20
414         return true;
415        
416     }
417     
418     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
419     /**
420      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
421      */
422     function disableInitialStage()
423         onlyAdministrator()
424         public
425     {
426         onlyAmbassadors = false;
427     }
428     
429     /**
430      * In case one of us dies, we need to replace ourselves.
431      */
432     function setAdministrator(bytes32 _identifier, bool _status)
433         onlyAdministrator()
434         public
435     {
436         administrators[_identifier] = _status;
437     }
438     
439     /**
440      * Precautionary measures in case we need to adjust the masternode rate.
441      */
442     function setStakingRequirement(uint256 _amountOfTokens)
443         onlyAdministrator()
444         public
445     {
446         stakingRequirement = _amountOfTokens;
447     }
448     
449     /**
450      * If we want to rebrand, we can.
451      */
452     function setName(string _name)
453         onlyAdministrator()
454         public
455     {
456         name = _name;
457     }
458     
459     /**
460      * If we want to rebrand, we can.
461      */
462     function setSymbol(string _symbol)
463         onlyAdministrator()
464         public
465     {
466         symbol = _symbol;
467     }
468 
469     
470     /*----------  HELPERS AND CALCULATORS  ----------*/
471     /**
472      * Method to view the current Ethereum stored in the contract
473      * Example: totalEthereumBalance()
474      */
475     function totalEthereumBalance()
476         public
477         view
478         returns(uint)
479     {
480         return this.balance;
481     }
482     
483     /**
484      * Retrieve the total token supply.
485      */
486     function totalSupply()
487         public
488         view
489         returns(uint256)
490     {
491         return tokenSupply_;
492     }
493     
494     /**
495      * Retrieve the tokens owned by the caller.
496      */
497     function myTokens()
498         public
499         view
500         returns(uint256)
501     {
502         address _customerAddress = msg.sender;
503         return balanceOf(_customerAddress);
504     }
505     
506     /**
507      * Retrieve the dividends owned by the caller.
508      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
509      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
510      * But in the internal calculations, we want them separate. 
511      */ 
512     function myDividends(bool _includeReferralBonus) 
513         public 
514         view 
515         returns(uint256)
516     {
517         address _customerAddress = msg.sender;
518         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
519     }
520     
521     /**
522      * Retrieve the token balance of any single address.
523      */
524     function balanceOf(address _customerAddress)
525         view
526         public
527         returns(uint256)
528     {
529         return tokenBalanceLedger_[_customerAddress];
530     }
531     
532     /**
533      * Retrieve the dividend balance of any single address.
534      */
535     function dividendsOf(address _customerAddress)
536         view
537         public
538         returns(uint256)
539     {
540         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
541     }
542     
543     /**
544      * Return the buy price of 1 individual token.
545      */
546     function sellPrice() 
547         public 
548         view 
549         returns(uint256)
550     {
551         // our calculation relies on the token supply, so we need supply. Doh.
552         if(tokenSupply_ == 0){
553             return tokenPriceInitial_ - tokenPriceIncremental_;
554         } else {
555             uint256 _ethereum = tokensToEthereum_(1e18);
556             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
557             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
558             return _taxedEthereum;
559         }
560     }
561     
562     /**
563      * Return the sell price of 1 individual token.
564      */
565     function buyPrice() 
566         public 
567         view 
568         returns(uint256)
569     {
570         // our calculation relies on the token supply, so we need supply. Doh.
571         if(tokenSupply_ == 0){
572             return tokenPriceInitial_ + tokenPriceIncremental_;
573         } else {
574             uint256 _ethereum = tokensToEthereum_(1e18);
575             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
576             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
577             return _taxedEthereum;
578         }
579     }
580     
581     /**
582      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
583      */
584     function calculateTokensReceived(uint256 _ethereumToSpend) 
585         public 
586         view 
587         returns(uint256)
588     {
589         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
590         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
591         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
592         
593         return _amountOfTokens;
594     }
595     
596     /**
597      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
598      */
599     function calculateEthereumReceived(uint256 _tokensToSell) 
600         public 
601         view 
602         returns(uint256)
603     {
604         require(_tokensToSell <= tokenSupply_);
605         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
606         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
607         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
608         return _taxedEthereum;
609     }
610     
611     
612     /*==========================================
613     =            INTERNAL FUNCTIONS            =
614     ==========================================*/
615     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
616         antiEarlyWhale(_incomingEthereum)
617         internal
618         returns(uint256)
619     {
620         // data setup
621         address _customerAddress = msg.sender;
622         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
623         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
624         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
625         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
626         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
627         uint256 _fee = _dividends * magnitude;
628  
629         // no point in continuing execution if OP is a poorfag russian hacker
630         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
631         // (or hackers)
632         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
633         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
634         
635         // is the user referred by a masternode?
636         if(
637             // is this a referred purchase?
638             _referredBy != 0x0000000000000000000000000000000000000000 &&
639 
640             // no cheating!
641             _referredBy != _customerAddress &&
642             
643             // does the referrer have at least X whole tokens?
644             // i.e is the referrer a godly chad masternode
645             tokenBalanceLedger_[_referredBy] >= stakingRequirement
646         ){
647             // wealth redistribution
648             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
649         } else {
650             // no ref purchase
651             // add the referral bonus back to the global dividends cake
652             _dividends = SafeMath.add(_dividends, _referralBonus);
653             _fee = _dividends * magnitude;
654         }
655         
656         // we can't give people infinite ethereum
657         if(tokenSupply_ > 0){
658             
659             // add tokens to the pool
660             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
661  
662             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
663             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
664             
665             // calculate the amount of tokens the customer receives over his purchase 
666             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
667         
668         } else {
669             // add tokens to the pool
670             tokenSupply_ = _amountOfTokens;
671         }
672         
673         // update circulating supply & the ledger address for the customer
674         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
675         
676         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
677         //really i know you think you do but you don't
678         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
679         payoutsTo_[_customerAddress] += _updatedPayouts;
680         
681         // fire event
682         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
683         
684         return _amountOfTokens;
685     }
686 
687     /**
688      * Calculate Token price based on an amount of incoming ethereum
689      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
690      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
691      */
692     function ethereumToTokens_(uint256 _ethereum)
693         internal
694         view
695         returns(uint256)
696     {
697         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
698         uint256 _tokensReceived = 
699          (
700             (
701                 // underflow attempts BTFO
702                 SafeMath.sub(
703                     (sqrt
704                         (
705                             (_tokenPriceInitial**2)
706                             +
707                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
708                             +
709                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
710                             +
711                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
712                         )
713                     ), _tokenPriceInitial
714                 )
715             )/(tokenPriceIncremental_)
716         )-(tokenSupply_)
717         ;
718   
719         return _tokensReceived;
720     }
721     
722     /**
723      * Calculate token sell value.
724      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
725      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
726      */
727      function tokensToEthereum_(uint256 _tokens)
728         internal
729         view
730         returns(uint256)
731     {
732 
733         uint256 tokens_ = (_tokens + 1e18);
734         uint256 _tokenSupply = (tokenSupply_ + 1e18);
735         uint256 _etherReceived =
736         (
737             // underflow attempts BTFO
738             SafeMath.sub(
739                 (
740                     (
741                         (
742                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
743                         )-tokenPriceIncremental_
744                     )*(tokens_ - 1e18)
745                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
746             )
747         /1e18);
748         return _etherReceived;
749     }
750     
751     
752     //This is where all your gas goes, sorry
753     //Not sorry, you probably only paid 1 gwei
754     function sqrt(uint x) internal pure returns (uint y) {
755         uint z = (x + 1) / 2;
756         y = x;
757         while (z < y) {
758             y = z;
759             z = (x / z + z) / 2;
760         }
761     }
762 }
763 
764 /**
765  * @title SafeMath
766  * @dev Math operations with safety checks that throw on error
767  */
768 library SafeMath {
769 
770     /**
771     * @dev Multiplies two numbers, throws on overflow.
772     */
773     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
774         if (a == 0) {
775             return 0;
776         }
777         uint256 c = a * b;
778         assert(c / a == b);
779         return c;
780     }
781 
782     /**
783     * @dev Integer division of two numbers, truncating the quotient.
784     */
785     function div(uint256 a, uint256 b) internal pure returns (uint256) {
786         // assert(b > 0); // Solidity automatically throws when dividing by 0
787         uint256 c = a / b;
788         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
789         return c;
790     }
791 
792     /**
793     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
794     */
795     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
796         assert(b <= a);
797         return a - b;
798     }
799 
800     /**
801     * @dev Adds two numbers, throws on overflow.
802     */
803     function add(uint256 a, uint256 b) internal pure returns (uint256) {
804         uint256 c = a + b;
805         assert(c >= a);
806         return c;
807     }
808 }