1 pragma solidity ^0.4.13;
2 
3 contract AcceptsProofofHumanity {
4     E25 public tokenContract;
5 
6     function AcceptsProofofHumanity(address _tokenContract) public {
7         tokenContract = E25(_tokenContract);
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
26 contract E25 {
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
62 
63     // ensures that the first tokens in the contract will be equally distributed
64     // meaning, no divine dump will be ever possible
65     // result: healthy longevity.
66     modifier antiEarlyWhale(uint256 _amountOfEthereum){
67         address _customerAddress = msg.sender;
68 
69         // are we still in the vulnerable phase?
70         // if so, enact anti early whale protocol
71         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
72             require(
73                 // is the customer in the ambassador list?
74                 ambassadors_[_customerAddress] == true &&
75 
76                 // does the customer purchase exceed the max ambassador quota?
77                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
78 
79             );
80 
81             // updated the accumulated quota
82             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
83 
84             // execute
85             _;
86         } else {
87             // in case the ether count drops low, the ambassador phase won't reinitiate
88             onlyAmbassadors = false;
89             _;
90         }
91 
92     }
93 
94     /*==============================
95     =            EVENTS            =
96     ==============================*/
97     event onTokenPurchase(
98         address indexed customerAddress,
99         uint256 incomingEthereum,
100         uint256 tokensMinted,
101         address indexed referredBy
102     );
103 
104     event onTokenSell(
105         address indexed customerAddress,
106         uint256 tokensBurned,
107         uint256 ethereumEarned
108     );
109 
110     event onReinvestment(
111         address indexed customerAddress,
112         uint256 ethereumReinvested,
113         uint256 tokensMinted
114     );
115 
116     event onWithdraw(
117         address indexed customerAddress,
118         uint256 ethereumWithdrawn
119     );
120 
121     // ERC20
122     event Transfer(
123         address indexed from,
124         address indexed to,
125         uint256 tokens
126     );
127 
128 
129     /*=====================================
130     =            CONFIGURABLES            =
131     =====================================*/
132     string public name = "E25";
133     string public symbol = "E25";
134     uint8 constant public decimals = 18;
135     uint8 constant internal dividendFee_ = 25; // 25% dividend fee on each buy and sell
136     uint8 constant internal charityFee_ = 4; // 4% charity fee on each buy and sell
137     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
138     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
139     uint256 constant internal magnitude = 2**64;
140 
141     // Address to send the charity  ! :)
142     //  https://giveth.io/
143     // https://etherscan.io/address/0x5ADF43DD006c6C36506e2b2DFA352E60002d22Dc
144     address constant public giveEthCharityAddress =0x9f8162583f7Da0a35a5C00e90bb15f22DcdE41eD;
145     uint256 public totalEthCharityRecieved; // total ETH charity recieved from this contract
146     uint256 public totalEthCharityCollected; // total ETH charity collected in this contract
147 
148     // proof of stake (defaults at 100 tokens)
149     uint256 public stakingRequirement = 10e18;
150 
151     // ambassador program
152     mapping(address => bool) internal ambassadors_;
153     uint256 constant internal ambassadorMaxPurchase_ = 0.4 ether;
154     uint256 constant internal ambassadorQuota_ = 10 ether;
155 
156 
157 
158    /*================================
159     =            DATASETS            =
160     ================================*/
161     // amount of shares for each address (scaled number)
162     mapping(address => uint256) internal tokenBalanceLedger_;
163     mapping(address => uint256) internal referralBalance_;
164     mapping(address => int256) internal payoutsTo_;
165     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
166     uint256 internal tokenSupply_ = 0;
167     uint256 internal profitPerShare_;
168 
169     // administrator list (see above on what they can do)
170     mapping(address => bool) public administrators;
171 
172     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
173     bool public onlyAmbassadors = false;
174 
175     // Special ProofofHumanity Platform control from scam game contracts on ProofofHumanity platform
176     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept ProofofHumanity tokens
177 
178 
179 
180     /*=======================================
181     =            PUBLIC FUNCTIONS            =
182     =======================================*/
183     /*
184     * -- APPLICATION ENTRY POINTS --
185     */
186     function E25()
187         public
188     {
189   
190         
191     }
192 
193 
194     /**
195      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
196      */
197     function buy(address _referredBy)
198         public
199         payable
200         returns(uint256)
201     {
202         purchaseInternal(msg.value, _referredBy);
203     }
204 
205     /**
206      * Fallback function to handle ethereum that was send straight to the contract
207      * Unfortunately we cannot use a referral address this way.
208      */
209     function()
210         payable
211         public
212     {
213         purchaseInternal(msg.value, 0x0);
214     }
215 
216     /**
217      * Sends charity money to the  https://giveth.io/
218      * Their charity address is here https://etherscan.io/address/0x5ADF43DD006c6C36506e2b2DFA352E60002d22Dc
219      */
220     function payCharity() payable public {
221       uint256 ethToPay = SafeMath.sub(totalEthCharityCollected, totalEthCharityRecieved);
222       require(ethToPay > 1);
223       totalEthCharityRecieved = SafeMath.add(totalEthCharityRecieved, ethToPay);
224       if(!giveEthCharityAddress.call.value(ethToPay).gas(400000)()) {
225          totalEthCharityRecieved = SafeMath.sub(totalEthCharityRecieved, ethToPay);
226       }
227     }
228 
229     /**
230      * Converts all of caller's dividends to tokens.
231      */
232     function reinvest()
233         onlyStronghands()
234         public
235     {
236         // fetch dividends
237         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
238 
239         // pay out the dividends virtually
240         address _customerAddress = msg.sender;
241         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
242 
243         // retrieve ref. bonus
244         _dividends += referralBalance_[_customerAddress];
245         referralBalance_[_customerAddress] = 0;
246 
247         // dispatch a buy order with the virtualized "withdrawn dividends"
248         uint256 _tokens = purchaseTokens(_dividends, 0x0);
249 
250         // fire event
251         onReinvestment(_customerAddress, _dividends, _tokens);
252     }
253 
254     /**
255      * Alias of sell() and withdraw().
256      */
257     function exit()
258         public
259     {
260         // get token count for caller & sell them all
261         address _customerAddress = msg.sender;
262         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
263         if(_tokens > 0) sell(_tokens);
264 
265         // lambo delivery service
266         withdraw();
267     }
268 
269     /**
270      * Withdraws all of the callers earnings.
271      */
272     function withdraw()
273         onlyStronghands()
274         public
275     {
276         // setup data
277         address _customerAddress = msg.sender;
278         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
279 
280         // update dividend tracker
281         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
282 
283         // add ref. bonus
284         _dividends += referralBalance_[_customerAddress];
285         referralBalance_[_customerAddress] = 0;
286 
287         // lambo delivery service
288         _customerAddress.transfer(_dividends);
289 
290         // fire event
291         onWithdraw(_customerAddress, _dividends);
292     }
293 
294     /**
295      * Liquifies tokens to ethereum.
296      */
297     function sell(uint256 _amountOfTokens)
298         onlyBagholders()
299         public
300     {
301         // setup data
302         address _customerAddress = msg.sender;
303         // russian hackers BTFO
304         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
305         uint256 _tokens = _amountOfTokens;
306         uint256 _ethereum = tokensToEthereum_(_tokens);
307 
308         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
309         uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereum, charityFee_), 100);
310 
311         // Take out dividends and then _charityPayout
312         uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _charityPayout);
313 
314         // Add ethereum to send to charity
315         totalEthCharityCollected = SafeMath.add(totalEthCharityCollected, _charityPayout);
316 
317         // burn the sold tokens
318         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
319         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
320 
321         // update dividends tracker
322         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
323         payoutsTo_[_customerAddress] -= _updatedPayouts;
324 
325         // dividing by zero is a bad idea
326         if (tokenSupply_ > 0) {
327             // update the amount of dividends per token
328             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
329         }
330 
331         // fire event
332         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
333     }
334 
335 
336     /**
337      * Transfer tokens from the caller to a new holder.
338      * REMEMBER THIS IS 0% TRANSFER FEE
339      */
340     function transfer(address _toAddress, uint256 _amountOfTokens)
341         onlyBagholders()
342         public
343         returns(bool)
344     {
345         // setup
346         address _customerAddress = msg.sender;
347 
348         // make sure we have the requested tokens
349         // also disables transfers until ambassador phase is over
350         // ( we dont want whale premines )
351         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
352 
353         // withdraw all outstanding dividends first
354         if(myDividends(true) > 0) withdraw();
355 
356         // exchange tokens
357         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
358         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
359 
360         // update dividend trackers
361         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
362         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
363 
364 
365         // fire event
366         Transfer(_customerAddress, _toAddress, _amountOfTokens);
367 
368         // ERC20
369         return true;
370     }
371 
372     /**
373     * Transfer token to a specified address and forward the data to recipient
374     * ERC-677 standard
375     * https://github.com/ethereum/EIPs/issues/677
376     * @param _to    Receiver address.
377     * @param _value Amount of tokens that will be transferred.
378     * @param _data  Transaction metadata.
379     */
380     function transferAndCall(address _to, uint256 _value, bytes _data) external returns (bool) {
381       require(_to != address(0));
382       require(canAcceptTokens_[_to] == true); // security check that contract approved by ProofofHumanity platform
383       require(transfer(_to, _value)); // do a normal token transfer to the contract
384 
385       if (isContract(_to)) {
386         AcceptsProofofHumanity receiver = AcceptsProofofHumanity(_to);
387         require(receiver.tokenFallback(msg.sender, _value, _data));
388       }
389 
390       return true;
391     }
392 
393     /**
394      * Additional check that the game address we are sending tokens to is a contract
395      * assemble the given address bytecode. If bytecode exists then the _addr is a contract.
396      */
397      function isContract(address _addr) private constant returns (bool is_contract) {
398        // retrieve the size of the code on target address, this needs assembly
399        uint length;
400        assembly { length := extcodesize(_addr) }
401        return length > 0;
402      }
403 
404     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
405     /**
406      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
407      */
408     function disableInitialStage()
409         onlyAdministrator()
410         public
411     {
412         onlyAmbassadors = false;
413     }
414 
415     /**
416      * In case one of us dies, we need to replace ourselves.
417      */
418     function setAdministrator(address _identifier, bool _status)
419         onlyAdministrator()
420         public
421     {
422         administrators[_identifier] = _status;
423     }
424 
425     /**
426      * Precautionary measures in case we need to adjust the masternode rate.
427      */
428     function setStakingRequirement(uint256 _amountOfTokens)
429         onlyAdministrator()
430         public
431     {
432         stakingRequirement = _amountOfTokens;
433     }
434 
435     /**
436      * Add or remove game contract, which can accept ProofofHumanity tokens
437      */
438     function setCanAcceptTokens(address _address, bool _value)
439       onlyAdministrator()
440       public
441     {
442       canAcceptTokens_[_address] = _value;
443     }
444 
445     /**
446      * If we want to rebrand, we can.
447      */
448     function setName(string _name)
449         onlyAdministrator()
450         public
451     {
452         name = _name;
453     }
454 
455     /**
456      * If we want to rebrand, we can.
457      */
458     function setSymbol(string _symbol)
459         onlyAdministrator()
460         public
461     {
462         symbol = _symbol;
463     }
464 
465 
466     /*----------  HELPERS AND CALCULATORS  ----------*/
467     /**
468      * Method to view the current Ethereum stored in the contract
469      * Example: totalEthereumBalance()
470      */
471     function totalEthereumBalance()
472         public
473         view
474         returns(uint)
475     {
476         return this.balance;
477     }
478 
479     /**
480      * Retrieve the total token supply.
481      */
482     function totalSupply()
483         public
484         view
485         returns(uint256)
486     {
487         return tokenSupply_;
488     }
489 
490     /**
491      * Retrieve the tokens owned by the caller.
492      */
493     function myTokens()
494         public
495         view
496         returns(uint256)
497     {
498         address _customerAddress = msg.sender;
499         return balanceOf(_customerAddress);
500     }
501 
502     /**
503      * Retrieve the dividends owned by the caller.
504      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
505      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
506      * But in the internal calculations, we want them separate.
507      */
508     function myDividends(bool _includeReferralBonus)
509         public
510         view
511         returns(uint256)
512     {
513         address _customerAddress = msg.sender;
514         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
515     }
516 
517     /**
518      * Retrieve the token balance of any single address.
519      */
520     function balanceOf(address _customerAddress)
521         view
522         public
523         returns(uint256)
524     {
525         return tokenBalanceLedger_[_customerAddress];
526     }
527 
528     /**
529      * Retrieve the dividend balance of any single address.
530      */
531     function dividendsOf(address _customerAddress)
532         view
533         public
534         returns(uint256)
535     {
536         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
537     }
538 
539     /**
540      * Return the buy price of 1 individual token.
541      */
542     function sellPrice()
543         public
544         view
545         returns(uint256)
546     {
547         // our calculation relies on the token supply, so we need supply. Doh.
548         if(tokenSupply_ == 0){
549             return tokenPriceInitial_ - tokenPriceIncremental_;
550         } else {
551             uint256 _ethereum = tokensToEthereum_(1e18);
552             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
553             uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereum, charityFee_), 100);
554             uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _charityPayout);
555             return _taxedEthereum;
556         }
557     }
558 
559     /**
560      * Return the sell price of 1 individual token.
561      */
562     function buyPrice()
563         public
564         view
565         returns(uint256)
566     {
567         // our calculation relies on the token supply, so we need supply. Doh.
568         if(tokenSupply_ == 0){
569             return tokenPriceInitial_ + tokenPriceIncremental_;
570         } else {
571             uint256 _ethereum = tokensToEthereum_(1e18);
572             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
573             uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereum, charityFee_), 100);
574             uint256 _taxedEthereum =  SafeMath.add(SafeMath.add(_ethereum, _dividends), _charityPayout);
575             return _taxedEthereum;
576         }
577     }
578 
579     /**
580      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
581      */
582     function calculateTokensReceived(uint256 _ethereumToSpend)
583         public
584         view
585         returns(uint256)
586     {
587         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, dividendFee_), 100);
588         uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereumToSpend, charityFee_), 100);
589         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereumToSpend, _dividends), _charityPayout);
590         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
591         return _amountOfTokens;
592     }
593 
594     /**
595      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
596      */
597     function calculateEthereumReceived(uint256 _tokensToSell)
598         public
599         view
600         returns(uint256)
601     {
602         require(_tokensToSell <= tokenSupply_);
603         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
604         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
605         uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereum, charityFee_), 100);
606         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _charityPayout);
607         return _taxedEthereum;
608     }
609 
610     /**
611      * Function for the frontend to show ether waiting to be send to charity in contract
612      */
613     function etherToSendCharity()
614         public
615         view
616         returns(uint256) {
617         return SafeMath.sub(totalEthCharityCollected, totalEthCharityRecieved);
618     }
619 
620 
621     /*==========================================
622     =            INTERNAL FUNCTIONS            =
623     ==========================================*/
624 
625     // Make sure we will send back excess if user sends more then 5 ether before 100 ETH in contract
626     function purchaseInternal(uint256 _incomingEthereum, address _referredBy)
627       notContract()// no contracts allowed
628       internal
629       returns(uint256) {
630 
631       uint256 purchaseEthereum = _incomingEthereum;
632       uint256 excess;
633       if(purchaseEthereum > 5 ether) { // check if the transaction is over 5 ether
634           if (SafeMath.sub(address(this).balance, purchaseEthereum) <= 100 ether) { // if so check the contract is less then 100 ether
635               purchaseEthereum = 5 ether;
636               excess = SafeMath.sub(_incomingEthereum, purchaseEthereum);
637           }
638       }
639 
640       purchaseTokens(purchaseEthereum, _referredBy);
641 
642       if (excess > 0) {
643         msg.sender.transfer(excess);
644       }
645     }
646 
647 
648     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
649         antiEarlyWhale(_incomingEthereum)
650         internal
651         returns(uint256)
652     {
653         // data setup
654         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);
655         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
656         uint256 _charityPayout = SafeMath.div(SafeMath.mul(_incomingEthereum, charityFee_), 100);
657         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
658         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_incomingEthereum, _undividedDividends), _charityPayout);
659 
660         totalEthCharityCollected = SafeMath.add(totalEthCharityCollected, _charityPayout);
661 
662         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
663         uint256 _fee = _dividends * magnitude;
664 
665         // no point in continuing execution if OP is a poorfag russian hacker
666         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
667         // (or hackers)
668         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
669         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
670 
671         // is the user referred by a masternode?
672         if(
673             // is this a referred purchase?
674             _referredBy != 0x0000000000000000000000000000000000000000 &&
675 
676             // no cheating!
677             _referredBy != msg.sender &&
678 
679             // does the referrer have at least X whole tokens?
680             // i.e is the referrer a godly chad masternode
681             tokenBalanceLedger_[_referredBy] >= stakingRequirement
682         ){
683             // wealth redistribution
684             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
685         } else {
686             // no ref purchase
687             // add the referral bonus back to the global dividends cake
688             _dividends = SafeMath.add(_dividends, _referralBonus);
689             _fee = _dividends * magnitude;
690         }
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
718         onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
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