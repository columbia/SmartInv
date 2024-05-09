1 pragma solidity ^0.4.21;
2 
3 /*
4 
5 
6   ______ .______     ____    ____ .______   .___________.  ______      ____    __    ____  ___      .______          _______.
7  /      ||   _  \    \   \  /   / |   _  \  |           | /  __  \     \   \  /  \  /   / /   \     |   _  \        /       |
8 |  ,----'|  |_)  |    \   \/   /  |  |_)  | `---|  |----`|  |  |  |     \   \/    \/   / /  ^  \    |  |_)  |      |   (----`
9 |  |     |      /      \_    _/   |   ___/      |  |     |  |  |  |      \            / /  /_\  \   |      /        \   \    
10 |  `----.|  |\  \----.   |  |     |  |          |  |     |  `--'  |       \    /\    / /  _____  \  |  |\  \----.----)   |   
11  \______|| _| `._____|   |__|     | _|          |__|      \______/         \__/  \__/ /__/     \__\ | _| `._____|_______/    
12                                                                                                                              
13 
14 website:    https://cryptowars.ga
15 
16 discord:    https://discord.gg/8AFP9gS
17 
18 25% Dividends Fees/Payouts
19 
20 Crypto Warriors Card Game is also included in the contract and played on the same page as the Exchange
21 
22 2% of Fees go into the card game insurance accounts for card holders that face a half-life cut
23 
24 5% of all Card gains go to Card insurance accounts
25 
26 Referral Program pays out 33% of Buy/Sell Fees to user of masternode link
27 
28 */
29 
30 contract AcceptsExchange {
31     cryptowars public tokenContract;
32 
33     function AcceptsExchange(address _tokenContract) public {
34         tokenContract = cryptowars(_tokenContract);
35     }
36 
37     modifier onlyTokenContract {
38         require(msg.sender == address(tokenContract));
39         _;
40     }
41 
42     /**
43     * @dev Standard ERC677 function that will handle incoming token transfers.
44     *
45     * @param _from  Token sender address.
46     * @param _value Amount of tokens.
47     * @param _data  Transaction metadata.
48     */
49     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
50     function tokenFallbackExpanded(address _from, uint256 _value, bytes _data, address _sender, address _referrer) external returns (bool);
51 }
52 
53 contract cryptowars {
54     /*=================================
55     =            MODIFIERS            =
56     =================================*/
57     // only people with tokens
58     modifier onlyBagholders() {
59         require(myTokens() > 0);
60         _;
61     }
62     
63     // only people with profits
64     modifier onlyStronghands() {
65         require(myDividends(true) > 0 || ownerAccounts[msg.sender] > 0);
66         //require(myDividends(true) > 0);
67         _;
68     }
69     
70       modifier notContract() {
71       require (msg.sender == tx.origin);
72       _;
73     }
74 
75     modifier allowPlayer(){
76         
77         require(boolAllowPlayer);
78         _;
79     }
80 
81     // administrators can:
82     // -> change the name of the contract
83     // -> change the name of the token
84     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
85     // they CANNOT:
86     // -> take funds
87     // -> disable withdrawals
88     // -> kill the contract
89     // -> change the price of tokens
90     modifier onlyAdministrator(){
91         address _customerAddress = msg.sender;
92         require(administrators[_customerAddress]);
93         _;
94     }
95     
96     modifier onlyActive(){
97         require(boolContractActive);
98         _;
99     }
100 
101      modifier onlyCardActive(){
102         require(boolCardActive);
103         _;
104     }
105 
106     
107     // ensures that the first tokens in the contract will be equally distributed
108     // meaning, no divine dump will be ever possible
109     // result: healthy longevity.
110     modifier antiEarlyWhale(uint256 _amountOfEthereum){
111         address _customerAddress = msg.sender;
112         
113         // are we still in the vulnerable phase?
114         // if so, enact anti early whale protocol 
115         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
116             require(
117                 // is the customer in the ambassador list?
118                 (ambassadors_[_customerAddress] == true &&
119                 
120                 // does the customer purchase exceed the max ambassador quota?
121                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_) ||
122 
123                 (_customerAddress == dev)
124                 
125             );
126             
127             // updated the accumulated quota    
128             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
129         
130             // execute
131             _;
132         } else {
133             // in case the ether count drops low, the ambassador phase won't reinitiate
134             onlyAmbassadors = false;
135             _;    
136         }
137         
138     }
139     
140     /*==============================
141     =            EVENTS            =
142     ==============================*/
143 
144     event onCardBuy(
145         address customerAddress,
146         uint256 incomingEthereum,
147         uint256 card,
148         uint256 newPrice,
149         uint256 halfLifeTime
150     );
151 
152     event onInsuranceChange(
153         address customerAddress,
154         uint256 card,
155         uint256 insuranceAmount
156     );
157 
158     event onTokenPurchase(
159         address indexed customerAddress,
160         uint256 incomingEthereum,
161         uint256 tokensMinted,
162         address indexed referredBy
163     );
164     
165     event onTokenSell(
166         address indexed customerAddress,
167         uint256 tokensBurned,
168         uint256 ethereumEarned
169     );
170     
171     event onReinvestment(
172         address indexed customerAddress,
173         uint256 ethereumReinvested,
174         uint256 tokensMinted
175     );
176     
177     event onWithdraw(
178         address indexed customerAddress,
179         uint256 ethereumWithdrawn
180     );
181     
182     // ERC20
183     event Transfer(
184         address indexed from,
185         address indexed to,
186         uint256 tokens
187     );
188     
189        // HalfLife
190     event Halflife(
191         address customerAddress,
192         uint card,
193         uint price,
194         uint newBlockTime,
195         uint insurancePay,
196         uint cardInsurance
197     );
198     
199     /*=====================================
200     =            CONFIGURABLES            =
201     =====================================*/
202     string public name = "CryptoWars";
203     string public symbol = "JEDI";
204     uint8 constant public decimals = 18;
205     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
206     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
207     uint256 constant internal magnitude = 2**64;
208     
209     // proof of stake (defaults at 100 tokens)
210     uint256 public stakingRequirement = 100e18;
211     
212     // ambassador program
213     mapping(address => bool) internal ambassadors_;
214     uint256 constant internal ambassadorMaxPurchase_ = 3 ether;
215     uint256 constant internal ambassadorQuota_ = 20 ether;
216     
217     address dev;
218 
219     uint nextAvailableCard;
220 
221     address add2 = 0x0;
222 
223     uint public totalCardValue = 0;
224 
225     uint public totalCardInsurance = 0;
226 
227     bool public boolAllowPlayer = false;
228     
229     
230    /*================================
231     =            DATASETS            =
232     ================================*/
233     // amount of shares for each address (scaled number)
234     mapping(address => uint256) internal tokenBalanceLedger_;
235     mapping(address => uint256) internal referralBalance_;
236     mapping(address => int256) internal payoutsTo_;
237     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
238     uint256 internal tokenSupply_ = 0;
239     uint256 internal profitPerShare_;
240 
241     //CARDS
242     mapping(uint => address) internal cardOwner;
243     mapping(uint => uint) public cardPrice;
244     mapping(uint => uint) public basePrice;
245     mapping(uint => uint) internal cardPreviousPrice;
246     mapping(address => uint) internal ownerAccounts;
247     mapping(uint => uint) internal totalCardDivs;
248     mapping(uint => uint) internal totalCardDivsETH;
249     mapping(uint => string) internal cardName;
250     mapping(uint => uint) internal cardInsurance;
251 
252     uint public cardInsuranceAccount;
253 
254     uint cardPriceIncrement = 1250;   //25% Price Increases
255    
256     uint totalDivsProduced;
257 
258     //card rates
259     uint public ownerDivRate = 500;
260     uint public distDivRate = 400;
261     uint public devDivRate = 50;
262     uint public insuranceDivRate = 50;
263     uint public referralRate = 50;
264     
265 
266 
267 
268     mapping(uint => uint) internal cardBlockNumber;
269 
270     uint public halfLifeTime = 5900;            //1 day half life period
271     uint public halfLifeRate = 900;             //cut price by 1/10 each half life period
272     uint public halfLifeReductionRate = 667;    //cut previous price by 1/3
273 
274     bool public allowHalfLife = true;  //for cards
275 
276     bool public allowReferral = false;  //for cards
277 
278     uint public insurancePayoutRate = 250; //pay 25% of the remaining insurance fund for that card on each half-life
279 
280    
281     address inv1 = 0x387E7E1580BbE37a06d847985faD20f353bBeB1b;
282     address inv2 = 0xD87fA3D0cF18fD2C14Aa34BcdeaF252Bf4d56644;
283     address inv3 = 0xc4166D533336cf49b85b3897D7315F5bB60E420b;
284 
285 
286     uint8 public dividendFee_ = 200; // 20% dividend fee on each buy and sell dividendFee_
287     uint8 public cardInsuranceFeeRate_ = 20;//20; // 2% fee rate on each buy and sell for Giants Card Insurance
288     uint8 public investorFeeRate_ = 10;//10; // 1% fee for investors
289 
290     uint public maxCards = 50;
291 
292     bool public boolContractActive = false;
293     bool public boolCardActive = false;
294 
295     // administrator list (see above on what they can do)
296     mapping(address => bool) public administrators;
297     
298     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
299     bool public onlyAmbassadors = true;
300 
301       // Special Wall Street Market Platform control from scam game contracts on Wall Street Market platform
302     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept Wall Street tokens
303 
304 
305     /*=======================================
306     =            PUBLIC FUNCTIONS            =
307     =======================================*/
308     /*
309     * -- APPLICATION ENTRY POINTS --  
310     */
311     function cryptowars()
312         public
313     {
314         allowHalfLife = true;
315         allowReferral = false;
316 
317         // add administrators here
318         administrators[msg.sender] = true;
319 
320         dev = msg.sender;
321 
322         ambassadors_[dev] = true;
323         ambassadors_[inv1] = true;
324         ambassadors_[inv2] = true;
325         ambassadors_[inv3] = true;
326 
327         ambassadors_[0x96762288ebb2560a19F8eAdAaa2012504F64278B] = true;
328         ambassadors_[0x5145A296e1bB9d4Cf468d6d97d7B6D15700f39EF] = true;
329         ambassadors_[0xE74b1ea522B9d558C8e8719c3b1C4A9050b531CA] = true;
330         ambassadors_[0xb62A0AC2338C227748E3Ce16d137C6282c9870cF] = true;
331         ambassadors_[0x836e5abac615b371efce0ab399c22a04c1db5ecf] = true;
332         ambassadors_[0xAe3dC7FA07F9dD030fa56C027E90998eD9Fe9D61] = true;
333         ambassadors_[0x38602d1446fe063444B04C3CA5eCDe0cbA104240] = true;
334         ambassadors_[0x3825c8BA07166f34cE9a2cD1e08A68b105c82cB9] = true;
335         ambassadors_[0xa6662191F558e4C611c8f14b50c784EDA9Ace98d] = true;
336         
337 
338         nextAvailableCard = 13;
339 
340         cardOwner[1] = dev;
341         cardPrice[1] = 5 ether;
342         basePrice[1] = cardPrice[1];
343         cardPreviousPrice[1] = 0;
344 
345         cardOwner[2] = dev;
346         cardPrice[2] = 4 ether;
347         basePrice[2] = cardPrice[2];
348         cardPreviousPrice[2] = 0;
349 
350         cardOwner[3] = dev;
351         cardPrice[3] = 3 ether;
352         basePrice[3] = cardPrice[3];
353         cardPreviousPrice[3] = 0;
354 
355         cardOwner[4] = dev;
356         cardPrice[4] = 2 ether;
357         basePrice[4] = cardPrice[4];
358         cardPreviousPrice[4] = 0;
359 
360         cardOwner[5] = dev;
361         cardPrice[5] = 1.5 ether;
362         basePrice[5] = cardPrice[5];
363         cardPreviousPrice[5] = 0;
364 
365         cardOwner[6] = 0xb62A0AC2338C227748E3Ce16d137C6282c9870cF;
366         cardPrice[6] = 1 ether;
367         basePrice[6] = cardPrice[6];
368         cardPreviousPrice[6] = 0;
369 
370         cardOwner[7] = 0x96762288ebb2560a19f8eadaaa2012504f64278b;
371         cardPrice[7] = 0.8 ether;
372         basePrice[7] = cardPrice[7];
373         cardPreviousPrice[7] = 0;
374 
375         cardOwner[8] = 0x836e5abac615b371efce0ab399c22a04c1db5ecf;
376         cardPrice[8] = 0.6 ether;
377         basePrice[8] = cardPrice[8];
378         cardPreviousPrice[8] = 0;
379 
380         cardOwner[9] = 0xAe3dC7FA07F9dD030fa56C027E90998eD9Fe9D61;
381         cardPrice[9] = 0.4 ether;
382         basePrice[9] = cardPrice[9];
383         cardPreviousPrice[9] = 0;
384 
385         cardOwner[10] = dev;
386         cardPrice[10] = 0.2 ether;
387         basePrice[10] = cardPrice[10];
388         cardPreviousPrice[10] = 0;
389 
390         cardOwner[11] = dev;
391         cardPrice[11] = 0.1 ether;
392         basePrice[11] = cardPrice[11];
393         cardPreviousPrice[11] = 0;
394 
395         cardOwner[12] = dev;
396         cardPrice[12] = 0.1 ether;
397         basePrice[12] = cardPrice[12];
398         cardPreviousPrice[12] = 0;
399 
400         getTotalCardValue();
401 
402     }
403     
404      
405     /**
406      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
407      */
408     function buy(address _referredBy)
409         public
410         payable
411         returns(uint256)
412     {
413         purchaseTokens(msg.value, _referredBy);
414     }
415     
416     /**
417      * Fallback function to handle ethereum that was send straight to the contract
418      * Unfortunately we cannot use a referral address this way.
419      */
420     function()
421         payable
422         public
423     {
424         purchaseTokens(msg.value, 0x0);
425     }
426     
427     /**
428      * Converts all of caller's dividends to tokens.
429      */
430     function reinvest()
431         onlyStronghands()
432         public
433     {
434         // fetch dividends
435         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
436         
437         // pay out the dividends virtually
438         address _customerAddress = msg.sender;
439         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
440         
441         // retrieve ref. bonus
442         _dividends += referralBalance_[_customerAddress] + ownerAccounts[_customerAddress];
443         referralBalance_[_customerAddress] = 0;
444         ownerAccounts[_customerAddress] = 0;
445         
446         // dispatch a buy order with the virtualized "withdrawn dividends"
447         uint256 _tokens = purchaseTokens(_dividends, 0x0);
448         
449         // fire event
450         onReinvestment(_customerAddress, _dividends, _tokens);
451     }
452     
453     /**
454      * Alias of sell() and withdraw().
455      */
456     function exit()
457         public
458     {
459         // get token count for caller & sell them all
460         address _customerAddress = msg.sender;
461         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
462         if(_tokens > 0) sell(_tokens);
463         
464         // lambo delivery service
465         withdraw();
466     }
467 
468     /**
469      * Withdraws all of the callers earnings.
470      */
471     function withdraw()
472         onlyStronghands()
473         public
474     {
475         // setup data
476         address _customerAddress = msg.sender;
477         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
478         
479         // update dividend tracker
480         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
481         
482         // add ref. bonus
483         _dividends += referralBalance_[_customerAddress] + ownerAccounts[_customerAddress];
484         referralBalance_[_customerAddress] = 0;
485         ownerAccounts[_customerAddress] = 0;
486         
487         // lambo delivery service
488         _customerAddress.transfer(_dividends);
489         
490         // fire event
491         onWithdraw(_customerAddress, _dividends);
492     }
493     
494     /**
495      * Liquifies tokens to ethereum.
496      */
497     function sell(uint256 _amountOfTokens)
498         onlyBagholders()
499         public
500     {
501         // setup data
502         address _customerAddress = msg.sender;
503         // russian hackers BTFO
504         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
505         uint256 _tokens = _amountOfTokens;
506         uint256 _ethereum = tokensToEthereum_(_tokens);
507         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_),1000);
508        // uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
509         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
510         
511         // burn the sold tokens
512         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
513         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
514         
515         // update dividends tracker
516         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
517         payoutsTo_[_customerAddress] -= _updatedPayouts;       
518         
519         // dividing by zero is a bad idea
520         if (tokenSupply_ > 0) {
521             // update the amount of dividends per token
522             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
523         }
524 
525         checkHalfLife();
526         
527         // fire event
528         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
529     }
530     
531     
532     /**
533      * Transfer tokens from the caller to a new holder.
534      * Remember, there's a 10% fee here as well.
535      */
536     function transfer(address _toAddress, uint256 _amountOfTokens)
537         onlyBagholders()
538         public
539         returns(bool)
540     {
541         // setup
542         address _customerAddress = msg.sender;
543         
544         // make sure we have the requested tokens
545         // also disables transfers until ambassador phase is over
546         // ( we dont want whale premines )
547         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
548         
549         // withdraw all outstanding dividends first
550         if(myDividends(true) > 0) withdraw();
551         
552         // liquify 20% of the tokens that are transfered
553         // these are dispersed to shareholders
554         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, dividendFee_),1000);
555         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
556         uint256 _dividends = tokensToEthereum_(_tokenFee);
557   
558         // burn the fee tokens
559         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
560 
561         // exchange tokens
562         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
563         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
564         
565         // update dividend trackers
566         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
567         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
568         
569         // disperse dividends among holders
570         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
571         
572         // fire event
573         Transfer(_customerAddress, _toAddress, _taxedTokens);
574         
575         // ERC20
576         return true;
577        
578     }
579     
580     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
581     /**
582      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
583      */
584     function disableInitialStage()
585         onlyAdministrator()
586         public
587     {
588         onlyAmbassadors = false;
589     }
590     
591     /**
592      * In case one of us dies, we need to replace ourselves.
593      */
594     function setAdministrator(address _identifier, bool _status)
595         onlyAdministrator()
596         public
597     {
598         administrators[_identifier] = _status;
599     }
600 
601     function setAllowHalfLife(bool _allow)
602         onlyAdministrator()
603     {
604         allowHalfLife = _allow;
605     
606     }
607 
608     function setAllowReferral(bool _allow)
609         onlyAdministrator()
610     {
611         allowReferral = _allow;
612     
613     }
614 
615     function setInv1(address _newInvestorAddress)
616         onlyAdministrator()
617         public
618     {
619         inv1 = _newInvestorAddress;
620     }
621 
622     function setInv2(address _newInvestorAddress)
623         onlyAdministrator()
624         public
625     {
626         inv2 = _newInvestorAddress;
627     }
628 
629     function setInv3(address _newInvestorAddress)
630         onlyAdministrator()
631         public
632     {
633         inv3 = _newInvestorAddress;
634     }
635 
636     /**
637      * Set fees/rates
638      */
639     function setFeeRates(uint8 _newDivRate, uint8 _newInvestorFee, uint8 _newCardFee)
640         onlyAdministrator()
641         public
642     {
643         require(_newDivRate <= 250);
644         require(_newInvestorFee + _newCardFee <= 50);  //5% -- 50 out of 1000
645 
646         dividendFee_ = _newDivRate;
647         investorFeeRate_ = _newInvestorFee;
648         cardInsuranceFeeRate_ = _newCardFee;
649     }
650     
651     /**
652      * In case one of us dies, we need to replace ourselves.
653      */
654     function setContractActive(bool _status)
655         onlyAdministrator()
656         public
657     {
658         boolContractActive = _status;
659     }
660 
661     /**
662      * In case one of us dies, we need to replace ourselves.
663      */
664     function setCardActive(bool _status)
665         onlyAdministrator()
666         public
667     {
668         boolCardActive = _status;
669     }
670     
671 
672     /**
673      * Precautionary measures in case we need to adjust the masternode rate.
674      */
675     function setStakingRequirement(uint256 _amountOfTokens)
676         onlyAdministrator()
677         public
678     {
679         stakingRequirement = _amountOfTokens;
680     }
681     
682     /**
683      * If we want to rebrand, we can.
684      */
685     function setName(string _name)
686         onlyAdministrator()
687         public
688     {
689         name = _name;
690     }
691     
692     /**
693      * If we want to rebrand, we can.
694      */
695     function setSymbol(string _symbol)
696         onlyAdministrator()
697         public
698     {
699         symbol = _symbol;
700     }
701 
702     
703     function setMaxCards(uint _card)  
704         onlyAdministrator()
705         public
706     {
707         maxCards = _card;
708     }
709 
710     function setHalfLifeTime(uint _time)
711         onlyAdministrator()
712         public
713     {
714         halfLifeTime = _time;
715     }
716 
717     function setHalfLifeRate(uint _rate)
718         onlyAdministrator()
719         public
720     {
721         halfLifeRate = _rate;
722     }
723 
724     function addNewCard(uint _price) 
725         onlyAdministrator()
726         public
727     {
728         require(nextAvailableCard < maxCards);
729         cardPrice[nextAvailableCard] = _price;
730         basePrice[nextAvailableCard] = cardPrice[nextAvailableCard];
731         cardOwner[nextAvailableCard] = dev;
732         totalCardDivs[nextAvailableCard] = 0;
733         cardPreviousPrice[nextAvailableCard] = 0;
734         nextAvailableCard = nextAvailableCard + 1;
735         getTotalCardValue();
736         
737     }
738 
739 
740     function addAmbassador(address _newAmbassador) 
741         onlyAdministrator()
742         public
743     {
744         ambassadors_[_newAmbassador] = true;
745     }
746     
747     /*----------  HELPERS AND CALCULATORS  ----------*/
748     /**
749      * Method to view the current Ethereum stored in the contract
750      * Example: totalEthereumBalance()
751      */
752     function totalEthereumBalance()
753         public
754         view
755         returns(uint)
756     {
757         return this.balance;
758     }
759     
760     /**
761      * Retrieve the total token supply.
762      */
763     function totalSupply()
764         public
765         view
766         returns(uint256)
767     {
768         return tokenSupply_;
769     }
770     
771     /**
772      * Retrieve the tokens owned by the caller.
773      */
774     function myTokens()
775         public
776         view
777         returns(uint256)
778     {
779         address _customerAddress = msg.sender;
780         return balanceOf(_customerAddress);
781     }
782     
783     /**
784      * Retrieve the dividends owned by the caller.
785      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
786      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
787      * But in the internal calculations, we want them separate. 
788      */ 
789     function myDividends(bool _includeReferralBonus) 
790         public 
791         view 
792         returns(uint256)
793     {
794         address _customerAddress = msg.sender;
795         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
796     }
797 
798     function myCardDividends()
799         public
800         view
801         returns(uint256)
802     {
803         address _customerAddress = msg.sender;
804         return ownerAccounts[_customerAddress];
805     }
806     
807     /**
808      * Retrieve the token balance of any single address.
809      */
810     function balanceOf(address _customerAddress)
811         view
812         public
813         returns(uint256)
814     {
815         return tokenBalanceLedger_[_customerAddress];
816     }
817     
818     /**
819      * Retrieve the dividend balance of any single address.
820      */
821     function dividendsOf(address _customerAddress)
822         view
823         public
824         returns(uint256)
825     {
826         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
827     }
828     
829     /**
830      * Return the buy price of 1 individual token.
831      */
832     function sellPrice() 
833         public 
834         view 
835         returns(uint256)
836     {
837         // our calculation relies on the token supply, so we need supply. Doh.
838         if(tokenSupply_ == 0){
839             return tokenPriceInitial_ - tokenPriceIncremental_;
840         } else {
841             uint256 _ethereum = tokensToEthereum_(1e18);
842             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_  ),1000);
843             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
844             return _taxedEthereum;
845         }
846     }
847     
848     /**
849      * Return the sell price of 1 individual token.
850      */
851     function buyPrice() 
852         public 
853         view 
854         returns(uint256)
855     {
856         // our calculation relies on the token supply, so we need supply. Doh.
857         if(tokenSupply_ == 0){
858             return tokenPriceInitial_ + tokenPriceIncremental_;
859         } else {
860             uint256 _ethereum = tokensToEthereum_(1e18);
861             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_  ),1000);
862             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
863             return _taxedEthereum;
864         }
865     }
866     
867     /**
868      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
869      */
870     function calculateTokensReceived(uint256 _ethereumToSpend) 
871         public 
872         view 
873         returns(uint256)
874     {
875         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, dividendFee_  ),1000);
876         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
877         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
878         
879         return _amountOfTokens;
880     }
881     
882     /**
883      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
884      */
885     function calculateEthereumReceived(uint256 _tokensToSell) 
886         public 
887         view 
888         returns(uint256)
889     {
890         require(_tokensToSell <= tokenSupply_);
891         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
892         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_  ),1000);
893         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
894         return _taxedEthereum;
895     }
896     
897     
898     /*==========================================
899     =            INTERNAL FUNCTIONS            =
900     ==========================================*/
901 
902 
903     function getNextAvailableCard()
904         public
905         view
906         returns(uint)
907     {
908         return nextAvailableCard;
909     }
910 
911     function getTotalCardValue()
912     internal
913     view
914     {
915         uint counter = 1;
916         uint _totalVal = 0;
917 
918         while (counter < nextAvailableCard) { 
919 
920             _totalVal = SafeMath.add(_totalVal,cardPrice[counter]);
921                 
922             counter = counter + 1;
923         } 
924         totalCardValue = _totalVal;
925             
926     }
927 
928     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
929         antiEarlyWhale(_incomingEthereum)
930         onlyActive()
931         internal
932         returns(uint256)
933     {
934         // data setup
935 
936         cardInsuranceAccount = SafeMath.add(cardInsuranceAccount, SafeMath.div(SafeMath.mul(_incomingEthereum, cardInsuranceFeeRate_), 1000));
937         ownerAccounts[inv1] = SafeMath.add(ownerAccounts[inv1] , SafeMath.div(SafeMath.mul(_incomingEthereum, investorFeeRate_), 1000));
938         ownerAccounts[inv2] = SafeMath.add(ownerAccounts[inv2] , SafeMath.div(SafeMath.mul(_incomingEthereum, investorFeeRate_), 1000));
939         ownerAccounts[inv3] = SafeMath.add(ownerAccounts[inv3] , SafeMath.div(SafeMath.mul(_incomingEthereum, investorFeeRate_), 1000));
940 
941 
942         _incomingEthereum = SafeMath.sub(_incomingEthereum,SafeMath.div(SafeMath.mul(_incomingEthereum, cardInsuranceFeeRate_), 1000) + SafeMath.div(SafeMath.mul(_incomingEthereum, investorFeeRate_), 1000)*3);
943 
944       
945         uint256 _referralBonus = SafeMath.div(SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_  ),1000), 3);
946         uint256 _dividends = SafeMath.sub(SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_  ),1000), _referralBonus);
947         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_  ),1000));
948         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
949         uint256 _fee = _dividends * magnitude;
950  
951         // no point in continuing execution if OP is a poorfag russian hacker
952         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
953         // (or hackers)
954         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
955         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
956         
957         // is the user referred by a masternode?
958         if(
959             // is this a referred purchase?
960             _referredBy != 0x0000000000000000000000000000000000000000 &&
961 
962             // no cheating!
963             _referredBy != msg.sender &&
964             
965             // does the referrer have at least X whole tokens?
966             // i.e is the referrer a godly chad masternode
967             tokenBalanceLedger_[_referredBy] >= stakingRequirement
968         ){
969             // wealth redistribution
970             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
971         } else {
972             // no ref purchase
973             // add the referral bonus back to the global dividends cake
974             _dividends = SafeMath.add(_dividends, _referralBonus);
975             _fee = _dividends * magnitude;
976         }
977         
978         // we can't give people infinite ethereum
979         if(tokenSupply_ > 0){
980             
981             // add tokens to the pool
982             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
983  
984             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
985             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
986             
987             // calculate the amount of tokens the customer receives over his purchase 
988             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
989         
990         } else {
991             // add tokens to the pool
992             tokenSupply_ = _amountOfTokens;
993         }
994         
995         // update circulating supply & the ledger address for the customer
996         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
997         
998         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
999         //really i know you think you do but you don't
1000         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
1001         payoutsTo_[msg.sender] += _updatedPayouts;
1002 
1003         distributeInsurance();
1004         checkHalfLife();
1005         
1006         // fire event
1007         onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
1008         
1009         return _amountOfTokens;
1010     }
1011 
1012 
1013 
1014     function buyCard(uint _card, address _referrer)
1015         public
1016         payable
1017         onlyCardActive()
1018     {
1019         require(_card <= nextAvailableCard);
1020         require(_card > 0);
1021         require(msg.value >= cardPrice[_card]);
1022        
1023         cardBlockNumber[_card] = block.number;   //reset block number for this card for half life calculations
1024 
1025 
1026          //Determine the total dividends
1027         uint _baseDividends = msg.value - cardPreviousPrice[_card];
1028         totalDivsProduced = SafeMath.add(totalDivsProduced, _baseDividends);
1029 
1030         //uint _devDividends = SafeMath.div(SafeMath.mul(_baseDividends,devDivRate),100);
1031         uint _ownerDividends = SafeMath.div(SafeMath.mul(_baseDividends,ownerDivRate),1000);
1032         _ownerDividends = SafeMath.add(_ownerDividends,cardPreviousPrice[_card]);  //owner receovers price they paid initially
1033         uint _insuranceDividends = SafeMath.div(SafeMath.mul(_baseDividends,insuranceDivRate),1000);
1034 
1035         totalCardDivs[_card] = SafeMath.add(totalCardDivs[_card],_ownerDividends);
1036         
1037         cardInsuranceAccount = SafeMath.add(cardInsuranceAccount, _insuranceDividends);
1038             
1039         uint _distDividends = SafeMath.div(SafeMath.mul(_baseDividends,distDivRate),1000);
1040 
1041         if (allowReferral && (_referrer != msg.sender) && (_referrer != 0x0000000000000000000000000000000000000000)) {
1042                 
1043             uint _referralDividends = SafeMath.div(SafeMath.mul(_baseDividends,referralRate),1000);
1044             _distDividends = SafeMath.sub(_distDividends,_referralDividends);
1045             ownerAccounts[_referrer] = SafeMath.add(ownerAccounts[_referrer],_referralDividends);
1046         }
1047             
1048         distributeYield(_distDividends);
1049 
1050         //distribute dividends to accounts
1051         address _previousOwner = cardOwner[_card];
1052         address _newOwner = msg.sender;
1053 
1054         ownerAccounts[_previousOwner] = SafeMath.add(ownerAccounts[_previousOwner],_ownerDividends);
1055         ownerAccounts[dev] = SafeMath.add(ownerAccounts[dev],SafeMath.div(SafeMath.mul(_baseDividends,devDivRate),1000));
1056 
1057         cardOwner[_card] = _newOwner;
1058 
1059         //Increment the card Price
1060         cardPreviousPrice[_card] = msg.value;
1061         cardPrice[_card] = SafeMath.div(SafeMath.mul(msg.value,cardPriceIncrement),1000);
1062   
1063         getTotalCardValue();
1064         distributeInsurance();
1065         checkHalfLife();
1066 
1067         emit onCardBuy(msg.sender, msg.value, _card, SafeMath.div(SafeMath.mul(msg.value,cardPriceIncrement),1000), halfLifeTime + block.number);
1068      
1069     }
1070 
1071 
1072     function distributeInsurance() internal
1073     {
1074         uint counter = 1;
1075         uint _cardDistAmount = cardInsuranceAccount;
1076         cardInsuranceAccount = 0;
1077         uint tempInsurance = 0;
1078 
1079         while (counter < nextAvailableCard) { 
1080   
1081             uint _distAmountLocal = SafeMath.div(SafeMath.mul(_cardDistAmount, cardPrice[counter]),totalCardValue);
1082             
1083             cardInsurance[counter] = SafeMath.add(cardInsurance[counter], _distAmountLocal);
1084             tempInsurance = tempInsurance + cardInsurance[counter];
1085             emit onInsuranceChange(0x0, counter, cardInsurance[counter]);
1086     
1087             counter = counter + 1;
1088         } 
1089         totalCardInsurance = tempInsurance;
1090     }
1091 
1092 
1093     function distributeYield(uint _distDividends) internal
1094     //tokens
1095     {
1096         uint counter = 1;
1097         uint currentBlock = block.number;
1098         uint insurancePayout = 0;
1099 
1100         while (counter < nextAvailableCard) { 
1101 
1102             uint _distAmountLocal = SafeMath.div(SafeMath.mul(_distDividends, cardPrice[counter]),totalCardValue);
1103             ownerAccounts[cardOwner[counter]] = SafeMath.add(ownerAccounts[cardOwner[counter]],_distAmountLocal);
1104             totalCardDivs[counter] = SafeMath.add(totalCardDivs[counter],_distAmountLocal);
1105 
1106             counter = counter + 1;
1107         } 
1108         getTotalCardValue();
1109         checkHalfLife();
1110     }
1111 
1112     function extCheckHalfLife() 
1113     public
1114     {
1115         bool _boolDev = (msg.sender == dev);
1116         if (_boolDev || boolAllowPlayer){
1117             checkHalfLife();
1118         }
1119     }
1120 
1121 
1122     function checkHalfLife() 
1123     internal
1124     
1125     //tokens
1126     {
1127 
1128         uint counter = 1;
1129         uint currentBlock = block.number;
1130         uint insurancePayout = 0;
1131         uint tempInsurance = 0;
1132 
1133         while (counter < nextAvailableCard) { 
1134 
1135             //HalfLife Check
1136             if (allowHalfLife) {
1137 
1138                 if (cardPrice[counter] > basePrice[counter]) {
1139                     uint _life = SafeMath.sub(currentBlock, cardBlockNumber[counter]);
1140 
1141                     if (_life > halfLifeTime) {
1142                     
1143                         cardBlockNumber[counter] = currentBlock;  //Reset the clock for this card
1144                         if (SafeMath.div(SafeMath.mul(cardPrice[counter], halfLifeRate),1000) < basePrice[counter]){
1145                             
1146                             cardPrice[counter] = basePrice[counter];
1147                             insurancePayout = SafeMath.div(SafeMath.mul(cardInsurance[counter],insurancePayoutRate),1000);
1148                             cardInsurance[counter] = SafeMath.sub(cardInsurance[counter],insurancePayout);
1149                             ownerAccounts[cardOwner[counter]] = SafeMath.add(ownerAccounts[cardOwner[counter]], insurancePayout);
1150                             
1151                         }else{
1152 
1153                             cardPrice[counter] = SafeMath.div(SafeMath.mul(cardPrice[counter], halfLifeRate),1000);  
1154                             cardPreviousPrice[counter] = SafeMath.div(SafeMath.mul(cardPrice[counter],halfLifeReductionRate),1000);
1155 
1156                             insurancePayout = SafeMath.div(SafeMath.mul(cardInsurance[counter],insurancePayoutRate),1000);
1157                             cardInsurance[counter] = SafeMath.sub(cardInsurance[counter],insurancePayout);
1158                             ownerAccounts[cardOwner[counter]] = SafeMath.add(ownerAccounts[cardOwner[counter]], insurancePayout);
1159 
1160                         }
1161                         emit onInsuranceChange(0x0, counter, cardInsurance[counter]);
1162                         emit Halflife(cardOwner[counter], counter, cardPrice[counter], halfLifeTime + block.number, insurancePayout, cardInsurance[counter]);
1163 
1164                     }
1165                     //HalfLife Check
1166                     
1167                 }
1168                
1169             }
1170             
1171             tempInsurance = tempInsurance + cardInsurance[counter];
1172             counter = counter + 1;
1173         } 
1174         totalCardInsurance = tempInsurance;
1175         getTotalCardValue();
1176 
1177     }
1178 
1179     /**
1180      * Calculate Token price based on an amount of incoming ethereum
1181      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
1182      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
1183      */
1184     function ethereumToTokens_(uint256 _ethereum)
1185         internal
1186         view
1187         returns(uint256)
1188     {
1189         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
1190         uint256 _tokensReceived = 
1191          (
1192             (
1193                 // underflow attempts BTFO
1194                 SafeMath.sub(
1195                     (sqrt
1196                         (
1197                             (_tokenPriceInitial**2)
1198                             +
1199                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
1200                             +
1201                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
1202                             +
1203                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
1204                         )
1205                     ), _tokenPriceInitial
1206                 )
1207             )/(tokenPriceIncremental_)
1208         )-(tokenSupply_)
1209         ;
1210   
1211         return _tokensReceived;
1212     }
1213     
1214     /**
1215      * Calculate token sell value.
1216      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
1217      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
1218      */
1219      function tokensToEthereum_(uint256 _tokens)
1220         internal
1221         view
1222         returns(uint256)
1223     {
1224 
1225         uint256 tokens_ = (_tokens + 1e18);
1226         uint256 _tokenSupply = (tokenSupply_ + 1e18);
1227         uint256 _etherReceived =
1228         (
1229             // underflow attempts BTFO
1230             SafeMath.sub(
1231                 (
1232                     (
1233                         (
1234                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
1235                         )-tokenPriceIncremental_
1236                     )*(tokens_ - 1e18)
1237                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
1238             )
1239         /1e18);
1240         return _etherReceived;
1241     }
1242 
1243 
1244     function getCardPrice(uint _card)
1245         public
1246         view
1247         returns(uint)
1248     {
1249         require(_card <= nextAvailableCard);
1250         return cardPrice[_card];
1251     }
1252 
1253    function getCardInsurance(uint _card)
1254         public
1255         view
1256         returns(uint)
1257     {
1258         require(_card <= nextAvailableCard);
1259         return cardInsurance[_card];
1260     }
1261 
1262 
1263     function getCardOwner(uint _card)
1264         public
1265         view
1266         returns(address)
1267     {
1268         require(_card <= nextAvailableCard);
1269         return cardOwner[_card];
1270     }
1271 
1272     function gettotalCardDivs(uint _card)
1273         public
1274         view
1275         returns(uint)
1276     {
1277         require(_card <= nextAvailableCard);
1278         return totalCardDivs[_card];
1279     }
1280 
1281     function getTotalDivsProduced()
1282         public
1283         view
1284         returns(uint)
1285     {
1286      
1287         return totalDivsProduced;
1288     }
1289     
1290     
1291     //This is where all your gas goes, sorry
1292     //Not sorry, you probably only paid 1 gwei
1293     function sqrt(uint x) internal pure returns (uint y) {
1294         uint z = (x + 1) / 2;
1295         y = x;
1296         while (z < y) {
1297             y = z;
1298             z = (x / z + z) / 2;
1299         }
1300     }
1301 }
1302 
1303 
1304 
1305 /**
1306  * @title SafeMath
1307  * @dev Math operations with safety checks that throw on error
1308  */
1309 library SafeMath {
1310 
1311     /**
1312     * @dev Multiplies two numbers, throws on overflow.
1313     */
1314     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1315         if (a == 0) {
1316             return 0;
1317         }
1318         uint256 c = a * b;
1319         assert(c / a == b);
1320         return c;
1321     }
1322 
1323     /**
1324     * @dev Integer division of two numbers, truncating the quotient.
1325     */
1326     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1327         // assert(b > 0); // Solidity automatically throws when dividing by 0
1328         uint256 c = a / b;
1329         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1330         return c;
1331     }
1332 
1333     /**
1334     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1335     */
1336     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1337         assert(b <= a);
1338         return a - b;
1339     }
1340 
1341     /**
1342     * @dev Adds two numbers, throws on overflow.
1343     */
1344     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1345         uint256 c = a + b;
1346         assert(c >= a);
1347         return c;
1348     }
1349 }