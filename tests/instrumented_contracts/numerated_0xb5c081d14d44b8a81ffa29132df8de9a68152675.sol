1 pragma solidity ^0.4.24;
2 
3 contract AcceptsExchange {
4     Exchange public tokenContract;
5 
6     constructor(address _tokenContract) public {
7         tokenContract = Exchange(_tokenContract);
8     }
9 
10     modifier onlyTokenContract {
11         require(msg.sender == address(tokenContract));
12         _;
13     }
14 
15     /**
16     * @dev Standard ERC677 function that will handle incoming token transfers.
17     *
18     * @param _from  Token sender address.
19     * @param _value Amount of tokens.
20     * @param _data  Transaction metadata.
21     */
22     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
23 }
24 
25 
26 contract Exchange {
27     /*=================================
28     =            MODIFIERS            =
29     =================================*/
30     // only people with tokens
31     modifier onlyBagholders() {
32         require(myTokens() > 0);
33         _;
34     }
35 
36     // only people with profits
37     modifier onlyStronghands() {
38         require(myDividends(true) > 0);
39         _;
40     }
41 
42     modifier notContract() {
43       require (msg.sender == tx.origin);
44       _;
45     }
46 
47     // administrators can:
48     // -> change the name of the contract
49     // -> change the name of the token
50     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
51     // they CANNOT:
52     // -> take funds
53     // -> disable withdrawals
54     // -> kill the contract
55     // -> change the price of tokens
56     modifier onlyAdministrator(){
57         address _customerAddress = msg.sender;
58         require(administrators[_customerAddress]);
59         _;
60     }
61 
62     uint ACTIVATION_TIME = 1540213200;
63 
64     // ensures that the first tokens in the contract will be equally distributed
65     // meaning, no divine dump will be ever possible
66     // result: healthy longevity.
67     modifier antiEarlyWhale(uint256 _amountOfEthereum){
68 
69         if (now >= ACTIVATION_TIME) {
70             onlyAmbassadors = false;
71         }
72 
73         // are we still in the vulnerable phase?
74         // if so, enact anti early whale protocol
75         // transaction reverts for ambassador instead of purchasing and sending back excess
76         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
77             require(
78                 // is the customer in the ambassador list?
79                 ambassadors_[msg.sender] == true &&
80 
81                 // does the customer purchase exceed the max ambassador quota?
82                 (ambassadorAccumulatedQuota_[msg.sender] + _amountOfEthereum) <= ambassadorMaxPurchase_
83 
84             );
85 
86             // updated the accumulated quota
87             ambassadorAccumulatedQuota_[msg.sender] = SafeMath.add(ambassadorAccumulatedQuota_[msg.sender], _amountOfEthereum);
88 
89             // execute
90             _;
91         } else {
92             // in case the ether count drops low, the ambassador phase won't reinitiate
93             onlyAmbassadors = false;
94             _;
95         }
96 
97     }
98 
99     /*==============================
100     =            EVENTS            =
101     ==============================*/
102     event onTokenPurchase(
103         address indexed customerAddress,
104         uint256 incomingEthereum,
105         uint256 tokensMinted,
106         address indexed referredBy,
107         bool isReinvest,
108         uint timestamp,
109         uint256 price
110     );
111 
112     event onTokenSell(
113         address indexed customerAddress,
114         uint256 tokensBurned,
115         uint256 ethereumEarned,
116         uint timestamp,
117         uint256 price
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
128         uint256 ethereumWithdrawn,
129         uint256 estimateTokens,
130         bool isTransfer
131     );
132 
133     // ERC20
134     event Transfer(
135         address indexed from,
136         address indexed to,
137         uint256 tokens
138     );
139 
140 
141     /*=====================================
142     =            CONFIGURABLES            =
143     =====================================*/
144     string public name = "EXCHANGE";
145     string public symbol = "SHARES";
146     uint8 constant public decimals = 18;
147 
148     uint8 constant internal entryFee_ = 20; // 20% dividend fee on each buy
149     uint8 constant internal startExitFee_ = 40; // 40 % dividends for token selling
150     uint8 constant internal finalExitFee_ = 20; // 20% dividends for token selling after step
151     uint8 constant internal fundFee_ = 5; // 5% to stock game
152     uint256 constant internal exitFeeFallDuration_ = 30 days; //Exit fee falls over period of 30 days
153 
154     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
155     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
156     uint256 constant internal magnitude = 2**64;
157 
158     // Address to send the 5% Fee
159     address public giveEthFundAddress = 0x0;
160     bool public finalizedEthFundAddress = false;
161     uint256 public totalEthFundRecieved; // total ETH charity recieved from this contract
162     uint256 public totalEthFundCollected; // total ETH charity collected in this contract
163 
164     // proof of stake (defaults at 100 tokens)
165     uint256 public stakingRequirement = 25e18;
166 
167     // ambassador program
168     mapping(address => bool) internal ambassadors_;
169     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
170     uint256 constant internal ambassadorQuota_ = 6 ether;
171 
172    /*================================
173     =            DATASETS            =
174     ================================*/
175     // amount of shares for each address (scaled number)
176     mapping(address => uint256) internal tokenBalanceLedger_;
177     mapping(address => uint256) internal referralBalance_;
178     mapping(address => int256) internal payoutsTo_;
179     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
180     uint256 internal tokenSupply_ = 0;
181     uint256 internal profitPerShare_;
182 
183     // administrator list (see above on what they can do)
184     mapping(address => bool) public administrators;
185 
186     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
187     bool public onlyAmbassadors = true;
188 
189     // To whitelist game contracts on the platform
190     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept the exchanges tokens
191 
192     /*=======================================
193     =            PUBLIC FUNCTIONS            =
194     =======================================*/
195     /*
196     * -- APPLICATION ENTRY POINTS --
197     */
198     constructor()
199         public
200     {
201         // add administrators here
202         administrators[0x3db1e274bf36824cf655beddb92a90c04906e04b] = true;
203 
204         // add the ambassadors here - Tokens will be distributed to these addresses from main premine
205         ambassadors_[0x3db1e274bf36824cf655beddb92a90c04906e04b] = true;
206         ambassadors_[0x7191cbd8bbcacfe989aa60fb0be85b47f922fe21] = true;
207         ambassadors_[0xEafE863757a2b2a2c5C3f71988b7D59329d09A78] = true;
208         ambassadors_[0x41fe3738b503cbafd01c1fd8dd66b7fe6ec11b01] = true;
209         ambassadors_[0x4ffE17a2A72bC7422CB176bC71c04EE6D87cE329] = true;
210         ambassadors_[0xEc31176d4df0509115abC8065A8a3F8275aafF2b] = true;
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
222 
223         require(tx.gasprice <= 0.05 szabo);
224         purchaseInternal(msg.value, _referredBy);
225     }
226 
227     /**
228      * Fallback function to handle ethereum that was send straight to the contract
229      * Unfortunately we cannot use a referral address this way.
230      */
231     function()
232         payable
233         public
234     {
235 
236         require(tx.gasprice <= 0.05 szabo);
237         purchaseInternal(msg.value, 0x0);
238     }
239 
240     function updateFundAddress(address _newAddress)
241         onlyAdministrator()
242         public
243     {
244         require(finalizedEthFundAddress == false);
245         giveEthFundAddress = _newAddress;
246     }
247 
248     function finalizeFundAddress(address _finalAddress)
249         onlyAdministrator()
250         public
251     {
252         require(finalizedEthFundAddress == false);
253         giveEthFundAddress = _finalAddress;
254         finalizedEthFundAddress = true;
255     }
256 
257     function payFund() payable onlyAdministrator() public {
258         uint256 ethToPay = SafeMath.sub(totalEthFundCollected, totalEthFundRecieved);
259         require(ethToPay > 0);
260         totalEthFundRecieved = SafeMath.add(totalEthFundRecieved, ethToPay);
261         if(!giveEthFundAddress.call.value(ethToPay).gas(400000)()) {
262           totalEthFundRecieved = SafeMath.sub(totalEthFundRecieved, ethToPay);
263         }
264     }
265 
266     /**
267      * Converts all of caller's dividends to tokens.
268      */
269     function reinvest()
270         onlyStronghands()
271         public
272     {
273         // fetch dividends
274         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
275 
276         // pay out the dividends virtually
277         address _customerAddress = msg.sender;
278         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
279 
280         // retrieve ref. bonus
281         _dividends += referralBalance_[_customerAddress];
282         referralBalance_[_customerAddress] = 0;
283 
284         // dispatch a buy order with the virtualized "withdrawn dividends"
285         uint256 _tokens = purchaseTokens(_dividends, _dividends, 0x0, true);
286 
287         // fire event
288         emit onReinvestment(_customerAddress, _dividends, _tokens);
289     }
290 
291     /**
292      * Alias of sell() and withdraw().
293      */
294     function exit()
295         public
296     {
297         // get token count for caller & sell them all
298         address _customerAddress = msg.sender;
299         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
300         if(_tokens > 0) sell(_tokens);
301 
302         // lambo delivery service
303         withdraw(false);
304     }
305 
306     /**
307      * Withdraws all of the callers earnings.
308      */
309     function withdraw(bool _isTransfer)
310         onlyStronghands()
311         public
312     {
313         // setup data
314         address _customerAddress = msg.sender;
315         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
316 
317         uint256 _estimateTokens = calculateTokensReceived(_dividends);
318 
319         // update dividend tracker
320         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
321 
322         // add ref. bonus
323         _dividends += referralBalance_[_customerAddress];
324         referralBalance_[_customerAddress] = 0;
325 
326         // lambo delivery service
327         _customerAddress.transfer(_dividends);
328 
329         // fire event
330         emit onWithdraw(_customerAddress, _dividends, _estimateTokens, _isTransfer);
331     }
332 
333     /**
334      * Liquifies tokens to ethereum.
335      */
336     function sell(uint256 _amountOfTokens)
337         onlyBagholders()
338         public
339     {
340         // setup data
341         address _customerAddress = msg.sender;
342         // russian hackers BTFO
343         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
344         uint256 _tokens = _amountOfTokens;
345         uint256 _ethereum = tokensToEthereum_(_tokens);
346 
347         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
348         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
349 
350         // Take out dividends and then _fundPayout
351         uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
352 
353         // Add ethereum to send to fund
354         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
355 
356         // burn the sold tokens
357         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
358         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
359 
360         // update dividends tracker
361         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
362         payoutsTo_[_customerAddress] -= _updatedPayouts;
363 
364         // dividing by zero is a bad idea
365         if (tokenSupply_ > 0) {
366             // update the amount of dividends per token
367             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
368         }
369 
370         // fire event
371         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
372     }
373 
374 
375     /**
376      * Transfer tokens from the caller to a new holder.
377      * REMEMBER THIS IS 0% TRANSFER FEE
378      */
379     function transfer(address _toAddress, uint256 _amountOfTokens)
380         onlyBagholders()
381         public
382         returns(bool)
383     {
384         // setup
385         address _customerAddress = msg.sender;
386 
387         // make sure we have the requested tokens
388         // also disables transfers until ambassador phase is over
389         // ( we dont want whale premines )
390         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
391 
392         // withdraw all outstanding dividends first
393         if(myDividends(true) > 0) withdraw(true);
394 
395         // exchange tokens
396         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
397         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
398 
399         // update dividend trackers
400         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
401         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
402 
403 
404         // fire event
405         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
406 
407         // ERC20
408         return true;
409     }
410 
411     /**
412     * Transfer token to a specified address and forward the data to recipient
413     * ERC-677 standard
414     * https://github.com/ethereum/EIPs/issues/677
415     * @param _to    Receiver address.
416     * @param _value Amount of tokens that will be transferred.
417     * @param _data  Transaction metadata.
418     */
419     function transferAndCall(address _to, uint256 _value, bytes _data) external returns (bool) {
420       require(_to != address(0));
421       require(canAcceptTokens_[_to] == true); // security check that contract approved by the exchange
422       require(transfer(_to, _value)); // do a normal token transfer to the contract
423 
424       if (isContract(_to)) {
425         AcceptsExchange receiver = AcceptsExchange(_to);
426         require(receiver.tokenFallback(msg.sender, _value, _data));
427       }
428 
429       return true;
430     }
431 
432     /**
433      * Additional check that the game address we are sending tokens to is a contract
434      * assemble the given address bytecode. If bytecode exists then the _addr is a contract.
435      */
436      function isContract(address _addr) private constant returns (bool is_contract) {
437        // retrieve the size of the code on target address, this needs assembly
438        uint length;
439        assembly { length := extcodesize(_addr) }
440        return length > 0;
441      }
442 
443     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
444     /**
445 
446     /**
447      * In case one of us dies, we need to replace ourselves.
448      */
449     function setAdministrator(address _identifier, bool _status)
450         onlyAdministrator()
451         public
452     {
453         administrators[_identifier] = _status;
454     }
455 
456     /**
457      * Precautionary measures in case we need to adjust the masternode rate.
458      */
459     function setStakingRequirement(uint256 _amountOfTokens)
460         onlyAdministrator()
461         public
462     {
463         stakingRequirement = _amountOfTokens;
464     }
465 
466     /**
467      * Add or remove game contract, which can accept tokens
468      */
469     function setCanAcceptTokens(address _address, bool _value)
470       onlyAdministrator()
471       public
472     {
473       canAcceptTokens_[_address] = _value;
474     }
475 
476     /**
477      * If we want to rebrand, we can.
478      */
479     function setName(string _name)
480         onlyAdministrator()
481         public
482     {
483         name = _name;
484     }
485 
486     /**
487      * If we want to rebrand, we can.
488      */
489     function setSymbol(string _symbol)
490         onlyAdministrator()
491         public
492     {
493         symbol = _symbol;
494     }
495 
496 
497     /*----------  HELPERS AND CALCULATORS  ----------*/
498     /**
499      * Method to view the current Ethereum stored in the contract
500      * Example: totalEthereumBalance()
501      */
502     function totalEthereumBalance()
503         public
504         view
505         returns(uint)
506     {
507         return address(this).balance;
508     }
509 
510     /**
511      * Retrieve the total token supply.
512      */
513     function totalSupply()
514         public
515         view
516         returns(uint256)
517     {
518         return tokenSupply_;
519     }
520 
521     /**
522      * Retrieve the tokens owned by the caller.
523      */
524     function myTokens()
525         public
526         view
527         returns(uint256)
528     {
529         address _customerAddress = msg.sender;
530         return balanceOf(_customerAddress);
531     }
532 
533     /**
534      * Retrieve the dividends owned by the caller.
535      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
536      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
537      * But in the internal calculations, we want them separate.
538      */
539     function myDividends(bool _includeReferralBonus)
540         public
541         view
542         returns(uint256)
543     {
544         address _customerAddress = msg.sender;
545         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
546     }
547 
548     /**
549      * Retrieve the token balance of any single address.
550      */
551     function balanceOf(address _customerAddress)
552         view
553         public
554         returns(uint256)
555     {
556         return tokenBalanceLedger_[_customerAddress];
557     }
558 
559     /**
560      * Retrieve the dividend balance of any single address.
561      */
562     function dividendsOf(address _customerAddress)
563         view
564         public
565         returns(uint256)
566     {
567         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
568     }
569 
570     /**
571      * Return the buy price of 1 individual token.
572      */
573     function sellPrice()
574         public
575         view
576         returns(uint256)
577     {
578         // our calculation relies on the token supply, so we need supply. Doh.
579         if(tokenSupply_ == 0){
580             return tokenPriceInitial_ - tokenPriceIncremental_;
581         } else {
582             uint256 _ethereum = tokensToEthereum_(1e18);
583             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
584             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
585             uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
586             return _taxedEthereum;
587         }
588     }
589 
590     /**
591      * Return the sell price of 1 individual token.
592      */
593     function buyPrice()
594         public
595         view
596         returns(uint256)
597     {
598         // our calculation relies on the token supply, so we need supply. Doh.
599         if(tokenSupply_ == 0){
600             return tokenPriceInitial_ + tokenPriceIncremental_;
601         } else {
602             uint256 _ethereum = tokensToEthereum_(1e18);
603             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
604             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
605             uint256 _taxedEthereum =  SafeMath.add(SafeMath.add(_ethereum, _dividends), _fundPayout);
606             return _taxedEthereum;
607         }
608     }
609 
610     /**
611      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
612      */
613     function calculateTokensReceived(uint256 _ethereumToSpend)
614         public
615         view
616         returns(uint256)
617     {
618         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
619         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereumToSpend, fundFee_), 100);
620         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereumToSpend, _dividends), _fundPayout);
621         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
622         return _amountOfTokens;
623     }
624 
625     /**
626      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
627      */
628     function calculateEthereumReceived(uint256 _tokensToSell)
629         public
630         view
631         returns(uint256)
632     {
633         require(_tokensToSell <= tokenSupply_);
634         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
635         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
636         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
637         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
638         return _taxedEthereum;
639     }
640 
641     /**
642      * Function for the frontend to show ether waiting to be send to fund in contract
643      */
644     function etherToSendFund()
645         public
646         view
647         returns(uint256) {
648         return SafeMath.sub(totalEthFundCollected, totalEthFundRecieved);
649     }
650 
651     /**
652      * Function for getting the current exitFee
653      */
654     function exitFee() public view returns (uint8) {
655         if ( now < ACTIVATION_TIME) {
656           return startExitFee_;
657         }
658         uint256 secondsPassed = now - ACTIVATION_TIME;
659         if (secondsPassed >= exitFeeFallDuration_) {
660             return finalExitFee_;
661         }
662         uint8 totalChange = startExitFee_ - finalExitFee_;
663         uint8 currentChange = uint8(totalChange * secondsPassed / exitFeeFallDuration_);
664         uint8 currentFee = startExitFee_- currentChange;
665         return currentFee;
666     }
667 
668     /*==========================================
669     =            INTERNAL FUNCTIONS            =
670     ==========================================*/
671 
672     // Make sure we will send back excess if user sends more then 2 ether before 80 ETH in contract
673     function purchaseInternal(uint256 _incomingEthereum, address _referredBy)
674       notContract()// no contracts allowed
675       internal
676       returns(uint256) {
677 
678       uint256 purchaseEthereum = _incomingEthereum;
679       uint256 excess;
680       if(purchaseEthereum > 2 ether) { // check if the transaction is over 2 ether
681           if (SafeMath.sub(address(this).balance, purchaseEthereum) <= 80 ether) { // if so check the contract is less then 80 ether
682               purchaseEthereum = 2 ether;
683               excess = SafeMath.sub(_incomingEthereum, purchaseEthereum);
684           }
685       }
686 
687       purchaseTokens(purchaseEthereum, _incomingEthereum, _referredBy, false);
688 
689       if (excess > 0) {
690         msg.sender.transfer(excess);
691       }
692     }
693 
694     function purchaseTokens(uint256 _purchaseEthereum, uint256 _incomingEthereum, address _referredBy, bool _isReinvest)
695         antiEarlyWhale(_incomingEthereum)
696         internal
697         returns(uint256)
698     {
699         // data setup
700         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_purchaseEthereum, entryFee_), 100);
701         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_purchaseEthereum, fundFee_), 100);
702         uint256 _dividends = SafeMath.sub(_undividedDividends, SafeMath.div(_undividedDividends, 3));
703         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_purchaseEthereum, _undividedDividends), _fundPayout);
704         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
705 
706         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
707         uint256 _fee = _dividends * magnitude;
708 
709         // no point in continuing execution if OP is a poor russian hacker
710         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
711         // (or hackers)
712         // and yes we know that the safemath function automatically rules out the "greater then" equation.
713         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
714 
715         // is the user referred by a masternode?
716         if(
717             // is this a referred purchase?
718             _referredBy != 0x0000000000000000000000000000000000000000 &&
719 
720             // no cheating!
721             _referredBy != msg.sender &&
722 
723             // does the referrer have at least X whole tokens?
724             // i.e is the referrer a godly chad masternode
725             tokenBalanceLedger_[_referredBy] >= stakingRequirement
726         ){
727             // wealth redistribution
728             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], SafeMath.div(_undividedDividends, 3));
729         } else {
730             // no ref purchase
731             // add the referral bonus back to the global dividends cake
732             _dividends = SafeMath.add(_dividends, SafeMath.div(_undividedDividends, 3));
733             _fee = _dividends * magnitude;
734         }
735 
736         // we can't give people infinite ethereum
737         if(tokenSupply_ > 0){
738 
739             // add tokens to the pool
740             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
741 
742             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
743             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
744 
745             // calculate the amount of tokens the customer receives over his purchase
746             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
747 
748         } else {
749             // add tokens to the pool
750             tokenSupply_ = _amountOfTokens;
751         }
752 
753         // update circulating supply & the ledger address for the customer
754         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
755 
756         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
757         //really i know you think you do but you don't
758         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
759         payoutsTo_[msg.sender] += _updatedPayouts;
760 
761         // fire event
762         emit onTokenPurchase(msg.sender, _purchaseEthereum, _amountOfTokens, _referredBy, _isReinvest, now, buyPrice());
763 
764         return _amountOfTokens;
765     }
766 
767     /**
768      * Calculate Token price based on an amount of incoming ethereum
769      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
770      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
771      */
772     function ethereumToTokens_(uint256 _ethereum)
773         internal
774         view
775         returns(uint256)
776     {
777         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
778         uint256 _tokensReceived =
779          (
780             (
781                 // underflow attempts BTFO
782                 SafeMath.sub(
783                     (sqrt
784                         (
785                             (_tokenPriceInitial**2)
786                             +
787                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
788                             +
789                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
790                             +
791                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
792                         )
793                     ), _tokenPriceInitial
794                 )
795             )/(tokenPriceIncremental_)
796         )-(tokenSupply_)
797         ;
798 
799         return _tokensReceived;
800     }
801 
802     /**
803      * Calculate token sell value.
804      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
805      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
806      */
807      function tokensToEthereum_(uint256 _tokens)
808         internal
809         view
810         returns(uint256)
811     {
812 
813         uint256 tokens_ = (_tokens + 1e18);
814         uint256 _tokenSupply = (tokenSupply_ + 1e18);
815         uint256 _etherReceived =
816         (
817             // underflow attempts BTFO
818             SafeMath.sub(
819                 (
820                     (
821                         (
822                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
823                         )-tokenPriceIncremental_
824                     )*(tokens_ - 1e18)
825                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
826             )
827         /1e18);
828         return _etherReceived;
829     }
830 
831 
832     //This is where all your gas goes, sorry
833     //Not sorry, you probably only paid 1 gwei
834     function sqrt(uint x) internal pure returns (uint y) {
835         uint z = (x + 1) / 2;
836         y = x;
837         while (z < y) {
838             y = z;
839             z = (x / z + z) / 2;
840         }
841     }
842 }
843 
844 /**
845  * @title SafeMath
846  * @dev Math operations with safety checks that throw on error
847  */
848 library SafeMath {
849 
850     /**
851     * @dev Multiplies two numbers, throws on overflow.
852     */
853     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
854         if (a == 0) {
855             return 0;
856         }
857         uint256 c = a * b;
858         assert(c / a == b);
859         return c;
860     }
861 
862     /**
863     * @dev Integer division of two numbers, truncating the quotient.
864     */
865     function div(uint256 a, uint256 b) internal pure returns (uint256) {
866         // assert(b > 0); // Solidity automatically throws when dividing by 0
867         uint256 c = a / b;
868         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
869         return c;
870     }
871 
872     /**
873     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
874     */
875     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
876         assert(b <= a);
877         return a - b;
878     }
879 
880     /**
881     * @dev Adds two numbers, throws on overflow.
882     */
883     function add(uint256 a, uint256 b) internal pure returns (uint256) {
884         uint256 c = a + b;
885         assert(c >= a);
886         return c;
887     }
888 }