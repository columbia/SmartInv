1 pragma solidity ^0.4.21;
2 
3 
4 /*
5 ******************** DailyDivs.com *********************
6 *
7 *  ____        _ _       ____  _                                
8 * |  _ \  __ _(_) |_   _|  _ \(_)_   _____   ___ ___  _ __ ___  
9 * | | | |/ _` | | | | | | | | | \ \ / / __| / __/ _ \| '_ ` _ \ 
10 * | |_| | (_| | | | |_| | |_| | |\ V /\__ \| (_| (_) | | | | | |
11 * |____/ \__,_|_|_|\__, |____/|_| \_/ |___(_)___\___/|_| |_| |_|
12 *                  |___/                                        
13 *
14 ******************** DailyDivs.com *********************
15 *
16 *
17 * [x] 0% TRANSFER FEES
18 * [x] 20% DIVIDENDS AND MASTERNODES
19 * [x] 5% FEE ON EACH BUY AND SELL GO TO Smart Contract Fund 0xd9092D94F74E6b5D408DBd3eCC88f3e5810d1e98
20 *     How 5% is divided and used: 
21 *     80% to Buy Tokens from the exchange to be transferred to DDT Surplus and fund other DailyDivs Games
22 *     20% to Dev Fund For Platform Development
23 * [x] Only 1 DDT Token is needed to have a masternode! This allows virtually anyone to earn via buys from their masternode!
24 * [x] DailyDivs Token can be used for future games
25 *
26 * Official Website: https://dailydivs.com/ 
27 * Official Discord: https://discord.gg/J4Bvu32
28 * Official Telegram: https://t.me/dailydivs
29 */
30 
31 
32 /**
33  * Definition of contract accepting DailyDivs tokens
34  * DDT Lending and other games can reuse this contract to support DailyDivs tokens
35  */
36 contract AcceptsDailyDivs {
37     DailyDivs public tokenContract;
38 
39     function AcceptsDailyDivs(address _tokenContract) public {
40         tokenContract = DailyDivs(_tokenContract);
41     }
42 
43     modifier onlyTokenContract {
44         require(msg.sender == address(tokenContract));
45         _;
46     }
47 
48     /**
49     * @dev Standard ERC677 function that will handle incoming token transfers.
50     *
51     * @param _from  Token sender address.
52     * @param _value Amount of tokens.
53     * @param _data  Transaction metadata.
54     */
55     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
56 }
57 
58 
59 contract DailyDivs {
60     /*=================================
61     =            MODIFIERS            =
62     =================================*/
63     // only people with tokens
64     modifier onlyBagholders() {
65         require(myTokens() > 0);
66         _;
67     }
68 
69     // only people with profits
70     modifier onlyStronghands() {
71         require(myDividends(true) > 0);
72         _;
73     }
74 
75     modifier notContract() {
76       require (msg.sender == tx.origin);
77       _;
78     }
79 
80     // administrators can:
81     // -> change the name of the contract
82     // -> change the name of the token
83     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
84     // they CANNOT:
85     // -> take funds
86     // -> disable withdrawals
87     // -> kill the contract
88     // -> change the price of tokens
89     modifier onlyAdministrator(){
90         address _customerAddress = msg.sender;
91         require(administrators[_customerAddress]);
92         _;
93     }
94     
95     uint ACTIVATION_TIME = 1538938800;
96 
97 
98     // ensures that the first tokens in the contract will be equally distributed
99     // meaning, no divine dump will be ever possible
100     // result: healthy longevity.
101     modifier antiEarlyWhale(uint256 _amountOfEthereum){
102         address _customerAddress = msg.sender;
103         
104         if (now >= ACTIVATION_TIME) {
105             onlyAmbassadors = false;
106         }
107 
108         // are we still in the vulnerable phase?
109         // if so, enact anti early whale protocol
110         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
111             require(
112                 // is the customer in the ambassador list?
113                 ambassadors_[_customerAddress] == true &&
114 
115                 // does the customer purchase exceed the max ambassador quota?
116                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
117 
118             );
119 
120             // updated the accumulated quota
121             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
122 
123             // execute
124             _;
125         } else {
126             // in case the ether count drops low, the ambassador phase won't reinitiate
127             onlyAmbassadors = false;
128             _;
129         }
130 
131     }
132 
133     /*==============================
134     =            EVENTS            =
135     ==============================*/
136     event onTokenPurchase(
137         address indexed customerAddress,
138         uint256 incomingEthereum,
139         uint256 tokensMinted,
140         address indexed referredBy
141     );
142 
143     event onTokenSell(
144         address indexed customerAddress,
145         uint256 tokensBurned,
146         uint256 ethereumEarned
147     );
148 
149     event onReinvestment(
150         address indexed customerAddress,
151         uint256 ethereumReinvested,
152         uint256 tokensMinted
153     );
154 
155     event onWithdraw(
156         address indexed customerAddress,
157         uint256 ethereumWithdrawn
158     );
159 
160     // ERC20
161     event Transfer(
162         address indexed from,
163         address indexed to,
164         uint256 tokens
165     );
166 
167 
168     /*=====================================
169     =            CONFIGURABLES            =
170     =====================================*/
171     string public name = "DailyDivs";
172     string public symbol = "DDT";
173     uint8 constant public decimals = 18;
174     uint8 constant internal dividendFee_ = 20; // 20% dividend fee on each buy and sell
175     uint8 constant internal fundFee_ = 5; // 5% fund tax on buys/sells/reinvest (split 80/20)
176     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
177     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
178     uint256 constant internal magnitude = 2**64;
179 
180     
181     // 80/20 FUND TAX CONTRACT ADDRESS
182     address constant public giveEthFundAddress = 0xd9092D94F74E6b5D408DBd3eCC88f3e5810d1e98;
183     uint256 public totalEthFundRecieved; // total ETH FUND recieved from this contract
184     uint256 public totalEthFundCollected; // total ETH FUND collected in this contract
185 
186     // proof of stake (defaults at 100 tokens)
187     uint256 public stakingRequirement = 1e18;
188 
189     // ambassador program
190     mapping(address => bool) internal ambassadors_;
191     uint256 constant internal ambassadorMaxPurchase_ = 8 ether;
192     uint256 constant internal ambassadorQuota_ = 8 ether;
193 
194 
195 
196    /*================================
197     =            DATASETS            =
198     ================================*/
199     // amount of shares for each address (scaled number)
200     mapping(address => uint256) internal tokenBalanceLedger_;
201     mapping(address => uint256) internal referralBalance_;
202     mapping(address => int256) internal payoutsTo_;
203     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
204     uint256 internal tokenSupply_ = 0;
205     uint256 internal profitPerShare_;
206 
207     // administrator list (see above on what they can do)
208     mapping(address => bool) public administrators;
209 
210     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
211     bool public onlyAmbassadors = true;
212 
213     // Special DailyDivs Platform control from scam game contracts on DailyDivs platform
214     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept DailyDivs tokens
215 
216 
217 
218     /*=======================================
219     =            PUBLIC FUNCTIONS            =
220     =======================================*/
221     /*
222     * -- APPLICATION ENTRY POINTS --
223     */
224     function DailyDivs()
225         public
226     {
227         // add administrators here
228         administrators[0x0E7b52B895E3322eF341004DC6CB5C63e1d9b1c5] = true;
229         
230         // admin
231         ambassadors_[0x0E7b52B895E3322eF341004DC6CB5C63e1d9b1c5] = true;
232 
233         // add the ambassadors
234         ambassadors_[0x4A42500b817439cF9B10b4d3edf68bb63Ed0A89B] = true;
235         
236         // add the ambassadors
237         ambassadors_[0x642e0ce9ae8c0d8007e0acaf82c8d716ff8c74c1] = true;
238         
239         // add the ambassadors
240         ambassadors_[0xeafe863757a2b2a2c5c3f71988b7d59329d09a78] = true;
241         
242         // add the ambassadors
243         ambassadors_[0x03B434e2dC43184538ED148f71c097b54f87EBBd] = true;
244         
245         // add the ambassadors
246         ambassadors_[0x8f1A667590014BF2e78b88EB112970F9E3E340E5] = true;
247         
248         // add the ambassadors
249         ambassadors_[0x6CF441B689683D3049f11B02c001E14bd0d86421] = true;
250         
251         // add the ambassadors
252             ambassadors_[0xa39334D8363d6aAF50372313efaa4cF8bDD50a30] = true;
253         
254         // add the ambassadors
255         ambassadors_[0xEc31176d4df0509115abC8065A8a3F8275aafF2b] = true;
256         
257         
258         
259         
260         
261     }
262 
263 
264     /**
265      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
266      */
267     function buy(address _referredBy)
268         public
269         payable
270         returns(uint256)
271     {
272         
273         require(tx.gasprice <= 0.05 szabo);
274         purchaseInternal(msg.value, _referredBy);
275     }
276 
277     /**
278      * Fallback function to handle ethereum that was send straight to the contract
279      * Unfortunately we cannot use a referral address this way.
280      */
281     function()
282         payable
283         public
284     {
285         
286         require(tx.gasprice <= 0.01 szabo);
287         purchaseInternal(msg.value, 0x0);
288     }
289 
290     /**
291      * Sends FUND TAX to the FUND TAX addres. (Remember 80% of the Fund is used to support DDT Lending and other platform games)
292      * This is the FUND TAX address that splits the ETH (80/20): https://etherscan.io/address/0xd9092D94F74E6b5D408DBd3eCC88f3e5810d1e98
293      */
294     function payFund() payable public {
295       uint256 ethToPay = SafeMath.sub(totalEthFundCollected, totalEthFundRecieved);
296       require(ethToPay > 1);
297       totalEthFundRecieved = SafeMath.add(totalEthFundRecieved, ethToPay);
298       if(!giveEthFundAddress.call.value(ethToPay).gas(400000)()) {
299          totalEthFundRecieved = SafeMath.sub(totalEthFundRecieved, ethToPay);
300       }
301     }
302 
303     /**
304      * Converts all of caller's dividends to tokens.
305      */
306     function reinvest()
307         onlyStronghands()
308         public
309     {
310         // fetch dividends
311         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
312 
313         // pay out the dividends virtually
314         address _customerAddress = msg.sender;
315         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
316 
317         // retrieve ref. bonus
318         _dividends += referralBalance_[_customerAddress];
319         referralBalance_[_customerAddress] = 0;
320 
321         // dispatch a buy order with the virtualized "withdrawn dividends"
322         uint256 _tokens = purchaseTokens(_dividends, 0x0);
323 
324         // fire event
325         onReinvestment(_customerAddress, _dividends, _tokens);
326     }
327 
328     /**
329      * Alias of sell() and withdraw().
330      */
331     function exit()
332         public
333     {
334         // get token count for caller & sell them all
335         address _customerAddress = msg.sender;
336         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
337         if(_tokens > 0) sell(_tokens);
338 
339         // lambo delivery service
340         withdraw();
341     }
342 
343     /**
344      * Withdraws all of the callers earnings.
345      */
346     function withdraw()
347         onlyStronghands()
348         public
349     {
350         // setup data
351         address _customerAddress = msg.sender;
352         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
353 
354         // update dividend tracker
355         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
356 
357         // add ref. bonus
358         _dividends += referralBalance_[_customerAddress];
359         referralBalance_[_customerAddress] = 0;
360 
361         // lambo delivery service
362         _customerAddress.transfer(_dividends);
363 
364         // fire event
365         onWithdraw(_customerAddress, _dividends);
366     }
367 
368     /**
369      * Liquifies tokens to ethereum.
370      */
371     function sell(uint256 _amountOfTokens)
372         onlyBagholders()
373         public
374     {
375         // setup data
376         address _customerAddress = msg.sender;
377         // russian hackers BTFO
378         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
379         uint256 _tokens = _amountOfTokens;
380         uint256 _ethereum = tokensToEthereum_(_tokens);
381 
382         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
383         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
384 
385         // Take out dividends and then _fundPayout
386         uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
387 
388         // Add ethereum to send to Fund Tax Contract
389         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
390 
391         // burn the sold tokens
392         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
393         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
394 
395         // update dividends tracker
396         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
397         payoutsTo_[_customerAddress] -= _updatedPayouts;
398 
399         // dividing by zero is a bad idea
400         if (tokenSupply_ > 0) {
401             // update the amount of dividends per token
402             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
403         }
404 
405         // fire event
406         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
407     }
408 
409 
410     /**
411      * Transfer tokens from the caller to a new holder.
412      * REMEMBER THIS IS 0% TRANSFER FEE
413      */
414     function transfer(address _toAddress, uint256 _amountOfTokens)
415         onlyBagholders()
416         public
417         returns(bool)
418     {
419         // setup
420         address _customerAddress = msg.sender;
421 
422         // make sure we have the requested tokens
423         // also disables transfers until ambassador phase is over
424         // ( we dont want whale premines )
425         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
426 
427         // withdraw all outstanding dividends first
428         if(myDividends(true) > 0) withdraw();
429 
430         // exchange tokens
431         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
432         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
433 
434         // update dividend trackers
435         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
436         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
437 
438 
439         // fire event
440         Transfer(_customerAddress, _toAddress, _amountOfTokens);
441 
442         // ERC20
443         return true;
444     }
445 
446     /**
447     * Transfer token to a specified address and forward the data to recipient
448     * ERC-677 standard
449     * https://github.com/ethereum/EIPs/issues/677
450     * @param _to    Receiver address.
451     * @param _value Amount of tokens that will be transferred.
452     * @param _data  Transaction metadata.
453     */
454     function transferAndCall(address _to, uint256 _value, bytes _data) external returns (bool) {
455       require(_to != address(0));
456       require(canAcceptTokens_[_to] == true); // security check that contract approved by DailyDivs platform
457       require(transfer(_to, _value)); // do a normal token transfer to the contract
458 
459       if (isContract(_to)) {
460         AcceptsDailyDivs receiver = AcceptsDailyDivs(_to);
461         require(receiver.tokenFallback(msg.sender, _value, _data));
462       }
463 
464       return true;
465     }
466 
467     /**
468      * Additional check that the game address we are sending tokens to is a contract
469      * assemble the given address bytecode. If bytecode exists then the _addr is a contract.
470      */
471      function isContract(address _addr) private constant returns (bool is_contract) {
472        // retrieve the size of the code on target address, this needs assembly
473        uint length;
474        assembly { length := extcodesize(_addr) }
475        return length > 0;
476      }
477 
478     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
479     /**
480      * In case the ambassador quota is not met, the administrator can manually disable the ambassador phase.
481      */
482     //function disableInitialStage()
483     //    onlyAdministrator()
484     //    public
485     //{
486     //    onlyAmbassadors = false;
487     //}
488 
489     /**
490      * In case one of us dies, we need to replace ourselves.
491      */
492     function setAdministrator(address _identifier, bool _status)
493         onlyAdministrator()
494         public
495     {
496         administrators[_identifier] = _status;
497     }
498 
499     /**
500      * Precautionary measures in case we need to adjust the masternode rate.
501      */
502     function setStakingRequirement(uint256 _amountOfTokens)
503         onlyAdministrator()
504         public
505     {
506         stakingRequirement = _amountOfTokens;
507     }
508 
509     /**
510      * Add or remove game contract, which can accept DailyDivs tokens
511      */
512     function setCanAcceptTokens(address _address, bool _value)
513       onlyAdministrator()
514       public
515     {
516       canAcceptTokens_[_address] = _value;
517     }
518 
519     /**
520      * If we want to rebrand, we can.
521      */
522     function setName(string _name)
523         onlyAdministrator()
524         public
525     {
526         name = _name;
527     }
528 
529     /**
530      * If we want to rebrand, we can.
531      */
532     function setSymbol(string _symbol)
533         onlyAdministrator()
534         public
535     {
536         symbol = _symbol;
537     }
538 
539 
540     /*----------  HELPERS AND CALCULATORS  ----------*/
541     /**
542      * Method to view the current Ethereum stored in the contract
543      * Example: totalEthereumBalance()
544      */
545     function totalEthereumBalance()
546         public
547         view
548         returns(uint)
549     {
550         return this.balance;
551     }
552 
553     /**
554      * Retrieve the total token supply.
555      */
556     function totalSupply()
557         public
558         view
559         returns(uint256)
560     {
561         return tokenSupply_;
562     }
563 
564     /**
565      * Retrieve the tokens owned by the caller.
566      */
567     function myTokens()
568         public
569         view
570         returns(uint256)
571     {
572         address _customerAddress = msg.sender;
573         return balanceOf(_customerAddress);
574     }
575 
576     /**
577      * Retrieve the dividends owned by the caller.
578      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
579      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
580      * But in the internal calculations, we want them separate.
581      */
582     function myDividends(bool _includeReferralBonus)
583         public
584         view
585         returns(uint256)
586     {
587         address _customerAddress = msg.sender;
588         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
589     }
590 
591     /**
592      * Retrieve the token balance of any single address.
593      */
594     function balanceOf(address _customerAddress)
595         view
596         public
597         returns(uint256)
598     {
599         return tokenBalanceLedger_[_customerAddress];
600     }
601 
602     /**
603      * Retrieve the dividend balance of any single address.
604      */
605     function dividendsOf(address _customerAddress)
606         view
607         public
608         returns(uint256)
609     {
610         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
611     }
612 
613     /**
614      * Return the buy price of 1 individual token.
615      */
616     function sellPrice()
617         public
618         view
619         returns(uint256)
620     {
621         // our calculation relies on the token supply, so we need supply. Doh.
622         if(tokenSupply_ == 0){
623             return tokenPriceInitial_ - tokenPriceIncremental_;
624         } else {
625             uint256 _ethereum = tokensToEthereum_(1e18);
626             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
627             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
628             uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
629             return _taxedEthereum;
630         }
631     }
632 
633     /**
634      * Return the sell price of 1 individual token.
635      */
636     function buyPrice()
637         public
638         view
639         returns(uint256)
640     {
641         // our calculation relies on the token supply, so we need supply. Doh.
642         if(tokenSupply_ == 0){
643             return tokenPriceInitial_ + tokenPriceIncremental_;
644         } else {
645             uint256 _ethereum = tokensToEthereum_(1e18);
646             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
647             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
648             uint256 _taxedEthereum =  SafeMath.add(SafeMath.add(_ethereum, _dividends), _fundPayout);
649             return _taxedEthereum;
650         }
651     }
652 
653     /**
654      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
655      */
656     function calculateTokensReceived(uint256 _ethereumToSpend)
657         public
658         view
659         returns(uint256)
660     {
661         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, dividendFee_), 100);
662         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereumToSpend, fundFee_), 100);
663         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereumToSpend, _dividends), _fundPayout);
664         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
665         return _amountOfTokens;
666     }
667 
668     /**
669      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
670      */
671     function calculateEthereumReceived(uint256 _tokensToSell)
672         public
673         view
674         returns(uint256)
675     {
676         require(_tokensToSell <= tokenSupply_);
677         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
678         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
679         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
680         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
681         return _taxedEthereum;
682     }
683 
684     /**
685      * Function for the frontend to show ether waiting to be sent to Fund Contract from the exchange contract
686      */
687     function etherToSendFund()
688         public
689         view
690         returns(uint256) {
691         return SafeMath.sub(totalEthFundCollected, totalEthFundRecieved);
692     }
693 
694 
695     /*==========================================
696     =            INTERNAL FUNCTIONS            =
697     ==========================================*/
698 
699     // Make sure we will send back excess if user sends more then 2 ether before 200 ETH in contract
700     function purchaseInternal(uint256 _incomingEthereum, address _referredBy)
701       notContract()// no contracts allowed
702       internal
703       returns(uint256) {
704 
705       uint256 purchaseEthereum = _incomingEthereum;
706       uint256 excess;
707       if(purchaseEthereum > 2 ether) { // check if the transaction is over 2 ether
708           if (SafeMath.sub(address(this).balance, purchaseEthereum) <= 200 ether) { // if so check the contract is less then 200 ether
709               purchaseEthereum = 2 ether;
710               excess = SafeMath.sub(_incomingEthereum, purchaseEthereum);
711           }
712       }
713 
714       purchaseTokens(purchaseEthereum, _referredBy);
715 
716       if (excess > 0) {
717         msg.sender.transfer(excess);
718       }
719     }
720 
721 
722     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
723         antiEarlyWhale(_incomingEthereum)
724         internal
725         returns(uint256)
726     {
727         // data setup
728         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);
729         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
730         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_incomingEthereum, fundFee_), 100);
731         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
732         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_incomingEthereum, _undividedDividends), _fundPayout);
733 
734         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
735 
736         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
737         uint256 _fee = _dividends * magnitude;
738 
739         // no point in continuing execution if OP is a poorfag russian hacker
740         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
741         // (or hackers)
742         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
743         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
744 
745         // is the user referred by a masternode?
746         if(
747             // is this a referred purchase?
748             _referredBy != 0x0000000000000000000000000000000000000000 &&
749 
750             // no cheating!
751             _referredBy != msg.sender &&
752 
753             // does the referrer have at least X whole tokens?
754             // i.e is the referrer a godly chad masternode
755             tokenBalanceLedger_[_referredBy] >= stakingRequirement
756         ){
757             // wealth redistribution
758             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
759         } else {
760             // no ref purchase
761             // add the referral bonus back to the global dividends cake
762             _dividends = SafeMath.add(_dividends, _referralBonus);
763             _fee = _dividends * magnitude;
764         }
765 
766         // we can't give people infinite ethereum
767         if(tokenSupply_ > 0){
768 
769             // add tokens to the pool
770             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
771 
772             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
773             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
774 
775             // calculate the amount of tokens the customer receives over his purchase
776             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
777 
778         } else {
779             // add tokens to the pool
780             tokenSupply_ = _amountOfTokens;
781         }
782 
783         // update circulating supply & the ledger address for the customer
784         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
785 
786         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
787         //really i know you think you do but you don't
788         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
789         payoutsTo_[msg.sender] += _updatedPayouts;
790 
791         // fire event
792         onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
793 
794         return _amountOfTokens;
795     }
796 
797     /**
798      * Calculate Token price based on an amount of incoming ethereum
799      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
800      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
801      */
802     function ethereumToTokens_(uint256 _ethereum)
803         internal
804         view
805         returns(uint256)
806     {
807         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
808         uint256 _tokensReceived =
809          (
810             (
811                 // underflow attempts BTFO
812                 SafeMath.sub(
813                     (sqrt
814                         (
815                             (_tokenPriceInitial**2)
816                             +
817                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
818                             +
819                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
820                             +
821                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
822                         )
823                     ), _tokenPriceInitial
824                 )
825             )/(tokenPriceIncremental_)
826         )-(tokenSupply_)
827         ;
828 
829         return _tokensReceived;
830     }
831 
832     /**
833      * Calculate token sell value.
834      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
835      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
836      */
837      function tokensToEthereum_(uint256 _tokens)
838         internal
839         view
840         returns(uint256)
841     {
842 
843         uint256 tokens_ = (_tokens + 1e18);
844         uint256 _tokenSupply = (tokenSupply_ + 1e18);
845         uint256 _etherReceived =
846         (
847             // underflow attempts BTFO
848             SafeMath.sub(
849                 (
850                     (
851                         (
852                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
853                         )-tokenPriceIncremental_
854                     )*(tokens_ - 1e18)
855                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
856             )
857         /1e18);
858         return _etherReceived;
859     }
860 
861 
862     //This is where all your gas goes, sorry
863     //Not sorry, you probably only paid 1 gwei
864     function sqrt(uint x) internal pure returns (uint y) {
865         uint z = (x + 1) / 2;
866         y = x;
867         while (z < y) {
868             y = z;
869             z = (x / z + z) / 2;
870         }
871     }
872 }
873 
874 /**
875  * @title SafeMath
876  * @dev Math operations with safety checks that throw on error
877  */
878 library SafeMath {
879 
880     /**
881     * @dev Multiplies two numbers, throws on overflow.
882     */
883     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
884         if (a == 0) {
885             return 0;
886         }
887         uint256 c = a * b;
888         assert(c / a == b);
889         return c;
890     }
891 
892     /**
893     * @dev Integer division of two numbers, truncating the quotient.
894     */
895     function div(uint256 a, uint256 b) internal pure returns (uint256) {
896         // assert(b > 0); // Solidity automatically throws when dividing by 0
897         uint256 c = a / b;
898         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
899         return c;
900     }
901 
902     /**
903     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
904     */
905     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
906         assert(b <= a);
907         return a - b;
908     }
909 
910     /**
911     * @dev Adds two numbers, throws on overflow.
912     */
913     function add(uint256 a, uint256 b) internal pure returns (uint256) {
914         uint256 c = a + b;
915         assert(c >= a);
916         return c;
917     }
918 }