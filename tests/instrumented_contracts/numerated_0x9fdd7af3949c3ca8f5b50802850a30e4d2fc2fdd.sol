1 pragma solidity ^0.4.24;
2 
3 
4 contract AcceptsProofofHumanity {
5     ProofofHumanity public tokenContract;
6 
7     constructor(address _tokenContract) public {
8         tokenContract = ProofofHumanity(_tokenContract);
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
27 contract ProofofHumanity {
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
43     modifier noUnapprovedContracts() {
44       require (msg.sender == tx.origin || approvedContracts[msg.sender] == true);
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
63 
64     // ensures that the first tokens in the contract will be equally distributed
65     // meaning, no divine dump will be ever possible
66     // result: healthy longevity.
67     modifier antiEarlyWhale(uint256 _amountOfEthereum){
68         address _customerAddress = msg.sender;
69 
70         // are we still in the vulnerable phase?
71         // if so, enact anti early whale protocol
72         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
73             require(
74                 // is the customer in the ambassador list?
75                 ambassadors_[_customerAddress] == true &&
76 
77                 // does the customer purchase exceed the max ambassador quota?
78                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
79 
80             );
81 
82             // updated the accumulated quota
83             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
84 
85             // execute
86             _;
87         } else {
88             // in case the ether count drops low, the ambassador phase won't reinitiate
89             onlyAmbassadors = false;
90             _;
91         }
92 
93     }
94 
95     /*==============================
96     =            EVENTS            =
97     ==============================*/
98     event onTokenPurchase(
99         address indexed customerAddress,
100         uint256 incomingEthereum,
101         uint256 tokensMinted,
102         address indexed referredBy
103     );
104 
105     event onTokenSell(
106         address indexed customerAddress,
107         uint256 tokensBurned,
108         uint256 ethereumEarned
109     );
110 
111     event onReinvestment(
112         address indexed customerAddress,
113         uint256 ethereumReinvested,
114         uint256 tokensMinted
115     );
116 
117     event onWithdraw(
118         address indexed customerAddress,
119         uint256 ethereumWithdrawn
120     );
121 
122     // ERC20
123     event Transfer(
124         address indexed from,
125         address indexed to,
126         uint256 tokens
127     );
128 
129 
130     /*=====================================
131     =            CONFIGURABLES            =
132     =====================================*/
133     string public name = "Proof of Humanity";
134     string public symbol = "PoH";
135     uint8 constant public decimals = 18;
136     uint8 constant internal dividendFee_ = 20; // 20% dividend fee on each buy and sell
137     uint8 constant internal charityFee_ = 2; // 2% charity fee on each buy and sell
138     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
139     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
140     uint256 constant internal magnitude = 2**64;
141 
142     // Address to send the charity  ! :)
143     //  https://giveth.io/
144     // https://etherscan.io/address/0x5ADF43DD006c6C36506e2b2DFA352E60002d22Dc
145     address constant public giveEthCharityAddress = 0x5ADF43DD006c6C36506e2b2DFA352E60002d22Dc;
146     uint256 public totalEthCharityRecieved; // total ETH charity recieved from this contract
147     uint256 public totalEthCharityCollected; // total ETH charity collected in this contract
148 
149     // proof of stake (defaults at 100 tokens)
150     uint256 public stakingRequirement = 100e18;
151 
152     // ambassador program
153     mapping(address => bool) internal ambassadors_;
154     uint256 constant internal ambassadorMaxPurchase_ = 0.5 ether;
155     uint256 constant internal ambassadorQuota_ = 1.5 ether;
156 
157 
158 
159    /*================================
160     =            DATASETS            =
161     ================================*/
162     // amount of shares for each address (scaled number)
163     mapping(address => uint256) internal tokenBalanceLedger_;
164     mapping(address => uint256) internal referralBalance_;
165     mapping(address => int256) internal payoutsTo_;
166     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
167     uint256 internal tokenSupply_ = 0;
168     uint256 internal profitPerShare_;
169 
170     // administrator list (see above on what they can do)
171     mapping(address => bool) public administrators;
172 
173     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
174     bool public onlyAmbassadors = true;
175 
176     // Special ProofofHumanity Platform control from scam game contracts on ProofofHumanity platform
177     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept ProofofHumanity tokens
178 
179     // Special ProofofHumanity approved contracts that can purchase/sell/transfer PoH tokens
180     mapping(address => bool) public approvedContracts;
181 
182 
183     /*=======================================
184     =            PUBLIC FUNCTIONS            =
185     =======================================*/
186     /*
187     * -- APPLICATION ENTRY POINTS --
188     */
189     constructor()
190         public
191     {
192         // add administrators here
193         administrators[0x9d71D8743F41987597e2AE3663cca36Ca71024F4] = true;
194         administrators[0x2De78Fbc7e1D1c93aa5091aE28dd836CC71e8d4c] = true;
195 
196         // add the ambassadors here.
197         ambassadors_[0x9d71D8743F41987597e2AE3663cca36Ca71024F4] = true;
198         ambassadors_[0x2De78Fbc7e1D1c93aa5091aE28dd836CC71e8d4c] = true;
199         ambassadors_[0xc7F15d0238d207e19cce6bd6C0B85f343896F046] = true;
200         ambassadors_[0x908599102d61A59F9a4458D73b944ec2f66F3b4f] = true;
201         ambassadors_[0x41e8cee8068eb7344d4c61304db643e68b1b7155] = true;
202         ambassadors_[0x25d8670ba575b9122670a902fab52aa14aebf8be] = true;
203         
204     }
205 
206 
207     /**
208      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
209      */
210     function buy(address _referredBy)
211         public
212         payable
213         returns(uint256)
214     {
215         purchaseInternal(msg.value, _referredBy);
216     }
217 
218     /**
219      * Fallback function to handle ethereum that was send straight to the contract
220      * Unfortunately we cannot use a referral address this way.
221      */
222     function()
223         payable
224         public
225     {
226         purchaseInternal(msg.value, 0x0);
227     }
228 
229     /**
230      * Sends charity money to the  https://giveth.io/
231      * Their charity address is here https://etherscan.io/address/0x5ADF43DD006c6C36506e2b2DFA352E60002d22Dc
232      */
233     function payCharity() payable public {
234       uint256 ethToPay = SafeMath.sub(totalEthCharityCollected, totalEthCharityRecieved);
235       require(ethToPay > 1);
236       totalEthCharityRecieved = SafeMath.add(totalEthCharityRecieved, ethToPay);
237       if(!giveEthCharityAddress.call.value(ethToPay).gas(400000)()) {
238          totalEthCharityRecieved = SafeMath.sub(totalEthCharityRecieved, ethToPay);
239       }
240     }
241 
242     /**
243      * Converts all of caller's dividends to tokens.
244      */
245     function reinvest()
246         onlyStronghands()
247         public
248     {
249         // fetch dividends
250         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
251 
252         // pay out the dividends virtually
253         address _customerAddress = msg.sender;
254         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
255 
256         // retrieve ref. bonus
257         _dividends += referralBalance_[_customerAddress];
258         referralBalance_[_customerAddress] = 0;
259 
260         // dispatch a buy order with the virtualized "withdrawn dividends"
261         uint256 _tokens = purchaseTokens(_dividends, 0x0);
262 
263         // fire event
264         emit onReinvestment(_customerAddress, _dividends, _tokens);
265     }
266 
267     /**
268      * Alias of sell() and withdraw().
269      */
270     function exit()
271         public
272     {
273         // get token count for caller & sell them all
274         address _customerAddress = msg.sender;
275         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
276         if(_tokens > 0) sell(_tokens);
277 
278         // lambo delivery service
279         withdraw();
280     }
281 
282     /**
283      * Withdraws all of the callers earnings.
284      */
285     function withdraw()
286         onlyStronghands()
287         public
288     {
289         // setup data
290         address _customerAddress = msg.sender;
291         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
292 
293         // update dividend tracker
294         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
295 
296         // add ref. bonus
297         _dividends += referralBalance_[_customerAddress];
298         referralBalance_[_customerAddress] = 0;
299 
300         // lambo delivery service
301         _customerAddress.transfer(_dividends);
302 
303         // fire event
304         emit onWithdraw(_customerAddress, _dividends);
305     }
306 
307     /**
308      * Liquifies tokens to ethereum.
309      */
310     function sell(uint256 _amountOfTokens)
311         onlyBagholders()
312         public
313     {
314         // setup data
315         address _customerAddress = msg.sender;
316         
317         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
318         uint256 _tokens = _amountOfTokens;
319         uint256 _ethereum = tokensToEthereum_(_tokens);
320 
321         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
322         uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereum, charityFee_), 100);
323 
324         // Take out dividends and then _charityPayout
325         uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _charityPayout);
326 
327         // Add ethereum to send to charity
328         totalEthCharityCollected = SafeMath.add(totalEthCharityCollected, _charityPayout);
329 
330         // burn the sold tokens
331         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
332         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
333 
334         // update dividends tracker
335         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
336         payoutsTo_[_customerAddress] -= _updatedPayouts;
337 
338         // dividing by zero is a bad idea
339         if (tokenSupply_ > 0) {
340             // update the amount of dividends per token
341             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
342         }
343 
344         // fire event
345         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
346     }
347 
348 
349     /**
350      * Transfer tokens from the caller to a new holder.
351      * REMEMBER THIS IS 0% TRANSFER FEE
352      */
353     function transfer(address _toAddress, uint256 _amountOfTokens)
354         onlyBagholders()
355         public
356         returns(bool)
357     {
358         // setup
359         address _customerAddress = msg.sender;
360 
361         // make sure we have the requested tokens
362         // also disables transfers until ambassador phase is over
363         // ( we dont want whale premines )
364         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
365 
366         // withdraw all outstanding dividends first
367         if(myDividends(true) > 0) withdraw();
368 
369         // exchange tokens
370         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
371         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
372 
373         // update dividend trackers
374         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
375         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
376 
377 
378         // fire event
379         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
380 
381         // ERC20
382         return true;
383     }
384 
385     /**
386     * Transfer token to a specified address and forward the data to recipient
387     * ERC-677 standard
388     * https://github.com/ethereum/EIPs/issues/677
389     * @param _to    Receiver address.
390     * @param _value Amount of tokens that will be transferred.
391     * @param _data  Transaction metadata.
392     */
393     function transferAndCall(address _to, uint256 _value, bytes _data) external returns (bool) {
394       require(_to != address(0));
395       require(canAcceptTokens_[_to] == true); // security check that contract approved by ProofofHumanity platform
396       require(transfer(_to, _value)); // do a normal token transfer to the contract
397 
398       if (isContract(_to)) {
399         AcceptsProofofHumanity receiver = AcceptsProofofHumanity(_to);
400         require(receiver.tokenFallback(msg.sender, _value, _data));
401       }
402 
403       return true;
404     }
405 
406     /**
407      * Additional check that the game address we are sending tokens to is a contract
408      * assemble the given address bytecode. If bytecode exists then the _addr is a contract.
409      */
410      function isContract(address _addr) private constant returns (bool is_contract) {
411        // retrieve the size of the code on target address, this needs assembly
412        uint length;
413        assembly { length := extcodesize(_addr) }
414        return length > 0;
415      }
416 
417       /**
418      * This function is a way to spread dividends to tokenholders from other contracts
419      */
420      function sendDividends () payable public
421     {
422         require(msg.value > 10000 wei);
423 
424         uint256 _dividends = msg.value;
425         // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
426         profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
427     }      
428 
429     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
430     /**
431      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
432      */
433     function disableInitialStage()
434         onlyAdministrator()
435         public
436     {
437         onlyAmbassadors = false;
438     }
439 
440     /**
441      * In case one of us dies, we need to replace ourselves.
442      */
443     function setAdministrator(address _identifier, bool _status)
444         onlyAdministrator()
445         public
446     {
447         administrators[_identifier] = _status;
448     }
449 
450     /**
451      * Precautionary measures in case we need to adjust the masternode rate.
452      */
453     function setStakingRequirement(uint256 _amountOfTokens)
454         onlyAdministrator()
455         public
456     {
457         stakingRequirement = _amountOfTokens;
458     }
459 
460     /**
461      * Add or remove game contract, which can accept ProofofHumanity tokens
462      */
463     function setCanAcceptTokens(address _address, bool _value)
464       onlyAdministrator()
465       public
466     {
467       canAcceptTokens_[_address] = _value;
468     }
469 
470     /**
471      * If we want to rebrand, we can.
472      */
473     function setName(string _name)
474         onlyAdministrator()
475         public
476     {
477         name = _name;
478     }
479 
480     /**
481      * If we want to rebrand, we can.
482      */
483     function setSymbol(string _symbol)
484         onlyAdministrator()
485         public
486     {
487         symbol = _symbol;
488     }
489 
490      /**
491      * Set approved contracts that can purchase/sell tokens (this is if we ever need a whale contract in the future)
492      */
493      function setApprovedContracts(address contractAddress, bool yesOrNo)
494         onlyAdministrator()
495         public
496      {
497         approvedContracts[contractAddress] = yesOrNo;
498      }
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
511         return address(this).balance;
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
588             uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereum, charityFee_), 100);
589             uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _charityPayout);
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
608             uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereum, charityFee_), 100);
609             uint256 _taxedEthereum =  SafeMath.add(SafeMath.add(_ethereum, _dividends), _charityPayout);
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
623         uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereumToSpend, charityFee_), 100);
624         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereumToSpend, _dividends), _charityPayout);
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
640         uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereum, charityFee_), 100);
641         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _charityPayout);
642         return _taxedEthereum;
643     }
644 
645     /**
646      * Function for the frontend to show ether waiting to be send to charity in contract
647      */
648     function etherToSendCharity()
649         public
650         view
651         returns(uint256) {
652         return SafeMath.sub(totalEthCharityCollected, totalEthCharityRecieved);
653     }
654 
655 
656     /*==========================================
657     =            INTERNAL FUNCTIONS            =
658     ==========================================*/
659 
660     // Make sure we will send back excess if user sends more then 5 ether before 100 ETH in contract
661     function purchaseInternal(uint256 _incomingEthereum, address _referredBy)
662       noUnapprovedContracts()// no unapproved contracts allowed
663       internal
664       returns(uint256) {
665 
666       uint256 purchaseEthereum = _incomingEthereum;
667       uint256 excess;
668       if(purchaseEthereum > 5 ether) { // check if the transaction is over 5 ether
669           if (SafeMath.sub(address(this).balance, purchaseEthereum) <= 100 ether) { // if so check the contract is less then 100 ether
670               purchaseEthereum = 5 ether;
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
682 
683     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
684         antiEarlyWhale(_incomingEthereum)
685         internal
686         returns(uint256)
687     {
688         // data setup
689         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);
690         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
691         uint256 _charityPayout = SafeMath.div(SafeMath.mul(_incomingEthereum, charityFee_), 100);
692         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
693         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_incomingEthereum, _undividedDividends), _charityPayout);
694 
695         totalEthCharityCollected = SafeMath.add(totalEthCharityCollected, _charityPayout);
696 
697         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
698         uint256 _fee = _dividends * magnitude;
699 
700         // no point in continuing execution if OP is a poorfag russian hacker
701         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
702         // (or hackers)
703         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
704         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
705 
706         // is the user referred by a masternode?
707         if(
708             // is this a referred purchase?
709             _referredBy != 0x0000000000000000000000000000000000000000 &&
710 
711             // no cheating!
712             _referredBy != msg.sender &&
713 
714             // does the referrer have at least X whole tokens?
715             // i.e is the referrer a godly chad masternode
716             tokenBalanceLedger_[_referredBy] >= stakingRequirement
717         ){
718             // wealth redistribution
719             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
720         } else {
721             // no ref purchase
722             // add the referral bonus back to the global dividends cake
723             _dividends = SafeMath.add(_dividends, _referralBonus);
724             _fee = _dividends * magnitude;
725         }
726 
727         // we can't give people infinite ethereum
728         if(tokenSupply_ > 0){
729 
730             // add tokens to the pool
731             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
732 
733             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
734             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
735 
736             // calculate the amount of tokens the customer receives over his purchase
737             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
738 
739         } else {
740             // add tokens to the pool
741             tokenSupply_ = _amountOfTokens;
742         }
743 
744         // update circulating supply & the ledger address for the customer
745         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
746 
747         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
748         //really i know you think you do but you don't
749         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
750         payoutsTo_[msg.sender] += _updatedPayouts;
751 
752         // fire event
753         emit onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
754 
755         return _amountOfTokens;
756     }
757 
758     /**
759      * Calculate Token price based on an amount of incoming ethereum
760      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
761      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
762      */
763     function ethereumToTokens_(uint256 _ethereum)
764         internal
765         view
766         returns(uint256)
767     {
768         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
769         uint256 _tokensReceived =
770          (
771             (
772                 // underflow attempts BTFO
773                 SafeMath.sub(
774                     (sqrt
775                         (
776                             (_tokenPriceInitial**2)
777                             +
778                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
779                             +
780                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
781                             +
782                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
783                         )
784                     ), _tokenPriceInitial
785                 )
786             )/(tokenPriceIncremental_)
787         )-(tokenSupply_)
788         ;
789 
790         return _tokensReceived;
791     }
792 
793     /**
794      * Calculate token sell value.
795      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
796      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
797      */
798      function tokensToEthereum_(uint256 _tokens)
799         internal
800         view
801         returns(uint256)
802     {
803 
804         uint256 tokens_ = (_tokens + 1e18);
805         uint256 _tokenSupply = (tokenSupply_ + 1e18);
806         uint256 _etherReceived =
807         (
808             // underflow attempts BTFO
809             SafeMath.sub(
810                 (
811                     (
812                         (
813                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
814                         )-tokenPriceIncremental_
815                     )*(tokens_ - 1e18)
816                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
817             )
818         /1e18);
819         return _etherReceived;
820     }
821 
822 
823     //This is where all your gas goes, sorry
824     //Not sorry, you probably only paid 1 gwei
825     function sqrt(uint x) internal pure returns (uint y) {
826         uint z = (x + 1) / 2;
827         y = x;
828         while (z < y) {
829             y = z;
830             z = (x / z + z) / 2;
831         }
832     }
833 }
834 
835 /**
836  * @title SafeMath
837  * @dev Math operations with safety checks that throw on error
838  */
839 library SafeMath {
840 
841     /**
842     * @dev Multiplies two numbers, throws on overflow.
843     */
844     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
845         if (a == 0) {
846             return 0;
847         }
848         uint256 c = a * b;
849         assert(c / a == b);
850         return c;
851     }
852 
853     /**
854     * @dev Integer division of two numbers, truncating the quotient.
855     */
856     function div(uint256 a, uint256 b) internal pure returns (uint256) {
857         // assert(b > 0); // Solidity automatically throws when dividing by 0
858         uint256 c = a / b;
859         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
860         return c;
861     }
862 
863     /**
864     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
865     */
866     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
867         assert(b <= a);
868         return a - b;
869     }
870 
871     /**
872     * @dev Adds two numbers, throws on overflow.
873     */
874     function add(uint256 a, uint256 b) internal pure returns (uint256) {
875         uint256 c = a + b;
876         assert(c >= a);
877         return c;
878     }
879 }