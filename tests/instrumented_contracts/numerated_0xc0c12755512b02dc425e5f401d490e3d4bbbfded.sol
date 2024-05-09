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
18 * [x] 4% DIVIDENDS AND MASTERNODES
19 * [x] 1% FEE ON EACH BUY AND SELL GO TO Staking Fund 0x6758C48e9ABB42106D53936dDbC841bB44128cf9
20 
21 * [x] Only 1 DDT Token is needed to have a masternode! This allows virtually anyone to earn via buys from their masternode!
22 * [x] DailyDivs Token can be used for future games
23 *
24 * Official Website: https://dailydivs.com/ 
25 * Official Discord: https://discord.gg/J4Bvu32
26 * Official Telegram: https://t.me/dailydivs
27 */
28 
29 
30 /**
31  * Definition of contract accepting DailyDivs tokens
32  * DDT Lending and other games can reuse this contract to support DailyDivs tokens
33  */
34 contract AcceptsDailyDivs {
35     DailyDivs public tokenContract;
36 
37     function AcceptsDailyDivs(address _tokenContract) public {
38         tokenContract = DailyDivs(_tokenContract);
39     }
40 
41     modifier onlyTokenContract {
42         require(msg.sender == address(tokenContract));
43         _;
44     }
45 
46     /**
47     * @dev Standard ERC677 function that will handle incoming token transfers.
48     *
49     * @param _from  Token sender address.
50     * @param _value Amount of tokens.
51     * @param _data  Transaction metadata.
52     */
53     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
54 }
55 
56 
57 contract DailyDivs {
58     /*=================================
59     =            MODIFIERS            =
60     =================================*/
61     // only people with tokens
62     modifier onlyBagholders() {
63         require(myTokens() > 0);
64         _;
65     }
66 
67     // only people with profits
68     modifier onlyStronghands() {
69         require(myDividends(true) > 0);
70         _;
71     }
72 
73     modifier notContract() {
74       require (msg.sender == tx.origin);
75       _;
76     }
77 
78     // administrators can:
79     // -> change the name of the contract
80     // -> change the name of the token
81     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
82     // they CANNOT:
83     // -> take funds
84     // -> disable withdrawals
85     // -> kill the contract
86     // -> change the price of tokens
87     modifier onlyAdministrator(){
88         address _customerAddress = msg.sender;
89         require(administrators[_customerAddress]);
90         _;
91     }
92     
93     uint ACTIVATION_TIME = 1540957500;
94 
95 
96     // ensures that the first tokens in the contract will be equally distributed
97     // meaning, no divine dump will be ever possible
98     // result: healthy longevity.
99     modifier antiEarlyWhale(uint256 _amountOfEthereum){
100         address _customerAddress = msg.sender;
101         
102         if (now >= ACTIVATION_TIME) {
103             onlyAmbassadors = false;
104         }
105 
106         // are we still in the vulnerable phase?
107         // if so, enact anti early whale protocol
108         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
109             require(
110                 // is the customer in the ambassador list?
111                 ambassadors_[_customerAddress] == true &&
112 
113                 // does the customer purchase exceed the max ambassador quota?
114                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
115 
116             );
117 
118             // updated the accumulated quota
119             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
120 
121             // execute
122             _;
123         } else {
124             // in case the ether count drops low, the ambassador phase won't reinitiate
125             onlyAmbassadors = false;
126             _;
127         }
128 
129     }
130 
131     /*==============================
132     =            EVENTS            =
133     ==============================*/
134     event onTokenPurchase(
135         address indexed customerAddress,
136         uint256 incomingEthereum,
137         uint256 tokensMinted,
138         address indexed referredBy
139     );
140 
141     event onTokenSell(
142         address indexed customerAddress,
143         uint256 tokensBurned,
144         uint256 ethereumEarned
145     );
146 
147     event onReinvestment(
148         address indexed customerAddress,
149         uint256 ethereumReinvested,
150         uint256 tokensMinted
151     );
152 
153     event onWithdraw(
154         address indexed customerAddress,
155         uint256 ethereumWithdrawn
156     );
157 
158     // ERC20
159     event Transfer(
160         address indexed from,
161         address indexed to,
162         uint256 tokens
163     );
164 
165 
166     /*=====================================
167     =            CONFIGURABLES            =
168     =====================================*/
169     string public name = "DailyDivs";
170     string public symbol = "DDT";
171     uint8 constant public decimals = 18;
172     uint8 constant internal dividendFee_ = 4; // 4% dividend fee on each buy and sell
173     uint8 constant internal fundFee_ = 1; // 1% fund tax on buys/sells/reinvest (split 80/20)
174     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
175     uint256 constant internal tokenPriceIncremental_ = 0.00000008 ether;
176     uint256 constant internal magnitude = 2**64;
177 
178     
179     // 80/20 FUND TAX CONTRACT ADDRESS
180     address constant public giveEthFundAddress = 0x6758C48e9ABB42106D53936dDbC841bB44128cf9;
181     uint256 public totalEthFundRecieved; // total ETH FUND recieved from this contract
182     uint256 public totalEthFundCollected; // total ETH FUND collected in this contract
183 
184     // proof of stake (defaults at 100 tokens)
185     uint256 public stakingRequirement = 1e18;
186 
187     // ambassador program
188     mapping(address => bool) internal ambassadors_;
189     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
190     uint256 constant internal ambassadorQuota_ = 1.5 ether;
191 
192 
193 
194    /*================================
195     =            DATASETS            =
196     ================================*/
197     // amount of shares for each address (scaled number)
198     mapping(address => uint256) internal tokenBalanceLedger_;
199     mapping(address => uint256) internal referralBalance_;
200     mapping(address => int256) internal payoutsTo_;
201     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
202     uint256 internal tokenSupply_ = 0;
203     uint256 internal profitPerShare_;
204 
205     // administrator list (see above on what they can do)
206     mapping(address => bool) public administrators;
207 
208     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
209     bool public onlyAmbassadors = true;
210 
211     // Special DailyDivs Platform control from scam game contracts on DailyDivs platform
212     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept DailyDivs tokens
213 
214 
215 
216     /*=======================================
217     =            PUBLIC FUNCTIONS            =
218     =======================================*/
219     /*
220     * -- APPLICATION ENTRY POINTS --
221     */
222     function DailyDivs()
223         public
224     {
225         // add administrators here
226         administrators[0x0E7b52B895E3322eF341004DC6CB5C63e1d9b1c5] = true;
227         
228         // admin
229         ambassadors_[0x0E7b52B895E3322eF341004DC6CB5C63e1d9b1c5] = true;
230 
231         
232         
233         
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
246         require(tx.gasprice <= 0.05 szabo);
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
259         require(tx.gasprice <= 0.01 szabo);
260         purchaseInternal(msg.value, 0x0);
261     }
262 
263     /**
264      * Sends FUND TAX to the FUND TAX addres. (Remember 100% of the Fund is used to support DDT Lending and other platform games)
265      * This is the FUND TAX address: https://etherscan.io/address/0x6758C48e9ABB42106D53936dDbC841bB44128cf9
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
357 
358         // Take out dividends and then _fundPayout
359         uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
360 
361         // Add ethereum to send to Fund Tax Contract
362         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
363 
364         // burn the sold tokens
365         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
366         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
367 
368         // update dividends tracker
369         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
370         payoutsTo_[_customerAddress] -= _updatedPayouts;
371 
372         // dividing by zero is a bad idea
373         if (tokenSupply_ > 0) {
374             // update the amount of dividends per token
375             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
376         }
377 
378         // fire event
379         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
380     }
381 
382 
383     /**
384      * Transfer tokens from the caller to a new holder.
385      * REMEMBER THIS IS 0% TRANSFER FEE
386      */
387     function transfer(address _toAddress, uint256 _amountOfTokens)
388         onlyBagholders()
389         public
390         returns(bool)
391     {
392         // setup
393         address _customerAddress = msg.sender;
394 
395         // make sure we have the requested tokens
396         // also disables transfers until ambassador phase is over
397         // ( we dont want whale premines )
398         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
399 
400         // withdraw all outstanding dividends first
401         if(myDividends(true) > 0) withdraw();
402 
403         // exchange tokens
404         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
405         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
406 
407         // update dividend trackers
408         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
409         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
410 
411 
412         // fire event
413         Transfer(_customerAddress, _toAddress, _amountOfTokens);
414 
415         // ERC20
416         return true;
417     }
418 
419     /**
420     * Transfer token to a specified address and forward the data to recipient
421     * ERC-677 standard
422     * https://github.com/ethereum/EIPs/issues/677
423     * @param _to    Receiver address.
424     * @param _value Amount of tokens that will be transferred.
425     * @param _data  Transaction metadata.
426     */
427     function transferAndCall(address _to, uint256 _value, bytes _data) external returns (bool) {
428       require(_to != address(0));
429       require(canAcceptTokens_[_to] == true); // security check that contract approved by DailyDivs platform
430       require(transfer(_to, _value)); // do a normal token transfer to the contract
431 
432       if (isContract(_to)) {
433         AcceptsDailyDivs receiver = AcceptsDailyDivs(_to);
434         require(receiver.tokenFallback(msg.sender, _value, _data));
435       }
436 
437       return true;
438     }
439 
440     /**
441      * Additional check that the game address we are sending tokens to is a contract
442      * assemble the given address bytecode. If bytecode exists then the _addr is a contract.
443      */
444      function isContract(address _addr) private constant returns (bool is_contract) {
445        // retrieve the size of the code on target address, this needs assembly
446        uint length;
447        assembly { length := extcodesize(_addr) }
448        return length > 0;
449      }
450 
451     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
452     /**
453      * In case the ambassador quota is not met, the administrator can manually disable the ambassador phase.
454      */
455     //function disableInitialStage()
456     //    onlyAdministrator()
457     //    public
458     //{
459     //    onlyAmbassadors = false;
460     //}
461 
462     /**
463      * In case one of us dies, we need to replace ourselves.
464      */
465     function setAdministrator(address _identifier, bool _status)
466         onlyAdministrator()
467         public
468     {
469         administrators[_identifier] = _status;
470     }
471 
472     /**
473      * Precautionary measures in case we need to adjust the masternode rate.
474      */
475     function setStakingRequirement(uint256 _amountOfTokens)
476         onlyAdministrator()
477         public
478     {
479         stakingRequirement = _amountOfTokens;
480     }
481 
482     /**
483      * Add or remove game contract, which can accept DailyDivs tokens
484      */
485     function setCanAcceptTokens(address _address, bool _value)
486       onlyAdministrator()
487       public
488     {
489       canAcceptTokens_[_address] = _value;
490     }
491 
492     /**
493      * If we want to rebrand, we can.
494      */
495     function setName(string _name)
496         onlyAdministrator()
497         public
498     {
499         name = _name;
500     }
501 
502     /**
503      * If we want to rebrand, we can.
504      */
505     function setSymbol(string _symbol)
506         onlyAdministrator()
507         public
508     {
509         symbol = _symbol;
510     }
511 
512 
513     /*----------  HELPERS AND CALCULATORS  ----------*/
514     /**
515      * Method to view the current Ethereum stored in the contract
516      * Example: totalEthereumBalance()
517      */
518     function totalEthereumBalance()
519         public
520         view
521         returns(uint)
522     {
523         return this.balance;
524     }
525 
526     /**
527      * Retrieve the total token supply.
528      */
529     function totalSupply()
530         public
531         view
532         returns(uint256)
533     {
534         return tokenSupply_;
535     }
536 
537     /**
538      * Retrieve the tokens owned by the caller.
539      */
540     function myTokens()
541         public
542         view
543         returns(uint256)
544     {
545         address _customerAddress = msg.sender;
546         return balanceOf(_customerAddress);
547     }
548 
549     /**
550      * Retrieve the dividends owned by the caller.
551      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
552      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
553      * But in the internal calculations, we want them separate.
554      */
555     function myDividends(bool _includeReferralBonus)
556         public
557         view
558         returns(uint256)
559     {
560         address _customerAddress = msg.sender;
561         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
562     }
563 
564     /**
565      * Retrieve the token balance of any single address.
566      */
567     function balanceOf(address _customerAddress)
568         view
569         public
570         returns(uint256)
571     {
572         return tokenBalanceLedger_[_customerAddress];
573     }
574 
575     /**
576      * Retrieve the dividend balance of any single address.
577      */
578     function dividendsOf(address _customerAddress)
579         view
580         public
581         returns(uint256)
582     {
583         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
584     }
585 
586     /**
587      * Return the buy price of 1 individual token.
588      */
589     function sellPrice()
590         public
591         view
592         returns(uint256)
593     {
594         // our calculation relies on the token supply, so we need supply. Doh.
595         if(tokenSupply_ == 0){
596             return tokenPriceInitial_ - tokenPriceIncremental_;
597         } else {
598             uint256 _ethereum = tokensToEthereum_(1e18);
599             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
600             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
601             uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
602             return _taxedEthereum;
603         }
604     }
605 
606     /**
607      * Return the sell price of 1 individual token.
608      */
609     function buyPrice()
610         public
611         view
612         returns(uint256)
613     {
614         // our calculation relies on the token supply, so we need supply. Doh.
615         if(tokenSupply_ == 0){
616             return tokenPriceInitial_ + tokenPriceIncremental_;
617         } else {
618             uint256 _ethereum = tokensToEthereum_(1e18);
619             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
620             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
621             uint256 _taxedEthereum =  SafeMath.add(SafeMath.add(_ethereum, _dividends), _fundPayout);
622             return _taxedEthereum;
623         }
624     }
625 
626     /**
627      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
628      */
629     function calculateTokensReceived(uint256 _ethereumToSpend)
630         public
631         view
632         returns(uint256)
633     {
634         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, dividendFee_), 100);
635         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereumToSpend, fundFee_), 100);
636         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereumToSpend, _dividends), _fundPayout);
637         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
638         return _amountOfTokens;
639     }
640 
641     /**
642      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
643      */
644     function calculateEthereumReceived(uint256 _tokensToSell)
645         public
646         view
647         returns(uint256)
648     {
649         require(_tokensToSell <= tokenSupply_);
650         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
651         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
652         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
653         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
654         return _taxedEthereum;
655     }
656 
657     /**
658      * Function for the frontend to show ether waiting to be sent to Fund Contract from the exchange contract
659      */
660     function etherToSendFund()
661         public
662         view
663         returns(uint256) {
664         return SafeMath.sub(totalEthFundCollected, totalEthFundRecieved);
665     }
666 
667 
668     /*==========================================
669     =            INTERNAL FUNCTIONS            =
670     ==========================================*/
671 
672     // Make sure we will send back excess if user sends more then 2 ether before 200 ETH in contract
673     function purchaseInternal(uint256 _incomingEthereum, address _referredBy)
674       notContract()// no contracts allowed
675       internal
676       returns(uint256) {
677 
678       uint256 purchaseEthereum = _incomingEthereum;
679       uint256 excess;
680       if(purchaseEthereum > 2 ether) { // check if the transaction is over 2 ether
681           if (SafeMath.sub(address(this).balance, purchaseEthereum) <= 200 ether) { // if so check the contract is less then 200 ether
682               purchaseEthereum = 2 ether;
683               excess = SafeMath.sub(_incomingEthereum, purchaseEthereum);
684           }
685       }
686 
687       purchaseTokens(purchaseEthereum, _referredBy);
688 
689       if (excess > 0) {
690         msg.sender.transfer(excess);
691       }
692     }
693 
694 
695     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
696         antiEarlyWhale(_incomingEthereum)
697         internal
698         returns(uint256)
699     {
700         // data setup
701         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);
702         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
703         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_incomingEthereum, fundFee_), 100);
704         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
705         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_incomingEthereum, _undividedDividends), _fundPayout);
706 
707         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
708 
709         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
710         uint256 _fee = _dividends * magnitude;
711 
712         // no point in continuing execution if OP is a poorfag russian hacker
713         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
714         // (or hackers)
715         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
716         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
717 
718         // is the user referred by a masternode?
719         if(
720             // is this a referred purchase?
721             _referredBy != 0x0000000000000000000000000000000000000000 &&
722 
723             // no cheating!
724             _referredBy != msg.sender &&
725 
726             // does the referrer have at least X whole tokens?
727             // i.e is the referrer a godly chad masternode
728             tokenBalanceLedger_[_referredBy] >= stakingRequirement
729         ){
730             // wealth redistribution
731             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
732         } else {
733             // no ref purchase
734             // add the referral bonus back to the global dividends cake
735             _dividends = SafeMath.add(_dividends, _referralBonus);
736             _fee = _dividends * magnitude;
737         }
738 
739         // we can't give people infinite ethereum
740         if(tokenSupply_ > 0){
741 
742             // add tokens to the pool
743             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
744 
745             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
746             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
747 
748             // calculate the amount of tokens the customer receives over his purchase
749             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
750 
751         } else {
752             // add tokens to the pool
753             tokenSupply_ = _amountOfTokens;
754         }
755 
756         // update circulating supply & the ledger address for the customer
757         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
758 
759         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
760         //really i know you think you do but you don't
761         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
762         payoutsTo_[msg.sender] += _updatedPayouts;
763 
764         // fire event
765         onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
766 
767         return _amountOfTokens;
768     }
769 
770     /**
771      * Calculate Token price based on an amount of incoming ethereum
772      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
773      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
774      */
775     function ethereumToTokens_(uint256 _ethereum)
776         internal
777         view
778         returns(uint256)
779     {
780         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
781         uint256 _tokensReceived =
782          (
783             (
784                 // underflow attempts BTFO
785                 SafeMath.sub(
786                     (sqrt
787                         (
788                             (_tokenPriceInitial**2)
789                             +
790                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
791                             +
792                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
793                             +
794                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
795                         )
796                     ), _tokenPriceInitial
797                 )
798             )/(tokenPriceIncremental_)
799         )-(tokenSupply_)
800         ;
801 
802         return _tokensReceived;
803     }
804 
805     /**
806      * Calculate token sell value.
807      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
808      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
809      */
810      function tokensToEthereum_(uint256 _tokens)
811         internal
812         view
813         returns(uint256)
814     {
815 
816         uint256 tokens_ = (_tokens + 1e18);
817         uint256 _tokenSupply = (tokenSupply_ + 1e18);
818         uint256 _etherReceived =
819         (
820             // underflow attempts BTFO
821             SafeMath.sub(
822                 (
823                     (
824                         (
825                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
826                         )-tokenPriceIncremental_
827                     )*(tokens_ - 1e18)
828                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
829             )
830         /1e18);
831         return _etherReceived;
832     }
833 
834 
835     //This is where all your gas goes, sorry
836     //Not sorry, you probably only paid 1 gwei
837     function sqrt(uint x) internal pure returns (uint y) {
838         uint z = (x + 1) / 2;
839         y = x;
840         while (z < y) {
841             y = z;
842             z = (x / z + z) / 2;
843         }
844     }
845 }
846 
847 /**
848  * @title SafeMath
849  * @dev Math operations with safety checks that throw on error
850  */
851 library SafeMath {
852 
853     /**
854     * @dev Multiplies two numbers, throws on overflow.
855     */
856     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
857         if (a == 0) {
858             return 0;
859         }
860         uint256 c = a * b;
861         assert(c / a == b);
862         return c;
863     }
864 
865     /**
866     * @dev Integer division of two numbers, truncating the quotient.
867     */
868     function div(uint256 a, uint256 b) internal pure returns (uint256) {
869         // assert(b > 0); // Solidity automatically throws when dividing by 0
870         uint256 c = a / b;
871         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
872         return c;
873     }
874 
875     /**
876     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
877     */
878     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
879         assert(b <= a);
880         return a - b;
881     }
882 
883     /**
884     * @dev Adds two numbers, throws on overflow.
885     */
886     function add(uint256 a, uint256 b) internal pure returns (uint256) {
887         uint256 c = a + b;
888         assert(c >= a);
889         return c;
890     }
891 }