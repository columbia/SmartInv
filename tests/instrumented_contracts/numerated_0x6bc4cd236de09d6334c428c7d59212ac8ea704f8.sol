1 pragma solidity ^0.4.21;
2 
3 /**
4   https://goldenmoon.io  https://goldenmoon.io  https://goldenmoon.io  https://goldenmoon.io  https://goldenmoon.io
5 
6                              ______      __    __              __  ___                
7                             / ____/___  / /___/ /__  ____     /  |/  /___  ____  ____ 
8                            / / __/ __ \/ / __  / _ \/ __ \   / /|_/ / __ \/ __ \/ __ \
9                           / /_/ / /_/ / / /_/ /  __/ / / /  / /  / / /_/ / /_/ / / / /
10                           \____/\____/_/\__,_/\___/_/ /_/  /_/  /_/\____/\____/_/ /_/ 
11                                                             
12 															
13 A pyramid scheme, 25% buy and sell fee contract with fair distributed tokens among investors. GMOON tokens used on games which will be released after pyramid launch on 19th 10pm EST.
14 
15 Credits
16 =======
17 
18 Contract Developer:
19    > GoldenMoon
20 
21 Front-End Design:
22    > roman25
23 
24 **/
25 
26 contract AcceptsGMOON {
27     GMOON public tokenContract;
28 
29     function AcceptsGMOON(address _tokenContract) public {
30         tokenContract = GMOON(_tokenContract);
31     }
32 
33     modifier onlyTokenContract {
34         require(msg.sender == address(tokenContract));
35         _;
36     }
37 
38     /**
39     * @dev Standard ERC677 function that will handle incoming token transfers.
40     *
41     * @param _from  Token sender address.
42     * @param _value Amount of tokens.
43     * @param _data  Transaction metadata.
44     */
45     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
46 }
47 
48 
49 contract GMOON {
50     /*=================================
51     =            MODIFIERS            =
52     =================================*/
53     // only people with tokens
54     modifier onlyBagholders() {
55         require(myTokens() > 0);
56         _;
57     }
58 
59     // only people with profits
60     modifier onlyStronghands() {
61         require(myDividends(true) > 0);
62         _;
63     }
64 
65     modifier notContract() {
66       require (msg.sender == tx.origin);
67       _;
68     }
69 
70     // administrators can:
71     // -> change the name of the contract
72     // -> change the name of the token
73     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
74     // they CANNOT:
75     // -> take funds
76     // -> disable withdrawals
77     // -> kill the contract
78     // -> change the price of tokens
79     modifier onlyAdministrator(){
80         address _customerAddress = msg.sender;
81         require(administrators[_customerAddress]);
82         _;
83     }
84 
85 	//Public sale opens (token purchase) at 10pm EST / 10am China / 9am South Korea
86 	uint activatePublicPurchase = 1535248800;
87 
88 
89     // ensures that the first tokens in the contract will be equally distributed
90     // meaning, no divine dump will be ever possible
91     // result: healthy longevity.
92     modifier antiEarlyWhale(uint256 _amountOfEthereum){
93         address _customerAddress = msg.sender;
94 		
95 		//Activate the timer for public sale (token purchase) at 10pm EST / 10am China / 9am South Korea
96 		if (now >= activatePublicPurchase) {
97             onlyAmbassadors = false;
98         }
99 
100         // are we still in the vulnerable phase?
101         // if so, enact anti early whale protocol
102         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
103             require(
104                 // is the customer in the ambassador list?
105                 ambassadors_[_customerAddress] == true &&
106 
107                 // does the customer purchase exceed the max ambassador quota?
108                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
109 
110             );
111 
112             // updated the accumulated quota
113             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
114 
115             // execute
116             _;
117         } else {
118             // in case the ether count drops low, the ambassador phase won't reinitiate
119             onlyAmbassadors = false;
120             _;
121         }
122 
123     }
124 
125     /*==============================
126     =            EVENTS            =
127     ==============================*/
128     event onTokenPurchase(
129         address indexed customerAddress,
130         uint256 incomingEthereum,
131         uint256 tokensMinted,
132         address indexed referredBy
133     );
134 
135     event onTokenSell(
136         address indexed customerAddress,
137         uint256 tokensBurned,
138         uint256 ethereumEarned
139     );
140 
141     event onReinvestment(
142         address indexed customerAddress,
143         uint256 ethereumReinvested,
144         uint256 tokensMinted
145     );
146 
147     event onWithdraw(
148         address indexed customerAddress,
149         uint256 ethereumWithdrawn
150     );
151     
152     event OnRedistribution (		
153 		uint256 amount,		
154 		uint256 timestamp		
155     );
156 
157     // ERC20
158     event Transfer(
159         address indexed from,
160         address indexed to,
161         uint256 tokens
162     );
163 
164 
165     /*=====================================
166     =            CONFIGURABLES            =
167     =====================================*/
168     string public name = "GoldenMoon";
169     string public symbol = "GMOON";
170     uint8 constant public decimals = 18;
171     uint8 constant internal dividendFee_ = 25; // 25% dividend fee on each buy and sell
172     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
173     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
174     uint256 constant internal magnitude = 2**64;
175 
176     // proof of stake (defaults at 1 tokens)
177     uint256 public stakingRequirement = 1e18;
178 
179     // ambassador program
180     mapping(address => bool) internal ambassadors_;
181     uint256 constant internal ambassadorMaxPurchase_ = .3 ether;
182     uint256 constant internal ambassadorQuota_ = 3 ether;
183 
184 
185 
186    /*================================
187     =            DATASETS            =
188     ================================*/
189     // amount of shares for each address (scaled number)
190     mapping(address => uint256) internal tokenBalanceLedger_;
191     mapping(address => uint256) internal referralBalance_;
192     mapping(address => int256) internal payoutsTo_;
193     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
194     uint256 internal tokenSupply_ = 0;
195     uint256 internal profitPerShare_;
196 
197     // administrator list (see above on what they can do)
198     mapping(address => bool) public administrators;
199 
200     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper game)
201     bool public onlyAmbassadors = true;
202 
203     // Special GoldenMoon Platform control from scam game contracts on GoldenMoon platform
204     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept GMOON tokens
205 
206 
207 
208     /*=======================================
209     =            PUBLIC FUNCTIONS            =
210     =======================================*/
211     /*
212     * -- APPLICATION ENTRY POINTS --
213     */
214     function GMOON()
215         public
216     {
217         // administrators
218 		
219 		administrators[0x9C98A3eE07F53b3BFAd5Aa83a62Ac96600aED8b5] = true;
220         administrators[0xe0212f02C1AD10f3DDA645F4F9775a0e3604d0B5] = true;
221 
222         // ambassadors - goldenmoon (main dev)
223         ambassadors_[0x9C98A3eE07F53b3BFAd5Aa83a62Ac96600aED8b5] = true;
224 		
225 		 // ambassadors - roman25 (front end dev)
226         ambassadors_[0xe0212f02C1AD10f3DDA645F4F9775a0e3604d0B5] = true;
227 		
228 		 // ambassadors - Ravi
229         ambassadors_[0x41a21b264F9ebF6cF571D4543a5b3AB1c6bEd98C] = true;
230 		
231 		 // ambassadors - Amit
232         ambassadors_[0x421D7643Cf71b704c0E13d23f34bE18846237574] = true;
233 		
234 		 // ambassadors - Xrypto
235         ambassadors_[0xD5FA3017A6af76b31eB093DFA527eE1D939f05ea] = true;
236 		
237 		 // ambassadors - Khan.Among.Lions.Amid.Pyramids
238         ambassadors_[0x05f2c11996d73288AbE8a31d8b593a693FF2E5D8] = true;
239 		
240 		 // ambassadors - yobo
241         ambassadors_[0x190A2409fc6434483D4c2CAb804E75e3Bc5ebFa6] = true;
242 		
243 		 // ambassadors - Flytothemars
244         ambassadors_[0xAdcc19C8873193223460F67552ddec01C16CE32E] = true;
245 		
246 		// ambassadors - udaman
247         ambassadors_[0xEE22F8Ca234C8Ca35c22593ac5524643B8136bdF] = true;
248 		
249 		// ambassadors - Jacksonkid
250         ambassadors_[0xc7F15d0238d207e19cce6bd6C0B85f343896F046] = true;
251         
252     }
253 
254 
255     /**
256      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
257      */
258     function buy(address _referredBy)
259         public
260         payable
261         returns(uint256)
262     {
263 		require(tx.gasprice <= 0.05 szabo);	
264         purchaseInternal(msg.value, _referredBy);
265     }
266 
267     /**
268      * Fallback function to handle ethereum that was send straight to the contract
269      * Unfortunately we cannot use a referral address this way.
270      */
271     function()
272         payable
273         public
274     {
275 		//Max gas limit 50 Gwei( to avoid gas war especialy in early stage )
276         require(tx.gasprice <= 0.05 szabo);	
277         purchaseInternal(msg.value, 0x0);
278     }
279 
280     /**
281      * Converts all of caller's dividends to tokens.
282      */
283     function reinvest()
284         onlyStronghands()
285         public
286     {
287         // fetch dividends
288         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
289 
290         // pay out the dividends virtually
291         address _customerAddress = msg.sender;
292         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
293 
294         // retrieve ref. bonus
295         _dividends += referralBalance_[_customerAddress];
296         referralBalance_[_customerAddress] = 0;
297 
298         // dispatch a buy order with the virtualized "withdrawn dividends"
299         uint256 _tokens = purchaseTokens(_dividends, 0x0);
300 
301         // fire event
302         emit onReinvestment(_customerAddress, _dividends, _tokens);
303     }
304 
305     /**
306      * Alias of sell() and withdraw().
307      */
308     function exit()
309         public
310     {
311         // get token count for caller & sell them all
312         address _customerAddress = msg.sender;
313         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
314         if(_tokens > 0) sell(_tokens);
315 
316         // lambo delivery service
317         withdraw();
318     }
319 
320     /**
321      * Withdraws all of the callers earnings.
322      */
323     function withdraw()
324         onlyStronghands()
325         public
326     {
327         // setup data
328         address _customerAddress = msg.sender;
329         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
330 
331         // update dividend tracker
332         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
333 
334         // add ref. bonus
335         _dividends += referralBalance_[_customerAddress];
336         referralBalance_[_customerAddress] = 0;
337 
338         // lambo delivery service
339         _customerAddress.transfer(_dividends);
340 
341         // fire event
342         emit onWithdraw(_customerAddress, _dividends);
343     }
344 
345     /**
346      * Liquifies tokens to ethereum.
347      */
348     function sell(uint256 _amountOfTokens)
349         onlyBagholders()
350         public
351     {
352         // setup data
353         address _customerAddress = msg.sender;
354         // russian hackers BTFO
355         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
356         uint256 _tokens = _amountOfTokens;
357         uint256 _ethereum = tokensToEthereum_(_tokens);
358 
359         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
360        
361         // Take out dividends
362         uint256 _taxedEthereum =  SafeMath.sub(_ethereum, _dividends);
363 
364         // burn the sold tokens
365         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
366         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
367 
368         // update dividends tracker
369         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
370         payoutsTo_[_customerAddress] -= _updatedPayouts;
371 
372         // dividing by zero is a bad idea
373         if (tokenSupply_ > 0) {
374             // update the amount of dividends per token
375             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
376         }
377 
378         // fire event
379         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
380     }
381 
382 
383     /**
384      * Transfer tokens from the caller to a new holder.
385      * REMEMBER THIS IS 0% TRANSFER FEE
386      */
387     function transfer(address _toAddress, uint256 _amountOfTokens)
388         onlyBagholders()
389         public
390         returns(bool)
391     {
392         // setup
393         address _customerAddress = msg.sender;
394 
395         // make sure we have the requested tokens
396         // also disables transfers until ambassador phase is over
397         // ( we dont want whale premines )
398         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
399 
400         // withdraw all outstanding dividends first
401         if(myDividends(true) > 0) withdraw();
402 
403         // exchange tokens
404         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
405         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
406 
407         // update dividend trackers
408         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
409         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
410 
411 
412         // fire event
413         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
414 
415         // ERC20
416         return true;
417     }
418 
419     /**
420     * Transfer token to a specified address and forward the data to recipient
421     * ERC-677 standard
422     * https://github.com/ethereum/EIPs/issues/677
423     * @param _to    Receiver address.
424     * @param _value Amount of tokens that will be transferred.
425     * @param _data  Transaction metadata.
426     */
427     function transferAndCall(address _to, uint256 _value, bytes _data) external returns (bool) {
428       require(_to != address(0));
429       require(canAcceptTokens_[_to] == true); // security check that contract approved by GoldenMoon platform
430       require(transfer(_to, _value)); // do a normal token transfer to the contract
431 
432       if (isContract(_to)) {
433         AcceptsGMOON receiver = AcceptsGMOON(_to);
434         require(receiver.tokenFallback(msg.sender, _value, _data));
435       }
436 
437       return true;
438     }
439 
440     /**
441      * Additional check that the game address we are sending tokens to is a contract
442      * assemble the given address bytecode. If bytecode exists then the _addr is a contract.
443      */
444      function isContract(address _addr) private constant returns (bool is_contract) {
445        // retrieve the size of the code on target address, this needs assembly
446        uint length;
447        assembly { length := extcodesize(_addr) }
448        return length > 0;
449      }
450 
451     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
452     /**
453      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
454      */
455     function disableInitialStage()
456         onlyAdministrator()
457         public
458     {
459         onlyAmbassadors = false;
460     }
461 
462     /**
463      * In case one of us dies, we need to replace ourselves.
464      */
465     function setAdministrator(address _identifier, bool _status)
466         onlyAdministrator()
467         public
468     {
469         administrators[_identifier] = _status;
470     }
471 
472     /**
473      * Precautionary measures in case we need to adjust the masternode rate.
474      */
475     function setStakingRequirement(uint256 _amountOfTokens)
476         onlyAdministrator()
477         public
478     {
479         stakingRequirement = _amountOfTokens;
480     }
481 
482     /**
483      * Add or remove game contract, which can accept GMOON tokens
484      */
485     function setCanAcceptTokens(address _address, bool _value)
486       onlyAdministrator()
487       public
488     {
489       canAcceptTokens_[_address] = _value;
490     }
491 
492     /**
493      * If we want to rebrand, we can.
494      */
495     function setName(string _name)
496         onlyAdministrator()
497         public
498     {
499         name = _name;
500     }
501 
502     /**
503      * If we want to rebrand, we can.
504      */
505     function setSymbol(string _symbol)
506         onlyAdministrator()
507         public
508     {
509         symbol = _symbol;
510     }
511 
512 
513     /*----------  HELPERS AND CALCULATORS  ----------*/
514     /**
515      * Method to view the current Ethereum stored in the contract
516      * Example: totalEthereumBalance()
517      */
518     function totalEthereumBalance()
519         public
520         view
521         returns(uint)
522     {
523         return address(this).balance;
524     }
525 
526     /**
527      * Retrieve the total token supply.
528      */
529     function totalSupply()
530         public
531         view
532         returns(uint256)
533     {
534         return tokenSupply_;
535     }
536 
537     /**
538      * Retrieve the tokens owned by the caller.
539      */
540     function myTokens()
541         public
542         view
543         returns(uint256)
544     {
545         address _customerAddress = msg.sender;
546         return balanceOf(_customerAddress);
547     }
548 
549     /**
550      * Retrieve the dividends owned by the caller.
551      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
552      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
553      * But in the internal calculations, we want them separate.
554      */
555     function myDividends(bool _includeReferralBonus)
556         public
557         view
558         returns(uint256)
559     {
560         address _customerAddress = msg.sender;
561         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
562     }
563 
564     /**
565      * Retrieve the token balance of any single address.
566      */
567     function balanceOf(address _customerAddress)
568         view
569         public
570         returns(uint256)
571     {
572         return tokenBalanceLedger_[_customerAddress];
573     }
574 
575     /**
576      * Retrieve the dividend balance of any single address.
577      */
578     function dividendsOf(address _customerAddress)
579         view
580         public
581         returns(uint256)
582     {
583         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
584     }
585 
586     /**
587      * Return the buy price of 1 individual token.
588      */
589     function sellPrice()
590         public
591         view
592         returns(uint256)
593     {
594         // our calculation relies on the token supply, so we need supply. Doh.
595         if(tokenSupply_ == 0){
596             return tokenPriceInitial_ - tokenPriceIncremental_;
597         } else {
598             uint256 _ethereum = tokensToEthereum_(1e18);
599             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
600             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
601             return _taxedEthereum;
602         }
603     }
604 
605     /**
606      * Return the sell price of 1 individual token.
607      */
608     function buyPrice()
609         public
610         view
611         returns(uint256)
612     {
613         // our calculation relies on the token supply, so we need supply. Doh.
614         if(tokenSupply_ == 0){
615             return tokenPriceInitial_ + tokenPriceIncremental_;
616         } else {
617             uint256 _ethereum = tokensToEthereum_(1e18);
618             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
619             uint256 _taxedEthereum =  SafeMath.add(_ethereum, _dividends);
620             return _taxedEthereum;
621         }
622     }
623 
624     /**
625      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
626      */
627     function calculateTokensReceived(uint256 _ethereumToSpend)
628         public
629         view
630         returns(uint256)
631     {
632         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, dividendFee_), 100);
633         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
634         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
635         return _amountOfTokens;
636     }
637 
638     /**
639      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
640      */
641     function calculateEthereumReceived(uint256 _tokensToSell)
642         public
643         view
644         returns(uint256)
645     {
646         require(_tokensToSell <= tokenSupply_);
647         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
648         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
649         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
650         return _taxedEthereum;
651     }
652 
653 
654     /*==========================================
655     =            INTERNAL FUNCTIONS            =
656     ==========================================*/
657 
658     // Make sure we will send back excess if user sends more then 3 ether before 100 ETH in contract
659     function purchaseInternal(uint256 _incomingEthereum, address _referredBy)
660       notContract()// no contracts allowed
661       internal
662       returns(uint256) {
663 
664       uint256 purchaseEthereum = _incomingEthereum;
665       uint256 excess;
666       if(purchaseEthereum > 3 ether) { // check if the transaction is over 3 ether
667           if (SafeMath.sub(address(this).balance, purchaseEthereum) <= 100 ether) { // if so check the contract is less then 100 ether
668               purchaseEthereum = 3 ether;
669               excess = SafeMath.sub(_incomingEthereum, purchaseEthereum);
670           }
671       }
672 
673       purchaseTokens(purchaseEthereum, _referredBy);
674 
675       if (excess > 0) {
676         msg.sender.transfer(excess);
677       }
678     }
679 
680 
681     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
682         antiEarlyWhale(_incomingEthereum)
683         internal
684         returns(uint256)
685     {
686         // data setup
687         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);
688         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
689         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
690         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
691 
692         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
693         uint256 _fee = _dividends * magnitude;
694 
695         // no point in continuing execution if OP is a poorfag russian hacker
696         // prevents overflow in the case that the game somehow magically starts being used by everyone in the world
697         // (or hackers)
698         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
699         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
700 
701         // is the user referred by a masternode?
702         if(
703             // is this a referred purchase?
704             _referredBy != 0x0000000000000000000000000000000000000000 &&
705 
706             // no cheating!
707             _referredBy != msg.sender &&
708 
709             // does the referrer have at least X whole tokens?
710             // i.e is the referrer a godly chad masternode
711             tokenBalanceLedger_[_referredBy] >= stakingRequirement
712         ){
713             // wealth redistribution
714             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
715         } else {
716             // no ref purchase
717             // add the referral bonus back to the global dividends cake
718             _dividends = SafeMath.add(_dividends, _referralBonus);
719             _fee = _dividends * magnitude;
720         }
721 
722         // we can't give people infinite ethereum
723         if(tokenSupply_ > 0){
724 
725             // add tokens to the pool
726             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
727 
728             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
729             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
730 
731             // calculate the amount of tokens the customer receives over his purchase
732             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
733 
734         } else {
735             // add tokens to the pool
736             tokenSupply_ = _amountOfTokens;
737         }
738 
739         // update circulating supply & the ledger address for the customer
740         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
741 
742         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
743         //really i know you think you do but you don't
744         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
745         payoutsTo_[msg.sender] += _updatedPayouts;
746 
747         // fire event
748         emit onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
749 
750         return _amountOfTokens;
751     }
752 
753     /**
754      * Calculate Token price based on an amount of incoming ethereum
755      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
756      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
757      */
758     function ethereumToTokens_(uint256 _ethereum)
759         internal
760         view
761         returns(uint256)
762     {
763         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
764         uint256 _tokensReceived =
765          (
766             (
767                 // underflow attempts BTFO
768                 SafeMath.sub(
769                     (sqrt
770                         (
771                             (_tokenPriceInitial**2)
772                             +
773                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
774                             +
775                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
776                             +
777                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
778                         )
779                     ), _tokenPriceInitial
780                 )
781             )/(tokenPriceIncremental_)
782         )-(tokenSupply_)
783         ;
784 
785         return _tokensReceived;
786     }
787 
788     /**
789      * Calculate token sell value.
790      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
791      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
792      */
793      function tokensToEthereum_(uint256 _tokens)
794         internal
795         view
796         returns(uint256)
797     {
798 
799         uint256 tokens_ = (_tokens + 1e18);
800         uint256 _tokenSupply = (tokenSupply_ + 1e18);
801         uint256 _etherReceived =
802         (
803             // underflow attempts BTFO
804             SafeMath.sub(
805                 (
806                     (
807                         (
808                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
809                         )-tokenPriceIncremental_
810                     )*(tokens_ - 1e18)
811                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
812             )
813         /1e18);
814         return _etherReceived;
815     }
816 
817 
818     //This is where all your gas goes, sorry
819     //Not sorry, you probably only paid 1 gwei
820     function sqrt(uint x) internal pure returns (uint y) {
821         uint z = (x + 1) / 2;
822         y = x;
823         while (z < y) {
824             y = z;
825             z = (x / z + z) / 2;
826         }
827     }
828 }
829 
830 /**
831  * @title SafeMath
832  * @dev Math operations with safety checks that throw on error
833  */
834 library SafeMath {
835 
836     /**
837     * @dev Multiplies two numbers, throws on overflow.
838     */
839     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
840         if (a == 0) {
841             return 0;
842         }
843         uint256 c = a * b;
844         assert(c / a == b);
845         return c;
846     }
847 
848     /**
849     * @dev Integer division of two numbers, truncating the quotient.
850     */
851     function div(uint256 a, uint256 b) internal pure returns (uint256) {
852         // assert(b > 0); // Solidity automatically throws when dividing by 0
853         uint256 c = a / b;
854         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
855         return c;
856     }
857 
858     /**
859     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
860     */
861     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
862         assert(b <= a);
863         return a - b;
864     }
865 
866     /**
867     * @dev Adds two numbers, throws on overflow.
868     */
869     function add(uint256 a, uint256 b) internal pure returns (uint256) {
870         uint256 c = a + b;
871         assert(c >= a);
872         return c;
873     }
874 }