1 pragma solidity ^0.4.21;
2 
3 
4 
5 /**
6  * Definition of contract accepting DailyDivs tokens
7  * Games, casinos, anything can reuse this contract to support DailyDivs tokens
8  */
9 contract AcceptsDailyDivs {
10     DailyDivs public tokenContract;
11 
12     function AcceptsDailyDivs(address _tokenContract) public {
13         tokenContract = DailyDivs(_tokenContract);
14     }
15 
16     modifier onlyTokenContract {
17         require(msg.sender == address(tokenContract));
18         _;
19     }
20 
21     /**
22     * @dev Standard ERC677 function that will handle incoming token transfers.
23     *
24     * @param _from  Token sender address.
25     * @param _value Amount of tokens.
26     * @param _data  Transaction metadata.
27     */
28     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
29 }
30 
31 
32 contract DailyDivs {
33     /*=================================
34     =            MODIFIERS            =
35     =================================*/
36     // only people with tokens
37     modifier onlyBagholders() {
38         require(myTokens() > 0);
39         _;
40     }
41 
42     // only people with profits
43     modifier onlyStronghands() {
44         require(myDividends(true) > 0);
45         _;
46     }
47 
48     modifier notContract() {
49       require (msg.sender == tx.origin);
50       _;
51     }
52 
53     // administrators can:
54     // -> change the name of the contract
55     // -> change the name of the token
56     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
57     // they CANNOT:
58     // -> take funds
59     // -> disable withdrawals
60     // -> kill the contract
61     // -> change the price of tokens
62     modifier onlyAdministrator(){
63         address _customerAddress = msg.sender;
64         require(administrators[_customerAddress]);
65         _;
66     }
67     
68     uint ACTIVATION_TIME = 1537743600;
69 
70 
71     // ensures that the first tokens in the contract will be equally distributed
72     // meaning, no divine dump will be ever possible
73     // result: healthy longevity.
74     modifier antiEarlyWhale(uint256 _amountOfEthereum){
75         address _customerAddress = msg.sender;
76         
77         if (now >= ACTIVATION_TIME) {
78             onlyAmbassadors = false;
79         }
80 
81         // are we still in the vulnerable phase?
82         // if so, enact anti early whale protocol
83         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
84             require(
85                 // is the customer in the ambassador list?
86                 ambassadors_[_customerAddress] == true &&
87 
88                 // does the customer purchase exceed the max ambassador quota?
89                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
90 
91             );
92 
93             // updated the accumulated quota
94             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
95 
96             // execute
97             _;
98         } else {
99             // in case the ether count drops low, the ambassador phase won't reinitiate
100             onlyAmbassadors = false;
101             _;
102         }
103 
104     }
105 
106     /*==============================
107     =            EVENTS            =
108     ==============================*/
109     event onTokenPurchase(
110         address indexed customerAddress,
111         uint256 incomingEthereum,
112         uint256 tokensMinted,
113         address indexed referredBy
114     );
115 
116     event onTokenSell(
117         address indexed customerAddress,
118         uint256 tokensBurned,
119         uint256 ethereumEarned
120     );
121 
122     event onReinvestment(
123         address indexed customerAddress,
124         uint256 ethereumReinvested,
125         uint256 tokensMinted
126     );
127 
128     event onWithdraw(
129         address indexed customerAddress,
130         uint256 ethereumWithdrawn
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
144     string public name = "EXODUS XCHANGE";
145     string public symbol = "EXE";
146     uint8 constant public decimals = 18;
147     uint8 constant internal dividendFee_ = 20; // 20% dividend fee on each buy and sell
148     uint8 constant internal fundFee_ = 5; // 5% investment fund fee on each buy and sell
149     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
150     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
151     uint256 constant internal magnitude = 2**64;
152 
153     // Address to send the 5% Fee
154     //  70% to Earn Game / 30% to Dev Fund
155     
156     address constant public giveEthFundAddress = 0x447FF830ba5F7fAf3d504273394370053d086C08;
157     uint256 public totalEthFundRecieved; // total ETH charity recieved from this contract
158     uint256 public totalEthFundCollected; // total ETH charity collected in this contract
159 
160     // proof of stake (defaults at 100 tokens)
161     uint256 public stakingRequirement = 25e18;
162 
163     // ambassador program
164     mapping(address => bool) internal ambassadors_;
165     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
166     uint256 constant internal ambassadorQuota_ = 7 ether;
167 
168 
169 
170    /*================================
171     =            DATASETS            =
172     ================================*/
173     // amount of shares for each address (scaled number)
174     mapping(address => uint256) internal tokenBalanceLedger_;
175     mapping(address => uint256) internal referralBalance_;
176     mapping(address => int256) internal payoutsTo_;
177     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
178     uint256 internal tokenSupply_ = 0;
179     uint256 internal profitPerShare_;
180 
181     // administrator list (see above on what they can do)
182     mapping(address => bool) public administrators;
183 
184     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
185     bool public onlyAmbassadors = true;
186 
187     // Special DailyDivs Platform control from scam game contracts on DailyDivs platform
188     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept DailyDivs tokens
189 
190     mapping(address => address) public stickyRef;
191 
192     /*=======================================
193     =            PUBLIC FUNCTIONS            =
194     =======================================*/
195     /*
196     * -- APPLICATION ENTRY POINTS --
197     */
198     function DailyDivs()
199         public
200     {
201         // add administrators here
202         administrators[0x2f4A12500A2E512090D164a52322583Bd293f3fE] = true;
203 
204         // add the ambassadors here - Tokens will be distributed to these addresses from main premine
205         ambassadors_[0xbb5976509F41dEbA91F6249901B0BC0Ca7ada275] = true;
206         // add the ambassadors here - Tokens will be distributed to these addresses from main premine
207         ambassadors_[0x1174D17880121CfE44ae4d0cF84B4EA7C52f33d2] = true;
208        // add the ambassadors here - Tokens will be distributed to these addresses from main premine
209         ambassadors_[0x8721a7477c697fE56Cba5Bfb769cA24a697CFB16] = true;
210         // add the ambassadors here - Tokens will be distributed to these addresses from main premine
211         ambassadors_[0xae28A91Fc7dF7FE7aE8E891E8580564eCA65e7CC] = true;
212         // add the ambassadors here - Tokens will be distributed to these addresses from main premine
213         ambassadors_[0xBd4D528f5b0C99775679d2A6d71821516E3f90BE] = true;
214         // add the ambassadors here - Tokens will be distributed to these addresses from main premine
215         ambassadors_[0x41FE3738B503cBaFD01C1Fd8DD66b7fE6Ec11b01] = true;
216         // add the ambassadors here - Tokens will be distributed to these addresses from main premine
217             ambassadors_[0x723A38b08c7282521d7E6Fab9fF146035658222E] = true;
218         
219     }
220 
221 
222     /**
223      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
224      */
225     function buy(address _referredBy)
226         public
227         payable
228         returns(uint256)
229     {
230         
231         require(tx.gasprice <= 0.05 szabo);
232         purchaseTokens(msg.value, _referredBy);
233     }
234 
235     /**
236      * Fallback function to handle ethereum that was send straight to the contract
237      * Unfortunately we cannot use a referral address this way.
238      */
239     function()
240         payable
241         public
242     {
243         
244         require(tx.gasprice <= 0.05 szabo);
245         purchaseTokens(msg.value, 0x0);
246     }
247 
248     /**
249      * Sends FUND money to the 70/30 Contract
250    
251      */
252     function payFund() payable public {
253       uint256 ethToPay = SafeMath.sub(totalEthFundCollected, totalEthFundRecieved);
254       require(ethToPay > 1);
255       totalEthFundRecieved = SafeMath.add(totalEthFundRecieved, ethToPay);
256       if(!giveEthFundAddress.call.value(ethToPay).gas(400000)()) {
257          totalEthFundRecieved = SafeMath.sub(totalEthFundRecieved, ethToPay);
258       }
259     }
260 
261     /**
262      * Converts all of caller's dividends to tokens.
263      */
264     function reinvest()
265         onlyStronghands()
266         public
267     {
268         // fetch dividends
269         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
270 
271         // pay out the dividends virtually
272         address _customerAddress = msg.sender;
273         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
274 
275         // retrieve ref. bonus
276         _dividends += referralBalance_[_customerAddress];
277         referralBalance_[_customerAddress] = 0;
278 
279         // dispatch a buy order with the virtualized "withdrawn dividends"
280         uint256 _tokens = purchaseTokens(_dividends, 0x0);
281 
282         // fire event
283         onReinvestment(_customerAddress, _dividends, _tokens);
284     }
285 
286     /**
287      * Alias of sell() and withdraw().
288      */
289     function exit()
290         public
291     {
292         // get token count for caller & sell them all
293         address _customerAddress = msg.sender;
294         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
295         if(_tokens > 0) sell(_tokens);
296 
297         // lambo delivery service
298         withdraw();
299     }
300 
301     /**
302      * Withdraws all of the callers earnings.
303      */
304     function withdraw()
305         onlyStronghands()
306         public
307     {
308         // setup data
309         address _customerAddress = msg.sender;
310         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
311 
312         // update dividend tracker
313         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
314 
315         // add ref. bonus
316         _dividends += referralBalance_[_customerAddress];
317         referralBalance_[_customerAddress] = 0;
318 
319         // lambo delivery service
320         _customerAddress.transfer(_dividends);
321 
322         // fire event
323         onWithdraw(_customerAddress, _dividends);
324     }
325 
326     /**
327      * Liquifies tokens to ethereum.
328      */
329     function sell(uint256 _amountOfTokens)
330         onlyBagholders()
331         public
332     {
333         // setup data
334         address _customerAddress = msg.sender;
335         // russian hackers BTFO
336         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
337         uint256 _tokens = _amountOfTokens;
338         uint256 _ethereum = tokensToEthereum_(_tokens);
339 
340         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
341         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
342         uint256 _refPayout = _dividends / 3;
343         _dividends = SafeMath.sub(_dividends, _refPayout);
344         (_dividends,) = handleRef(stickyRef[msg.sender], _refPayout, _dividends, 0);
345 
346         // Take out dividends and then _fundPayout
347         uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
348 
349         // Add ethereum to send to fund
350         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
351 
352         // burn the sold tokens
353         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
354         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
355 
356         // update dividends tracker
357         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
358         payoutsTo_[_customerAddress] -= _updatedPayouts;
359 
360         // dividing by zero is a bad idea
361         if (tokenSupply_ > 0) {
362             // update the amount of dividends per token
363             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
364         }
365 
366         // fire event
367         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
368     }
369 
370 
371     /**
372      * Transfer tokens from the caller to a new holder.
373      * REMEMBER THIS IS 0% TRANSFER FEE
374      */
375     function transfer(address _toAddress, uint256 _amountOfTokens)
376         onlyBagholders()
377         public
378         returns(bool)
379     {
380         // setup
381         address _customerAddress = msg.sender;
382 
383         // make sure we have the requested tokens
384         // also disables transfers until ambassador phase is over
385         // ( we dont want whale premines )
386         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
387 
388         // withdraw all outstanding dividends first
389         if(myDividends(true) > 0) withdraw();
390 
391         // exchange tokens
392         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
393         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
394 
395         // update dividend trackers
396         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
397         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
398 
399 
400         // fire event
401         Transfer(_customerAddress, _toAddress, _amountOfTokens);
402 
403         // ERC20
404         return true;
405     }
406 
407     /**
408     * Transfer token to a specified address and forward the data to recipient
409     * ERC-677 standard
410     * https://github.com/ethereum/EIPs/issues/677
411     * @param _to    Receiver address.
412     * @param _value Amount of tokens that will be transferred.
413     * @param _data  Transaction metadata.
414     */
415     function transferAndCall(address _to, uint256 _value, bytes _data) external returns (bool) {
416       require(_to != address(0));
417       require(canAcceptTokens_[_to] == true); // security check that contract approved by DailyDivs platform
418       require(transfer(_to, _value)); // do a normal token transfer to the contract
419 
420       if (isContract(_to)) {
421         AcceptsDailyDivs receiver = AcceptsDailyDivs(_to);
422         require(receiver.tokenFallback(msg.sender, _value, _data));
423       }
424 
425       return true;
426     }
427 
428     /**
429      * Additional check that the game address we are sending tokens to is a contract
430      * assemble the given address bytecode. If bytecode exists then the _addr is a contract.
431      */
432      function isContract(address _addr) private constant returns (bool is_contract) {
433        // retrieve the size of the code on target address, this needs assembly
434        uint length;
435        assembly { length := extcodesize(_addr) }
436        return length > 0;
437      }
438 
439     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
440     /**
441      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
442      */
443     //function disableInitialStage()
444     //    onlyAdministrator()
445     //    public
446     //{
447     //    onlyAmbassadors = false;
448     //}
449 
450     /**
451      * In case one of us dies, we need to replace ourselves.
452      */
453     function setAdministrator(address _identifier, bool _status)
454         onlyAdministrator()
455         public
456     {
457         administrators[_identifier] = _status;
458     }
459 
460     /**
461      * Precautionary measures in case we need to adjust the masternode rate.
462      */
463     function setStakingRequirement(uint256 _amountOfTokens)
464         onlyAdministrator()
465         public
466     {
467         stakingRequirement = _amountOfTokens;
468     }
469 
470     /**
471      * Add or remove game contract, which can accept DailyDivs tokens
472      */
473     function setCanAcceptTokens(address _address, bool _value)
474       onlyAdministrator()
475       public
476     {
477       canAcceptTokens_[_address] = _value;
478     }
479 
480     /**
481      * If we want to rebrand, we can.
482      */
483     function setName(string _name)
484         onlyAdministrator()
485         public
486     {
487         name = _name;
488     }
489 
490     /**
491      * If we want to rebrand, we can.
492      */
493     function setSymbol(string _symbol)
494         onlyAdministrator()
495         public
496     {
497         symbol = _symbol;
498     }
499 
500 
501     /*----------  HELPERS AND CALCULATORS  ----------*/
502     /**
503      * Method to view the current Ethereum stored in the contract
504      * Example: totalEthereumBalance()
505      */
506     function totalEthereumBalance()
507         public
508         view
509         returns(uint)
510     {
511         return this.balance;
512     }
513 
514     /**
515      * Retrieve the total token supply.
516      */
517     function totalSupply()
518         public
519         view
520         returns(uint256)
521     {
522         return tokenSupply_;
523     }
524 
525     /**
526      * Retrieve the tokens owned by the caller.
527      */
528     function myTokens()
529         public
530         view
531         returns(uint256)
532     {
533         address _customerAddress = msg.sender;
534         return balanceOf(_customerAddress);
535     }
536 
537     /**
538      * Retrieve the dividends owned by the caller.
539      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
540      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
541      * But in the internal calculations, we want them separate.
542      */
543     function myDividends(bool _includeReferralBonus)
544         public
545         view
546         returns(uint256)
547     {
548         address _customerAddress = msg.sender;
549         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
550     }
551 
552     /**
553      * Retrieve the token balance of any single address.
554      */
555     function balanceOf(address _customerAddress)
556         view
557         public
558         returns(uint256)
559     {
560         return tokenBalanceLedger_[_customerAddress];
561     }
562 
563     /**
564      * Retrieve the dividend balance of any single address.
565      */
566     function dividendsOf(address _customerAddress)
567         view
568         public
569         returns(uint256)
570     {
571         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
572     }
573 
574     /**
575      * Return the buy price of 1 individual token.
576      */
577     function sellPrice()
578         public
579         view
580         returns(uint256)
581     {
582         // our calculation relies on the token supply, so we need supply. Doh.
583         if(tokenSupply_ == 0){
584             return tokenPriceInitial_ - tokenPriceIncremental_;
585         } else {
586             uint256 _ethereum = tokensToEthereum_(1e18);
587             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
588             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
589             uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
590             return _taxedEthereum;
591         }
592     }
593 
594     /**
595      * Return the sell price of 1 individual token.
596      */
597     function buyPrice()
598         public
599         view
600         returns(uint256)
601     {
602         // our calculation relies on the token supply, so we need supply. Doh.
603         if(tokenSupply_ == 0){
604             return tokenPriceInitial_ + tokenPriceIncremental_;
605         } else {
606             uint256 _ethereum = tokensToEthereum_(1e18);
607             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
608             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
609             uint256 _taxedEthereum =  SafeMath.add(SafeMath.add(_ethereum, _dividends), _fundPayout);
610             return _taxedEthereum;
611         }
612     }
613 
614     /**
615      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
616      */
617     function calculateTokensReceived(uint256 _ethereumToSpend)
618         public
619         view
620         returns(uint256)
621     {
622         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, dividendFee_), 100);
623         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereumToSpend, fundFee_), 100);
624         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereumToSpend, _dividends), _fundPayout);
625         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
626         return _amountOfTokens;
627     }
628 
629     /**
630      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
631      */
632     function calculateEthereumReceived(uint256 _tokensToSell)
633         public
634         view
635         returns(uint256)
636     {
637         require(_tokensToSell <= tokenSupply_);
638         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
639         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
640         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
641         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
642         return _taxedEthereum;
643     }
644 
645     /**
646      * Function for the frontend to show ether waiting to be send to fund in contract
647      */
648     function etherToSendFund()
649         public
650         view
651         returns(uint256) {
652         return SafeMath.sub(totalEthFundCollected, totalEthFundRecieved);
653     }
654 
655 
656     /*==========================================
657     =            INTERNAL FUNCTIONS            =
658     ==========================================*/
659 
660     // Make sure we will send back excess if user sends more then 5 ether before 100 ETH in contract
661     function purchaseInternal(uint256 _incomingEthereum, address _referredBy)
662       notContract()// no contracts allowed
663       internal
664       returns(uint256) {
665 
666       uint256 purchaseEthereum = _incomingEthereum;
667       uint256 excess;
668       if(purchaseEthereum > 2.5 ether) { // check if the transaction is over 2.5 ether
669           if (SafeMath.sub(address(this).balance, purchaseEthereum) <= 100 ether) { // if so check the contract is less then 100 ether
670               purchaseEthereum = 2.5 ether;
671               excess = SafeMath.sub(_incomingEthereum, purchaseEthereum);
672           }
673       }
674 
675       purchaseTokens(purchaseEthereum, _referredBy);
676 
677       if (excess > 0) {
678         msg.sender.transfer(excess);
679       }
680     }
681 
682     function handleRef(address _ref, uint _referralBonus, uint _currentDividends, uint _currentFee) internal returns (uint, uint){
683         uint _dividends = _currentDividends;
684         uint _fee = _currentFee;
685         address _referredBy = stickyRef[msg.sender];
686         if (_referredBy == address(0x0)){
687             _referredBy = _ref;
688         }
689         // is the user referred by a masternode?
690         if(
691             // is this a referred purchase?
692             _referredBy != 0x0000000000000000000000000000000000000000 &&
693 
694             // no cheating!
695             _referredBy != msg.sender &&
696 
697             // does the referrer have at least X whole tokens?
698             // i.e is the referrer a godly chad masternode
699             tokenBalanceLedger_[_referredBy] >= stakingRequirement
700         ){
701             // wealth redistribution
702             if (stickyRef[msg.sender] == address(0x0)){
703                 stickyRef[msg.sender] = _referredBy;
704             }
705             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus/2);
706             address currentRef = stickyRef[_referredBy];
707             if (currentRef != address(0x0) && tokenBalanceLedger_[currentRef] >= stakingRequirement){
708                 referralBalance_[currentRef] = SafeMath.add(referralBalance_[currentRef], (_referralBonus/10)*3);
709                 currentRef = stickyRef[currentRef];
710                 if (currentRef != address(0x0) && tokenBalanceLedger_[currentRef] >= stakingRequirement){
711                     referralBalance_[currentRef] = SafeMath.add(referralBalance_[currentRef], (_referralBonus/10)*2);
712                 }
713                 else{
714                     _dividends = SafeMath.add(_dividends, _referralBonus - _referralBonus/2 - (_referralBonus/10)*3);
715                     _fee = _dividends * magnitude;
716                 }
717             }
718             else{
719                 _dividends = SafeMath.add(_dividends, _referralBonus - _referralBonus/2);
720                 _fee = _dividends * magnitude;
721             }
722             
723             
724         } else {
725             // no ref purchase
726             // add the referral bonus back to the global dividends cake
727             _dividends = SafeMath.add(_dividends, _referralBonus);
728             _fee = _dividends * magnitude;
729         }
730         return (_dividends, _fee);
731     }
732 
733 
734     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
735         antiEarlyWhale(_incomingEthereum)
736         internal
737         returns(uint256)
738     {
739         // data setup
740         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);
741         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
742         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_incomingEthereum, fundFee_), 100);
743         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
744         uint256 _fee;
745         (_dividends, _fee) = handleRef(_referredBy, _referralBonus, _dividends, _fee);
746         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_incomingEthereum, _dividends), _fundPayout);
747         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
748 
749         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
750 
751 
752         // no point in continuing execution if OP is a poorfag russian hacker
753         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
754         // (or hackers)
755         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
756         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
757 
758 
759 
760         // we can't give people infinite ethereum
761         if(tokenSupply_ > 0){
762  
763             // add tokens to the pool
764             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
765 
766             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
767             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
768 
769             // calculate the amount of tokens the customer receives over his purchase
770             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
771 
772         } else {
773             // add tokens to the pool
774             tokenSupply_ = _amountOfTokens;
775         }
776 
777         // update circulating supply & the ledger address for the customer
778         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
779 
780         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
781         //really i know you think you do but you don't
782         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
783         payoutsTo_[msg.sender] += _updatedPayouts;
784 
785         // fire event
786         onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
787 
788         return _amountOfTokens;
789     }
790 
791     /**
792      * Calculate Token price based on an amount of incoming ethereum
793      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
794      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
795      */
796     function ethereumToTokens_(uint256 _ethereum)
797         internal
798         view
799         returns(uint256)
800     {
801         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
802         uint256 _tokensReceived =
803          (
804             (
805                 // underflow attempts BTFO
806                 SafeMath.sub(
807                     (sqrt
808                         (
809                             (_tokenPriceInitial**2)
810                             +
811                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
812                             +
813                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
814                             +
815                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
816                         )
817                     ), _tokenPriceInitial
818                 )
819             )/(tokenPriceIncremental_)
820         )-(tokenSupply_)
821         ;
822 
823         return _tokensReceived;
824     }
825 
826     /**
827      * Calculate token sell value.
828      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
829      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
830      */
831      function tokensToEthereum_(uint256 _tokens)
832         internal
833         view
834         returns(uint256)
835     {
836 
837         uint256 tokens_ = (_tokens + 1e18);
838         uint256 _tokenSupply = (tokenSupply_ + 1e18);
839         uint256 _etherReceived =
840         (
841             // underflow attempts BTFO
842             SafeMath.sub(
843                 (
844                     (
845                         (
846                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
847                         )-tokenPriceIncremental_
848                     )*(tokens_ - 1e18)
849                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
850             )
851         /1e18);
852         return _etherReceived;
853     }
854 
855 
856     //This is where all your gas goes, sorry
857     //Not sorry, you probably only paid 1 gwei
858     function sqrt(uint x) internal pure returns (uint y) {
859         uint z = (x + 1) / 2;
860         y = x;
861         while (z < y) {
862             y = z;
863             z = (x / z + z) / 2;
864         }
865     }
866 }
867 
868 /**
869  * @title SafeMath
870  * @dev Math operations with safety checks that throw on error
871  */
872 library SafeMath {
873 
874     /**
875     * @dev Multiplies two numbers, throws on overflow.
876     */
877     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
878         if (a == 0) {
879             return 0;
880         }
881         uint256 c = a * b;
882         assert(c / a == b);
883         return c;
884     }
885 
886     /**
887     * @dev Integer division of two numbers, truncating the quotient.
888     */
889     function div(uint256 a, uint256 b) internal pure returns (uint256) {
890         // assert(b > 0); // Solidity automatically throws when dividing by 0
891         uint256 c = a / b;
892         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
893         return c;
894     }
895 
896     /**
897     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
898     */
899     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
900         assert(b <= a);
901         return a - b;
902     }
903 
904     /**
905     * @dev Adds two numbers, throws on overflow.
906     */
907     function add(uint256 a, uint256 b) internal pure returns (uint256) {
908         uint256 c = a + b;
909         assert(c >= a);
910         return c;
911     }
912 }