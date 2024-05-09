1 pragma solidity ^0.4.24;
2 
3 /*
4 * Team FreedomBird presents..
5 * ====================================*
6 *   ██████╗  ██████╗  ██████╗
7 *   ██╔══██╗██╔═══██╗██╔════╝
8 *   ██████╔╝██║   ██║██║
9 *   ██╔═══╝ ██║   ██║██║
10 *   ██║     ╚██████╔╝╚██████╗
11 *   ╚═╝      ╚═════╝  ╚═════╝
12 *   power of community.社区动力
13 * ====================================*
14 *
15 * -> What?
16 * PoC is the proof of 3G community, the base rules:
17 * 1. Buy or sell token will take 10% dividends fee to all poc token holders
18 * 2. Holding over 100 PoC Tokens can be master node, All players who enter the contract through your Masternode have 33% of their 10% dividends fee rerouted from the master-node
19 * More stable than ever, having withstood severe testnet abuse and attack attempts from our community!.
20 * Visit https://poc3g.com for more information.
21 * Join PoC, build the community, earning money and get freedom!
22 */
23 
24 contract PowerOfCommunity {
25   /*=================================
26   =            MODIFIERS            =
27   =================================*/
28   // only people with tokens.
29   modifier onlyBagholders() {
30     require(myTokens() > 0);
31     _;
32   }
33 
34   // only people with profits.
35   modifier onlyStronghands() {
36     require(myDividends(true) > 0);
37     _;
38   }
39 
40   // administrators can:
41   // -> change the name of the contract
42   // -> change the name of the token
43   // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
44   // they CANNOT:
45   // -> take funds
46   // -> disable withdrawals
47   // -> kill the contract
48   // -> change the price of tokens
49   modifier onlyAdministrator(){
50     address _customerAddress = msg.sender;
51     require(administrators[keccak256(abi.encodePacked(_customerAddress))], 'only administrator can do it');
52     _;
53   }
54 
55 
56   // ensures that the first tokens in the contract will be equally distributed.
57   // meaning, no divine dump will be ever possible.
58   // result: healthy longevity.
59   modifier antiEarlyWhale(uint256 _amountOfEthereum){
60     address _customerAddress = msg.sender;
61 
62     // are we still in the vulnerable phase?
63     // if so, enact anti early whale protocol
64     if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
65       require(
66       // is the customer in the ambassador list?
67         ambassadors_[_customerAddress] == true &&
68 
69         // does the customer purchase exceed the max ambassador quota?
70         (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
71 
72       );
73 
74       // updated the accumulated quota
75       ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
76 
77       // execute
78       _;
79     } else {
80       // in case the ether count drops low, the ambassador phase won't reinitiate.
81       onlyAmbassadors = false;
82       _;
83     }
84 
85   }
86 
87 
88   /*==============================
89   =            EVENTS            =
90   ==============================*/
91   event onTokenPurchase(
92     address indexed customerAddress,
93     uint256 incomingEthereum,
94     uint256 tokensMinted,
95     address indexed referredBy
96   );
97 
98   event onTokenSell(
99     address indexed customerAddress,
100     uint256 tokensBurned,
101     uint256 ethereumEarned
102   );
103 
104   event onReinvestment(
105     address indexed customerAddress,
106     uint256 ethereumReinvested,
107     uint256 tokensMinted
108   );
109 
110   event onWithdraw(
111     address indexed customerAddress,
112     uint256 ethereumWithdrawn
113   );
114 
115   // ERC20
116   event Transfer(
117     address indexed from,
118     address indexed to,
119     uint256 tokens
120   );
121 
122   event onAirdrop (
123     address indexed customerAddress,
124     uint256 ethereumAirdrop
125   );
126 
127 
128   /*=====================================
129   =            CONFIGURABLES            =
130   =====================================*/
131   string public name = "Power of Community";
132   string public symbol = "PoC";
133   uint8 constant public decimals = 18;
134   uint8 constant internal dividendFee_ = 10;
135   uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
136   uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
137   uint256 constant internal magnitude = 2**64;
138 
139   // proof of stake (defaults at 100 tokens)
140   uint256 public stakingRequirement = 100e18;
141 
142   // ambassador program
143   mapping(address => bool) internal ambassadors_;
144   uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
145   uint256 constant internal ambassadorQuota_ = 20 ether;
146 
147 
148 
149   /*================================
150    =            DATASETS            =
151    ================================*/
152   // amount of shares for each address (scaled number)
153   mapping(address => uint256) internal tokenBalanceLedger_;
154   mapping(address => uint256) internal referralBalance_;
155   mapping(address => int256) internal payoutsTo_;
156   mapping(address => uint256) internal ambassadorAccumulatedQuota_;
157   uint256 internal tokenSupply_ = 0;
158   uint256 internal profitPerShare_;
159 
160   // administrator list (see above on what they can do)
161   mapping(bytes32 => bool) public administrators;
162 
163   // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
164   bool public onlyAmbassadors = true;
165 
166 
167 
168   /*=======================================
169   =            PUBLIC FUNCTIONS            =
170   =======================================*/
171   /*
172   * -- APPLICATION ENTRY POINTS --
173   */
174   constructor()
175   public
176   {
177     // add administrators here
178     administrators[0x5459dfc1e0ca91cd608719d708525d3feec9ff93fb124f99900ab703862bfbb5] = true;
179 
180     // add the ambassadors here.
181     // contributors that need to remain private out of security concerns.
182     ambassadors_[0xf490eA414651d6c43ED5233e82AC0AA7C73a2ff8] = true; // gl
183     ambassadors_[0x84755198234ea33C19C7db8a470f30CB4B4c3204] = true; // fm
184     ambassadors_[0x53569B4936D17dA60EDef18ce9c177291529F03E] = true; // rz
185     ambassadors_[0x68aa9131666210a55C7Ea1BfA6bA3d8e906E1a5B] = true; // ds
186     ambassadors_[0xc377bCA574536B678e94cc614f77D1f271eEa063] = true; // bw
187     ambassadors_[0xb1D68138E6bD476b559710341584f7D79E8DEd27] = true; // st
188     ambassadors_[0x4d607EB2c41AAEaf6942879afc11bEda30259Af6] = true; // cxc
189   }
190 
191 
192   /**
193    * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
194    */
195   function buy(address _referredBy)
196   public
197   payable
198   returns(uint256)
199   {
200     purchaseTokens(msg.value, _referredBy);
201   }
202 
203   /**
204    * Fallback function to handle ethereum that was send straight to the contract
205    * Unfortunately we cannot use a referral address this way.
206    */
207   function()
208   payable
209   public
210   {
211     purchaseTokens(msg.value, 0x0);
212   }
213 
214   /**
215    * Converts all of caller's dividends to tokens.
216    */
217   function reinvest()
218   onlyStronghands()
219   public
220   {
221     // fetch dividends
222     uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
223 
224     // pay out the dividends virtually
225     address _customerAddress = msg.sender;
226     payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
227 
228     // retrieve ref. bonus
229     _dividends += referralBalance_[_customerAddress];
230     referralBalance_[_customerAddress] = 0;
231 
232     // dispatch a buy order with the virtualized "withdrawn dividends"
233     uint256 _tokens = purchaseTokens(_dividends, 0x0);
234 
235     // fire event
236     emit onReinvestment(_customerAddress, _dividends, _tokens);
237   }
238 
239   /**
240    * Alias of sell() and withdraw().
241    */
242   function exit()
243   public
244   {
245     // get token count for caller & sell them all
246     address _customerAddress = msg.sender;
247     uint256 _tokens = tokenBalanceLedger_[_customerAddress];
248     if(_tokens > 0) sell(_tokens);
249 
250     // lambo delivery service
251     withdraw();
252   }
253 
254   /**
255    * Withdraws all of the callers earnings.
256    */
257   function withdraw()
258   onlyStronghands()
259   public
260   {
261     // setup data
262     address _customerAddress = msg.sender;
263     uint256 _dividends = myDividends(false); // get ref. bonus later in the code
264 
265     // update dividend tracker
266     payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
267 
268     // add ref. bonus
269     _dividends += referralBalance_[_customerAddress];
270     referralBalance_[_customerAddress] = 0;
271 
272     // lambo delivery service
273     _customerAddress.transfer(_dividends);
274 
275     // fire event
276     emit onWithdraw(_customerAddress, _dividends);
277   }
278 
279   /**
280    * Liquifies tokens to ethereum.
281    */
282   function sell(uint256 _amountOfTokens)
283   onlyBagholders()
284   public
285   {
286     // setup data
287     address _customerAddress = msg.sender;
288     // russian hackers BTFO
289     require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
290     uint256 _tokens = _amountOfTokens;
291     uint256 _ethereum = tokensToEthereum_(_tokens);
292     uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
293     uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
294 
295     // burn the sold tokens
296     tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
297     tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
298 
299     // update dividends tracker
300     int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
301     payoutsTo_[_customerAddress] -= _updatedPayouts;
302 
303     // dividing by zero is a bad idea
304     if (tokenSupply_ > 0) {
305       // update the amount of dividends per token
306       profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
307     }
308 
309     // fire event
310     emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
311   }
312 
313 
314   /**
315    * Transfer tokens from the caller to a new holder.
316    * Remember, there's a 0.5% fee here as well.
317    */
318   function transfer(address _toAddress, uint256 _amountOfTokens)
319   onlyBagholders()
320   public
321   returns(bool)
322   {
323     // setup
324     address _customerAddress = msg.sender;
325 
326     // make sure we have the requested tokens
327     // also disables transfers until ambassador phase is over
328     // ( we dont want whale premines )
329     require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
330 
331     // withdraw all outstanding dividends first
332     if(myDividends(true) > 0) withdraw();
333 
334     // liquify 0.5% of the tokens that are transfered
335     // these are dispersed to shareholders
336     uint256 _tokenFee = SafeMath.div(_amountOfTokens, 200);
337     uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
338     uint256 _dividends = tokensToEthereum_(_tokenFee);
339 
340     // burn the fee tokens
341     tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
342 
343     // exchange tokens
344     tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
345     tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
346 
347     // update dividend trackers
348     payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
349     payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
350 
351     // disperse dividends among holders
352     profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
353 
354     // fire event
355     emit Transfer(_customerAddress, _toAddress, _taxedTokens);
356 
357     // ERC20
358     return true;
359 
360   }
361 
362   /**
363    * airdrop or donate eth to all holder
364    */
365   function airdrop()
366   payable
367   public
368   {
369     require(tokenSupply_ > 0, 'no holder');
370     profitPerShare_ = SafeMath.add(profitPerShare_, (msg.value * magnitude) / tokenSupply_);
371     emit onAirdrop(msg.sender, msg.value);
372   }
373 
374   /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
375   /**
376    * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
377    */
378   function disableInitialStage()
379   onlyAdministrator()
380   public
381   {
382     onlyAmbassadors = false;
383   }
384 
385   /**
386    * In case one of us dies, we need to replace ourselves.
387    */
388   function setAdministrator(bytes32 _identifier, bool _status)
389   onlyAdministrator()
390   public
391   {
392     administrators[_identifier] = _status;
393   }
394 
395   /**
396    * Precautionary measures in case we need to adjust the masternode rate.
397    */
398   function setStakingRequirement(uint256 _amountOfTokens)
399   onlyAdministrator()
400   public
401   {
402     stakingRequirement = _amountOfTokens;
403   }
404 
405   /**
406    * If we want to rebrand, we can.
407    */
408   function setName(string _name)
409   onlyAdministrator()
410   public
411   {
412     name = _name;
413   }
414 
415   /**
416    * If we want to rebrand, we can.
417    */
418   function setSymbol(string _symbol)
419   onlyAdministrator()
420   public
421   {
422     symbol = _symbol;
423   }
424 
425 
426   /*----------  HELPERS AND CALCULATORS  ----------*/
427   /**
428    * Retrieve the contract public state.
429    * -function hash- 0xc19d93fb
430    * @return total supply
431    * @return total ethereum balance
432    * @return current buy price of 1 individual token
433    * @return current sell price of 1 individual token
434    */
435   function state()
436   public
437   view
438   returns(uint256, uint, uint256, uint256)
439   {
440     return (
441       tokenSupply_,           // 0
442       totalEthereumBalance(), // 1
443       buyPrice(),             // 2
444       sellPrice()             // 3
445     );
446   }
447 
448   /**
449    * Retrieve the token holder state.
450    * @return token balance
451    * @return dividends
452    * @return referral bonus balance
453    */
454   function holderState()
455   public
456   view
457   returns(uint256, uint256, uint256)
458   {
459     address _customerAddress = msg.sender;
460     return (
461       balanceOf(_customerAddress),          // 0
462       dividendsOf(_customerAddress),        // 1
463       referralBalance_[_customerAddress]    // 2
464     );
465   }
466 
467   /**
468    * Method to view the current Ethereum stored in the contract.
469    * Example: totalEthereumBalance()
470    */
471   function totalEthereumBalance()
472   public
473   view
474   returns(uint)
475   {
476     return address(this).balance;
477   }
478 
479   /**
480    * Retrieve the total token supply.
481    */
482   function totalSupply()
483   public
484   view
485   returns(uint256)
486   {
487     return tokenSupply_;
488   }
489 
490   /**
491    * Retrieve the tokens owned by the caller.
492    */
493   function myTokens()
494   public
495   view
496   returns(uint256)
497   {
498     address _customerAddress = msg.sender;
499     return balanceOf(_customerAddress);
500   }
501 
502   /**
503    * Retrieve the dividends owned by the caller.
504    * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
505    * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
506    * But in the internal calculations, we want them separate.
507    */
508   function myDividends(bool _includeReferralBonus)
509   public
510   view
511   returns(uint256)
512   {
513     address _customerAddress = msg.sender;
514     return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
515   }
516 
517   /**
518    * Retrieve the token balance of any single address.
519    */
520   function balanceOf(address _customerAddress)
521   view
522   public
523   returns(uint256)
524   {
525     return tokenBalanceLedger_[_customerAddress];
526   }
527 
528   /**
529    * Retrieve the dividend balance of any single address.
530    */
531   function dividendsOf(address _customerAddress)
532   view
533   public
534   returns(uint256)
535   {
536     return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
537   }
538 
539   /**
540    * Return the buy price of 1 individual token.
541    */
542   function sellPrice()
543   public
544   view
545   returns(uint256)
546   {
547     // our calculation relies on the token supply, so we need supply. Doh.
548     if(tokenSupply_ == 0){
549       return tokenPriceInitial_ - tokenPriceIncremental_;
550     } else {
551       uint256 _ethereum = tokensToEthereum_(1e18);
552       uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
553       uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
554       return _taxedEthereum;
555     }
556   }
557 
558   /**
559    * Return the sell price of 1 individual token.
560    */
561   function buyPrice()
562   public
563   view
564   returns(uint256)
565   {
566     // our calculation relies on the token supply, so we need supply. Doh.
567     if(tokenSupply_ == 0){
568       return tokenPriceInitial_ + tokenPriceIncremental_;
569     } else {
570       uint256 _ethereum = tokensToEthereum_(1e18);
571       uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
572       uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
573       return _taxedEthereum;
574     }
575   }
576 
577   /**
578    * Function for the frontend to dynamically retrieve the price scaling of buy orders.
579    */
580   function calculateTokensReceived(uint256 _ethereumToSpend)
581   public
582   view
583   returns(uint256)
584   {
585     uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
586     uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
587     uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
588 
589     return _amountOfTokens;
590   }
591 
592   /**
593    * Function for the frontend to dynamically retrieve the price scaling of sell orders.
594    */
595   function calculateEthereumReceived(uint256 _tokensToSell)
596   public
597   view
598   returns(uint256)
599   {
600     require(_tokensToSell <= tokenSupply_);
601     uint256 _ethereum = tokensToEthereum_(_tokensToSell);
602     uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
603     uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
604     return _taxedEthereum;
605   }
606 
607 
608   /*==========================================
609   =            INTERNAL FUNCTIONS            =
610   ==========================================*/
611   function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
612   antiEarlyWhale(_incomingEthereum)
613   internal
614   returns(uint256)
615   {
616     // data setup
617     address _customerAddress = msg.sender;
618     uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
619     uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
620     uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
621     uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
622     uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
623     uint256 _fee = _dividends * magnitude;
624 
625     // no point in continuing execution if OP is a poorfag russian hacker
626     // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
627     // (or hackers)
628     // and yes we know that the safemath function automatically rules out the "greater then" equasion.
629     require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_));
630 
631     // is the user referred by a masternode?
632     if(
633     // is this a referred purchase?
634       _referredBy != 0x0000000000000000000000000000000000000000 &&
635 
636       // no cheating!
637       _referredBy != _customerAddress &&
638 
639       // does the referrer have at least X whole tokens?
640       // i.e is the referrer a godly chad masternode
641       tokenBalanceLedger_[_referredBy] >= stakingRequirement
642     ){
643       // wealth redistribution
644       referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
645     } else {
646       // no ref purchase
647       // add the referral bonus back to the global dividends cake
648       _dividends = SafeMath.add(_dividends, _referralBonus);
649       _fee = _dividends * magnitude;
650     }
651 
652     // we can't give people infinite ethereum
653     if(tokenSupply_ > 0){
654 
655       // add tokens to the pool
656       tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
657 
658       // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
659       profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
660 
661       // calculate the amount of tokens the customer receives over his purchase
662       _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
663 
664     } else {
665       // add tokens to the pool
666       tokenSupply_ = _amountOfTokens;
667     }
668 
669     // update circulating supply & the ledger address for the customer
670     tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
671 
672     // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
673     // really i know you think you do but you don't
674     int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
675     payoutsTo_[_customerAddress] += _updatedPayouts;
676 
677     // fire event
678     emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
679 
680     return _amountOfTokens;
681   }
682 
683   /**
684    * Calculate Token price based on an amount of incoming ethereum
685    * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
686    * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
687    */
688   function ethereumToTokens_(uint256 _ethereum)
689   internal
690   view
691   returns(uint256)
692   {
693     uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
694     uint256 _tokensReceived =
695     (
696     (
697     // underflow attempts BTFO
698     SafeMath.sub(
699       (sqrt
700     (
701       (_tokenPriceInitial**2)
702       +
703       (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
704       +
705       (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
706       +
707       (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
708     )
709       ), _tokenPriceInitial
710     )
711     )/(tokenPriceIncremental_)
712     )-(tokenSupply_)
713     ;
714 
715     return _tokensReceived;
716   }
717 
718   /**
719    * Calculate token sell value.
720    * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
721    * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
722    */
723   function tokensToEthereum_(uint256 _tokens)
724   internal
725   view
726   returns(uint256)
727   {
728 
729     uint256 tokens_ = (_tokens + 1e18);
730     uint256 _tokenSupply = (tokenSupply_ + 1e18);
731     uint256 _etherReceived =
732     (
733     // underflow attempts BTFO
734     SafeMath.sub(
735       (
736       (
737       (
738       tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
739       )-tokenPriceIncremental_
740       )*(tokens_ - 1e18)
741       ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
742     )
743     /1e18);
744     return _etherReceived;
745   }
746 
747 
748   //This is where all your gas goes, sorry.
749   //Not sorry, you probably only paid 1 gwei
750   function sqrt(uint x) internal pure returns (uint y) {
751     uint z = (x + 1) / 2;
752     y = x;
753     while (z < y) {
754       y = z;
755       z = (x / z + z) / 2;
756     }
757   }
758 }
759 
760 /**
761  * @title SafeMath
762  * @dev Math operations with safety checks that throw on error
763  */
764 library SafeMath {
765 
766   /**
767   * @dev Multiplies two numbers, throws on overflow.
768   */
769   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
770     if (a == 0) {
771       return 0;
772     }
773     uint256 c = a * b;
774     assert(c / a == b);
775     return c;
776   }
777 
778   /**
779   * @dev Integer division of two numbers, truncating the quotient.
780   */
781   function div(uint256 a, uint256 b) internal pure returns (uint256) {
782     // assert(b > 0); // Solidity automatically throws when dividing by 0
783     uint256 c = a / b;
784     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
785     return c;
786   }
787 
788   /**
789   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
790   */
791   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
792     assert(b <= a);
793     return a - b;
794   }
795 
796   /**
797   * @dev Adds two numbers, throws on overflow.
798   */
799   function add(uint256 a, uint256 b) internal pure returns (uint256) {
800     uint256 c = a + b;
801     assert(c >= a);
802     return c;
803   }
804 }