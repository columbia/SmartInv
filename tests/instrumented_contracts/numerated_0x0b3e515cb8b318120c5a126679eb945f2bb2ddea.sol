1 pragma solidity ^0.4.21;
2 
3 /*
4 ******************** HALO 3D *********************
5 * ===============================================*
6 MMMMMMMMMMMMMMMMMMMMMWWXKKXNWMMMMMMMMMMMMMMMMMMMMM
7 MMMMMMMMMMMMMMMMMMWWXko;'',lkKNWWMMMMMMMMMMMMMMMMM
8 MMMMMMMMMMMMMMMMMNOc'.       .:d0XWWMMMMMMMMMMMMMM
9 MMMMMMMMMMMMMMMMMNOc'.          .,lkKNWWMMMMMMMMMM
10 MMMMMMMWWNKKXWWMMMWNKkl'            .:d0XWWMMMMMMM
11 MMMMWWXOo;..'cx0NNWX0d:.               .,lkKWWMMMM
12 MMWWKo,.       .;lc,.           .          'l0NWMM
13 MMWOc;,'.                   .,lkOdc'.    ..,,:xNWM
14 MWNd. .';;,.              .lOXNWWWNXOo;,,,'.  :XWM
15 MWNo.    .ckxl,.          .'cxKNWMMMWWXd.     :KWM
16 MWNo.     :KNNXOo;.           'oKNWMMWNo.     :KWM
17 MWNd.     :KWWWW0l;;;'.    ..,,,:kWMMWNo.     :KWM
18 MWNo.     ;0WWWWO'  .,;;;;;;'.  .dNWMWXo.     :KWM
19 MWNo.     .lkXNNO'     'dx;     .dXNX0d,      :KWM
20 MWNo.       .':dd.     .ox;     .lxl;.        :KWM
21 MWNo.           .      .ox;      ..           :KWM
22 MWNd.                  .ox;                   :KWM
23 MWNd.     ,dl;.        .ox;        .'cdc.     :KWM
24 MMNx.     ;0NN0d;.     .ox;      'oOXNXo.    .oXWM
25 MMWNOo;.  :KWMWNO'     .ox;     .oXWMWNo. .,lkXWMM
26 MMMMWWN0xlxNWMMWO'     .ox;     .dNWMMWOox0NWWMMMM
27 MMMMMMMMWWWMMMMWO'     .ox;     .dNWMMMWWWMMMMMMMM
28 MMMMMMMMMMMMMMMWKc.    .ox,     ,OWMMMMMMMMMMMMMMM
29 MMMMMMMMMMMMMMMMWXOo;. .ox; .,lkXWWMMMMMMMMMMMMMMM
30 MMMMMMMMMMMMMMMMMMWWN0xx0Kkx0NWWMMMMMMMMMMMMMMMMMM
31 MMMMMMMMMMMMMMMMMMMMMMMWWWWWMMMMMMMMMMMMMMMMMMMMMM
32 * ===============================================*
33 ******************** HALO 3D *********************
34 *
35 * The World's FIRST Charity/Gaming Pyramid! All the features of a classic pyramid plus more.
36 * Brought to you by a collaboration of crypto gaming experts and YouTubers.
37 *
38 * What is new?
39 * [x] REVOLUTIONARY 0% TRANSFER FEES, Now you can send Halo3D tokens to all your family, no charge
40 * [X] 20% DIVIDENDS AND MASTERNODES! We know you all love your divies :D
41 * [x] GENEROUS 2% FEE ON EACH BUY AND SELL GO TO CHARITY https://giveth.io/
42 *     https://etherscan.io/address/0x5ADF43DD006c6C36506e2b2DFA352E60002d22Dc
43 * [x] DAPP INTEROPERABILITY, games and other dAPPs can incorporate Halo3D tokens!
44 *
45 * Official website is https://h3d.pw/  :)
46 * Official discord is https://discord.gg/w6HamAS 0_0
47 */
48 
49 
50 /**
51  * Definition of contract accepting Halo3D tokens
52  * Games, casinos, anything can reuse this contract to support Halo3D tokens
53  */
54 contract AcceptsHalo3D {
55     Halo3D public tokenContract;
56 
57     function AcceptsHalo3D(address _tokenContract) public {
58         tokenContract = Halo3D(_tokenContract);
59     }
60 
61     modifier onlyTokenContract {
62         require(msg.sender == address(tokenContract));
63         _;
64     }
65 
66     /**
67     * @dev Standard ERC677 function that will handle incoming token transfers.
68     *
69     * @param _from  Token sender address.
70     * @param _value Amount of tokens.
71     * @param _data  Transaction metadata.
72     */
73     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
74 }
75 
76 
77 contract Halo3D {
78     /*=================================
79     =            MODIFIERS            =
80     =================================*/
81     // only people with tokens
82     modifier onlyBagholders() {
83         require(myTokens() > 0);
84         _;
85     }
86 
87     // only people with profits
88     modifier onlyStronghands() {
89         require(myDividends(true) > 0);
90         _;
91     }
92 
93     modifier notContract() {
94       require (msg.sender == tx.origin);
95       _;
96     }
97 
98     // administrators can:
99     // -> change the name of the contract
100     // -> change the name of the token
101     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
102     // they CANNOT:
103     // -> take funds
104     // -> disable withdrawals
105     // -> kill the contract
106     // -> change the price of tokens
107     modifier onlyAdministrator(){
108         address _customerAddress = msg.sender;
109         require(administrators[_customerAddress]);
110         _;
111     }
112 
113 
114     // ensures that the first tokens in the contract will be equally distributed
115     // meaning, no divine dump will be ever possible
116     // result: healthy longevity.
117     modifier antiEarlyWhale(uint256 _amountOfEthereum){
118         address _customerAddress = msg.sender;
119 
120         // are we still in the vulnerable phase?
121         // if so, enact anti early whale protocol
122         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
123             require(
124                 // is the customer in the ambassador list?
125                 ambassadors_[_customerAddress] == true &&
126 
127                 // does the customer purchase exceed the max ambassador quota?
128                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
129 
130             );
131 
132             // updated the accumulated quota
133             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
134 
135             // execute
136             _;
137         } else {
138             // in case the ether count drops low, the ambassador phase won't reinitiate
139             onlyAmbassadors = false;
140             _;
141         }
142 
143     }
144 
145     /*==============================
146     =            EVENTS            =
147     ==============================*/
148     event onTokenPurchase(
149         address indexed customerAddress,
150         uint256 incomingEthereum,
151         uint256 tokensMinted,
152         address indexed referredBy
153     );
154 
155     event onTokenSell(
156         address indexed customerAddress,
157         uint256 tokensBurned,
158         uint256 ethereumEarned
159     );
160 
161     event onReinvestment(
162         address indexed customerAddress,
163         uint256 ethereumReinvested,
164         uint256 tokensMinted
165     );
166 
167     event onWithdraw(
168         address indexed customerAddress,
169         uint256 ethereumWithdrawn
170     );
171 
172     // ERC20
173     event Transfer(
174         address indexed from,
175         address indexed to,
176         uint256 tokens
177     );
178 
179 
180     /*=====================================
181     =            CONFIGURABLES            =
182     =====================================*/
183     string public name = "Halo3D";
184     string public symbol = "H3D";
185     uint8 constant public decimals = 18;
186     uint8 constant internal dividendFee_ = 20; // 20% dividend fee on each buy and sell
187     uint8 constant internal charityFee_ = 2; // 2% charity fee on each buy and sell
188     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
189     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
190     uint256 constant internal magnitude = 2**64;
191 
192     // Address to send the charity  ! :)
193     //  https://giveth.io/
194     // https://etherscan.io/address/0x5ADF43DD006c6C36506e2b2DFA352E60002d22Dc
195     address constant public giveEthCharityAddress = 0x5ADF43DD006c6C36506e2b2DFA352E60002d22Dc;
196     uint256 public totalEthCharityRecieved; // total ETH charity recieved from this contract
197     uint256 public totalEthCharityCollected; // total ETH charity collected in this contract
198 
199     // proof of stake (defaults at 100 tokens)
200     uint256 public stakingRequirement = 100e18;
201 
202     // ambassador program
203     mapping(address => bool) internal ambassadors_;
204     uint256 constant internal ambassadorMaxPurchase_ = 0.4 ether;
205     uint256 constant internal ambassadorQuota_ = 10 ether;
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
226     // Special Halo3D Platform control from scam game contracts on Halo3D platform
227     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept Halo3D tokens
228 
229 
230 
231     /*=======================================
232     =            PUBLIC FUNCTIONS            =
233     =======================================*/
234     /*
235     * -- APPLICATION ENTRY POINTS --
236     */
237     function Halo3D()
238         public
239     {
240         // add administrators here
241         administrators[0xf4cFeD6A0f869548F73f05a364B329b86B6Bb157] = true;
242 
243         // add the ambassadors here.
244         ambassadors_[0xf4cFeD6A0f869548F73f05a364B329b86B6Bb157] = true;
245         //ambassador B
246         ambassadors_[0xe436cbd3892c6dc3d6c8a3580153e6e0fa613cfc] = true;
247         //ambassador W
248         ambassadors_[0x922cFfa33A078B4Cc6077923e43447d8467F8B55] = true;
249         //ambassador B1
250         ambassadors_[0x8Dd512843c24c382210a9CcC9C98B8b5eEED97e8] = true;
251         //ambassador J
252         ambassadors_[0x4ffe17a2a72bc7422cb176bc71c04ee6d87ce329] = true;
253         //ambassador CG
254         ambassadors_[0x3747EaFE2Bc9cB5221879758ca24a0d15B47A9B6] = true;
255         //ambassador BL
256         ambassadors_[0xB38094D492af4FfffF760707F36869713bFb2250] = true;
257         //ambassador BU
258         ambassadors_[0xBa21d01125D6932ce8ABf3625977899Fd2C7fa30] = true;
259         //ambassador SW
260         ambassadors_[0x2e6236591bfa37c683ce60d6cfde40396a114ff1] = true;
261         //ambassador Tr
262         ambassadors_[0xa683C1b815997a7Fa38f6178c84675FC4c79AC2B] = true;
263         //ambassador NM
264         ambassadors_[0x84ECB387395a1be65E133c75Ff9e5FCC6F756DB3] = true;
265         //ambassador Kh
266         ambassadors_[0x05f2c11996d73288AbE8a31d8b593a693FF2E5D8] = true;
267         //ambassador KA
268         ambassadors_[0x5632CA98e5788edDB2397757Aa82d1Ed6171e5aD] = true;
269         //ambassador FL
270         ambassadors_[0xA790fa6422A15a3637885f6811e5428de3513169] = true;
271         //ambassador Al
272         ambassadors_[0x008ca4F1bA79D1A265617c6206d7884ee8108a78] = true;
273         //ambassador KC
274         ambassadors_[0x7c377B7bCe53a5CEF88458b2cBBe11C3babe16DA] = true;
275         //ambassador Ph
276         ambassadors_[0x183feBd8828a9ac6c70C0e27FbF441b93004fC05] = true;
277         //ambassador CW
278         ambassadors_[0x29A9c76aD091c015C12081A1B201c3ea56884579] = true;
279     }
280 
281 
282     /**
283      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
284      */
285     function buy(address _referredBy)
286         public
287         payable
288         returns(uint256)
289     {
290         purchaseInternal(msg.value, _referredBy);
291     }
292 
293     /**
294      * Fallback function to handle ethereum that was send straight to the contract
295      * Unfortunately we cannot use a referral address this way.
296      */
297     function()
298         payable
299         public
300     {
301         purchaseInternal(msg.value, 0x0);
302     }
303 
304     /**
305      * Sends charity money to the  https://giveth.io/
306      * Their charity address is here https://etherscan.io/address/0x5ADF43DD006c6C36506e2b2DFA352E60002d22Dc
307      */
308     function payCharity() payable public {
309       uint256 ethToPay = SafeMath.sub(totalEthCharityCollected, totalEthCharityRecieved);
310       require(ethToPay > 1);
311       totalEthCharityRecieved = SafeMath.add(totalEthCharityRecieved, ethToPay);
312       if(!giveEthCharityAddress.call.value(ethToPay).gas(400000)()) {
313          totalEthCharityRecieved = SafeMath.sub(totalEthCharityRecieved, ethToPay);
314       }
315     }
316 
317     /**
318      * Converts all of caller's dividends to tokens.
319      */
320     function reinvest()
321         onlyStronghands()
322         public
323     {
324         // fetch dividends
325         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
326 
327         // pay out the dividends virtually
328         address _customerAddress = msg.sender;
329         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
330 
331         // retrieve ref. bonus
332         _dividends += referralBalance_[_customerAddress];
333         referralBalance_[_customerAddress] = 0;
334 
335         // dispatch a buy order with the virtualized "withdrawn dividends"
336         uint256 _tokens = purchaseTokens(_dividends, 0x0);
337 
338         // fire event
339         onReinvestment(_customerAddress, _dividends, _tokens);
340     }
341 
342     /**
343      * Alias of sell() and withdraw().
344      */
345     function exit()
346         public
347     {
348         // get token count for caller & sell them all
349         address _customerAddress = msg.sender;
350         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
351         if(_tokens > 0) sell(_tokens);
352 
353         // lambo delivery service
354         withdraw();
355     }
356 
357     /**
358      * Withdraws all of the callers earnings.
359      */
360     function withdraw()
361         onlyStronghands()
362         public
363     {
364         // setup data
365         address _customerAddress = msg.sender;
366         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
367 
368         // update dividend tracker
369         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
370 
371         // add ref. bonus
372         _dividends += referralBalance_[_customerAddress];
373         referralBalance_[_customerAddress] = 0;
374 
375         // lambo delivery service
376         _customerAddress.transfer(_dividends);
377 
378         // fire event
379         onWithdraw(_customerAddress, _dividends);
380     }
381 
382     /**
383      * Liquifies tokens to ethereum.
384      */
385     function sell(uint256 _amountOfTokens)
386         onlyBagholders()
387         public
388     {
389         // setup data
390         address _customerAddress = msg.sender;
391         // russian hackers BTFO
392         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
393         uint256 _tokens = _amountOfTokens;
394         uint256 _ethereum = tokensToEthereum_(_tokens);
395 
396         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
397         uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereum, charityFee_), 100);
398 
399         // Take out dividends and then _charityPayout
400         uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _charityPayout);
401 
402         // Add ethereum to send to charity
403         totalEthCharityCollected = SafeMath.add(totalEthCharityCollected, _charityPayout);
404 
405         // burn the sold tokens
406         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
407         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
408 
409         // update dividends tracker
410         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
411         payoutsTo_[_customerAddress] -= _updatedPayouts;
412 
413         // dividing by zero is a bad idea
414         if (tokenSupply_ > 0) {
415             // update the amount of dividends per token
416             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
417         }
418 
419         // fire event
420         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
421     }
422 
423 
424     /**
425      * Transfer tokens from the caller to a new holder.
426      * REMEMBER THIS IS 0% TRANSFER FEE
427      */
428     function transfer(address _toAddress, uint256 _amountOfTokens)
429         onlyBagholders()
430         public
431         returns(bool)
432     {
433         // setup
434         address _customerAddress = msg.sender;
435 
436         // make sure we have the requested tokens
437         // also disables transfers until ambassador phase is over
438         // ( we dont want whale premines )
439         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
440 
441         // withdraw all outstanding dividends first
442         if(myDividends(true) > 0) withdraw();
443 
444         // exchange tokens
445         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
446         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
447 
448         // update dividend trackers
449         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
450         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
451 
452 
453         // fire event
454         Transfer(_customerAddress, _toAddress, _amountOfTokens);
455 
456         // ERC20
457         return true;
458     }
459 
460     /**
461     * Transfer token to a specified address and forward the data to recipient
462     * ERC-677 standard
463     * https://github.com/ethereum/EIPs/issues/677
464     * @param _to    Receiver address.
465     * @param _value Amount of tokens that will be transferred.
466     * @param _data  Transaction metadata.
467     */
468     function transferAndCall(address _to, uint256 _value, bytes _data) external returns (bool) {
469       require(_to != address(0));
470       require(canAcceptTokens_[_to] == true); // security check that contract approved by Halo3D platform
471       require(transfer(_to, _value)); // do a normal token transfer to the contract
472 
473       if (isContract(_to)) {
474         AcceptsHalo3D receiver = AcceptsHalo3D(_to);
475         require(receiver.tokenFallback(msg.sender, _value, _data));
476       }
477 
478       return true;
479     }
480 
481     /**
482      * Additional check that the game address we are sending tokens to is a contract
483      * assemble the given address bytecode. If bytecode exists then the _addr is a contract.
484      */
485      function isContract(address _addr) private constant returns (bool is_contract) {
486        // retrieve the size of the code on target address, this needs assembly
487        uint length;
488        assembly { length := extcodesize(_addr) }
489        return length > 0;
490      }
491 
492     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
493     /**
494      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
495      */
496     function disableInitialStage()
497         onlyAdministrator()
498         public
499     {
500         onlyAmbassadors = false;
501     }
502 
503     /**
504      * In case one of us dies, we need to replace ourselves.
505      */
506     function setAdministrator(address _identifier, bool _status)
507         onlyAdministrator()
508         public
509     {
510         administrators[_identifier] = _status;
511     }
512 
513     /**
514      * Precautionary measures in case we need to adjust the masternode rate.
515      */
516     function setStakingRequirement(uint256 _amountOfTokens)
517         onlyAdministrator()
518         public
519     {
520         stakingRequirement = _amountOfTokens;
521     }
522 
523     /**
524      * Add or remove game contract, which can accept Halo3D tokens
525      */
526     function setCanAcceptTokens(address _address, bool _value)
527       onlyAdministrator()
528       public
529     {
530       canAcceptTokens_[_address] = _value;
531     }
532 
533     /**
534      * If we want to rebrand, we can.
535      */
536     function setName(string _name)
537         onlyAdministrator()
538         public
539     {
540         name = _name;
541     }
542 
543     /**
544      * If we want to rebrand, we can.
545      */
546     function setSymbol(string _symbol)
547         onlyAdministrator()
548         public
549     {
550         symbol = _symbol;
551     }
552 
553 
554     /*----------  HELPERS AND CALCULATORS  ----------*/
555     /**
556      * Method to view the current Ethereum stored in the contract
557      * Example: totalEthereumBalance()
558      */
559     function totalEthereumBalance()
560         public
561         view
562         returns(uint)
563     {
564         return this.balance;
565     }
566 
567     /**
568      * Retrieve the total token supply.
569      */
570     function totalSupply()
571         public
572         view
573         returns(uint256)
574     {
575         return tokenSupply_;
576     }
577 
578     /**
579      * Retrieve the tokens owned by the caller.
580      */
581     function myTokens()
582         public
583         view
584         returns(uint256)
585     {
586         address _customerAddress = msg.sender;
587         return balanceOf(_customerAddress);
588     }
589 
590     /**
591      * Retrieve the dividends owned by the caller.
592      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
593      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
594      * But in the internal calculations, we want them separate.
595      */
596     function myDividends(bool _includeReferralBonus)
597         public
598         view
599         returns(uint256)
600     {
601         address _customerAddress = msg.sender;
602         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
603     }
604 
605     /**
606      * Retrieve the token balance of any single address.
607      */
608     function balanceOf(address _customerAddress)
609         view
610         public
611         returns(uint256)
612     {
613         return tokenBalanceLedger_[_customerAddress];
614     }
615 
616     /**
617      * Retrieve the dividend balance of any single address.
618      */
619     function dividendsOf(address _customerAddress)
620         view
621         public
622         returns(uint256)
623     {
624         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
625     }
626 
627     /**
628      * Return the buy price of 1 individual token.
629      */
630     function sellPrice()
631         public
632         view
633         returns(uint256)
634     {
635         // our calculation relies on the token supply, so we need supply. Doh.
636         if(tokenSupply_ == 0){
637             return tokenPriceInitial_ - tokenPriceIncremental_;
638         } else {
639             uint256 _ethereum = tokensToEthereum_(1e18);
640             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
641             uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereum, charityFee_), 100);
642             uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _charityPayout);
643             return _taxedEthereum;
644         }
645     }
646 
647     /**
648      * Return the sell price of 1 individual token.
649      */
650     function buyPrice()
651         public
652         view
653         returns(uint256)
654     {
655         // our calculation relies on the token supply, so we need supply. Doh.
656         if(tokenSupply_ == 0){
657             return tokenPriceInitial_ + tokenPriceIncremental_;
658         } else {
659             uint256 _ethereum = tokensToEthereum_(1e18);
660             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
661             uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereum, charityFee_), 100);
662             uint256 _taxedEthereum =  SafeMath.add(SafeMath.add(_ethereum, _dividends), _charityPayout);
663             return _taxedEthereum;
664         }
665     }
666 
667     /**
668      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
669      */
670     function calculateTokensReceived(uint256 _ethereumToSpend)
671         public
672         view
673         returns(uint256)
674     {
675         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, dividendFee_), 100);
676         uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereumToSpend, charityFee_), 100);
677         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereumToSpend, _dividends), _charityPayout);
678         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
679         return _amountOfTokens;
680     }
681 
682     /**
683      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
684      */
685     function calculateEthereumReceived(uint256 _tokensToSell)
686         public
687         view
688         returns(uint256)
689     {
690         require(_tokensToSell <= tokenSupply_);
691         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
692         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
693         uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereum, charityFee_), 100);
694         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _charityPayout);
695         return _taxedEthereum;
696     }
697 
698     /**
699      * Function for the frontend to show ether waiting to be send to charity in contract
700      */
701     function etherToSendCharity()
702         public
703         view
704         returns(uint256) {
705         return SafeMath.sub(totalEthCharityCollected, totalEthCharityRecieved);
706     }
707 
708 
709     /*==========================================
710     =            INTERNAL FUNCTIONS            =
711     ==========================================*/
712 
713     // Make sure we will send back excess if user sends more then 5 ether before 100 ETH in contract
714     function purchaseInternal(uint256 _incomingEthereum, address _referredBy)
715       notContract()// no contracts allowed
716       internal
717       returns(uint256) {
718 
719       uint256 purchaseEthereum = _incomingEthereum;
720       uint256 excess;
721       if(purchaseEthereum > 5 ether) { // check if the transaction is over 5 ether
722           if (SafeMath.sub(address(this).balance, purchaseEthereum) <= 100 ether) { // if so check the contract is less then 100 ether
723               purchaseEthereum = 5 ether;
724               excess = SafeMath.sub(_incomingEthereum, purchaseEthereum);
725           }
726       }
727 
728       purchaseTokens(purchaseEthereum, _referredBy);
729 
730       if (excess > 0) {
731         msg.sender.transfer(excess);
732       }
733     }
734 
735 
736     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
737         antiEarlyWhale(_incomingEthereum)
738         internal
739         returns(uint256)
740     {
741         // data setup
742         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);
743         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
744         uint256 _charityPayout = SafeMath.div(SafeMath.mul(_incomingEthereum, charityFee_), 100);
745         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
746         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_incomingEthereum, _undividedDividends), _charityPayout);
747 
748         totalEthCharityCollected = SafeMath.add(totalEthCharityCollected, _charityPayout);
749 
750         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
751         uint256 _fee = _dividends * magnitude;
752 
753         // no point in continuing execution if OP is a poorfag russian hacker
754         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
755         // (or hackers)
756         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
757         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
758 
759         // is the user referred by a masternode?
760         if(
761             // is this a referred purchase?
762             _referredBy != 0x0000000000000000000000000000000000000000 &&
763 
764             // no cheating!
765             _referredBy != msg.sender &&
766 
767             // does the referrer have at least X whole tokens?
768             // i.e is the referrer a godly chad masternode
769             tokenBalanceLedger_[_referredBy] >= stakingRequirement
770         ){
771             // wealth redistribution
772             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
773         } else {
774             // no ref purchase
775             // add the referral bonus back to the global dividends cake
776             _dividends = SafeMath.add(_dividends, _referralBonus);
777             _fee = _dividends * magnitude;
778         }
779 
780         // we can't give people infinite ethereum
781         if(tokenSupply_ > 0){
782 
783             // add tokens to the pool
784             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
785 
786             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
787             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
788 
789             // calculate the amount of tokens the customer receives over his purchase
790             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
791 
792         } else {
793             // add tokens to the pool
794             tokenSupply_ = _amountOfTokens;
795         }
796 
797         // update circulating supply & the ledger address for the customer
798         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
799 
800         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
801         //really i know you think you do but you don't
802         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
803         payoutsTo_[msg.sender] += _updatedPayouts;
804 
805         // fire event
806         onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
807 
808         return _amountOfTokens;
809     }
810 
811     /**
812      * Calculate Token price based on an amount of incoming ethereum
813      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
814      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
815      */
816     function ethereumToTokens_(uint256 _ethereum)
817         internal
818         view
819         returns(uint256)
820     {
821         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
822         uint256 _tokensReceived =
823          (
824             (
825                 // underflow attempts BTFO
826                 SafeMath.sub(
827                     (sqrt
828                         (
829                             (_tokenPriceInitial**2)
830                             +
831                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
832                             +
833                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
834                             +
835                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
836                         )
837                     ), _tokenPriceInitial
838                 )
839             )/(tokenPriceIncremental_)
840         )-(tokenSupply_)
841         ;
842 
843         return _tokensReceived;
844     }
845 
846     /**
847      * Calculate token sell value.
848      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
849      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
850      */
851      function tokensToEthereum_(uint256 _tokens)
852         internal
853         view
854         returns(uint256)
855     {
856 
857         uint256 tokens_ = (_tokens + 1e18);
858         uint256 _tokenSupply = (tokenSupply_ + 1e18);
859         uint256 _etherReceived =
860         (
861             // underflow attempts BTFO
862             SafeMath.sub(
863                 (
864                     (
865                         (
866                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
867                         )-tokenPriceIncremental_
868                     )*(tokens_ - 1e18)
869                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
870             )
871         /1e18);
872         return _etherReceived;
873     }
874 
875 
876     //This is where all your gas goes, sorry
877     //Not sorry, you probably only paid 1 gwei
878     function sqrt(uint x) internal pure returns (uint y) {
879         uint z = (x + 1) / 2;
880         y = x;
881         while (z < y) {
882             y = z;
883             z = (x / z + z) / 2;
884         }
885     }
886 }
887 
888 /**
889  * @title SafeMath
890  * @dev Math operations with safety checks that throw on error
891  */
892 library SafeMath {
893 
894     /**
895     * @dev Multiplies two numbers, throws on overflow.
896     */
897     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
898         if (a == 0) {
899             return 0;
900         }
901         uint256 c = a * b;
902         assert(c / a == b);
903         return c;
904     }
905 
906     /**
907     * @dev Integer division of two numbers, truncating the quotient.
908     */
909     function div(uint256 a, uint256 b) internal pure returns (uint256) {
910         // assert(b > 0); // Solidity automatically throws when dividing by 0
911         uint256 c = a / b;
912         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
913         return c;
914     }
915 
916     /**
917     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
918     */
919     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
920         assert(b <= a);
921         return a - b;
922     }
923 
924     /**
925     * @dev Adds two numbers, throws on overflow.
926     */
927     function add(uint256 a, uint256 b) internal pure returns (uint256) {
928         uint256 c = a + b;
929         assert(c >= a);
930         return c;
931     }
932 }