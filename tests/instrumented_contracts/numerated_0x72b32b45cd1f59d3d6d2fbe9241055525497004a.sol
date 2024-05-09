1 pragma solidity ^0.4.21;
2 
3 
4 contract AcceptsDailyDivs {
5     DailyDivs public tokenContract;
6 
7     function AcceptsDailyDivs(address _tokenContract) public {
8         tokenContract = DailyDivs(_tokenContract);
9     }
10 
11     modifier onlyTokenContract {
12         require(msg.sender == address(tokenContract));
13         _;
14     }
15 
16     /**
17     * @dev Standard ERC677 function that will handle incoming token transfers.
18     *
19     * @param _from  Token sender address.
20     * @param _value Amount of tokens.
21     * @param _data  Transaction metadata.
22     */
23     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
24 }
25 
26 
27 contract DailyDivs {
28     /*=================================
29     =            MODIFIERS            =
30     =================================*/
31     // only people with tokens
32     modifier onlyBagholders() {
33         require(myTokens() > 0);
34         _;
35     }
36 
37     // only people with profits
38     modifier onlyStronghands() {
39         require(myDividends(true) > 0);
40         _;
41     }
42 
43     modifier notContract() {
44       require (msg.sender == tx.origin);
45       _;
46     }
47 
48     // administrators can:
49     // -> change the name of the contract
50     // -> change the name of the token
51     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
52     // they CANNOT:
53     // -> take funds
54     // -> disable withdrawals
55     // -> kill the contract
56     // -> change the price of tokens
57     modifier onlyAdministrator(){
58         address _customerAddress = msg.sender;
59         require(administrators[_customerAddress]);
60         _;
61     }
62     
63     uint ACTIVATION_TIME = 1536174000;
64 
65 
66     // ensures that the first tokens in the contract will be equally distributed
67     // meaning, no divine dump will be ever possible
68     // result: healthy longevity.
69     modifier antiEarlyWhale(uint256 _amountOfEthereum){
70         address _customerAddress = msg.sender;
71         
72         if (now >= ACTIVATION_TIME) {
73             onlyAmbassadors = false;
74         }
75 
76         // are we still in the vulnerable phase?
77         // if so, enact anti early whale protocol
78         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
79             require(
80                 // is the customer in the ambassador list?
81                 ambassadors_[_customerAddress] == true &&
82 
83                 // does the customer purchase exceed the max ambassador quota?
84                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
85 
86             );
87 
88             // updated the accumulated quota
89             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
90 
91             // execute
92             _;
93         } else {
94             // in case the ether count drops low, the ambassador phase won't reinitiate
95             onlyAmbassadors = false;
96             _;
97         }
98 
99     }
100 
101     /*==============================
102     =            EVENTS            =
103     ==============================*/
104     event onTokenPurchase(
105         address indexed customerAddress,
106         uint256 incomingEthereum,
107         uint256 tokensMinted,
108         address indexed referredBy
109     );
110 
111     event onTokenSell(
112         address indexed customerAddress,
113         uint256 tokensBurned,
114         uint256 ethereumEarned
115     );
116 
117     event onReinvestment(
118         address indexed customerAddress,
119         uint256 ethereumReinvested,
120         uint256 tokensMinted
121     );
122 
123     event onWithdraw(
124         address indexed customerAddress,
125         uint256 ethereumWithdrawn
126     );
127 
128     // ERC20
129     event Transfer(
130         address indexed from,
131         address indexed to,
132         uint256 tokens
133     );
134 
135 
136     /*=====================================
137     =            CONFIGURABLES            =
138     =====================================*/
139     string public name = "DivsVIP";
140     string public symbol = "DVIP";
141     uint8 constant public decimals = 18;
142     uint8 constant internal dividendFee_ = 20; // 20% dividend fee on each buy and sell
143     uint8 constant internal fundFee_ = 5; // 5% investment fund fee on each buy and sell
144     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
145     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
146     uint256 constant internal magnitude = 2**64;
147 
148     // Address to send the 5% Fee
149     //  70% to Earn Game / 30% to Dev Fund
150     // https://etherscan.io/address/0xF34340Ba65f37320B25F9f6F3978D02DDc13283b
151     address constant public giveEthFundAddress = 0xF34340Ba65f37320B25F9f6F3978D02DDc13283b;
152     uint256 public totalEthFundRecieved; // total ETH charity recieved from this contract
153     uint256 public totalEthFundCollected; // total ETH charity collected in this contract
154 
155     // proof of stake (defaults at 100 tokens)
156     uint256 public stakingRequirement = 25e18;
157 
158     // ambassador program
159     mapping(address => bool) internal ambassadors_;
160     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
161     uint256 constant internal ambassadorQuota_ = 6 ether;
162 
163 
164 
165    /*================================
166     =            DATASETS            =
167     ================================*/
168     // amount of shares for each address (scaled number)
169     mapping(address => uint256) internal tokenBalanceLedger_;
170     mapping(address => uint256) internal referralBalance_;
171     mapping(address => int256) internal payoutsTo_;
172     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
173     uint256 internal tokenSupply_ = 0;
174     uint256 internal profitPerShare_;
175 
176     // administrator list (see above on what they can do)
177     mapping(address => bool) public administrators;
178 
179     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
180     bool public onlyAmbassadors = true;
181 
182     // Special DailyDivs Platform control from scam game contracts on DailyDivs platform
183     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept DailyDivs tokens
184 
185     mapping(address => address) public stickyRef;
186 
187     /*=======================================
188     =            PUBLIC FUNCTIONS            =
189     =======================================*/
190     /*
191     * -- APPLICATION ENTRY POINTS --
192     */
193     function DailyDivs()
194         public
195     {
196         // add administrators here
197         administrators[0x2f59321274Df6D4d84c05Fd61148a842d1cD9E9d] = true;
198 
199       // add the ambassadors here - Tokens will be distributed to these addresses from main premine
200         ambassadors_[0xD5FA3017A6af76b31eB093DFA527eE1D939f05ea] = true;
201         // add the ambassadors here - Tokens will be distributed to these addresses from main premine
202         ambassadors_[0x008ca4f1ba79d1a265617c6206d7884ee8108a78] = true;
203        // add the ambassadors here - Tokens will be distributed to these addresses from main premine
204         ambassadors_[0xB5a28B0752ce06C41d8965Cf431C759D888a162A] = true;
205         // add the ambassadors here - Tokens will be distributed to these addresses from main premine
206         ambassadors_[0x0C0dF6e58e5F7865b8137a7Fb663E7DCD5672995] = true;
207         // add the ambassadors here - Tokens will be distributed to these addresses from main premine
208         ambassadors_[0x797452296a37C2A8419F45A95b435093917f8f8B] = true;
209         // add the ambassadors here - Tokens will be distributed to these addresses from main premine
210         ambassadors_[0xf458168E49D9BA62Ae780A1d8286296A9A4D9D3B] = true;
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
224         purchaseTokens(msg.value, _referredBy);
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
237         purchaseTokens(msg.value, 0x0);
238     }
239 
240     /**
241      * Sends FUND money to the 70/30 Contract
242      * The address is here https://etherscan.io/address/0xF34340Ba65f37320B25F9f6F3978D02DDc13283b
243      */
244     function payFund() payable public {
245       uint256 ethToPay = SafeMath.sub(totalEthFundCollected, totalEthFundRecieved);
246       require(ethToPay > 1);
247       totalEthFundRecieved = SafeMath.add(totalEthFundRecieved, ethToPay);
248       if(!giveEthFundAddress.call.value(ethToPay).gas(400000)()) {
249          totalEthFundRecieved = SafeMath.sub(totalEthFundRecieved, ethToPay);
250       }
251     }
252 
253     /**
254      * Converts all of caller's dividends to tokens.
255      */
256     function reinvest()
257         onlyStronghands()
258         public
259     {
260         // fetch dividends
261         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
262 
263         // pay out the dividends virtually
264         address _customerAddress = msg.sender;
265         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
266 
267         // retrieve ref. bonus
268         _dividends += referralBalance_[_customerAddress];
269         referralBalance_[_customerAddress] = 0;
270 
271         // dispatch a buy order with the virtualized "withdrawn dividends"
272         uint256 _tokens = purchaseTokens(_dividends, 0x0);
273 
274         // fire event
275         onReinvestment(_customerAddress, _dividends, _tokens);
276     }
277 
278     /**
279      * Alias of sell() and withdraw().
280      */
281     function exit()
282         public
283     {
284         // get token count for caller & sell them all
285         address _customerAddress = msg.sender;
286         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
287         if(_tokens > 0) sell(_tokens);
288 
289         // lambo delivery service
290         withdraw();
291     }
292 
293     /**
294      * Withdraws all of the callers earnings.
295      */
296     function withdraw()
297         onlyStronghands()
298         public
299     {
300         // setup data
301         address _customerAddress = msg.sender;
302         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
303 
304         // update dividend tracker
305         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
306 
307         // add ref. bonus
308         _dividends += referralBalance_[_customerAddress];
309         referralBalance_[_customerAddress] = 0;
310 
311         // lambo delivery service
312         _customerAddress.transfer(_dividends);
313 
314         // fire event
315         onWithdraw(_customerAddress, _dividends);
316     }
317 
318     /**
319      * Liquifies tokens to ethereum.
320      */
321     function sell(uint256 _amountOfTokens)
322         onlyBagholders()
323         public
324     {
325         // setup data
326         address _customerAddress = msg.sender;
327         // russian hackers BTFO
328         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
329         uint256 _tokens = _amountOfTokens;
330         uint256 _ethereum = tokensToEthereum_(_tokens);
331 
332         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
333         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
334         uint256 _refPayout = _dividends / 3;
335         _dividends = SafeMath.sub(_dividends, _refPayout);
336         (_dividends,) = handleRef(stickyRef[msg.sender], _refPayout, _dividends, 0);
337 
338         // Take out dividends and then _fundPayout
339         uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
340 
341         // Add ethereum to send to fund
342         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
343 
344         // burn the sold tokens
345         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
346         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
347 
348         // update dividends tracker
349         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
350         payoutsTo_[_customerAddress] -= _updatedPayouts;
351 
352         // dividing by zero is a bad idea
353         if (tokenSupply_ > 0) {
354             // update the amount of dividends per token
355             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
356         }
357 
358         // fire event
359         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
360     }
361 
362 
363     /**
364      * Transfer tokens from the caller to a new holder.
365      * REMEMBER THIS IS 0% TRANSFER FEE
366      */
367     function transfer(address _toAddress, uint256 _amountOfTokens)
368         onlyBagholders()
369         public
370         returns(bool)
371     {
372         // setup
373         address _customerAddress = msg.sender;
374 
375         // make sure we have the requested tokens
376         // also disables transfers until ambassador phase is over
377         // ( we dont want whale premines )
378         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
379 
380         // withdraw all outstanding dividends first
381         if(myDividends(true) > 0) withdraw();
382 
383         // exchange tokens
384         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
385         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
386 
387         // update dividend trackers
388         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
389         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
390 
391 
392         // fire event
393         Transfer(_customerAddress, _toAddress, _amountOfTokens);
394 
395         // ERC20
396         return true;
397     }
398 
399     /**
400     * Transfer token to a specified address and forward the data to recipient
401     * ERC-677 standard
402     * https://github.com/ethereum/EIPs/issues/677
403     * @param _to    Receiver address.
404     * @param _value Amount of tokens that will be transferred.
405     * @param _data  Transaction metadata.
406     */
407     function transferAndCall(address _to, uint256 _value, bytes _data) external returns (bool) {
408       require(_to != address(0));
409       require(canAcceptTokens_[_to] == true); // security check that contract approved by DailyDivs platform
410       require(transfer(_to, _value)); // do a normal token transfer to the contract
411 
412       if (isContract(_to)) {
413         AcceptsDailyDivs receiver = AcceptsDailyDivs(_to);
414         require(receiver.tokenFallback(msg.sender, _value, _data));
415       }
416 
417       return true;
418     }
419 
420     /**
421      * Additional check that the game address we are sending tokens to is a contract
422      * assemble the given address bytecode. If bytecode exists then the _addr is a contract.
423      */
424      function isContract(address _addr) private constant returns (bool is_contract) {
425        // retrieve the size of the code on target address, this needs assembly
426        uint length;
427        assembly { length := extcodesize(_addr) }
428        return length > 0;
429      }
430 
431     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
432     /**
433      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
434      */
435     //function disableInitialStage()
436     //    onlyAdministrator()
437     //    public
438     //{
439     //    onlyAmbassadors = false;
440     //}
441 
442     /**
443      * In case one of us dies, we need to replace ourselves.
444      */
445     function setAdministrator(address _identifier, bool _status)
446         onlyAdministrator()
447         public
448     {
449         administrators[_identifier] = _status;
450     }
451 
452     /**
453      * Precautionary measures in case we need to adjust the masternode rate.
454      */
455     function setStakingRequirement(uint256 _amountOfTokens)
456         onlyAdministrator()
457         public
458     {
459         stakingRequirement = _amountOfTokens;
460     }
461 
462     /**
463      * Add or remove game contract, which can accept DailyDivs tokens
464      */
465     function setCanAcceptTokens(address _address, bool _value)
466       onlyAdministrator()
467       public
468     {
469       canAcceptTokens_[_address] = _value;
470     }
471 
472     /**
473      * If we want to rebrand, we can.
474      */
475     function setName(string _name)
476         onlyAdministrator()
477         public
478     {
479         name = _name;
480     }
481 
482     /**
483      * If we want to rebrand, we can.
484      */
485     function setSymbol(string _symbol)
486         onlyAdministrator()
487         public
488     {
489         symbol = _symbol;
490     }
491 
492 
493     /*----------  HELPERS AND CALCULATORS  ----------*/
494     /**
495      * Method to view the current Ethereum stored in the contract
496      * Example: totalEthereumBalance()
497      */
498     function totalEthereumBalance()
499         public
500         view
501         returns(uint)
502     {
503         return this.balance;
504     }
505 
506     /**
507      * Retrieve the total token supply.
508      */
509     function totalSupply()
510         public
511         view
512         returns(uint256)
513     {
514         return tokenSupply_;
515     }
516 
517     /**
518      * Retrieve the tokens owned by the caller.
519      */
520     function myTokens()
521         public
522         view
523         returns(uint256)
524     {
525         address _customerAddress = msg.sender;
526         return balanceOf(_customerAddress);
527     }
528 
529     /**
530      * Retrieve the dividends owned by the caller.
531      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
532      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
533      * But in the internal calculations, we want them separate.
534      */
535     function myDividends(bool _includeReferralBonus)
536         public
537         view
538         returns(uint256)
539     {
540         address _customerAddress = msg.sender;
541         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
542     }
543 
544     /**
545      * Retrieve the token balance of any single address.
546      */
547     function balanceOf(address _customerAddress)
548         view
549         public
550         returns(uint256)
551     {
552         return tokenBalanceLedger_[_customerAddress];
553     }
554 
555     /**
556      * Retrieve the dividend balance of any single address.
557      */
558     function dividendsOf(address _customerAddress)
559         view
560         public
561         returns(uint256)
562     {
563         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
564     }
565 
566     /**
567      * Return the buy price of 1 individual token.
568      */
569     function sellPrice()
570         public
571         view
572         returns(uint256)
573     {
574         // our calculation relies on the token supply, so we need supply. Doh.
575         if(tokenSupply_ == 0){
576             return tokenPriceInitial_ - tokenPriceIncremental_;
577         } else {
578             uint256 _ethereum = tokensToEthereum_(1e18);
579             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
580             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
581             uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
582             return _taxedEthereum;
583         }
584     }
585 
586     /**
587      * Return the sell price of 1 individual token.
588      */
589     function buyPrice()
590         public
591         view
592         returns(uint256)
593     {
594         // our calculation relies on the token supply, so we need supply. Doh.
595         if(tokenSupply_ == 0){
596             return tokenPriceInitial_ + tokenPriceIncremental_;
597         } else {
598             uint256 _ethereum = tokensToEthereum_(1e18);
599             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
600             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
601             uint256 _taxedEthereum =  SafeMath.add(SafeMath.add(_ethereum, _dividends), _fundPayout);
602             return _taxedEthereum;
603         }
604     }
605 
606     /**
607      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
608      */
609     function calculateTokensReceived(uint256 _ethereumToSpend)
610         public
611         view
612         returns(uint256)
613     {
614         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, dividendFee_), 100);
615         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereumToSpend, fundFee_), 100);
616         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereumToSpend, _dividends), _fundPayout);
617         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
618         return _amountOfTokens;
619     }
620 
621     /**
622      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
623      */
624     function calculateEthereumReceived(uint256 _tokensToSell)
625         public
626         view
627         returns(uint256)
628     {
629         require(_tokensToSell <= tokenSupply_);
630         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
631         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
632         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
633         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
634         return _taxedEthereum;
635     }
636 
637     /**
638      * Function for the frontend to show ether waiting to be send to fund in contract
639      */
640     function etherToSendFund()
641         public
642         view
643         returns(uint256) {
644         return SafeMath.sub(totalEthFundCollected, totalEthFundRecieved);
645     }
646 
647 
648     /*==========================================
649     =            INTERNAL FUNCTIONS            =
650     ==========================================*/
651 
652     // Make sure we will send back excess if user sends more then 5 ether before 100 ETH in contract
653     function purchaseInternal(uint256 _incomingEthereum, address _referredBy)
654       notContract()// no contracts allowed
655       internal
656       returns(uint256) {
657 
658       uint256 purchaseEthereum = _incomingEthereum;
659       uint256 excess;
660       if(purchaseEthereum > 2.5 ether) { // check if the transaction is over 2.5 ether
661           if (SafeMath.sub(address(this).balance, purchaseEthereum) <= 100 ether) { // if so check the contract is less then 100 ether
662               purchaseEthereum = 2.5 ether;
663               excess = SafeMath.sub(_incomingEthereum, purchaseEthereum);
664           }
665       }
666 
667       purchaseTokens(purchaseEthereum, _referredBy);
668 
669       if (excess > 0) {
670         msg.sender.transfer(excess);
671       }
672     }
673 
674     function handleRef(address _ref, uint _referralBonus, uint _currentDividends, uint _currentFee) internal returns (uint, uint){
675         uint _dividends = _currentDividends;
676         uint _fee = _currentFee;
677         address _referredBy = stickyRef[msg.sender];
678         if (_referredBy == address(0x0)){
679             _referredBy = _ref;
680         }
681         // is the user referred by a masternode?
682         if(
683             // is this a referred purchase?
684             _referredBy != 0x0000000000000000000000000000000000000000 &&
685 
686             // no cheating!
687             _referredBy != msg.sender &&
688 
689             // does the referrer have at least X whole tokens?
690             // i.e is the referrer a godly chad masternode
691             tokenBalanceLedger_[_referredBy] >= stakingRequirement
692         ){
693             // wealth redistribution
694             if (stickyRef[msg.sender] == address(0x0)){
695                 stickyRef[msg.sender] = _referredBy;
696             }
697             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus/2);
698             address currentRef = stickyRef[_referredBy];
699             if (currentRef != address(0x0) && tokenBalanceLedger_[currentRef] >= stakingRequirement){
700                 referralBalance_[currentRef] = SafeMath.add(referralBalance_[currentRef], (_referralBonus/10)*3);
701                 currentRef = stickyRef[currentRef];
702                 if (currentRef != address(0x0) && tokenBalanceLedger_[currentRef] >= stakingRequirement){
703                     referralBalance_[currentRef] = SafeMath.add(referralBalance_[currentRef], (_referralBonus/10)*2);
704                 }
705                 else{
706                     _dividends = SafeMath.add(_dividends, _referralBonus - _referralBonus/2 - (_referralBonus/10)*3);
707                     _fee = _dividends * magnitude;
708                 }
709             }
710             else{
711                 _dividends = SafeMath.add(_dividends, _referralBonus - _referralBonus/2);
712                 _fee = _dividends * magnitude;
713             }
714             
715             
716         } else {
717             // no ref purchase
718             // add the referral bonus back to the global dividends cake
719             _dividends = SafeMath.add(_dividends, _referralBonus);
720             _fee = _dividends * magnitude;
721         }
722         return (_dividends, _fee);
723     }
724 
725 
726     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
727         antiEarlyWhale(_incomingEthereum)
728         internal
729         returns(uint256)
730     {
731         // data setup
732         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);
733         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
734         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_incomingEthereum, fundFee_), 100);
735         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
736         uint256 _fee;
737         (_dividends, _fee) = handleRef(_referredBy, _referralBonus, _dividends, _fee);
738         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_incomingEthereum, _dividends), _fundPayout);
739         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
740 
741         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
742 
743 
744         // no point in continuing execution if OP is a poorfag russian hacker
745         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
746         // (or hackers)
747         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
748         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
749 
750 
751 
752         // we can't give people infinite ethereum
753         if(tokenSupply_ > 0){
754  
755             // add tokens to the pool
756             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
757 
758             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
759             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
760 
761             // calculate the amount of tokens the customer receives over his purchase
762             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
763 
764         } else {
765             // add tokens to the pool
766             tokenSupply_ = _amountOfTokens;
767         }
768 
769         // update circulating supply & the ledger address for the customer
770         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
771 
772         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
773         //really i know you think you do but you don't
774         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
775         payoutsTo_[msg.sender] += _updatedPayouts;
776 
777         // fire event
778         onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
779 
780         return _amountOfTokens;
781     }
782 
783     /**
784      * Calculate Token price based on an amount of incoming ethereum
785      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
786      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
787      */
788     function ethereumToTokens_(uint256 _ethereum)
789         internal
790         view
791         returns(uint256)
792     {
793         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
794         uint256 _tokensReceived =
795          (
796             (
797                 // underflow attempts BTFO
798                 SafeMath.sub(
799                     (sqrt
800                         (
801                             (_tokenPriceInitial**2)
802                             +
803                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
804                             +
805                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
806                             +
807                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
808                         )
809                     ), _tokenPriceInitial
810                 )
811             )/(tokenPriceIncremental_)
812         )-(tokenSupply_)
813         ;
814 
815         return _tokensReceived;
816     }
817 
818     /**
819      * Calculate token sell value.
820      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
821      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
822      */
823      function tokensToEthereum_(uint256 _tokens)
824         internal
825         view
826         returns(uint256)
827     {
828 
829         uint256 tokens_ = (_tokens + 1e18);
830         uint256 _tokenSupply = (tokenSupply_ + 1e18);
831         uint256 _etherReceived =
832         (
833             // underflow attempts BTFO
834             SafeMath.sub(
835                 (
836                     (
837                         (
838                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
839                         )-tokenPriceIncremental_
840                     )*(tokens_ - 1e18)
841                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
842             )
843         /1e18);
844         return _etherReceived;
845     }
846 
847 
848     //This is where all your gas goes, sorry
849     //Not sorry, you probably only paid 1 gwei
850     function sqrt(uint x) internal pure returns (uint y) {
851         uint z = (x + 1) / 2;
852         y = x;
853         while (z < y) {
854             y = z;
855             z = (x / z + z) / 2;
856         }
857     }
858 }
859 
860 /**
861  * @title SafeMath
862  * @dev Math operations with safety checks that throw on error
863  */
864 library SafeMath {
865 
866     /**
867     * @dev Multiplies two numbers, throws on overflow.
868     */
869     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
870         if (a == 0) {
871             return 0;
872         }
873         uint256 c = a * b;
874         assert(c / a == b);
875         return c;
876     }
877 
878     /**
879     * @dev Integer division of two numbers, truncating the quotient.
880     */
881     function div(uint256 a, uint256 b) internal pure returns (uint256) {
882         // assert(b > 0); // Solidity automatically throws when dividing by 0
883         uint256 c = a / b;
884         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
885         return c;
886     }
887 
888     /**
889     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
890     */
891     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
892         assert(b <= a);
893         return a - b;
894     }
895 
896     /**
897     * @dev Adds two numbers, throws on overflow.
898     */
899     function add(uint256 a, uint256 b) internal pure returns (uint256) {
900         uint256 c = a + b;
901         assert(c >= a);
902         return c;
903     }
904 }