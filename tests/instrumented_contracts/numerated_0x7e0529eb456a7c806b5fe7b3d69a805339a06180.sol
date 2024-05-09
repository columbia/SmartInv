1 pragma solidity ^0.4.21;
2 
3 /*
4 ******************** Fundingsecured.me *********************
5 *
6 * ________ ___  ___  ________   ________  ___  ________   ________             
7 *|\  _____\\  \|\  \|\   ___  \|\   ___ \|\  \|\   ___  \|\   ____\            
8 *\ \  \__/\ \  \\\  \ \  \\ \  \ \  \_|\ \ \  \ \  \\ \  \ \  \___|            
9 * \ \   __\\ \  \\\  \ \  \\ \  \ \  \ \\ \ \  \ \  \\ \  \ \  \  ___          
10 *  \ \  \_| \ \  \\\  \ \  \\ \  \ \  \_\\ \ \  \ \  \\ \  \ \  \|\  \         
11 *   \ \__\   \ \_______\ \__\\ \__\ \_______\ \__\ \__\\ \__\ \_______\        
12 *    \|__|    \|_______|\|__| \|__|\|_______|\|__|\|__| \|__|\|_______|        
13 *                                                                              
14 *                                                                              
15 *                                                                              
16 * ________  _______   ________  ___  ___  ________  _______   ________         
17 *|\   ____\|\  ___ \ |\   ____\|\  \|\  \|\   __  \|\  ___ \ |\   ___ \        
18 *\ \  \___|\ \   __/|\ \  \___|\ \  \\\  \ \  \|\  \ \   __/|\ \  \_|\ \       
19 * \ \_____  \ \  \_|/_\ \  \    \ \  \\\  \ \   _  _\ \  \_|/_\ \  \ \\ \      
20 *  \|____|\  \ \  \_|\ \ \  \____\ \  \\\  \ \  \\  \\ \  \_|\ \ \  \_\\ \ ___ 
21 *    ____\_\  \ \_______\ \_______\ \_______\ \__\\ _\\ \_______\ \_______\\__\
22 *   |\_________\|_______|\|_______|\|_______|\|__|\|__|\|_______|\|_______\|__|
23 *   \|_________|                                                               
24 *   
25 ******************** Fundingsecured.me *********************
26 *
27 *
28 * [x] 25% Exchange fee (Divs + Dev + Referral)
29 * [x] 24% Dividends to all FUNDS holders
30 * [x] 0% Account transfer fees
31 * [x] 1% To Dev Fund for future development costs (Address be updated in the future)
32 * [x] Dev Fund Address: 0x6BeF5C40723BaB057a5972f8s43454232EEE1Db50 
33 * [x] Multi-tier Masternode system for exchange buys and sells (3 levels)
34 * [x] Refferal approximate % breakdown (4% for 1st, 2.4% for 2nd, 1.6% 3rd)
35 * [x] Funding Secured (FUNDS) Token will and can be used for future games
36 *
37 * Official Website: https://fundingsecured.me/
38 * Official Exchange: https://fundingsecured.me/exchange
39 * Official Discord: https://discordapp.com/invite/3FrBqBa
40 * Official Twitter: https://twitter.com/FundingSecured_
41 * Official Telegram: https://t.me/fundingsecured
42 */
43 
44 
45 /**
46  * Definition of contract accepting FUNDING SECURED (FUNDS) tokens
47  * Games or any other innovative platforms can reuse this contract to support FUNDING SECURED (FUNDS) tokens
48  */
49 contract AcceptsFUNDS {
50     FUNDS public tokenContract;
51 
52     constructor(address _tokenContract) public {
53         tokenContract = FUNDS(_tokenContract);
54     }
55 
56     modifier onlyTokenContract {
57         require(msg.sender == address(tokenContract));
58         _;
59     }
60 
61     /**
62     * @dev Standard ERC677 function that will handle incoming token transfers.
63     *
64     * @param _from  Token sender address.
65     * @param _value Amount of tokens.
66     * @param _data  Transaction metadata.
67     */
68     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
69 }
70 
71 
72 contract FUNDS {
73     /*=================================
74     =            MODIFIERS            =
75     =================================*/
76     // only people with tokens
77     modifier onlyBagholders() {
78         require(myTokens() > 0);
79         _;
80     }
81 
82     // only people with profits
83     modifier onlyStronghands() {
84         require(myDividends(true) > 0);
85         _;
86     }
87 
88     modifier notContract() {
89       require (msg.sender == tx.origin);
90       _;
91     }
92 
93     // administrators can:
94     // -> change the name of the contract
95     // -> change the name of the token
96     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
97     // they CANNOT:
98     // -> take funds
99     // -> disable withdrawals
100     // -> kill the contract
101     // -> change the price of tokens
102     modifier onlyAdministrator(){
103         address _customerAddress = msg.sender;
104         require(administrators[_customerAddress]);
105         _;
106     }
107     
108     uint ACTIVATION_TIME = 1536258600;
109 
110 
111     // ensures that the first tokens in the contract will be equally distributed
112     // meaning, no divine dump will be ever possible
113     // result: healthy longevity.
114     modifier antiEarlyWhale(uint256 _amountOfEthereum){
115         address _customerAddress = msg.sender;
116         
117         if (now >= ACTIVATION_TIME) {
118             onlyAmbassadors = false;
119         }
120 
121         // are we still in the vulnerable phase?
122         // if so, enact anti early whale protocol
123         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
124             require(
125                 // is the customer in the ambassador list?
126                 ambassadors_[_customerAddress] == true &&
127 
128                 // does the customer purchase exceed the max ambassador quota?
129                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
130 
131             );
132 
133             // updated the accumulated quota
134             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
135 
136             // execute
137             _;
138         } else {
139             // in case the ether count drops low, the ambassador phase won't reinitiate
140             onlyAmbassadors = false;
141             _;
142         }
143 
144     }
145 
146     /*==============================
147     =            EVENTS            =
148     ==============================*/
149     event onTokenPurchase(
150         address indexed customerAddress,
151         uint256 incomingEthereum,
152         uint256 tokensMinted,
153         address indexed referredBy
154     );
155 
156     event onTokenSell(
157         address indexed customerAddress,
158         uint256 tokensBurned,
159         uint256 ethereumEarned
160     );
161 
162     event onReinvestment(
163         address indexed customerAddress,
164         uint256 ethereumReinvested,
165         uint256 tokensMinted
166     );
167 
168     event onWithdraw(
169         address indexed customerAddress,
170         uint256 ethereumWithdrawn
171     );
172 
173     // ERC20
174     event Transfer(
175         address indexed from,
176         address indexed to,
177         uint256 tokens
178     );
179 
180 
181     /*=====================================
182     =            CONFIGURABLES            =
183     =====================================*/
184     string public name = "FUNDS";
185     string public symbol = "FUNDS";
186     uint8 constant public decimals = 18;
187     uint8 constant internal dividendFee_ = 24; // 24% dividend fee on each buy and sell
188     uint8 constant internal fundFee_ = 1; // 1% investment fund fee on each buy and sell
189     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
190     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
191     uint256 constant internal magnitude = 2**64;
192 
193     // Address to send the 1% Fee
194     address public giveEthFundAddress = 0x6BeF5C40723BaB057a5972f843454232EEE1Db50;
195     bool public finalizedEthFundAddress = false;
196     uint256 public totalEthFundRecieved; // total ETH charity recieved from this contract
197     uint256 public totalEthFundCollected; // total ETH charity collected in this contract
198 
199     // proof of stake (defaults at 100 tokens)
200     uint256 public stakingRequirement = 25e18;
201 
202     // ambassador program
203     mapping(address => bool) internal ambassadors_;
204     uint256 constant internal ambassadorMaxPurchase_ = 0.5 ether;
205     uint256 constant internal ambassadorQuota_ = 2.0 ether;
206 
207 
208 
209    /*================================
210     =            DATASETS            =
211     ================================*/
212     // amount of shares for each address (scaled number)
213     mapping(address => uint256) internal tokenBalanceLedger_;
214     mapping(address => uint256) internal referralBalance_;
215     mapping(address => int256) internal payoutsTo_;
216     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
217     uint256 internal tokenSupply_ = 0;
218     uint256 internal profitPerShare_;
219 
220     // administrator list (see above on what they can do)
221     mapping(address => bool) public administrators;
222 
223     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
224     bool public onlyAmbassadors = true;
225 
226     // Special Funding Secured Platform control from scam game contracts on Funding Secured platform
227     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept Funding Secured tokens
228 
229     mapping(address => address) public stickyRef;
230 
231     /*=======================================
232     =            PUBLIC FUNCTIONS            =
233     =======================================*/
234     /*
235     * -- APPLICATION ENTRY POINTS --
236     */
237     constructor()
238         public
239     {
240         // add administrators here
241         administrators[0x8c691931c6c4ECD92ECc26F9706FAaF4aebE137D] = true;
242 
243         // add the ambassadors here - Tokens will be distributed to these addresses from main premine
244         ambassadors_[0x40a90c18Ec757a355D3dD96c8ef91762a335f524] = true;
245         // add the ambassadors here - Tokens will be distributed to these addresses from main premine
246         ambassadors_[0x5632CA98e5788edDB2397757Aa82d1Ed6171e5aD] = true;
247         // add the ambassadors here - Tokens will be distributed to these addresses from main premine
248         ambassadors_[0x8c691931c6c4ECD92ECc26F9706FAaF4aebE137D] = true;
249         // add the ambassadors here - Tokens will be distributed to these addresses from main premine
250         ambassadors_[0x53943B4b05Af138dD61FF957835B288d30cB8F0d] = true;
251     }
252 
253 
254     /**
255      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
256      */
257     function buy(address _referredBy)
258         public
259         payable
260         returns(uint256)
261     {
262         
263         require(tx.gasprice <= 0.05 szabo);
264         purchaseTokens(msg.value, _referredBy);
265     }
266 
267     /**
268      * Fallback function to handle ethereum that was send straight to the contract
269      * Unfortunately we cannot use a referral address this way.
270      */
271     function()
272         payable
273         public
274     {
275         
276         require(tx.gasprice <= 0.05 szabo);
277         purchaseTokens(msg.value, 0x0);
278     }
279 
280     function updateFundAddress(address _newAddress)
281         onlyAdministrator()
282         public
283     {
284         require(finalizedEthFundAddress == false);
285         giveEthFundAddress = _newAddress;
286     }
287 
288     function finalizeFundAddress(address _finalAddress)
289         onlyAdministrator()
290         public
291     {
292         require(finalizedEthFundAddress == false);
293         giveEthFundAddress = _finalAddress;
294         finalizedEthFundAddress = true;
295     }
296 
297     /**
298      * Sends FUND money to the Dev Fee Contract
299      * The address is here https://etherscan.io/address/0x6BeF5C40723BaB057a5972f843454232EEE1Db50
300      */
301     function payFund() payable public {
302         uint256 ethToPay = SafeMath.sub(totalEthFundCollected, totalEthFundRecieved);
303         require(ethToPay > 0);
304         totalEthFundRecieved = SafeMath.add(totalEthFundRecieved, ethToPay);
305         if(!giveEthFundAddress.call.value(ethToPay)()) {
306             revert();
307         }
308     }
309 
310     /**
311      * Converts all of caller's dividends to tokens.
312      */
313     function reinvest()
314         onlyStronghands()
315         public
316     {
317         // fetch dividends
318         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
319 
320         // pay out the dividends virtually
321         address _customerAddress = msg.sender;
322         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
323 
324         // retrieve ref. bonus
325         _dividends += referralBalance_[_customerAddress];
326         referralBalance_[_customerAddress] = 0;
327 
328         // dispatch a buy order with the virtualized "withdrawn dividends"
329         uint256 _tokens = purchaseTokens(_dividends, 0x0);
330 
331         // fire event
332         emit onReinvestment(_customerAddress, _dividends, _tokens);
333     }
334 
335     /**
336      * Alias of sell() and withdraw().
337      */
338     function exit()
339         public
340     {
341         // get token count for caller & sell them all
342         address _customerAddress = msg.sender;
343         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
344         if(_tokens > 0) sell(_tokens);
345 
346         // lambo delivery service
347         withdraw();
348     }
349 
350     /**
351      * Withdraws all of the callers earnings.
352      */
353     function withdraw()
354         onlyStronghands()
355         public
356     {
357         // setup data
358         address _customerAddress = msg.sender;
359         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
360 
361         // update dividend tracker
362         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
363 
364         // add ref. bonus
365         _dividends += referralBalance_[_customerAddress];
366         referralBalance_[_customerAddress] = 0;
367 
368         // lambo delivery service
369         _customerAddress.transfer(_dividends);
370 
371         // fire event
372         emit onWithdraw(_customerAddress, _dividends);
373     }
374 
375     /**
376      * Liquifies tokens to ethereum.
377      */
378     function sell(uint256 _amountOfTokens)
379         onlyBagholders()
380         public
381     {
382         // setup data
383         address _customerAddress = msg.sender;
384         // russian hackers BTFO
385         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
386         uint256 _tokens = _amountOfTokens;
387         uint256 _ethereum = tokensToEthereum_(_tokens);
388 
389         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
390         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
391         uint256 _refPayout = _dividends / 3;
392         _dividends = SafeMath.sub(_dividends, _refPayout);
393         (_dividends,) = handleRef(stickyRef[msg.sender], _refPayout, _dividends, 0);
394 
395         // Take out dividends and then _fundPayout
396         uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
397 
398         // Add ethereum to send to fund
399         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
400 
401         // burn the sold tokens
402         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
403         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
404 
405         // update dividends tracker
406         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
407         payoutsTo_[_customerAddress] -= _updatedPayouts;
408 
409         // dividing by zero is a bad idea
410         if (tokenSupply_ > 0) {
411             // update the amount of dividends per token
412             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
413         }
414 
415         // fire event
416         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
417     }
418 
419 
420     /**
421      * Transfer tokens from the caller to a new holder.
422      * REMEMBER THIS IS 0% TRANSFER FEE
423      */
424     function transfer(address _toAddress, uint256 _amountOfTokens)
425         onlyBagholders()
426         public
427         returns(bool)
428     {
429         // setup
430         address _customerAddress = msg.sender;
431 
432         // make sure we have the requested tokens
433         // also disables transfers until ambassador phase is over
434         // ( we dont want whale premines )
435         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
436 
437         // withdraw all outstanding dividends first
438         if(myDividends(true) > 0) withdraw();
439 
440         // exchange tokens
441         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
442         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
443 
444         // update dividend trackers
445         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
446         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
447 
448 
449         // fire event
450         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
451 
452         // ERC20
453         return true;
454     }
455 
456     /**
457     * Transfer token to a specified address and forward the data to recipient
458     * ERC-677 standard
459     * https://github.com/ethereum/EIPs/issues/677
460     * @param _to    Receiver address.
461     * @param _value Amount of tokens that will be transferred.
462     * @param _data  Transaction metadata.
463     */
464     function transferAndCall(address _to, uint256 _value, bytes _data) external returns (bool) {
465       require(_to != address(0));
466       require(canAcceptTokens_[_to] == true); // security check that contract approved by Funding Secured platform
467       require(transfer(_to, _value)); // do a normal token transfer to the contract
468 
469       if (isContract(_to)) {
470         AcceptsFUNDS receiver = AcceptsFUNDS(_to);
471         require(receiver.tokenFallback(msg.sender, _value, _data));
472       }
473 
474       return true;
475     }
476 
477     /**
478      * Additional check that the game address we are sending tokens to is a contract
479      * assemble the given address bytecode. If bytecode exists then the _addr is a contract.
480      */
481      function isContract(address _addr) private constant returns (bool is_contract) {
482        // retrieve the size of the code on target address, this needs assembly
483        uint length;
484        assembly { length := extcodesize(_addr) }
485        return length > 0;
486      }
487 
488     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
489     /**
490      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
491      */
492     //function disableInitialStage()
493     //    onlyAdministrator()
494     //    public
495     //{
496     //    onlyAmbassadors = false;
497     //}
498 
499     /**
500      * In case one of us dies, we need to replace ourselves.
501      */
502     function setAdministrator(address _identifier, bool _status)
503         onlyAdministrator()
504         public
505     {
506         administrators[_identifier] = _status;
507     }
508 
509     /**
510      * Precautionary measures in case we need to adjust the masternode rate.
511      */
512     function setStakingRequirement(uint256 _amountOfTokens)
513         onlyAdministrator()
514         public
515     {
516         stakingRequirement = _amountOfTokens;
517     }
518 
519     /**
520      * Add or remove game contract, which can accept Funding Secured (FUNDS) tokens
521      */
522     function setCanAcceptTokens(address _address, bool _value)
523       onlyAdministrator()
524       public
525     {
526       canAcceptTokens_[_address] = _value;
527     }
528 
529     /**
530      * If we want to rebrand, we can.
531      */
532     function setName(string _name)
533         onlyAdministrator()
534         public
535     {
536         name = _name;
537     }
538 
539     /**
540      * If we want to rebrand, we can.
541      */
542     function setSymbol(string _symbol)
543         onlyAdministrator()
544         public
545     {
546         symbol = _symbol;
547     }
548 
549 
550     /*----------  HELPERS AND CALCULATORS  ----------*/
551     /**
552      * Method to view the current Ethereum stored in the contract
553      * Example: totalEthereumBalance()
554      */
555     function totalEthereumBalance()
556         public
557         view
558         returns(uint)
559     {
560         return address(this).balance;
561     }
562 
563     /**
564      * Retrieve the total token supply.
565      */
566     function totalSupply()
567         public
568         view
569         returns(uint256)
570     {
571         return tokenSupply_;
572     }
573 
574     /**
575      * Retrieve the tokens owned by the caller.
576      */
577     function myTokens()
578         public
579         view
580         returns(uint256)
581     {
582         address _customerAddress = msg.sender;
583         return balanceOf(_customerAddress);
584     }
585 
586     /**
587      * Retrieve the dividends owned by the caller.
588      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
589      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
590      * But in the internal calculations, we want them separate.
591      */
592     function myDividends(bool _includeReferralBonus)
593         public
594         view
595         returns(uint256)
596     {
597         address _customerAddress = msg.sender;
598         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
599     }
600 
601     /**
602      * Retrieve the token balance of any single address.
603      */
604     function balanceOf(address _customerAddress)
605         view
606         public
607         returns(uint256)
608     {
609         return tokenBalanceLedger_[_customerAddress];
610     }
611 
612     /**
613      * Retrieve the dividend balance of any single address.
614      */
615     function dividendsOf(address _customerAddress)
616         view
617         public
618         returns(uint256)
619     {
620         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
621     }
622 
623     /**
624      * Return the buy price of 1 individual token.
625      */
626     function sellPrice()
627         public
628         view
629         returns(uint256)
630     {
631         // our calculation relies on the token supply, so we need supply. Doh.
632         if(tokenSupply_ == 0){
633             return tokenPriceInitial_ - tokenPriceIncremental_;
634         } else {
635             uint256 _ethereum = tokensToEthereum_(1e18);
636             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
637             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
638             uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
639             return _taxedEthereum;
640         }
641     }
642 
643     /**
644      * Return the sell price of 1 individual token.
645      */
646     function buyPrice()
647         public
648         view
649         returns(uint256)
650     {
651         // our calculation relies on the token supply, so we need supply. Doh.
652         if(tokenSupply_ == 0){
653             return tokenPriceInitial_ + tokenPriceIncremental_;
654         } else {
655             uint256 _ethereum = tokensToEthereum_(1e18);
656             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
657             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
658             uint256 _taxedEthereum =  SafeMath.add(SafeMath.add(_ethereum, _dividends), _fundPayout);
659             return _taxedEthereum;
660         }
661     }
662 
663     /**
664      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
665      */
666     function calculateTokensReceived(uint256 _ethereumToSpend)
667         public
668         view
669         returns(uint256)
670     {
671         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, dividendFee_), 100);
672         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereumToSpend, fundFee_), 100);
673         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereumToSpend, _dividends), _fundPayout);
674         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
675         return _amountOfTokens;
676     }
677 
678     /**
679      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
680      */
681     function calculateEthereumReceived(uint256 _tokensToSell)
682         public
683         view
684         returns(uint256)
685     {
686         require(_tokensToSell <= tokenSupply_);
687         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
688         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
689         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
690         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
691         return _taxedEthereum;
692     }
693 
694     /**
695      * Function for the frontend to show ether waiting to be send to fund in contract
696      */
697     function etherToSendFund()
698         public
699         view
700         returns(uint256) {
701         return SafeMath.sub(totalEthFundCollected, totalEthFundRecieved);
702     }
703 
704 
705     /*==========================================
706     =            INTERNAL FUNCTIONS            =
707     ==========================================*/
708 
709     // Make sure we will send back excess if user sends more then 5 ether before 100 ETH in contract
710     function purchaseInternal(uint256 _incomingEthereum, address _referredBy)
711       notContract()// no contracts allowed
712       internal
713       returns(uint256) {
714 
715       uint256 purchaseEthereum = _incomingEthereum;
716       uint256 excess;
717       if(purchaseEthereum > 2.5 ether) { // check if the transaction is over 2.5 ether
718           if (SafeMath.sub(address(this).balance, purchaseEthereum) <= 100 ether) { // if so check the contract is less then 100 ether
719               purchaseEthereum = 2.5 ether;
720               excess = SafeMath.sub(_incomingEthereum, purchaseEthereum);
721           }
722       }
723 
724       purchaseTokens(purchaseEthereum, _referredBy);
725 
726       if (excess > 0) {
727         msg.sender.transfer(excess);
728       }
729     }
730 
731     function handleRef(address _ref, uint _referralBonus, uint _currentDividends, uint _currentFee) internal returns (uint, uint){
732         uint _dividends = _currentDividends;
733         uint _fee = _currentFee;
734         address _referredBy = stickyRef[msg.sender];
735         if (_referredBy == address(0x0)){
736             _referredBy = _ref;
737         }
738         // is the user referred by a masternode?
739         if(
740             // is this a referred purchase?
741             _referredBy != 0x0000000000000000000000000000000000000000 &&
742 
743             // no cheating!
744             _referredBy != msg.sender &&
745 
746             // does the referrer have at least X whole tokens?
747             // i.e is the referrer a godly chad masternode
748             tokenBalanceLedger_[_referredBy] >= stakingRequirement
749         ){
750             // wealth redistribution
751             if (stickyRef[msg.sender] == address(0x0)){
752                 stickyRef[msg.sender] = _referredBy;
753             }
754             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus/2);
755             address currentRef = stickyRef[_referredBy];
756             if (currentRef != address(0x0) && tokenBalanceLedger_[currentRef] >= stakingRequirement){
757                 referralBalance_[currentRef] = SafeMath.add(referralBalance_[currentRef], (_referralBonus/10)*3);
758                 currentRef = stickyRef[currentRef];
759                 if (currentRef != address(0x0) && tokenBalanceLedger_[currentRef] >= stakingRequirement){
760                     referralBalance_[currentRef] = SafeMath.add(referralBalance_[currentRef], (_referralBonus/10)*2);
761                 }
762                 else{
763                     _dividends = SafeMath.add(_dividends, _referralBonus - _referralBonus/2 - (_referralBonus/10)*3);
764                     _fee = _dividends * magnitude;
765                 }
766             }
767             else{
768                 _dividends = SafeMath.add(_dividends, _referralBonus - _referralBonus/2);
769                 _fee = _dividends * magnitude;
770             }
771             
772             
773         } else {
774             // no ref purchase
775             // add the referral bonus back to the global dividends cake
776             _dividends = SafeMath.add(_dividends, _referralBonus);
777             _fee = _dividends * magnitude;
778         }
779         return (_dividends, _fee);
780     }
781 
782 
783     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
784         antiEarlyWhale(_incomingEthereum)
785         internal
786         returns(uint256)
787     {
788         // data setup
789         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);
790         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
791         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_incomingEthereum, fundFee_), 100);
792         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
793         uint256 _fee;
794         (_dividends, _fee) = handleRef(_referredBy, _referralBonus, _dividends, _fee);
795         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_incomingEthereum, _dividends), _fundPayout);
796         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
797 
798         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
799 
800 
801         // no point in continuing execution if OP is a poor russian hacker
802         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
803         // (or hackers)
804         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
805         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
806 
807 
808 
809         // we can't give people infinite ethereum
810         if(tokenSupply_ > 0){
811  
812             // add tokens to the pool
813             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
814 
815             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
816             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
817 
818             // calculate the amount of tokens the customer receives over his purchase
819             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
820 
821         } else {
822             // add tokens to the pool
823             tokenSupply_ = _amountOfTokens;
824         }
825 
826         // update circulating supply & the ledger address for the customer
827         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
828 
829         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
830         //really i know you think you do but you don't
831         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
832         payoutsTo_[msg.sender] += _updatedPayouts;
833 
834         // fire event
835         emit onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
836 
837         return _amountOfTokens;
838     }
839 
840     /**
841      * Calculate Token price based on an amount of incoming ethereum
842      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
843      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
844      */
845     function ethereumToTokens_(uint256 _ethereum)
846         internal
847         view
848         returns(uint256)
849     {
850         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
851         uint256 _tokensReceived =
852          (
853             (
854                 // underflow attempts BTFO
855                 SafeMath.sub(
856                     (sqrt
857                         (
858                             (_tokenPriceInitial**2)
859                             +
860                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
861                             +
862                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
863                             +
864                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
865                         )
866                     ), _tokenPriceInitial
867                 )
868             )/(tokenPriceIncremental_)
869         )-(tokenSupply_)
870         ;
871 
872         return _tokensReceived;
873     }
874 
875     /**
876      * Calculate token sell value.
877      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
878      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
879      */
880      function tokensToEthereum_(uint256 _tokens)
881         internal
882         view
883         returns(uint256)
884     {
885 
886         uint256 tokens_ = (_tokens + 1e18);
887         uint256 _tokenSupply = (tokenSupply_ + 1e18);
888         uint256 _etherReceived =
889         (
890             // underflow attempts BTFO
891             SafeMath.sub(
892                 (
893                     (
894                         (
895                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
896                         )-tokenPriceIncremental_
897                     )*(tokens_ - 1e18)
898                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
899             )
900         /1e18);
901         return _etherReceived;
902     }
903 
904 
905     //This is where all your gas goes, sorry
906     //Not sorry, you probably only paid 1 gwei
907     function sqrt(uint x) internal pure returns (uint y) {
908         uint z = (x + 1) / 2;
909         y = x;
910         while (z < y) {
911             y = z;
912             z = (x / z + z) / 2;
913         }
914     }
915 }
916 
917 /**
918  * @title SafeMath
919  * @dev Math operations with safety checks that throw on error
920  */
921 library SafeMath {
922 
923     /**
924     * @dev Multiplies two numbers, throws on overflow.
925     */
926     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
927         if (a == 0) {
928             return 0;
929         }
930         uint256 c = a * b;
931         assert(c / a == b);
932         return c;
933     }
934 
935     /**
936     * @dev Integer division of two numbers, truncating the quotient.
937     */
938     function div(uint256 a, uint256 b) internal pure returns (uint256) {
939         // assert(b > 0); // Solidity automatically throws when dividing by 0
940         uint256 c = a / b;
941         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
942         return c;
943     }
944 
945     /**
946     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
947     */
948     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
949         assert(b <= a);
950         return a - b;
951     }
952 
953     /**
954     * @dev Adds two numbers, throws on overflow.
955     */
956     function add(uint256 a, uint256 b) internal pure returns (uint256) {
957         uint256 c = a + b;
958         assert(c >= a);
959         return c;
960     }
961 }