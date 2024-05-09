1 pragma solidity ^0.4.21;
2 
3 
4 /*
5 ******************** DividendFacial.Site *********************
6 
7 *
8 *
9 * [x] 0% TRANSFER FEES
10 * [x] 25% DIVIDENDS AND MASTERNODES
11 * [x] 5% FEE ON EACH BUY AND SELL GO TO Smart Contract Fund 0x5e4b7b9365bce0bebb7d22790cc3470edcdcf980
12 *     How 5% is divided and used: 
13 *     90% to Buy Tokens from the exchange to be transferred to DFT Surplus and fund other DividendFacial Games
14 *     10% to Dev Fund For Platform Development
15 * [x] Only 1 DFT Token is needed to have a masternode! This allows virtually anyone to earn via buys from their masternode!
16 * [x] DividendFacialTokens can be used for future games
17 *
18 * Official Website: https://dividendfacial.site/ 
19 * Official Discord: https://discord.gg/UCTWT6C
20 */
21 
22 /**
23  * Definition of contract accepting DividendFacial tokens
24  * DFT Lending and other games can reuse this contract to support DividendFacial tokens
25  */
26 contract AcceptsDividendFacial {
27     DividendFacial public tokenContract;
28 
29     function AcceptsDividendFacial(address _tokenContract) public {
30         tokenContract = DividendFacial(_tokenContract);
31     }
32 
33     modifier onlyTokenContract {
34         require(msg.sender == address(tokenContract));
35         _;
36     }
37 
38     /**
39     * @dev Standard ERC677 function that will handle incoming token transfers.
40     *
41     * @param _from  Token sender address.
42     * @param _value Amount of tokens.
43     * @param _data  Transaction metadata.
44     */
45     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
46 }
47 
48 
49 contract DividendFacial {
50     /*=================================
51     =            MODIFIERS            =
52     =================================*/
53     // only people with tokens
54     modifier onlyBagholders() {
55         require(myTokens() > 0);
56         _;
57     }
58 
59     // only people with profits
60     modifier onlyStronghands() {
61         require(myDividends(true) > 0);
62         _;
63     }
64 
65     modifier notContract() {
66       require (msg.sender == tx.origin);
67       _;
68     }
69 
70     // administrators can:
71     // -> change the name of the contract
72     // -> change the name of the token
73     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
74     // they CANNOT:
75     // -> take funds
76     // -> disable withdrawals
77     // -> kill the contract
78     // -> change the price of tokens
79     modifier onlyAdministrator(){
80         address _customerAddress = msg.sender;
81         require(administrators[_customerAddress]);
82         _;
83     }
84     
85     uint ACTIVATION_TIME = 1539730800;
86 
87 
88     // ensures that the first tokens in the contract will be equally distributed
89     // meaning, no divine dump will be ever possible
90     // result: healthy longevity.
91     modifier antiEarlyWhale(uint256 _amountOfEthereum){
92         address _customerAddress = msg.sender;
93         
94         if (now >= ACTIVATION_TIME) {
95             onlyAmbassadors = false;
96         }
97 
98         // are we still in the vulnerable phase?
99         // if so, enact anti early whale protocol
100         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
101             require(
102                 // is the customer in the ambassador list?
103                 ambassadors_[_customerAddress] == true &&
104 
105                 // does the customer purchase exceed the max ambassador quota?
106                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
107 
108             );
109 
110             // updated the accumulated quota
111             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
112 
113             // execute
114             _;
115         } else {
116             // in case the ether count drops low, the ambassador phase won't reinitiate
117             onlyAmbassadors = false;
118             _;
119         }
120 
121     }
122 
123     /*==============================
124     =            EVENTS            =
125     ==============================*/
126     event onTokenPurchase(
127         address indexed customerAddress,
128         uint256 incomingEthereum,
129         uint256 tokensMinted,
130         address indexed referredBy
131     );
132 
133     event onTokenSell(
134         address indexed customerAddress,
135         uint256 tokensBurned,
136         uint256 ethereumEarned
137     );
138 
139     event onReinvestment(
140         address indexed customerAddress,
141         uint256 ethereumReinvested,
142         uint256 tokensMinted
143     );
144 
145     event onWithdraw(
146         address indexed customerAddress,
147         uint256 ethereumWithdrawn
148     );
149 
150     // ERC20
151     event Transfer(
152         address indexed from,
153         address indexed to,
154         uint256 tokens
155     );
156 
157 
158     /*=====================================
159     =            CONFIGURABLES            =
160     =====================================*/
161     string public name = "DividendFacial";
162     string public symbol = "DFT";
163     uint8 constant public decimals = 18;
164     uint8 constant internal dividendFee_ = 25; // 25% dividend fee on each buy and sell
165     uint8 constant internal fundFee_ = 5; // 5% fund tax on buys/sells/reinvest (split 80/20)
166     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
167     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
168     uint256 constant internal magnitude = 2**64;
169 
170     
171     // 80/20 FUND TAX CONTRACT ADDRESS
172     address constant public giveEthFundAddress = 0x5e4b7b9365bce0bebb7d22790cc3470edcdcf980;
173     uint256 public totalEthFundRecieved; // total ETH FUND recieved from this contract
174     uint256 public totalEthFundCollected; // total ETH FUND collected in this contract
175 
176     // proof of stake (defaults at 100 tokens)
177     uint256 public stakingRequirement = 1e18;
178 
179     // ambassador program
180     mapping(address => bool) internal ambassadors_;
181     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
182     uint256 constant internal ambassadorQuota_ = 8 ether;
183 
184 
185 
186    /*================================
187     =            DATASETS            =
188     ================================*/
189     // amount of shares for each address (scaled number)
190     mapping(address => uint256) internal tokenBalanceLedger_;
191     mapping(address => uint256) internal referralBalance_;
192     mapping(address => int256) internal payoutsTo_;
193     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
194     uint256 internal tokenSupply_ = 0;
195     uint256 internal profitPerShare_;
196 
197     // administrator list (see above on what they can do)
198     mapping(address => bool) public administrators;
199 
200     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
201     bool public onlyAmbassadors = true;
202 
203     // Special DividendFacial Platform control from scam game contracts on DividendFacial platform
204     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept DividendFacial tokens
205 
206 
207 
208     /*=======================================
209     =            PUBLIC FUNCTIONS            =
210     =======================================*/
211     /*
212     * -- APPLICATION ENTRY POINTS --
213     */
214     function DividendFacial()
215         public
216     {
217         // add administrators here
218         administrators[0x92daddea0e089bb3eb0838e4ad78b3389fb9752e] = true;
219         
220         // admin
221         ambassadors_[0x92daddea0e089bb3eb0838e4ad78b3389fb9752e] = true;
222 
223         // Lucky Whale. One Discord member will win these private keys: https://discord.gg/UCTWT6C
224         ambassadors_[0xabd751a7637b922573885a0af0e1a57f84b9f2ed] = true;
225         
226         // Oracle-Join his discord: https://discord.gg/xsPGdCf
227         ambassadors_[0x41FE3738B503cBaFD01C1Fd8DD66b7fE6Ec11b01] = true;
228         
229         // Phil, Crypto Gamer Extraordinaire https://discord.gg/6bu3Wu9
230         ambassadors_[0x183feBd8828a9ac6c70C0e27FbF441b93004fC05] = true;
231         
232         // Yobo, Investment Games Gangsta https://discord.gg/c3qGczu
233         ambassadors_[0x190a2409fc6434483d4c2cab804e75e3bc5ebfa6] = true;
234         
235         // Blery 
236         ambassadors_[0x260BB292817c668caF44Eb4c7A281A1ef3DDbbf3] = true;
237         
238         //  
239         ambassadors_[0xCd39c70f9DF2A0D216c3A52C5A475914485a0625] = true;
240         
241         // Blery 
242         ambassadors_[0x260BB292817c668caF44Eb4c7A281A1ef3DDbbf3] = true;
243         
244         
245         
246         
247     }
248 
249 
250     /**
251      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
252      */
253     function buy(address _referredBy)
254         public
255         payable
256         returns(uint256)
257     {
258         
259         require(tx.gasprice <= 0.05 szabo);
260         purchaseInternal(msg.value, _referredBy);
261     }
262 
263     /**
264      * Fallback function to handle ethereum that was send straight to the contract
265      * Unfortunately we cannot use a referral address this way.
266      */
267     function()
268         payable
269         public
270     {
271         
272         require(tx.gasprice <= 0.01 szabo);
273         purchaseInternal(msg.value, 0x0);
274     }
275 
276     /**
277      * Sends FUND TAX to the FUND TAX addres. (Remember 90% of the Fund is used to support DFT Lending and other platform games)
278      * This is the FUND TAX address that splits the ETH (90/10): https://etherscan.io/address/0x5e4b7b9365bce0bebb7d22790cc3470edcdcf980
279      */
280     function payFund() payable public {
281       uint256 ethToPay = SafeMath.sub(totalEthFundCollected, totalEthFundRecieved);
282       require(ethToPay > 1);
283       totalEthFundRecieved = SafeMath.add(totalEthFundRecieved, ethToPay);
284       if(!giveEthFundAddress.call.value(ethToPay).gas(400000)()) {
285          totalEthFundRecieved = SafeMath.sub(totalEthFundRecieved, ethToPay);
286       }
287     }
288 
289     /**
290      * Converts all of caller's dividends to tokens.
291      */
292     function reinvest()
293         onlyStronghands()
294         public
295     {
296         // fetch dividends
297         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
298 
299         // pay out the dividends virtually
300         address _customerAddress = msg.sender;
301         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
302 
303         // retrieve ref. bonus
304         _dividends += referralBalance_[_customerAddress];
305         referralBalance_[_customerAddress] = 0;
306 
307         // dispatch a buy order with the virtualized "withdrawn dividends"
308         uint256 _tokens = purchaseTokens(_dividends, 0x0);
309 
310         // fire event
311         onReinvestment(_customerAddress, _dividends, _tokens);
312     }
313 
314     /**
315      * Alias of sell() and withdraw().
316      */
317     function exit()
318         public
319     {
320         // get token count for caller & sell them all
321         address _customerAddress = msg.sender;
322         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
323         if(_tokens > 0) sell(_tokens);
324 
325         // lambo delivery service
326         withdraw();
327     }
328 
329     /**
330      * Withdraws all of the callers earnings.
331      */
332     function withdraw()
333         onlyStronghands()
334         public
335     {
336         // setup data
337         address _customerAddress = msg.sender;
338         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
339 
340         // update dividend tracker
341         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
342 
343         // add ref. bonus
344         _dividends += referralBalance_[_customerAddress];
345         referralBalance_[_customerAddress] = 0;
346 
347         // lambo delivery service
348         _customerAddress.transfer(_dividends);
349 
350         // fire event
351         onWithdraw(_customerAddress, _dividends);
352     }
353 
354     /**
355      * Liquifies tokens to ethereum.
356      */
357     function sell(uint256 _amountOfTokens)
358         onlyBagholders()
359         public
360     {
361         // setup data
362         address _customerAddress = msg.sender;
363         // russian hackers BTFO
364         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
365         uint256 _tokens = _amountOfTokens;
366         uint256 _ethereum = tokensToEthereum_(_tokens);
367 
368         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
369         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
370 
371         // Take out dividends and then _fundPayout
372         uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
373 
374         // Add ethereum to send to Fund Tax Contract
375         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
376 
377         // burn the sold tokens
378         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
379         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
380 
381         // update dividends tracker
382         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
383         payoutsTo_[_customerAddress] -= _updatedPayouts;
384 
385         // dividing by zero is a bad idea
386         if (tokenSupply_ > 0) {
387             // update the amount of dividends per token
388             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
389         }
390 
391         // fire event
392         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
393     }
394 
395 
396     /**
397      * Transfer tokens from the caller to a new holder.
398      * REMEMBER THIS IS 0% TRANSFER FEE
399      */
400     function transfer(address _toAddress, uint256 _amountOfTokens)
401         onlyBagholders()
402         public
403         returns(bool)
404     {
405         // setup
406         address _customerAddress = msg.sender;
407 
408         // make sure we have the requested tokens
409         // also disables transfers until ambassador phase is over
410         // ( we dont want whale premines )
411         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
412 
413         // withdraw all outstanding dividends first
414         if(myDividends(true) > 0) withdraw();
415 
416         // exchange tokens
417         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
418         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
419 
420         // update dividend trackers
421         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
422         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
423 
424 
425         // fire event
426         Transfer(_customerAddress, _toAddress, _amountOfTokens);
427 
428         // ERC20
429         return true;
430     }
431 
432     /**
433     * Transfer token to a specified address and forward the data to recipient
434     * ERC-677 standard
435     * https://github.com/ethereum/EIPs/issues/677
436     * @param _to    Receiver address.
437     * @param _value Amount of tokens that will be transferred.
438     * @param _data  Transaction metadata.
439     */
440     function transferAndCall(address _to, uint256 _value, bytes _data) external returns (bool) {
441       require(_to != address(0));
442       require(canAcceptTokens_[_to] == true); // security check that contract approved by DividendFacial platform
443       require(transfer(_to, _value)); // do a normal token transfer to the contract
444 
445       if (isContract(_to)) {
446         AcceptsDividendFacial receiver = AcceptsDividendFacial(_to);
447         require(receiver.tokenFallback(msg.sender, _value, _data));
448       }
449 
450       return true;
451     }
452 
453     /**
454      * Additional check that the game address we are sending tokens to is a contract
455      * assemble the given address bytecode. If bytecode exists then the _addr is a contract.
456      */
457      function isContract(address _addr) private constant returns (bool is_contract) {
458        // retrieve the size of the code on target address, this needs assembly
459        uint length;
460        assembly { length := extcodesize(_addr) }
461        return length > 0;
462      }
463 
464     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
465     /**
466      * In case the ambassador quota is not met, the administrator can manually disable the ambassador phase.
467      */
468     //function disableInitialStage()
469     //    onlyAdministrator()
470     //    public
471     //{
472     //    onlyAmbassadors = false;
473     //}
474 
475     /**
476      * In case one of us dies, we need to replace ourselves.
477      */
478     function setAdministrator(address _identifier, bool _status)
479         onlyAdministrator()
480         public
481     {
482         administrators[_identifier] = _status;
483     }
484 
485     /**
486      * Precautionary measures in case we need to adjust the masternode rate.
487      */
488     function setStakingRequirement(uint256 _amountOfTokens)
489         onlyAdministrator()
490         public
491     {
492         stakingRequirement = _amountOfTokens;
493     }
494 
495     /**
496      * Add or remove game contract, which can accept DividendFacial tokens
497      */
498     function setCanAcceptTokens(address _address, bool _value)
499       onlyAdministrator()
500       public
501     {
502       canAcceptTokens_[_address] = _value;
503     }
504 
505     /**
506      * If we want to rebrand, we can.
507      */
508     function setName(string _name)
509         onlyAdministrator()
510         public
511     {
512         name = _name;
513     }
514 
515     /**
516      * If we want to rebrand, we can.
517      */
518     function setSymbol(string _symbol)
519         onlyAdministrator()
520         public
521     {
522         symbol = _symbol;
523     }
524 
525 
526     /*----------  HELPERS AND CALCULATORS  ----------*/
527     /**
528      * Method to view the current Ethereum stored in the contract
529      * Example: totalEthereumBalance()
530      */
531     function totalEthereumBalance()
532         public
533         view
534         returns(uint)
535     {
536         return this.balance;
537     }
538 
539     /**
540      * Retrieve the total token supply.
541      */
542     function totalSupply()
543         public
544         view
545         returns(uint256)
546     {
547         return tokenSupply_;
548     }
549 
550     /**
551      * Retrieve the tokens owned by the caller.
552      */
553     function myTokens()
554         public
555         view
556         returns(uint256)
557     {
558         address _customerAddress = msg.sender;
559         return balanceOf(_customerAddress);
560     }
561 
562     /**
563      * Retrieve the dividends owned by the caller.
564      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
565      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
566      * But in the internal calculations, we want them separate.
567      */
568     function myDividends(bool _includeReferralBonus)
569         public
570         view
571         returns(uint256)
572     {
573         address _customerAddress = msg.sender;
574         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
575     }
576 
577     /**
578      * Retrieve the token balance of any single address.
579      */
580     function balanceOf(address _customerAddress)
581         view
582         public
583         returns(uint256)
584     {
585         return tokenBalanceLedger_[_customerAddress];
586     }
587 
588     /**
589      * Retrieve the dividend balance of any single address.
590      */
591     function dividendsOf(address _customerAddress)
592         view
593         public
594         returns(uint256)
595     {
596         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
597     }
598 
599     /**
600      * Return the buy price of 1 individual token.
601      */
602     function sellPrice()
603         public
604         view
605         returns(uint256)
606     {
607         // our calculation relies on the token supply, so we need supply. Doh.
608         if(tokenSupply_ == 0){
609             return tokenPriceInitial_ - tokenPriceIncremental_;
610         } else {
611             uint256 _ethereum = tokensToEthereum_(1e18);
612             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
613             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
614             uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
615             return _taxedEthereum;
616         }
617     }
618 
619     /**
620      * Return the sell price of 1 individual token.
621      */
622     function buyPrice()
623         public
624         view
625         returns(uint256)
626     {
627         // our calculation relies on the token supply, so we need supply. Doh.
628         if(tokenSupply_ == 0){
629             return tokenPriceInitial_ + tokenPriceIncremental_;
630         } else {
631             uint256 _ethereum = tokensToEthereum_(1e18);
632             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
633             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
634             uint256 _taxedEthereum =  SafeMath.add(SafeMath.add(_ethereum, _dividends), _fundPayout);
635             return _taxedEthereum;
636         }
637     }
638 
639     /**
640      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
641      */
642     function calculateTokensReceived(uint256 _ethereumToSpend)
643         public
644         view
645         returns(uint256)
646     {
647         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, dividendFee_), 100);
648         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereumToSpend, fundFee_), 100);
649         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereumToSpend, _dividends), _fundPayout);
650         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
651         return _amountOfTokens;
652     }
653 
654     /**
655      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
656      */
657     function calculateEthereumReceived(uint256 _tokensToSell)
658         public
659         view
660         returns(uint256)
661     {
662         require(_tokensToSell <= tokenSupply_);
663         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
664         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
665         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
666         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
667         return _taxedEthereum;
668     }
669 
670     /**
671      * Function for the frontend to show ether waiting to be sent to Fund Contract from the exchange contract
672      */
673     function etherToSendFund()
674         public
675         view
676         returns(uint256) {
677         return SafeMath.sub(totalEthFundCollected, totalEthFundRecieved);
678     }
679 
680 
681     /*==========================================
682     =            INTERNAL FUNCTIONS            =
683     ==========================================*/
684 
685     // Make sure we will send back excess if user sends more then 2 ether before 200 ETH in contract
686     function purchaseInternal(uint256 _incomingEthereum, address _referredBy)
687       notContract()// no contracts allowed
688       internal
689       returns(uint256) {
690 
691       uint256 purchaseEthereum = _incomingEthereum;
692       uint256 excess;
693       if(purchaseEthereum > 2 ether) { // check if the transaction is over 2 ether
694           if (SafeMath.sub(address(this).balance, purchaseEthereum) <= 200 ether) { // if so check the contract is less then 200 ether
695               purchaseEthereum = 2 ether;
696               excess = SafeMath.sub(_incomingEthereum, purchaseEthereum);
697           }
698       }
699 
700       purchaseTokens(purchaseEthereum, _referredBy);
701 
702       if (excess > 0) {
703         msg.sender.transfer(excess);
704       }
705     }
706 
707 
708     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
709         antiEarlyWhale(_incomingEthereum)
710         internal
711         returns(uint256)
712     {
713         // data setup
714         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);
715         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
716         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_incomingEthereum, fundFee_), 100);
717         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
718         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_incomingEthereum, _undividedDividends), _fundPayout);
719 
720         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
721 
722         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
723         uint256 _fee = _dividends * magnitude;
724 
725         // no point in continuing execution if OP is a poorfag russian hacker
726         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
727         // (or hackers)
728         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
729         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
730 
731         // is the user referred by a masternode?
732         if(
733             // is this a referred purchase?
734             _referredBy != 0x0000000000000000000000000000000000000000 &&
735 
736             // no cheating!
737             _referredBy != msg.sender &&
738 
739             // does the referrer have at least X whole tokens?
740             // i.e is the referrer a godly chad masternode
741             tokenBalanceLedger_[_referredBy] >= stakingRequirement
742         ){
743             // wealth redistribution
744             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
745         } else {
746             // no ref purchase
747             // add the referral bonus back to the global dividends cake
748             _dividends = SafeMath.add(_dividends, _referralBonus);
749             _fee = _dividends * magnitude;
750         }
751 
752         // we can't give people infinite ethereum
753         if(tokenSupply_ > 0){
754 
755             // add tokens to the pool
756             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
757 
758             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
759             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
760 
761             // calculate the amount of tokens the customer receives over his purchase
762             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
763 
764         } else {
765             // add tokens to the pool
766             tokenSupply_ = _amountOfTokens;
767         }
768 
769         // update circulating supply & the ledger address for the customer
770         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
771 
772         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
773         //really i know you think you do but you don't
774         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
775         payoutsTo_[msg.sender] += _updatedPayouts;
776 
777         // fire event
778         onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
779 
780         return _amountOfTokens;
781     }
782 
783     /**
784      * Calculate Token price based on an amount of incoming ethereum
785      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
786      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
787      */
788     function ethereumToTokens_(uint256 _ethereum)
789         internal
790         view
791         returns(uint256)
792     {
793         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
794         uint256 _tokensReceived =
795          (
796             (
797                 // underflow attempts BTFO
798                 SafeMath.sub(
799                     (sqrt
800                         (
801                             (_tokenPriceInitial**2)
802                             +
803                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
804                             +
805                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
806                             +
807                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
808                         )
809                     ), _tokenPriceInitial
810                 )
811             )/(tokenPriceIncremental_)
812         )-(tokenSupply_)
813         ;
814 
815         return _tokensReceived;
816     }
817 
818     /**
819      * Calculate token sell value.
820      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
821      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
822      */
823      function tokensToEthereum_(uint256 _tokens)
824         internal
825         view
826         returns(uint256)
827     {
828 
829         uint256 tokens_ = (_tokens + 1e18);
830         uint256 _tokenSupply = (tokenSupply_ + 1e18);
831         uint256 _etherReceived =
832         (
833             // underflow attempts BTFO
834             SafeMath.sub(
835                 (
836                     (
837                         (
838                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
839                         )-tokenPriceIncremental_
840                     )*(tokens_ - 1e18)
841                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
842             )
843         /1e18);
844         return _etherReceived;
845     }
846 
847 
848     //This is where all your gas goes, sorry
849     //Not sorry, you probably only paid 1 gwei
850     function sqrt(uint x) internal pure returns (uint y) {
851         uint z = (x + 1) / 2;
852         y = x;
853         while (z < y) {
854             y = z;
855             z = (x / z + z) / 2;
856         }
857     }
858 }
859 
860 /**
861  * @title SafeMath
862  * @dev Math operations with safety checks that throw on error
863  */
864 library SafeMath {
865 
866     /**
867     * @dev Multiplies two numbers, throws on overflow.
868     */
869     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
870         if (a == 0) {
871             return 0;
872         }
873         uint256 c = a * b;
874         assert(c / a == b);
875         return c;
876     }
877 
878     /**
879     * @dev Integer division of two numbers, truncating the quotient.
880     */
881     function div(uint256 a, uint256 b) internal pure returns (uint256) {
882         // assert(b > 0); // Solidity automatically throws when dividing by 0
883         uint256 c = a / b;
884         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
885         return c;
886     }
887 
888     /**
889     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
890     */
891     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
892         assert(b <= a);
893         return a - b;
894     }
895 
896     /**
897     * @dev Adds two numbers, throws on overflow.
898     */
899     function add(uint256 a, uint256 b) internal pure returns (uint256) {
900         uint256 c = a + b;
901         assert(c >= a);
902         return c;
903     }
904 }