1 pragma solidity ^0.4.21;
2 
3 
4 /*
5 
6 
7 ******************** OmniDex *********************
8 * [x] What is new?
9 * [x] 0% TRANSFER FEES! This allows for tokens to be used in future games with out being taxed
10 * [X] 18% DIVIDENDS AND MASTERNODES!
11 * [x] 2% Bankroll Fee 
12 * 75% of Bankroll ETH will be dumped back into the contract Every Monday at Midnight Eastern Time. 25% of Bankroll ETH collect will go to funding future development.
13 * [x] DAPP INTEROPERABILITY, games and other dAPPs can incorporate OmniDex tokens!
14 *
15 */
16 
17 
18 /**
19  * Definition of contract accepting OmniDex tokens
20  * Games, casinos, anything can reuse this contract to support OmniDex tokens
21  */
22 contract AcceptsOmniDex {
23     OmniDex public tokenContract;
24 
25     function AcceptsOmniDex(address _tokenContract) public {
26         tokenContract = OmniDex(_tokenContract);
27     }
28 
29     modifier onlyTokenContract {
30         require(msg.sender == address(tokenContract));
31         _;
32     }
33 
34     /**
35     * @dev Standard ERC677 function that will handle incoming token transfers.
36     *
37     * @param _from  Token sender address.
38     * @param _value Amount of tokens.
39     * @param _data  Transaction metadata.
40     */
41     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
42 }
43 
44 
45 contract OmniDex {
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
61     modifier notContract() {
62       require (msg.sender == tx.origin);
63       _;
64     }
65 
66     // administrators can:
67     // -> change the name of the contract
68     // -> change the name of the token
69     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
70     // they CANNOT:
71     // -> take funds
72     // -> disable withdrawals
73     // -> kill the contract
74     // -> change the price of tokens
75     modifier onlyAdministrator(){
76         address _customerAddress = msg.sender;
77         require(administrators[_customerAddress]);
78         _;
79     }
80 
81 
82     // ensures that the first tokens in the contract will be equally distributed
83     // meaning, no divine dump will be ever possible
84     // result: healthy longevity.
85     modifier antiEarlyWhale(uint256 _amountOfEthereum){
86         address _customerAddress = msg.sender;
87 
88         // are we still in the vulnerable phase?
89         // if so, enact anti early whale protocol
90         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
91             require(
92                 // is the customer in the ambassador list?
93                 ambassadors_[_customerAddress] == true &&
94 
95                 // does the customer purchase exceed the max ambassador quota?
96                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
97 
98             );
99 
100             // updated the accumulated quota
101             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
102 
103             // execute
104             _;
105         } else {
106             // in case the ether count drops low, the ambassador phase won't reinitiate
107             onlyAmbassadors = false;
108             _;
109         }
110 
111     }
112 
113     /*==============================
114     =            EVENTS            =
115     ==============================*/
116     event onTokenPurchase(
117         address indexed customerAddress,
118         uint256 incomingEthereum,
119         uint256 tokensMinted,
120         address indexed referredBy
121     );
122 
123     event onTokenSell(
124         address indexed customerAddress,
125         uint256 tokensBurned,
126         uint256 ethereumEarned
127     );
128 
129     event onReinvestment(
130         address indexed customerAddress,
131         uint256 ethereumReinvested,
132         uint256 tokensMinted
133     );
134 
135     event onWithdraw(
136         address indexed customerAddress,
137         uint256 ethereumWithdrawn
138     );
139 
140     // ERC20
141     event Transfer(
142         address indexed from,
143         address indexed to,
144         uint256 tokens
145     );
146 
147 
148     /*=====================================
149     =            CONFIGURABLES            =
150     =====================================*/
151     string public name = "OmniDex";
152     string public symbol = "OMNI";
153     uint8 constant public decimals = 18;
154     uint8 constant internal dividendFee_ = 18; // 18% dividend fee on each buy and sell
155     uint8 constant internal bankrollFee_ = 2; // 2% Bankroll fee on each buy and sell
156     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
157     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
158     uint256 constant internal magnitude = 2**64;
159 
160     // Address to send the Bankroll 
161     
162     address constant public giveEthBankrollAddress = 0x523a819E6dd9295Dba794C275627C95fa0644E8D;
163     uint256 public totalEthBankrollRecieved; // total ETH Bankroll recieved from this contract
164     uint256 public totalEthBankrollCollected; // total ETH Bankroll collected in this contract
165 
166     // proof of stake (defaults at 100 tokens)
167     uint256 public stakingRequirement = 30e18;
168 
169     // ambassador program
170     mapping(address => bool) internal ambassadors_;
171     uint256 constant internal ambassadorMaxPurchase_ = 0.5 ether;
172     uint256 constant internal ambassadorQuota_ = 3 ether; // If ambassor quota not met, disable to open to public
173 
174 
175 
176    /*================================
177     =            DATASETS            =
178     ================================*/
179     // amount of shares for each address (scaled number)
180     mapping(address => uint256) internal tokenBalanceLedger_;
181     mapping(address => uint256) internal referralBalance_;
182     mapping(address => int256) internal payoutsTo_;
183     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
184     uint256 internal tokenSupply_ = 0;
185     uint256 internal profitPerShare_;
186 
187     // administrator list (see above on what they can do)
188     mapping(address => bool) public administrators;
189 
190     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
191     bool public onlyAmbassadors = true;
192 
193     // Special OmniDex Platform control from scam game contracts on OmniDex platform
194     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept OmniDex tokens
195 
196 
197 
198     /*=======================================
199     =            PUBLIC FUNCTIONS            =
200     =======================================*/
201     /*
202     * -- APPLICATION ENTRY POINTS --
203     */
204     function OmniDex()
205         public
206     {
207         // add administrators here
208         administrators[0xDEAD04D223220ACb19B46AFc84E04D490b872249] = true;
209 
210         // add the ambassadors here.
211         ambassadors_[0xDEAD04D223220ACb19B46AFc84E04D490b872249] = true;
212         //ambassador Dev
213         ambassadors_[0x008ca4F1bA79D1A265617c6206d7884ee8108a78] = true;
214         //ambassador Crypto Alex
215         ambassadors_[0x9f06A41D9F00007009e4c1842D2f2aA9FC844a26] = true;
216         //ambassador FROG
217         ambassadors_[0xAAa2792AC2A60c694a87Cec7516E8CdFE85B0463] = true;
218         //ambassador Cliffy
219         ambassadors_[0x41a21b264f9ebf6cf571d4543a5b3ab1c6bed98c] = true;
220         //ambassador Ravi
221         ambassadors_[0xAD6D6c25FCDAb2e737e8de31795df4c6bB6D9Bae] = true;
222         //ambassador Hellina
223         
224         
225         
226     }
227 
228 
229     /**
230      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
231      */
232     function buy(address _referredBy)
233         public
234         payable
235         returns(uint256)
236     {
237         purchaseInternal(msg.value, _referredBy);
238     }
239 
240     /**
241      * Fallback function to handle ethereum that was send straight to the contract
242      * Unfortunately we cannot use a referral address this way.
243      */
244     function()
245         payable
246         public
247     {
248         purchaseInternal(msg.value, 0x0);
249     }
250 
251     /**
252      * Sends Bankroll funds for additional dividends
253      * Bankroll Address: https://etherscan.io/address/0x523a819E6dd9295Dba794C275627C95fa0644E8D
254      */
255     function payBankroll() payable public {
256       uint256 ethToPay = SafeMath.sub(totalEthBankrollCollected, totalEthBankrollRecieved);
257       require(ethToPay > 1);
258       totalEthBankrollRecieved = SafeMath.add(totalEthBankrollRecieved, ethToPay);
259       if(!giveEthBankrollAddress.call.value(ethToPay).gas(400000)()) {
260          totalEthBankrollRecieved = SafeMath.sub(totalEthBankrollRecieved, ethToPay);
261       }
262     }
263 
264     /**
265      * Converts all of caller's dividends to tokens.
266      */
267     function reinvest()
268         onlyStronghands()
269         public
270     {
271         // fetch dividends
272         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
273 
274         // pay out the dividends virtually
275         address _customerAddress = msg.sender;
276         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
277 
278         // retrieve ref. bonus
279         _dividends += referralBalance_[_customerAddress];
280         referralBalance_[_customerAddress] = 0;
281 
282         // dispatch a buy order with the virtualized "withdrawn dividends"
283         uint256 _tokens = purchaseTokens(_dividends, 0x0);
284 
285         // fire event
286         onReinvestment(_customerAddress, _dividends, _tokens);
287     }
288 
289     /**
290      * Alias of sell() and withdraw().
291      */
292     function exit()
293         public
294     {
295         // get token count for caller & sell them all
296         address _customerAddress = msg.sender;
297         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
298         if(_tokens > 0) sell(_tokens);
299 
300         // lambo delivery service
301         withdraw();
302     }
303 
304     /**
305      * Withdraws all of the callers earnings.
306      */
307     function withdraw()
308         onlyStronghands()
309         public
310     {
311         // setup data
312         address _customerAddress = msg.sender;
313         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
314 
315         // update dividend tracker
316         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
317 
318         // add ref. bonus
319         _dividends += referralBalance_[_customerAddress];
320         referralBalance_[_customerAddress] = 0;
321 
322         // lambo delivery service
323         _customerAddress.transfer(_dividends);
324 
325         // fire event
326         onWithdraw(_customerAddress, _dividends);
327     }
328 
329     /**
330      * Liquifies tokens to ethereum.
331      */
332     function sell(uint256 _amountOfTokens)
333         onlyBagholders()
334         public
335     {
336         // setup data
337         address _customerAddress = msg.sender;
338         // russian hackers BTFO
339         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
340         uint256 _tokens = _amountOfTokens;
341         uint256 _ethereum = tokensToEthereum_(_tokens);
342 
343         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
344         uint256 _bankrollPayout = SafeMath.div(SafeMath.mul(_ethereum, bankrollFee_), 100);
345 
346         // Take out dividends and then _bankrollPayout
347         uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _bankrollPayout);
348 
349         // Add ethereum to send to Bankroll
350         totalEthBankrollCollected = SafeMath.add(totalEthBankrollCollected, _bankrollPayout);
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
417       require(canAcceptTokens_[_to] == true); // security check that contract approved by OmniDex platform
418       require(transfer(_to, _value)); // do a normal token transfer to the contract
419 
420       if (isContract(_to)) {
421         AcceptsOmniDex receiver = AcceptsOmniDex(_to);
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
443     function disableInitialStage()
444         onlyAdministrator()
445         public
446     {
447         onlyAmbassadors = false;
448     }
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
471      * Add or remove game contract, which can accept OmniDex tokens
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
588             uint256 _bankrollPayout = SafeMath.div(SafeMath.mul(_ethereum, bankrollFee_), 100);
589             uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _bankrollPayout);
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
608             uint256 _bankrollPayout = SafeMath.div(SafeMath.mul(_ethereum, bankrollFee_), 100);
609             uint256 _taxedEthereum =  SafeMath.add(SafeMath.add(_ethereum, _dividends), _bankrollPayout);
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
623         uint256 _bankrollPayout = SafeMath.div(SafeMath.mul(_ethereumToSpend, bankrollFee_), 100);
624         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereumToSpend, _dividends), _bankrollPayout);
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
640         uint256 _bankrollPayout = SafeMath.div(SafeMath.mul(_ethereum, bankrollFee_), 100);
641         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _bankrollPayout);
642         return _taxedEthereum;
643     }
644 
645     /**
646      * Function for the frontend to show ether waiting to be sent to Bankroll in contract
647      */
648     function etherToSendBankroll()
649         public
650         view
651         returns(uint256) {
652         return SafeMath.sub(totalEthBankrollCollected, totalEthBankrollRecieved);
653     }
654 
655 
656     /*==========================================
657     =            INTERNAL FUNCTIONS            =
658     ==========================================*/
659 
660     // Make sure we will send back excess if user sends more then 2 ether before 100 ETH in contract
661     function purchaseInternal(uint256 _incomingEthereum, address _referredBy)
662       notContract()// no contracts allowed
663       internal
664       returns(uint256) {
665 
666       uint256 purchaseEthereum = _incomingEthereum;
667       uint256 excess;
668       if(purchaseEthereum > 3 ether) { // check if the transaction is over 3 ether
669           if (SafeMath.sub(address(this).balance, purchaseEthereum) <= 100 ether) { // if so check the contract is less then 100 ether
670               purchaseEthereum = 3 ether;
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
691         uint256 _bankrollPayout = SafeMath.div(SafeMath.mul(_incomingEthereum, bankrollFee_), 100);
692         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
693         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_incomingEthereum, _undividedDividends), _bankrollPayout);
694 
695         totalEthBankrollCollected = SafeMath.add(totalEthBankrollCollected, _bankrollPayout);
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
753         onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
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