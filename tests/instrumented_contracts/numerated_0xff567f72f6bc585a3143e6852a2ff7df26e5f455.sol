1 pragma solidity ^0.4.25;
2 
3 /**
4   _____ _            _   _  ___  ____  _        ____                                      _ _         
5  |_   _| |__   ___  | | | |/ _ \|  _ \| |      / ___|___  _ __ ___  _ __ ___  _   _ _ __ (_) |_ _   _ 
6    | | | '_ \ / _ \ | |_| | | | | | | | |     | |   / _ \| '_ ` _ \| '_ ` _ \| | | | '_ \| | __| | | |
7    | | | | | |  __/ |  _  | |_| | |_| | |___  | |__| (_) | | | | | | | | | | | |_| | | | | | |_| |_| |
8    |_| |_| |_|\___| |_| |_|\___/|____/|_____|  \____\___/|_| |_| |_|_| |_| |_|\__,_|_| |_|_|\__|\__, |
9                                                                                                 |___/ 
10 																								
11 	Special thanks to P3D Hourglass scheme.
12 	Hey, don't do drugs!
13 */
14 
15 
16 /**
17  * Definition of contract accepting THC tokens
18  * Games, Lending, anything can reuse this contract to support THC tokens
19  * ...
20  * Secret Project
21  * ...
22  */
23 contract AcceptsProsperity {
24     Prosperity public tokenContract;
25 
26     constructor(address _tokenContract) public {
27         tokenContract = Prosperity(_tokenContract);
28     }
29 
30     modifier onlyTokenContract {
31         require(msg.sender == address(tokenContract));
32         _;
33     }
34 
35     /**
36     * @dev Standard ERC677 function that will handle incoming token transfers.
37     *
38     * @param _from  Token sender address.
39     * @param _value Amount of tokens.
40     * @param _data  Transaction metadata.
41     */
42     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
43 }
44 
45 contract Prosperity {
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
66     // -> take funds, except the funding contract
67     // -> disable withdrawals
68     // -> kill the contract
69     // -> change the price of tokens
70     modifier onlyAdministrator(){
71         address _customerAddress = msg.sender;
72         require(administrator == _customerAddress);
73         _;
74     }
75     
76     // ensures that the first tokens in the contract will be equally distributed
77     // meaning, no divine dump will be ever possible
78     // result: healthy longevity.
79     modifier antiEarlyWhale(uint256 _amountOfEthereum){
80         address _customerAddress = msg.sender;
81         
82         // are we still in the vulnerable phase?
83         // if so, enact anti early whale protocol 
84         if( onlyAmbassadors && 
85 			((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ ) &&
86 			now < ACTIVATION_TIME)
87 		{
88             require(
89                 // is the customer in the ambassador list?
90                 ambassadors_[_customerAddress] == true &&
91                 
92                 // does the customer purchase exceed the max ambassador quota?
93                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
94                 
95             );
96             
97             // updated the accumulated quota    
98             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
99         
100         } else {
101             // in case the ether count drops low, the ambassador phase won't reinitiate
102 			// only write state variable once
103 			if (onlyAmbassadors) {
104 				onlyAmbassadors = false;
105 			}
106         }
107 		
108 		_;
109     }
110 	
111 	// ambassadors are not allowed to sell their tokens within the anti-pump-and-dump phase
112 	// @Sordren
113 	// hopefully many devs will use this as a standard
114 	modifier ambassAntiPumpAndDump() {
115 		
116 		// we are still in ambassadors antiPumpAndDump phase
117 		if (now <= antiPumpAndDumpEnd_) {
118 			address _customerAddress = msg.sender;
119 			
120 			// require sender is not an ambassador
121 			require(!ambassadors_[_customerAddress]);
122 		}
123 	
124 		// execute
125 		_;
126 	}
127 	
128 	// ambassadors are not allowed to transfer tokens to non-amassador accounts within the anti-pump-and-dump phase
129 	// @Sordren
130 	modifier ambassOnlyToAmbass(address _to) {
131 		
132 		// we are still in ambassadors antiPumpAndDump phase
133 		if (now <= antiPumpAndDumpEnd_){
134 			address _from = msg.sender;
135 			
136 			// sender is ambassador
137 			if (ambassadors_[_from]) {
138 				
139 				// sender is not the lending
140 				// this is required for withdrawing capital from lending
141 				if (_from != lendingAddress_) {
142 					// require receiver is ambassador
143 					require(ambassadors_[_to], "As ambassador you should know better :P");
144 				}
145 			}
146 		}
147 		
148 		// execute
149 		_;
150 	}
151     
152     
153     /*==============================
154     =            EVENTS            =
155     ==============================*/
156     event onTokenPurchase(
157         address indexed customerAddress,
158         uint256 incomingEthereum,
159         uint256 tokensMinted,
160         address indexed referredBy
161     );
162     
163     event onTokenSell(
164         address indexed customerAddress,
165         uint256 tokensBurned,
166         uint256 ethereumEarned
167     );
168     
169     event onReinvestment(
170         address indexed customerAddress,
171         uint256 ethereumReinvested,
172         uint256 tokensMinted
173     );
174     
175     event onWithdraw(
176         address indexed customerAddress,
177         uint256 ethereumWithdrawn
178     );
179     
180     // ERC20
181     event Transfer(
182         address indexed from,
183         address indexed to,
184         uint256 tokens
185     );
186     
187     
188     /*=====================================
189     =            CONFIGURABLES            =
190     =====================================*/
191     string public name = "The HODL Community";
192     string public symbol = "THC";
193     uint8 constant public decimals = 18;
194     uint8 constant internal dividendFee_ = 17;	// 17% divvies
195 	uint8 constant internal fundFee_ = 3; 		// 3% investment fund fee on each buy/sell
196 	uint8 constant internal referralBonus_ = 5;
197     uint256 constant internal tokenPriceInitial_ =     0.0000001 ether;
198     uint256 constant internal tokenPriceIncremental_ = 0.000000005 ether;
199     uint256 constant internal magnitude = 2**64;	
200     
201     // proof of stake (defaults at 100 tokens)
202     uint256 public stakingRequirement = 20e18;
203     
204     // ambassador program
205     uint256 constant internal ambassadorMaxPurchase_ = 2 ether;
206     uint256 constant internal ambassadorQuota_ = 20 ether;
207 	
208 	// anti pump and dump phase time (default 30 days)
209 	uint256 constant internal antiPumpAndDumpTime_ = 90 days;								// remember it is constant, so it cannot be changed after deployment
210 	uint256 constant public antiPumpAndDumpEnd_ = ACTIVATION_TIME + antiPumpAndDumpTime_;	// set anti-pump-and-dump time to 30 days after deploying
211 	uint256 constant internal ACTIVATION_TIME = 1541966400;
212 	
213 	// when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
214     bool public onlyAmbassadors = true;
215     
216     
217    /*================================
218     =            DATASETS            =
219     ================================*/
220     // amount of shares for each address (scaled number)
221     mapping(address => uint256) internal tokenBalanceLedger_;
222     mapping(address => uint256) internal referralBalance_;
223     mapping(address => int256) internal payoutsTo_;
224 	mapping(address => address) internal lastRef_;
225     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
226     uint256 internal tokenSupply_ = 0;
227     uint256 internal profitPerShare_;
228     
229     // administrator (see above on what they can do)
230     address internal administrator;
231 	
232 	// lending address
233 	address internal lendingAddress_;
234 	
235 	// Address to send the 3% fee
236     address public fundAddress_;
237     uint256 internal totalEthFundReceived; 		// total ETH received from this contract
238     uint256 internal totalEthFundCollected; 	// total ETH collected in this contract
239 	
240 	// ambassador program
241 	mapping(address => bool) internal ambassadors_;
242 	
243 	// Special THC Platform control from scam game contracts on THC platform
244     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept THC tokens
245 
246 
247     /*=======================================
248     =            PUBLIC FUNCTIONS            =
249     =======================================*/
250     /*
251     * -- APPLICATION ENTRY POINTS --  
252     */
253     constructor()
254         public
255     {
256         // add administrators here
257         administrator = 0x28436C7453EbA01c6EcbC8a9cAa975f0ADE6Fff1;
258 		fundAddress_ = 0x1E2F082CB8fd71890777CA55Bd0Ce1299975B25f;
259 		lendingAddress_ = 0x961FA070Ef41C2b68D1A50905Ea9198EF7Dbfbf8;
260         
261         // add the ambassadors here.
262         ambassadors_[0x28436C7453EbA01c6EcbC8a9cAa975f0ADE6Fff1] = true;	// tobi
263         ambassadors_[0x92be79705F4Fab97894833448Def30377bc7267A] = true;	// fabi
264 		ambassadors_[0x5289f0f0E8417c7475Ba33E92b1944279e183B0C] = true;	// julian
265 		ambassadors_[0x000929719742ec6E0bFD0107959384F7Acd8F883] = true;	// lukas
266 		ambassadors_[0xCe221935D4342A3F2A39d791851eE3696488D087] = true;	// leon
267 		ambassadors_[0x7276262ce50d60770F4d4FA64dbA15805D8Bdc87] = true;	// lio
268 		ambassadors_[lendingAddress_] 							 = true;	// lending, to be the first to buy tokens
269 		ambassadors_[fundAddress_]								 = true;	// fund, to be able to be masternode
270 		
271 		// set lending ref
272 		lastRef_[lendingAddress_] = fundAddress_;
273     }
274     
275      
276     /**
277      * Converts all incoming ethereum to tokens for the caller, and passes down the referral
278      */
279     function buy(address _referredBy)
280         public
281         payable
282         returns(uint256)
283     {
284 		require(tx.gasprice <= 0.05 szabo);
285 		address _lastRef = handleLastRef(_referredBy);
286 		purchaseInternal(msg.value, _lastRef);
287     }
288     
289     /**
290      * Fallback function to handle ethereum that was send straight to the contract
291      * Unfortunately we cannot use a referral address this way.
292      */
293     function()
294         payable
295         external
296     {
297 		require(tx.gasprice <= 0.05 szabo);
298 		address lastRef = handleLastRef(address(0));	// hopefully (for you) you used a referral somewhere in the past
299 		purchaseInternal(msg.value, lastRef);
300     }
301     
302     /**
303      * Converts all of caller's dividends to tokens.
304      */
305     function reinvest()
306         onlyStronghands()
307         public
308     {
309         // fetch dividends
310         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
311         
312         // pay out the dividends virtually
313         address _customerAddress = msg.sender;
314         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
315         
316         // retrieve ref. bonus
317         _dividends += referralBalance_[_customerAddress];
318         referralBalance_[_customerAddress] = 0;
319         
320         // dispatch a buy order with the virtualized "withdrawn dividends"
321 		address _lastRef = handleLastRef(address(0));	// hopefully you used a referral somewhere in the past
322         uint256 _tokens = purchaseInternal(_dividends, _lastRef);
323         
324         // fire event
325         emit onReinvestment(_customerAddress, _dividends, _tokens);
326     }
327     
328     /**
329      * Alias of sell() and withdraw().
330      */
331     function exit()
332         public
333     {
334         // get token count for caller & sell them all
335         address _customerAddress = msg.sender;
336         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
337         if(_tokens > 0) sell(_tokens);
338         
339         // lambo delivery service
340         withdraw();
341     }
342 
343     /**
344      * Withdraws all of the callers earnings.
345      */
346     function withdraw()
347         onlyStronghands()
348         public
349     {
350         // setup data
351         address _customerAddress = msg.sender;
352         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
353         
354         // update dividend tracker
355         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
356         
357         // add ref. bonus
358         _dividends += referralBalance_[_customerAddress];
359         referralBalance_[_customerAddress] = 0;
360         
361         // lambo delivery service
362         _customerAddress.transfer(_dividends);
363         
364         // fire event
365         emit onWithdraw(_customerAddress, _dividends);
366     }
367     
368     /**
369      * Liquifies tokens to ethereum.
370      */
371     function sell(uint256 _amountOfTokens)
372         onlyBagholders()
373 		ambassAntiPumpAndDump()
374         public
375     {
376         // setup data
377         address _customerAddress = msg.sender;
378         // russian hackers BTFO
379         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
380         uint256 _tokens = _amountOfTokens;
381         uint256 _ethereum = tokensToEthereum_(_tokens);
382         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);				// 17%
383 		uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);					// 3%
384         uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);	// Take out dividends and then _fundPayout
385 		
386 		// Add ethereum for fund
387         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
388         
389         // burn the sold tokens
390         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
391         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
392         
393         // update dividends tracker
394         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
395         payoutsTo_[_customerAddress] -= _updatedPayouts;
396         
397         // dividing by zero is a bad idea
398         if (tokenSupply_ > 0) {
399             // update the amount of dividends per token
400             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
401         }
402         
403         // fire event
404         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
405     }
406     
407     
408     /**
409      * Transfer tokens from the caller to a new holder.
410      * Remember, there's 0% fee here.
411      */
412     function transfer(address _toAddress, uint256 _amountOfTokens)
413         onlyBagholders()
414 		ambassOnlyToAmbass(_toAddress)
415         public
416         returns(bool)
417     {
418         // setup
419         address _customerAddress = msg.sender;
420         
421         // make sure we have the requested tokens
422         // also disables transfers until ambassador phase is over
423         // ( we dont want whale premines )
424         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
425         
426         // withdraw all outstanding dividends first
427         if(myDividends(true) > 0) withdraw();
428 
429         // exchange tokens
430         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
431         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
432 		
433 		// update dividend trackers
434         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
435         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
436         
437         // fire event
438         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
439         
440         // ERC20
441         return true;
442     }
443 	
444 	/**
445     * Transfer token to a specified address and forward the data to recipient
446     * ERC-677 standard
447     * https://github.com/ethereum/EIPs/issues/677
448     * @param _to    Receiver address.
449     * @param _value Amount of tokens that will be transferred.
450     * @param _data  Transaction metadata.
451     */
452     function transferAndCall(address _to, uint256 _value, bytes _data)
453 		external
454 		returns (bool) 
455 	{
456 		require(_to != address(0));
457 		require(canAcceptTokens_[_to] == true); 	// security check that contract approved by THC platform
458 		require(transfer(_to, _value)); 			// do a normal token transfer to the contract
459 
460 		if (isContract(_to)) {
461 			AcceptsProsperity receiver = AcceptsProsperity(_to);
462 			require(receiver.tokenFallback(msg.sender, _value, _data));
463 		}
464 
465 		return true;
466     }
467 
468     /**
469      * Additional check that the game address we are sending tokens to is a contract
470      * assemble the given address bytecode. If bytecode exists then the _addr is a contract.
471      */
472      function isContract(address _addr) 
473 		private 
474 		constant 
475 		returns (bool is_contract) 
476 	{
477 		// retrieve the size of the code on target address, this needs assembly
478 		uint length;
479 		assembly { length := extcodesize(_addr) }
480 		return length > 0;
481      }
482 	 
483     
484     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/	
485     /**
486      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
487      */
488     function disableInitialStage()
489         onlyAdministrator()
490         public
491     {
492         onlyAmbassadors = false;
493     }
494 	
495 	/**
496      * Sends FUND money to the Fund Contract
497      */
498     function payFund()
499 		public 
500 	{
501 		uint256 ethToPay = SafeMath.sub(totalEthFundCollected, totalEthFundReceived);
502 		require(ethToPay > 0);
503 		totalEthFundReceived = SafeMath.add(totalEthFundReceived, ethToPay);
504       
505 		if(!fundAddress_.call.value(ethToPay).gas(400000)()) {
506 			totalEthFundReceived = SafeMath.sub(totalEthFundReceived, ethToPay);
507 		}
508     }
509     
510     /**
511      * In case one of us dies, we need to replace ourselves.
512      */
513     function setAdministrator(address _identifier)
514         onlyAdministrator()
515         public
516     {
517         administrator = _identifier;
518     }
519 	
520 	/**
521      * Only Add game contract, which can accept THC tokens.
522 	 * Disabling a contract is not possible after activating
523      */
524     function setCanAcceptTokens(address _address)
525       onlyAdministrator()
526       public
527     {
528       canAcceptTokens_[_address] = true;
529     }
530     
531     /**
532      * Precautionary measures in case we need to adjust the masternode rate.
533      */
534     function setStakingRequirement(uint256 _amountOfTokens)
535         onlyAdministrator()
536         public
537     {
538         stakingRequirement = _amountOfTokens;
539     }
540     
541     /**
542      * If we want to rebrand, we can.
543      */
544     function setName(string _name)
545         onlyAdministrator()
546         public
547     {
548         name = _name;
549     }
550     
551     /**
552      * If we want to rebrand, we can.
553      */
554     function setSymbol(string _symbol)
555         onlyAdministrator()
556         public
557     {
558         symbol = _symbol;
559     }
560 
561     
562     /*----------  HELPERS AND CALCULATORS  ----------*/
563     /**
564      * Method to view the current Ethereum stored in the contract
565      * Example: totalEthereumBalance()
566      */
567     function totalEthereumBalance()
568         public
569         view
570         returns(uint)
571     {
572         return address(this).balance;
573     }
574     
575     /**
576      * Retrieve the total token supply.
577      */
578     function totalSupply()
579         public
580         view
581         returns(uint256)
582     {
583         return tokenSupply_;
584     }
585     
586     /**
587      * Retrieve the tokens owned by the caller.
588      */
589     function myTokens()
590         public
591         view
592         returns(uint256)
593     {
594         address _customerAddress = msg.sender;
595         return balanceOf(_customerAddress);
596     }
597     
598     /**
599      * Retrieve the dividends owned by the caller.
600      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
601      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
602      * But in the internal calculations, we want them separate. 
603      */ 
604     function myDividends(bool _includeReferralBonus) 
605         public 
606         view 
607         returns(uint256)
608     {
609         address _customerAddress = msg.sender;
610         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
611     }
612 	
613 	/**
614 	 * Retrieve the last used referral address of the given address
615 	 */
616 	function myLastRef(address _addr)
617 		public
618 		view
619 		returns(address)
620 	{
621 		return lastRef_[_addr];
622 	}
623     
624     /**
625      * Retrieve the token balance of any single address.
626      */
627     function balanceOf(address _customerAddress)
628         view
629         public
630         returns(uint256)
631     {
632         return tokenBalanceLedger_[_customerAddress];
633     }
634     
635     /**
636      * Retrieve the dividend balance of any single address.
637      */
638     function dividendsOf(address _customerAddress)
639         view
640         public
641         returns(uint256)
642     {
643         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
644     }
645     
646     /**
647      * Return the buy price of 1 individual token.
648      */
649     function sellPrice() 
650         public 
651         view 
652         returns(uint256)
653     {
654         // our calculation relies on the token supply, so we need supply. Doh.
655         if(tokenSupply_ == 0){
656             return tokenPriceInitial_ - tokenPriceIncremental_;
657         } else {
658             uint256 _ethereum = tokensToEthereum_(1e18);
659             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
660 			uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
661             uint256 _taxedEthereum = SafeMath.sub(_ethereum, SafeMath.add(_dividends, _fundPayout));    // 80%
662             return _taxedEthereum;
663         }
664     }
665     
666     /**
667      * Return the sell price of 1 individual token.
668      */
669     function buyPrice() 
670         public 
671         view 
672         returns(uint256)
673     {
674         // our calculation relies on the token supply, so we need supply. Doh.
675         if(tokenSupply_ == 0){
676             return tokenPriceInitial_ + tokenPriceIncremental_;
677         } else {
678             uint256 _ethereum = tokensToEthereum_(1e18);
679             uint256 _taxedEthereum = SafeMath.div(SafeMath.mul(_ethereum, 100), 80); // 125% => 100/80
680             return _taxedEthereum;
681         }
682     }
683     
684     /**
685      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
686      */
687     function calculateTokensReceived(uint256 _weiToSpend)
688         public 
689         view 
690         returns(uint256)
691     {
692         uint256 _dividends = SafeMath.div(SafeMath.mul(_weiToSpend, dividendFee_), 100);			// 17%
693 		uint256 _fundPayout = SafeMath.div(SafeMath.mul(_weiToSpend, fundFee_), 100);				// 3%
694         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_weiToSpend, _dividends), _fundPayout); // 80%
695         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
696         return SafeMath.div(_amountOfTokens, 1e18);
697     }
698     
699     /**
700      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
701      */
702     function calculateEthereumReceived(uint256 _tokensToSell) 
703         public 
704         view 
705         returns(uint256)
706     {
707         require(_tokensToSell <= tokenSupply_);
708         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
709         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);				// 17%
710 		uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);					// 3%
711         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);	// 80%
712         return _taxedEthereum;
713     }
714 	
715 	/**
716      * Function for the frontend to show ether waiting to be send to fund in contract
717      */
718     function etherToSendFund()
719         public
720         view
721         returns(uint256)
722 	{
723         return SafeMath.sub(totalEthFundCollected, totalEthFundReceived);
724     }
725     
726     
727     /*==========================================
728     =            INTERNAL FUNCTIONS            =
729     ==========================================*/
730 	function handleLastRef(address _ref)
731 		internal 
732 		returns(address)
733 	{
734 		address _customerAddress = msg.sender;			// sender
735 		address _lastRef = lastRef_[_customerAddress];	// last saved ref
736 		
737 		// no cheating by referring yourself
738 		if (_ref == _customerAddress) {
739 			return _lastRef;
740 		}
741 		
742 		// try to use last ref of customer
743 		if (_ref == address(0)) {
744 			return _lastRef;
745 		} else {
746 			// new ref is another address, replace 
747 			if (_ref != _lastRef) {
748 				lastRef_[_customerAddress] = _ref;	// save new ref for next time
749 				return _ref;						// return new ref
750 			} else {
751 				return _lastRef;					// return last used ref
752 			}
753 		}
754 	}
755 	
756 	// Make sure we will send back excess if user sends more then 2 ether before 100 ETH in contract
757     function purchaseInternal(uint256 _incomingEthereum, address _referredBy)
758 		internal
759 		returns(uint256)
760 	{
761 		address _customerAddress = msg.sender;
762 		uint256 _purchaseEthereum = _incomingEthereum;
763 		uint256 _excess = 0;
764 
765 		// limit customers value if needed
766 		if(_purchaseEthereum > 2 ether) { // check if the transaction is over 2 ether
767 			if (SafeMath.sub(totalEthereumBalance(), _purchaseEthereum) < 100 ether) { // if so check the contract is less then 100 ether
768 				_purchaseEthereum = 2 ether;
769 				_excess = SafeMath.sub(_incomingEthereum, _purchaseEthereum);
770 			}
771 		}
772 
773 		// purchase tokens
774 		purchaseTokens(_purchaseEthereum, _referredBy);
775 
776 		// payback
777 		if (_excess > 0) {
778 			_customerAddress.transfer(_excess);
779 		}
780     }
781 	
782     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
783         antiEarlyWhale(_incomingEthereum)
784         internal
785         returns(uint256)
786     {
787         // data setup
788         address _customerAddress = msg.sender;
789         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);				// 17%
790 		uint256 _fundPayout = SafeMath.div(SafeMath.mul(_incomingEthereum, fundFee_), 100);							// 3%
791 		uint256 _referralPayout = SafeMath.div(SafeMath.mul(_incomingEthereum, referralBonus_), 100);				// 5%
792         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralPayout);									// 12% => 17% - 5%
793         //uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_incomingEthereum, _undividedDividends), _fundPayout);	// 80%
794         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
795 		
796 		// _taxedEthereum should be used, but stack is too deep here
797         uint256 _amountOfTokens = ethereumToTokens_(SafeMath.sub(SafeMath.sub(_incomingEthereum, _undividedDividends), _fundPayout));
798         uint256 _fee = _dividends * magnitude;
799  
800         // no point in continuing execution if OP is a poorfag russian hacker
801         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
802         // (or hackers)
803         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
804         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
805         
806         // is the user referred by a masternode?
807         if(
808             // is this a referred purchase?
809             _referredBy != 0x0000000000000000000000000000000000000000 &&
810 
811             // no cheating!
812             _referredBy != _customerAddress &&
813             
814             // does the referrer have at least X whole tokens?
815             // i.e is the referrer a godly chad masternode
816             tokenBalanceLedger_[_referredBy] >= stakingRequirement
817         ){
818             // wealth redistribution
819             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralPayout);
820         } else {
821             // no ref purchase
822             // add the referral bonus back to the global dividends cake
823             _dividends = SafeMath.add(_dividends, _referralPayout);
824             _fee = _dividends * magnitude;
825         }
826         
827         // we can't give people infinite ethereum
828         if(tokenSupply_ > 0){
829             
830             // add tokens to the pool
831             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
832  
833             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
834             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
835             
836             // calculate the amount of tokens the customer receives over his purchase 
837             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
838         
839         } else {
840             // add tokens to the pool
841             tokenSupply_ = _amountOfTokens;
842         }
843         
844         // update circulating supply & the ledger address for the customer
845         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
846         
847         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
848         // really i know you think you do but you don't
849         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
850         payoutsTo_[_customerAddress] += _updatedPayouts;
851         
852         // fire event
853         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
854         
855         return _amountOfTokens;
856     }
857 
858     /**
859      * Calculate Token price based on an amount of incoming ethereum
860      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
861      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
862      */
863     function ethereumToTokens_(uint256 _ethereum)
864         internal
865         view
866         returns(uint256)
867     {
868         uint256 _tokensReceived = 
869 		(
870 			// underflow attempts BTFO
871 			SafeMath.sub(
872 				(sqrt
873 					(
874 						(tokenPriceInitial_)**2 * 10**36
875 						+
876 						(tokenPriceInitial_) * (tokenPriceIncremental_) * 10**36
877 						+
878 						25 * (tokenPriceIncremental_)**2 * 10**34
879 						+
880 						(tokenPriceIncremental_)**2 * (tokenSupply_)**2
881 						+
882 						2 * (tokenPriceIncremental_) * (tokenPriceInitial_) * (tokenSupply_) * 10**18
883 						+
884 						(tokenPriceIncremental_)**2 * (tokenSupply_) * 10**18
885 						+
886 						2 * (tokenPriceIncremental_) * (_ethereum) * 10**36
887 					)
888 				), ((tokenPriceInitial_)* 10**18 + 5 * (tokenPriceIncremental_) * 10**17)
889 			) / (tokenPriceIncremental_)
890         ) - (tokenSupply_)
891         ;
892   
893         return _tokensReceived;
894     }
895     
896     /**
897      * Calculate token sell value.
898      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
899      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
900      */
901      function tokensToEthereum_(uint256 _tokens)
902         internal
903         view
904         returns(uint256)
905     {
906         uint256 _etherReceived =
907         (
908             // underflow attempts BTFO
909             SafeMath.sub(
910                 (
911 					((tokenPriceIncremental_) * (_tokens) * (tokenSupply_)) / 1e18
912                     +
913                     (tokenPriceInitial_) * (_tokens)
914                     +
915                     ((tokenPriceIncremental_) * (_tokens)) / 2        
916                 ), (
917 					((tokenPriceIncremental_) * (_tokens**2)) / 2
918 				) / 1e18
919 			)
920         ) / 1e18
921 		;
922         
923 		return _etherReceived;
924     }
925     
926     
927     //This is where all your gas goes, sorry
928     //Not sorry, you probably only paid 1 gwei
929     function sqrt(uint x) internal pure returns (uint y) {
930         uint z = (x + 1) / 2;
931         y = x;
932         while (z < y) {
933             y = z;
934             z = (x / z + z) / 2;
935         }
936     }
937 }
938 
939 /**
940  * @title SafeMath
941  * @dev Math operations with safety checks that throw on error
942  */
943 library SafeMath {
944 
945     /**
946     * @dev Multiplies two numbers, throws on overflow.
947     */
948     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
949         if (a == 0) {
950             return 0;
951         }
952         uint256 c = a * b;
953         assert(c / a == b);
954         return c;
955     }
956 
957     /**
958     * @dev Integer division of two numbers, truncating the quotient.
959     */
960     function div(uint256 a, uint256 b) internal pure returns (uint256) {
961         // assert(b > 0); // Solidity automatically throws when dividing by 0
962         uint256 c = a / b;
963         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
964         return c;
965     }
966 
967     /**
968     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
969     */
970     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
971         assert(b <= a);
972         return a - b;
973     }
974 
975     /**
976     * @dev Adds two numbers, throws on overflow.
977     */
978     function add(uint256 a, uint256 b) internal pure returns (uint256) {
979         uint256 c = a + b;
980         assert(c >= a);
981         return c;
982     }
983 }
984 
985 
986 
987 
988 
989 
990 /**
991   _____ _            _   _  ___  ____  _        ____                                      _ _         
992  |_   _| |__   ___  | | | |/ _ \|  _ \| |      / ___|___  _ __ ___  _ __ ___  _   _ _ __ (_) |_ _   _ 
993    | | | '_ \ / _ \ | |_| | | | | | | | |     | |   / _ \| '_ ` _ \| '_ ` _ \| | | | '_ \| | __| | | |
994    | | | | | |  __/ |  _  | |_| | |_| | |___  | |__| (_) | | | | | | | | | | | |_| | | | | | |_| |_| |
995    |_| |_| |_|\___| |_| |_|\___/|____/|_____|  \____\___/|_| |_| |_|_| |_| |_|\__,_|_| |_|_|\__|\__, |
996                                                                                                 |___/ 
997 																								
998 	HODL responsibly. Don't drink and crypto!
999 */