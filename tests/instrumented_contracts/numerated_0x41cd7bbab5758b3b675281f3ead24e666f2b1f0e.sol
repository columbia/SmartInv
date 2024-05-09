1 pragma solidity ^0.4.21;
2 
3 /*
4 ******************** DailyDivs.com *********************
5 *
6 *  ____        _ _       ____  _                                
7 * |  _ \  __ _(_) |_   _|  _ \(_)_   _____   ___ ___  _ __ ___  
8 * | | | |/ _` | | | | | | | | | \ \ / / __| / __/ _ \| '_ ` _ \ 
9 * | |_| | (_| | | | |_| | |_| | |\ V /\__ \| (_| (_) | | | | | |
10 * |____/ \__,_|_|_|\__, |____/|_| \_/ |___(_)___\___/|_| |_| |_|
11 *                  |___/                                        
12 *
13 ******************** DailyDivs.com *********************
14 *
15 *
16 * [x] 0% TRANSFER FEES
17 * [x] 20% DIVIDENDS AND MASTERNODES
18 * [x] Multi-tier Masternode system 50% 1st ref 30% 2nd ref 20% 3rd ref
19 * [x] 5% FEE ON EACH BUY AND SELL GO TO Smart Contract Fund 0xF34340Ba65f37320B25F9f6F3978D02DDc13283b
20 *     5% Split -> 70% to Earn Game / 30% to Dev Fund For Future Development Costs
21 * [x] DailyDivs Token can be used for future games
22 *
23 * Official Website: https://dailydivs.com/ 
24 * Official Discord: https://discord.gg/J4Bvu32
25 * Official Telegram: https://t.me/dailydivs
26 */
27 
28 
29 /**
30  * Definition of contract accepting DailyDivs tokens
31  * Games, casinos, anything can reuse this contract to support DailyDivs tokens
32  */
33 contract AcceptsDailyDivs {
34     DailyDivs public tokenContract;
35 
36     function AcceptsDailyDivs(address _tokenContract) public {
37         tokenContract = DailyDivs(_tokenContract);
38     }
39 
40     modifier onlyTokenContract {
41         require(msg.sender == address(tokenContract));
42         _;
43     }
44 
45     /**
46     * @dev Standard ERC677 function that will handle incoming token transfers.
47     *
48     * @param _from  Token sender address.
49     * @param _value Amount of tokens.
50     * @param _data  Transaction metadata.
51     */
52     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
53 }
54 
55 
56 contract DailyDivs {
57     /*=================================
58     =            MODIFIERS            =
59     =================================*/
60     // only people with tokens
61     modifier onlyBagholders() {
62         require(myTokens() > 0);
63         _;
64     }
65 
66     // only people with profits
67     modifier onlyStronghands() {
68         require(myDividends(true) > 0);
69         _;
70     }
71 
72     modifier notContract() {
73       require (msg.sender == tx.origin);
74       _;
75     }
76 
77     // administrators can:
78     // -> change the name of the contract
79     // -> change the name of the token
80     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
81     // they CANNOT:
82     // -> take funds
83     // -> disable withdrawals
84     // -> kill the contract
85     // -> change the price of tokens
86     modifier onlyAdministrator(){
87         address _customerAddress = msg.sender;
88         require(administrators[_customerAddress]);
89         _;
90     }
91     
92     uint ACTIVATION_TIME = 1535835600;
93 
94 
95     // ensures that the first tokens in the contract will be equally distributed
96     // meaning, no divine dump will be ever possible
97     // result: healthy longevity.
98     modifier antiEarlyWhale(uint256 _amountOfEthereum){
99         address _customerAddress = msg.sender;
100         
101         if (now >= ACTIVATION_TIME) {
102             onlyAmbassadors = false;
103         }
104 
105         // are we still in the vulnerable phase?
106         // if so, enact anti early whale protocol
107         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
108             require(
109                 // is the customer in the ambassador list?
110                 ambassadors_[_customerAddress] == true &&
111 
112                 // does the customer purchase exceed the max ambassador quota?
113                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
114 
115             );
116 
117             // updated the accumulated quota
118             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
119 
120             // execute
121             _;
122         } else {
123             // in case the ether count drops low, the ambassador phase won't reinitiate
124             onlyAmbassadors = false;
125             _;
126         }
127 
128     }
129 
130     /*==============================
131     =            EVENTS            =
132     ==============================*/
133     event onTokenPurchase(
134         address indexed customerAddress,
135         uint256 incomingEthereum,
136         uint256 tokensMinted,
137         address indexed referredBy
138     );
139 
140     event onTokenSell(
141         address indexed customerAddress,
142         uint256 tokensBurned,
143         uint256 ethereumEarned
144     );
145 
146     event onReinvestment(
147         address indexed customerAddress,
148         uint256 ethereumReinvested,
149         uint256 tokensMinted
150     );
151 
152     event onWithdraw(
153         address indexed customerAddress,
154         uint256 ethereumWithdrawn
155     );
156 
157     // ERC20
158     event Transfer(
159         address indexed from,
160         address indexed to,
161         uint256 tokens
162     );
163 
164 
165     /*=====================================
166     =            CONFIGURABLES            =
167     =====================================*/
168     string public name = "DailyDivs";
169     string public symbol = "DDT";
170     uint8 constant public decimals = 18;
171     uint8 constant internal dividendFee_ = 20; // 20% dividend fee on each buy and sell
172     uint8 constant internal fundFee_ = 5; // 5% investment fund fee on each buy and sell
173     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
174     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
175     uint256 constant internal magnitude = 2**64;
176 
177     // Address to send the 5% Fee
178     //  70% to Earn Game / 30% to Dev Fund
179     // https://etherscan.io/address/0xF34340Ba65f37320B25F9f6F3978D02DDc13283b
180     address constant public giveEthFundAddress = 0xF34340Ba65f37320B25F9f6F3978D02DDc13283b;
181     uint256 public totalEthFundRecieved; // total ETH charity recieved from this contract
182     uint256 public totalEthFundCollected; // total ETH charity collected in this contract
183 
184     // proof of stake (defaults at 100 tokens)
185     uint256 public stakingRequirement = 25e18;
186 
187     // ambassador program
188     mapping(address => bool) internal ambassadors_;
189     uint256 constant internal ambassadorMaxPurchase_ = 2.5 ether;
190     uint256 constant internal ambassadorQuota_ = 2.5 ether;
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
214     mapping(address => address) public stickyRef;
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
226         administrators[0x5e4edd4b711eCe01400067dc3Ec564aed42Ed5b5] = true;
227 
228         // add the ambassadors here - Tokens will be distributed to these addresses from main premine
229         ambassadors_[0x5e4edd4b711eCe01400067dc3Ec564aed42Ed5b5] = true;
230         // add the ambassadors here - Tokens will be distributed to these addresses from main premine
231         ambassadors_[0x12b353d1a2842d2272ab5a18c6814d69f4296873] = true;
232        // add the ambassadors here - Tokens will be distributed to these addresses from main premine
233         ambassadors_[0x87A7e71D145187eE9aAdc86954d39cf0e9446751] = true;
234         // add the ambassadors here - Tokens will be distributed to these addresses from main premine
235         ambassadors_[0x41FE3738B503cBaFD01C1Fd8DD66b7fE6Ec11b01] = true;
236         // add the ambassadors here - Tokens will be distributed to these addresses from main premine
237         ambassadors_[0x5632ca98e5788eddb2397757aa82d1ed6171e5ad] = true;
238         // add the ambassadors here - Tokens will be distributed to these addresses from main premine
239         ambassadors_[0x0A49857F69919AEcddbA77136364Bb19108B4891] = true;
240         // add the ambassadors here - Tokens will be distributed to these addresses from main premine
241             ambassadors_[0xdb59f29f7242989a3eda271483b89e1f74353ffa] = true;
242         
243     }
244 
245 
246     /**
247      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
248      */
249     function buy(address _referredBy)
250         public
251         payable
252         returns(uint256)
253     {
254         
255         require(tx.gasprice <= 0.05 szabo);
256         purchaseTokens(msg.value, _referredBy);
257     }
258 
259     /**
260      * Fallback function to handle ethereum that was send straight to the contract
261      * Unfortunately we cannot use a referral address this way.
262      */
263     function()
264         payable
265         public
266     {
267         
268         require(tx.gasprice <= 0.05 szabo);
269         purchaseTokens(msg.value, 0x0);
270     }
271 
272     /**
273      * Sends FUND money to the 70/30 Contract
274      * The address is here https://etherscan.io/address/0xF34340Ba65f37320B25F9f6F3978D02DDc13283b
275      */
276     function payFund() payable public {
277       uint256 ethToPay = SafeMath.sub(totalEthFundCollected, totalEthFundRecieved);
278       require(ethToPay > 1);
279       totalEthFundRecieved = SafeMath.add(totalEthFundRecieved, ethToPay);
280       if(!giveEthFundAddress.call.value(ethToPay).gas(400000)()) {
281          totalEthFundRecieved = SafeMath.sub(totalEthFundRecieved, ethToPay);
282       }
283     }
284 
285     /**
286      * Converts all of caller's dividends to tokens.
287      */
288     function reinvest()
289         onlyStronghands()
290         public
291     {
292         // fetch dividends
293         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
294 
295         // pay out the dividends virtually
296         address _customerAddress = msg.sender;
297         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
298 
299         // retrieve ref. bonus
300         _dividends += referralBalance_[_customerAddress];
301         referralBalance_[_customerAddress] = 0;
302 
303         // dispatch a buy order with the virtualized "withdrawn dividends"
304         uint256 _tokens = purchaseTokens(_dividends, 0x0);
305 
306         // fire event
307         onReinvestment(_customerAddress, _dividends, _tokens);
308     }
309 
310     /**
311      * Alias of sell() and withdraw().
312      */
313     function exit()
314         public
315     {
316         // get token count for caller & sell them all
317         address _customerAddress = msg.sender;
318         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
319         if(_tokens > 0) sell(_tokens);
320 
321         // lambo delivery service
322         withdraw();
323     }
324 
325     /**
326      * Withdraws all of the callers earnings.
327      */
328     function withdraw()
329         onlyStronghands()
330         public
331     {
332         // setup data
333         address _customerAddress = msg.sender;
334         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
335 
336         // update dividend tracker
337         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
338 
339         // add ref. bonus
340         _dividends += referralBalance_[_customerAddress];
341         referralBalance_[_customerAddress] = 0;
342 
343         // lambo delivery service
344         _customerAddress.transfer(_dividends);
345 
346         // fire event
347         onWithdraw(_customerAddress, _dividends);
348     }
349 
350     /**
351      * Liquifies tokens to ethereum.
352      */
353     function sell(uint256 _amountOfTokens)
354         onlyBagholders()
355         public
356     {
357         // setup data
358         address _customerAddress = msg.sender;
359         // russian hackers BTFO
360         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
361         uint256 _tokens = _amountOfTokens;
362         uint256 _ethereum = tokensToEthereum_(_tokens);
363 
364         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
365         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
366         uint256 _refPayout = _dividends / 3;
367         _dividends = SafeMath.sub(_dividends, _refPayout);
368         (_dividends,) = handleRef(stickyRef[msg.sender], _refPayout, _dividends, 0);
369 
370         // Take out dividends and then _fundPayout
371         uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
372 
373         // Add ethereum to send to fund
374         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
375 
376         // burn the sold tokens
377         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
378         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
379 
380         // update dividends tracker
381         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
382         payoutsTo_[_customerAddress] -= _updatedPayouts;
383 
384         // dividing by zero is a bad idea
385         if (tokenSupply_ > 0) {
386             // update the amount of dividends per token
387             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
388         }
389 
390         // fire event
391         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
392     }
393 
394 
395     /**
396      * Transfer tokens from the caller to a new holder.
397      * REMEMBER THIS IS 0% TRANSFER FEE
398      */
399     function transfer(address _toAddress, uint256 _amountOfTokens)
400         onlyBagholders()
401         public
402         returns(bool)
403     {
404         // setup
405         address _customerAddress = msg.sender;
406 
407         // make sure we have the requested tokens
408         // also disables transfers until ambassador phase is over
409         // ( we dont want whale premines )
410         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
411 
412         // withdraw all outstanding dividends first
413         if(myDividends(true) > 0) withdraw();
414 
415         // exchange tokens
416         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
417         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
418 
419         // update dividend trackers
420         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
421         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
422 
423 
424         // fire event
425         Transfer(_customerAddress, _toAddress, _amountOfTokens);
426 
427         // ERC20
428         return true;
429     }
430 
431     /**
432     * Transfer token to a specified address and forward the data to recipient
433     * ERC-677 standard
434     * https://github.com/ethereum/EIPs/issues/677
435     * @param _to    Receiver address.
436     * @param _value Amount of tokens that will be transferred.
437     * @param _data  Transaction metadata.
438     */
439     function transferAndCall(address _to, uint256 _value, bytes _data) external returns (bool) {
440       require(_to != address(0));
441       require(canAcceptTokens_[_to] == true); // security check that contract approved by DailyDivs platform
442       require(transfer(_to, _value)); // do a normal token transfer to the contract
443 
444       if (isContract(_to)) {
445         AcceptsDailyDivs receiver = AcceptsDailyDivs(_to);
446         require(receiver.tokenFallback(msg.sender, _value, _data));
447       }
448 
449       return true;
450     }
451 
452     /**
453      * Additional check that the game address we are sending tokens to is a contract
454      * assemble the given address bytecode. If bytecode exists then the _addr is a contract.
455      */
456      function isContract(address _addr) private constant returns (bool is_contract) {
457        // retrieve the size of the code on target address, this needs assembly
458        uint length;
459        assembly { length := extcodesize(_addr) }
460        return length > 0;
461      }
462 
463     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
464     /**
465      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
466      */
467     //function disableInitialStage()
468     //    onlyAdministrator()
469     //    public
470     //{
471     //    onlyAmbassadors = false;
472     //}
473 
474     /**
475      * In case one of us dies, we need to replace ourselves.
476      */
477     function setAdministrator(address _identifier, bool _status)
478         onlyAdministrator()
479         public
480     {
481         administrators[_identifier] = _status;
482     }
483 
484     /**
485      * Precautionary measures in case we need to adjust the masternode rate.
486      */
487     function setStakingRequirement(uint256 _amountOfTokens)
488         onlyAdministrator()
489         public
490     {
491         stakingRequirement = _amountOfTokens;
492     }
493 
494     /**
495      * Add or remove game contract, which can accept DailyDivs tokens
496      */
497     function setCanAcceptTokens(address _address, bool _value)
498       onlyAdministrator()
499       public
500     {
501       canAcceptTokens_[_address] = _value;
502     }
503 
504     /**
505      * If we want to rebrand, we can.
506      */
507     function setName(string _name)
508         onlyAdministrator()
509         public
510     {
511         name = _name;
512     }
513 
514     /**
515      * If we want to rebrand, we can.
516      */
517     function setSymbol(string _symbol)
518         onlyAdministrator()
519         public
520     {
521         symbol = _symbol;
522     }
523 
524 
525     /*----------  HELPERS AND CALCULATORS  ----------*/
526     /**
527      * Method to view the current Ethereum stored in the contract
528      * Example: totalEthereumBalance()
529      */
530     function totalEthereumBalance()
531         public
532         view
533         returns(uint)
534     {
535         return this.balance;
536     }
537 
538     /**
539      * Retrieve the total token supply.
540      */
541     function totalSupply()
542         public
543         view
544         returns(uint256)
545     {
546         return tokenSupply_;
547     }
548 
549     /**
550      * Retrieve the tokens owned by the caller.
551      */
552     function myTokens()
553         public
554         view
555         returns(uint256)
556     {
557         address _customerAddress = msg.sender;
558         return balanceOf(_customerAddress);
559     }
560 
561     /**
562      * Retrieve the dividends owned by the caller.
563      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
564      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
565      * But in the internal calculations, we want them separate.
566      */
567     function myDividends(bool _includeReferralBonus)
568         public
569         view
570         returns(uint256)
571     {
572         address _customerAddress = msg.sender;
573         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
574     }
575 
576     /**
577      * Retrieve the token balance of any single address.
578      */
579     function balanceOf(address _customerAddress)
580         view
581         public
582         returns(uint256)
583     {
584         return tokenBalanceLedger_[_customerAddress];
585     }
586 
587     /**
588      * Retrieve the dividend balance of any single address.
589      */
590     function dividendsOf(address _customerAddress)
591         view
592         public
593         returns(uint256)
594     {
595         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
596     }
597 
598     /**
599      * Return the buy price of 1 individual token.
600      */
601     function sellPrice()
602         public
603         view
604         returns(uint256)
605     {
606         // our calculation relies on the token supply, so we need supply. Doh.
607         if(tokenSupply_ == 0){
608             return tokenPriceInitial_ - tokenPriceIncremental_;
609         } else {
610             uint256 _ethereum = tokensToEthereum_(1e18);
611             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
612             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
613             uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
614             return _taxedEthereum;
615         }
616     }
617 
618     /**
619      * Return the sell price of 1 individual token.
620      */
621     function buyPrice()
622         public
623         view
624         returns(uint256)
625     {
626         // our calculation relies on the token supply, so we need supply. Doh.
627         if(tokenSupply_ == 0){
628             return tokenPriceInitial_ + tokenPriceIncremental_;
629         } else {
630             uint256 _ethereum = tokensToEthereum_(1e18);
631             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
632             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
633             uint256 _taxedEthereum =  SafeMath.add(SafeMath.add(_ethereum, _dividends), _fundPayout);
634             return _taxedEthereum;
635         }
636     }
637 
638     /**
639      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
640      */
641     function calculateTokensReceived(uint256 _ethereumToSpend)
642         public
643         view
644         returns(uint256)
645     {
646         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, dividendFee_), 100);
647         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereumToSpend, fundFee_), 100);
648         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereumToSpend, _dividends), _fundPayout);
649         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
650         return _amountOfTokens;
651     }
652 
653     /**
654      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
655      */
656     function calculateEthereumReceived(uint256 _tokensToSell)
657         public
658         view
659         returns(uint256)
660     {
661         require(_tokensToSell <= tokenSupply_);
662         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
663         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
664         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
665         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
666         return _taxedEthereum;
667     }
668 
669     /**
670      * Function for the frontend to show ether waiting to be send to fund in contract
671      */
672     function etherToSendFund()
673         public
674         view
675         returns(uint256) {
676         return SafeMath.sub(totalEthFundCollected, totalEthFundRecieved);
677     }
678 
679 
680     /*==========================================
681     =            INTERNAL FUNCTIONS            =
682     ==========================================*/
683 
684     // Make sure we will send back excess if user sends more then 5 ether before 100 ETH in contract
685     function purchaseInternal(uint256 _incomingEthereum, address _referredBy)
686       notContract()// no contracts allowed
687       internal
688       returns(uint256) {
689 
690       uint256 purchaseEthereum = _incomingEthereum;
691       uint256 excess;
692       if(purchaseEthereum > 2.5 ether) { // check if the transaction is over 2.5 ether
693           if (SafeMath.sub(address(this).balance, purchaseEthereum) <= 100 ether) { // if so check the contract is less then 100 ether
694               purchaseEthereum = 2.5 ether;
695               excess = SafeMath.sub(_incomingEthereum, purchaseEthereum);
696           }
697       }
698 
699       purchaseTokens(purchaseEthereum, _referredBy);
700 
701       if (excess > 0) {
702         msg.sender.transfer(excess);
703       }
704     }
705 
706     function handleRef(address _ref, uint _referralBonus, uint _currentDividends, uint _currentFee) internal returns (uint, uint){
707         uint _dividends = _currentDividends;
708         uint _fee = _currentFee;
709         address _referredBy = stickyRef[msg.sender];
710         if (_referredBy == address(0x0)){
711             _referredBy = _ref;
712         }
713         // is the user referred by a masternode?
714         if(
715             // is this a referred purchase?
716             _referredBy != 0x0000000000000000000000000000000000000000 &&
717 
718             // no cheating!
719             _referredBy != msg.sender &&
720 
721             // does the referrer have at least X whole tokens?
722             // i.e is the referrer a godly chad masternode
723             tokenBalanceLedger_[_referredBy] >= stakingRequirement
724         ){
725             // wealth redistribution
726             if (stickyRef[msg.sender] == address(0x0)){
727                 stickyRef[msg.sender] = _referredBy;
728             }
729             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus/2);
730             address currentRef = stickyRef[_referredBy];
731             if (currentRef != address(0x0) && tokenBalanceLedger_[currentRef] >= stakingRequirement){
732                 referralBalance_[currentRef] = SafeMath.add(referralBalance_[currentRef], (_referralBonus/10)*3);
733                 currentRef = stickyRef[currentRef];
734                 if (currentRef != address(0x0) && tokenBalanceLedger_[currentRef] >= stakingRequirement){
735                     referralBalance_[currentRef] = SafeMath.add(referralBalance_[currentRef], (_referralBonus/10)*2);
736                 }
737                 else{
738                     _dividends = SafeMath.add(_dividends, _referralBonus - _referralBonus/2 - (_referralBonus/10)*3);
739                     _fee = _dividends * magnitude;
740                 }
741             }
742             else{
743                 _dividends = SafeMath.add(_dividends, _referralBonus - _referralBonus/2);
744                 _fee = _dividends * magnitude;
745             }
746             
747             
748         } else {
749             // no ref purchase
750             // add the referral bonus back to the global dividends cake
751             _dividends = SafeMath.add(_dividends, _referralBonus);
752             _fee = _dividends * magnitude;
753         }
754         return (_dividends, _fee);
755     }
756 
757 
758     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
759         antiEarlyWhale(_incomingEthereum)
760         internal
761         returns(uint256)
762     {
763         // data setup
764         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);
765         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
766         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_incomingEthereum, fundFee_), 100);
767         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
768         uint256 _fee;
769         (_dividends, _fee) = handleRef(_referredBy, _referralBonus, _dividends, _fee);
770         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_incomingEthereum, _dividends), _fundPayout);
771         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
772 
773         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
774 
775 
776         // no point in continuing execution if OP is a poorfag russian hacker
777         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
778         // (or hackers)
779         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
780         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
781 
782 
783 
784         // we can't give people infinite ethereum
785         if(tokenSupply_ > 0){
786  
787             // add tokens to the pool
788             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
789 
790             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
791             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
792 
793             // calculate the amount of tokens the customer receives over his purchase
794             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
795 
796         } else {
797             // add tokens to the pool
798             tokenSupply_ = _amountOfTokens;
799         }
800 
801         // update circulating supply & the ledger address for the customer
802         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
803 
804         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
805         //really i know you think you do but you don't
806         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
807         payoutsTo_[msg.sender] += _updatedPayouts;
808 
809         // fire event
810         onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
811 
812         return _amountOfTokens;
813     }
814 
815     /**
816      * Calculate Token price based on an amount of incoming ethereum
817      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
818      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
819      */
820     function ethereumToTokens_(uint256 _ethereum)
821         internal
822         view
823         returns(uint256)
824     {
825         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
826         uint256 _tokensReceived =
827          (
828             (
829                 // underflow attempts BTFO
830                 SafeMath.sub(
831                     (sqrt
832                         (
833                             (_tokenPriceInitial**2)
834                             +
835                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
836                             +
837                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
838                             +
839                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
840                         )
841                     ), _tokenPriceInitial
842                 )
843             )/(tokenPriceIncremental_)
844         )-(tokenSupply_)
845         ;
846 
847         return _tokensReceived;
848     }
849 
850     /**
851      * Calculate token sell value.
852      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
853      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
854      */
855      function tokensToEthereum_(uint256 _tokens)
856         internal
857         view
858         returns(uint256)
859     {
860 
861         uint256 tokens_ = (_tokens + 1e18);
862         uint256 _tokenSupply = (tokenSupply_ + 1e18);
863         uint256 _etherReceived =
864         (
865             // underflow attempts BTFO
866             SafeMath.sub(
867                 (
868                     (
869                         (
870                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
871                         )-tokenPriceIncremental_
872                     )*(tokens_ - 1e18)
873                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
874             )
875         /1e18);
876         return _etherReceived;
877     }
878 
879 
880     //This is where all your gas goes, sorry
881     //Not sorry, you probably only paid 1 gwei
882     function sqrt(uint x) internal pure returns (uint y) {
883         uint z = (x + 1) / 2;
884         y = x;
885         while (z < y) {
886             y = z;
887             z = (x / z + z) / 2;
888         }
889     }
890 }
891 
892 /**
893  * @title SafeMath
894  * @dev Math operations with safety checks that throw on error
895  */
896 library SafeMath {
897 
898     /**
899     * @dev Multiplies two numbers, throws on overflow.
900     */
901     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
902         if (a == 0) {
903             return 0;
904         }
905         uint256 c = a * b;
906         assert(c / a == b);
907         return c;
908     }
909 
910     /**
911     * @dev Integer division of two numbers, truncating the quotient.
912     */
913     function div(uint256 a, uint256 b) internal pure returns (uint256) {
914         // assert(b > 0); // Solidity automatically throws when dividing by 0
915         uint256 c = a / b;
916         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
917         return c;
918     }
919 
920     /**
921     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
922     */
923     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
924         assert(b <= a);
925         return a - b;
926     }
927 
928     /**
929     * @dev Adds two numbers, throws on overflow.
930     */
931     function add(uint256 a, uint256 b) internal pure returns (uint256) {
932         uint256 c = a + b;
933         assert(c >= a);
934         return c;
935     }
936 }