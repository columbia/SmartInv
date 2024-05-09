1 pragma solidity 0.4.25;
2 /*
3 *===============================================================================================
4 * POWH5D P5D - https://p5d.io
5 * ==============================================================================================
6 * THE ULTIMATE EXPANSION FOR THE POWH3D IMPROVED WITH:
7 * 1) DYNAMIC BUY FEES - 20% - 10% DEPENDING ON TOTAL TOKEN SUPPLY
8 * 2) DYNAMIC BUY FEES - 10% - 2% DEPENDING ON TOTAL TOKEN SUPPLY
9 * 3) TOKEN PRICE INCREMENTAL AS THE ORIGINAL P3D
10 * ==============================================================================================
11 *  [x] Developer optimized to include utility functions:
12 *      -> approve(): allow others to transfer on your behalf
13 *      -> approveAndCall(): callback for contracts that want to use approve()
14 *      -> transferFrom(): use your approval allowance to transfer P5D on anothers behalf
15 *      -> transferAndCall(): callback for contracts that want to use transfer()
16 *  [x] Designed to be a bridge for P3D to make the token functional for use in external contracts
17 *  [x] Masternodes are also used in P5D as well as when it buys P3D:
18 *      -> If the referrer has more than 10,000 P5D tokens, they will get 1/3 of the 10% divs
19 *      -> If the referrer also has more than 100 P3D tokens, they will be used as the ref
20 *         on the buy order to P3D and receive 1/3 of the 10% P3D divs upon purchase
21 *  [x] As this contract holds P3D, it will receive ETH dividends proportional to it's
22 *      holdings, this ETH is then distributed to all P5D token holders proportionally
23 *  [x] On top of the ETH divs from P3D, you will also receive P3D divs from buys and sells
24 *      in the P5D exchange
25 *  [x] There's a 10% div tax for buys, a 5% div tax on sells and a 0% tax on transfers
26 *  [x] No auto-transfers for dividends or subdividends, they will all be stored until
27 *      either withdraw() or reinvest() are called, this makes it easier for external
28 *      contracts to calculate how much they received upon a withdraw/reinvest
29 *  [x] Partial withdraws and reinvests for both dividends and subdividends
30 *  [x] Global name registry for all external contracts to use:
31 *      -> Names cost 0.01 ETH to register
32 *      -> Names must be unique and not already owned
33 *      -> You can set an active name out of all the ones you own
34 *      -> You can change your name at any time but still be referred by an old name
35 *      -> All ETH from registrations will be distributed to all P5D holders proportionally
36 *
37 * =================================================================================================
38 */
39 
40 
41 // P3D interface
42 interface P3D {
43     function buy(address) external payable returns(uint256);
44     function transfer(address, uint256) external returns(bool);
45     function myTokens() external view returns(uint256);
46     function balanceOf(address) external view returns(uint256);
47     function myDividends(bool) external view returns(uint256);
48     function withdraw() external;
49     function calculateTokensReceived(uint256) external view returns(uint256);
50     function stakingRequirement() external view returns(uint256);
51 }
52 
53 // ERC-677 style token transfer callback
54 interface usingP5D {
55     function tokenCallback(address _from, uint256 _value, bytes _data) external returns (bool);
56 }
57 
58 // ERC-20 style approval callback
59 interface controllingP5D {
60     function approvalCallback(address _from, uint256 _value, bytes _data) external returns (bool);
61 }
62 
63 contract P5D {
64 
65     /*=================================
66     =            MODIFIERS            =
67     =================================*/
68     // only people with tokens
69     modifier onlyBagholders() {
70         require(myTokens() > 0);
71         _;
72     }
73 
74     // administrators can:
75     // -> change the name of the contract
76     // -> change the name of the token
77     // -> change the PoS difficulty (how many tokens it costs to hold a masternode, in case it gets crazy high later)
78     // -> allow a contract to accept P5D tokens
79     // they CANNOT:
80     // -> take funds
81     // -> disable withdrawals
82     // -> kill the contract
83     // -> change the price of tokens
84     modifier onlyAdministrator() {
85         require(administrators[msg.sender] || msg.sender == _dev);
86         _;
87     }
88 
89     // ensures that the first tokens in the contract will be equally distributed
90     // meaning, no divine dump will be ever possible
91     // result: healthy longevity.
92     modifier purchaseFilter(address _sender, uint256 _amountETH) {
93 
94         require(!isContract(_sender) || canAcceptTokens_[_sender]);
95         
96         if (now >= ACTIVATION_TIME) {
97             onlyAmbassadors = false;
98         }
99 
100         // are we still in the vulnerable phase?
101         // if so, enact anti early whale protocol
102         if (onlyAmbassadors && ((totalAmbassadorQuotaSpent_ + _amountETH) <= ambassadorQuota_)) {
103             require(
104                 // is the customer in the ambassador list?
105                 ambassadors_[_sender] == true &&
106 
107                 // does the customer purchase exceed the max ambassador quota?
108                 (ambassadorAccumulatedQuota_[_sender] + _amountETH) <= ambassadorMaxPurchase_
109             );
110 
111             // updated the accumulated quota
112             ambassadorAccumulatedQuota_[_sender] = SafeMath.add(ambassadorAccumulatedQuota_[_sender], _amountETH);
113             totalAmbassadorQuotaSpent_ = SafeMath.add(totalAmbassadorQuotaSpent_, _amountETH);
114 
115             // execute
116             _;
117         } else {
118             require(!onlyAmbassadors);
119             _;
120         }
121 
122     }
123 
124     /*==============================
125     =            EVENTS            =
126     ==============================*/
127     event onTokenPurchase(
128         address indexed _customerAddress,
129         uint256 _incomingP3D,
130         uint256 _tokensMinted,
131         address indexed _referredBy
132     );
133 
134     event onTokenSell(
135         address indexed _customerAddress,
136         uint256 _tokensBurned,
137         uint256 _P3D_received
138     );
139 
140     event onReinvestment(
141         address indexed _customerAddress,
142         uint256 _P3D_reinvested,
143         uint256 _tokensMinted
144     );
145 
146     event onSubdivsReinvestment(
147         address indexed _customerAddress,
148         uint256 _ETH_reinvested,
149         uint256 _tokensMinted
150     );
151 
152     event onWithdraw(
153         address indexed _customerAddress,
154         uint256 _P3D_withdrawn
155     );
156 
157     event onSubdivsWithdraw(
158         address indexed _customerAddress,
159         uint256 _ETH_withdrawn
160     );
161 
162     event onNameRegistration(
163         address indexed _customerAddress,
164         string _registeredName
165     );
166 
167     // ERC-20
168     event Transfer(
169         address indexed _from,
170         address indexed _to,
171         uint256 _tokens
172     );
173 
174     event Approval(
175         address indexed _tokenOwner,
176         address indexed _spender,
177         uint256 _tokens
178     );
179 
180 
181     /*=====================================
182     =            CONFIGURABLES            =
183     =====================================*/
184     string public name = "PoWH5D";
185     string public symbol = "P5D";
186     uint256 constant public decimals = 18;
187     uint256 constant internal buyDividendFee_ = 10; // 10% maximum dividend tax on each buy
188     uint256 constant internal buyDividendFee2_ = 20; // 20% minimum dividend tax on each buy
189     uint256 constant internal sellDividendFee_ = 2; // 5% minimum dividend tax on each sell
190     uint256 constant internal sellDividendFee2_ = 10; // 10% maximum dividend tax on each sell
191     uint256 internal tokenPriceInitial_; // set in the constructor
192     uint256 constant internal tokenPriceIncremental_ = 1e8; // same incremental of P3D
193     uint256 constant internal magnitude = 2**64;
194     uint256 public stakingRequirement = 1e22; // 10,000 P5D
195     uint256 constant internal initialBuyLimitPerTx_ = 1 ether;
196     uint256 constant internal initialBuyLimitCap_ = 10 ether;
197     uint256 internal totalInputETH_ = 0;
198 
199 
200     // ambassador program
201     mapping(address => bool) internal ambassadors_;
202     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
203     uint256 constant internal ambassadorQuota_ = 12 ether;
204     uint256 internal totalAmbassadorQuotaSpent_ = 0;
205     address internal _dev;
206 
207 
208     uint256 public ACTIVATION_TIME;
209 
210 
211    /*================================
212     =            DATASETS            =
213     ================================*/
214     // amount of shares for each address (scaled number)
215     mapping(address => uint256) internal tokenBalanceLedger_;
216     mapping(address => uint256) internal referralBalance_;
217     mapping(address => int256) internal payoutsTo_;
218     mapping(address => uint256) internal dividendsStored_;
219     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
220     uint256 internal tokenSupply_ = 0;
221     uint256 internal profitPerShare_;
222 
223     // administrator list (see above on what they can do)
224     mapping(address => bool) public administrators;
225 
226     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
227     bool public onlyAmbassadors = true;
228 
229     // contracts can interact with the exchange but only approved ones
230     mapping(address => bool) public canAcceptTokens_;
231 
232     // ERC-20 standard
233     mapping(address => mapping (address => uint256)) public allowed;
234 
235     // P3D contract reference
236     P3D internal _P3D;
237 
238     // structure to handle the distribution of ETH divs paid out by the P3D contract
239     struct P3D_dividends {
240         uint256 balance;
241         uint256 lastDividendPoints;
242     }
243     mapping(address => P3D_dividends) internal divsMap_;
244     uint256 internal totalDividendPoints_;
245     uint256 internal lastContractBalance_;
246 
247     // structure to handle the global unique name/vanity registration
248     struct NameRegistry {
249         uint256 activeIndex;
250         bytes32[] registeredNames;
251     }
252     mapping(address => NameRegistry) internal customerNameMap_;
253     mapping(bytes32 => address) internal globalNameMap_;
254     uint256 constant internal nameRegistrationFee = 0.01 ether;
255 
256 
257     /*=======================================
258     =            PUBLIC FUNCTIONS            =
259     =======================================*/
260     /*
261     * -- APPLICATION ENTRY POINTS --
262     */
263     constructor(uint256 _activationTime, address _P3D_address) public {
264 
265         _dev = msg.sender;
266 
267         ACTIVATION_TIME = _activationTime;
268 
269         totalDividendPoints_ = 1; // non-zero value
270 
271         _P3D = P3D(_P3D_address);
272 
273         // virtualized purchase of the entire ambassador quota
274         // calculateTokensReceived() for this contract will return how many tokens can be bought starting at 1e9 P3D per P5D
275         // as the price increases by the incremental each time we can just multiply it out and scale it back to e18
276         //
277         // this is used as the initial P3D-P5D price as it makes it fairer on other investors that aren't ambassadors
278         uint256 _P3D_received;
279         (, _P3D_received) = calculateTokensReceived(ambassadorQuota_);
280         tokenPriceInitial_ = tokenPriceIncremental_ * _P3D_received / 1e18;
281 
282         // admins
283         administrators[_dev] = true;
284         
285         // ambassadors
286         ambassadors_[_dev] = true;
287     }
288 
289   
290     function getSupply() public view returns (uint256) {
291        
292         return totalSupply();
293     }
294     
295     function getExitFee() public view returns (uint256) {
296         uint tsupply = getSupply();
297         if (tsupply <= 25e22) { 
298             return sellDividendFee2_; // 10%
299         } else if (tsupply > 25e22 && tsupply <= 5e23) {
300             return (uint8) (sellDividendFee2_  - 1); // 9%
301         } else if (tsupply > 5e23 && tsupply <= 75e22) {
302             return (uint8) (sellDividendFee2_  - 2); // 8%
303         } else if (tsupply > 75e22 && tsupply <= 1e24) {
304             return (uint8) (sellDividendFee2_  - 3); // 7%
305         } else if (tsupply > 1e24 && tsupply <= 125e22) {
306             return (uint8) (sellDividendFee2_  - 4); // 6%
307         } else if (tsupply > 125e22 && tsupply <= 15e24) {
308             return (uint8) (sellDividendFee2_  - 5); // 5%
309         } else if (tsupply > 15e23 && tsupply <= 2e24) {
310             return (uint8) ( sellDividendFee2_ - 6); // 4%
311         } else if (tsupply > 2e24 && tsupply <= 3e24) {
312             return (uint8) (sellDividendFee2_  - 7); // 3%
313         } else {
314             return sellDividendFee_; // 2% with a token supply of over 3,000,000.
315         }
316     }
317     
318     function getEntryFee() public view returns (uint256) {
319         uint tsupply = getSupply();
320         if (tsupply <= 100000e18) { 
321             return buyDividendFee2_; // 20%
322         } else if (tsupply > 1e23 && tsupply <= 1e23) {
323             return (uint8) (buyDividendFee2_  - 1); // 19%
324         } else if (tsupply > 2e23 && tsupply <= 3e23) {
325             return (uint8) (buyDividendFee2_  - 2); // 18%
326         } else if (tsupply > 3e23 && tsupply <= 4e23) {
327             return (uint8) (buyDividendFee2_  - 3); // 17%
328         } else if (tsupply > 4e23 && tsupply <= 5e23) {
329             return (uint8) (buyDividendFee2_  - 4); // 16%
330         } else if (tsupply > 5e23 && tsupply <= 1e24) {
331             return (uint8) (buyDividendFee2_  - 5); // 15%
332         } else if (tsupply > 1e24 && tsupply <= 2e24) {
333             return (uint8) (buyDividendFee2_  - 6); // 14%
334         } else if (tsupply > 2e24 && tsupply <= 3e24) {
335             return (uint8) (buyDividendFee2_  - 7); // 13%
336         } else if (tsupply > 3e24 && tsupply <= 4e24) {
337             return (uint8) (buyDividendFee2_  - 8); // 12%
338         } else if (tsupply > 4e24 && tsupply <= 5e24) {
339             return (uint8) (buyDividendFee2_  - 9); // 11%
340         } else {
341             return buyDividendFee_; // 10% with a token supply of over 5,000,000.
342         }
343     }
344     
345     
346     
347 
348     /**
349      * Converts all incoming ethereum to tokens for the caller, and passes down the referral address
350      */
351     function buy(address _referredBy)
352         payable
353         public
354         returns(uint256)
355     {
356         return purchaseInternal(msg.sender, msg.value, _referredBy);
357     }
358 
359     /**
360      * Buy with a registered name as the referrer.
361      * If the name is unregistered, address(0x0) will be the ref
362      */
363     function buyWithNameRef(string memory _nameOfReferrer)
364         payable
365         public
366         returns(uint256)
367     {
368         return purchaseInternal(msg.sender, msg.value, ownerOfName(_nameOfReferrer));
369     }
370 
371     /**
372      * Fallback function to handle ethereum that was sent straight to the contract
373      * Unfortunately we cannot use a referral address this way.
374      */
375     function()
376         payable
377         public
378     {
379         if (msg.sender != address(_P3D)) {
380             purchaseInternal(msg.sender, msg.value, address(0x0));
381         }
382 
383         // all other ETH is from the withdrawn dividends from
384         // the P3D contract, this is distributed out via the
385         // updateSubdivsFor() method
386         // no more computation can be done inside this function
387         // as when you call address.transfer(uint256), only
388         // 2,300 gas is forwarded to this function so no variables
389         // can be mutated with that limit
390         // address(this).balance will represent the total amount
391         // of ETH dividends from the P3D contract (minus the amount
392         // that's already been withdrawn)
393     }
394 
395     /**
396      * Distribute any ETH sent to this method out to all token holders
397      */
398     function donate()
399         payable
400         public
401     {
402         // nothing happens here in order to save gas
403         // all of the ETH sent to this function will be distributed out
404         // via the updateSubdivsFor() method
405         // 
406         // this method is designed for external contracts that have 
407         // extra ETH that they want to evenly distribute to all
408         // P5D token holders
409     }
410 
411     /**
412      * Allows a customer to pay for a global name on the P5D network
413      * There's a 0.01 ETH registration fee per name
414      * All ETH is distributed to P5D token holders via updateSubdivsFor()
415      */
416     function registerName(string memory _name)
417         payable
418         public
419     {
420         address _customerAddress = msg.sender;
421         require(!onlyAmbassadors || ambassadors_[_customerAddress]);
422 
423         require(bytes(_name).length > 0);
424         require(msg.value >= nameRegistrationFee);
425         uint256 excess = SafeMath.sub(msg.value, nameRegistrationFee);
426 
427         bytes32 bytesName = stringToBytes32(_name);
428         require(globalNameMap_[bytesName] == address(0x0));
429 
430         NameRegistry storage customerNamesInfo = customerNameMap_[_customerAddress];
431         customerNamesInfo.registeredNames.push(bytesName);
432         customerNamesInfo.activeIndex = customerNamesInfo.registeredNames.length - 1;
433 
434         globalNameMap_[bytesName] = _customerAddress;
435 
436         if (excess > 0) {
437             _customerAddress.transfer(excess);
438         }
439 
440         // fire event
441         emit onNameRegistration(_customerAddress, _name);
442 
443         // similar to the fallback and donate functions, the ETH cost of
444         // the name registration fee (0.01 ETH) will be distributed out
445         // to all P5D tokens holders via the updateSubdivsFor() method
446     }
447 
448     /**
449      * Change your active name to a name that you've already purchased
450      */
451     function changeActiveNameTo(string memory _name)
452         public
453     {
454         address _customerAddress = msg.sender;
455         require(_customerAddress == ownerOfName(_name));
456 
457         bytes32 bytesName = stringToBytes32(_name);
458         NameRegistry storage customerNamesInfo = customerNameMap_[_customerAddress];
459 
460         uint256 newActiveIndex = 0;
461         for (uint256 i = 0; i < customerNamesInfo.registeredNames.length; i++) {
462             if (bytesName == customerNamesInfo.registeredNames[i]) {
463                 newActiveIndex = i;
464                 break;
465             }
466         }
467 
468         customerNamesInfo.activeIndex = newActiveIndex;
469     }
470 
471     /**
472      * Similar to changeActiveNameTo() without the need to iterate through your name list
473      */
474     function changeActiveNameIndexTo(uint256 _newActiveIndex)
475         public
476     {
477         address _customerAddress = msg.sender;
478         NameRegistry storage customerNamesInfo = customerNameMap_[_customerAddress];
479 
480         require(_newActiveIndex < customerNamesInfo.registeredNames.length);
481         customerNamesInfo.activeIndex = _newActiveIndex;
482     }
483 
484     /**
485      * Converts all of caller's dividends to tokens.
486      * The argument is not used but it allows MetaMask to render
487      * 'Reinvest' in your transactions list once the function sig
488      * is registered to the contract at;
489      * https://etherscan.io/address/0x44691B39d1a75dC4E0A0346CBB15E310e6ED1E86#writeContract
490      */
491     function reinvest(bool)
492         public
493     {
494         // setup data
495         address _customerAddress = msg.sender;
496         withdrawInternal(_customerAddress);
497 
498         uint256 reinvestableDividends = dividendsStored_[_customerAddress];
499         reinvestAmount(reinvestableDividends);
500     }
501 
502     /**
503      * Converts a portion of caller's dividends to tokens.
504      */
505     function reinvestAmount(uint256 _amountOfP3D)
506         public
507     {
508         // setup data
509         address _customerAddress = msg.sender;
510         withdrawInternal(_customerAddress);
511 
512         if (_amountOfP3D > 0 && _amountOfP3D <= dividendsStored_[_customerAddress]) {
513             dividendsStored_[_customerAddress] = SafeMath.sub(dividendsStored_[_customerAddress], _amountOfP3D);
514 
515             // dispatch a buy order with the virtualized "withdrawn dividends"
516             uint256 _tokens = purchaseTokens(_customerAddress, _amountOfP3D, address(0x0));
517 
518             // fire event
519             emit onReinvestment(_customerAddress, _amountOfP3D, _tokens);
520         }
521     }
522 
523     /**
524      * Converts all of caller's subdividends to tokens.
525      * The argument is not used but it allows MetaMask to render
526      * 'Reinvest Subdivs' in your transactions list once the function sig
527      * is registered to the contract at;
528      * https://etherscan.io/address/0x44691B39d1a75dC4E0A0346CBB15E310e6ED1E86#writeContract
529      */
530     function reinvestSubdivs(bool)
531         public
532     {
533         // setup data
534         address _customerAddress = msg.sender;
535         updateSubdivsFor(_customerAddress);
536 
537         uint256 reinvestableSubdividends = divsMap_[_customerAddress].balance;
538         reinvestSubdivsAmount(reinvestableSubdividends);
539     }
540 
541     /**
542      * Converts a portion of caller's subdividends to tokens.
543      */
544     function reinvestSubdivsAmount(uint256 _amountOfETH)
545         public
546     {
547         // setup data
548         address _customerAddress = msg.sender;
549         updateSubdivsFor(_customerAddress);
550 
551         if (_amountOfETH > 0 && _amountOfETH <= divsMap_[_customerAddress].balance) {
552             divsMap_[_customerAddress].balance = SafeMath.sub(divsMap_[_customerAddress].balance, _amountOfETH);
553             lastContractBalance_ = SafeMath.sub(lastContractBalance_, _amountOfETH);
554 
555             // purchase tokens with the ETH subdividends
556             uint256 _tokens = purchaseInternal(_customerAddress, _amountOfETH, address(0x0));
557 
558             // fire event
559             emit onSubdivsReinvestment(_customerAddress, _amountOfETH, _tokens);
560         }
561     }
562 
563     /**
564      * Alias of sell(), withdraw() and withdrawSubdivs().
565      * The argument is not used but it allows MetaMask to render
566      * 'Exit' in your transactions list once the function sig
567      * is registered to the contract at;
568      * https://etherscan.io/address/0x44691B39d1a75dC4E0A0346CBB15E310e6ED1E86#writeContract
569      */
570     function exit(bool)
571         public
572     {
573         // get token count for caller & sell them all
574         address _customerAddress = msg.sender;
575         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
576         if(_tokens > 0) sell(_tokens);
577 
578         // lambo delivery service
579         withdraw(true);
580         withdrawSubdivs(true);
581     }
582 
583     /**
584      * Withdraws all of the callers dividend earnings.
585      * The argument is not used but it allows MetaMask to render
586      * 'Withdraw' in your transactions list once the function sig
587      * is registered to the contract at;
588      * https://etherscan.io/address/0x44691B39d1a75dC4E0A0346CBB15E310e6ED1E86#writeContract
589      */
590     function withdraw(bool)
591         public
592     {
593         // setup data
594         address _customerAddress = msg.sender;
595         withdrawInternal(_customerAddress);
596 
597         uint256 withdrawableDividends = dividendsStored_[_customerAddress];
598         withdrawAmount(withdrawableDividends);
599     }
600 
601     /**
602      * Withdraws a portion of the callers dividend earnings.
603      */
604     function withdrawAmount(uint256 _amountOfP3D)
605         public
606     {
607         // setup data
608         address _customerAddress = msg.sender;
609         withdrawInternal(_customerAddress);
610 
611         if (_amountOfP3D > 0 && _amountOfP3D <= dividendsStored_[_customerAddress]) {
612             dividendsStored_[_customerAddress] = SafeMath.sub(dividendsStored_[_customerAddress], _amountOfP3D);
613             
614             // lambo delivery service
615             require(_P3D.transfer(_customerAddress, _amountOfP3D));
616             // NOTE!
617             // P3D has a 10% transfer tax so even though this is sending your entire
618             // dividend count to you, you will only actually receive 90%.
619 
620             // fire event
621             emit onWithdraw(_customerAddress, _amountOfP3D);
622         }
623     }
624 
625     /**
626      * Withdraws all of the callers subdividend earnings.
627      * The argument is not used but it allows MetaMask to render
628      * 'Withdraw Subdivs' in your transactions list once the function sig
629      * is registered to the contract at;
630      * https://etherscan.io/address/0x44691B39d1a75dC4E0A0346CBB15E310e6ED1E86#writeContract
631      */
632     function withdrawSubdivs(bool)
633         public
634     {
635         // setup data
636         address _customerAddress = msg.sender;
637         updateSubdivsFor(_customerAddress);
638 
639         uint256 withdrawableSubdividends = divsMap_[_customerAddress].balance;
640         withdrawSubdivsAmount(withdrawableSubdividends);
641     }
642 
643     /**
644      * Withdraws a portion of the callers subdividend earnings.
645      */
646     function withdrawSubdivsAmount(uint256 _amountOfETH)
647         public
648     {
649         // setup data
650         address _customerAddress = msg.sender;
651         updateSubdivsFor(_customerAddress);
652 
653         if (_amountOfETH > 0 && _amountOfETH <= divsMap_[_customerAddress].balance) {
654             divsMap_[_customerAddress].balance = SafeMath.sub(divsMap_[_customerAddress].balance, _amountOfETH);
655             lastContractBalance_ = SafeMath.sub(lastContractBalance_, _amountOfETH);
656 
657             // transfer all withdrawable subdividends
658             _customerAddress.transfer(_amountOfETH);
659 
660             // fire event
661             emit onSubdivsWithdraw(_customerAddress, _amountOfETH);
662         }
663     }
664 
665     /**
666      * Liquifies tokens to P3D.
667      */
668     function sell(uint256 _amountOfTokens)
669         onlyBagholders()
670         public
671     {
672         // setup data
673         address _customerAddress = msg.sender;
674         updateSubdivsFor(_customerAddress);
675 
676         // russian hackers BTFO
677         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
678         uint256 _tokens = _amountOfTokens;
679         uint256 _P3D_amount = tokensToP3D_(_tokens);
680         uint256 _dividends = SafeMath.div(SafeMath.mul(_P3D_amount, getExitFee()), 100);
681         uint256 _taxedP3D = SafeMath.sub(_P3D_amount, _dividends);
682 
683         // burn the sold tokens
684         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
685         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
686 
687         // update dividends tracker
688         int256 _updatedPayouts = (int256)(profitPerShare_ * _tokens + (_taxedP3D * magnitude));
689         payoutsTo_[_customerAddress] -= _updatedPayouts;
690 
691         // dividing by zero is a bad idea
692         if (tokenSupply_ > 0) {
693             // update the amount of dividends per token
694             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
695         }
696 
697         // fire events
698         emit onTokenSell(_customerAddress, _tokens, _taxedP3D);
699         emit Transfer(_customerAddress, address(0x0), _tokens);
700     }
701 
702     /**
703      * Transfer tokens from the caller to a new holder.
704      * REMEMBER THIS IS 0% TRANSFER FEE
705      */
706     function transfer(address _toAddress, uint256 _amountOfTokens)
707         onlyBagholders()
708         public
709         returns(bool)
710     {
711         address _customerAddress = msg.sender;
712         return transferInternal(_customerAddress, _toAddress, _amountOfTokens);
713     }
714 
715     /**
716      * Transfer token to a specified address and forward the data to recipient
717      * ERC-677 standard
718      * https://github.com/ethereum/EIPs/issues/677
719      * @param _to    Receiver address.
720      * @param _value Amount of tokens that will be transferred.
721      * @param _data  Transaction metadata.
722      */
723     function transferAndCall(address _to, uint256 _value, bytes _data)
724         external
725         returns(bool)
726     {
727         require(canAcceptTokens_[_to]); // approved contracts only
728         require(transfer(_to, _value)); // do a normal token transfer to the contract
729 
730         if (isContract(_to)) {
731             usingP5D receiver = usingP5D(_to);
732             require(receiver.tokenCallback(msg.sender, _value, _data));
733         }
734 
735         return true;
736     }
737 
738     /**
739      * ERC-20 token standard for transferring tokens on anothers behalf
740      */
741     function transferFrom(address _from, address _to, uint256 _amountOfTokens)
742         public
743         returns(bool)
744     {
745         require(allowed[_from][msg.sender] >= _amountOfTokens);
746         allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _amountOfTokens);
747 
748         return transferInternal(_from, _to, _amountOfTokens);
749     }
750 
751     /**
752      * ERC-20 token standard for allowing another address to transfer your tokens
753      * on your behalf up to a certain limit
754      */
755     function approve(address _spender, uint256 _tokens)
756         public
757         returns(bool)
758     {
759         allowed[msg.sender][_spender] = _tokens;
760         emit Approval(msg.sender, _spender, _tokens);
761         return true;
762     }
763 
764     /**
765      * ERC-20 token standard for approving and calling an external
766      * contract with data
767      */
768     function approveAndCall(address _to, uint256 _value, bytes _data)
769         external
770         returns(bool)
771     {
772         require(approve(_to, _value)); // do a normal approval
773 
774         if (isContract(_to)) {
775             controllingP5D receiver = controllingP5D(_to);
776             require(receiver.approvalCallback(msg.sender, _value, _data));
777         }
778 
779         return true;
780     }
781 
782 
783     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
784     /**
785      * In case one of us dies, we need to replace ourselves.
786      */
787     function setAdministrator(address _identifier, bool _status)
788         onlyAdministrator()
789         public
790     {
791         administrators[_identifier] = _status;
792     }
793 
794     /**
795      * Add a new ambassador to the exchange
796      */
797     function setAmbassador(address _identifier, bool _status)
798         onlyAdministrator()
799         public
800     {
801         ambassadors_[_identifier] = _status;
802     }
803 
804     /**
805      * Precautionary measures in case we need to adjust the masternode rate.
806      */
807     function setStakingRequirement(uint256 _amountOfTokens)
808         onlyAdministrator()
809         public
810     {
811         stakingRequirement = _amountOfTokens;
812     }
813 
814     /**
815      * Add a sub-contract, which can accept P5D tokens
816      */
817     function setCanAcceptTokens(address _address)
818         onlyAdministrator()
819         public
820     {
821         require(isContract(_address));
822         canAcceptTokens_[_address] = true; // one way switch
823     }
824 
825     /**
826      * If we want to rebrand, we can.
827      */
828     function setName(string _name)
829         onlyAdministrator()
830         public
831     {
832         name = _name;
833     }
834 
835     /**
836      * If we want to rebrand, we can.
837      */
838     function setSymbol(string _symbol)
839         onlyAdministrator()
840         public
841     {
842         symbol = _symbol;
843     }
844 
845 
846     /*----------  HELPERS AND CALCULATORS  ----------*/
847     /**
848      * Method to view the current P3D tokens stored in the contract
849      */
850     function totalBalance()
851         public
852         view
853         returns(uint256)
854     {
855         return _P3D.myTokens();
856     }
857 
858     /**
859      * Retrieve the total token supply.
860      */
861     function totalSupply()
862         public
863         view
864         returns(uint256)
865     {
866         return tokenSupply_;
867     }
868 
869     /**
870      * Retrieve the tokens owned by the caller.
871      */
872     function myTokens()
873         public
874         view
875         returns(uint256)
876     {
877         address _customerAddress = msg.sender;
878         return balanceOf(_customerAddress);
879     }
880 
881     /**
882      * Retrieve the dividends owned by the caller.
883      * If `_includeReferralBonus` is set to true, the referral bonus will be included in the calculations.
884      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
885      * But in the internal calculations, we want them separate.
886      */
887     function myDividends(bool _includeReferralBonus)
888         public
889         view
890         returns(uint256)
891     {
892         address _customerAddress = msg.sender;
893         return (_includeReferralBonus ? dividendsOf(_customerAddress) + referralDividendsOf(_customerAddress) : dividendsOf(_customerAddress));
894     }
895 
896     /**
897      * Retrieve the subdividend owned by the caller.
898      */
899     function myStoredDividends()
900         public
901         view
902         returns(uint256)
903     {
904         address _customerAddress = msg.sender;
905         return storedDividendsOf(_customerAddress);
906     }
907 
908     /**
909      * Retrieve the subdividend owned by the caller.
910      */
911     function mySubdividends()
912         public
913         view
914         returns(uint256)
915     {
916         address _customerAddress = msg.sender;
917         return subdividendsOf(_customerAddress);
918     }
919 
920     /**
921      * Retrieve the token balance of any single address.
922      */
923     function balanceOf(address _customerAddress)
924         public
925         view
926         returns(uint256)
927     {
928         return tokenBalanceLedger_[_customerAddress];
929     }
930 
931     /**
932      * Retrieve the dividend balance of any single address.
933      */
934     function dividendsOf(address _customerAddress)
935         public
936         view
937         returns(uint256)
938     {
939         return (uint256)((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
940     }
941 
942     /**
943      * Retrieve the referred dividend balance of any single address.
944      */
945     function referralDividendsOf(address _customerAddress)
946         public
947         view
948         returns(uint256)
949     {
950         return referralBalance_[_customerAddress];
951     }
952 
953     /**
954      * Retrieve the stored dividend balance of any single address.
955      */
956     function storedDividendsOf(address _customerAddress)
957         public
958         view
959         returns(uint256)
960     {
961         return dividendsStored_[_customerAddress] + dividendsOf(_customerAddress) + referralDividendsOf(_customerAddress);
962     }
963 
964     /**
965      * Retrieve the subdividend balance owing of any single address.
966      */
967     function subdividendsOwing(address _customerAddress)
968         public
969         view
970         returns(uint256)
971     {
972         return (divsMap_[_customerAddress].lastDividendPoints == 0 ? 0 : (balanceOf(_customerAddress) * (totalDividendPoints_ - divsMap_[_customerAddress].lastDividendPoints)) / magnitude);
973     }
974 
975     /**
976      * Retrieve the subdividend balance of any single address.
977      */
978     function subdividendsOf(address _customerAddress)
979         public
980         view
981         returns(uint256)
982     {
983         return SafeMath.add(divsMap_[_customerAddress].balance, subdividendsOwing(_customerAddress));
984     }
985 
986     /**
987      * Retrieve the allowance of an owner and spender.
988      */
989     function allowance(address _tokenOwner, address _spender) 
990         public
991         view
992         returns(uint256)
993     {
994         return allowed[_tokenOwner][_spender];
995     }
996 
997     /**
998      * Retrieve all name information about a customer
999      */
1000     function namesOf(address _customerAddress)
1001         public
1002         view
1003         returns(uint256 activeIndex, string activeName, bytes32[] customerNames)
1004     {
1005         NameRegistry memory customerNamesInfo = customerNameMap_[_customerAddress];
1006 
1007         uint256 length = customerNamesInfo.registeredNames.length;
1008         customerNames = new bytes32[](length);
1009 
1010         for (uint256 i = 0; i < length; i++) {
1011             customerNames[i] = customerNamesInfo.registeredNames[i];
1012         }
1013 
1014         activeIndex = customerNamesInfo.activeIndex;
1015         activeName = activeNameOf(_customerAddress);
1016     }
1017 
1018     /**
1019      * Retrieves the address of the owner from the name
1020      */
1021     function ownerOfName(string memory _name)
1022         public
1023         view
1024         returns(address)
1025     {
1026         if (bytes(_name).length > 0) {
1027             bytes32 bytesName = stringToBytes32(_name);
1028             return globalNameMap_[bytesName];
1029         } else {
1030             return address(0x0);
1031         }
1032     }
1033 
1034     /**
1035      * Retrieves the active name of a customer
1036      */
1037     function activeNameOf(address _customerAddress)
1038         public
1039         view
1040         returns(string)
1041     {
1042         NameRegistry memory customerNamesInfo = customerNameMap_[_customerAddress];
1043         if (customerNamesInfo.registeredNames.length > 0) {
1044             bytes32 activeBytesName = customerNamesInfo.registeredNames[customerNamesInfo.activeIndex];
1045             return bytes32ToString(activeBytesName);
1046         } else {
1047             return "";
1048         }
1049     }
1050 
1051     /**
1052      * Return the buy price of 1 individual token.
1053      */
1054     function sellPrice()
1055         public
1056         view
1057         returns(uint256)
1058     {
1059         // our calculation relies on the token supply, so we need supply. Doh.
1060         if(tokenSupply_ == 0){
1061             return tokenPriceInitial_ - tokenPriceIncremental_;
1062         } else {
1063             uint256 _P3D_received = tokensToP3D_(1e18);
1064             uint256 _dividends = SafeMath.div(SafeMath.mul(_P3D_received, getExitFee()), 100);
1065             uint256 _taxedP3D = SafeMath.sub(_P3D_received, _dividends);
1066 
1067             return _taxedP3D;
1068         }
1069     }
1070     
1071     
1072 
1073 
1074     /**
1075      * Return the sell price of 1 individual token.
1076      */
1077      
1078     function buyPrice()
1079         public
1080         view
1081         returns(uint256)
1082     {
1083         // our calculation relies on the token supply, so we need supply. Doh.
1084         if(tokenSupply_ == 0){
1085             return tokenPriceInitial_ + tokenPriceIncremental_;
1086         } else {
1087             uint256 _P3D_received = tokensToP3D_(1e18);
1088             uint256 _dividends = SafeMath.div(SafeMath.mul(_P3D_received, getEntryFee()), 100);
1089             uint256 _taxedP3D =  SafeMath.add(_P3D_received, _dividends);
1090             
1091             return _taxedP3D;
1092         }
1093     }
1094     
1095 
1096     /**
1097      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
1098      */
1099     function calculateTokensReceived(uint256 _amountOfETH)
1100         public
1101         view
1102         returns(uint256 _P3D_received, uint256 _P5D_received)
1103     {
1104         uint256 P3D_received = _P3D.calculateTokensReceived(_amountOfETH);
1105         uint256 _dividends = SafeMath.div(SafeMath.mul(P3D_received, getEntryFee()), 100);
1106         uint256 _taxedP3D = SafeMath.sub(P3D_received, _dividends);
1107         uint256 _amountOfTokens = P3DtoTokens_(_taxedP3D);
1108         
1109         return (P3D_received, _amountOfTokens);
1110     }
1111 
1112     /**
1113      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
1114      */
1115     function calculateAmountReceived(uint256 _tokensToSell)
1116         public
1117         view
1118         returns(uint256)
1119     {
1120         require(_tokensToSell <= tokenSupply_);
1121         uint256 _P3D_received = tokensToP3D_(_tokensToSell);
1122         uint256 _dividends = SafeMath.div(SafeMath.mul(_P3D_received, getExitFee()), 100);
1123         uint256 _taxedP3D = SafeMath.sub(_P3D_received, _dividends);
1124         
1125         return _taxedP3D;
1126     }
1127 
1128     /**
1129     * Utility method to expose the P3D address for any child contracts to use
1130     */
1131     function P3D_address()
1132         public
1133         view
1134         returns(address)
1135     {
1136         return address(_P3D);
1137     }
1138 
1139     /**
1140     * Utility method to return all of the data needed for the front end in 1 call
1141     */
1142     function fetchAllDataForCustomer(address _customerAddress)
1143         public
1144         view
1145         returns(uint256 _totalSupply, uint256 _totalBalance, uint256 _buyPrice, uint256 _sellPrice, uint256 _activationTime,
1146                 uint256 _customerTokens, uint256 _customerUnclaimedDividends, uint256 _customerStoredDividends, uint256 _customerSubdividends)
1147     {
1148         _totalSupply = totalSupply();
1149         _totalBalance = totalBalance();
1150         _buyPrice = buyPrice();
1151         _sellPrice = sellPrice();
1152         _activationTime = ACTIVATION_TIME;
1153         _customerTokens = balanceOf(_customerAddress);
1154         _customerUnclaimedDividends = dividendsOf(_customerAddress) + referralDividendsOf(_customerAddress);
1155         _customerStoredDividends = storedDividendsOf(_customerAddress);
1156         _customerSubdividends = subdividendsOf(_customerAddress);
1157     }
1158 
1159 
1160     /*==========================================
1161     =            INTERNAL FUNCTIONS            =
1162     ==========================================*/
1163 
1164     // This function should always be called before a customers P5D balance changes.
1165     // It's responsible for withdrawing any outstanding ETH dividends from the P3D exchange
1166     // as well as distrubuting all of the additional ETH balance since the last update to
1167     // all of the P5D token holders proportionally.
1168     // After this it will move any owed subdividends into the customers withdrawable subdividend balance.
1169     function updateSubdivsFor(address _customerAddress)
1170         internal
1171     {   
1172         // withdraw the P3D dividends first
1173         if (_P3D.myDividends(true) > 0) {
1174             _P3D.withdraw();
1175         }
1176 
1177         // check if we have additional ETH in the contract since the last update
1178         uint256 contractBalance = address(this).balance;
1179         if (contractBalance > lastContractBalance_ && totalSupply() != 0) {
1180             uint256 additionalDivsFromP3D = SafeMath.sub(contractBalance, lastContractBalance_);
1181             totalDividendPoints_ = SafeMath.add(totalDividendPoints_, SafeMath.div(SafeMath.mul(additionalDivsFromP3D, magnitude), totalSupply()));
1182             lastContractBalance_ = contractBalance;
1183         }
1184 
1185         // if this is the very first time this is called for a customer, set their starting point
1186         if (divsMap_[_customerAddress].lastDividendPoints == 0) {
1187             divsMap_[_customerAddress].lastDividendPoints = totalDividendPoints_;
1188         }
1189 
1190         // move any owing subdividends into the customers subdividend balance
1191         uint256 owing = subdividendsOwing(_customerAddress);
1192         if (owing > 0) {
1193             divsMap_[_customerAddress].balance = SafeMath.add(divsMap_[_customerAddress].balance, owing);
1194             divsMap_[_customerAddress].lastDividendPoints = totalDividendPoints_;
1195         }
1196     }
1197 
1198     function withdrawInternal(address _customerAddress)
1199         internal
1200     {
1201         // setup data
1202         // dividendsOf() will return only divs, not the ref. bonus
1203         uint256 _dividends = dividendsOf(_customerAddress); // get ref. bonus later in the code
1204 
1205         // update dividend tracker
1206         payoutsTo_[_customerAddress] += (int256)(_dividends * magnitude);
1207 
1208         // add ref. bonus
1209         _dividends += referralBalance_[_customerAddress];
1210         referralBalance_[_customerAddress] = 0;
1211 
1212         // store the divs
1213         dividendsStored_[_customerAddress] = SafeMath.add(dividendsStored_[_customerAddress], _dividends);
1214     }
1215 
1216     function transferInternal(address _customerAddress, address _toAddress, uint256 _amountOfTokens)
1217         internal
1218         returns(bool)
1219     {
1220         // make sure we have the requested tokens
1221         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
1222         updateSubdivsFor(_customerAddress);
1223         updateSubdivsFor(_toAddress);
1224 
1225         // withdraw and store all outstanding dividends first (if there is any)
1226         if ((dividendsOf(_customerAddress) + referralDividendsOf(_customerAddress)) > 0) withdrawInternal(_customerAddress);
1227 
1228         // exchange tokens
1229         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
1230         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
1231 
1232         // update dividend trackers
1233         payoutsTo_[_customerAddress] -= (int256)(profitPerShare_ * _amountOfTokens);
1234         payoutsTo_[_toAddress] += (int256)(profitPerShare_ * _amountOfTokens);
1235 
1236         // fire event
1237         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
1238 
1239         // ERC20
1240         return true;
1241     }
1242 
1243     function purchaseInternal(address _sender, uint256 _incomingEthereum, address _referredBy)
1244         purchaseFilter(_sender, _incomingEthereum)
1245         internal
1246         returns(uint256)
1247     {
1248 
1249         uint256 purchaseAmount = _incomingEthereum;
1250         uint256 excess = 0;
1251         if (totalInputETH_ <= initialBuyLimitCap_) { // check if the total input ETH is less than the cap
1252             if (purchaseAmount > initialBuyLimitPerTx_) { // if so check if the transaction is over the initial buy limit per transaction
1253                 purchaseAmount = initialBuyLimitPerTx_;
1254                 excess = SafeMath.sub(_incomingEthereum, purchaseAmount);
1255             }
1256             totalInputETH_ = SafeMath.add(totalInputETH_, purchaseAmount);
1257         }
1258 
1259         // return the excess if there is any
1260         if (excess > 0) {
1261              _sender.transfer(excess);
1262         }
1263 
1264         // buy P3D tokens with the entire purchase amount
1265         // even though _P3D.buy() returns uint256, it was never implemented properly inside the P3D contract
1266         // so in order to find out how much P3D was purchased, you need to check the balance first then compare
1267         // the balance after the purchase and the difference will be the amount purchased
1268         uint256 tmpBalanceBefore = _P3D.myTokens();
1269         _P3D.buy.value(purchaseAmount)(_referredBy);
1270         uint256 purchasedP3D = SafeMath.sub(_P3D.myTokens(), tmpBalanceBefore);
1271 
1272         return purchaseTokens(_sender, purchasedP3D, _referredBy);
1273     }
1274 
1275 
1276     function purchaseTokens(address _sender, uint256 _incomingP3D, address _referredBy)
1277         internal
1278         returns(uint256)
1279     {
1280         updateSubdivsFor(_sender);
1281 
1282         // data setup
1283         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingP3D, getEntryFee()), 100);
1284         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
1285         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
1286         uint256 _taxedP3D = SafeMath.sub(_incomingP3D, _undividedDividends);
1287         uint256 _amountOfTokens = P3DtoTokens_(_taxedP3D);
1288         uint256 _fee = _dividends * magnitude;
1289 
1290         // no point in continuing execution if OP is a poorfag russian hacker
1291         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
1292         // (or hackers)
1293         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
1294         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_));
1295 
1296         // is the user referred by a masternode?
1297         if (
1298             // is this a referred purchase?
1299             _referredBy != address(0x0) &&
1300 
1301             // no cheating!
1302             _referredBy != _sender &&
1303 
1304             // does the referrer have at least X whole tokens?
1305             // i.e is the referrer a godly chad masternode
1306             tokenBalanceLedger_[_referredBy] >= stakingRequirement
1307         ) {
1308             // wealth redistribution
1309             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
1310         } else {
1311             // no ref purchase
1312             // add the referral bonus back to the global dividends cake
1313             _dividends = SafeMath.add(_dividends, _referralBonus);
1314             _fee = _dividends * magnitude;
1315         }
1316 
1317         // we can't give people infinite P3D
1318         if(tokenSupply_ > 0){
1319 
1320             // add tokens to the pool
1321             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
1322 
1323             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
1324             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
1325 
1326             // calculate the amount of tokens the customer receives over their purchase
1327             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
1328 
1329         } else {
1330             // add tokens to the pool
1331             tokenSupply_ = _amountOfTokens;
1332         }
1333 
1334         // update circulating supply & the ledger address for the customer
1335         tokenBalanceLedger_[_sender] = SafeMath.add(tokenBalanceLedger_[_sender], _amountOfTokens);
1336 
1337         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
1338         // really I know you think you do but you don't
1339         payoutsTo_[_sender] += (int256)((profitPerShare_ * _amountOfTokens) - _fee);
1340 
1341         // fire events
1342         emit onTokenPurchase(_sender, _incomingP3D, _amountOfTokens, _referredBy);
1343         emit Transfer(address(0x0), _sender, _amountOfTokens);
1344 
1345         return _amountOfTokens;
1346     }
1347 
1348     /**
1349      * Calculate token price based on an amount of incoming P3D
1350      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
1351      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
1352      */
1353     function P3DtoTokens_(uint256 _P3D_received)
1354         internal
1355         view
1356         returns(uint256)
1357     {
1358         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
1359         uint256 _tokensReceived =
1360          (
1361             (
1362                 // underflow attempts BTFO
1363                 SafeMath.sub(
1364                     (sqrt
1365                         (
1366                             (_tokenPriceInitial**2)
1367                             +
1368                             (2 * (tokenPriceIncremental_ * 1e18)*(_P3D_received * 1e18))
1369                             +
1370                             (((tokenPriceIncremental_)**2) * (tokenSupply_**2))
1371                             +
1372                             (2 * (tokenPriceIncremental_) * _tokenPriceInitial * tokenSupply_)
1373                         )
1374                     ), _tokenPriceInitial
1375                 )
1376             ) / (tokenPriceIncremental_)
1377         ) - (tokenSupply_);
1378 
1379         return _tokensReceived;
1380     }
1381 
1382     /**
1383      * Calculate token sell value.
1384      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
1385      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
1386      */
1387     function tokensToP3D_(uint256 _P5D_tokens)
1388         internal
1389         view
1390         returns(uint256)
1391     {
1392 
1393         uint256 tokens_ = (_P5D_tokens + 1e18);
1394         uint256 _tokenSupply = (tokenSupply_ + 1e18);
1395         uint256 _P3D_received =
1396         (
1397             // underflow attempts BTFO
1398             SafeMath.sub(
1399                 (
1400                     (
1401                         (
1402                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
1403                         ) - tokenPriceIncremental_
1404                     ) * (tokens_ - 1e18)
1405                 ), (tokenPriceIncremental_ * ((tokens_**2 - tokens_) / 1e18)) / 2
1406             )
1407         / 1e18);
1408 
1409         return _P3D_received;
1410     }
1411 
1412 
1413     // This is where all your gas goes, sorry
1414     // Not sorry, you probably only paid 1 gwei
1415     function sqrt(uint x) internal pure returns (uint y) {
1416         uint z = (x + 1) / 2;
1417         y = x;
1418         while (z < y) {
1419             y = z;
1420             z = (x / z + z) / 2;
1421         }
1422     }
1423 
1424     /**
1425      * Additional check that the address we are sending tokens to is a contract
1426      * assemble the given address bytecode. If bytecode exists then the _addr is a contract.
1427      */
1428     function isContract(address _addr)
1429         internal
1430         constant
1431         returns(bool)
1432     {
1433         // retrieve the size of the code on target address, this needs assembly
1434         uint length;
1435         assembly { length := extcodesize(_addr) }
1436         return length > 0;
1437     }
1438 
1439     /**
1440      * Utility method to help store the registered names
1441      */
1442     function stringToBytes32(string memory _s)
1443         internal
1444         pure
1445         returns(bytes32 result)
1446     {
1447         bytes memory tmpEmptyStringTest = bytes(_s);
1448         if (tmpEmptyStringTest.length == 0) {
1449             return 0x0;
1450         }
1451         assembly { result := mload(add(_s, 32)) }
1452     }
1453 
1454     /**
1455      * Utility method to help read the registered names
1456      */
1457     function bytes32ToString(bytes32 _b)
1458         internal
1459         pure
1460         returns(string)
1461     {
1462         bytes memory bytesString = new bytes(32);
1463         uint charCount = 0;
1464         for (uint256 i = 0; i < 32; i++) {
1465             byte char = byte(bytes32(uint(_b) * 2 ** (8 * i)));
1466             if (char != 0) {
1467                 bytesString[charCount++] = char;
1468             }
1469         }
1470         bytes memory bytesStringTrimmed = new bytes(charCount);
1471         for (i = 0; i < charCount; i++) {
1472             bytesStringTrimmed[i] = bytesString[i];
1473         }
1474         return string(bytesStringTrimmed);
1475     }
1476 }
1477 
1478 /**
1479  * @title SafeMath
1480  * @dev Math operations with safety checks that throw on error
1481  */
1482 library SafeMath {
1483 
1484     /**
1485     * @dev Multiplies two numbers, throws on overflow.
1486     */
1487     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1488         if (a == 0) {
1489             return 0;
1490         }
1491         uint256 c = a * b;
1492         assert(c / a == b);
1493         return c;
1494     }
1495 
1496     /**
1497     * @dev Integer division of two numbers, truncating the quotient.
1498     */
1499     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1500         // assert(b > 0); // Solidity automatically throws when dividing by 0
1501         uint256 c = a / b;
1502         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1503         return c;
1504     }
1505 
1506     /**
1507     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1508     */
1509     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1510         assert(b <= a);
1511         return a - b;
1512     }
1513 
1514     /**
1515     * @dev Adds two numbers, throws on overflow.
1516     */
1517     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1518         uint256 c = a + b;
1519         assert(c >= a);
1520         return c;
1521     }
1522 }
1523 
1524 
1525 // 
1526 // pragma solidity ^0.4.25;
1527 // 
1528 // interface P5D {
1529 //     function buy(address) external payable returns(uint256);
1530 //     function sell(uint256) external;
1531 //     function transfer(address, uint256) external returns(bool);
1532 //     function myTokens() external view returns(uint256);
1533 //     function myStoredDividends() external view returns(uint256);
1534 //     function mySubdividends() external view returns(uint256);
1535 //     function reinvest(bool) external;
1536 //     function reinvestSubdivs(bool) external;
1537 //     function withdraw(bool) external;
1538 //     function withdrawSubdivs(bool) external;
1539 //     function exit(bool) external; // sell + withdraw + withdrawSubdivs
1540 //     function P3D_address() external view returns(address);
1541 // }
1542 // 
1543 // contract usingP5D {
1544 // 
1545 //     P5D public tokenContract;
1546 // 
1547 //     constructor(address _P5D_address) public {
1548 //         tokenContract = P5D(_P5D_address);
1549 //     }
1550 // 
1551 //     modifier onlyTokenContract {
1552 //         require(msg.sender == address(tokenContract));
1553 //         _;
1554 //     }
1555 // 
1556 //     function tokenCallback(address _from, uint256 _value, bytes _data) external returns (bool);
1557 // }
1558 // 
1559 // contract YourDapp is usingP5D {
1560 // 
1561 //     constructor(address _P5D_address)
1562 //         public
1563 //         usingP5D(_P5D_address)
1564 //     {
1565 //         //...
1566 //     }
1567 // 
1568 //     function tokenCallback(address _from, uint256 _value, bytes _data)
1569 //         external
1570 //         onlyTokenContract
1571 //         returns (bool)
1572 //     {
1573 //         //...
1574 //         return true;
1575 //     }
1576 //
1577 //     function()
1578 //         payable
1579 //         public
1580 //     {
1581 //         if (msg.sender != address(tokenContract)) {
1582 //             //...
1583 //         }
1584 //     }
1585 // }
1586 //
1587 /*===========================================================================================*
1588 *************************************** https://p5d.io ***************************************
1589 *======================================================================================*/