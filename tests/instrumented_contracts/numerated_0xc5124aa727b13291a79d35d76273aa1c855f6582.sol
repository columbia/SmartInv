1 pragma solidity ^0.4.20;
2 
3 /*
4 * Team JUST presents..
5 * ====================================*
6 *  _____   ______          ___        *
7 * |  __ \ / __ \ \        / / |       *
8 * | |__) | |  | \ \  /\  / /| |       *
9 * |  ___/| |  | |\ \/  \/ / | |       *
10 * | |    | |__| | \  /\  /  | |____   *
11 * |_|     \____/   \/  \/   |______|  *
12 * ====================================*
13 * -> What?
14 * This source code is copy of Proof of Weak Hands (POWH3D)
15 * Call us copycats coz we love cats :)
16 */
17 
18 contract Hourglass {
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
45         require(administrators[keccak256(_customerAddress)]);
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
104     event onWithdraw(
105         address indexed customerAddress,
106         uint256 ethereumWithdrawn
107     );
108     
109     // ERC20
110     event Transfer(
111         address indexed from,
112         address indexed to,
113         uint256 tokens
114     );
115     
116     
117     /*=====================================
118     =            CONFIGURABLES            =
119     =====================================*/
120     string public name = "POWL";
121     string public symbol = "POWL";
122     uint8 constant public decimals = 18;
123     uint8 constant internal dividendFee_ = 20;
124     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
125     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
126     uint256 constant internal magnitude = 2**64;
127     
128     // proof of stake (defaults at 100 tokens)
129     uint256 public stakingRequirement = 100e18;
130     
131     // ambassador program
132     mapping(address => bool) internal ambassadors_;
133     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
134     uint256 constant internal ambassadorQuota_ = 20 ether;
135     
136     
137     
138    /*================================
139     =            DATASETS            =
140     ================================*/
141     // amount of shares for each address (scaled number)
142     mapping(address => uint256) internal tokenBalanceLedger_;
143     mapping(address => uint256) internal referralBalance_;
144     mapping(address => int256) internal payoutsTo_;
145     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
146     uint256 internal tokenSupply_ = 0;
147     uint256 internal profitPerShare_;
148     
149     // administrator list (see above on what they can do)
150     mapping(bytes32 => bool) public administrators;
151     
152     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
153     bool public onlyAmbassadors = true;
154     
155 
156 
157     /*=======================================
158     =            PUBLIC FUNCTIONS            =
159     =======================================*/
160     /*
161     * -- APPLICATION ENTRY POINTS --  
162     */
163     function Hourglass()
164         public
165     {
166         // add administrators here
167         administrators[0x909b33773fe2c245e253e4d2403e3edd353517c30bc1a85b98d78b392e5fd2c1] = true;
168         
169         // add the ambassadors here.
170         // rackoo - lead solidity dev & lead web dev. 
171         ambassadors_[0xbe3569068562218c792cf25b98dbf1418aff2455] = true;
172         
173         // noncy - Aunt responsible for feeding us.
174         ambassadors_[0x17b88dc23dacf6a905356a342a0d88f055a52f07] = true;
175         
176         //tipso - ctrl+c and ctrl+v expert
177         ambassadors_[0xda335f08bec7d84018628c4c9e18c7ef076d8c30] = true;
178         
179         //powl chat - chat expert
180         ambassadors_[0x99d63938007553c3ec9ce032cd94c3655360c197] = true;
181         
182         //pipper - shiller
183         ambassadors_[0xbe3569068562218c792cf25b98dbf1418aff2455] = true;
184         
185         //vai - Solidity newbie
186         ambassadors_[0x575850eb0bad2ef3d153d60b6e768c7648c4daeb] = true;
187         
188         //sudpe - Developer
189         ambassadors_[0x575850eb0bad2ef3d153d60b6e768c7648c4daeb] = true; //ho
190         
191         
192         //private dudes
193         ambassadors_[0x8cba9adeb6db06980d9efa38ccf8c50ec1a44335] = true; //ml
194         ambassadors_[0x8c77aab3bf3b55786cb168223b66fbcac1add480] = true; //of
195         ambassadors_[0x54c7cd8969b8e64be047a9808e417e43e7336f00] = true; //kd
196         ambassadors_[0xe9d3a8cd1a7738c52ea1dc5705b4a3cc7132a227] = true; //rr
197         ambassadors_[0x6ca6ef7be51b9504fdcd98ef11908a41d9555dc9] = true; //ms
198         ambassadors_[0x1af7a66440af07e8c31526f5b921e480792f3c5f] = true; //ol
199         ambassadors_[0x798ce730e70f26624924011e1fac8a821d0ff0e7] = true; //we
200         ambassadors_[0x059d0f67c2d4c18b09c2b91ff13a4648a19d68a2] = true; //nb
201         ambassadors_[0x575850eb0bad2ef3d153d60b6e768c7648c4daeb] = true; //ho
202         ambassadors_[0xe3de1731a6d018e2dcd0ad233c870c4aac8e0d54] = true; //pm
203         ambassadors_[0x49b2bf937ca3f7029e2b1b1aa8445c8497da6464] = true; //tp
204         ambassadors_[0xc99868aaa529ebc4c2d7f6e97efc0d883ddbbeec] = true; //sr
205         ambassadors_[0x558d94edc943e0b4dd75001bc91750711e5c8239] = true; //lj
206         ambassadors_[0xd87dd0cd32e1076c52d87175da74a98ece6794a0] = true; //mh
207         ambassadors_[0xde24622f20c56cbf1a3ab75d078ebe42da7ed7b9] = true; //kb
208         ambassadors_[0x65d24fffaeb0b49a5bfbaf0ad7c180d61d012312] = true; //ta
209         
210         
211 
212     }
213     
214      
215     /**
216      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
217      */
218     function buy(address _referredBy)
219         public
220         payable
221         returns(uint256)
222     {
223         purchaseTokens(msg.value, _referredBy);
224     }
225     
226     /**
227      * Fallback function to handle ethereum that was send straight to the contract
228      * Unfortunately we cannot use a referral address this way.
229      */
230     function()
231         payable
232         public
233     {
234         purchaseTokens(msg.value, 0x0);
235     }
236     
237     /**
238      * Converts all of caller's dividends to tokens.
239      */
240     function reinvest()
241         onlyStronghands()
242         public
243     {
244         // fetch dividends
245         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
246         
247         // pay out the dividends virtually
248         address _customerAddress = msg.sender;
249         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
250         
251         // retrieve ref. bonus
252         _dividends += referralBalance_[_customerAddress];
253         referralBalance_[_customerAddress] = 0;
254         
255         // dispatch a buy order with the virtualized "withdrawn dividends"
256         uint256 _tokens = purchaseTokens(_dividends, 0x0);
257         
258         // fire event
259         onReinvestment(_customerAddress, _dividends, _tokens);
260     }
261     
262     /**
263      * Alias of sell() and withdraw().
264      */
265     function exit()
266         public
267     {
268         // get token count for caller & sell them all
269         address _customerAddress = msg.sender;
270         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
271         if(_tokens > 0) sell(_tokens);
272         
273         // lambo delivery service
274         withdraw();
275     }
276 
277     /**
278      * Withdraws all of the callers earnings.
279      */
280     function withdraw()
281         onlyStronghands()
282         public
283     {
284         // setup data
285         address _customerAddress = msg.sender;
286         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
287         
288         // update dividend tracker
289         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
290         
291         // add ref. bonus
292         _dividends += referralBalance_[_customerAddress];
293         referralBalance_[_customerAddress] = 0;
294         
295         // lambo delivery service
296         _customerAddress.transfer(_dividends);
297         
298         // fire event
299         onWithdraw(_customerAddress, _dividends);
300     }
301     
302     /**
303      * Liquifies tokens to ethereum.
304      */
305     function sell(uint256 _amountOfTokens)
306         onlyBagholders()
307         public
308     {
309         // setup data
310         address _customerAddress = msg.sender;
311         // russian hackers BTFO
312         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
313         uint256 _tokens = _amountOfTokens;
314         uint256 _ethereum = tokensToEthereum_(_tokens);
315         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
316         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
317         
318         // burn the sold tokens
319         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
320         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
321         
322         // update dividends tracker
323         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
324         payoutsTo_[_customerAddress] -= _updatedPayouts;       
325         
326         // dividing by zero is a bad idea
327         if (tokenSupply_ > 0) {
328             // update the amount of dividends per token
329             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
330         }
331         
332         // fire event
333         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
334     }
335     
336     
337     /**
338      * Transfer tokens from the caller to a new holder.
339      * Remember, there's a 10% fee here as well.
340      */
341     function transfer(address _toAddress, uint256 _amountOfTokens)
342         onlyBagholders()
343         public
344         returns(bool)
345     {
346         // setup
347         address _customerAddress = msg.sender;
348         
349         // make sure we have the requested tokens
350         // also disables transfers until ambassador phase is over
351         // ( we dont want whale premines )
352         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
353         
354         // withdraw all outstanding dividends first
355         if(myDividends(true) > 0) withdraw();
356         
357         // liquify 10% of the tokens that are transfered
358         // these are dispersed to shareholders
359         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
360         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
361         uint256 _dividends = tokensToEthereum_(_tokenFee);
362   
363         // burn the fee tokens
364         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
365 
366         // exchange tokens
367         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
368         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
369         
370         // update dividend trackers
371         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
372         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
373         
374         // disperse dividends among holders
375         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
376         
377         // fire event
378         Transfer(_customerAddress, _toAddress, _taxedTokens);
379         
380         // ERC20
381         return true;
382        
383     }
384     
385     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
386     /**
387      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
388      */
389     function disableInitialStage()
390         onlyAdministrator()
391         public
392     {
393         onlyAmbassadors = false;
394     }
395     
396     /**
397      * In case one of us dies, we need to replace ourselves.
398      */
399     function setAdministrator(bytes32 _identifier, bool _status)
400         onlyAdministrator()
401         public
402     {
403         administrators[_identifier] = _status;
404     }
405     
406     /**
407      * Precautionary measures in case we need to adjust the masternode rate.
408      */
409     function setStakingRequirement(uint256 _amountOfTokens)
410         onlyAdministrator()
411         public
412     {
413         stakingRequirement = _amountOfTokens;
414     }
415     
416     /**
417      * If we want to rebrand, we can.
418      */
419     function setName(string _name)
420         onlyAdministrator()
421         public
422     {
423         name = _name;
424     }
425     
426     /**
427      * If we want to rebrand, we can.
428      */
429     function setSymbol(string _symbol)
430         onlyAdministrator()
431         public
432     {
433         symbol = _symbol;
434     }
435 
436     
437     /*----------  HELPERS AND CALCULATORS  ----------*/
438     /**
439      * Method to view the current Ethereum stored in the contract
440      * Example: totalEthereumBalance()
441      */
442     function totalEthereumBalance()
443         public
444         view
445         returns(uint)
446     {
447         return this.balance;
448     }
449     
450     /**
451      * Retrieve the total token supply.
452      */
453     function totalSupply()
454         public
455         view
456         returns(uint256)
457     {
458         return tokenSupply_;
459     }
460     
461     /**
462      * Retrieve the tokens owned by the caller.
463      */
464     function myTokens()
465         public
466         view
467         returns(uint256)
468     {
469         address _customerAddress = msg.sender;
470         return balanceOf(_customerAddress);
471     }
472     
473     /**
474      * Retrieve the dividends owned by the caller.
475      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
476      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
477      * But in the internal calculations, we want them separate. 
478      */ 
479     function myDividends(bool _includeReferralBonus) 
480         public 
481         view 
482         returns(uint256)
483     {
484         address _customerAddress = msg.sender;
485         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
486     }
487     
488     /**
489      * Retrieve the token balance of any single address.
490      */
491     function balanceOf(address _customerAddress)
492         view
493         public
494         returns(uint256)
495     {
496         return tokenBalanceLedger_[_customerAddress];
497     }
498     
499     /**
500      * Retrieve the dividend balance of any single address.
501      */
502     function dividendsOf(address _customerAddress)
503         view
504         public
505         returns(uint256)
506     {
507         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
508     }
509     
510     /**
511      * Return the buy price of 1 individual token.
512      */
513     function sellPrice() 
514         public 
515         view 
516         returns(uint256)
517     {
518         // our calculation relies on the token supply, so we need supply. Doh.
519         if(tokenSupply_ == 0){
520             return tokenPriceInitial_ - tokenPriceIncremental_;
521         } else {
522             uint256 _ethereum = tokensToEthereum_(1e18);
523             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
524             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
525             return _taxedEthereum;
526         }
527     }
528     
529     /**
530      * Return the sell price of 1 individual token.
531      */
532     function buyPrice() 
533         public 
534         view 
535         returns(uint256)
536     {
537         // our calculation relies on the token supply, so we need supply. Doh.
538         if(tokenSupply_ == 0){
539             return tokenPriceInitial_ + tokenPriceIncremental_;
540         } else {
541             uint256 _ethereum = tokensToEthereum_(1e18);
542             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
543             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
544             return _taxedEthereum;
545         }
546     }
547     
548     /**
549      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
550      */
551     function calculateTokensReceived(uint256 _ethereumToSpend) 
552         public 
553         view 
554         returns(uint256)
555     {
556         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
557         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
558         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
559         
560         return _amountOfTokens;
561     }
562     
563     /**
564      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
565      */
566     function calculateEthereumReceived(uint256 _tokensToSell) 
567         public 
568         view 
569         returns(uint256)
570     {
571         require(_tokensToSell <= tokenSupply_);
572         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
573         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
574         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
575         return _taxedEthereum;
576     }
577     
578     
579     /*==========================================
580     =            INTERNAL FUNCTIONS            =
581     ==========================================*/
582     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
583         antiEarlyWhale(_incomingEthereum)
584         internal
585         returns(uint256)
586     {
587         // data setup
588         address _customerAddress = msg.sender;
589         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
590         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
591         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
592         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
593         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
594         uint256 _fee = _dividends * magnitude;
595  
596         // no point in continuing execution if OP is a poorfag russian hacker
597         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
598         // (or hackers)
599         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
600         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
601         
602         // is the user referred by a masternode?
603         if(
604             // is this a referred purchase?
605             _referredBy != 0x0000000000000000000000000000000000000000 &&
606 
607             // no cheating!
608             _referredBy != _customerAddress &&
609             
610             // does the referrer have at least X whole tokens?
611             // i.e is the referrer a godly chad masternode
612             tokenBalanceLedger_[_referredBy] >= stakingRequirement
613         ){
614             // wealth redistribution
615             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
616         } else {
617             // no ref purchase
618             // add the referral bonus back to the global dividends cake
619             _dividends = SafeMath.add(_dividends, _referralBonus);
620             _fee = _dividends * magnitude;
621         }
622         
623         // we can't give people infinite ethereum
624         if(tokenSupply_ > 0){
625             
626             // add tokens to the pool
627             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
628  
629             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
630             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
631             
632             // calculate the amount of tokens the customer receives over his purchase 
633             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
634         
635         } else {
636             // add tokens to the pool
637             tokenSupply_ = _amountOfTokens;
638         }
639         
640         // update circulating supply & the ledger address for the customer
641         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
642         
643         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
644         //really i know you think you do but you don't
645         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
646         payoutsTo_[_customerAddress] += _updatedPayouts;
647         
648         // fire event
649         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
650         
651         return _amountOfTokens;
652     }
653 
654     /**
655      * Calculate Token price based on an amount of incoming ethereum
656      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
657      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
658      */
659     function ethereumToTokens_(uint256 _ethereum)
660         internal
661         view
662         returns(uint256)
663     {
664         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
665         uint256 _tokensReceived = 
666          (
667             (
668                 // underflow attempts BTFO
669                 SafeMath.sub(
670                     (sqrt
671                         (
672                             (_tokenPriceInitial**2)
673                             +
674                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
675                             +
676                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
677                             +
678                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
679                         )
680                     ), _tokenPriceInitial
681                 )
682             )/(tokenPriceIncremental_)
683         )-(tokenSupply_)
684         ;
685   
686         return _tokensReceived;
687     }
688     
689     /**
690      * Calculate token sell value.
691      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
692      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
693      */
694      function tokensToEthereum_(uint256 _tokens)
695         internal
696         view
697         returns(uint256)
698     {
699 
700         uint256 tokens_ = (_tokens + 1e18);
701         uint256 _tokenSupply = (tokenSupply_ + 1e18);
702         uint256 _etherReceived =
703         (
704             // underflow attempts BTFO
705             SafeMath.sub(
706                 (
707                     (
708                         (
709                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
710                         )-tokenPriceIncremental_
711                     )*(tokens_ - 1e18)
712                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
713             )
714         /1e18);
715         return _etherReceived;
716     }
717     
718     
719     //This is where all your gas goes, sorry
720     //Not sorry, you probably only paid 1 gwei
721     function sqrt(uint x) internal pure returns (uint y) {
722         uint z = (x + 1) / 2;
723         y = x;
724         while (z < y) {
725             y = z;
726             z = (x / z + z) / 2;
727         }
728     }
729 }
730 
731 /**
732  * @title SafeMath
733  * @dev Math operations with safety checks that throw on error
734  */
735 library SafeMath {
736 
737     /**
738     * @dev Multiplies two numbers, throws on overflow.
739     */
740     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
741         if (a == 0) {
742             return 0;
743         }
744         uint256 c = a * b;
745         assert(c / a == b);
746         return c;
747     }
748 
749     /**
750     * @dev Integer division of two numbers, truncating the quotient.
751     */
752     function div(uint256 a, uint256 b) internal pure returns (uint256) {
753         // assert(b > 0); // Solidity automatically throws when dividing by 0
754         uint256 c = a / b;
755         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
756         return c;
757     }
758 
759     /**
760     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
761     */
762     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
763         assert(b <= a);
764         return a - b;
765     }
766 
767     /**
768     * @dev Adds two numbers, throws on overflow.
769     */
770     function add(uint256 a, uint256 b) internal pure returns (uint256) {
771         uint256 c = a + b;
772         assert(c >= a);
773         return c;
774     }
775 }