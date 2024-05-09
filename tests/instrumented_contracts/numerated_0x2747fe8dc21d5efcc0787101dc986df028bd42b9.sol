1 pragma solidity ^0.4.25;
2 
3 /*
4 ██╗  ██╗██╗   ██╗██████╗ ███████╗██████╗ ███████╗████████╗██╗  ██╗
5 ██║  ██║╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗██╔════╝╚══██╔══╝██║  ██║
6 ███████║ ╚████╔╝ ██████╔╝█████╗  ██████╔╝█████╗     ██║   ███████║
7 ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══╝  ██╔══██╗██╔══╝     ██║   ██╔══██║
8 ██║  ██║   ██║   ██║     ███████╗██║  ██║███████╗   ██║   ██║  ██║
9 ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝
10 Sepcial thanks to P3D & HODL(tobi) basecode & modification 
11 HyperETH - 2019
12 Decentralized Blockchain Gaming Ecosystem 
13 Smart Contract & Web Games
14 */
15 
16 
17 contract AcceptsHyperETH {
18     HyperETH public tokenContract;
19 
20     constructor(address _tokenContract) public {
21         tokenContract = HyperETH(_tokenContract);
22     }
23 
24     modifier onlyTokenContract {
25         require(msg.sender == address(tokenContract));
26         _;
27     }
28 
29     /**
30     * @dev Standard ERC677 function that will handle incoming token transfers.
31     *
32     * @param _from  Token sender address.
33     * @param _value Amount of tokens.
34     * @param _data  Transaction metadata.
35     */
36     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
37 }
38 
39 contract HyperETH {
40     /*=================================
41     =            MODIFIERS            =
42     =================================*/
43     // only people with tokens
44     modifier onlyBagholders() {
45         require(myTokens() > 0);
46         _;
47     }
48     
49     // only people with profits
50     modifier onlyStronghands() {
51         require(myDividends(true) > 0);
52         _;
53     }
54     
55     // administrator can:
56     // -> change the name of the contract
57     // -> change the name of the token
58     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
59     // they CANNOT:
60     // -> take funds, except the funding contract
61     // -> disable withdrawals
62     // -> kill the contract
63     // -> change the price of tokens
64     modifier onlyAdministrator(){
65         address _customerAddress = msg.sender;
66         require(administrator == _customerAddress);
67         _;
68     }
69     
70     // ensures that the first tokens in the contract will be equally distributed
71     // meaning, no divine dump will be ever possible
72     // result: healthy longevity.
73     modifier antiEarlyWhale(uint256 _amountOfEthereum){
74         address _customerAddress = msg.sender;
75         
76         // are we still in the vulnerable phase?
77         // if so, enact anti early whale protocol 
78         if( onlyAmbassadors && 
79 			((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ ) &&
80 			now < ACTIVATION_TIME)
81 		{
82             require(
83                 // is the customer in the ambassador list?
84                 ambassadors_[_customerAddress] == true &&
85                 
86                 // does the customer purchase exceed the max ambassador quota?
87                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
88                 
89             );
90             
91             // updated the accumulated quota    
92             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
93         
94         } else {
95             // in case the ether count drops low, the ambassador phase won't reinitiate
96 			// only write state variable once
97 			if (onlyAmbassadors) {
98 				onlyAmbassadors = false;
99 			}
100         }
101 		
102 		_;
103     }
104 	
105 	// ambassadors are not allowed to sell their tokens within the anti-pump-and-dump phase
106 	// @Sordren
107 	// hopefully many devs will use this as a standard
108 	modifier ambassAntiPumpAndDump() {
109 		
110 		// we are still in ambassadors antiPumpAndDump phase
111 		if (now <= antiPumpAndDumpEnd_) {
112 			address _customerAddress = msg.sender;
113 			
114 			// require sender is not an ambassador
115 			require(!ambassadors_[_customerAddress]);
116 		}
117 	
118 		// execute
119 		_;
120 	}
121 	
122 	// ambassadors are not allowed to transfer tokens to non-amassador accounts within the anti-pump-and-dump phase
123 	// @Sordren
124 	modifier ambassOnlyToAmbass(address _to) {
125 		
126 		// we are still in ambassadors antiPumpAndDump phase
127 		if (now <= antiPumpAndDumpEnd_){
128 			address _from = msg.sender;
129 			
130 			// sender is ambassador
131 			if (ambassadors_[_from]) {
132 				
133 				// sender is not the lending
134 				// this is required for withdrawing capital from lending
135 				if (_from != lendingAddress_) {
136 					// require receiver is ambassador
137 					require(ambassadors_[_to], "As ambassador you should know better :P");
138 				}
139 			}
140 		}
141 		
142 		// execute
143 		_;
144 	}
145     
146     
147     /*==============================
148     =            EVENTS            =
149     ==============================*/
150     event onTokenPurchase(
151         address indexed customerAddress,
152         uint256 incomingEthereum,
153         uint256 tokensMinted,
154         address indexed referredBy
155     );
156     
157     event onTokenSell(
158         address indexed customerAddress,
159         uint256 tokensBurned,
160         uint256 ethereumEarned
161     );
162     
163     event onReinvestment(
164         address indexed customerAddress,
165         uint256 ethereumReinvested,
166         uint256 tokensMinted
167     );
168     
169     event onWithdraw(
170         address indexed customerAddress,
171         uint256 ethereumWithdrawn
172     );
173     
174     // ERC20
175     event Transfer(
176         address indexed from,
177         address indexed to,
178         uint256 tokens
179     );
180     
181     
182     /*=====================================
183     =            CONFIGURABLES            =
184     =====================================*/
185     string public name = "Hyper Token";
186     string public symbol = "HYPER";
187     uint8 constant public decimals = 18;
188     uint8 constant internal dividendFee_ = 10;	// 10% dividend dispersement
189 	uint8 constant internal fundFee_ = 3; 		// 3% development fund
190 	uint8 constant internal referralBonus_ = 10;
191     uint256 constant internal tokenPriceInitial_ =     0.000000001 ether;
192     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
193     uint256 constant internal magnitude = 2**64;	
194     
195     // proof of stake (defaults at 100 tokens)
196     uint256 public stakingRequirement = 100e18;
197     
198     // ambassador program
199     uint256 constant internal ambassadorMaxPurchase_ = 2 ether;
200     uint256 constant internal ambassadorQuota_ = 2 ether;
201 	
202 	// anti pump and dump phase time (default 30 days)
203 	uint256 constant internal antiPumpAndDumpTime_ = 30 days;								// remember it is constant, so it cannot be changed after deployment
204 	uint256 constant public antiPumpAndDumpEnd_ = ACTIVATION_TIME + antiPumpAndDumpTime_;	// set anti-pump-and-dump time to 30 days after deploying
205 	uint256 constant internal ACTIVATION_TIME = 1541966400;
206 	
207 	// when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
208     bool public onlyAmbassadors = true;
209     
210     
211    /*================================
212     =            DATASETS            =
213     ================================*/
214     // amount of shares for each address (scaled number)
215     mapping(address => uint256) internal tokenBalanceLedger_;
216     mapping(address => uint256) internal referralBalance_;
217     mapping(address => int256) internal payoutsTo_;
218 	mapping(address => address) internal lastRef_;
219     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
220     uint256 internal tokenSupply_ = 0;
221     uint256 internal profitPerShare_;
222     
223     // administrator (see above on what they can do)
224     address internal administrator;
225 	
226 	// staking address
227 	address internal lendingAddress_;
228 	
229 	// Address to send the 3% fee
230     address public fundAddress_;
231     uint256 internal totalEthFundReceived; 		// total ETH received from this contract
232     uint256 internal totalEthFundCollected; 	// total ETH collected in this contract
233 	
234 	// ambassador program
235 	mapping(address => bool) internal ambassadors_;
236 	
237 	// Special HYPER Platform control from scam game contracts on HYPER platform
238     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept HYPER tokens
239 
240 
241     /*=======================================
242     =            PUBLIC FUNCTIONS            =
243     =======================================*/
244     /*
245     * -- APPLICATION ENTRY POINTS --  
246     */
247     constructor()
248         public
249     {
250         // add administrators here
251         administrator = 0x73018870D10173ae6F71Cac3047ED3b6d175F274;
252 		fundAddress_ = 0xFa48ee5030771E39bc0F89046bF5BeECb65dcf27;
253 		lendingAddress_ = 0xa206d217c0642735e82a6b11547bf00659623163;
254         
255         // add the ambassadors here.
256         ambassadors_[0x73018870D10173ae6F71Cac3047ED3b6d175F274] = true;	// dev team
257 		ambassadors_[lendingAddress_] 							 = true;	// staking, to be the first to buy tokens
258 		ambassadors_[fundAddress_]								 = true;	// fund, to be able to be masternode
259 		
260 		// set lending ref
261 		lastRef_[lendingAddress_] = fundAddress_;
262     }
263     
264      
265     /**
266      * Converts all incoming ethereum to tokens for the caller, and passes down the referral
267      */
268     function buy(address _referredBy)
269         public
270         payable
271         returns(uint256)
272     {
273 		require(tx.gasprice <= 0.05 szabo);
274 		address _lastRef = handleLastRef(_referredBy);
275 		purchaseInternal(msg.value, _lastRef);
276     }
277     
278     /**
279      * Fallback function to handle ethereum that was send straight to the contract
280      * Unfortunately we cannot use a referral address this way.
281      */
282     function()
283         payable
284         external
285     {
286 		require(tx.gasprice <= 0.05 szabo);
287 		address lastRef = handleLastRef(address(0));	// hopefully (for you) you used a referral somewhere in the past
288 		purchaseInternal(msg.value, lastRef);
289     }
290     
291     /**
292      * Converts all of caller's dividends to tokens.
293      */
294     function reinvest()
295         onlyStronghands()
296         public
297     {
298         // fetch dividends
299         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
300         
301         // pay out the dividends virtually
302         address _customerAddress = msg.sender;
303         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
304         
305         // retrieve ref. bonus
306         _dividends += referralBalance_[_customerAddress];
307         referralBalance_[_customerAddress] = 0;
308         
309         // dispatch a buy order with the virtualized "withdrawn dividends"
310 		address _lastRef = handleLastRef(address(0));	// hopefully you used a referral somewhere in the past
311         uint256 _tokens = purchaseInternal(_dividends, _lastRef);
312         
313         // fire event
314         emit onReinvestment(_customerAddress, _dividends, _tokens);
315     }
316     
317     /**
318      * Alias of sell() and withdraw().
319      */
320     function exit()
321         public
322     {
323         // get token count for caller & sell them all
324         address _customerAddress = msg.sender;
325         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
326         if(_tokens > 0) sell(_tokens);
327         
328         // lambo delivery service
329         withdraw();
330     }
331 
332     /**
333      * Withdraws all of the callers earnings.
334      */
335     function withdraw()
336         onlyStronghands()
337         public
338     {
339         // setup data
340         address _customerAddress = msg.sender;
341         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
342         
343         // update dividend tracker
344         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
345         
346         // add ref. bonus
347         _dividends += referralBalance_[_customerAddress];
348         referralBalance_[_customerAddress] = 0;
349         
350         // lambo delivery service
351         _customerAddress.transfer(_dividends);
352         
353         // fire event
354         emit onWithdraw(_customerAddress, _dividends);
355     }
356     
357     /**
358      * Liquifies tokens to ethereum.
359      */
360     function sell(uint256 _amountOfTokens)
361         onlyBagholders()
362 		ambassAntiPumpAndDump()
363         public
364     {
365         // setup data
366         address _customerAddress = msg.sender;
367         // russian hackers BTFO
368         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
369         uint256 _tokens = _amountOfTokens;
370         uint256 _ethereum = tokensToEthereum_(_tokens);
371         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);				// 10%
372 		uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);					// 3%
373         uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);	// Take out dividends and then _fundPayout
374 		
375 		// Add ethereum for fund
376         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
377         
378         // burn the sold tokens
379         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
380         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
381         
382         // update dividends tracker
383         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
384         payoutsTo_[_customerAddress] -= _updatedPayouts;
385         
386         // dividing by zero is a bad idea
387         if (tokenSupply_ > 0) {
388             // update the amount of dividends per token
389             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
390         }
391         
392         // fire event
393         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
394     }
395     
396     
397     /**
398      * Transfer tokens from the caller to a new holder.
399      * Remember, there's 0% fee here.
400      */
401     function transfer(address _toAddress, uint256 _amountOfTokens)
402         onlyBagholders()
403 		ambassOnlyToAmbass(_toAddress)
404         public
405         returns(bool)
406     {
407         // setup
408         address _customerAddress = msg.sender;
409         
410         // make sure we have the requested tokens
411         // also disables transfers until ambassador phase is over
412         // ( we dont want whale premines )
413         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
414         
415         // withdraw all outstanding dividends first
416         if(myDividends(true) > 0) withdraw();
417 
418         // exchange tokens
419         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
420         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
421 		
422 		// update dividend trackers
423         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
424         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
425         
426         // fire event
427         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
428         
429         // ERC20
430         return true;
431     }
432 	
433 	/**
434     * Transfer token to a specified address and forward the data to recipient
435     * ERC-677 standard
436     * https://github.com/ethereum/EIPs/issues/677
437     * @param _to    Receiver address.
438     * @param _value Amount of tokens that will be transferred.
439     * @param _data  Transaction metadata.
440     */
441     function transferAndCall(address _to, uint256 _value, bytes _data)
442 		external
443 		returns (bool) 
444 	{
445 		require(_to != address(0));
446 		require(canAcceptTokens_[_to] == true); 	// security check that contract approved by HYPER platform
447 		require(transfer(_to, _value)); 			// do a normal token transfer to the contract
448 
449 		if (isContract(_to)) {
450 			AcceptsHyperETH receiver = AcceptsHyperETH(_to);
451 			require(receiver.tokenFallback(msg.sender, _value, _data));
452 		}
453 
454 		return true;
455     }
456 
457     /**
458      * Additional check that the game address we are sending tokens to is a contract
459      * assemble the given address bytecode. If bytecode exists then the _addr is a contract.
460      */
461      function isContract(address _addr) 
462 		private 
463 		constant 
464 		returns (bool is_contract) 
465 	{
466 		// retrieve the size of the code on target address, this needs assembly
467 		uint length;
468 		assembly { length := extcodesize(_addr) }
469 		return length > 0;
470      }
471 	 
472     
473     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/	
474     /**
475      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
476      */
477     function disableInitialStage()
478         onlyAdministrator()
479         public
480     {
481         onlyAmbassadors = false;
482     }
483 	
484 	/**
485      * Sends FUND money to the Fund Contract
486      */
487     function payFund()
488 		public 
489 	{
490 		uint256 ethToPay = SafeMath.sub(totalEthFundCollected, totalEthFundReceived);
491 		require(ethToPay > 0);
492 		totalEthFundReceived = SafeMath.add(totalEthFundReceived, ethToPay);
493       
494 		if(!fundAddress_.call.value(ethToPay).gas(400000)()) {
495 			totalEthFundReceived = SafeMath.sub(totalEthFundReceived, ethToPay);
496 		}
497     }
498     
499     /**
500      * In case one of us dies, we need to replace ourselves.
501      */
502     function setAdministrator(address _identifier)
503         onlyAdministrator()
504         public
505     {
506         administrator = _identifier;
507     }
508 	
509 	/**
510      * Only Add game contract, which can accept HYPER tokens.
511 	 * Disabling a contract is not possible after activating
512      */
513     function setCanAcceptTokens(address _address)
514       onlyAdministrator()
515       public
516     {
517       canAcceptTokens_[_address] = true;
518     }
519     
520     /**
521      * Precautionary measures in case we need to adjust the masternode rate.
522      */
523     function setStakingRequirement(uint256 _amountOfTokens)
524         onlyAdministrator()
525         public
526     {
527         stakingRequirement = _amountOfTokens;
528     }
529     
530     /**
531      * If we want to rebrand, we can.
532      */
533     function setName(string _name)
534         onlyAdministrator()
535         public
536     {
537         name = _name;
538     }
539     
540     /**
541      * If we want to rebrand, we can.
542      */
543     function setSymbol(string _symbol)
544         onlyAdministrator()
545         public
546     {
547         symbol = _symbol;
548     }
549 
550     
551     /*----------  HELPERS AND CALCULATORS  ----------*/
552     /**
553      * Method to view the current Ethereum stored in the contract
554      * Example: totalEthereumBalance()
555      */
556     function totalEthereumBalance()
557         public
558         view
559         returns(uint)
560     {
561         return address(this).balance;
562     }
563     
564     /**
565      * Retrieve the total token supply.
566      */
567     function totalSupply()
568         public
569         view
570         returns(uint256)
571     {
572         return tokenSupply_;
573     }
574     
575     /**
576      * Retrieve the tokens owned by the caller.
577      */
578     function myTokens()
579         public
580         view
581         returns(uint256)
582     {
583         address _customerAddress = msg.sender;
584         return balanceOf(_customerAddress);
585     }
586     
587     /**
588      * Retrieve the dividends owned by the caller.
589      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
590      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
591      * But in the internal calculations, we want them separate. 
592      */ 
593     function myDividends(bool _includeReferralBonus) 
594         public 
595         view 
596         returns(uint256)
597     {
598         address _customerAddress = msg.sender;
599         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
600     }
601 	
602 	/**
603 	 * Retrieve the last used referral address of the given address
604 	 */
605 	function myLastRef(address _addr)
606 		public
607 		view
608 		returns(address)
609 	{
610 		return lastRef_[_addr];
611 	}
612     
613     /**
614      * Retrieve the token balance of any single address.
615      */
616     function balanceOf(address _customerAddress)
617         view
618         public
619         returns(uint256)
620     {
621         return tokenBalanceLedger_[_customerAddress];
622     }
623     
624     /**
625      * Retrieve the dividend balance of any single address.
626      */
627     function dividendsOf(address _customerAddress)
628         view
629         public
630         returns(uint256)
631     {
632         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
633     }
634     
635     /**
636      * Return the buy price of 1 individual token.
637      */
638     function sellPrice() 
639         public 
640         view 
641         returns(uint256)
642     {
643         // our calculation relies on the token supply, so we need supply. Doh.
644         if(tokenSupply_ == 0){
645             return tokenPriceInitial_ - tokenPriceIncremental_;
646         } else {
647             uint256 _ethereum = tokensToEthereum_(1e18);
648             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
649 			uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
650             uint256 _taxedEthereum = SafeMath.sub(_ethereum, SafeMath.add(_dividends, _fundPayout));    
651             return _taxedEthereum;
652         }
653     }
654     
655     /**
656      * Return the sell price of 1 individual token.
657      */
658     function buyPrice() 
659         public 
660         view 
661         returns(uint256)
662     {
663         // our calculation relies on the token supply, so we need supply. Doh.
664         if(tokenSupply_ == 0){
665             return tokenPriceInitial_ + tokenPriceIncremental_;
666         } else {
667             uint256 _ethereum = tokensToEthereum_(1e18);
668             uint256 _taxedEthereum = SafeMath.div(SafeMath.mul(_ethereum, 100), 80); // 125% => 100/80
669             return _taxedEthereum;
670         }
671     }
672     
673     /**
674      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
675      */
676     function calculateTokensReceived(uint256 _weiToSpend)
677         public 
678         view 
679         returns(uint256)
680     {
681         uint256 _dividends = SafeMath.div(SafeMath.mul(_weiToSpend, dividendFee_), 100);			// 10%
682 		uint256 _fundPayout = SafeMath.div(SafeMath.mul(_weiToSpend, fundFee_), 100);				// 3%
683         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_weiToSpend, _dividends), _fundPayout); // 87%
684         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
685         return SafeMath.div(_amountOfTokens, 1e18);
686     }
687     
688     /**
689      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
690      */
691     function calculateEthereumReceived(uint256 _tokensToSell) 
692         public 
693         view 
694         returns(uint256)
695     {
696         require(_tokensToSell <= tokenSupply_);
697         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
698         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);				// 10%
699 		uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);					// 3%
700         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);	// 87%
701         return _taxedEthereum;
702     }
703 	
704 	/**
705      * Function for the frontend to show ether waiting to be send to fund in contract
706      */
707     function etherToSendFund()
708         public
709         view
710         returns(uint256)
711 	{
712         return SafeMath.sub(totalEthFundCollected, totalEthFundReceived);
713     }
714     
715     
716     /*==========================================
717     =            INTERNAL FUNCTIONS            =
718     ==========================================*/
719 	function handleLastRef(address _ref)
720 		internal 
721 		returns(address)
722 	{
723 		address _customerAddress = msg.sender;			// sender
724 		address _lastRef = lastRef_[_customerAddress];	// last saved ref
725 		
726 		// no cheating by referring yourself
727 		if (_ref == _customerAddress) {
728 			return _lastRef;
729 		}
730 		
731 		// try to use last ref of customer
732 		if (_ref == address(0)) {
733 			return _lastRef;
734 		} else {
735 			// new ref is another address, replace 
736 			if (_ref != _lastRef) {
737 				lastRef_[_customerAddress] = _ref;	// save new ref for next time
738 				return _ref;						// return new ref
739 			} else {
740 				return _lastRef;					// return last used ref
741 			}
742 		}
743 	}
744 	
745 	// Make sure we will send back excess if user sends more then 10 ether before 100 ETH in contract
746     function purchaseInternal(uint256 _incomingEthereum, address _referredBy)
747 		internal
748 		returns(uint256)
749 	{
750 		address _customerAddress = msg.sender;
751 		uint256 _purchaseEthereum = _incomingEthereum;
752 		uint256 _excess = 0;
753 
754 		// limit customers value if needed
755 		if(_purchaseEthereum > 10 ether) { // check if the transaction is over 10 ether
756 			if (SafeMath.sub(totalEthereumBalance(), _purchaseEthereum) < 100 ether) { // if so check the contract is less then 100 ether
757 				_purchaseEthereum = 10 ether;
758 				_excess = SafeMath.sub(_incomingEthereum, _purchaseEthereum);
759 			}
760 		}
761 
762 		// purchase tokens
763 		purchaseTokens(_purchaseEthereum, _referredBy);
764 
765 		// payback
766 		if (_excess > 0) {
767 			_customerAddress.transfer(_excess);
768 		}
769     }
770 	
771     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
772         antiEarlyWhale(_incomingEthereum)
773         internal
774         returns(uint256)
775     {
776         // data setup
777         address _customerAddress = msg.sender;
778         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);				// 10%
779 		uint256 _fundPayout = SafeMath.div(SafeMath.mul(_incomingEthereum, fundFee_), 100);							// 3%
780 		uint256 _referralPayout = SafeMath.div(SafeMath.mul(_incomingEthereum, referralBonus_), 100);				// 10%
781         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralPayout);									// 7% => 10% - 3%
782         //uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_incomingEthereum, _undividedDividends), _fundPayout);	// 87%
783         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
784 		
785 		// _taxedEthereum should be used, but stack is too deep here
786         uint256 _amountOfTokens = ethereumToTokens_(SafeMath.sub(SafeMath.sub(_incomingEthereum, _undividedDividends), _fundPayout));
787         uint256 _fee = _dividends * magnitude;
788  
789         // no point in continuing execution if OP is a poorfag russian hacker
790         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
791         // (or hackers)
792         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
793         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
794         
795         // is the user referred by a masternode?
796         if(
797             // is this a referred purchase?
798             _referredBy != 0x0000000000000000000000000000000000000000 &&
799 
800             // no cheating!
801             _referredBy != _customerAddress &&
802             
803             // does the referrer have at least X whole tokens?
804             // i.e is the referrer a godly chad masternode
805             tokenBalanceLedger_[_referredBy] >= stakingRequirement
806         ){
807             // wealth redistribution
808             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralPayout);
809         } else {
810             // no ref purchase
811             // add the referral bonus back to the global dividends cake
812             _dividends = SafeMath.add(_dividends, _referralPayout);
813             _fee = _dividends * magnitude;
814         }
815         
816         // we can't give people infinite ethereum
817         if(tokenSupply_ > 0){
818             
819             // add tokens to the pool
820             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
821  
822             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
823             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
824             
825             // calculate the amount of tokens the customer receives over his purchase 
826             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
827         
828         } else {
829             // add tokens to the pool
830             tokenSupply_ = _amountOfTokens;
831         }
832         
833         // update circulating supply & the ledger address for the customer
834         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
835         
836         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
837         // really i know you think you do but you don't
838         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
839         payoutsTo_[_customerAddress] += _updatedPayouts;
840         
841         // fire event
842         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
843         
844         return _amountOfTokens;
845     }
846 
847     /**
848      * Calculate Token price based on an amount of incoming ethereum
849      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
850      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
851      */
852     function ethereumToTokens_(uint256 _ethereum)
853         internal
854         view
855         returns(uint256)
856     {
857         uint256 _tokensReceived = 
858 		(
859 			// underflow attempts BTFO
860 			SafeMath.sub(
861 				(sqrt
862 					(
863 						(tokenPriceInitial_)**2 * 10**36
864 						+
865 						(tokenPriceInitial_) * (tokenPriceIncremental_) * 10**36
866 						+
867 						25 * (tokenPriceIncremental_)**2 * 10**34
868 						+
869 						(tokenPriceIncremental_)**2 * (tokenSupply_)**2
870 						+
871 						2 * (tokenPriceIncremental_) * (tokenPriceInitial_) * (tokenSupply_) * 10**18
872 						+
873 						(tokenPriceIncremental_)**2 * (tokenSupply_) * 10**18
874 						+
875 						2 * (tokenPriceIncremental_) * (_ethereum) * 10**36
876 					)
877 				), ((tokenPriceInitial_)* 10**18 + 5 * (tokenPriceIncremental_) * 10**17)
878 			) / (tokenPriceIncremental_)
879         ) - (tokenSupply_)
880         ;
881   
882         return _tokensReceived;
883     }
884     
885     /**
886      * Calculate token sell value.
887      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
888      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
889      */
890      function tokensToEthereum_(uint256 _tokens)
891         internal
892         view
893         returns(uint256)
894     {
895         uint256 _etherReceived =
896         (
897             // underflow attempts BTFO
898             SafeMath.sub(
899                 (
900 					((tokenPriceIncremental_) * (_tokens) * (tokenSupply_)) / 1e18
901                     +
902                     (tokenPriceInitial_) * (_tokens)
903                     +
904                     ((tokenPriceIncremental_) * (_tokens)) / 2        
905                 ), (
906 					((tokenPriceIncremental_) * (_tokens**2)) / 2
907 				) / 1e18
908 			)
909         ) / 1e18
910 		;
911         
912 		return _etherReceived;
913     }
914     
915     
916     //This is where all your gas goes, sorry
917     //Not sorry, you probably only paid 1 gwei
918     function sqrt(uint x) internal pure returns (uint y) {
919         uint z = (x + 1) / 2;
920         y = x;
921         while (z < y) {
922             y = z;
923             z = (x / z + z) / 2;
924         }
925     }
926 }
927 
928 /**
929  * @title SafeMath
930  * @dev Math operations with safety checks that throw on error
931  */
932 library SafeMath {
933 
934     /**
935     * @dev Multiplies two numbers, throws on overflow.
936     */
937     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
938         if (a == 0) {
939             return 0;
940         }
941         uint256 c = a * b;
942         assert(c / a == b);
943         return c;
944     }
945 
946     /**
947     * @dev Integer division of two numbers, truncating the quotient.
948     */
949     function div(uint256 a, uint256 b) internal pure returns (uint256) {
950         // assert(b > 0); // Solidity automatically throws when dividing by 0
951         uint256 c = a / b;
952         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
953         return c;
954     }
955 
956     /**
957     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
958     */
959     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
960         assert(b <= a);
961         return a - b;
962     }
963 
964     /**
965     * @dev Adds two numbers, throws on overflow.
966     */
967     function add(uint256 a, uint256 b) internal pure returns (uint256) {
968         uint256 c = a + b;
969         assert(c >= a);
970         return c;
971     }
972 }