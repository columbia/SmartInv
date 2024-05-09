1 pragma solidity ^0.4.25;
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
62     /*==============================
63     =            EVENTS            =
64     ==============================*/
65     event onTokenPurchase(
66         address indexed customerAddress,
67         uint256 incomingEthereum,
68         uint256 tokensMinted,
69         address indexed referredBy
70     );
71 
72     event onTokenSell(
73         address indexed customerAddress,
74         uint256 tokensBurned,
75         uint256 ethereumEarned
76     );
77 
78     event onReinvestment(
79         address indexed customerAddress,
80         uint256 ethereumReinvested,
81         uint256 tokensMinted
82     );
83 
84     event onWithdraw(
85         address indexed customerAddress,
86         uint256 ethereumWithdrawn
87     );
88 
89     // ERC20
90     event Transfer(
91         address indexed from,
92         address indexed to,
93         uint256 tokens
94     );
95 
96 
97     /*=====================================
98     =            CONFIGURABLES            =
99     =====================================*/
100     string public name = "Nasdaq";
101     string public symbol = "SHARES";
102     uint8 constant public decimals = 18;
103     uint8 constant internal dividendFee_ = 20; // 20% dividend fee on each buy and sell
104     uint8 constant internal fundFee_ = 5; // 5% to bond game
105     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
106     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
107     uint256 constant internal magnitude = 2**64;
108 
109     // Address to send the 5% Fee
110     address public giveEthFundAddress = 0x0;
111     bool public finalizedEthFundAddress = false;
112     uint256 public totalEthFundRecieved; // total ETH charity recieved from this contract
113     uint256 public totalEthFundCollected; // total ETH charity collected in this contract
114 
115     // proof of stake (defaults at 100 tokens)
116     uint256 public stakingRequirement = 25e18;
117 
118    /*================================
119     =            DATASETS            =
120     ================================*/
121     // amount of shares for each address (scaled number)
122     mapping(address => uint256) internal tokenBalanceLedger_;
123     mapping(address => uint256) internal referralBalance_;
124     mapping(address => int256) internal payoutsTo_;
125     uint256 internal tokenSupply_ = 0;
126     uint256 internal profitPerShare_;
127 
128     // administrator list (see above on what they can do)
129     mapping(address => bool) public administrators;
130 
131     // To whitelist game contracts on the platform
132     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept the exchanges tokens
133 
134     mapping(address => address) public stickyRef;
135 
136     /*=======================================
137     =            PUBLIC FUNCTIONS            =
138     =======================================*/
139     /*
140     * -- APPLICATION ENTRY POINTS --
141     */
142     constructor()
143         public
144     {
145         // add administrators here
146         administrators[0x7191cbD8BBCacFE989aa60FB0bE85B47f922FE21] = true;
147     }
148 
149 
150     /**
151      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
152      */
153     function buy(address _referredBy)
154         public
155         payable
156         returns(uint256)
157     {
158 
159         require(tx.gasprice <= 0.05 szabo);
160         purchaseTokens(msg.value, _referredBy);
161     }
162 
163     /**
164      * Fallback function to handle ethereum that was send straight to the contract
165      * Unfortunately we cannot use a referral address this way.
166      */
167     function()
168         payable
169         public
170     {
171 
172         require(tx.gasprice <= 0.05 szabo);
173         purchaseTokens(msg.value, 0x0);
174     }
175 
176     function updateFundAddress(address _newAddress)
177         onlyAdministrator()
178         public
179     {
180         require(finalizedEthFundAddress == false);
181         giveEthFundAddress = _newAddress;
182     }
183 
184     function finalizeFundAddress(address _finalAddress)
185         onlyAdministrator()
186         public
187     {
188         require(finalizedEthFundAddress == false);
189         giveEthFundAddress = _finalAddress;
190         finalizedEthFundAddress = true;
191     }
192 
193     function payFund() payable public {
194         uint256 ethToPay = SafeMath.sub(totalEthFundCollected, totalEthFundRecieved);
195         require(ethToPay > 0);
196         totalEthFundRecieved = SafeMath.add(totalEthFundRecieved, ethToPay);
197         if(!giveEthFundAddress.call.value(ethToPay)()) {
198             revert();
199         }
200     }
201 
202     /**
203      * Converts all of caller's dividends to tokens.
204      */
205     function reinvest()
206         onlyStronghands()
207         public
208     {
209         // fetch dividends
210         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
211 
212         // pay out the dividends virtually
213         address _customerAddress = msg.sender;
214         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
215 
216         // retrieve ref. bonus
217         _dividends += referralBalance_[_customerAddress];
218         referralBalance_[_customerAddress] = 0;
219 
220         // dispatch a buy order with the virtualized "withdrawn dividends"
221         uint256 _tokens = purchaseTokens(_dividends, 0x0);
222 
223         // fire event
224         emit onReinvestment(_customerAddress, _dividends, _tokens);
225     }
226 
227     /**
228      * Alias of sell() and withdraw().
229      */
230     function exit()
231         public
232     {
233         // get token count for caller & sell them all
234         address _customerAddress = msg.sender;
235         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
236         if(_tokens > 0) sell(_tokens);
237 
238         // lambo delivery service
239         withdraw();
240     }
241 
242     /**
243      * Withdraws all of the callers earnings.
244      */
245     function withdraw()
246         onlyStronghands()
247         public
248     {
249         // setup data
250         address _customerAddress = msg.sender;
251         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
252 
253         // update dividend tracker
254         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
255 
256         // add ref. bonus
257         _dividends += referralBalance_[_customerAddress];
258         referralBalance_[_customerAddress] = 0;
259 
260         // lambo delivery service
261         _customerAddress.transfer(_dividends);
262 
263         // fire event
264         emit onWithdraw(_customerAddress, _dividends);
265     }
266 
267     /**
268      * Liquifies tokens to ethereum.
269      */
270     function sell(uint256 _amountOfTokens)
271         onlyBagholders()
272         public
273     {
274         // setup data
275         address _customerAddress = msg.sender;
276         // russian hackers BTFO
277         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
278         uint256 _tokens = _amountOfTokens;
279         uint256 _ethereum = tokensToEthereum_(_tokens);
280 
281         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
282         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
283         uint256 _refPayout = _dividends / 3;
284         _dividends = SafeMath.sub(_dividends, _refPayout);
285         (_dividends,) = handleRef(stickyRef[msg.sender], _refPayout, _dividends, 0);
286 
287         // Take out dividends and then _fundPayout
288         uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
289 
290         // Add ethereum to send to fund
291         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
292 
293         // burn the sold tokens
294         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
295         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
296 
297         // update dividends tracker
298         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
299         payoutsTo_[_customerAddress] -= _updatedPayouts;
300 
301         // dividing by zero is a bad idea
302         if (tokenSupply_ > 0) {
303             // update the amount of dividends per token
304             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
305         }
306 
307         // fire event
308         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
309     }
310 
311 
312     /**
313      * Transfer tokens from the caller to a new holder.
314      * REMEMBER THIS IS 0% TRANSFER FEE
315      */
316     function transfer(address _toAddress, uint256 _amountOfTokens)
317         onlyBagholders()
318         public
319         returns(bool)
320     {
321         // setup
322         address _customerAddress = msg.sender;
323 
324         // make sure we have the requested tokens
325         // also disables transfers until ambassador phase is over
326         // ( we dont want whale premines )
327         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
328 
329         // withdraw all outstanding dividends first
330         if(myDividends(true) > 0) withdraw();
331 
332         // exchange tokens
333         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
334         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
335 
336         // update dividend trackers
337         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
338         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
339 
340 
341         // fire event
342         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
343 
344         // ERC20
345         return true;
346     }
347 
348     /**
349     * Transfer token to a specified address and forward the data to recipient
350     * ERC-677 standard
351     * https://github.com/ethereum/EIPs/issues/677
352     * @param _to    Receiver address.
353     * @param _value Amount of tokens that will be transferred.
354     * @param _data  Transaction metadata.
355     */
356     function transferAndCall(address _to, uint256 _value, bytes _data) external returns (bool) {
357       require(_to != address(0));
358       require(canAcceptTokens_[_to] == true); // security check that contract approved by the exchange
359       require(transfer(_to, _value)); // do a normal token transfer to the contract
360 
361       if (isContract(_to)) {
362         AcceptsExchange receiver = AcceptsExchange(_to);
363         require(receiver.tokenFallback(msg.sender, _value, _data));
364       }
365 
366       return true;
367     }
368 
369     /**
370      * Additional check that the game address we are sending tokens to is a contract
371      * assemble the given address bytecode. If bytecode exists then the _addr is a contract.
372      */
373      function isContract(address _addr) private constant returns (bool is_contract) {
374        // retrieve the size of the code on target address, this needs assembly
375        uint length;
376        assembly { length := extcodesize(_addr) }
377        return length > 0;
378      }
379 
380     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
381     /**
382 
383     /**
384      * In case one of us dies, we need to replace ourselves.
385      */
386     function setAdministrator(address _identifier, bool _status)
387         onlyAdministrator()
388         public
389     {
390         administrators[_identifier] = _status;
391     }
392 
393     /**
394      * Precautionary measures in case we need to adjust the masternode rate.
395      */
396     function setStakingRequirement(uint256 _amountOfTokens)
397         onlyAdministrator()
398         public
399     {
400         stakingRequirement = _amountOfTokens;
401     }
402 
403     /**
404      * Add or remove game contract, which can accept tokens
405      */
406     function setCanAcceptTokens(address _address, bool _value)
407       onlyAdministrator()
408       public
409     {
410       canAcceptTokens_[_address] = _value;
411     }
412 
413     /**
414      * If we want to rebrand, we can.
415      */
416     function setName(string _name)
417         onlyAdministrator()
418         public
419     {
420         name = _name;
421     }
422 
423     /**
424      * If we want to rebrand, we can.
425      */
426     function setSymbol(string _symbol)
427         onlyAdministrator()
428         public
429     {
430         symbol = _symbol;
431     }
432 
433 
434     /*----------  HELPERS AND CALCULATORS  ----------*/
435     /**
436      * Method to view the current Ethereum stored in the contract
437      * Example: totalEthereumBalance()
438      */
439     function totalEthereumBalance()
440         public
441         view
442         returns(uint)
443     {
444         return address(this).balance;
445     }
446 
447     /**
448      * Retrieve the total token supply.
449      */
450     function totalSupply()
451         public
452         view
453         returns(uint256)
454     {
455         return tokenSupply_;
456     }
457 
458     /**
459      * Retrieve the tokens owned by the caller.
460      */
461     function myTokens()
462         public
463         view
464         returns(uint256)
465     {
466         address _customerAddress = msg.sender;
467         return balanceOf(_customerAddress);
468     }
469 
470     /**
471      * Retrieve the dividends owned by the caller.
472      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
473      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
474      * But in the internal calculations, we want them separate.
475      */
476     function myDividends(bool _includeReferralBonus)
477         public
478         view
479         returns(uint256)
480     {
481         address _customerAddress = msg.sender;
482         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
483     }
484 
485     /**
486      * Retrieve the token balance of any single address.
487      */
488     function balanceOf(address _customerAddress)
489         view
490         public
491         returns(uint256)
492     {
493         return tokenBalanceLedger_[_customerAddress];
494     }
495 
496     /**
497      * Retrieve the dividend balance of any single address.
498      */
499     function dividendsOf(address _customerAddress)
500         view
501         public
502         returns(uint256)
503     {
504         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
505     }
506 
507     /**
508      * Return the buy price of 1 individual token.
509      */
510     function sellPrice()
511         public
512         view
513         returns(uint256)
514     {
515         // our calculation relies on the token supply, so we need supply. Doh.
516         if(tokenSupply_ == 0){
517             return tokenPriceInitial_ - tokenPriceIncremental_;
518         } else {
519             uint256 _ethereum = tokensToEthereum_(1e18);
520             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
521             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
522             uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
523             return _taxedEthereum;
524         }
525     }
526 
527     /**
528      * Return the sell price of 1 individual token.
529      */
530     function buyPrice()
531         public
532         view
533         returns(uint256)
534     {
535         // our calculation relies on the token supply, so we need supply. Doh.
536         if(tokenSupply_ == 0){
537             return tokenPriceInitial_ + tokenPriceIncremental_;
538         } else {
539             uint256 _ethereum = tokensToEthereum_(1e18);
540             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
541             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
542             uint256 _taxedEthereum =  SafeMath.add(SafeMath.add(_ethereum, _dividends), _fundPayout);
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
555         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, dividendFee_), 100);
556         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereumToSpend, fundFee_), 100);
557         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereumToSpend, _dividends), _fundPayout);
558         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
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
572         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
573         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
574         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
575         return _taxedEthereum;
576     }
577 
578     /**
579      * Function for the frontend to show ether waiting to be send to fund in contract
580      */
581     function etherToSendFund()
582         public
583         view
584         returns(uint256) {
585         return SafeMath.sub(totalEthFundCollected, totalEthFundRecieved);
586     }
587 
588 
589     /*==========================================
590     =            INTERNAL FUNCTIONS            =
591     ==========================================*/
592 
593     // Make sure we will send back excess if user sends more then 5 ether before 100 ETH in contract
594     function purchaseInternal(uint256 _incomingEthereum, address _referredBy)
595       notContract()// no contracts allowed
596       internal
597       returns(uint256) {
598 
599       uint256 purchaseEthereum = _incomingEthereum;
600       uint256 excess;
601       if(purchaseEthereum > 2.5 ether) { // check if the transaction is over 2.5 ether
602           if (SafeMath.sub(address(this).balance, purchaseEthereum) <= 100 ether) { // if so check the contract is less then 100 ether
603               purchaseEthereum = 2.5 ether;
604               excess = SafeMath.sub(_incomingEthereum, purchaseEthereum);
605           }
606       }
607 
608       purchaseTokens(purchaseEthereum, _referredBy);
609 
610       if (excess > 0) {
611         msg.sender.transfer(excess);
612       }
613     }
614 
615     function handleRef(address _ref, uint _referralBonus, uint _currentDividends, uint _currentFee) internal returns (uint, uint){
616         uint _dividends = _currentDividends;
617         uint _fee = _currentFee;
618         address _referredBy = stickyRef[msg.sender];
619         if (_referredBy == address(0x0)){
620             _referredBy = _ref;
621         }
622         // is the user referred by a masternode?
623         if(
624             // is this a referred purchase?
625             _referredBy != 0x0000000000000000000000000000000000000000 &&
626 
627             // no cheating!
628             _referredBy != msg.sender &&
629 
630             // does the referrer have at least X whole tokens?
631             // i.e is the referrer a godly chad masternode
632             tokenBalanceLedger_[_referredBy] >= stakingRequirement
633         ){
634             // wealth redistribution
635             if (stickyRef[msg.sender] == address(0x0)){
636                 stickyRef[msg.sender] = _referredBy;
637             }
638             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus/2);
639             address currentRef = stickyRef[_referredBy];
640             if (currentRef != address(0x0) && tokenBalanceLedger_[currentRef] >= stakingRequirement){
641                 referralBalance_[currentRef] = SafeMath.add(referralBalance_[currentRef], (_referralBonus/10)*3);
642                 currentRef = stickyRef[currentRef];
643                 if (currentRef != address(0x0) && tokenBalanceLedger_[currentRef] >= stakingRequirement){
644                     referralBalance_[currentRef] = SafeMath.add(referralBalance_[currentRef], (_referralBonus/10)*2);
645                 }
646                 else{
647                     _dividends = SafeMath.add(_dividends, _referralBonus - _referralBonus/2 - (_referralBonus/10)*3);
648                     _fee = _dividends * magnitude;
649                 }
650             }
651             else{
652                 _dividends = SafeMath.add(_dividends, _referralBonus - _referralBonus/2);
653                 _fee = _dividends * magnitude;
654             }
655 
656 
657         } else {
658             // no ref purchase
659             // add the referral bonus back to the global dividends cake
660             _dividends = SafeMath.add(_dividends, _referralBonus);
661             _fee = _dividends * magnitude;
662         }
663         return (_dividends, _fee);
664     }
665 
666 
667     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
668         internal
669         returns(uint256)
670     {
671         // data setup
672         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);
673         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
674         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_incomingEthereum, fundFee_), 100);
675         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
676         uint256 _fee;
677         (_dividends, _fee) = handleRef(_referredBy, _referralBonus, _dividends, _fee);
678         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_incomingEthereum, _dividends), _fundPayout);
679         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
680 
681         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
682 
683 
684         // no point in continuing execution if OP is a poor russian hacker
685         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
686         // (or hackers)
687         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
688         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
689 
690 
691 
692         // we can't give people infinite ethereum
693         if(tokenSupply_ > 0){
694 
695             // add tokens to the pool
696             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
697 
698             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
699             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
700 
701             // calculate the amount of tokens the customer receives over his purchase
702             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
703 
704         } else {
705             // add tokens to the pool
706             tokenSupply_ = _amountOfTokens;
707         }
708 
709         // update circulating supply & the ledger address for the customer
710         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
711 
712         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
713         //really i know you think you do but you don't
714         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
715         payoutsTo_[msg.sender] += _updatedPayouts;
716 
717         // fire event
718         emit onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
719 
720         return _amountOfTokens;
721     }
722 
723     /**
724      * Calculate Token price based on an amount of incoming ethereum
725      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
726      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
727      */
728     function ethereumToTokens_(uint256 _ethereum)
729         internal
730         view
731         returns(uint256)
732     {
733         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
734         uint256 _tokensReceived =
735          (
736             (
737                 // underflow attempts BTFO
738                 SafeMath.sub(
739                     (sqrt
740                         (
741                             (_tokenPriceInitial**2)
742                             +
743                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
744                             +
745                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
746                             +
747                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
748                         )
749                     ), _tokenPriceInitial
750                 )
751             )/(tokenPriceIncremental_)
752         )-(tokenSupply_)
753         ;
754 
755         return _tokensReceived;
756     }
757 
758     /**
759      * Calculate token sell value.
760      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
761      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
762      */
763      function tokensToEthereum_(uint256 _tokens)
764         internal
765         view
766         returns(uint256)
767     {
768 
769         uint256 tokens_ = (_tokens + 1e18);
770         uint256 _tokenSupply = (tokenSupply_ + 1e18);
771         uint256 _etherReceived =
772         (
773             // underflow attempts BTFO
774             SafeMath.sub(
775                 (
776                     (
777                         (
778                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
779                         )-tokenPriceIncremental_
780                     )*(tokens_ - 1e18)
781                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
782             )
783         /1e18);
784         return _etherReceived;
785     }
786 
787 
788     //This is where all your gas goes, sorry
789     //Not sorry, you probably only paid 1 gwei
790     function sqrt(uint x) internal pure returns (uint y) {
791         uint z = (x + 1) / 2;
792         y = x;
793         while (z < y) {
794             y = z;
795             z = (x / z + z) / 2;
796         }
797     }
798 }
799 
800 /**
801  * @title SafeMath
802  * @dev Math operations with safety checks that throw on error
803  */
804 library SafeMath {
805 
806     /**
807     * @dev Multiplies two numbers, throws on overflow.
808     */
809     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
810         if (a == 0) {
811             return 0;
812         }
813         uint256 c = a * b;
814         assert(c / a == b);
815         return c;
816     }
817 
818     /**
819     * @dev Integer division of two numbers, truncating the quotient.
820     */
821     function div(uint256 a, uint256 b) internal pure returns (uint256) {
822         // assert(b > 0); // Solidity automatically throws when dividing by 0
823         uint256 c = a / b;
824         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
825         return c;
826     }
827 
828     /**
829     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
830     */
831     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
832         assert(b <= a);
833         return a - b;
834     }
835 
836     /**
837     * @dev Adds two numbers, throws on overflow.
838     */
839     function add(uint256 a, uint256 b) internal pure returns (uint256) {
840         uint256 c = a + b;
841         assert(c >= a);
842         return c;
843     }
844 }