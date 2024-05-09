1 pragma solidity ^0.4.24;
2 
3 /*
4 ******************** https://mobstreet.me/exchange ********************
5 *
6 *
7 *       ███╗   ███╗ ██████╗ ██████╗                       
8 *       ████╗ ████║██╔═══██╗██╔══██╗                      
9 *       ██╔████╔██║██║   ██║██████╔╝                      
10 *       ██║╚██╔╝██║██║   ██║██╔══██╗                      
11 *       ██║ ╚═╝ ██║╚██████╔╝██████╔╝                      
12 *       ╚═╝     ╚═╝ ╚═════╝ ╚═════╝                       
13                                                   
14 *       ███████╗████████╗██████╗ ███████╗███████╗████████╗
15 *       ██╔════╝╚══██╔══╝██╔══██╗██╔════╝██╔════╝╚══██╔══╝
16 *       ███████╗   ██║   ██████╔╝█████╗  █████╗     ██║   
17 *       ╚════██║   ██║   ██╔══██╗██╔══╝  ██╔══╝     ██║   
18 *       ███████║   ██║   ██║  ██║███████╗███████╗   ██║   
19 *       ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   
20 *                                          
21 *   
22 ********************  https://mobstreet.me/exchange ********************
23 *
24 * [x] 25% Exchange fee (Divs + Dev + Referral)
25 * [x] 24% Dividends to all MOB token holders
26 * [x] 0% Account transfer fees
27 * [x] 1% To developers for future development costs (Address can also be updated in the future)
28 * [x] Dev Fund Address: 0x16837e8f7d7e88E2E5B5392bD637122F2e21594A
29 * [x] Multi-tier Masternode system for exchange buys and sells (3 levels)
30 * [x] Refferal approximate % breakdown (4% for 1st, 2.4% for 2nd, 1.6% 3rd)
31 * [x] MOB STREET (MOB) Tokens will and can be used for future games
32 *
33 * Official Website: https://mobstreet.me/
34 * Official Exchange: https://mobstreet.me/exchange
35 * Official Discord: https://discordapp.com/invite/
36 * Official Twitter: https://twitter.com/
37 * Official Telegram: https://t.me/
38 */
39 
40 
41 /**
42  * Definition of contract accepting MOB STREET (MOB) Tokens
43  * Games or any other innovative platforms can reuse this contract to support MOB STREET (MOB) Tokens
44  */
45 contract AcceptsMOB {
46     MOB public tokenContract;
47 
48     constructor(address _tokenContract) public {
49         tokenContract = MOB(_tokenContract);
50     }
51 
52     modifier onlyTokenContract {
53         require(msg.sender == address(tokenContract));
54         _;
55     }
56 
57     /**
58     * @dev Standard ERC677 function that will handle incoming token transfers.
59     *
60     * @param _from  Token sender address.
61     * @param _value Amount of tokens.
62     * @param _data  Transaction metadata.
63     */
64     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
65 }
66 
67 
68 contract MOB {
69     /*=================================
70     =            MODIFIERS            =
71     =================================*/
72     // only people with tokens
73     modifier onlyBagholders() {
74         require(myTokens() > 0);
75         _;
76     }
77 
78     // only people with profits
79     modifier onlyStronghands() {
80         require(myDividends(true) > 0);
81         _;
82     }
83 
84     modifier notContract() {
85       require (msg.sender == tx.origin);
86       _;
87     }
88 
89     // administrators can:
90     // -> change the name of the contract
91     // -> change the name of the token
92     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
93     // they CANNOT:
94     // -> take MOB
95     // -> disable withdrawals
96     // -> kill the contract
97     // -> change the price of tokens
98     modifier onlyAdministrator(){
99         address _customerAddress = msg.sender;
100         require(administrators[_customerAddress]);
101         _;
102     }
103     
104     uint ACTIVATION_TIME = 1537491600;
105 
106 
107     // ensures that the first tokens in the contract will be equally distributed
108     // meaning, no divine dump will be ever possible
109     // result: healthy longevity.
110     modifier antiEarlyWhale(uint256 _amountOfEthereum){
111         address _customerAddress = msg.sender;
112         
113         if (now >= ACTIVATION_TIME) {
114             onlyAmbassadors = false;
115         }
116 
117         // are we still in the vulnerable phase?
118         // if so, enact anti early whale protocol
119         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
120             require(
121                 // is the customer in the ambassador list?
122                 ambassadors_[_customerAddress] == true &&
123 
124                 // does the customer purchase exceed the max ambassador quota?
125                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
126 
127             );
128 
129             // updated the accumulated quota
130             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
131 
132             // execute
133             _;
134         } else {
135             // in case the ether count drops low, the ambassador phase won't reinitiate
136             onlyAmbassadors = false;
137             _;
138         }
139 
140     }
141 
142     /*==============================
143     =            EVENTS            =
144     ==============================*/
145     event onTokenPurchase(
146         address indexed customerAddress,
147         uint256 incomingEthereum,
148         uint256 tokensMinted,
149         address indexed referredBy
150     );
151 
152     event onTokenSell(
153         address indexed customerAddress,
154         uint256 tokensBurned,
155         uint256 ethereumEarned
156     );
157 
158     event onReinvestment(
159         address indexed customerAddress,
160         uint256 ethereumReinvested,
161         uint256 tokensMinted
162     );
163 
164     event onWithdraw(
165         address indexed customerAddress,
166         uint256 ethereumWithdrawn
167     );
168 
169     // ERC20
170     event Transfer(
171         address indexed from,
172         address indexed to,
173         uint256 tokens
174     );
175 
176 
177     /*=====================================
178     =            CONFIGURABLES            =
179     =====================================*/
180     string public name = "MOB";
181     string public symbol = "MOB";
182     uint8 constant public decimals = 18;
183     uint8 constant internal dividendFee_ = 24; // 24% dividend fee on each buy and sell
184     uint8 constant internal fundFee_ = 1; // 1% investment fund fee on each buy and sell
185 	uint256 constant internal tokenPriceInitial_ = 0.0000000001 ether;
186 	uint256 constant internal tokenPriceIncremental_ = 0.00000000001 ether;
187     uint256 constant internal magnitude = 2**64;
188 
189     // Address to send the 1% Fee
190     address public giveEthFundAddress = 0x16837e8f7d7e88E2E5B5392bD637122F2e21594A;
191     bool public finalizedEthFundAddress = false;
192     uint256 public totalEthFundRecieved; // total ETH charity recieved from this contract
193     uint256 public totalEthFundCollected; // total ETH charity collected in this contract
194 
195     // proof of stake (defaults at 100 tokens)
196     uint256 public stakingRequirement = 25e18;
197 
198     // ambassador program
199     mapping(address => bool) internal ambassadors_;
200     uint256 constant internal ambassadorMaxPurchase_ = 1.0 ether;
201     uint256 constant internal ambassadorQuota_ = 5.0 ether;
202 
203 
204 
205    /*================================
206     =            DATASETS            =
207     ================================*/
208     // amount of shares for each address (scaled number)
209     mapping(address => uint256) internal tokenBalanceLedger_;
210     mapping(address => uint256) internal referralBalance_;
211     mapping(address => int256) internal payoutsTo_;
212     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
213     uint256 internal tokenSupply_ = 0;
214     uint256 internal profitPerShare_;
215 
216     // administrator list (see above on what they can do)
217     mapping(address => bool) public administrators;
218 
219     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
220     bool public onlyAmbassadors = true;
221 
222     // Special MOB STREET Platform control from scam game contracts on MOB STREET platform
223     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept MOB STREET tokens
224 
225     mapping(address => address) public stickyRef;
226 
227     /*=======================================
228     =            PUBLIC FUNCTIONS            =
229     =======================================*/
230     /*
231     * -- APPLICATION ENTRY POINTS --
232     */
233     constructor()
234         public
235     {
236         // add administrators here
237         administrators[0xb2A13A5AE7922325290ce4eAf5029Ef18045Ee2B] = true;
238 
239 		// add the ambassadors here - Tokens will be distributed to these addresses from main premine
240         ambassadors_[0xb2A13A5AE7922325290ce4eAf5029Ef18045Ee2B] = true;
241         // add the ambassadors here - Tokens will be distributed to these addresses from main premine
242         ambassadors_[0x41FE3738B503cBaFD01C1Fd8DD66b7fE6Ec11b01] = true;
243         // add the ambassadors here - Tokens will be distributed to these addresses from main premine
244         ambassadors_[0xa37172d3803cd1366608dfea5efeec767a880a8b] = true;
245         // add the ambassadors here - Tokens will be distributed to these addresses from main premine
246         ambassadors_[0xea1e475a57Dd5417238f437Df3C654381E946Db1] = true;
247         // add the ambassadors here - Tokens will be distributed to these addresses from main premine
248         ambassadors_[0xd1692f1c6b50d299993363be1c869e3e64842732] = true;
249     }
250 
251 
252     /**
253      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
254      */
255     function buy(address _referredBy)
256         public
257         payable
258         returns(uint256)
259     {
260         
261         require(tx.gasprice <= 0.25 szabo);
262         purchaseTokens(msg.value, _referredBy);
263     }
264 
265     /**
266      * Fallback function to handle ethereum that was send straight to the contract
267      * Unfortunately we cannot use a referral address this way.
268      */
269     function()
270         payable
271         public
272     {
273         
274         require(tx.gasprice <= 0.25 szabo);
275         purchaseTokens(msg.value, 0x0);
276     }
277 
278     function updateFundAddress(address _newAddress)
279         onlyAdministrator()
280         public
281     {
282         require(finalizedEthFundAddress == false);
283         giveEthFundAddress = _newAddress;
284     }
285 
286     function finalizeFundAddress(address _finalAddress)
287         onlyAdministrator()
288         public
289     {
290         require(finalizedEthFundAddress == false);
291         giveEthFundAddress = _finalAddress;
292         finalizedEthFundAddress = true;
293     }
294 
295     /**
296      * Sends MOB money to the Dev Fee Contract
297      * The address is here https://etherscan.io/address/0x16837e8f7d7e88E2E5B5392bD637122F2e21594A
298      */
299     function payFund() payable public {
300         uint256 ethToPay = SafeMath.sub(totalEthFundCollected, totalEthFundRecieved);
301         require(ethToPay > 0);
302         totalEthFundRecieved = SafeMath.add(totalEthFundRecieved, ethToPay);
303         if(!giveEthFundAddress.call.value(ethToPay)()) {
304             revert();
305         }
306     }
307 
308     /**
309      * Converts all of caller's dividends to tokens.
310      */
311     function reinvest()
312         onlyStronghands()
313         public
314     {
315         // fetch dividends
316         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
317 
318         // pay out the dividends virtually
319         address _customerAddress = msg.sender;
320         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
321 
322         // retrieve ref. bonus
323         _dividends += referralBalance_[_customerAddress];
324         referralBalance_[_customerAddress] = 0;
325 
326         // dispatch a buy order with the virtualized "withdrawn dividends"
327         uint256 _tokens = purchaseTokens(_dividends, 0x0);
328 
329         // fire event
330         emit onReinvestment(_customerAddress, _dividends, _tokens);
331     }
332 
333     /**
334      * Alias of sell() and withdraw().
335      */
336     function exit()
337         public
338     {
339         // get token count for caller & sell them all
340         address _customerAddress = msg.sender;
341         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
342         if(_tokens > 0) sell(_tokens);
343 
344         // lambo delivery service
345         withdraw();
346     }
347 
348     /**
349      * Withdraws all of the callers earnings.
350      */
351     function withdraw()
352         onlyStronghands()
353         public
354     {
355         // setup data
356         address _customerAddress = msg.sender;
357         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
358 
359         // update dividend tracker
360         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
361 
362         // add ref. bonus
363         _dividends += referralBalance_[_customerAddress];
364         referralBalance_[_customerAddress] = 0;
365 
366         // lambo delivery service
367         _customerAddress.transfer(_dividends);
368 
369         // fire event
370         emit onWithdraw(_customerAddress, _dividends);
371     }
372 
373     /**
374      * Liquifies tokens to ethereum.
375      */
376     function sell(uint256 _amountOfTokens)
377         onlyBagholders()
378         public
379     {
380         // setup data
381         address _customerAddress = msg.sender;
382         // russian hackers BTFO
383         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
384         uint256 _tokens = _amountOfTokens;
385         uint256 _ethereum = tokensToEthereum_(_tokens);
386 
387         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
388         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
389         uint256 _refPayout = _dividends / 3;
390         _dividends = SafeMath.sub(_dividends, _refPayout);
391         (_dividends,) = handleRef(stickyRef[msg.sender], _refPayout, _dividends, 0);
392 
393         // Take out dividends and then _fundPayout
394         uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
395 
396         // Add ethereum to send to fund
397         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
398 
399         // burn the sold tokens
400         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
401         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
402 
403         // update dividends tracker
404         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
405         payoutsTo_[_customerAddress] -= _updatedPayouts;
406 
407         // dividing by zero is a bad idea
408         if (tokenSupply_ > 0) {
409             // update the amount of dividends per token
410             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
411         }
412 
413         // fire event
414         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
415     }
416 
417 
418     /**
419      * Transfer tokens from the caller to a new holder.
420      * REMEMBER THIS IS 0% TRANSFER FEE
421      */
422     function transfer(address _toAddress, uint256 _amountOfTokens)
423         onlyBagholders()
424         public
425         returns(bool)
426     {
427         // setup
428         address _customerAddress = msg.sender;
429 
430         // make sure we have the requested tokens
431         // also disables transfers until ambassador phase is over
432         // ( we dont want whale premines )
433         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
434 
435         // withdraw all outstanding dividends first
436         if(myDividends(true) > 0) withdraw();
437 
438         // exchange tokens
439         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
440         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
441 
442         // update dividend trackers
443         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
444         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
445 
446 
447         // fire event
448         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
449 
450         // ERC20
451         return true;
452     }
453 
454     /**
455     * Transfer token to a specified address and forward the data to recipient
456     * ERC-677 standard
457     * https://github.com/ethereum/EIPs/issues/677
458     * @param _to    Receiver address.
459     * @param _value Amount of tokens that will be transferred.
460     * @param _data  Transaction metadata.
461     */
462     function transferAndCall(address _to, uint256 _value, bytes _data) external returns (bool) {
463       require(_to != address(0));
464       require(canAcceptTokens_[_to] == true); // security check that contract approved by MOB STREET platform
465       require(transfer(_to, _value)); // do a normal token transfer to the contract
466 
467       if (isContract(_to)) {
468         AcceptsMOB receiver = AcceptsMOB(_to);
469         require(receiver.tokenFallback(msg.sender, _value, _data));
470       }
471 
472       return true;
473     }
474 
475     /**
476      * Additional check that the game address we are sending tokens to is a contract
477      * assemble the given address bytecode. If bytecode exists then the _addr is a contract.
478      */
479      function isContract(address _addr) private constant returns (bool is_contract) {
480        // retrieve the size of the code on target address, this needs assembly
481        uint length;
482        assembly { length := extcodesize(_addr) }
483        return length > 0;
484      }
485 
486     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
487     /**
488      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
489      */
490     //function disableInitialStage()
491     //    onlyAdministrator()
492     //    public
493     //{
494     //    onlyAmbassadors = false;
495     //}
496 
497     /**
498      * In case one of us dies, we need to replace ourselves.
499      */
500     function setAdministrator(address _identifier, bool _status)
501         onlyAdministrator()
502         public
503     {
504         administrators[_identifier] = _status;
505     }
506 
507     /**
508      * Precautionary measures in case we need to adjust the masternode rate.
509      */
510     function setStakingRequirement(uint256 _amountOfTokens)
511         onlyAdministrator()
512         public
513     {
514         stakingRequirement = _amountOfTokens;
515     }
516 
517     /**
518      * Add or remove game contract, which can accept MOB STREET (MOB) tokens
519      */
520     function setCanAcceptTokens(address _address, bool _value)
521       onlyAdministrator()
522       public
523     {
524       canAcceptTokens_[_address] = _value;
525     }
526 
527     /**
528      * If we want to rebrand, we can.
529      */
530     function setName(string _name)
531         onlyAdministrator()
532         public
533     {
534         name = _name;
535     }
536 
537     /**
538      * If we want to rebrand, we can.
539      */
540     function setSymbol(string _symbol)
541         onlyAdministrator()
542         public
543     {
544         symbol = _symbol;
545     }
546 
547 
548     /*----------  HELPERS AND CALCULATORS  ----------*/
549     /**
550      * Method to view the current Ethereum stored in the contract
551      * Example: totalEthereumBalance()
552      */
553     function totalEthereumBalance()
554         public
555         view
556         returns(uint)
557     {
558         return address(this).balance;
559     }
560 
561     /**
562      * Retrieve the total token supply.
563      */
564     function totalSupply()
565         public
566         view
567         returns(uint256)
568     {
569         return tokenSupply_;
570     }
571 
572     /**
573      * Retrieve the tokens owned by the caller.
574      */
575     function myTokens()
576         public
577         view
578         returns(uint256)
579     {
580         address _customerAddress = msg.sender;
581         return balanceOf(_customerAddress);
582     }
583 
584     /**
585      * Retrieve the dividends owned by the caller.
586      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
587      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
588      * But in the internal calculations, we want them separate.
589      */
590     function myDividends(bool _includeReferralBonus)
591         public
592         view
593         returns(uint256)
594     {
595         address _customerAddress = msg.sender;
596         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
597     }
598 
599     /**
600      * Retrieve the token balance of any single address.
601      */
602     function balanceOf(address _customerAddress)
603         view
604         public
605         returns(uint256)
606     {
607         return tokenBalanceLedger_[_customerAddress];
608     }
609 
610     /**
611      * Retrieve the dividend balance of any single address.
612      */
613     function dividendsOf(address _customerAddress)
614         view
615         public
616         returns(uint256)
617     {
618         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
619     }
620 
621     /**
622      * Return the buy price of 1 individual token.
623      */
624     function sellPrice()
625         public
626         view
627         returns(uint256)
628     {
629         // our calculation relies on the token supply, so we need supply. Doh.
630         if(tokenSupply_ == 0){
631             return tokenPriceInitial_ - tokenPriceIncremental_;
632         } else {
633             uint256 _ethereum = tokensToEthereum_(1e18);
634             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
635             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
636             uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
637             return _taxedEthereum;
638         }
639     }
640 
641     /**
642      * Return the sell price of 1 individual token.
643      */
644     function buyPrice()
645         public
646         view
647         returns(uint256)
648     {
649         // our calculation relies on the token supply, so we need supply. Doh.
650         if(tokenSupply_ == 0){
651             return tokenPriceInitial_ + tokenPriceIncremental_;
652         } else {
653             uint256 _ethereum = tokensToEthereum_(1e18);
654             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
655             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
656             uint256 _taxedEthereum =  SafeMath.add(SafeMath.add(_ethereum, _dividends), _fundPayout);
657             return _taxedEthereum;
658         }
659     }
660 
661     /**
662      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
663      */
664     function calculateTokensReceived(uint256 _ethereumToSpend)
665         public
666         view
667         returns(uint256)
668     {
669         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, dividendFee_), 100);
670         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereumToSpend, fundFee_), 100);
671         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereumToSpend, _dividends), _fundPayout);
672         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
673         return _amountOfTokens;
674     }
675 
676     /**
677      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
678      */
679     function calculateEthereumReceived(uint256 _tokensToSell)
680         public
681         view
682         returns(uint256)
683     {
684         require(_tokensToSell <= tokenSupply_);
685         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
686         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
687         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
688         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
689         return _taxedEthereum;
690     }
691 
692     /**
693      * Function for the frontend to show ether waiting to be send to fund in contract
694      */
695     function etherToSendFund()
696         public
697         view
698         returns(uint256) {
699         return SafeMath.sub(totalEthFundCollected, totalEthFundRecieved);
700     }
701 
702 
703     /*==========================================
704     =            INTERNAL FUNCTIONS            =
705     ==========================================*/
706 
707     // Make sure we will send back excess if user sends more then 5 ether before 100 ETH in contract
708     function purchaseInternal(uint256 _incomingEthereum, address _referredBy)
709       notContract()// no contracts allowed
710       internal
711       returns(uint256) {
712 
713       uint256 purchaseEthereum = _incomingEthereum;
714       uint256 excess;
715       if(purchaseEthereum > 2.5 ether) { // check if the transaction is over 2.5 ether
716           if (SafeMath.sub(address(this).balance, purchaseEthereum) <= 50 ether) { // if so check the contract is less then 50 ether
717               purchaseEthereum = 2.5 ether;
718               excess = SafeMath.sub(_incomingEthereum, purchaseEthereum);
719           }
720       }
721 
722       purchaseTokens(purchaseEthereum, _referredBy);
723 
724       if (excess > 0) {
725         msg.sender.transfer(excess);
726       }
727     }
728 
729     function handleRef(address _ref, uint _referralBonus, uint _currentDividends, uint _currentFee) internal returns (uint, uint){
730         uint _dividends = _currentDividends;
731         uint _fee = _currentFee;
732         address _referredBy = stickyRef[msg.sender];
733         if (_referredBy == address(0x0)){
734             _referredBy = _ref;
735         }
736         // is the user referred by a masternode?
737         if(
738             // is this a referred purchase?
739             _referredBy != 0x0000000000000000000000000000000000000000 &&
740 
741             // no cheating!
742             _referredBy != msg.sender &&
743 
744             // does the referrer have at least X whole tokens?
745             // i.e is the referrer a godly chad masternode
746             tokenBalanceLedger_[_referredBy] >= stakingRequirement
747         ){
748             // wealth redistribution
749             if (stickyRef[msg.sender] == address(0x0)){
750                 stickyRef[msg.sender] = _referredBy;
751             }
752             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus/2);
753             address currentRef = stickyRef[_referredBy];
754             if (currentRef != address(0x0) && tokenBalanceLedger_[currentRef] >= stakingRequirement){
755                 referralBalance_[currentRef] = SafeMath.add(referralBalance_[currentRef], (_referralBonus/10)*3);
756                 currentRef = stickyRef[currentRef];
757                 if (currentRef != address(0x0) && tokenBalanceLedger_[currentRef] >= stakingRequirement){
758                     referralBalance_[currentRef] = SafeMath.add(referralBalance_[currentRef], (_referralBonus/10)*2);
759                 }
760                 else{
761                     _dividends = SafeMath.add(_dividends, _referralBonus - _referralBonus/2 - (_referralBonus/10)*3);
762                     _fee = _dividends * magnitude;
763                 }
764             }
765             else{
766                 _dividends = SafeMath.add(_dividends, _referralBonus - _referralBonus/2);
767                 _fee = _dividends * magnitude;
768             }
769             
770             
771         } else {
772             // no ref purchase
773             // add the referral bonus back to the global dividends cake
774             _dividends = SafeMath.add(_dividends, _referralBonus);
775             _fee = _dividends * magnitude;
776         }
777         return (_dividends, _fee);
778     }
779 
780 
781     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
782         antiEarlyWhale(_incomingEthereum)
783         internal
784         returns(uint256)
785     {
786         // data setup
787         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);
788         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
789         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_incomingEthereum, fundFee_), 100);
790         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
791         uint256 _fee;
792         (_dividends, _fee) = handleRef(_referredBy, _referralBonus, _dividends, _fee);
793         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_incomingEthereum, _dividends), _fundPayout);
794         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
795 
796         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
797 
798 
799         // no point in continuing execution if OP is a poor russian hacker
800         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
801         // (or hackers)
802         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
803         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
804 
805 
806 
807         // we can't give people infinite ethereum
808         if(tokenSupply_ > 0){
809  
810             // add tokens to the pool
811             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
812 
813             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
814             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
815 
816             // calculate the amount of tokens the customer receives over his purchase
817             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
818 
819         } else {
820             // add tokens to the pool
821             tokenSupply_ = _amountOfTokens;
822         }
823 
824         // update circulating supply & the ledger address for the customer
825         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
826 
827         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
828         //really i know you think you do but you don't
829         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
830         payoutsTo_[msg.sender] += _updatedPayouts;
831 
832         // fire event
833         emit onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
834 
835         return _amountOfTokens;
836     }
837 
838     /**
839      * Calculate Token price based on an amount of incoming ethereum
840      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
841      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
842      */
843     function ethereumToTokens_(uint256 _ethereum)
844         internal
845         view
846         returns(uint256)
847     {
848         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
849         uint256 _tokensReceived =
850          (
851             (
852                 // underflow attempts BTFO
853                 SafeMath.sub(
854                     (sqrt
855                         (
856                             (_tokenPriceInitial**2)
857                             +
858                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
859                             +
860                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
861                             +
862                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
863                         )
864                     ), _tokenPriceInitial
865                 )
866             )/(tokenPriceIncremental_)
867         )-(tokenSupply_)
868         ;
869 
870         return _tokensReceived;
871     }
872 
873     /**
874      * Calculate token sell value.
875      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
876      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
877      */
878      function tokensToEthereum_(uint256 _tokens)
879         internal
880         view
881         returns(uint256)
882     {
883 
884         uint256 tokens_ = (_tokens + 1e18);
885         uint256 _tokenSupply = (tokenSupply_ + 1e18);
886         uint256 _etherReceived =
887         (
888             // underflow attempts BTFO
889             SafeMath.sub(
890                 (
891                     (
892                         (
893                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
894                         )-tokenPriceIncremental_
895                     )*(tokens_ - 1e18)
896                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
897             )
898         /1e18);
899         return _etherReceived;
900     }
901 
902 
903     //This is where all your gas goes, sorry
904     //Not sorry, you probably only paid 1 gwei
905     function sqrt(uint x) internal pure returns (uint y) {
906         uint z = (x + 1) / 2;
907         y = x;
908         while (z < y) {
909             y = z;
910             z = (x / z + z) / 2;
911         }
912     }
913 }
914 
915 /**
916  * @title SafeMath
917  * @dev Math operations with safety checks that throw on error
918  */
919 library SafeMath {
920 
921     /**
922     * @dev Multiplies two numbers, throws on overflow.
923     */
924     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
925         if (a == 0) {
926             return 0;
927         }
928         uint256 c = a * b;
929         assert(c / a == b);
930         return c;
931     }
932 
933     /**
934     * @dev Integer division of two numbers, truncating the quotient.
935     */
936     function div(uint256 a, uint256 b) internal pure returns (uint256) {
937         // assert(b > 0); // Solidity automatically throws when dividing by 0
938         uint256 c = a / b;
939         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
940         return c;
941     }
942 
943     /**
944     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
945     */
946     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
947         assert(b <= a);
948         return a - b;
949     }
950 
951     /**
952     * @dev Adds two numbers, throws on overflow.
953     */
954     function add(uint256 a, uint256 b) internal pure returns (uint256) {
955         uint256 c = a + b;
956         assert(c >= a);
957         return c;
958     }
959 }