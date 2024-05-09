1 pragma solidity ^0.4.24;
2 
3 /*
4 ******************** https://doubledivs.cash/exchange/ *********************
5 *                                  
6 *      _______   ______    __    __  .______    __       _______                       
7 *     |       \ /  __  \  |  |  |  | |   _  \  |  |     |   ____|                      
8 *     |  .--.  |  |  |  | |  |  |  | |  |_)  | |  |     |  |__                         
9 *     |  |  |  |  |  |  | |  |  |  | |   _  <  |  |     |   __|                        
10 *     |  '--'  |  `--'  | |  `--'  | |  |_)  | |  `----.|  |____                       
11 *     |_______/ \______/   \______/  |______/  |_______||_______|                                                 
12 *      _______   __  ____    ____   _______.                                           
13 *     |       \ |  | \   \  /   /  /       |                                           
14 *     |  .--.  ||  |  \   \/   /  |   (----`                                           
15 *     |  |  |  ||  |   \      /    \   \                                               
16 *     |  '--'  ||  |    \    / .----)   |                                              
17 *     |_______/ |__|     \__/  |_______/                                                                                                                                
18 *      __________   ___   ______  __    __       ___      .__   __.   _______  _______ 
19 *     |   ____\  \ /  /  /      ||  |  |  |     /   \     |  \ |  |  /  _____||   ____|
20 *     |  |__   \  V  /  |  ,----'|  |__|  |    /  ^  \    |   \|  | |  |  __  |  |__   
21 *     |   __|   >   <   |  |     |   __   |   /  /_\  \   |  . `  | |  | |_ | |   __|  
22 *     |  |____ /  .  \  |  `----.|  |  |  |  /  _____  \  |  |\   | |  |__| | |  |____ 
23 *     |_______/__/ \__\  \______||__|  |__| /__/     \__\ |__| \__|  \______| |_______|
24 *                                                                                       
25 *     DOUBLEDIVS 50% DIVIDENDS. FOREVER.
26 *     
27 *     https://doubledivs.cash/
28 *     https://doubledivs.cash/exchange/
29 *
30 ******************** https://doubledivs.cash/exchange/ *********************
31 *
32 *
33 * [x] 25% Exchange fee (Split to Token Divs + Double Divs + Referral)
34 * [x] 18% Dividends to all DDIVS holders
35 * [x] 5% Dividends to Double Divs
36 * [x] 0% Account transfer fees
37 * [x] 2% To Dev Fund for future development costs
38 * [x] Double Divs Dividend Account: 0x85EcbC22e9c0Ad0c1Cb3F4465582493bADc50433
39 * [x] Multi-tier Masternode system for exchange buys and sells (3 levels)
40 * [x] Refferal approximate % breakdown (4% for 1st, 2.4% for 2nd, 1.6% 3rd)
41 * [x] Double Divs (DDIVS) Token can be used for future games
42 *
43 * Official Website: https://doubledivs.cash/
44 * Official Exchange: https://doubledivs.cash/exchange
45 * Official Discord: https://discord.gg/YRTWtJ6
46 * Official Twitter: https://twitter.com/DoubleDivs
47 * Official Telegram: https://t.me/DoubleDivs
48 */
49 
50 
51 /**
52  * Definition of contract accepting Double Divs (DDIVS) tokens
53  * Games or any other innovative platforms can reuse this contract to support Double Divs (DDIVS) tokens
54  */
55 contract AcceptsDDIVS {
56     DDIVS public tokenContract;
57 
58     constructor(address _tokenContract) public {
59         tokenContract = DDIVS(_tokenContract);
60     }
61 
62     modifier onlyTokenContract {
63         require(msg.sender == address(tokenContract));
64         _;
65     }
66 
67     /**
68     * @dev Standard ERC677 function that will handle incoming token transfers.
69     *
70     * @param _from  Token sender address.
71     * @param _value Amount of tokens.
72     * @param _data  Transaction metadata.
73     */
74     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
75 }
76 
77 
78 contract DDIVS {
79     /*=================================
80     =            MODIFIERS            =
81     =================================*/
82     // only people with tokens
83     modifier onlyBagholders() {
84         require(myTokens() > 0);
85         _;
86     }
87 
88     // only people with profits
89     modifier onlyStronghands() {
90         require(myDividends(true) > 0);
91         _;
92     }
93 
94     modifier notContract() {
95       require (msg.sender == tx.origin);
96       _;
97     }
98 
99     // administrators can:
100     // -> change the name of the contract
101     // -> change the name of the token
102     // -> change the PoS difficulty (How many tokens it costs to hold a masternode)
103     // they CANNOT:
104     // -> take funds
105     // -> disable withdrawals
106     // -> kill the contract
107     // -> change the price of tokens
108     modifier onlyAdministrator(){
109         address _customerAddress = msg.sender;
110         require(administrators[_customerAddress]);
111         _;
112     }
113     
114     uint ACTIVATION_TIME = 1538028000;
115 
116 
117     // ensures that the first tokens in the contract will be equally distributed
118     // meaning, no divine dump will be ever possible
119     // result: healthy longevity.
120     modifier antiEarlyWhale(uint256 _amountOfEthereum){
121         address _customerAddress = msg.sender;
122         
123         if (now >= ACTIVATION_TIME) {
124             onlyAmbassadors = false;
125         }
126 
127         // are we still in the vulnerable phase?
128         // if so, enact anti early whale protocol
129         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
130             require(
131                 // is the customer in the ambassador list?
132                 ambassadors_[_customerAddress] == true &&
133 
134                 // does the customer purchase exceed the max ambassador quota?
135                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
136 
137             );
138 
139             // updated the accumulated quota
140             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
141 
142             // execute
143             _;
144         } else {
145             // in case the ether count drops low, the ambassador phase won't reinitiate
146             onlyAmbassadors = false;
147             _;
148         }
149 
150     }
151 
152     /*==============================
153     =            EVENTS            =
154     ==============================*/
155     event onTokenPurchase(
156         address indexed customerAddress,
157         uint256 incomingEthereum,
158         uint256 tokensMinted,
159         address indexed referredBy
160     );
161 
162     event onTokenSell(
163         address indexed customerAddress,
164         uint256 tokensBurned,
165         uint256 ethereumEarned
166     );
167 
168     event onReinvestment(
169         address indexed customerAddress,
170         uint256 ethereumReinvested,
171         uint256 tokensMinted
172     );
173 
174     event onWithdraw(
175         address indexed customerAddress,
176         uint256 ethereumWithdrawn
177     );
178 
179     // ERC20
180     event Transfer(
181         address indexed from,
182         address indexed to,
183         uint256 tokens
184     );
185 
186 
187     /*=====================================
188     =            CONFIGURABLES            =
189     =====================================*/
190     string public name = "DDIVS";
191     string public symbol = "DDIVS";
192     uint8 constant public decimals = 18;
193     uint8 constant internal dividendFee_ = 18; // 18% dividend fee for double divs tokens on each buy and sell
194     uint8 constant internal fundFee_ = 7; // 7% investment fund fee to buy double divs on each buy and sell
195     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
196     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
197     uint256 constant internal magnitude = 2**64;
198 
199     // Address to send the 1% Fee
200     address public giveEthFundAddress = 0x85EcbC22e9c0Ad0c1Cb3F4465582493bADc50433;
201     bool public finalizedEthFundAddress = false;
202     uint256 public totalEthFundRecieved; // total ETH charity recieved from this contract
203     uint256 public totalEthFundCollected; // total ETH charity collected in this contract
204 
205     // proof of stake (defaults at 100 tokens)
206     uint256 public stakingRequirement = 25e18;
207 
208     // ambassador program
209     mapping(address => bool) internal ambassadors_;
210     uint256 constant internal ambassadorMaxPurchase_ = 0.75 ether;
211     uint256 constant internal ambassadorQuota_ = 1.5 ether;
212 
213 
214 
215    /*================================
216     =            DATASETS            =
217     ================================*/
218     // amount of shares for each address (scaled number)
219     mapping(address => uint256) internal tokenBalanceLedger_;
220     mapping(address => uint256) internal referralBalance_;
221     mapping(address => int256) internal payoutsTo_;
222     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
223     uint256 internal tokenSupply_ = 0;
224     uint256 internal profitPerShare_;
225 
226     // administrator list (see above on what they can do)
227     mapping(address => bool) public administrators;
228 
229     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
230     bool public onlyAmbassadors = true;
231 
232     // Special Double Divs Platform control from scam game contracts on Double Divs platform
233     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept Double Divs tokens
234 
235     mapping(address => address) public stickyRef;
236 
237     /*=======================================
238     =            PUBLIC FUNCTIONS            =
239     =======================================*/
240     /*
241     * -- APPLICATION ENTRY POINTS --
242     */
243     constructor()
244         public
245     {
246         // add administrators here
247         administrators[0x28F0088308CDc140C2D72fBeA0b8e529cAA5Cb40] = true;
248 
249         // add the ambassadors here - Tokens will be distributed to these addresses from main premine
250         ambassadors_[0x41FE3738B503cBaFD01C1Fd8DD66b7fE6Ec11b01] = true;
251         // add the ambassadors here - Tokens will be distributed to these addresses from main premine
252         ambassadors_[0x28F0088308CDc140C2D72fBeA0b8e529cAA5Cb40] = true;
253     }
254 
255 
256     /**
257      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
258      */
259     function buy(address _referredBy)
260         public
261         payable
262         returns(uint256)
263     {
264         
265         require(tx.gasprice <= 0.05 szabo);
266         purchaseTokens(msg.value, _referredBy);
267     }
268 
269     /**
270      * Fallback function to handle ethereum that was send straight to the contract
271      * Unfortunately we cannot use a referral address this way.
272      */
273     function()
274         payable
275         public
276     {
277         
278         require(tx.gasprice <= 0.05 szabo);
279         purchaseTokens(msg.value, 0x0);
280     }
281 
282     function updateFundAddress(address _newAddress)
283         onlyAdministrator()
284         public
285     {
286         require(finalizedEthFundAddress == false);
287         giveEthFundAddress = _newAddress;
288     }
289 
290     function finalizeFundAddress(address _finalAddress)
291         onlyAdministrator()
292         public
293     {
294         require(finalizedEthFundAddress == false);
295         giveEthFundAddress = _finalAddress;
296         finalizedEthFundAddress = true;
297     }
298 
299     /**
300      * Sends FUND money to the Dev Fee Contract
301      * The address is here https://etherscan.io/address/0x85EcbC22e9c0Ad0c1Cb3F4465582493bADc50433
302      */
303     function payFund() payable public {
304         uint256 ethToPay = SafeMath.sub(totalEthFundCollected, totalEthFundRecieved);
305         require(ethToPay > 0);
306         totalEthFundRecieved = SafeMath.add(totalEthFundRecieved, ethToPay);
307         if(!giveEthFundAddress.call.value(ethToPay)()) {
308             revert();
309         }
310     }
311 
312     /**
313      * Converts all of caller's dividends to tokens.
314      */
315     function reinvest()
316         onlyStronghands()
317         public
318     {
319         // fetch dividends
320         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
321 
322         // pay out the dividends virtually
323         address _customerAddress = msg.sender;
324         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
325 
326         // retrieve ref. bonus
327         _dividends += referralBalance_[_customerAddress];
328         referralBalance_[_customerAddress] = 0;
329 
330         // dispatch a buy order with the virtualized "withdrawn dividends"
331         uint256 _tokens = purchaseTokens(_dividends, 0x0);
332 
333         // fire event
334         emit onReinvestment(_customerAddress, _dividends, _tokens);
335     }
336 
337     /**
338      * Alias of sell() and withdraw().
339      */
340     function exit()
341         public
342     {
343         // get token count for caller & sell them all
344         address _customerAddress = msg.sender;
345         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
346         if(_tokens > 0) sell(_tokens);
347 
348         // lambo delivery service
349         withdraw();
350     }
351 
352     /**
353      * Withdraws all of the callers earnings.
354      */
355     function withdraw()
356         onlyStronghands()
357         public
358     {
359         // setup data
360         address _customerAddress = msg.sender;
361         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
362 
363         // update dividend tracker
364         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
365 
366         // add ref. bonus
367         _dividends += referralBalance_[_customerAddress];
368         referralBalance_[_customerAddress] = 0;
369 
370         // lambo delivery service
371         _customerAddress.transfer(_dividends);
372 
373         // fire event
374         emit onWithdraw(_customerAddress, _dividends);
375     }
376 
377     /**
378      * Liquifies tokens to ethereum.
379      */
380     function sell(uint256 _amountOfTokens)
381         onlyBagholders()
382         public
383     {
384         // setup data
385         address _customerAddress = msg.sender;
386         // russian hackers BTFO
387         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
388         uint256 _tokens = _amountOfTokens;
389         uint256 _ethereum = tokensToEthereum_(_tokens);
390 
391         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
392         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
393         uint256 _refPayout = _dividends / 3;
394         _dividends = SafeMath.sub(_dividends, _refPayout);
395         (_dividends,) = handleRef(stickyRef[msg.sender], _refPayout, _dividends, 0);
396 
397         // Take out dividends and then _fundPayout
398         uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
399 
400         // Add ethereum to send to fund
401         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
402 
403         // burn the sold tokens
404         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
405         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
406 
407         // update dividends tracker
408         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
409         payoutsTo_[_customerAddress] -= _updatedPayouts;
410 
411         // dividing by zero is a bad idea
412         if (tokenSupply_ > 0) {
413             // update the amount of dividends per token
414             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
415         }
416 
417         // fire event
418         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
419     }
420 
421 
422     /**
423      * Transfer tokens from the caller to a new holder.
424      * REMEMBER THIS IS 0% TRANSFER FEE
425      */
426     function transfer(address _toAddress, uint256 _amountOfTokens)
427         onlyBagholders()
428         public
429         returns(bool)
430     {
431         // setup
432         address _customerAddress = msg.sender;
433 
434         // make sure we have the requested tokens
435         // also disables transfers until ambassador phase is over
436         // ( we dont want whale premines )
437         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
438 
439         // withdraw all outstanding dividends first
440         if(myDividends(true) > 0) withdraw();
441 
442         // exchange tokens
443         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
444         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
445 
446         // update dividend trackers
447         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
448         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
449 
450 
451         // fire event
452         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
453 
454         // ERC20
455         return true;
456     }
457 
458     /**
459     * Transfer token to a specified address and forward the data to recipient
460     * ERC-677 standard
461     * https://github.com/ethereum/EIPs/issues/677
462     * @param _to    Receiver address.
463     * @param _value Amount of tokens that will be transferred.
464     * @param _data  Transaction metadata.
465     */
466     function transferAndCall(address _to, uint256 _value, bytes _data) external returns (bool) {
467       require(_to != address(0));
468       require(canAcceptTokens_[_to] == true); // security check that contract approved by Double Divs platform
469       require(transfer(_to, _value)); // do a normal token transfer to the contract
470 
471       if (isContract(_to)) {
472         AcceptsDDIVS receiver = AcceptsDDIVS(_to);
473         require(receiver.tokenFallback(msg.sender, _value, _data));
474       }
475 
476       return true;
477     }
478 
479     /**
480      * Additional check that the game address we are sending tokens to is a contract
481      * assemble the given address bytecode. If bytecode exists then the _addr is a contract.
482      */
483      function isContract(address _addr) private constant returns (bool is_contract) {
484        // retrieve the size of the code on target address, this needs assembly
485        uint length;
486        assembly { length := extcodesize(_addr) }
487        return length > 0;
488      }
489 
490     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
491     /**
492      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
493      */
494     //function disableInitialStage()
495     //    onlyAdministrator()
496     //    public
497     //{
498     //    onlyAmbassadors = false;
499     //}
500 
501     /**
502      * In case one of us dies, we need to replace ourselves.
503      */
504     function setAdministrator(address _identifier, bool _status)
505         onlyAdministrator()
506         public
507     {
508         administrators[_identifier] = _status;
509     }
510 
511     /**
512      * Precautionary measures in case we need to adjust the masternode rate.
513      */
514     function setStakingRequirement(uint256 _amountOfTokens)
515         onlyAdministrator()
516         public
517     {
518         stakingRequirement = _amountOfTokens;
519     }
520 
521     /**
522      * Add or remove game contract, which can accept Double Divs (DDIVS) tokens
523      */
524     function setCanAcceptTokens(address _address, bool _value)
525       onlyAdministrator()
526       public
527     {
528       canAcceptTokens_[_address] = _value;
529     }
530 
531     /**
532      * If we want to rebrand, we can.
533      */
534     function setName(string _name)
535         onlyAdministrator()
536         public
537     {
538         name = _name;
539     }
540 
541     /**
542      * If we want to rebrand, we can.
543      */
544     function setSymbol(string _symbol)
545         onlyAdministrator()
546         public
547     {
548         symbol = _symbol;
549     }
550 
551 
552     /*----------  HELPERS AND CALCULATORS  ----------*/
553     /**
554      * Method to view the current Ethereum stored in the contract
555      * Example: totalEthereumBalance()
556      */
557     function totalEthereumBalance()
558         public
559         view
560         returns(uint)
561     {
562         return address(this).balance;
563     }
564 
565     /**
566      * Retrieve the total token supply.
567      */
568     function totalSupply()
569         public
570         view
571         returns(uint256)
572     {
573         return tokenSupply_;
574     }
575 
576     /**
577      * Retrieve the tokens owned by the caller.
578      */
579     function myTokens()
580         public
581         view
582         returns(uint256)
583     {
584         address _customerAddress = msg.sender;
585         return balanceOf(_customerAddress);
586     }
587 
588     /**
589      * Retrieve the dividends owned by the caller.
590      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
591      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
592      * But in the internal calculations, we want them separate.
593      */
594     function myDividends(bool _includeReferralBonus)
595         public
596         view
597         returns(uint256)
598     {
599         address _customerAddress = msg.sender;
600         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
601     }
602 
603     /**
604      * Retrieve the token balance of any single address.
605      */
606     function balanceOf(address _customerAddress)
607         view
608         public
609         returns(uint256)
610     {
611         return tokenBalanceLedger_[_customerAddress];
612     }
613 
614     /**
615      * Retrieve the dividend balance of any single address.
616      */
617     function dividendsOf(address _customerAddress)
618         view
619         public
620         returns(uint256)
621     {
622         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
623     }
624 
625     /**
626      * Return the buy price of 1 individual token.
627      */
628     function sellPrice()
629         public
630         view
631         returns(uint256)
632     {
633         // our calculation relies on the token supply, so we need supply. Doh.
634         if(tokenSupply_ == 0){
635             return tokenPriceInitial_ - tokenPriceIncremental_;
636         } else {
637             uint256 _ethereum = tokensToEthereum_(1e18);
638             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
639             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
640             uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
641             return _taxedEthereum;
642         }
643     }
644 
645     /**
646      * Return the sell price of 1 individual token.
647      */
648     function buyPrice()
649         public
650         view
651         returns(uint256)
652     {
653         // our calculation relies on the token supply, so we need supply. Doh.
654         if(tokenSupply_ == 0){
655             return tokenPriceInitial_ + tokenPriceIncremental_;
656         } else {
657             uint256 _ethereum = tokensToEthereum_(1e18);
658             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
659             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
660             uint256 _taxedEthereum =  SafeMath.add(SafeMath.add(_ethereum, _dividends), _fundPayout);
661             return _taxedEthereum;
662         }
663     }
664 
665     /**
666      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
667      */
668     function calculateTokensReceived(uint256 _ethereumToSpend)
669         public
670         view
671         returns(uint256)
672     {
673         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, dividendFee_), 100);
674         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereumToSpend, fundFee_), 100);
675         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereumToSpend, _dividends), _fundPayout);
676         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
677         return _amountOfTokens;
678     }
679 
680     /**
681      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
682      */
683     function calculateEthereumReceived(uint256 _tokensToSell)
684         public
685         view
686         returns(uint256)
687     {
688         require(_tokensToSell <= tokenSupply_);
689         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
690         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
691         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
692         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
693         return _taxedEthereum;
694     }
695 
696     /**
697      * Function for the frontend to show ether waiting to be send to fund in contract
698      */
699     function etherToSendFund()
700         public
701         view
702         returns(uint256) {
703         return SafeMath.sub(totalEthFundCollected, totalEthFundRecieved);
704     }
705 
706 
707     /*==========================================
708     =            INTERNAL FUNCTIONS            =
709     ==========================================*/
710 
711     // Make sure we will send back excess if user sends more then 5 ether before 100 ETH in contract
712     function purchaseInternal(uint256 _incomingEthereum, address _referredBy)
713       notContract()// no contracts allowed
714       internal
715       returns(uint256) {
716 
717       uint256 purchaseEthereum = _incomingEthereum;
718       uint256 excess;
719       if(purchaseEthereum > 2.5 ether) { // check if the transaction is over 2.5 ether
720           if (SafeMath.sub(address(this).balance, purchaseEthereum) <= 100 ether) { // if so check the contract is less then 100 ether
721               purchaseEthereum = 2.5 ether;
722               excess = SafeMath.sub(_incomingEthereum, purchaseEthereum);
723           }
724       }
725 
726       purchaseTokens(purchaseEthereum, _referredBy);
727 
728       if (excess > 0) {
729         msg.sender.transfer(excess);
730       }
731     }
732 
733     function handleRef(address _ref, uint _referralBonus, uint _currentDividends, uint _currentFee) internal returns (uint, uint){
734         uint _dividends = _currentDividends;
735         uint _fee = _currentFee;
736         address _referredBy = stickyRef[msg.sender];
737         if (_referredBy == address(0x0)){
738             _referredBy = _ref;
739         }
740         // is the user referred by a masternode?
741         if(
742             // is this a referred purchase?
743             _referredBy != 0x0000000000000000000000000000000000000000 &&
744 
745             // no cheating!
746             _referredBy != msg.sender &&
747 
748             // does the referrer have at least X whole tokens?
749             // i.e is the referrer a godly chad masternode
750             tokenBalanceLedger_[_referredBy] >= stakingRequirement
751         ){
752             // wealth redistribution
753             if (stickyRef[msg.sender] == address(0x0)){
754                 stickyRef[msg.sender] = _referredBy;
755             }
756             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus/2);
757             address currentRef = stickyRef[_referredBy];
758             if (currentRef != address(0x0) && tokenBalanceLedger_[currentRef] >= stakingRequirement){
759                 referralBalance_[currentRef] = SafeMath.add(referralBalance_[currentRef], (_referralBonus/10)*3);
760                 currentRef = stickyRef[currentRef];
761                 if (currentRef != address(0x0) && tokenBalanceLedger_[currentRef] >= stakingRequirement){
762                     referralBalance_[currentRef] = SafeMath.add(referralBalance_[currentRef], (_referralBonus/10)*2);
763                 }
764                 else{
765                     _dividends = SafeMath.add(_dividends, _referralBonus - _referralBonus/2 - (_referralBonus/10)*3);
766                     _fee = _dividends * magnitude;
767                 }
768             }
769             else{
770                 _dividends = SafeMath.add(_dividends, _referralBonus - _referralBonus/2);
771                 _fee = _dividends * magnitude;
772             }
773             
774             
775         } else {
776             // no ref purchase
777             // add the referral bonus back to the global dividends cake
778             _dividends = SafeMath.add(_dividends, _referralBonus);
779             _fee = _dividends * magnitude;
780         }
781         return (_dividends, _fee);
782     }
783 
784 
785     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
786         antiEarlyWhale(_incomingEthereum)
787         internal
788         returns(uint256)
789     {
790         // data setup
791         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);
792         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
793         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_incomingEthereum, fundFee_), 100);
794         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
795         uint256 _fee;
796         (_dividends, _fee) = handleRef(_referredBy, _referralBonus, _dividends, _fee);
797         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_incomingEthereum, _dividends), _fundPayout);
798         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
799 
800         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
801 
802 
803         // no point in continuing execution if OP is a poor russian hacker
804         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
805         // (or hackers)
806         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
807         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
808 
809 
810 
811         // we can't give people infinite ethereum
812         if(tokenSupply_ > 0){
813  
814             // add tokens to the pool
815             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
816 
817             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
818             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
819 
820             // calculate the amount of tokens the customer receives over his purchase
821             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
822 
823         } else {
824             // add tokens to the pool
825             tokenSupply_ = _amountOfTokens;
826         }
827 
828         // update circulating supply & the ledger address for the customer
829         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
830 
831         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
832         //really i know you think you do but you don't
833         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
834         payoutsTo_[msg.sender] += _updatedPayouts;
835 
836         // fire event
837         emit onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
838 
839         return _amountOfTokens;
840     }
841 
842     /**
843      * Calculate Token price based on an amount of incoming ethereum
844      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
845      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
846      */
847     function ethereumToTokens_(uint256 _ethereum)
848         internal
849         view
850         returns(uint256)
851     {
852         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
853         uint256 _tokensReceived =
854          (
855             (
856                 // underflow attempts BTFO
857                 SafeMath.sub(
858                     (sqrt
859                         (
860                             (_tokenPriceInitial**2)
861                             +
862                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
863                             +
864                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
865                             +
866                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
867                         )
868                     ), _tokenPriceInitial
869                 )
870             )/(tokenPriceIncremental_)
871         )-(tokenSupply_)
872         ;
873 
874         return _tokensReceived;
875     }
876 
877     /**
878      * Calculate token sell value.
879      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
880      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
881      */
882      function tokensToEthereum_(uint256 _tokens)
883         internal
884         view
885         returns(uint256)
886     {
887 
888         uint256 tokens_ = (_tokens + 1e18);
889         uint256 _tokenSupply = (tokenSupply_ + 1e18);
890         uint256 _etherReceived =
891         (
892             // underflow attempts BTFO
893             SafeMath.sub(
894                 (
895                     (
896                         (
897                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
898                         )-tokenPriceIncremental_
899                     )*(tokens_ - 1e18)
900                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
901             )
902         /1e18);
903         return _etherReceived;
904     }
905 
906 
907     //This is where all your gas goes, sorry
908     //Not sorry, you probably only paid 1 gwei
909     function sqrt(uint x) internal pure returns (uint y) {
910         uint z = (x + 1) / 2;
911         y = x;
912         while (z < y) {
913             y = z;
914             z = (x / z + z) / 2;
915         }
916     }
917 }
918 
919 /**
920  * @title SafeMath
921  * @dev Math operations with safety checks that throw on error
922  */
923 library SafeMath {
924 
925     /**
926     * @dev Multiplies two numbers, throws on overflow.
927     */
928     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
929         if (a == 0) {
930             return 0;
931         }
932         uint256 c = a * b;
933         assert(c / a == b);
934         return c;
935     }
936 
937     /**
938     * @dev Integer division of two numbers, truncating the quotient.
939     */
940     function div(uint256 a, uint256 b) internal pure returns (uint256) {
941         // assert(b > 0); // Solidity automatically throws when dividing by 0
942         uint256 c = a / b;
943         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
944         return c;
945     }
946 
947     /**
948     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
949     */
950     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
951         assert(b <= a);
952         return a - b;
953     }
954 
955     /**
956     * @dev Adds two numbers, throws on overflow.
957     */
958     function add(uint256 a, uint256 b) internal pure returns (uint256) {
959         uint256 c = a + b;
960         assert(c >= a);
961         return c;
962     }
963 }