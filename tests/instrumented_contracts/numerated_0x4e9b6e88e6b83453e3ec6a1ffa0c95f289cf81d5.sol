1 pragma solidity ^0.4.21;
2 
3 /*
4 *  DAILYROI EXCHANGE
5 *
6 *
7 * [x] 0% TRANSFER FEES
8 * [x] 20% DIVIDENDS AND MASTERNODES
9 * [x] Multi-tier Masternode system 50% 1st ref 30% 2nd ref 20% 3rd ref
10 * [x] 2% FEE ON EACH BUY AND SELL GO TO Smart Contract Fund 0x9F0a1bcD44f522318900e70A2617C0056378BB2D
11 *     2% - 100% to DailyRoi
12 * [x] DAILYROI Token can be used for future games
13 *
14 * Official Website: https://exchange.dailyroi.fun/
15 * Official Discord: https://discord.gg/3kX7Vv6
16 */
17 
18 
19 /**
20  * Definition of contract accepting DailyRoi tokens
21  * Games, casinos, anything can reuse this contract to support DailyRoi tokens
22  */
23 contract AcceptsDailyRoi {
24     DailyRoi public tokenContract;
25 
26     function AcceptsDailyRoi(address _tokenContract) public {
27         tokenContract = DailyRoi(_tokenContract);
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
45 
46 contract DailyRoi {
47     /*=================================
48     =            MODIFIERS            =
49     =================================*/
50     // only people with tokens
51     modifier onlyBagholders() {
52         require(myTokens() > 0);
53         _;
54     }
55 
56     // only people with profits
57     modifier onlyStronghands() {
58         require(myDividends(true) > 0);
59         _;
60     }
61 
62     modifier notContract() {
63       require (msg.sender == tx.origin);
64       _;
65     }
66 
67     // administrators can:
68     // -> change the name of the contract
69     // -> change the name of the token
70     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
71     // they CANNOT:
72     // -> take funds
73     // -> disable withdrawals
74     // -> kill the contract
75     // -> change the price of tokens
76     modifier onlyAdministrator(){
77         address _customerAddress = msg.sender;
78         require(administrators[_customerAddress]);
79         _;
80     }
81 
82     uint ACTIVATION_TIME = 1537927200;
83 
84 
85     // ensures that the first tokens in the contract will be equally distributed
86     // meaning, no divine dump will be ever possible
87     // result: healthy longevity.
88     modifier antiEarlyWhale(uint256 _amountOfEthereum){
89         address _customerAddress = msg.sender;
90 
91         if (now >= ACTIVATION_TIME) {
92             onlyAmbassadors = false;
93         }
94 
95         // are we still in the vulnerable phase?
96         // if so, enact anti early whale protocol
97         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
98             require(
99                 // is the customer in the ambassador list?
100                 ambassadors_[_customerAddress] == true &&
101 
102                 // does the customer purchase exceed the max ambassador quota?
103                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
104 
105             );
106 
107             // updated the accumulated quota
108             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
109 
110             // execute
111             _;
112         } else {
113             // in case the ether count drops low, the ambassador phase won't reinitiate
114             onlyAmbassadors = false;
115             _;
116         }
117 
118     }
119 
120     /*==============================
121     =            EVENTS            =
122     ==============================*/
123     event onTokenPurchase(
124         address indexed customerAddress,
125         uint256 incomingEthereum,
126         uint256 tokensMinted,
127         address indexed referredBy
128     );
129 
130     event onTokenSell(
131         address indexed customerAddress,
132         uint256 tokensBurned,
133         uint256 ethereumEarned
134     );
135 
136     event onReinvestment(
137         address indexed customerAddress,
138         uint256 ethereumReinvested,
139         uint256 tokensMinted
140     );
141 
142     event onWithdraw(
143         address indexed customerAddress,
144         uint256 ethereumWithdrawn
145     );
146 
147     // ERC20
148     event Transfer(
149         address indexed from,
150         address indexed to,
151         uint256 tokens
152     );
153 
154 
155     /*=====================================
156     =            CONFIGURABLES            =
157     =====================================*/
158     string public name = "DailyRoi";
159     string public symbol = "DROI";
160     uint8 constant public decimals = 18;
161     uint8 constant internal dividendFee_ = 20; // 20% dividend fee on each buy and sell
162     uint8 constant internal fundFee_ = 2; // 2% investment fund fee on each buy and sell
163     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
164     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
165     uint256 constant internal magnitude = 2**64;
166 
167     // Address to send the 2% Fee
168     //  TO DAILY ROI
169     // https://etherscan.io/address/0x9F0a1bcD44f522318900e70A2617C0056378BB2D
170     address constant public giveEthFundAddress = 0x9F0a1bcD44f522318900e70A2617C0056378BB2D;
171     uint256 public totalEthFundRecieved; // total ETH charity recieved from this contract
172     uint256 public totalEthFundCollected; // total ETH charity collected in this contract
173 
174     // proof of stake (defaults at 100 tokens)
175     uint256 public stakingRequirement = 25e18;
176 
177     // ambassador program
178     mapping(address => bool) internal ambassadors_;
179     uint256 constant internal ambassadorMaxPurchase_ = 0.5 ether;
180     uint256 constant internal ambassadorQuota_ = 5 ether;
181 
182 
183 
184    /*================================
185     =            DATASETS            =
186     ================================*/
187     // amount of shares for each address (scaled number)
188     mapping(address => uint256) internal tokenBalanceLedger_;
189     mapping(address => uint256) internal referralBalance_;
190     mapping(address => int256) internal payoutsTo_;
191     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
192     uint256 internal tokenSupply_ = 0;
193     uint256 internal profitPerShare_;
194 
195     // administrator list (see above on what they can do)
196     mapping(address => bool) public administrators;
197 
198     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
199     bool public onlyAmbassadors = true;
200 
201     // Special DailyRoi Platform control from scam game contracts on DailyRoi platform
202     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept DailyRoi tokens
203 
204     mapping(address => address) public stickyRef;
205 
206     /*=======================================
207     =            PUBLIC FUNCTIONS            =
208     =======================================*/
209     /*
210     * -- APPLICATION ENTRY POINTS --
211     */
212     function DailyRoi()
213         public
214     {
215         // add administrators here
216         administrators[0x091cC8008d52B2e81cE2350F52254c77032366bD] = true;
217 
218         // add the ambassadors here - Tokens will be distributed to these addresses from main premine
219         ambassadors_[0x091cC8008d52B2e81cE2350F52254c77032366bD] = true;
220         // add the ambassadors here - Tokens will be distributed to these addresses from main premine
221         ambassadors_[0x8b24A3bD6924e63E5fd28e9A7AF2dc872E1c1BAF] = true;
222        // add the ambassadors here - Tokens will be distributed to these addresses from main premine
223         ambassadors_[0xd6370e84d792Fb9ef65BB8D8D57A2A0c1Cd0206d] = true;
224         // add the ambassadors here - Tokens will be distributed to these addresses from main premine
225         ambassadors_[0x566A42661757b09feac47ffC4f7D0723ce37701a] = true;
226         // add the ambassadors here - Tokens will be distributed to these addresses from main premine
227         ambassadors_[0x0C0dF6e58e5F7865b8137a7Fb663E7DCD5672995] = true;
228         // add the ambassadors here - Tokens will be distributed to these addresses from main premine
229         ambassadors_[0xf84B08cC9f14D682aBe6017ADbA3b1a4071b9C81] = true;
230         // add the ambassadors here - Tokens will be distributed to these addresses from main premine
231         ambassadors_[0xEafE863757a2b2a2c5C3f71988b7D59329d09A78] = true;
232         // add the ambassadors here - Tokens will be distributed to these addresses from main premine
233         ambassadors_[0xa683C1b815997a7Fa38f6178c84675FC4c79AC2B] = true;
234     }
235 
236 
237     /**
238      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
239      */
240     function buy(address _referredBy)
241         public
242         payable
243         returns(uint256)
244     {
245 
246         require(tx.gasprice <= 0.212 szabo);
247         purchaseInternal(msg.value, _referredBy);
248     }
249 
250     /**
251      * Fallback function to handle ethereum that was send straight to the contract
252      * Unfortunately we cannot use a referral address this way.
253      */
254     function()
255         payable
256         public
257     {
258 
259         require(tx.gasprice <= 0.212 szabo);
260         purchaseInternal(msg.value, 0x0);
261     }
262 
263     /**
264      * Sends FUND money to  DailyRoi
265      * The address is here https://etherscan.io/address/0x9F0a1bcD44f522318900e70A2617C0056378BB2D
266      */
267     function payFund() payable public {
268       uint256 ethToPay = SafeMath.sub(totalEthFundCollected, totalEthFundRecieved);
269       require(ethToPay > 1);
270       totalEthFundRecieved = SafeMath.add(totalEthFundRecieved, ethToPay);
271       if(!giveEthFundAddress.call.value(ethToPay).gas(400000)()) {
272          totalEthFundRecieved = SafeMath.sub(totalEthFundRecieved, ethToPay);
273       }
274     }
275 
276     /**
277      * Converts all of caller's dividends to tokens.
278      */
279     function reinvest()
280         onlyStronghands()
281         public
282     {
283         // fetch dividends
284         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
285 
286         // pay out the dividends virtually
287         address _customerAddress = msg.sender;
288         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
289 
290         // retrieve ref. bonus
291         _dividends += referralBalance_[_customerAddress];
292         referralBalance_[_customerAddress] = 0;
293 
294         // dispatch a buy order with the virtualized "withdrawn dividends"
295         uint256 _tokens = purchaseTokens(_dividends, 0x0);
296 
297         // fire event
298         onReinvestment(_customerAddress, _dividends, _tokens);
299     }
300 
301     /**
302      * Alias of sell() and withdraw().
303      */
304     function exit()
305         public
306     {
307         // get token count for caller & sell them all
308         address _customerAddress = msg.sender;
309         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
310         if(_tokens > 0) sell(_tokens);
311 
312         // lambo delivery service
313         withdraw();
314     }
315 
316     /**
317      * Withdraws all of the callers earnings.
318      */
319     function withdraw()
320         onlyStronghands()
321         public
322     {
323         // setup data
324         address _customerAddress = msg.sender;
325         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
326 
327         // update dividend tracker
328         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
329 
330         // add ref. bonus
331         _dividends += referralBalance_[_customerAddress];
332         referralBalance_[_customerAddress] = 0;
333 
334         // lambo delivery service
335         _customerAddress.transfer(_dividends);
336 
337         // fire event
338         onWithdraw(_customerAddress, _dividends);
339     }
340 
341     /**
342      * Liquifies tokens to ethereum.
343      */
344     function sell(uint256 _amountOfTokens)
345         onlyBagholders()
346         public
347     {
348         // setup data
349         address _customerAddress = msg.sender;
350         // russian hackers BTFO
351         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
352         uint256 _tokens = _amountOfTokens;
353         uint256 _ethereum = tokensToEthereum_(_tokens);
354 
355         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
356         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
357         uint256 _refPayout = _dividends / 3;
358         _dividends = SafeMath.sub(_dividends, _refPayout);
359         (_dividends,) = handleRef(stickyRef[msg.sender], _refPayout, _dividends, 0);
360 
361         // Take out dividends and then _fundPayout
362         uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
363 
364         // Add ethereum to send to fund
365         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
366 
367         // burn the sold tokens
368         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
369         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
370 
371         // update dividends tracker
372         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
373         payoutsTo_[_customerAddress] -= _updatedPayouts;
374 
375         // dividing by zero is a bad idea
376         if (tokenSupply_ > 0) {
377             // update the amount of dividends per token
378             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
379         }
380 
381         // fire event
382         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
383     }
384 
385 
386     /**
387      * Transfer tokens from the caller to a new holder.
388      * REMEMBER THIS IS 0% TRANSFER FEE
389      */
390     function transfer(address _toAddress, uint256 _amountOfTokens)
391         onlyBagholders()
392         public
393         returns(bool)
394     {
395         // setup
396         address _customerAddress = msg.sender;
397 
398         // make sure we have the requested tokens
399         // also disables transfers until ambassador phase is over
400         // ( we dont want whale premines )
401         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
402 
403         // withdraw all outstanding dividends first
404         if(myDividends(true) > 0) withdraw();
405 
406         // exchange tokens
407         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
408         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
409 
410         // update dividend trackers
411         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
412         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
413 
414 
415         // fire event
416         Transfer(_customerAddress, _toAddress, _amountOfTokens);
417 
418         // ERC20
419         return true;
420     }
421 
422     /**
423     * Transfer token to a specified address and forward the data to recipient
424     * ERC-677 standard
425     * https://github.com/ethereum/EIPs/issues/677
426     * @param _to    Receiver address.
427     * @param _value Amount of tokens that will be transferred.
428     * @param _data  Transaction metadata.
429     */
430     function transferAndCall(address _to, uint256 _value, bytes _data) external returns (bool) {
431       require(_to != address(0));
432       require(canAcceptTokens_[_to] == true); // security check that contract approved by DailyRoi platform
433       require(transfer(_to, _value)); // do a normal token transfer to the contract
434 
435       if (isContract(_to)) {
436         AcceptsDailyRoi receiver = AcceptsDailyRoi(_to);
437         require(receiver.tokenFallback(msg.sender, _value, _data));
438       }
439 
440       return true;
441     }
442 
443     /**
444      * Additional check that the game address we are sending tokens to is a contract
445      * assemble the given address bytecode. If bytecode exists then the _addr is a contract.
446      */
447      function isContract(address _addr) private constant returns (bool is_contract) {
448        // retrieve the size of the code on target address, this needs assembly
449        uint length;
450        assembly { length := extcodesize(_addr) }
451        return length > 0;
452      }
453 
454     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
455     /**
456      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
457      */
458     //function disableInitialStage()
459     //    onlyAdministrator()
460     //    public
461     //{
462     //    onlyAmbassadors = false;
463     //}
464 
465     /**
466      * In case one of us dies, we need to replace ourselves.
467      */
468     function setAdministrator(address _identifier, bool _status)
469         onlyAdministrator()
470         public
471     {
472         administrators[_identifier] = _status;
473     }
474 
475     /**
476      * Precautionary measures in case we need to adjust the masternode rate.
477      */
478     function setStakingRequirement(uint256 _amountOfTokens)
479         onlyAdministrator()
480         public
481     {
482         stakingRequirement = _amountOfTokens;
483     }
484 
485     /**
486      * Add or remove game contract, which can accept DailyRoi tokens
487      */
488     function setCanAcceptTokens(address _address, bool _value)
489       onlyAdministrator()
490       public
491     {
492       canAcceptTokens_[_address] = _value;
493     }
494 
495     /**
496      * If we want to rebrand, we can.
497      */
498     function setName(string _name)
499         onlyAdministrator()
500         public
501     {
502         name = _name;
503     }
504 
505     /**
506      * If we want to rebrand, we can.
507      */
508     function setSymbol(string _symbol)
509         onlyAdministrator()
510         public
511     {
512         symbol = _symbol;
513     }
514 
515 
516     /*----------  HELPERS AND CALCULATORS  ----------*/
517     /**
518      * Method to view the current Ethereum stored in the contract
519      * Example: totalEthereumBalance()
520      */
521     function totalEthereumBalance()
522         public
523         view
524         returns(uint)
525     {
526         return this.balance;
527     }
528 
529     /**
530      * Retrieve the total token supply.
531      */
532     function totalSupply()
533         public
534         view
535         returns(uint256)
536     {
537         return tokenSupply_;
538     }
539 
540     /**
541      * Retrieve the tokens owned by the caller.
542      */
543     function myTokens()
544         public
545         view
546         returns(uint256)
547     {
548         address _customerAddress = msg.sender;
549         return balanceOf(_customerAddress);
550     }
551 
552     /**
553      * Retrieve the dividends owned by the caller.
554      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
555      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
556      * But in the internal calculations, we want them separate.
557      */
558     function myDividends(bool _includeReferralBonus)
559         public
560         view
561         returns(uint256)
562     {
563         address _customerAddress = msg.sender;
564         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
565     }
566 
567     /**
568      * Retrieve the token balance of any single address.
569      */
570     function balanceOf(address _customerAddress)
571         view
572         public
573         returns(uint256)
574     {
575         return tokenBalanceLedger_[_customerAddress];
576     }
577 
578     /**
579      * Retrieve the dividend balance of any single address.
580      */
581     function dividendsOf(address _customerAddress)
582         view
583         public
584         returns(uint256)
585     {
586         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
587     }
588 
589     /**
590      * Return the buy price of 1 individual token.
591      */
592     function sellPrice()
593         public
594         view
595         returns(uint256)
596     {
597         // our calculation relies on the token supply, so we need supply. Doh.
598         if(tokenSupply_ == 0){
599             return tokenPriceInitial_ - tokenPriceIncremental_;
600         } else {
601             uint256 _ethereum = tokensToEthereum_(1e18);
602             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
603             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
604             uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
605             return _taxedEthereum;
606         }
607     }
608 
609     /**
610      * Return the sell price of 1 individual token.
611      */
612     function buyPrice()
613         public
614         view
615         returns(uint256)
616     {
617         // our calculation relies on the token supply, so we need supply. Doh.
618         if(tokenSupply_ == 0){
619             return tokenPriceInitial_ + tokenPriceIncremental_;
620         } else {
621             uint256 _ethereum = tokensToEthereum_(1e18);
622             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
623             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
624             uint256 _taxedEthereum =  SafeMath.add(SafeMath.add(_ethereum, _dividends), _fundPayout);
625             return _taxedEthereum;
626         }
627     }
628 
629     /**
630      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
631      */
632     function calculateTokensReceived(uint256 _ethereumToSpend)
633         public
634         view
635         returns(uint256)
636     {
637         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, dividendFee_), 100);
638         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereumToSpend, fundFee_), 100);
639         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereumToSpend, _dividends), _fundPayout);
640         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
641         return _amountOfTokens;
642     }
643 
644     /**
645      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
646      */
647     function calculateEthereumReceived(uint256 _tokensToSell)
648         public
649         view
650         returns(uint256)
651     {
652         require(_tokensToSell <= tokenSupply_);
653         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
654         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
655         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
656         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
657         return _taxedEthereum;
658     }
659 
660     /**
661      * Function for the frontend to show ether waiting to be send to fund in contract
662      */
663     function etherToSendFund()
664         public
665         view
666         returns(uint256) {
667         return SafeMath.sub(totalEthFundCollected, totalEthFundRecieved);
668     }
669 
670 
671     /*==========================================
672     =            INTERNAL FUNCTIONS            =
673     ==========================================*/
674 
675     // Make sure we will send back excess if user sends more then 5 ether before 100 ETH in contract
676     function purchaseInternal(uint256 _incomingEthereum, address _referredBy)
677       notContract()// no contracts allowed
678       internal
679       returns(uint256) {
680 
681       uint256 purchaseEthereum = _incomingEthereum;
682       uint256 excess;
683       if(purchaseEthereum > 5 ether) { // check if the transaction is over 5 ether
684           if (SafeMath.sub(address(this).balance, purchaseEthereum) <= 50 ether) { // if so check the contract is less then 100 ether
685               purchaseEthereum = 2.5 ether;
686               excess = SafeMath.sub(_incomingEthereum, purchaseEthereum);
687           }
688       }
689 
690       purchaseTokens(purchaseEthereum, _referredBy);
691 
692       if (excess > 0) {
693         msg.sender.transfer(excess);
694       }
695     }
696 
697     function handleRef(address _ref, uint _referralBonus, uint _currentDividends, uint _currentFee) internal returns (uint, uint){
698         uint _dividends = _currentDividends;
699         uint _fee = _currentFee;
700         address _referredBy = stickyRef[msg.sender];
701         if (_referredBy == address(0x0)){
702             _referredBy = _ref;
703         }
704         // is the user referred by a masternode?
705         if(
706             // is this a referred purchase?
707             _referredBy != 0x0000000000000000000000000000000000000000 &&
708 
709             // no cheating!
710             _referredBy != msg.sender &&
711 
712             // does the referrer have at least X whole tokens?
713             // i.e is the referrer a godly chad masternode
714             tokenBalanceLedger_[_referredBy] >= stakingRequirement
715         ){
716             // wealth redistribution
717             if (stickyRef[msg.sender] == address(0x0)){
718                 stickyRef[msg.sender] = _referredBy;
719             }
720             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus/2);
721             address currentRef = stickyRef[_referredBy];
722             if (currentRef != address(0x0) && tokenBalanceLedger_[currentRef] >= stakingRequirement){
723                 referralBalance_[currentRef] = SafeMath.add(referralBalance_[currentRef], (_referralBonus/10)*3);
724                 currentRef = stickyRef[currentRef];
725                 if (currentRef != address(0x0) && tokenBalanceLedger_[currentRef] >= stakingRequirement){
726                     referralBalance_[currentRef] = SafeMath.add(referralBalance_[currentRef], (_referralBonus/10)*2);
727                 }
728                 else{
729                     _dividends = SafeMath.add(_dividends, _referralBonus - _referralBonus/2 - (_referralBonus/10)*3);
730                     _fee = _dividends * magnitude;
731                 }
732             }
733             else{
734                 _dividends = SafeMath.add(_dividends, _referralBonus - _referralBonus/2);
735                 _fee = _dividends * magnitude;
736             }
737 
738 
739         } else {
740             // no ref purchase
741             // add the referral bonus back to the global dividends cake
742             _dividends = SafeMath.add(_dividends, _referralBonus);
743             _fee = _dividends * magnitude;
744         }
745         return (_dividends, _fee);
746     }
747 
748 
749     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
750         antiEarlyWhale(_incomingEthereum)
751         internal
752         returns(uint256)
753     {
754         // data setup
755         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);
756         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
757         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_incomingEthereum, fundFee_), 100);
758         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
759         uint256 _fee;
760         (_dividends, _fee) = handleRef(_referredBy, _referralBonus, _dividends, _fee);
761         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_incomingEthereum, _dividends), _fundPayout);
762         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
763 
764         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
765 
766 
767         // no point in continuing execution if OP is a poorfag russian hacker
768         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
769         // (or hackers)
770         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
771         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
772 
773 
774 
775         // we can't give people infinite ethereum
776         if(tokenSupply_ > 0){
777 
778             // add tokens to the pool
779             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
780 
781             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
782             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
783 
784             // calculate the amount of tokens the customer receives over his purchase
785             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
786 
787         } else {
788             // add tokens to the pool
789             tokenSupply_ = _amountOfTokens;
790         }
791 
792         // update circulating supply & the ledger address for the customer
793         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
794 
795         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
796         //really i know you think you do but you don't
797         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
798         payoutsTo_[msg.sender] += _updatedPayouts;
799 
800         // fire event
801         onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
802 
803         return _amountOfTokens;
804     }
805 
806     /**
807      * Calculate Token price based on an amount of incoming ethereum
808      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
809      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
810      */
811     function ethereumToTokens_(uint256 _ethereum)
812         internal
813         view
814         returns(uint256)
815     {
816         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
817         uint256 _tokensReceived =
818          (
819             (
820                 // underflow attempts BTFO
821                 SafeMath.sub(
822                     (sqrt
823                         (
824                             (_tokenPriceInitial**2)
825                             +
826                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
827                             +
828                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
829                             +
830                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
831                         )
832                     ), _tokenPriceInitial
833                 )
834             )/(tokenPriceIncremental_)
835         )-(tokenSupply_)
836         ;
837 
838         return _tokensReceived;
839     }
840 
841     /**
842      * Calculate token sell value.
843      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
844      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
845      */
846      function tokensToEthereum_(uint256 _tokens)
847         internal
848         view
849         returns(uint256)
850     {
851 
852         uint256 tokens_ = (_tokens + 1e18);
853         uint256 _tokenSupply = (tokenSupply_ + 1e18);
854         uint256 _etherReceived =
855         (
856             // underflow attempts BTFO
857             SafeMath.sub(
858                 (
859                     (
860                         (
861                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
862                         )-tokenPriceIncremental_
863                     )*(tokens_ - 1e18)
864                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
865             )
866         /1e18);
867         return _etherReceived;
868     }
869 
870 
871     //This is where all your gas goes, sorry
872     //Not sorry, you probably only paid 1 gwei
873     function sqrt(uint x) internal pure returns (uint y) {
874         uint z = (x + 1) / 2;
875         y = x;
876         while (z < y) {
877             y = z;
878             z = (x / z + z) / 2;
879         }
880     }
881 }
882 
883 /**
884  * @title SafeMath
885  * @dev Math operations with safety checks that throw on error
886  */
887 library SafeMath {
888 
889     /**
890     * @dev Multiplies two numbers, throws on overflow.
891     */
892     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
893         if (a == 0) {
894             return 0;
895         }
896         uint256 c = a * b;
897         assert(c / a == b);
898         return c;
899     }
900 
901     /**
902     * @dev Integer division of two numbers, truncating the quotient.
903     */
904     function div(uint256 a, uint256 b) internal pure returns (uint256) {
905         // assert(b > 0); // Solidity automatically throws when dividing by 0
906         uint256 c = a / b;
907         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
908         return c;
909     }
910 
911     /**
912     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
913     */
914     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
915         assert(b <= a);
916         return a - b;
917     }
918 
919     /**
920     * @dev Adds two numbers, throws on overflow.
921     */
922     function add(uint256 a, uint256 b) internal pure returns (uint256) {
923         uint256 c = a + b;
924         assert(c >= a);
925         return c;
926     }
927 }