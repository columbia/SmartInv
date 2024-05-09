1 pragma solidity ^0.4.21;
2 
3 
4 
5 /**Decentralized
6     Immutable & Unstoppable  Ethereum Staking Smart Contract.!
7  * Definition of contract accepting GGT tokens
8  * Games, casinos,Exchanges anything can reuse this contract to support GGT tokens
9  */
10 contract AcceptsGameofGold {
11     GameofGold public tokenContract;
12 
13     function AcceptsGameofGold(address _tokenContract) public {
14         tokenContract = GameofGold(_tokenContract);
15     }
16 
17     modifier onlyTokenContract {
18         require(msg.sender == address(tokenContract));
19         _;
20     }
21 
22     /**
23     * @dev Standard ERC677 function that will handle incoming token transfers.
24     *
25     * @param _from  Token sender address.
26     * @param _value Amount of tokens.
27     * @param _data  Transaction metadata.
28     */
29     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
30 }
31 
32 
33 contract GameofGold {
34     /*=================================
35     =            MODIFIERS            =
36     =================================*/
37     // only people with tokens
38     modifier onlyBagholders() {
39         require(myTokens() > 0);
40         _;
41     }
42 
43     // only people with profits
44     modifier onlyStronghands() {
45         require(myDividends(true) > 0);
46         _;
47     }
48 
49     modifier notContract() {
50       require (msg.sender == tx.origin);
51       _;
52     }
53 
54     // administrators can:
55     // -> change the name of the contract
56     // -> change the name of the token
57     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
58     // they CANNOT:
59     // -> take funds
60     // -> disable withdrawals
61     // -> kill the contract
62     // -> change the price of tokens
63     modifier onlyAdministrator(){
64         address _customerAddress = msg.sender;
65         require(administrators[_customerAddress]);
66         _;
67     }
68     
69     uint ACTIVATION_TIME = 1571954400;
70 
71 
72     // ensures that the first tokens in the contract will be equally distributed
73     // meaning, no divine dump will be ever possible
74     // result: healthy longevity.
75     modifier antiEarlyWhale(uint256 _amountOfEthereum){
76         address _customerAddress = msg.sender;
77         
78         if (now >= ACTIVATION_TIME) {
79             onlyAmbassadors = false;
80         }
81 
82         // are we still in the vulnerable phase?
83         // if so, enact anti early whale protocol
84         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
85             require(
86                 // is the customer in the ambassador list?
87                 ambassadors_[_customerAddress] == true &&
88 
89                 // does the customer purchase exceed the max ambassador quota?
90                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
91 
92             );
93 
94             // updated the accumulated quota
95             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
96 
97             // execute
98             _;
99         } else {
100             // in case the ether count drops low, the ambassador phase won't reinitiate
101             onlyAmbassadors = false;
102             _;
103         }
104 
105     }
106 
107     /*==============================
108     =            EVENTS            =
109     ==============================*/
110     event onTokenPurchase(
111         address indexed customerAddress,
112         uint256 incomingEthereum,
113         uint256 tokensMinted,
114         address indexed referredBy
115     );
116 
117     event onTokenSell(
118         address indexed customerAddress,
119         uint256 tokensBurned,
120         uint256 ethereumEarned
121     );
122 
123     event onReinvestment(
124         address indexed customerAddress,
125         uint256 ethereumReinvested,
126         uint256 tokensMinted
127     );
128 
129     event onWithdraw(
130         address indexed customerAddress,
131         uint256 ethereumWithdrawn
132     );
133 
134     // ERC20
135     event Transfer(
136         address indexed from,
137         address indexed to,
138         uint256 tokens
139     );
140 
141 
142     /*=====================================
143     =            CONFIGURABLES            =
144     =====================================*/
145     string public name = "Game of Gold";
146     string public symbol = "GGT";
147     uint8 constant public decimals = 18;
148     uint8 constant internal dividendFee_ = 25; 
149     uint8 constant internal fundFee_ = 2;  
150     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
151     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
152     uint256 constant internal magnitude = 2**64;
153 
154     // Address to send 
155     // ad/games Fund
156     
157     address constant public giveEthFundAddress = 0x67104fA2cAFe7f3c4afc32104621c71f83510980; // ad/games Fund
158 	address constant public giveEthFundAddress2 = 0xbf92e4a68cc341915f571364ec8e261f810d06fe;// ad/games Fund
159     uint256 public totalEthFundRecieved; // 
160     uint256 public totalEthFundCollected; //
161 
162     // proof of stake (defaults at 100 tokens)
163     uint256 public stakingRequirement = 25e18;
164 
165     // ambassador program
166     mapping(address => bool) internal ambassadors_;
167     uint256 constant internal ambassadorMaxPurchase_ = 1.5 ether;
168     uint256 constant internal ambassadorQuota_ = 1.5 ether;
169 
170 
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
189    
190     mapping(address => bool) public canAcceptTokens_; 
191 
192     mapping(address => address) public stickyRef;
193 
194     /*=======================================
195     =            PUBLIC FUNCTIONS            =
196     =======================================*/
197     /*
198     * -- APPLICATION ENTRY POINTS --
199     */
200     function GameofGold()
201         public
202     {
203         // add administrators here
204         administrators[0x15B2F64191e3C34FAdf40a4440F546669205747a] = true;
205 
206         // add the ambassadors here - Tokens will be distributed to these addresses from main premine
207        ambassadors_[0xE804b9eB03D7C19a1fF99f320C659E362F823764] = true;
208        ambassadors_[0x909f449940832a0f99A3c451AF912A0B92F5c646] = true;
209         
210     }
211 
212 
213     /**
214      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
215      */
216     function buy(address _referredBy)
217         public
218         payable
219         returns(uint256)
220     {
221         
222         require(tx.gasprice <= 0.05 szabo);
223         purchaseTokens(msg.value, _referredBy);
224     }
225 
226     /**
227      * Fallback function to handle ethereum that was send straight to the contract
228      * Unfortunately we cannot use a referral address this way.
229      */
230     function()
231         
232         public
233         payable
234     {
235         
236        
237     }
238 
239     
240     function payFund() payable public {
241       uint256 ethToPay = SafeMath.sub(totalEthFundCollected, totalEthFundRecieved);
242       require(ethToPay > 1);
243       totalEthFundRecieved = SafeMath.add(totalEthFundRecieved, ethToPay);
244       uint256 div1=(ethToPay*1)/2; // ad/games Fund
245       uint256 div2=(ethToPay*1)/2; // ad/games Fund
246       if(!giveEthFundAddress.call.value(div1).gas(400000)()) {
247          totalEthFundRecieved = SafeMath.sub(totalEthFundRecieved, div1);
248       }
249       if(!giveEthFundAddress2.call.value(div2).gas(400000)()) {
250          totalEthFundRecieved = SafeMath.sub(totalEthFundRecieved, div2);
251       }
252     }
253 
254     /**
255      * Converts all of caller's dividends to tokens.
256      */
257     function reinvest()
258         onlyStronghands()
259         public
260     {
261         // fetch dividends
262         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
263 
264         // pay out the dividends virtually
265         address _customerAddress = msg.sender;
266         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
267 
268         // retrieve ref. bonus
269         _dividends += referralBalance_[_customerAddress];
270         referralBalance_[_customerAddress] = 0;
271 
272         // dispatch a buy order with the virtualized "withdrawn dividends"
273         uint256 _tokens = purchaseTokens(_dividends, 0x0);
274 
275         // fire event
276         onReinvestment(_customerAddress, _dividends, _tokens);
277     }
278 
279     /**
280      * Alias of sell() and withdraw().
281      */
282     function exit()
283         public
284     {
285         // get token count for caller & sell them all
286         address _customerAddress = msg.sender;
287         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
288         if(_tokens > 0) sell(_tokens);
289 
290         // lambo delivery service
291         withdraw();
292     }
293 
294     /**
295      * Withdraws all of the callers earnings.
296      */
297     function withdraw()
298         onlyStronghands()
299         public
300     {
301         // setup data
302         address _customerAddress = msg.sender;
303         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
304 
305         // update dividend tracker
306         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
307 
308         // add ref. bonus
309         _dividends += referralBalance_[_customerAddress];
310         referralBalance_[_customerAddress] = 0;
311 
312         // lambo delivery service
313         _customerAddress.transfer(_dividends);
314 
315         // fire event
316         onWithdraw(_customerAddress, _dividends);
317     }
318 
319     /**
320      * Liquifies tokens to ethereum.
321      */
322     function sell(uint256 _amountOfTokens)
323         onlyBagholders()
324         public
325     {
326         // setup data
327         address _customerAddress = msg.sender;
328         // russian hackers BTFO
329         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
330         uint256 _tokens = _amountOfTokens;
331         uint256 _ethereum = tokensToEthereum_(_tokens);
332 
333         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
334         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
335         
336         uint256 _refPayout = _dividends / 3;
337         _dividends = SafeMath.sub(_dividends, _refPayout);
338         (_dividends,) = handleRef(stickyRef[msg.sender], _refPayout, _dividends, 0);
339 
340         // Take out dividends and then _fundPayout
341         uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
342 
343         // Add ethereum to send to fund
344         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
345 
346         // burn the sold tokens
347         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
348         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
349 
350         // update dividends tracker
351         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
352         payoutsTo_[_customerAddress] -= _updatedPayouts;
353 
354         // dividing by zero is a bad idea
355         if (tokenSupply_ > 0) {
356             // update the amount of dividends per token
357             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
358         }
359 
360         // fire event
361         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
362     }
363 
364 
365     /**
366      * Transfer tokens from the caller to a new holder.
367      * REMEMBER THIS IS 0% TRANSFER FEE
368      */
369     function transfer(address _toAddress, uint256 _amountOfTokens)
370         onlyBagholders()
371         public
372         returns(bool)
373     {
374         // setup
375         address _customerAddress = msg.sender;
376 
377         // make sure we have the requested tokens
378         // also disables transfers until ambassador phase is over
379         // ( we dont want whale premines )
380         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
381 
382         // withdraw all outstanding dividends first
383         if(myDividends(true) > 0) withdraw();
384 
385         // exchange tokens
386         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
387         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
388 
389         // update dividend trackers
390         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
391         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
392 
393 
394         // fire event
395         Transfer(_customerAddress, _toAddress, _amountOfTokens);
396 
397         // ERC20
398         return true;
399     }
400 
401     /**
402     * Transfer token to a specified address and forward the data to recipient
403     * ERC-677 standard
404     * https://github.com/ethereum/EIPs/issues/677
405     * @param _to    Receiver address.
406     * @param _value Amount of tokens that will be transferred.
407     * @param _data  Transaction metadata.
408     */
409     function transferAndCall(address _to, uint256 _value, bytes _data) external returns (bool) {
410       require(_to != address(0));
411       require(canAcceptTokens_[_to] == true); // security check that contract approved by GGT platform
412       require(transfer(_to, _value)); // do a normal token transfer to the contract
413 
414       if (isContract(_to)) {
415         AcceptsGameofGold receiver = AcceptsGameofGold(_to);
416         require(receiver.tokenFallback(msg.sender, _value, _data));
417       }
418 
419       return true;
420     }
421 
422     /**
423      * Additional check that the game address we are sending tokens to is a contract
424      * assemble the given address bytecode. If bytecode exists then the _addr is a contract.
425      */
426      function isContract(address _addr) private constant returns (bool is_contract) {
427        // retrieve the size of the code on target address, this needs assembly
428        uint length;
429        assembly { length := extcodesize(_addr) }
430        return length > 0;
431      }
432 
433     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
434     /**
435      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
436      */
437     //function disableInitialStage()
438     //    onlyAdministrator()
439     //    public
440     //{
441     //    onlyAmbassadors = false;
442     //}
443 
444 
445     /**
446      * In case one of us dies, we need to replace ourselves.
447      */
448     function setAdministrator(address _identifier, bool _status)
449         onlyAdministrator()
450         public
451     {
452         administrators[_identifier] = _status;
453     }
454 
455     /**
456      * Precautionary measures in case we need to adjust the masternode rate.
457      */
458     function setStakingRequirement(uint256 _amountOfTokens)
459         onlyAdministrator()
460         public
461     {
462         stakingRequirement = _amountOfTokens;
463     }
464 
465     /**
466      * Add or remove game contract, which can accept Crypto Surge Tokens tokens
467      */
468     function setCanAcceptTokens(address _address, bool _value)
469       onlyAdministrator()
470       public
471     {
472       canAcceptTokens_[_address] = _value;
473     }
474 
475     /**
476      * If we want to rebrand, we can.
477      */
478     function setName(string _name)
479         onlyAdministrator()
480         public
481     {
482         name = _name;
483     }
484 
485     /**
486      * If we want to rebrand, we can.
487      */
488     function setSymbol(string _symbol)
489         onlyAdministrator()
490         public
491     {
492         symbol = _symbol;
493     }
494 
495 
496     /*----------  HELPERS AND CALCULATORS  ----------*/
497     /**
498      * Method to view the current Ethereum stored in the contract
499      * Example: totalEthereumBalance()
500      */
501     function totalEthereumBalance()
502         public
503         view
504         returns(uint)
505     {
506         return this.balance;
507     }
508 
509     /**
510      * Retrieve the total token supply.
511      */
512     function totalSupply()
513         public
514         view
515         returns(uint256)
516     {
517         return tokenSupply_;
518     }
519 
520     /**
521      * Retrieve the tokens owned by the caller.
522      */
523     function myTokens()
524         public
525         view
526         returns(uint256)
527     {
528         address _customerAddress = msg.sender;
529         return balanceOf(_customerAddress);
530     }
531 
532     /**
533      * Retrieve the dividends owned by the caller.
534      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
535      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
536      * But in the internal calculations, we want them separate.
537      */
538     function myDividends(bool _includeReferralBonus)
539         public
540         view
541         returns(uint256)
542     {
543         address _customerAddress = msg.sender;
544         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
545     }
546 
547     /**
548      * Retrieve the token balance of any single address.
549      */
550     function balanceOf(address _customerAddress)
551         view
552         public
553         returns(uint256)
554     {
555         return tokenBalanceLedger_[_customerAddress];
556     }
557 
558     /**
559      * Retrieve the dividend balance of any single address.
560      */
561     function dividendsOf(address _customerAddress)
562         view
563         public
564         returns(uint256)
565     {
566         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
567     }
568 
569     /**
570      * Return the buy price of 1 individual token.
571      */
572     function sellPrice()
573         public
574         view
575         returns(uint256)
576     {
577         // our calculation relies on the token supply, so we need supply. Doh.
578         if(tokenSupply_ == 0){
579             return tokenPriceInitial_ - tokenPriceIncremental_;
580         } else {
581             uint256 _ethereum = tokensToEthereum_(1e18);
582             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
583             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
584             uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
585             return _taxedEthereum;
586         }
587     }
588 
589     /**
590      * Return the sell price of 1 individual token.
591      */
592     function buyPrice()
593         public
594         view
595         returns(uint256)
596     {
597         // our calculation relies on the token supply, so we need supply. Doh.
598         if(tokenSupply_ == 0){
599             return tokenPriceInitial_ + tokenPriceIncremental_;
600         } else {
601             uint256 _ethereum = tokensToEthereum_(1e18);
602             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
603             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
604             uint256 _taxedEthereum =  SafeMath.add(SafeMath.add(_ethereum, _dividends), _fundPayout);
605             return _taxedEthereum;
606         }
607     }
608 
609     /**
610      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
611      */
612     function calculateTokensReceived(uint256 _ethereumToSpend)
613         public
614         view
615         returns(uint256)
616     {
617         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, dividendFee_), 100);
618         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereumToSpend, fundFee_), 100);
619         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereumToSpend, _dividends), _fundPayout);
620         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
621         return _amountOfTokens;
622     }
623 
624     /**
625      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
626      */
627     function calculateEthereumReceived(uint256 _tokensToSell)
628         public
629         view
630         returns(uint256)
631     {
632         require(_tokensToSell <= tokenSupply_);
633         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
634         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
635         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
636         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
637         return _taxedEthereum;
638     }
639 
640     /**
641      * Function for the frontend to show ether waiting to be send to fund in contract
642      */
643     function etherToSendFund()
644         public
645         view
646         returns(uint256) {
647         return SafeMath.sub(totalEthFundCollected, totalEthFundRecieved);
648     }
649 
650 
651     /*==========================================
652     =            INTERNAL FUNCTIONS            =
653     ==========================================*/
654 
655     // Make sure we will send back excess if user sends more then 5 ether before 100 ETH in contract
656     function purchaseInternal(uint256 _incomingEthereum, address _referredBy)
657       notContract()// no contracts allowed
658       internal
659       returns(uint256) {
660 
661       uint256 purchaseEthereum = _incomingEthereum;
662       uint256 excess;
663       if(purchaseEthereum > 2.5 ether) { // check if the transaction is over 2.5 ether
664           if (SafeMath.sub(address(this).balance, purchaseEthereum) <= 100 ether) { // if so check the contract is less then 100 ether
665               purchaseEthereum = 2.5 ether;
666               excess = SafeMath.sub(_incomingEthereum, purchaseEthereum);
667           }
668       }
669 
670       purchaseTokens(purchaseEthereum, _referredBy);
671 
672       if (excess > 0) {
673         msg.sender.transfer(excess);
674       }
675     }
676 
677     function handleRef(address _ref, uint _referralBonus, uint _currentDividends, uint _currentFee) internal returns (uint, uint){
678         uint _dividends = _currentDividends;
679         uint _fee = _currentFee;
680         address _referredBy = stickyRef[msg.sender];
681         if (_referredBy == address(0x0)){
682             _referredBy = _ref;
683         }
684         // is the user referred by a masternode?
685         if(
686             // is this a referred purchase?
687             _referredBy != 0x0000000000000000000000000000000000000000 &&
688 
689             // no cheating!
690             _referredBy != msg.sender &&
691 
692             // does the referrer have at least X whole tokens?
693             // i.e is the referrer a godly chad masternode
694             tokenBalanceLedger_[_referredBy] >= stakingRequirement
695         ){
696             // wealth redistribution
697             if (stickyRef[msg.sender] == address(0x0)){
698                 stickyRef[msg.sender] = _referredBy;
699             }
700             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus/2);
701             address currentRef = stickyRef[_referredBy];
702             if (currentRef != address(0x0) && tokenBalanceLedger_[currentRef] >= stakingRequirement){
703                 referralBalance_[currentRef] = SafeMath.add(referralBalance_[currentRef], (_referralBonus/10)*3);
704                 currentRef = stickyRef[currentRef];
705                 if (currentRef != address(0x0) && tokenBalanceLedger_[currentRef] >= stakingRequirement){
706                     referralBalance_[currentRef] = SafeMath.add(referralBalance_[currentRef], (_referralBonus/10)*2);
707                 }
708                 else{
709                     _dividends = SafeMath.add(_dividends, _referralBonus - _referralBonus/2 - (_referralBonus/10)*3);
710                     _fee = _dividends * magnitude;
711                 }
712             }
713             else{
714                 _dividends = SafeMath.add(_dividends, _referralBonus - _referralBonus/2);
715                 _fee = _dividends * magnitude;
716             }
717             
718             
719         } else {
720             // no ref purchase
721             // add the referral bonus back to the global dividends cake
722             _dividends = SafeMath.add(_dividends, _referralBonus);
723             _fee = _dividends * magnitude;
724         }
725         return (_dividends, _fee);
726     }
727 
728 
729     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
730         antiEarlyWhale(_incomingEthereum)
731         internal
732         returns(uint256)
733     {
734         // data setup
735         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);
736         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
737         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_incomingEthereum, fundFee_), 100);
738         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
739         uint256 _fee;
740         (_dividends, _fee) = handleRef(_referredBy, _referralBonus, _dividends, _fee);
741         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_incomingEthereum, _dividends), _fundPayout);
742         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
743 
744         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
745 
746 
747         // no point in continuing execution if OP is a poorfag russian hacker
748         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
749         // (or hackers)
750         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
751         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
752 
753 
754 
755         // we can't give people infinite ethereum
756         if(tokenSupply_ > 0){
757  
758             // add tokens to the pool
759             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
760 
761             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
762             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
763 
764             // calculate the amount of tokens the customer receives over his purchase
765             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
766 
767         } else {
768             // add tokens to the pool
769             tokenSupply_ = _amountOfTokens;
770         }
771 
772         // update circulating supply & the ledger address for the customer
773         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
774 
775         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
776         //really i know you think you do but you don't
777         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
778         payoutsTo_[msg.sender] += _updatedPayouts;
779 
780         // fire event
781         onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
782 
783         return _amountOfTokens;
784     }
785 
786     /**
787      * Calculate Token price based on an amount of incoming ethereum
788      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
789      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
790      */
791     function ethereumToTokens_(uint256 _ethereum)
792         internal
793         view
794         returns(uint256)
795     {
796         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
797         uint256 _tokensReceived =
798          (
799             (
800                 // underflow attempts BTFO
801                 SafeMath.sub(
802                     (sqrt
803                         (
804                             (_tokenPriceInitial**2)
805                             +
806                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
807                             +
808                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
809                             +
810                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
811                         )
812                     ), _tokenPriceInitial
813                 )
814             )/(tokenPriceIncremental_)
815         )-(tokenSupply_)
816         ;
817 
818         return _tokensReceived;
819     }
820 
821     /**
822      * Calculate token sell value.
823      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
824      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
825      */
826      function tokensToEthereum_(uint256 _tokens)
827         internal
828         view
829         returns(uint256)
830     {
831 
832         uint256 tokens_ = (_tokens + 1e18);
833         uint256 _tokenSupply = (tokenSupply_ + 1e18);
834         uint256 _etherReceived =
835         (
836             // underflow attempts BTFO
837             SafeMath.sub(
838                 (
839                     (
840                         (
841                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
842                         )-tokenPriceIncremental_
843                     )*(tokens_ - 1e18)
844                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
845             )
846         /1e18);
847         return _etherReceived;
848     }
849 
850 
851     //This is where all your gas goes, sorry
852     //Not sorry, you probably only paid 1 gwei
853     function sqrt(uint x) internal pure returns (uint y) {
854         uint z = (x + 1) / 2;
855         y = x;
856         while (z < y) {
857             y = z;
858             z = (x / z + z) / 2;
859         }
860     }
861 }
862 
863 /**
864  * @title SafeMath
865  * @dev Math operations with safety checks that throw on error
866  */
867 library SafeMath {
868 
869     /**
870     * @dev Multiplies two numbers, throws on overflow.
871     */
872     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
873         if (a == 0) {
874             return 0;
875         }
876         uint256 c = a * b;
877         assert(c / a == b);
878         return c;
879     }
880 
881     /**
882     * @dev Integer division of two numbers, truncating the quotient.
883     */
884     function div(uint256 a, uint256 b) internal pure returns (uint256) {
885         // assert(b > 0); // Solidity automatically throws when dividing by 0
886         uint256 c = a / b;
887         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
888         return c;
889     }
890 
891     /**
892     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
893     */
894     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
895         assert(b <= a);
896         return a - b;
897     }
898 
899     /**
900     * @dev Adds two numbers, throws on overflow.
901     */
902     function add(uint256 a, uint256 b) internal pure returns (uint256) {
903         uint256 c = a + b;
904         assert(c >= a);
905         return c;
906     }
907 }